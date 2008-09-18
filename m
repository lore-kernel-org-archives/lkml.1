Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYIRRtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYIRRtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYIRRs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:48:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:43790 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbYIRRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=VEs3hW/685wvIg5HhhlKw6ZGcFq1QZIf/gtWMFfwusWwc5Tl2m2ppZGdpfV9uJQ05d
         D733Z1KvDBGMGyAlKc69I3BZG0nETi5d9TvbFC1Z1itNJXwBI/m6Se65899AEOBkLOUn
         KbDIEid6NU7SYuSsOjqCwSAcmP0XLbPE1Of/8=
Message-ID: <48D29485.5010900@gmail.com>
Date: Thu, 18 Sep 2008 19:48:53 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] memrlimit: fix task_lock() recursive locking
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_mm_owner_callbacks() can be called with task_lock() held in
mm_update_next_owner(), and all the .mm_owner_changed callbacks seem to
be *always* called with task_lock() held.

Actually, memrlimit is using task_lock() via get_task_mm() in
memrlimit_cgroup_mm_owner_changed(), raising the following recursive locking
trace:

[ 5346.421365] =============================================
[ 5346.421374] [ INFO: possible recursive locking detected ]
[ 5346.421381] 2.6.27-rc5-mm1 #20
[ 5346.421385] ---------------------------------------------
[ 5346.421391] interbench/10530 is trying to acquire lock:
[ 5346.421396]  (&p->alloc_lock){--..}, at: [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421417]
[ 5346.421418] but task is already holding lock:
[ 5346.421423]  (&p->alloc_lock){--..}, at: [<ffffffff8023db98>] mm_update_next_owner+0x148/0x230
[ 5346.421438]
[ 5346.421440] other info that might help us debug this:
[ 5346.421446] 2 locks held by interbench/10530:
[ 5346.421450]  #0:  (&mm->mmap_sem){----}, at: [<ffffffff8023db90>] mm_update_next_owner+0x140/0x230
[ 5346.421467]  #1:  (&p->alloc_lock){--..}, at: [<ffffffff8023db98>] mm_update_next_owner+0x148/0x230
[ 5346.421483]
[ 5346.421485] stack backtrace:
[ 5346.421491] Pid: 10530, comm: interbench Not tainted 2.6.27-rc5-mm1 #20
[ 5346.421496] Call Trace:
[ 5346.421507]  [<ffffffff80263383>] validate_chain+0xb03/0x10d0
[ 5346.421515]  [<ffffffff80263c05>] __lock_acquire+0x2b5/0x9c0
[ 5346.421522]  [<ffffffff80262cc2>] validate_chain+0x442/0x10d0
[ 5346.421530]  [<ffffffff802643aa>] lock_acquire+0x9a/0xe0
[ 5346.421537]  [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421546]  [<ffffffff804757c7>] _spin_lock+0x37/0x70
[ 5346.421553]  [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421560]  [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421569]  [<ffffffff802b91f8>] memrlimit_cgroup_mm_owner_changed+0x18/0x90
[ 5346.421579]  [<ffffffff80278b03>] cgroup_mm_owner_callbacks+0x93/0xc0
[ 5346.421587]  [<ffffffff8023dc36>] mm_update_next_owner+0x1e6/0x230
[ 5346.421595]  [<ffffffff8023dd72>] exit_mm+0xf2/0x120
[ 5346.421602]  [<ffffffff8023f547>] do_exit+0x167/0x930
[ 5346.421610]  [<ffffffff8047604a>] _spin_unlock_irq+0x2a/0x50
[ 5346.421618]  [<ffffffff8023fd46>] do_group_exit+0x36/0xa0
[ 5346.421626]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b

Here is a possible fix, introducing get_task_mm_task_locked().

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/sched.h |    1 +
 kernel/cgroup.c       |    2 +-
 kernel/fork.c         |   22 +++++++++++++++-------
 mm/memrlimitcgroup.c  |    4 ++--
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cd67fac..954057c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1773,6 +1773,7 @@ static inline void mmdrop(struct mm_struct * mm)
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
 /* Grab a reference to a task's mm, if it is not already going away */
+extern struct mm_struct *get_task_mm_task_locked(struct task_struct *task);
 extern struct mm_struct *get_task_mm(struct task_struct *task);
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 678a680..30b9c3a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2757,7 +2757,7 @@ void cgroup_fork_callbacks(struct task_struct *child)
  * invoke this routine, since it assigns the mm->owner the first time
  * and does not change it.
  *
- * The callbacks are invoked with mmap_sem held in read mode.
+ * The callbacks are invoked with mmap_sem and task_lock held in read mode.
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 7b34bc5..24f9656 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -494,6 +494,20 @@ void mmput(struct mm_struct *mm)
 EXPORT_SYMBOL_GPL(mmput);
 
 /**
+ * Must be called with task_lock held.
+ */
+struct mm_struct *get_task_mm_task_locked(struct task_struct *task)
+{
+	struct mm_struct *mm = task->mm;
+
+	if ((!mm) || (task->flags & PF_KTHREAD))
+		return NULL;
+	atomic_inc(&mm->mm_users);
+	return mm;
+}
+EXPORT_SYMBOL_GPL(get_task_mm_task_locked);
+
+/**
  * get_task_mm - acquire a reference to the task's mm
  *
  * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
@@ -507,13 +521,7 @@ struct mm_struct *get_task_mm(struct task_struct *task)
 	struct mm_struct *mm;
 
 	task_lock(task);
-	mm = task->mm;
-	if (mm) {
-		if (task->flags & PF_KTHREAD)
-			mm = NULL;
-		else
-			atomic_inc(&mm->mm_users);
-	}
+	mm = get_task_mm_task_locked(task);
 	task_unlock(task);
 	return mm;
 }
diff --git a/mm/memrlimitcgroup.c b/mm/memrlimitcgroup.c
index 8ee74f6..dad0163 100644
--- a/mm/memrlimitcgroup.c
+++ b/mm/memrlimitcgroup.c
@@ -238,7 +238,7 @@ out:
 }
 
 /*
- * This callback is called with mmap_sem held
+ * This callback is called with mmap_sem and task_lock held
  */
 static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
 						struct cgroup *old_cgrp,
@@ -246,7 +246,7 @@ static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
 						struct task_struct *p)
 {
 	struct memrlimit_cgroup *memrcg, *old_memrcg;
-	struct mm_struct *mm = get_task_mm(p);
+	struct mm_struct *mm = get_task_mm_task_locked(p);
 
 	BUG_ON(!mm);
 
