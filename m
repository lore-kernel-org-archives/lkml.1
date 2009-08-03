Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbZHCPOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbZHCPOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932308AbZHCPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:14:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42096 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbZHCPOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:14:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH update] PM: Introduce core framework for run-time PM of I/O devices (rev. 11)
Date: Mon, 3 Aug 2009 17:15:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200907221701.50449.rjw@sisk.pl> <200907312053.17914.rjw@sisk.pl> <aec7e5c30908022026t2fa8f328s27424073c9ff560b@mail.gmail.com>
In-Reply-To: <aec7e5c30908022026t2fa8f328s27424073c9ff560b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031715.19302.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Magnus Damm wrote:
> Hi again Rafael,

Hi,

> On Sat, Aug 1, 2009 at 3:53 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > On Friday 31 July 2009, Magnus Damm wrote:
> >> [Runtime PM v11]
> 
> >> > @@ -202,7 +203,9 @@ int driver_probe_device(struct device_dr
> >> >        pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
> >> >                 drv->bus->name, __func__, dev_name(dev), drv->name);
> >> >
> >> > +       pm_runtime_get_noresume(dev);
> >> >        ret = really_probe(dev, drv);
> >> > +       pm_runtime_put_noidle(dev);
> >> >
> >> >        return ret;
> >> >  }
> >>
> >> This creates problems when drivers want to performing runtime resume
> >> from within probe(). For more details please have a look at "[PATCH
> >> 04/04] video: Runtime PM hack for SuperH LCDC driver".
> >
> > Ah, I see.  You'd like to call pm_runtime_get_sync() from .probe(), but that
> > sees the usage counter different from zero and exits immediately.
> 
> Exactly.
> 
> > OTOH, I think we should prevent suspends from racing with .probe() at the core
> > level.  Hmm.
> 
> Doesn't it make more sense to allow runtime suspend and resume to
> happen after the pm_runtime_enable() call? What case are you trying to
> protect against?

If runtime PM is enabled before .probe() and then .probe() itself doesn't
use pm_runtime_get_*(), then theory it is possible to have ->runtime_suspend()
called while .probe() is running and there's no synchronization between the
two.  So, we prevent ->runtime_suspend() from being called while .proble()
is running with the help of the usage counter.

> > One possible approach could be to call pm_runtime_resume() from
> > sh_mobile_lcdc_probe() instead of pm_runtime_put_noidle().  Then, the platform
> > code will have a chance to turn the device on and the later pm_runtime_get*()
> > and pm_runtime_put*() calls will be balanced.  Of course, in that case the
> > pm_runtime_get_noresume() in sh_mobile_lcdc_probe() won't be necessary any
> > more.  Am I overlooking anything?
> 
> So for drivers that want to access hardware from .probe(), calling
> pm_runtime_resume() after pm_runtime_enable() in should be enough?

Yes, that should be sufficient (as long as the pm_runtime_resume() is
successful).

Best,
Rafael
