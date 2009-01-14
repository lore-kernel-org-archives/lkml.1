Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbZANRHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbZANRHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbZANRHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:07:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763695AbZANRHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:07:17 -0500
Date: Wed, 14 Jan 2009 18:06:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH -v11 delta] mutex: implement adaptive spinning
Message-ID: <20090114170651.GA25904@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231901899.1709.18.camel@think.oraclecorp.com> <20090114112158.GA8625@elte.hu> <alpine.LFD.2.00.0901140739110.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901140739110.6528@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > > If I take out:
> > > 	/*
> > > 	 * If there are pending waiters, join them.
> > > 	 */
> > > 	if (!list_empty(&lock->wait_list))
> > > 		break;
> > > 
> > > 
> > > v10 pops dbench 50 up to 1800MB/s.  The other tests soundly beat my 
> > > spinning and aren't less fair.  But clearly this isn't a good solution.
> > 
> > i think since we already decided that it's ok to be somewhat unfair (_all_ 
> > batching constructs introduce unfairness, so the question is never 'should 
> > we?' but 'by how much?'), we should just take this out and enjoy the speed 
> 
> Yeah, let's just do it. It's going to be unfair, but let's see if the 
> unfairness is going to actually be noticeable in real life. I suspect it 
> isn't, and if it is, we can look at it again and see if there are other 
> approaches.
> 
> If it makes _that_ much of a difference on dbench, it's worth being 
> unfair even if it's just for some dubious benchmark.

Below is the final v10->v11 delta, for review. Beyond the tweak from 
Chris, there's small cleanups and the debug simplification from Johannes 
Weiner. We think this is the final version and are doing final tests now.

	Ingo

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 0d5336d..703dec2 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -148,7 +148,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+#ifdef CONFIG_SMP
 	/*
 	 * Optimistic spinning.
 	 *
@@ -162,21 +162,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 * Since this needs the lock owner, and this mutex implementation
 	 * doesn't track the owner atomically in the lock field, we need to
 	 * track it non-atomically.
-	 *
-	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
-	 * to serialize everything.
 	 */
 
 	for (;;) {
 		struct thread_info *owner;
 
 		/*
-		 * If there are pending waiters, join them.
-		 */
-		if (!list_empty(&lock->wait_list))
-			break;
-
-		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
@@ -184,6 +175,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+			lock_acquired(&lock->dep_map, ip);
+			preempt_enable();
+			return 0;
+		}
+
 		/*
 		 * When there's no owner, we might have preempted between the
 		 * owner acquiring the lock and setting the owner field. If
@@ -193,13 +190,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (!owner && (need_resched() || rt_task(task)))
 			break;
 
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
-			lock_acquired(&lock->dep_map, ip);
-			mutex_set_owner(lock);
-			preempt_enable();
-			return 0;
-		}
-
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
 		 * everything in this loop to be re-loaded. We don't need
@@ -209,7 +199,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		cpu_relax();
 	}
 #endif
-
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
@@ -263,7 +252,6 @@ done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
-	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -439,10 +427,8 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
-	if (likely(prev == 1)) {
-		mutex_set_owner(lock);
+	if (likely(prev == 1))
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-	}
 
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
