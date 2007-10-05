Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXJEJbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXJEJbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXJEJbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:31:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56347 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbXJEJbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:31:40 -0400
Subject: [PATCH] lockdep: fix mismatched lockdep_depth/curr_chain_hash
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>, stable <stable@kernel.org>
Cc: mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071005034058.20275.21559.stgit@ghaskins-t60p.haskins.net>
References: <20071005034058.20275.21559.stgit@ghaskins-t60p.haskins.net>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 11:31:26 +0200
Message-Id: <1191576686.22357.64.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stable team,

please consider this patch for the next 22-stable.

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
 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2166,7 +2166,6 @@ out_calc_hash:
 	}
 #endif
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
@@ -2215,6 +2214,7 @@ out_calc_hash:
 		if (unlikely(!debug_locks))
 			return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP


