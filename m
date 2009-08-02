Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZHBNDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZHBNDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZHBNDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:03:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:56445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZHBNDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:03:06 -0400
Date: Sun, 2 Aug 2009 13:02:38 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Implement lockdep_count_*ward_deps by BFS
Message-ID: <tip-ef681026ff85c49b7399ceec3eb62bbbcce605e8@git.kernel.org>
Git-Commit-ID: ef681026ff85c49b7399ceec3eb62bbbcce605e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:02:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef681026ff85c49b7399ceec3eb62bbbcce605e8
Gitweb:     http://git.kernel.org/tip/ef681026ff85c49b7399ceec3eb62bbbcce605e8
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Peter Zijlstra <a.p.zijlstra@chello.nl>
CommitDate: Fri, 24 Jul 2009 10:49:56 +0200

lockdep: Implement lockdep_count_*ward_deps by BFS

Implement lockdep_count_{for,back}ward using BFS.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |   52 +++++++++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 938dc50..b896f23 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1115,61 +1115,59 @@ static noinline int print_bfs_bug(int ret)
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
 
