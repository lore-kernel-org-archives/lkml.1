Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbZA2EdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbZA2EdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZA2Ebn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:31:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbZA2Ebl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:31:41 -0500
Date: Thu, 29 Jan 2009 05:29:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ptrace: fix possible zombie leak on PTRACE_DETACH
Message-ID: <20090129042923.GA5118@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ptrace_detach() takes tasklist, the tracee can be SIGKILL'ed.
If it has already passed exit_notify() we can leak a zombie, because
a) ptracing disables the auto-reaping logic, and b) ->real_parent
was not notified about the child's death.

ptrace_detach() should follow the ptrace_exit's logic, change the
code accordingly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/include/linux/ptrace.h~4_DETACH_FIX_ZOMBIE_LEAK	2009-01-12 23:07:48.000000000 +0100
+++ 6.29-rc3/include/linux/ptrace.h	2009-01-29 04:30:50.000000000 +0100
@@ -94,6 +94,7 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
+extern int __ptrace_detach(struct task_struct *tracer, struct task_struct *p);
 extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
--- 6.29-rc3/kernel/ptrace.c~4_DETACH_FIX_ZOMBIE_LEAK	2009-01-29 03:24:51.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-01-29 04:39:48.000000000 +0100
@@ -237,6 +237,8 @@ out:
 
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
+	int dead = 0;
+
 	if (!valid_signal(data))
 		return -EIO;
 
@@ -244,18 +246,21 @@ int ptrace_detach(struct task_struct *ch
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	/* protect against de_thread()->release_task() */
 	write_lock_irq(&tasklist_lock);
+	/* protect against de_thread()->release_task() */
 	if (child->ptrace) {
 		child->exit_code = data;
 
-		__ptrace_unlink(child);
+		dead = __ptrace_detach(current, child);
 
 		if (!child->exit_state)
 			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 
+	if (unlikely(dead))
+		release_task(child);
+
 	return 0;
 }
 

