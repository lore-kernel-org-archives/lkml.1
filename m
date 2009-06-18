Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbZFRFey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbZFRFey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZFRFeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:34:46 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50235 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZFRFep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:34:45 -0400
Message-Id: <200906180534.n5I5YgMY080614@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v3)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: paulmck@linux.vnet.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Jun 2009 14:34:42 +0900
References: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp> <20090617163122.GC6767@linux.vnet.ibm.com>
In-Reply-To: <20090617163122.GC6767@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 18062009 #2132583, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul E. McKenney wrote:
> Consider the following sequence of events:
> 
> o	CPU 0 picks up users_counter_idx int local variable idx.
> 	Let's assume that the value is zero.
> 
> o	CPU 0 is now preempted, interrupted, or otherwise delayed.
> 
> o	CPU 1 starts garbage collection, finding some elements to
> 	delete, thus setting "element_deleted" to true.
> 
> o	CPU 1 continues garbage collection, inverting the value of
> 	users_counter_idx, so that the value is now one, waiting
> 	for the value-zero readers, and freeing up the old elements.
> 
> o	CPU 0 continues execution, first atomically incrementing
> 	users_counter[0], then traversing the list, possibly sleeping.
> 
> o	CPU 2 starts a new round of garbage collection, again finding
> 	some elements to delete, and thus again setting
> 	"elements_deleted" to true.  One of the elements deleted
> 	is the one that CPU 0 is currently referencing while asleep.
> 
No. CPU 2 can't start a new round of GC because GC function is exclusively
executed because of gc_mutex mutex.

> o	CPU 2 continues garbage collection, inverting the value of
> 	users_counter_idx, so that the value is now zero, waiting
> 	for the value-one readers, and freeing up the old elements.
> 	Note that CPU 0 is a value-zero reader, so that CPU 2 will
> 	not wait on it.
> 
> 	CPU 2 therefore kfree()s the element that CPU 0 is currently
> 	referencing.
> 
CPU 2 won't continue GC, for CPU 2 can't start a new round of GC.

> o	CPU 0 wakes up, and suffers possibly fatal disappointment upon
> 	attempting to reference an element that has been freed -- and,
> 	worse yet, possibly re-allocated as some other type of
> 	structure.
>
CPU 0 won't suffer, for first round of GC (by CPU 1) prevents CPU 2 from
starting a new round of GC.

> Or am I missing something in your pseudocode?
I think you missed that GC function is executed exclusively.

The race between readers and GC is avoided as below.

(a-1) A reader reads users_counter_idx and saves to r_idx
(a-2) GC removes element from the list using RCU
(a-3) GC reads users_counter_idx and saves to g_idx
(a-4) GC inverts users_counter_idx
(a-5) GC releases the removed element
(a-6) A reader increments users_counter[r_idx]
(a-7) A reader won't see the element removed by GC because
      the reader has not started list traversal as of (a-2)

(b-1) A reader reads users_counter_idx and saves to r_idx
(b-2) A reader increments users_counter[r_idx]
(b-3) GC removes element from the list using RCU
(b-4) A reader won't see the element removed by GC
(b-5) GC reads users_counter_idx and saves to g_idx
(b-6) GC inverts users_counter_idx
(b-7) GC waits for users_counter[g_idx] to become 0
(b-8) A reader decrements users_counter[r_idx]
(b-9) GC releases the removed element

(c-1) A reader reads users_counter_idx and saves to r_idx
(c-2) A reader increments users_counter[r_idx]
(c-3) A reader sees the element
(c-4) GC removes element from the list using RCU
(c-5) GC reads users_counter_idx and saves to g_idx
(c-6) GC inverts users_counter_idx
(c-7) GC waits for users_counter[g_idx] to become 0
(c-8) A reader decrements users_counter[r_idx]
(c-9) GC releases the removed element

What I worry is that some memory barriers might be needed between

> > {
> > 	/* Get counter index. */
> > 	int idx = atomic_read(&users_counter_idx);
> > 	/* Lock counter. */
> > 	atomic_inc(&users_counter[idx]);
- here -
> > 	list_for_each_entry_rcu() {
> > 		... /* Allowed to sleep. */
> > 	}
- here -
> > 	/* Unlock counter. */
> > 	atomic_dec(&users_counter[idx]);
> > }

and

> > 	if (element_deleted) {
> > 		/* Swap active counter. */
> > 		const int idx = atomic_read(&users_counter_idx);
- here -
> > 		atomic_set(&users_counter_idx, idx ^ 1);
- here -
> > 		/*
> > 		 * Wait for readers who are using previously active counter.
> > 		 * This is similar to synchronize_rcu() while this code allows
> > 		 * readers to do operations which may sleep.
> > 		 */
> > 		while (atomic_read(&users_counter[idx]))
> > 			msleep(1000);
> > 		/*
> > 		 * Nobody is using previously active counter.
> > 		 * Ready to release memory of elements removed before
> > 		 * previously active counter became inactive.
> > 		 */
> > 		kfree(element);
> > 	}

in order to enforce ordering.



> Also, if you have lots of concurrent readers, you can suffer high memory
> contention on the users_counter[] array, correct?

Excuse me. I couldn't understand "memory contention"...

( http://www.answers.com/topic/memory-contention )
| A situation in which two different programs, or two parts of a program,
| try to read items in the same block of memory at the same time. 
Why suffered by atomic_read() at the same time?
Cache invalidation by atomic_inc()/atomic_dec() a shared variable?

( http://wiki.answers.com/Q/What_is_memory_contention )
| Memory contention is a state a OS memory manager can reside in when to many
| memory requests (alloc, realloc, free) are issued to it from an active
| application possibly leading to a DOS condition specific to that
| application. 
No memory allocation for users_counter[] array.



> I recommend that you look into use of SRCU in this case.

I have one worry regarding SRCU.
Inside synchronize_srcu(), there is a loop

	while (srcu_readers_active_idx(sp, idx))
		schedule_timeout_interruptible(1);

but the reader's sleeping duration varies from less than one second to
more than hours.

Checking for counters for every jiffies sounds too much waste of CPU.
Delaying kfree() for seconds or minutes won't cause troubles for TOMOYO.
It would be nice if checking interval is configurable like
"schedule_timeout_interruptible(sp->timeout);".



> Anyway, the general approach would be to make changes to your code
> roughly as follows:
> 
> 1.	replace your users_counter and users_counter_idx with a
> 	struct srcu_struct.
> 
> 2.	In the reader, replace the fetch from users_counter_idx and
> 	the atomic_inc() with srcu_read_lock().
> 
> 3.	In the garbage collector, replace the fetch/update of
> 	users_counter_idx and the "while" loop with synchronize_srcu().
> 
I see. Since I isolated the GC as a dedicated kernel thread, writers no longer
wait for elements to be kfree()ed. I can use SRCU.



> Or is there some reason why SRCU does not work for you?
None for mainline version.

I'm also maintaining TOMOYO for older/distributor kernels for those who want to
enable both SELinux/SMACK/AppArmor/grsecurity etc. and TOMOYO at the same time.
Thus, if my idea works, I want to backport it to TOMOYO for these kernels.



Regards.
