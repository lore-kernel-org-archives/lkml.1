Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYCZXIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYCZXIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYCZXIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:08:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYCZXIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:08:36 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] procfs mem permission cleanup
X-Shopping-List: (1) Musical global vagrant lotion
   (2) Ancient obsessions
   (3) Throwaway fads
   (4) Cognizant auctions
   (5) Concurrent load putty
Message-Id: <20080326230727.8802C26FA1C@magilla.localdomain>
Date: Wed, 26 Mar 2008 16:07:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the permission checks done for /proc/PID/mem i/o calls.
It puts all the logic in a new function, check_mem_permission().

The old code repeated the (!MAY_PTRACE(task) || !ptrace_may_attach(task))
magical expression multiple times.  The new function does all that work
in one place, with clear comments.

The old code called security_ptrace() twice on successful checks,
once in MAY_PTRACE() and once in __ptrace_may_attach().  Now it's
only called once, and only if all other checks have succeeded.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/proc/base.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 81d7d14..299ad71 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -195,12 +195,32 @@ static int proc_root_link(struct inode *inode, struct path *path)
 	return result;
 }
 
-#define MAY_PTRACE(task) \
-	(task == current || \
-	(task->parent == current && \
-	(task->ptrace & PT_PTRACED) && \
-	 (task_is_stopped_or_traced(task)) && \
-	 security_ptrace(current,task) == 0))
+/*
+ * Return zero if current may access user memory in @task, -error if not.
+ */
+static int check_mem_permission(struct task_struct *task)
+{
+	/*
+	 * A task can always look at itself, in case it chooses
+	 * to use system calls instead of load instructions.
+	 */
+	if (task == current)
+		return 0;
+
+	/*
+	 * If current is actively ptrace'ing, and would also be
+	 * permitted to freshly attach with ptrace now, permit it.
+	 */
+	if (task->parent == current && (task->ptrace & PT_PTRACED) &&
+	    task_is_stopped_or_traced(task) &&
+	    ptrace_may_attach(task))
+		return 0;
+
+	/*
+	 * Noone else is allowed.
+	 */
+	return -EPERM;
+}
 
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
@@ -715,7 +735,7 @@ static ssize_t mem_read(struct file * file, char __user * buf,
 	if (!task)
 		goto out_no_task;
 
-	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
+	if (check_mem_permission(task))
 		goto out;
 
 	ret = -ENOMEM;
@@ -741,7 +761,7 @@ static ssize_t mem_read(struct file * file, char __user * buf,
 
 		this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		retval = access_process_vm(task, src, page, this_len, 0);
-		if (!retval || !MAY_PTRACE(task) || !ptrace_may_attach(task)) {
+		if (!retval || check_mem_permission(task)) {
 			if (!ret)
 				ret = -EIO;
 			break;
@@ -785,7 +805,7 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
 	if (!task)
 		goto out_no_task;
 
-	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
+	if (check_mem_permission(task))
 		goto out;
 
 	copied = -ENOMEM;
