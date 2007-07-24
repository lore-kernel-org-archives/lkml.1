Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbXGXUYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbXGXUYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXGXUY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:24:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56810 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763502AbXGXUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:24:27 -0400
Date: Tue, 24 Jul 2007 16:24:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Towards eliminating the freezer
In-Reply-To: <200707242120.22529.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0707241549280.17124-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Rafael J. Wysocki wrote:

> Hmm, I still don't understand why we can't lock dpm_list_mutex before the
> "For each" loop (we already do something like this in device_suspend() and
> device_resume()) and that would simplify things.
> 
> It seems that we can do something like this:
> 
> device_suspend:
> 	Lock dpm_list_mutex (from now on, new devices cannot be added)
> 	For each device on dpm_active, reverse
> 		acquire dev->sem (from now on, no new drivers can bind to dev)
> 		suspend(dev)
> 		move dev to dpm_off

You have a minor error there; it's necessary to unlock dpm_list_mutex 
while acquiring dev-sem and then lock it again.  But more importantly, 
this code acquires the device semaphores in the wrong order.  They have 
to be acquired going forward (from the top of the device tree down), 
not backward.


Here's my proposal in a more explicit form.  Before doing
device_suspend() we call lock_all_devices():

struct list_head dpm_locked;

static void lock_all_devices()
{
	mutex_lock(&dpm_list_mtx);
	while (!list_empty(&dpm_active)) {
		struct list_head *entry = dpm_active.next;
		struct device *dev = to_device(entry);

		get_device(dev);
		mutex_unlock(&dpm_list_mtx);
		down(&dev->sem);
		mutex_lock(&dpm_list_mtx);

		if (list_empty(entry))		/* Device was removed */
			up(&dev->sem);
		else			/* Move it to the dpm_locked list */
			list_move_tail(entry, &dpm_locked);
		put_device(dev);
	}
}

Then device_suspend() can be simplified:

int device_suspend(pm_message_t state)
{
	int error = 0;

	might_sleep();
	list_for_each_entry_reverse(dev, &dpm_locked, power.entry) {
		error = suspend_device(dev, state);

		if (error) {
			printk(KERN_ERR "Could not suspend device %s: "
				"error %d%s\n",
				kobject_name(&dev->kobj), error,
				error == -EAGAIN ? " (please convert to suspend_late)" : "");
			break;
		}
		list_move(&dev->power.entry, &dpm_off);
	}
	if (error)
		dpm_resume();
	return error;
}

Appropriate changes are needed in the resume pathway as well, together 
with an unlock_all_devices() routine:

static void unlock_all_devices(void)
{
	while (!list_empty(&dpm_locked)) {
		struct list_head *entry = dpm_locked.prev;
		struct device *dev = to_device(entry);

		list_move(entry, &dpm_active);
		up(&dev->sem);
	}
	mutex_unlock(&dpm_list_mtx);
}


Incidentally, what is dpm_mtx for?  It doesn't seem to do anything 
useful.  Is it a relic of the former runtime PM support?

Alan Stern

