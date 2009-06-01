Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbZFAJuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbZFAJuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZFAJuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:50:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:55961 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbZFAJuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:50:14 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       yong.zhang0@gmail.com
Subject: [PATCH 1/1] lockdep: cleanup duplicated variable
Date: Mon,  1 Jun 2009 17:51:26 +0800
Message-Id: <c9ae33b1d45eebad1f71a0aaf1b1c702e23d51fc.1243849167.git.yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 01 Jun 2009 09:49:57.0502 (UTC) FILETIME=[5295A9E0:01C9E29E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of using variable i to keep chain depth and with graph_lock
being held, only one variable is enough.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/lockdep.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8bbeef9..89f2d15 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1641,7 +1641,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	struct lock_class *class = hlock_class(hlock);
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
-	struct held_lock *hlock_curr, *hlock_next;
+	struct held_lock *hlock_next;
 	int i, j, n, cn;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
@@ -1693,12 +1693,10 @@ cache_hit:
 	chain->chain_key = chain_key;
 	chain->irq_context = hlock->irq_context;
 	/* Find the first held_lock of current chain */
-	hlock_next = hlock;
 	for (i = curr->lockdep_depth - 1; i >= 0; i--) {
-		hlock_curr = curr->held_locks + i;
-		if (hlock_curr->irq_context != hlock_next->irq_context)
+		hlock_next = curr->held_locks + i;
+		if (hlock_next->irq_context != hlock->irq_context)
 			break;
-		hlock_next = hlock;
 	}
 	i++;
 	chain->depth = curr->lockdep_depth + 1 - i;
-- 
1.5.6.5

