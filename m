Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbXKUQAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbXKUQAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbXKUQAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:00:12 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60028 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977AbXKUQAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:00:10 -0500
Date: Wed, 21 Nov 2007 19:00:26 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/3] kill PT_ATTACHED
Message-ID: <20071121160026.GA1172@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the patch

	"Fix ptrace_attach()/ptrace_traceme()/de_thread() race"
	commit f5b40e363ad6041a96e3da32281d8faa191597b9

we set PT_ATTACHED and change child->parent "atomically" wrt task_list lock.

This means we can remove the checks like "PT_ATTACHED && ->parent != ptracer"
which were needed to catch the "ptrace attach is in progress" case. We can also
remove the flag itself since nobody else uses it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/include/linux/ptrace.h~1_PT_ATTACHED	2007-11-21 16:41:25.000000000 +0300
+++ PT/include/linux/ptrace.h	2007-11-21 16:50:39.000000000 +0300
@@ -67,7 +67,6 @@
 #define PT_TRACE_EXEC	0x00000080
 #define PT_TRACE_VFORK_DONE	0x00000100
 #define PT_TRACE_EXIT	0x00000200
-#define PT_ATTACHED	0x00000400	/* parent != real_parent */
 
 #define PT_TRACE_MASK	0x000003f4
 
--- PT/kernel/ptrace.c~1_PT_ATTACHED	2007-11-21 16:41:25.000000000 +0300
+++ PT/kernel/ptrace.c	2007-11-21 16:53:39.000000000 +0300
@@ -100,8 +100,7 @@ int ptrace_check_attach(struct task_stru
 	 */
 	read_lock(&tasklist_lock);
 	if ((child->ptrace & PT_PTRACED) && child->parent == current &&
-	    (!(child->ptrace & PT_ATTACHED) || child->real_parent != current)
-	    && child->signal != NULL) {
+	     child->signal != NULL) {
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
 		if (is_task_stopped(child))
@@ -200,8 +199,7 @@ repeat:
 		goto bad;
 
 	/* Go */
-	task->ptrace |= PT_PTRACED | ((task->real_parent != current)
-				      ? PT_ATTACHED : 0);
+	task->ptrace |= PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
--- PT/kernel/signal.c~1_PT_ATTACHED	2007-11-21 16:41:25.000000000 +0300
+++ PT/kernel/signal.c	2007-11-21 16:50:39.000000000 +0300
@@ -1577,11 +1577,6 @@ static inline int may_ptrace_stop(void)
 {
 	if (!likely(current->ptrace & PT_PTRACED))
 		return 0;
-
-	if (unlikely(current->parent == current->real_parent &&
-		    (current->ptrace & PT_ATTACHED)))
-		return 0;
-
 	/*
 	 * Are we in the middle of do_coredump?
 	 * If so and our tracer is also part of the coredump stopping
--- PT/kernel/exit.c~1_PT_ATTACHED	2007-11-21 16:41:25.000000000 +0300
+++ PT/kernel/exit.c	2007-11-21 16:50:39.000000000 +0300
@@ -1511,18 +1511,7 @@ static int wait_task_continued(struct ta
 
 static inline int my_ptrace_child(struct task_struct *p)
 {
-	if (!(p->ptrace & PT_PTRACED))
-		return 0;
-	if (!(p->ptrace & PT_ATTACHED))
-		return 1;
-	/*
-	 * This child was PTRACE_ATTACH'd.  We should be seeing it only if
-	 * we are the attacher.  If we are the real parent, this is a race
-	 * inside ptrace_attach.  It is waiting for the tasklist_lock,
-	 * which we have to switch the parent links, but has already set
-	 * the flags in p->ptrace.
-	 */
-	return (p->parent != p->real_parent);
+	return p->ptrace & PT_PTRACED;
 }
 
 static long do_wait(pid_t pid, int options, struct siginfo __user *infop,

