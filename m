Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZGaSxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZGaSxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZGaSxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:53:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZGaSxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:53:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH update] PM: Introduce core framework for run-time PM of I/O devices (rev. 11)
Date: Fri, 31 Jul 2009 20:53:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200907221701.50449.rjw@sisk.pl> <200907222110.47701.rjw@sisk.pl> <aec7e5c30907310732u35faa15fpab070025f596463e@mail.gmail.com>
In-Reply-To: <aec7e5c30907310732u35faa15fpab070025f596463e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907312053.17914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, Magnus Damm wrote:
> Hi Rafail

Hi,

> [Runtime PM v11]
> 
> Thanks for your work on this. The code is getting better and better.
> I've just finished posting a bunch of patches related to v11 of your
> Runtime PM patch. Basically everything seems fine except a few minor
> details and the code below: =)

Thanks a lot for your feedback.

> On Thu, Jul 23, 2009 at 4:10 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > On Wednesday 22 July 2009, Rafael J. Wysocki wrote:
> > Index: linux-2.6/drivers/base/dd.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/dd.c
> > +++ linux-2.6/drivers/base/dd.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/kthread.h>
> >  #include <linux/wait.h>
> >  #include <linux/async.h>
> > +#include <linux/pm_runtime.h>
> >
> >  #include "base.h"
> >  #include "power/power.h"
> > @@ -202,7 +203,9 @@ int driver_probe_device(struct device_dr
> >        pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
> >                 drv->bus->name, __func__, dev_name(dev), drv->name);
> >
> > +       pm_runtime_get_noresume(dev);
> >        ret = really_probe(dev, drv);
> > +       pm_runtime_put_noidle(dev);
> >
> >        return ret;
> >  }
> 
> This creates problems when drivers want to performing runtime resume
> from within probe(). For more details please have a look at "[PATCH
> 04/04] video: Runtime PM hack for SuperH LCDC driver".

Ah, I see.  You'd like to call pm_runtime_get_sync() from .probe(), but that
sees the usage counter different from zero and exits immediately.

OTOH, I think we should prevent suspends from racing with .probe() at the core
level.  Hmm.

One possible approach could be to call pm_runtime_resume() from
sh_mobile_lcdc_probe() instead of pm_runtime_put_noidle().  Then, the platform
code will have a chance to turn the device on and the later pm_runtime_get*()
and pm_runtime_put*() calls will be balanced.  Of course, in that case the
pm_runtime_get_noresume() in sh_mobile_lcdc_probe() won't be necessary any
more.  Am I overlooking anything?

Rafael
