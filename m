Return-Path: <linux-kernel-owner+w=401wt.eu-S1750774AbZHHOCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbZHHOCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 10:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbZHHOCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 10:02:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40212 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZHHOCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 10:02:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH update x2] PM: Introduce core framework for run-time PM of I/O devices (rev. 13)
Date: Sat, 8 Aug 2009 16:03:02 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908071130440.3063-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908071130440.3063-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908081603.02713.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Alan Stern wrote:
> On Thu, 6 Aug 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > The patch below should address all of your most recent comments.
> 
> Only two comments.
> 
> 
> > +static int __pm_request_idle(struct device *dev)
> > +{
> ...
> > +	if (dev->power.request_pending) {
> > +		/* Any requests other then RPM_REQ_IDLE take precedence. */
> > +		if (dev->power.request != RPM_REQ_NONE)
> 
> Replace != with ==.

Good catch, thanks!

> > +			dev->power.request = RPM_REQ_IDLE;
> > +		else if (dev->power.request != RPM_REQ_IDLE)
> > +			retval = -EAGAIN;
> > +		return retval;
> 
> 
> > --- linux-2.6.orig/drivers/base/dd.c
> > +++ linux-2.6/drivers/base/dd.c
> ...
> > @@ -306,6 +317,8 @@ static void __device_release_driver(stru
> >  
> >  	drv = dev->driver;
> >  	if (drv) {
> > +		pm_runtime_disable(dev);
> > +
> >  		driver_sysfs_remove(dev);
> >  
> >  		if (dev->bus)
> > @@ -324,6 +337,8 @@ static void __device_release_driver(stru
> >  			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> >  						     BUS_NOTIFY_UNBOUND_DRIVER,
> >  						     dev);
> > +
> > +		pm_runtime_enable(dev);
> >  	}
> >  }
> 
> We may need to be more careful here.  The driver's remove method may
> want to do some runtime PM stuff to the device before giving up
> control.  On the other hand I'm not sure what _should_ be done here, so
> I can't suggest anything better.

Hmm.  Perhaps we can do something along the lines of our .probe() handling.
Namely, call

pm_runtime_disable(dev);
pm_runtime_get_noresume(dev);
pm_runtime_enable(dev);

before and

pm_runtime_put_noidle()

after?  Then, if the driver's or bus type's .remove() needs to resume, it will
be able to do that right away and if it wants to suspend, it can always call
pm_runtime_put*(), because our pm_runtime_put_noidle() won't decrease the
usage counter below zero.

At the same time we can avoid "leftover" suspends that could interfere with
.remove() in case it needs to access the hardware.

Best,
Rafael
