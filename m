Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbYFIXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbYFIXqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYFIXqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:46:34 -0400
Received: from [78.13.68.104] ([78.13.68.104]:39600 "EHLO linux.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754325AbYFIXqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:46:34 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [RFC PATCH 5/5] refresh VM committed space after a task migration
Date: Tue, 10 Jun 2008 01:33:03 +0200
Message-Id: <1213054383-18137-6-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update VM committed space statistics when a task is migrated from a cgroup to
another. To implement this feature we must keep track of the space committed by
each task (that is directly accounted in the task_struct).

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/sched.h |    3 +++
 kernel/fork.c         |    3 +++
 mm/memcontrol.c       |    6 ++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ae0be3c..8b458df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1277,6 +1277,9 @@ struct task_struct {
 	/* cg_list protected by css_set_lock and tsk->alloc_lock */
 	struct list_head cg_list;
 #endif
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	atomic_long_t vm_committed_space;
+#endif
 #ifdef CONFIG_FUTEX
 	struct robust_list_head __user *robust_list;
 #ifdef CONFIG_COMPAT
diff --git a/kernel/fork.c b/kernel/fork.c
index eaffa56..9fafbdb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -219,6 +219,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	/* One for us, one for whoever does the "release_task()" (usually parent) */
 	atomic_set(&tsk->usage,2);
 	atomic_set(&tsk->fs_excl, 0);
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	atomic_long_set(&tsk->vm_committed_space, 0);
+#endif
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	tsk->btrace_seq = 0;
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e3e34e9..bc4923e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1334,6 +1334,7 @@ static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 {
 	struct mm_struct *mm;
 	struct mem_cgroup *mem, *old_mem;
+	long committed;
 
 	if (mem_cgroup_subsys.disabled)
 		return;
@@ -1355,6 +1356,11 @@ static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 	if (!thread_group_leader(p))
 		goto out;
 
+	preempt_disable();
+	committed = atomic_long_read(&p->vm_committed_space);
+	atomic_long_sub(committed, &old_mem->vmacct.vm_committed_space);
+	atomic_long_add(committed, &mem->vmacct.vm_committed_space);
+	preempt_enable();
 out:
 	mmput(mm);
 }
-- 
1.5.4.3

