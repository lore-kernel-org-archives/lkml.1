Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZF1PGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZF1PGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZF1PF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:05:56 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58849 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbZF1PFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ps6tx4eb8Zb4hz/V9AKKA7XnraGh3BRn7DJ+LXIMEQsEjAFwMXyNs1Fpe911uChigs
         vNaflz+EFoZIzbcfip285no91Djh0KIOizeCzinwWUfsPTDyhIURBZ3k1ygyNwVWnpht
         R5PxDMudB91RNZWRQ6q6O1Fr8Qzj4TtzF5fUo=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [RESEND PATCH 07/11] kernel:lockdep: implement lockdep_count_*ward_deps by BFS
Date: Sun, 28 Jun 2009 23:04:42 +0800
Message-Id: <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246201486-7308-7-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-5-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-6-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-7-git-send-email-tom.leiming@gmail.com>
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

