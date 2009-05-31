Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbZEaOvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbZEaOvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759124AbZEaOu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:50:26 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:45632 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759105AbZEaOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NBZvTwzMuA6xJtBr4VkE7r8p4fXWpqLwulCU1WQzcaU7QDwnPaJArw7mhm9cyviIpL
         ETYxhTsc5ZrGdBmugkRr0h+1k7Z0IXmCk9k6N48mKLyojv9HioVnn8JYR9jiEk1z3LsX
         DtrA4/qZUHxXBN+S72OIs6mQ7yKXqIk4p83s0=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 6/8] kernel:lockdep: implement lockdep_count_*ward_deps by BFS
Date: Sun, 31 May 2009 22:49:23 +0800
Message-Id: <1243781365-26814-7-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1243781365-26814-6-git-send-email-tom.leiming@gmail.com>
References: <yes>
 <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-6-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>


Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |   52 +++++++++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index d839994..6e31e4b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1115,61 +1115,59 @@ static int noinline print_bfs_bug(int ret)
 	return 0;
 }
 
-unsigned long __lockdep_count_forward_deps(struct lock_class *class,
-					   unsigned int depth)
+static int noop_count(struct lock_list *entry, void *data)
 {
-	struct lock_list *entry;
-	unsigned long ret = 1;
+	(*(unsigned long *)data)++;
+	return 0;
+}
 
-	if (lockdep_dependency_visit(class, depth))
-		return 0;
+unsigned long __lockdep_count_forward_deps(struct lock_list *this)
+{
+	unsigned long  count = 0;
+	struct lock_list *uninitialized_var(target_entry);
 
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_after, entry)
-		ret += __lockdep_count_forward_deps(entry->class, depth + 1);
+	__bfs_forwards(this, (void *)&count, noop_count, &target_entry);
 
-	return ret;
+	return count;
 }
-
 unsigned long lockdep_count_forward_deps(struct lock_class *class)
 {
 	unsigned long ret, flags;
+	struct lock_list this;
+
+	this.parent = NULL;
+	this.class = class;
 
 	local_irq_save(flags);
 	__raw_spin_lock(&lockdep_lock);
-	ret = __lockdep_count_forward_deps(class, 0);
+	ret = __lockdep_count_forward_deps(&this);
 	__raw_spin_unlock(&lockdep_lock);
 	local_irq_restore(flags);
 
 	return ret;
 }
 
-unsigned long __lockdep_count_backward_deps(struct lock_class *class,
-					    unsigned int depth)
+unsigned long __lockdep_count_backward_deps(struct lock_list *this)
 {
-	struct lock_list *entry;
-	unsigned long ret = 1;
+	unsigned long  count = 0;
+	struct lock_list *uninitialized_var(target_entry);
 
-	if (lockdep_dependency_visit(class, depth))
-		return 0;
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_before, entry)
-		ret += __lockdep_count_backward_deps(entry->class, depth + 1);
+	__bfs_backwards(this, (void *)&count, noop_count, &target_entry);
 
-	return ret;
+	return count;
 }
 
 unsigned long lockdep_count_backward_deps(struct lock_class *class)
 {
 	unsigned long ret, flags;
+	struct lock_list this;
+
+	this.parent = NULL;
+	this.class = class;
 
 	local_irq_save(flags);
 	__raw_spin_lock(&lockdep_lock);
-	ret = __lockdep_count_backward_deps(class, 0);
+	ret = __lockdep_count_backward_deps(&this);
 	__raw_spin_unlock(&lockdep_lock);
 	local_irq_restore(flags);
 
-- 
1.6.0.GIT

