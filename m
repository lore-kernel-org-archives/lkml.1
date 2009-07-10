Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZGJIo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZGJIo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZGJIoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:44:17 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62742 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZGJIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:44:16 -0400
Message-ID: <4A56FEF7.80207@ct.jp.nec.com>
Date: Fri, 10 Jul 2009 17:42:31 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC 1/2] move binfmt filed to signal_struct
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Because the binfmt is not different between threads in the same process,
it can be moved from task_struct to signal_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/exec.c             |    6 +++---
 include/linux/sched.h |    2 +-
 kernel/exit.c         |    4 ++--
 kernel/fork.c         |    7 ++++---
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4a8849e..402d3b8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1377,13 +1377,13 @@ out_ret:
 
 int set_binfmt(struct linux_binfmt *new)
 {
-	struct linux_binfmt *old = current->binfmt;
+	struct linux_binfmt *old = current->signal->binfmt;
 
 	if (new) {
 		if (!try_module_get(new->module))
 			return -1;
 	}
-	current->binfmt = new;
+	current->signal->binfmt = new;
 	if (old)
 		module_put(old->module);
 	return 0;
@@ -1730,7 +1730,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 	audit_core_dumps(signr);
 
-	binfmt = current->binfmt;
+	binfmt = current->signal->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0085d75..2a6eb81 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -576,6 +576,7 @@ struct signal_struct {
 	int leader;
 
 	struct tty_struct *tty; /* NULL if no tty */
+	struct linux_binfmt *binfmt;
 
 	/*
 	 * Cumulative resource counters for dead threads in the group,
@@ -1211,7 +1212,6 @@ struct task_struct {
 	struct mm_struct *mm, *active_mm;
 
 /* task state */
-	struct linux_binfmt *binfmt;
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
diff --git a/kernel/exit.c b/kernel/exit.c
index 628d41f..708348a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -971,8 +971,8 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->binfmt)
-		module_put(tsk->binfmt->module);
+	if (tsk->signal->binfmt)
+		module_put(tsk->signal->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 467746b..dfb9d0a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -847,6 +847,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = NULL;
 	sig->tty = NULL;
+	sig->binfmt = current->signal->binfmt;
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
@@ -1014,7 +1015,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->binfmt && !try_module_get(p->binfmt->module))
+	if (p->signal->binfmt && !try_module_get(p->signal->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
 
 	p->did_exec = 0;
@@ -1301,8 +1302,8 @@ bad_fork_cleanup_cgroup:
 #endif
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
-	if (p->binfmt)
-		module_put(p->binfmt->module);
+	if (p->signal->binfmt)
+		module_put(p->signal->binfmt->module);
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-- 
1.6.2.5

