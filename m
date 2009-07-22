Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZGVM67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZGVM67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZGVM66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:58:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:7369 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbZGVM64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aiJdIyW2r/yGkVL0w0cWH1ndNU09Vna2r7/hqbF5geKhfAVmhttkPxYLWjHuQrtwUH
         ERdPnVwuIXL/gsEiduIH5EARFfsqGDrwqpoIQzmponrpxdXBmR1rvMx/fcWBAKhaQTSs
         eGDBbBpIS8T1OQ+Addwa7k5r8D+1S4cLjmIZo=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [tip:core/locking 1/3] lockdep:reintroduce generation count to make BFS faster
Date: Wed, 22 Jul 2009 20:58:31 +0800
Message-Id: <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

We still can apply DaveM's generation count optimization to
BFS, so reintroduce it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/lockdep.h |    1 +
 kernel/lockdep.c        |   11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 12aabfc..ddde26f 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -58,6 +58,7 @@ struct lock_class {
 
 	struct lockdep_subclass_key	*key;
 	unsigned int			subclass;
+	unsigned int			dep_gen_id;
 
 	/*
 	 * IRQ/softirq usage tracking bits:
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1cedb00..1b1796a 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -848,14 +848,15 @@ struct circular_queue {
 };
 
 static struct circular_queue lock_cq;
-static unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
 
 unsigned int max_bfs_queue_depth;
 
+static unsigned int lockdep_dependency_gen_id;
+
 static inline void __cq_init(struct circular_queue *cq)
 {
 	cq->front = cq->rear = 0;
-	bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
+	lockdep_dependency_gen_id++;
 }
 
 static inline int __cq_empty(struct circular_queue *cq)
@@ -900,7 +901,7 @@ static inline void mark_lock_accessed(struct lock_list *lock,
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
 	lock->parent = parent;
-	set_bit(nr, bfs_accessed);
+	lock->class->dep_gen_id = lockdep_dependency_gen_id;
 }
 
 static inline unsigned long lock_accessed(struct lock_list *lock)
@@ -908,7 +909,7 @@ static inline unsigned long lock_accessed(struct lock_list *lock)
 	unsigned long nr;
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
-	return test_bit(nr, bfs_accessed);
+	return lock->class->dep_gen_id == lockdep_dependency_gen_id;
 }
 
 static inline struct lock_list *get_lock_parent(struct lock_list *child)
@@ -3491,7 +3492,7 @@ void __init lockdep_info(void)
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
 		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024
 #ifdef CONFIG_PROVE_LOCKING
-		+ sizeof(struct circular_queue) + sizeof(bfs_accessed)
+		+ sizeof(struct circular_queue)
 #endif
 		);
 
-- 
1.6.0.GIT

