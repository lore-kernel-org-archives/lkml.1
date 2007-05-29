Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXE2NSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXE2NSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXE2NSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:18:36 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65098 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbXE2NSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:18:35 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:18:35 EDT
Message-Id: <20070529130106.864404378@chello.nl>
References: <20070529125248.877196281@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 29 May 2007 14:52:50 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/5] lockdep: sanitise CONFIG_PROVE_LOCKING
Content-Disposition: inline; filename=lockdep-prove-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that all of the lock dependency tracking code is under
CONFIG_PROVE_LOCKING. This allows us to use the held lock tracking code
for other purposes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jason Baron <jbaron@redhat.com>
---
 kernel/lockdep.c  |   13 ++++++++++++-
 kernel/spinlock.c |    4 ++--
 2 files changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6-git/kernel/lockdep.c
===================================================================
--- linux-2.6-git.orig/kernel/lockdep.c
+++ linux-2.6-git/kernel/lockdep.c
@@ -95,6 +95,7 @@ static int lockdep_initialized;
 unsigned long nr_list_entries;
 static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Allocate a lockdep entry. (assumes the graph_lock held, returns
  * with NULL on failure)
@@ -111,6 +112,7 @@ static struct lock_list *alloc_list_entr
 	}
 	return list_entries + nr_list_entries++;
 }
+#endif
 
 /*
  * All data structures here are protected by the global debug_lock.
@@ -140,7 +142,9 @@ LIST_HEAD(all_lock_classes);
 static struct list_head classhash_table[CLASSHASH_SIZE];
 
 unsigned long nr_lock_chains;
+#ifdef CONFIG_PROVE_LOCKING
 static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+#endif
 
 /*
  * We put the lock dependency chains into a hash-table as well, to cache
@@ -486,6 +490,7 @@ static void print_lock_dependencies(stru
 	}
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Add a new dependency to the head of the list:
  */
@@ -545,6 +550,7 @@ print_circular_bug_entry(struct lock_lis
 
 	return 0;
 }
+#endif
 
 static void print_kernel_version(void)
 {
@@ -553,6 +559,7 @@ static void print_kernel_version(void)
 		init_utsname()->version);
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * When a circular dependency is detected, print the
  * header first:
@@ -643,6 +650,7 @@ check_noncircular(struct lock_class *sou
 	}
 	return 1;
 }
+#endif
 
 static int very_verbose(struct lock_class *class)
 {
@@ -827,6 +835,7 @@ check_usage(struct task_struct *curr, st
 
 #endif
 
+#ifdef CONFIG_PROVE_LOCKING
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
@@ -1091,7 +1100,7 @@ out_bug:
 
 	return 0;
 }
-
+#endif
 
 /*
  * Is this the address of a static object:
@@ -1311,6 +1320,7 @@ out_unlock_set:
 	return class;
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Look up a dependency chain. If the key is not present yet then
  * add it and return 1 - in this case the new dependency chain is
@@ -1385,6 +1395,7 @@ cache_hit:
 
 	return 1;
 }
+#endif
 
 /*
  * We are building curr_chain_key incrementally, so double-check
Index: linux-2.6-git/kernel/spinlock.c
===================================================================
--- linux-2.6-git.orig/kernel/spinlock.c
+++ linux-2.6-git/kernel/spinlock.c
@@ -88,7 +88,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * _raw_spin_lock_flags() code, because lockdep assumes
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
-#ifdef CONFIG_PROVE_LOCKING
+#ifdef CONFIG_LOCKDEP
 	_raw_spin_lock(lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
@@ -305,7 +305,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * _raw_spin_lock_flags() code, because lockdep assumes
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
-#ifdef CONFIG_PROVE_SPIN_LOCKING
+#ifdef CONFIG_LOCKDEP
 	_raw_spin_lock(lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);

--

