Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbZGXEX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbZGXEX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZGXEX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:23:27 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44688 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZGXEX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:23:26 -0400
Message-ID: <4A6935E0.3080002@ct.jp.nec.com>
Date: Fri, 24 Jul 2009 13:17:36 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] task_struct cleanup: make binfmt module get and put per
 mm_struct
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com>
In-Reply-To: <4A693569.1090009@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The binfmt is a member of mm_struct, so it can be handled per mm_struct
instead of task_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/exit.c |    3 ---
 kernel/fork.c |   11 +++++------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 07524fa..77b01be 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -953,9 +953,6 @@ NORET_TYPE void do_exit(long code)
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
-	if (tsk->mm && tsk->mm->binfmt)
-		module_put(tsk->mm->binfmt->module);
-
 	exit_mm(tsk);
 
 	if (group_dead)
diff --git a/kernel/fork.c b/kernel/fork.c
index b81223a..3f3de29 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -494,6 +494,8 @@ void mmput(struct mm_struct *mm)
 			spin_unlock(&mmlist_lock);
 		}
 		put_swap_token(mm);
+		if (mm->binfmt)
+			module_put(mm->binfmt->module);
 		mmdrop(mm);
 	}
 }
@@ -619,6 +621,9 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
 
+	if (mm->binfmt && !try_module_get(mm->binfmt->module))
+		goto free_pt;
+
 	return mm;
 
 free_pt:
@@ -1008,9 +1013,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->mm && p->mm->binfmt && !try_module_get(p->mm->binfmt->module))
-		goto bad_fork_cleanup_put_domain;
-
 	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
@@ -1295,9 +1297,6 @@ bad_fork_cleanup_cgroup:
 #endif
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
-	if (p->mm && p->mm->binfmt)
-		module_put(p->mm->binfmt->module);
-bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
-- 
1.6.3.3

