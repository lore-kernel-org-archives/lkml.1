Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZGROYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZGROYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZGROYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:24:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:54003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZGROYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:24:01 -0400
Date: Sat, 18 Jul 2009 14:23:24 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Introduce match function to BFS
Message-ID: <tip-451641e4e36a6a207fffbbe5628ddd1fda400387@git.kernel.org>
Git-Commit-ID: 451641e4e36a6a207fffbbe5628ddd1fda400387
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:23:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  451641e4e36a6a207fffbbe5628ddd1fda400387
Gitweb:     http://git.kernel.org/tip/451641e4e36a6a207fffbbe5628ddd1fda400387
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 16:02:53 +0200

lockdep: Introduce match function to BFS

1,introduce match() to BFS in order to make it usable to
match different pattern;

2,also rename some functions to make them more suitable.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5dcca26..ce6d09e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -900,17 +900,18 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
 static struct circular_queue  lock_cq;
 
-static int __search_shortest_path(struct lock_list *source_entry,
-				struct lock_class *target,
-				struct lock_list **target_entry,
-				int forward)
+static int __bfs(struct lock_list *source_entry,
+			void *data,
+			int (*match)(struct lock_list *entry, void *data),
+			struct lock_list **target_entry,
+			int forward)
 {
 	struct lock_list *entry;
 	struct list_head *head;
 	struct circular_queue *cq = &lock_cq;
 	int ret = 1;
 
-	if (source_entry->class == target) {
+	if (match(source_entry, data)) {
 		*target_entry = source_entry;
 		ret = 0;
 		goto exit;
@@ -945,7 +946,7 @@ static int __search_shortest_path(struct lock_list *source_entry,
 		list_for_each_entry(entry, head, entry) {
 			if (!lock_accessed(entry)) {
 				mark_lock_accessed(entry, lock);
-				if (entry->class == target) {
+				if (match(entry, data)) {
 					*target_entry = entry;
 					ret = 0;
 					goto exit;
@@ -962,19 +963,21 @@ exit:
 	return ret;
 }
 
-static inline int __search_forward_shortest_path(struct lock_list *src_entry,
-				struct lock_class *target,
-				struct lock_list **target_entry)
+static inline int __bfs_forward(struct lock_list *src_entry,
+			void *data,
+			int (*match)(struct lock_list *entry, void *data),
+			struct lock_list **target_entry)
 {
-	return __search_shortest_path(src_entry, target, target_entry, 1);
+	return __bfs(src_entry, data, match, target_entry, 1);
 
 }
 
-static inline int __search_backward_shortest_path(struct lock_list *src_entry,
-				struct lock_class *target,
-				struct lock_list **target_entry)
+static inline int __bfs_backward(struct lock_list *src_entry,
+			void *data,
+			int (*match)(struct lock_list *entry, void *data),
+			struct lock_list **target_entry)
 {
-	return __search_shortest_path(src_entry, target, target_entry, 0);
+	return __bfs(src_entry, data, match, target_entry, 0);
 
 }
 
@@ -1035,6 +1038,11 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth)
 	return 0;
 }
 
+static inline int class_equal(struct lock_list *entry, void *data)
+{
+	return entry->class == data;
+}
+
 static noinline int print_circular_bug(void)
 {
 	struct task_struct *curr = current;
@@ -1052,9 +1060,10 @@ static noinline int print_circular_bug(void)
 	if (!save_trace(&this.trace))
 		return 0;
 
-	result = __search_forward_shortest_path(&this,
-						hlock_class(check_target),
-						&target);
+	result = __bfs_forward(&this,
+			hlock_class(check_target),
+			class_equal,
+			&target);
 	if (result) {
 		printk("\n%s:search shortest path failed:%d\n", __func__,
 			result);
