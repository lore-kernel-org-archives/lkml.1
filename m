Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbZEaOuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbZEaOuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbZEaOtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:49:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:17323 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573AbZEaOtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UqTpLOWidMyBJfyzPdDkuWtCxd6lxmmwxcVL/nvmG2vSNm41Ah7sOX5QXGcZBHgiBy
         Qhf/cxc0FZwUFae65DTr2dVvcjrASu7aI/1BBE7OcigbI+zEF+6PkOrWnF6uixZ4DE9E
         /IaV0+Gjfg+0qizai7pPStO2OkbXBu7B5zjRg=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/8] kernel:lockdep: introduce match function to BFS
Date: Sun, 31 May 2009 22:49:19 +0800
Message-Id: <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
References: <yes>
 <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

1,introduce match() to BFS in order to make it usable to
match different pattern;

2,also rename some functions to make them more suitable.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
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
-- 
1.6.0.GIT

