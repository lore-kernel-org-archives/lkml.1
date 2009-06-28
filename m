Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZF1PHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZF1PHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbZF1PGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:06:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:55103 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbZF1PGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UKh2qM7vChTaupB/DzyHOMfKUwj9TZ49zl+x6FLN64QjtwFBYC5ZhbmFhQkpNBXAT+
         nBDGxvMzC8koUvdxcz11KTVZ1hHmoxH5Mv91rGkL6+GI3yvr7oUtoj5B0yxTizQ5TzPQ
         kgQuXeOan1Lhu6oQyPOVEMFmvstMO013OEgMg=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [RESEND PATCH 09/11] kernel:lockdep:add statistics info for max bfs queue depth
Date: Sun, 28 Jun 2009 23:04:44 +0800
Message-Id: <1246201486-7308-10-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-5-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-6-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-7-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c           |    6 +++++-
 kernel/lockdep_internals.h |    3 ++-
 kernel/lockdep_proc.c      |    2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index faa39cb..b20f08b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -929,7 +929,7 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 
 unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
 static struct circular_queue  lock_cq;
-
+unsigned int max_bfs_queue_depth;
 static int __bfs(struct lock_list *source_entry,
 			void *data,
 			int (*match)(struct lock_list *entry, void *data),
@@ -975,6 +975,7 @@ static int __bfs(struct lock_list *source_entry,
 
 		list_for_each_entry(entry, head, entry) {
 			if (!lock_accessed(entry)) {
+				unsigned int cq_depth;
 				mark_lock_accessed(entry, lock);
 				if (match(entry, data)) {
 					*target_entry = entry;
@@ -986,6 +987,9 @@ static int __bfs(struct lock_list *source_entry,
 					ret = -1;
 					goto exit;
 				}
+				cq_depth = __cq_get_elem_count(cq);
+				if (max_bfs_queue_depth < cq_depth)
+					max_bfs_queue_depth = cq_depth;
 			}
 		}
 	}
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index b115aaa..6baa880 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -138,6 +138,7 @@ extern atomic_t nr_find_usage_backwards_recursions;
 #endif
 
 
+extern unsigned int max_bfs_queue_depth;
 extern unsigned long nr_list_entries;
 extern struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 extern unsigned long bfs_accessed[];
@@ -191,7 +192,7 @@ static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
 	return 0;
 }
 
-static inline int __cq_get_elem_count(struct circular_queue *cq)
+static inline unsigned int  __cq_get_elem_count(struct circular_queue *cq)
 {
 	return (cq->rear - cq->front)&(MAX_CIRCULAR_QUE_SIZE-1);
 }
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d7135aa..9a1bf34 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -411,6 +411,8 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			max_lockdep_depth);
 	seq_printf(m, " max recursion depth:           %11u\n",
 			max_recursion_depth);
+	seq_printf(m, " max bfs queue depth:           %11u\n",
+			max_bfs_queue_depth);
 	lockdep_stats_debug_show(m);
 	seq_printf(m, " debug_locks:                   %11u\n",
 			debug_locks);
-- 
1.6.0.GIT

