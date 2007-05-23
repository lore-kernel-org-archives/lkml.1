Return-Path: <linux-kernel-owner+w=401wt.eu-S1765962AbXEWKDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765962AbXEWKDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765167AbXEWKCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:02:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765082AbXEWKCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:02:44 -0400
Message-Id: <20070523095807.312401674@chello.nl>
References: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] lockdep: isolate lock graph walking
Content-Disposition: inline; filename=lockstat-prove-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Put the lock dependancy tracking bits under CONFIG_PROVE_LOCKING
This way we can reuse the hold_lock part of lockdep for other purposes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2007-05-23 00:22:59.000000000 +0200
+++ linux-2.6/kernel/lockdep.c	2007-05-23 00:42:43.000000000 +0200
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
@@ -482,6 +486,7 @@ static void print_lock_dependencies(stru
 	}
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Add a new dependency to the head of the list:
  */
@@ -541,6 +546,7 @@ print_circular_bug_entry(struct lock_lis
 
 	return 0;
 }
+#endif
 
 static void print_kernel_version(void)
 {
@@ -549,6 +555,7 @@ static void print_kernel_version(void)
 		init_utsname()->version);
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * When a circular dependency is detected, print the
  * header first:
@@ -639,6 +646,7 @@ check_noncircular(struct lock_class *sou
 	}
 	return 1;
 }
+#endif
 
 static int very_verbose(struct lock_class *class)
 {
@@ -823,6 +831,7 @@ check_usage(struct task_struct *curr, st
 
 #endif
 
+#ifdef CONFIG_PROVE_LOCKING
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
@@ -1087,7 +1096,7 @@ out_bug:
 
 	return 0;
 }
-
+#endif
 
 /*
  * Is this the address of a static object:
@@ -1307,6 +1316,7 @@ out_unlock_set:
 	return class;
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Look up a dependency chain. If the key is not present yet then
  * add it and return 1 - in this case the new dependency chain is
@@ -1381,6 +1391,7 @@ cache_hit:
 
 	return 1;
 }
+#endif
 
 /*
  * We are building curr_chain_key incrementally, so double-check
@@ -2168,6 +2179,7 @@ out_calc_hash:
 	chain_key = iterate_chain_key(chain_key, id);
 	curr->curr_chain_key = chain_key;
 
+#ifdef CONFIG_PROVE_LOCKING
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
 	 * does not add new dependencies, because trylock can be done
@@ -2214,6 +2226,7 @@ out_calc_hash:
 		/* after lookup_chain_cache(): */
 		if (unlikely(!debug_locks))
 			return 0;
+#endif
 
 	curr->lockdep_depth++;
 	check_chain_key(curr);

-- 

