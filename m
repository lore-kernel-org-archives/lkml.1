Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYCWNrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYCWNrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 09:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbYCWNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 09:46:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56022 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757541AbYCWNq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 09:46:58 -0400
Date: Sun, 23 Mar 2008 16:51:10 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Pavel Machek <pavel@ucw.cz>,
       Stephen Smalley <sds@tycho.nsa.gov>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080323135110.GA294@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-send with updated changelog)

Ptracing of /sbin/init is not allowed. Of course, this is dangerous, but may
be useful. Introduce the kernel boot parameter to allow this, so that we can't
surprise some special/secured systems.

Afaics, with the recent changes there is no kernel problems with ptracing init,
it can't lose SIGNAL_UNKILLABLE flag and be killed by accident. However, admin
should know what it does, "gdb /sbin/init 1" stops init, it can't reap zombies
or take care of /etc/inittab until continued. It is even possible to crash init
(and thus the whole system) if you wish, ptracer has full control.

The "if (pid == 1)" check in ptrace_get_task_struct() is killed, ptrace_attach
does the same check.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/ptrace.c~5_INIT_PTRACE	2008-03-16 17:22:04.000000000 +0300
+++ 25/kernel/ptrace.c	2008-03-16 18:33:02.000000000 +0300
@@ -160,6 +160,15 @@ int ptrace_may_attach(struct task_struct
 	return !err;
 }
 
+static int allow_ptrace_init;
+
+static int __init __allow_ptrace_init(char *str)
+{
+	allow_ptrace_init = 1;
+	return 1;
+}
+__setup("init_ptrace", __allow_ptrace_init);
+
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
@@ -168,7 +177,7 @@ int ptrace_attach(struct task_struct *ta
 	audit_ptrace(task);
 
 	retval = -EPERM;
-	if (task->pid <= 1)
+	if (unlikely(is_global_init(task)) && likely(!allow_ptrace_init))
 		goto out;
 	if (same_thread_group(task, current))
 		goto out;
@@ -518,12 +527,6 @@ struct task_struct *ptrace_get_task_stru
 {
 	struct task_struct *child;
 
-	/*
-	 * Tracing init is not allowed.
-	 */
-	if (pid == 1)
-		return ERR_PTR(-EPERM);
-
 	read_lock(&tasklist_lock);
 	child = find_task_by_vpid(pid);
 	if (child)
--- 25/Documentation/kernel-parameters.txt~5_INIT_PTRACE	2008-02-15 16:58:12.000000000 +0300
+++ 25/Documentation/kernel-parameters.txt	2008-03-16 18:30:28.000000000 +0300
@@ -803,6 +803,8 @@ and is between 256 and 4096 characters. 
 			Run specified binary instead of /sbin/init as init
 			process.
 
+	init_ptrace	[KNL] Allows to ptrace init.
+
 	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
 			for working out where the kernel is dying during
 			startup.

