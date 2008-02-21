Return-Path: <linux-kernel-owner+w=401wt.eu-S1765752AbYBUQ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765752AbYBUQ2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYBUQ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:27:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47175 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754146AbYBUQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:27:55 -0500
Date: Thu, 21 Feb 2008 11:27:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802210102.11611.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802211115380.4528-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:

> > > +bool in_suspend_context(void)
> > > +{
> > > +	bool result;
> > > +
> > > +	mutex_lock(&suspending_task_mtx);
> > > +	result = (suspending_task == current);
> > > +	mutex_unlock(&suspending_task_mtx);
> > > +	return result;
> > > +}
> > 
> > If suspending_task == current then you are guaranteed to be serialized, 
> > because everything a single task does is serial.
> 
> As I said before (but that doesn't seem to reach the list, so I'm repeating),
> this is to protect other tasks from reading an inconsistent value of
> suspending_task in case they attempt to remove a device concurrently with
> respect to us.
> 
> While this is not likely to happen right now, because of the freezer, it may
> very well happen when the freezer is finally removed.

Sorry, I don't understand.  Are you worried that process A might set
suspending_task = A but then process B might still see suspending_task
== NULL?  Or that A might set suspend_task = NULL but then B might
still see suspending_task == A?

Neither one will cause any problem, since the only case that matters is
when B sees suspending_task == B -- and that can happen if and only if
B was the last process to set suspending_task.

In fact, you might as well get rid of the set_suspending_task() routine 
entirely and just put the assignments inline.

> --- linux-2.6.orig/drivers/base/core.c
> +++ linux-2.6/drivers/base/core.c
> @@ -929,6 +929,11 @@ void device_del(struct device *dev)
>  	struct device *parent = dev->parent;
>  	struct class_interface *class_intf;
>  
> +	if (in_suspend_context()) {
> +		get_device(dev);

Where is this get_device() undone?  Shouldn't there be an extra 
put_device() added to unregister_dropped_devices()?

> +		device_pm_schedule_removal(dev);
> +		return;
> +	}
>  	device_pm_remove(dev);
>  	if (parent)
>  		klist_del(&dev->knode_parent);

And now the change to device_destroy() isn't needed at all.

Alan Stern

