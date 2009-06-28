Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZF1PFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZF1PFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbZF1PFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:05:19 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58849 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbZF1PFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PbEWRf5DEwoElNtciDGJSuvBx0BFX3IPhlSZ0gKjeSJg3LE9ksrOxSkcLBtz8vmKHq
         HKuPSIPukBYsJphlQhoc6Y023pOor0bnkgmOvxm2pV0a/ptIaYsQSQjUDpwPG2nNA8sT
         whZ2TBa4aEDC0hcFMlHDn5qQOC0MMZl0Sl5mU=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [RESEND PATCH 03/11] kernel:lockdep: introduce match function to BFS
Date: Sun, 28 Jun 2009 23:04:38 +0800
Message-Id: <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
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

