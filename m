Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZGJIou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZGJIou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZGJIok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:44:40 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:63157 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbZGJIoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:44:39 -0400
Message-ID: <4A56FF33.2080508@ct.jp.nec.com>
Date: Fri, 10 Jul 2009 17:43:31 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC 2/2] make binfmt module get and put per signal_struct
References: <4A56FEF7.80207@ct.jp.nec.com>
In-Reply-To: <4A56FEF7.80207@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The binfmt is a member of signal_struct, so it can be handled per
signal_struct instead of task_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/exit.c |    2 --
 kernel/fork.c |   12 ++++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 708348a..187a211 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -971,8 +971,6 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->signal->binfmt)
-		module_put(tsk->signal->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index dfb9d0a..636c06f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -848,6 +848,10 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->tty_old_pgrp = NULL;
 	sig->tty = NULL;
 	sig->binfmt = current->signal->binfmt;
+	if (sig->binfmt && !try_module_get(sig->binfmt->module)) {
+		kmem_cache_free(signal_cachep, sig);
+		return -EAGAIN;
+	}
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
@@ -876,6 +880,8 @@ void __cleanup_signal(struct signal_struct *sig)
 {
 	thread_group_cputime_free(sig);
 	tty_kref_put(sig->tty);
+	if (sig->binfmt)
+		module_put(sig->binfmt->module);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1015,9 +1021,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->signal->binfmt && !try_module_get(p->signal->binfmt->module))
-		goto bad_fork_cleanup_put_domain;
-
 	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
@@ -1302,9 +1305,6 @@ bad_fork_cleanup_cgroup:
 #endif
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
-	if (p->signal->binfmt)
-		module_put(p->signal->binfmt->module);
-bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
-- 
1.6.2.5

