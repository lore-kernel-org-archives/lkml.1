Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYHALIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYHALIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYHALIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:08:46 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:63973 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbYHALIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:08:45 -0400
Subject: [PATCH] lockdep: lock_set_subclass - reset a held lock's subclass
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080801.021348.233313767.davem@davemloft.net>
References: <20080731.155504.167792984.davem@davemloft.net>
	 <20080801.011122.32782916.davem@davemloft.net>
	 <20080801090100.GA25142@elte.hu>
	 <20080801.021348.233313767.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:08:40 +0200
Message-Id: <1217588920.9686.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: lockdep: lock_set_subclass - reset a held lock's subclass

this can be used to reset a held lock's subclass, for arbitrary-depth
iterated data structures such as trees or lists which have per-node
locks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |    4 ++
 kernel/lockdep.c        |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -300,6 +300,9 @@ extern void lock_acquire(struct lockdep_
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+extern void lock_set_subclass(struct lockdep_map *lock, unsigned int subclass,
+			      unsigned long ip);
+
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
@@ -316,6 +319,7 @@ static inline void lockdep_on(void)
 
 # define lock_acquire(l, s, t, r, c, i)		do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2658,6 +2658,55 @@ static int check_unlock(struct task_stru
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
@@ -2822,6 +2871,26 @@ static void check_flags(unsigned long fl
 #endif
 }
 
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
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:


