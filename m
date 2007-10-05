Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXJEJcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXJEJcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbXJEJbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:31:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbXJEJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:31:44 -0400
Subject: [PATCH] lockdep: fix mismatched lockdep_depth/curr_chain_hash
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20071005041939.20566.51093.stgit@ghaskins-t60p.haskins.net>
References: <20071005041939.20566.51093.stgit@ghaskins-t60p.haskins.net>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 11:31:22 +0200
Message-Id: <1191576682.22357.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ouch!

Thanks Gregory for finding this!

I'll send your initial patch to the stable team for .22.

---
Subject: lockdep: fix mismatched lockdep_depth/curr_chain_hash
From: Gregory Haskins <ghaskins@novell.com>

It is possible for the current->curr_chain_key to become inconsistent with the
current index if the chain fails to validate.  The end result is that future
lock_acquire() operations may inadvertently fail to find a hit in the cache
resulting in a new node being added to the graph for every acquire.

[ peterz: this might explain some of the lockdep is so _slow_ complaints. ]
[ mingo: this does not impact the correctness of validation, but may slow
  down future operations significantly, if the chain gets very long. ]

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -1521,7 +1521,7 @@ cache_hit:
 }
 
 static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
-	       	struct held_lock *hlock, int chain_head)
+	       	struct held_lock *hlock, int chain_head, u64 chain_key)
 {
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
@@ -1534,7 +1534,7 @@ static int validate_chain(struct task_st
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check == 2) &&
-			lookup_chain_cache(curr->curr_chain_key, hlock->class)) {
+			lookup_chain_cache(chain_key, hlock->class)) {
 		/*
 		 * Check whether last held lock:
 		 *
@@ -1576,7 +1576,7 @@ static int validate_chain(struct task_st
 #else
 static inline int validate_chain(struct task_struct *curr,
 	       	struct lockdep_map *lock, struct held_lock *hlock,
-		int chain_head)
+		int chain_head, u64 chain_key)
 {
 	return 1;
 }
@@ -2450,11 +2450,11 @@ static int __lock_acquire(struct lockdep
 		chain_head = 1;
 	}
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
-	if (!validate_chain(curr, lock, hlock, chain_head))
+	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
 		return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP


