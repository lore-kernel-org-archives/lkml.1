Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZEEXc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZEEXc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZEEXcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:32:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbZEEXcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:32:47 -0400
Date: Wed, 6 May 2009 01:28:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace_get_task_struct: s/tasklist/rcu/, make it static
Message-ID: <20090505232820.GA4377@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use rcu_read_lock() instead of tasklist_lock to find/get the task
  in ptrace_get_task_struct().

- Make it static, it has no callers outside of ptrace.c.

- The comment doesn't match the reality, this helper does not do
  any checks. Beacuse it is really trivial and static I removed the
  whole comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |    1 -
 kernel/ptrace.c        |   16 +++-------------
 2 files changed, 3 insertions(+), 14 deletions(-)

--- PTRACE/include/linux/ptrace.h~4_GET	2009-04-06 00:03:41.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-06 01:09:58.000000000 +0200
@@ -81,7 +81,6 @@
 
 
 extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
-extern struct task_struct *ptrace_get_task_struct(pid_t pid);
 extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
--- PTRACE/kernel/ptrace.c~4_GET	2009-05-06 00:16:17.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-06 01:18:19.000000000 +0200
@@ -587,26 +587,16 @@ int ptrace_request(struct task_struct *c
 	return ret;
 }
 
-/**
- * ptrace_get_task_struct  --  grab a task struct reference for ptrace
- * @pid:       process id to grab a task_struct reference of
- *
- * This function is a helper for ptrace implementations.  It checks
- * permissions and then grabs a task struct for use of the actual
- * ptrace implementation.
- *
- * Returns the task_struct for @pid or an ERR_PTR() on failure.
- */
-struct task_struct *ptrace_get_task_struct(pid_t pid)
+static struct task_struct *ptrace_get_task_struct(pid_t pid)
 {
 	struct task_struct *child;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	child = find_task_by_vpid(pid);
 	if (child)
 		get_task_struct(child);
+	rcu_read_unlock();
 
-	read_unlock(&tasklist_lock);
 	if (!child)
 		return ERR_PTR(-ESRCH);
 	return child;

