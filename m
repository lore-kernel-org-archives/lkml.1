Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYCPPvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYCPPvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 11:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYCPPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 11:50:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35768 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYCPPug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 11:50:36 -0400
Date: Sun, 16 Mar 2008 18:54:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ptrace: it is fun to strace /sbin/init
Message-ID: <20080316155455.GA20848@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ptracing of /sbin/init is not allowed. Of course, this is very dangerous, but
may be useful. Introduce the kernel boot parameter to allow this.

Note that it is really dangerous, also because init can lose SIGNAL_UNKILLABLE
flag. But this is because we are not careful enough with setting signal->flags,
this should be cleanuped anyway.

Unless I missed something, ptrace_get_task_struct() is pointless. It does not
need to check "pid == 1", ptrace_attach() does this. It doesn't need tasklist.
It should be replaced with the generic find_get_task_by_vpid() which does not
exist yet.

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
 
+	init_ptrace	[KNL] Allows to ptrace init. Very dangerous. Don't use.
+
 	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
 			for working out where the kernel is dying during
 			startup.

