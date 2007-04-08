Return-Path: <linux-kernel-owner+w=401wt.eu-S1751209AbXDHPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbXDHPzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXDHPzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:55:25 -0400
Received: from mail.screens.ru ([213.234.233.54]:37418 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbXDHPzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:55:24 -0400
Date: Sun, 8 Apr 2007 19:55:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC, PATCH 2/3] implement CLONE_KERNEL_THREAD flag
Message-ID: <20070408155513.GA129@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For review only.

We have some problems with the kernel threads parented to /sbin/init, see

	http://marc.info/?t=117580282200003&r=1
	http://marc.info/?t=95299284800003&r=1

A task created with CLONE_KERNEL_THREAD will have swapper as its parent.
Note that this is only the first step, we can extend the meaning of this
flag to also use init_task for copy_mm/copy_files/etc.

	arch/sparc/kernel/process.c
	arch/sparc64/kernel/process.c
	arch/m68knommu/kernel/process.c
	arch/m68k/kernel/process.c
	arch/alpha/kernel/entry.S
	arch/h8300/kernel/process.c
	arch/v850/kernel/process.c
	arch/frv/kernel/kernel_thread.S
	arch/frv/kernel/kernel_thread.S
	arch/powerpc/kernel/misc_32.S
	arch/powerpc/kernel/misc_64.S

implement kthread_create() via sys_clone(). This means that these arches can't
take advantage of CLONE_KERNEL_THREAD, it will be filtered out by sys_clone().

This patch breaks arch/ia64/, its sys_clone() was not converted by the previous
patch, so user-space can do sys_clone(CLONE_KERNEL_THREAD).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    5 ++++-
 kernel/fork.c         |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- 2.6.21-rc5-mm4/include/linux/sched.h~2_IMPL	2007-04-07 22:07:50.000000000 +0400
+++ 2.6.21-rc5-mm4/include/linux/sched.h	2007-04-08 18:53:51.000000000 +0400
@@ -28,7 +28,10 @@
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 
 /* user-space visible */
-#define SYS_CLONE_MASK		(~0x0)
+#define SYS_CLONE_MASK		(~(CLONE_KERNEL_THREAD))
+
+/* for in kernel use only */
+#define CLONE_KERNEL_THREAD	0x20000000	/* hide from init */
 
 /*
  * Scheduling policies
--- 2.6.21-rc5-mm4/kernel/fork.c~2_IMPL	2007-04-07 23:56:08.000000000 +0400
+++ 2.6.21-rc5-mm4/kernel/fork.c	2007-04-08 18:55:42.000000000 +0400
@@ -1159,7 +1159,8 @@ static struct task_struct *copy_process(
 	p->parent_exec_id = p->self_exec_id;
 
 	/* ok, now we should be set up.. */
-	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
+	p->exit_signal = (clone_flags & (CLONE_THREAD|CLONE_KERNEL_THREAD))
+					? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
 
@@ -1196,6 +1197,8 @@ static struct task_struct *copy_process(
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
 		p->parent = current->parent;
+	else if (unlikely(clone_flags & CLONE_KERNEL_THREAD))
+		p->parent = &init_task;
 	else
 		p->parent = current;
 

