Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZFQQbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZFQQbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZFQQbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:31:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43325 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZFQQbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:31:20 -0400
Date: Wed, 17 Jun 2009 09:31:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v3)
Message-ID: <20090617163122.GC6767@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 08:19:07PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> This patchset adds garbage collector for TOMOYO.
> This time, I'm using some sort of RCU-like approach instead of cookie-list
> approach.
> 
> TOMOYO 1/3: Move sleeping operations to outside the semaphore.
> 6 files changed, 231 insertions(+), 345 deletions(-)
> 
> TOMOYO 2/3: Replace tomoyo_save_name() with tomoyo_get_name()/tomoyo_put_name().
> 5 files changed, 70 insertions(+), 23 deletions(-)
> 
> TOMOYO 3/3: Add RCU-like garbage collector.
> 7 files changed, 733 insertions(+), 358 deletions(-)
> 
> Paul E. McKenney wrote ( http://lkml.org/lkml/2009/5/27/2 ) :
> > I would also recommend the three-part LWN series as a starting point:
> > 
> > #       http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> > #       http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> > #       http://lwn.net/Articles/264090/ (What is RCU's API?)
>
> I've read these articles. They are very good.

Glad that they were helpful!!!

> I came up with an idea that we may be able to implement GC while readers are
> permitted to sleep but no read locks are required.

I believe you have a bug in your pseudocode -- please see below.

> The idea is to have two counters which hold the number of readers currently
> reading the list, one is active and the other is inactive. Reader increments
> the currently active counter before starts reading and decrements that counter
> after finished reading. GC swaps active counter and inactive counter and waits
> for previously active counter's count to become 0 before releasing elements
> removed from the list.
> Code is shown below.
> 
> atomic_t users_counter[2];
> atomic_t users_counter_idx;
> DEFINE_MUTEX(updator_mutex);
> DEFINE_MUTEX(gc_mutex);
> 
> --- reader ---
> {
> 	/* Get counter index. */
> 	int idx = atomic_read(&users_counter_idx);
> 	/* Lock counter. */
> 	atomic_inc(&users_counter[idx]);
> 	list_for_each_entry_rcu() {
> 		... /* Allowed to sleep. */
> 	}
> 	/* Unlock counter. */
> 	atomic_dec(&users_counter[idx]);
> }
> 
> --- writer ---
> {
> 	bool found = false;
> 	/* Get lock for writing. */
> 	mutex_lock(&updater_mutex);
> 	list_for_each_entry_rcu() {
> 		if (...)
> 			continue;
> 		found = true;
> 		break;
> 	}
> 	if (!found)
> 		list_add_rcu(element);
> 	/* Release lock for writing. */
> 	mutex_unlock(&updater_mutex);
> }
> 
> --- garbage collector ---
> {
> 	bool element_deleted = false;
> 	/* Protect the counters from concurrent GC threads. */
> 	mutex_lock(&gc_mutex);
> 	/* Get lock for writing. */
> 	mutex_lock(&updater_mutex);
> 	list_for_each_entry_rcu() {
> 		if (...)
> 			continue;
> 		list_del_rcu(element);
> 		element_deleted = true;
> 		break;
> 	}
> 	/* Release lock for writing. */
> 	mutex_unlock(&updater_mutex);
> 	if (element_deleted) {
> 		/* Swap active counter. */
> 		const int idx = atomic_read(&users_counter_idx);
> 		atomic_set(&users_counter_idx, idx ^ 1);
> 		/*
> 		 * Wait for readers who are using previously active counter.
> 		 * This is similar to synchronize_rcu() while this code allows
> 		 * readers to do operations which may sleep.
> 		 */
> 		while (atomic_read(&users_counter[idx]))
> 			msleep(1000);
> 		/*
> 		 * Nobody is using previously active counter.
> 		 * Ready to release memory of elements removed before
> 		 * previously active counter became inactive.
> 		 */
> 		kfree(element);
> 	}
> 	mutex_unlock(&gc_mutex);
> }

Consider the following sequence of events:

o	CPU 0 picks up users_counter_idx int local variable idx.
	Let's assume that the value is zero.

o	CPU 0 is now preempted, interrupted, or otherwise delayed.

o	CPU 1 starts garbage collection, finding some elements to
	delete, thus setting "element_deleted" to true.

o	CPU 1 continues garbage collection, inverting the value of
	users_counter_idx, so that the value is now one, waiting
	for the value-zero readers, and freeing up the old elements.

o	CPU 0 continues execution, first atomically incrementing
	users_counter[0], then traversing the list, possibly sleeping.

o	CPU 2 starts a new round of garbage collection, again finding
	some elements to delete, and thus again setting
	"elements_deleted" to true.  One of the elements deleted
	is the one that CPU 0 is currently referencing while asleep.

o	CPU 2 continues garbage collection, inverting the value of
	users_counter_idx, so that the value is now zero, waiting
	for the value-one readers, and freeing up the old elements.
	Note that CPU 0 is a value-zero reader, so that CPU 2 will
	not wait on it.

	CPU 2 therefore kfree()s the element that CPU 0 is currently
	referencing.

o	CPU 0 wakes up, and suffers possibly fatal disappointment upon
	attempting to reference an element that has been freed -- and,
	worse yet, possibly re-allocated as some other type of
	structure.

Or am I missing something in your pseudocode?

Also, if you have lots of concurrent readers, you can suffer high memory
contention on the users_counter[] array, correct?

I recommend that you look into use of SRCU in this case.  There is some
documentation at http://lwn.net/Articles/202847/, with an revised
version incorporating feedback from the LWN comments available at:

	http://www.rdrop.com/users/paulmck/RCU/srcu.2007.01.14a.pdf

Well, all but one of the LWN comments -- someone posted one a couple of
months ago that I just now noticed.

Anyway, the general approach would be to make changes to your code
roughly as follows:

1.	replace your users_counter and users_counter_idx with a
	struct srcu_struct.

2.	In the reader, replace the fetch from users_counter_idx and
	the atomic_inc() with srcu_read_lock().

3.	In the garbage collector, replace the fetch/update of
	users_counter_idx and the "while" loop with synchronize_srcu().

> In this idea, GC's kfree() call may be deferred for unknown duration, but
> defer duration will not matter if we use a dedicated kernel thread for GC.
> 
> I noticed that there is QRCU in the "RCU has a Family of Wait-to-Finish APIs"
> section. My idea seems to resemble QRCU except grace periods.
> But "Availability" field is empty. Oh, what happened to QRCU?

Last I knew, it was queued up in Jens Axboe's tree, awaiting a first
user.  But the approach you have above looks to me like it will do fine
with SRCU.

Or is there some reason why SRCU does not work for you?

							Thanx, Paul
