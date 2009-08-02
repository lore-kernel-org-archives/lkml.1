Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZHBNxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZHBNxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZHBNxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:53:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:50215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZHBNxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:53:14 -0400
Date: Sun, 2 Aug 2009 13:52:36 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, davem@davemloft.net, tglx@linutronix.de,
       tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, davem@davemloft.net, tglx@linutronix.de,
       tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <1248274089-6358-1-git-send-email-tom.leiming@gmail.com>
References: <1248274089-6358-1-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Reintroduce generation count to make BFS faster
Message-ID: <tip-e351b660fddd4df76cc4635f896d311ed0ff3752@git.kernel.org>
Git-Commit-ID: e351b660fddd4df76cc4635f896d311ed0ff3752
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:52:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e351b660fddd4df76cc4635f896d311ed0ff3752
Gitweb:     http://git.kernel.org/tip/e351b660fddd4df76cc4635f896d311ed0ff3752
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Wed, 22 Jul 2009 22:48:09 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 15:41:37 +0200

lockdep: Reintroduce generation count to make BFS faster

We still can apply DaveM's generation count optimization to
BFS, based on the following idea:

 - before doing each BFS, increase the global generation id
   by 1

 - if one node in the graph has been visited, mark it as
   visited by storing the current global generation id into
   the node's dep_gen_id field

 - so we can decide if one node has been visited already, by
   comparing the node's dep_gen_id with the global generation id.

By applying DaveM's generation count optimization to current
implementation of BFS, we gain the following advantages:

 - we save MAX_LOCKDEP_ENTRIES/8 bytes memory;

 - we remove the bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
   in each BFS, which is very time-consuming since
   MAX_LOCKDEP_ENTRIES may be very large.(16384UL)

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "David S. Miller" <davem@davemloft.net>
LKML-Reference: <1248274089-6358-1-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/lockdep.h |    1 +
 kernel/lockdep.c        |   11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 47d42ef..9ccf0e2 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -58,6 +58,7 @@ struct lock_class {
 
 	struct lockdep_subclass_key	*key;
 	unsigned int			subclass;
+	unsigned int			dep_gen_id;
 
 	/*
 	 * IRQ/softirq usage tracking bits:
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0bb246e..2b443b5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -861,14 +861,15 @@ struct circular_queue {
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
@@ -914,7 +915,7 @@ static inline void mark_lock_accessed(struct lock_list *lock,
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
 	lock->parent = parent;
-	set_bit(nr, bfs_accessed);
+	lock->class->dep_gen_id = lockdep_dependency_gen_id;
 }
 
 static inline unsigned long lock_accessed(struct lock_list *lock)
@@ -923,7 +924,7 @@ static inline unsigned long lock_accessed(struct lock_list *lock)
 
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
-	return test_bit(nr, bfs_accessed);
+	return lock->class->dep_gen_id == lockdep_dependency_gen_id;
 }
 
 static inline struct lock_list *get_lock_parent(struct lock_list *child)
@@ -3604,7 +3605,7 @@ void __init lockdep_info(void)
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
 		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024
 #ifdef CONFIG_PROVE_LOCKING
-		+ sizeof(struct circular_queue) + sizeof(bfs_accessed)
+		+ sizeof(struct circular_queue)
 #endif
 		);
 
