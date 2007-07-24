Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbXGXVHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbXGXVHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXGXVHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:07:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbXGXVHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:07:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Towards eliminating the freezer
Date: Tue, 24 Jul 2007 23:14:51 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707241549280.17124-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707241549280.17124-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707242314.52355.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 July 2007 22:24, Alan Stern wrote:
> On Tue, 24 Jul 2007, Rafael J. Wysocki wrote:
> 
> > Hmm, I still don't understand why we can't lock dpm_list_mutex before the
> > "For each" loop (we already do something like this in device_suspend() and
> > device_resume()) and that would simplify things.
> > 
> > It seems that we can do something like this:
> > 
> > device_suspend:
> > 	Lock dpm_list_mutex (from now on, new devices cannot be added)
> > 	For each device on dpm_active, reverse
> > 		acquire dev->sem (from now on, no new drivers can bind to dev)
> > 		suspend(dev)
> > 		move dev to dpm_off
> 
> You have a minor error there; it's necessary to unlock dpm_list_mutex 
> while acquiring dev-sem and then lock it again.

Ah, right, now I see that.

> But more importantly, this code acquires the device semaphores in the wrong
> order.  They have to be acquired going forward (from the top of the device
> tree down), not backward.

Yes, I've overlooked that too.

> Here's my proposal in a more explicit form.  Before doing
> device_suspend() we call lock_all_devices():
> 
> struct list_head dpm_locked;
> 
> static void lock_all_devices()
> {
> 	mutex_lock(&dpm_list_mtx);
> 	while (!list_empty(&dpm_active)) {
> 		struct list_head *entry = dpm_active.next;
> 		struct device *dev = to_device(entry);
> 
> 		get_device(dev);
> 		mutex_unlock(&dpm_list_mtx);
> 		down(&dev->sem);
> 		mutex_lock(&dpm_list_mtx);
> 
> 		if (list_empty(entry))		/* Device was removed */
> 			up(&dev->sem);
> 		else			/* Move it to the dpm_locked list */
> 			list_move_tail(entry, &dpm_locked);
> 		put_device(dev);
> 	}
> }
> 
> Then device_suspend() can be simplified:
> 
> int device_suspend(pm_message_t state)
> {
> 	int error = 0;
> 
> 	might_sleep();
> 	list_for_each_entry_reverse(dev, &dpm_locked, power.entry) {
> 		error = suspend_device(dev, state);
> 
> 		if (error) {
> 			printk(KERN_ERR "Could not suspend device %s: "
> 				"error %d%s\n",
> 				kobject_name(&dev->kobj), error,
> 				error == -EAGAIN ? " (please convert to suspend_late)" : "");
> 			break;
> 		}
> 		list_move(&dev->power.entry, &dpm_off);

Is that safe with list_for_each_entry_reverse?

> 	}
> 	if (error)
> 		dpm_resume();
> 	return error;
> }
> 
> Appropriate changes are needed in the resume pathway as well, together 
> with an unlock_all_devices() routine:

Sure.

> static void unlock_all_devices(void)
> {
> 	while (!list_empty(&dpm_locked)) {
> 		struct list_head *entry = dpm_locked.prev;
> 		struct device *dev = to_device(entry);
> 
> 		list_move(entry, &dpm_active);
> 		up(&dev->sem);
> 	}
> 	mutex_unlock(&dpm_list_mtx);
> }

Yes, that looks fine. 

So, who's writing the patch? ;-)

> Incidentally, what is dpm_mtx for?  It doesn't seem to do anything 
> useful.  Is it a relic of the former runtime PM support?

I think so.  IMO it can be removed.

I also think it would be nicer to have all of the functions in
drivers/base/power/{main|suspend|resume}.c moved to one file.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
