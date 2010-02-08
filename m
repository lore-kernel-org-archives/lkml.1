Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0BHPi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:38:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51752 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752890Ab0BHPiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:38:54 -0500
Date: Mon, 8 Feb 2010 10:38:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
In-Reply-To: <1265365117.22001.377.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.1002081033170.1411-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Peter Zijlstra wrote:

> >  But for now perhaps a compromise is in
> > order.  We could make the switch from semaphores to mutexes while
> > avoiding lockdep issues by assigning the device mutexes to a
> > "don't-verify" class.  Is there such a thing, or could it be added?
> 
> Something like the below might work, but it should go along with a
> checkpatch.pl mod to ensure we don't grow any new users (just don't feel
> like brushing up my perl fu enough to actually make sense of that
> script)

I tried this out and it does work; no more lockdep warnings during 
bootup.  The complete patch is below.

But before we apply this, it might be worthwhile to spend a little time 
figuring out how many independent device trees there really are and 
whether they can be handled with separate depth-associated lockdep 
classes.  It's not at all obvious that they can.

Alan Stern


Index: usb-2.6/include/linux/lockdep.h
===================================================================
--- usb-2.6.orig/include/linux/lockdep.h
+++ usb-2.6/include/linux/lockdep.h
@@ -40,6 +40,8 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+extern struct lock_class_key __lockdep_no_validate__;
+
 #define LOCKSTAT_POINTS		4
 
 /*
Index: usb-2.6/kernel/lockdep.c
===================================================================
--- usb-2.6.orig/kernel/lockdep.c
+++ usb-2.6/kernel/lockdep.c
@@ -2716,6 +2716,8 @@ void lockdep_init_map(struct lockdep_map
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
+struct lock_class_key __lockdep_no_validate__;
+
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
  * We maintain the dependency maps and validate the locking attempt:
@@ -2750,6 +2752,9 @@ static int __lock_acquire(struct lockdep
 		return 0;
 	}
 
+	if (lock->key == &__lockdep_no_validate__)
+		check = 1;
+
 	if (!subclass)
 		class = lock->class_cache;
 	/*
Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -559,6 +559,7 @@ void device_initialize(struct device *de
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
+	lockdep_set_class(&dev->mutex, &__lockdep_no_validate__);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);

