Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0BEKT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:19:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0BEKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:19:26 -0500
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1002041322390.1261-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002041322390.1261-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 11:18:37 +0100
Message-ID: <1265365117.22001.377.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 13:37 -0500, Alan Stern wrote:
> On Thu, 4 Feb 2010, Peter Zijlstra wrote:
> 
> > > This doesn't address the fact that we really have multiple device trees
> > > (for example, class devices are handled separately from normal
> > > devices).  With the above patch installed, I still get lockdep
> > > violations farther on during boot:
> > 
> > <snip lockdep splat>
> > 
> > Hmm, so you have multiple interacting trees? I had understood you only
> > had a single device tree.
> 
> The real situation is kind of complicated, and I'm not familiar with
> all the details.  But it's certainly true that a driver will want to
> work with (and lock!) multiple struct device's that don't have a
> parent-child relation in the tree.  The simplest example is regular
> devices together with class devices, and another might be PCI devices
> together with their "shadow" ACPI devices.
> 
> >  So how many trees are there, is that fixed?
> > Does the device know what tree it is going to end up in?
> 
> The driver generally knows, but AFAIK that information is not passed 
> back to the driver core.  At least, not directly -- you might say that 
> it could be deduced from the parent pointer, assuming the core already 
> knows all about the parent.
> 
> > If yes, then you can extend the setup_mutex_depth() function to pick a
> > different class stack for each tree.
> 
> Maybe this could be done. 

Right, so this device stuff is much more complicated than I was led to
believe ;-)

So the device core doesn't know, so how are you guys making sure there
really are no deadlocks hidden in there somewhere?

>  But for now perhaps a compromise is in
> order.  We could make the switch from semaphores to mutexes while
> avoiding lockdep issues by assigning the device mutexes to a
> "don't-verify" class.  Is there such a thing, or could it be added?

Something like the below might work, but it should go along with a
checkpatch.pl mod to ensure we don't grow any new users (just don't feel
like brushing up my perl fu enough to actually make sense of that
script)

---
 include/linux/lockdep.h |    2 ++
 kernel/lockdep.c        |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ccf0e2..4e30ab4 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -40,6 +40,8 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+extern struct lock_class_key __lockdep_no_validate__;
+
 #define LOCKSTAT_POINTS		4
 
 /*
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c62ec14..af65a34 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2716,6 +2716,8 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
+struct lock_class_key __lockdep_no_validate__;
+
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
  * We maintain the dependency maps and validate the locking attempt:
@@ -2750,6 +2752,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		return 0;
 	}
 
+	if (lock->key == &__lockdep_no_validate__)
+		check = 1;
+
 	if (!subclass)
 		class = lock->class_cache;
 	/*


