Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZLUBUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZLUBUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZLUBU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:20:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37712 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZLUBU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:28 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091221220.243954235@firstfloor.org>
In-Reply-To: <20091221220.243954235@firstfloor.org>
To: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com
Subject: [PATCH] [4/11] SYSCTL: Use RCU strings for core_pattern sysctl
Message-Id: <20091221012025.A2FA2B158A@basil.firstfloor.org>
Date: Mon, 21 Dec 2009 02:20:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As a bonus this removes one use of the BKL.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/exec.c       |    9 ++++-----
 kernel/sysctl.c |    6 +++---
 2 files changed, 7 insertions(+), 8 deletions(-)

Index: linux-2.6.33-rc1-ak/fs/exec.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/fs/exec.c
+++ linux-2.6.33-rc1-ak/fs/exec.c
@@ -62,7 +62,7 @@
 #include "internal.h"
 
 int core_uses_pid;
-char core_pattern[CORENAME_MAX_SIZE] = "core";
+char *core_pattern = "core";
 unsigned int core_pipe_limit;
 int suid_dumpable = 0;
 
@@ -1825,12 +1825,11 @@ void do_coredump(long signr, int exit_co
 	clear_thread_flag(TIF_SIGPENDING);
 
 	/*
-	 * lock_kernel() because format_corename() is controlled by sysctl, which
-	 * uses lock_kernel()
+	 * Protect corename by RCU vs proc_rcu_string()
 	 */
- 	lock_kernel();
+	rcu_read_lock();
 	ispipe = format_corename(corename, signr);
-	unlock_kernel();
+	rcu_read_unlock();
 
 	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
 		goto fail_unlock;
Index: linux-2.6.33-rc1-ak/kernel/sysctl.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/sysctl.c
+++ linux-2.6.33-rc1-ak/kernel/sysctl.c
@@ -75,7 +75,7 @@ extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
-extern char core_pattern[];
+extern char *core_pattern;
 extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
@@ -399,10 +399,10 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname	= "core_pattern",
-		.data		= core_pattern,
+		.data		= &core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 	{
 		.procname	= "core_pipe_limit",
