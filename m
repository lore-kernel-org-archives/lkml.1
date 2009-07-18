Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZGROZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZGROZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZGROZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:25:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:54098 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZGROZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:25:15 -0400
Date: Sat, 18 Jul 2009 14:24:40 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <1246201486-7308-10-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-10-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Add statistics info for max bfs queue depth
Message-ID: <tip-63627e378c2ede5086d0f8927571c857777845d7@git.kernel.org>
Git-Commit-ID: 63627e378c2ede5086d0f8927571c857777845d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:24:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63627e378c2ede5086d0f8927571c857777845d7
Gitweb:     http://git.kernel.org/tip/63627e378c2ede5086d0f8927571c857777845d7
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 16:02:56 +0200

lockdep: Add statistics info for max bfs queue depth

Add BFS statistics to the existing lockdep stats.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1246201486-7308-10-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c           |    6 +++++-
 kernel/lockdep_internals.h |    3 ++-
 kernel/lockdep_proc.c      |    2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 930335d..41ceaa1 100644
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
