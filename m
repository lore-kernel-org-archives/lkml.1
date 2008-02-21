Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYBURtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYBURtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 12:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYBURs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 12:48:57 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752318AbYBURs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 12:48:56 -0500
Date: Thu, 21 Feb 2008 12:48:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802211738.41552.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802211243240.5473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:

> > > --- linux-2.6.orig/drivers/base/core.c
> > > +++ linux-2.6/drivers/base/core.c
> > > @@ -929,6 +929,11 @@ void device_del(struct device *dev)
> > >  	struct device *parent = dev->parent;
> > >  	struct class_interface *class_intf;
> > >  
> > > +	if (in_suspend_context()) {
> > > +		get_device(dev);
> > 
> > Where is this get_device() undone?  Shouldn't there be an extra 
> > put_device() added to unregister_dropped_devices()?
> 
> No, I don't think so, because unregister_dropped_devices() calls
> device_unregister() that does the put_device() eventually.

Ah, yes.

> If we are called by device_unregister(), the get_device() is needed to balance
> the put_device() that will be called by device_unregister() after we return.
> 
> OTOH, if we are called directly, then we need to balance the put_device()
> that will be done by device_unregister() called from
> unregister_dropped_devices().
> 
> I hope I didn't miss anything.

Okay, that sounds right.

> > > +		device_pm_schedule_removal(dev);
> > > +		return;
> > > +	}
> > >  	device_pm_remove(dev);
> > >  	if (parent)
> > >  		klist_del(&dev->knode_parent);
> > 
> > And now the change to device_destroy() isn't needed at all.
> 
> No, it's not.  Didn't I remove it?  I thought I did.

Oh yes, you did.

I see a possible problem in device_resume().  My copy isn't fully 
up-to-date, but it looks like you call unregister_dropped_devices() 
before doing the up_write(&pm_sleep_rwsem).  Won't this cause 
warnings in device_del() about a suspicious caller?

Alan Stern

