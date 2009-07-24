Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbZGXEXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbZGXEXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZGXEXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:23:09 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44566 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZGXEXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:23:08 -0400
Message-ID: <4A693569.1090009@ct.jp.nec.com>
Date: Fri, 24 Jul 2009 13:15:37 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] task_struct cleanup: move binfmt field to mm_struct
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com>
In-Reply-To: <4A68FD3B.7040606@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Because the binfmt is not different between threads in the same process,
it can be moved from task_struct to mm_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/exec.c                |   10 +++++++---
 include/linux/mm_types.h |    2 ++
 include/linux/sched.h    |    1 -
 kernel/exit.c            |    5 +++--
 kernel/fork.c            |    6 +++---
 5 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4a8849e..75441aa 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1377,13 +1377,17 @@ out_ret:
 
 int set_binfmt(struct linux_binfmt *new)
 {
-	struct linux_binfmt *old = current->binfmt;
+	struct linux_binfmt *old;
 
+	if (!current->mm)
+		return -1;
+
+	old = current->mm->binfmt;
 	if (new) {
 		if (!try_module_get(new->module))
 			return -1;
 	}
-	current->binfmt = new;
+	current->mm->binfmt = new;
 	if (old)
 		module_put(old->module);
 	return 0;
@@ -1730,7 +1734,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 	audit_core_dumps(signr);
 
-	binfmt = current->binfmt;
+	binfmt = current->mm ? current->mm->binfmt : NULL;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 7acc843..6719040 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -240,6 +240,8 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+	struct linux_binfmt *binfmt;
+
 	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
 
 	cpumask_t cpu_vm_mask;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3ab08e4..940b070 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1220,7 +1220,6 @@ struct task_struct {
 	struct mm_struct *mm, *active_mm;
 
 /* task state */
-	struct linux_binfmt *binfmt;
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
diff --git a/kernel/exit.c b/kernel/exit.c
index 869dc22..07524fa 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -953,6 +953,9 @@ NORET_TYPE void do_exit(long code)
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
+	if (tsk->mm && tsk->mm->binfmt)
+		module_put(tsk->mm->binfmt->module);
+
 	exit_mm(tsk);
 
 	if (group_dead)
@@ -970,8 +973,6 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->binfmt)
-		module_put(tsk->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index fe2b1aa..b81223a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1008,7 +1008,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->binfmt && !try_module_get(p->binfmt->module))
+	if (p->mm && p->mm->binfmt && !try_module_get(p->mm->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
 
 	p->did_exec = 0;
@@ -1295,8 +1295,8 @@ bad_fork_cleanup_cgroup:
 #endif
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
-	if (p->binfmt)
-		module_put(p->binfmt->module);
+	if (p->mm && p->mm->binfmt)
+		module_put(p->mm->binfmt->module);
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-- 
1.6.3.3

