Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXFYVBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXFYVBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXFYVBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:01:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXFYVBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:01:20 -0400
Date: Mon, 25 Jun 2007 23:01:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Johannes Weiner <hannes-kernel@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com, David Chinner <dgc@sgi.com>
Subject: Re: [BUG] Lockdep warning with XFS on 2.6.22-rc6
Message-ID: <20070625210111.GB26725@elte.hu>
References: <20070625104956.GA22130@saeurebad.de> <a781481a0706250854p4dad0cb6k20111db0f1c13e55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706250854p4dad0cb6k20111db0f1c13e55@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satyam Sharma <satyam.sharma@gmail.com> wrote:

> [ Ok, so we know that XFS wants to lock inodes in ascending inode 
> number order and not strictly the parent-first-child-second order that 
> rest of the fs/ code does, so that makes it difficult to teach lockdep 
> about this kind of lock ordering ... ]

hm, there's a recent API addition to lockdep that should help with this: 
have you looked into the patch below, could it be used to solve the XFS 
problem? Basically when you are one step deeper into a recursive locking 
scenario you can use lock_set_subclass() on the held lock to reset it 
one level higher.

this preserves lockdep checking but allows arbitrary deep locking.

	Ingo

---------------------->
Subject: [patch] lockdep: lock_set_subclass - reset a held lock's subclass
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

this can be used to reset a held lock's subclass, for arbitrary-depth
iterated data structures such as trees or lists which have per-node
locks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |    4 ++
 kernel/lockdep.c        |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

Index: linux/include/linux/lockdep.h
===================================================================
--- linux.orig/include/linux/lockdep.h
+++ linux/include/linux/lockdep.h
@@ -243,6 +243,9 @@ extern void lock_acquire(struct lockdep_
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+extern void lock_set_subclass(struct lockdep_map *lock, unsigned int subclass,
+			      unsigned long ip);
+
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
@@ -259,6 +262,7 @@ static inline void lockdep_on(void)
 
 # define lock_acquire(l, s, t, r, c, i)		do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
Index: linux/kernel/lockdep.c
===================================================================
--- linux.orig/kernel/lockdep.c
+++ linux/kernel/lockdep.c
@@ -2278,6 +2278,55 @@ static int check_unlock(struct task_stru
 	return 1;
 }
 
+static int
+__lock_set_subclass(struct lockdep_map *lock,
+		    unsigned int subclass, unsigned long ip)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	struct lock_class *class;
+	unsigned int depth;
+	int i;
+
+	depth = curr->lockdep_depth;
+	if (DEBUG_LOCKS_WARN_ON(!depth))
+		return 0;
+
+	prev_hlock = NULL;
+	for (i = depth-1; i >= 0; i--) {
+		hlock = curr->held_locks + i;
+		/*
+		 * We must not cross into another context:
+		 */
+		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
+			break;
+		if (hlock->instance == lock)
+			goto found_it;
+		prev_hlock = hlock;
+	}
+	return print_unlock_inbalance_bug(curr, lock, ip);
+
+found_it:
+	class = register_lock_class(lock, subclass, 0);
+	hlock->class = class;
+
+	curr->lockdep_depth = i;
+	curr->curr_chain_key = hlock->prev_chain_key;
+
+	for (; i < depth; i++) {
+		hlock = curr->held_locks + i;
+		if (!__lock_acquire(hlock->instance,
+			hlock->class->subclass, hlock->trylock,
+				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->acquire_ip))
+			return 0;
+	}
+
+	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth))
+		return 0;
+	return 1;
+}
+
 /*
  * Remove the lock to the list of currently held locks in a
  * potentially non-nested (out of order) manner. This is a
@@ -2473,6 +2522,26 @@ void lock_release(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_release);
 
+void
+lock_set_subclass(struct lockdep_map *lock,
+		  unsigned int subclass, unsigned long ip)
+{
+	unsigned long flags;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	current->lockdep_recursion = 1;
+	check_flags(flags);
+	if (__lock_set_subclass(lock, subclass, ip))
+		check_chain_key(current);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+
+EXPORT_SYMBOL_GPL(lock_set_subclass);
+
 /*
  * Used by the testsuite, sanitize the validator state
  * after a simulated failure:
