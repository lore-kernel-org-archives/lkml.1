Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYLJFUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYLJFUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 00:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYLJFT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 00:19:58 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:48809 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYLJFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 00:19:57 -0500
Date: Wed, 10 Dec 2008 10:49:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: menage@google.com, KAMEZAWA Hiroyuki <kamezawa.hiroyuki@jp.fujitsu.com>,
       Daisuke Miyakawa <dmiyakawa@google.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC][RFT] memcg fix cgroup_mutex deadlock when cpuset reclaims
	memory
Message-ID: <20081210051947.GH7593@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: menage@google.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyuki@jp.fujitsu.com>,
	Daisuke Miyakawa <dmiyakawa@google.com>,
	YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a proposed fix for the memory controller cgroup_mutex deadlock
reported. It is lightly tested and reviewed. I need help with review
and test. Is the reported deadlock reproducible after this patch? A
careful review of the cpuset impact will also be highly appreciated.

From: Balbir Singh <balbir@linux.vnet.ibm.com>

cpuset_migrate_mm() holds cgroup_mutex throughout the duration of
do_migrate_pages(). The issue with that is that

1. It can lead to deadlock with memcg, as do_migrate_pages()
   enters reclaim
2. It can lead to long latencies, preventing users from creating/
   destroying other cgroups anywhere else

The patch holds callback_mutex through the duration of cpuset_migrate_mm() and
gives up cgroup_mutex while doing so.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/cpuset.h |   13 ++++++++++++-
 kernel/cpuset.c        |   23 ++++++++++++-----------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff -puN kernel/cgroup.c~cpuset-remove-cgroup-mutex-from-update-path kernel/cgroup.c
diff -puN kernel/cpuset.c~cpuset-remove-cgroup-mutex-from-update-path kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-cgroup-mutex-from-update-path
+++ a/kernel/cpuset.c
@@ -369,7 +369,7 @@ static void guarantee_online_mems(const 
  * task has been modifying its cpuset.
  */
 
-void cpuset_update_task_memory_state(void)
+void __cpuset_update_task_memory_state(bool held)
 {
 	int my_cpusets_mem_gen;
 	struct task_struct *tsk = current;
@@ -380,7 +380,8 @@ void cpuset_update_task_memory_state(voi
 	rcu_read_unlock();
 
 	if (my_cpusets_mem_gen != tsk->cpuset_mems_generation) {
-		mutex_lock(&callback_mutex);
+		if (!held)
+			mutex_lock(&callback_mutex);
 		task_lock(tsk);
 		cs = task_cs(tsk); /* Maybe changed when task not locked */
 		guarantee_online_mems(cs, &tsk->mems_allowed);
@@ -394,7 +395,8 @@ void cpuset_update_task_memory_state(voi
 		else
 			tsk->flags &= ~PF_SPREAD_SLAB;
 		task_unlock(tsk);
-		mutex_unlock(&callback_mutex);
+		if (!held)
+			mutex_unlock(&callback_mutex);
 		mpol_rebind_task(tsk, &tsk->mems_allowed);
 	}
 }
@@ -949,13 +951,15 @@ static int update_cpumask(struct cpuset 
  *    so that the migration code can allocate pages on these nodes.
  *
  *    Call holding cgroup_mutex, so current's cpuset won't change
- *    during this call, as manage_mutex holds off any cpuset_attach()
+ *    during this call, as callback_mutex holds off any cpuset_attach()
  *    calls.  Therefore we don't need to take task_lock around the
  *    call to guarantee_online_mems(), as we know no one is changing
  *    our task's cpuset.
  *
  *    Hold callback_mutex around the two modifications of our tasks
- *    mems_allowed to synchronize with cpuset_mems_allowed().
+ *    mems_allowed to synchronize with cpuset_mems_allowed(). Give
+ *    up cgroup_mutex to avoid deadlocking with other subsystems
+ *    as we enter reclaim from do_migrate_pages().
  *
  *    While the mm_struct we are migrating is typically from some
  *    other task, the task_struct mems_allowed that we are hacking
@@ -976,17 +980,14 @@ static void cpuset_migrate_mm(struct mm_
 {
 	struct task_struct *tsk = current;
 
-	cpuset_update_task_memory_state();
-
+	cgroup_unlock();
 	mutex_lock(&callback_mutex);
+	cpuset_update_task_memory_state_locked();
 	tsk->mems_allowed = *to;
-	mutex_unlock(&callback_mutex);
-
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
-
-	mutex_lock(&callback_mutex);
 	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
 	mutex_unlock(&callback_mutex);
+	cgroup_lock();
 }
 
 static void *cpuset_being_rebound;
diff -puN include/linux/cpuset.h~cpuset-remove-cgroup-mutex-from-update-path include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-remove-cgroup-mutex-from-update-path
+++ a/include/linux/cpuset.h
@@ -25,7 +25,18 @@ extern void cpuset_cpus_allowed_locked(s
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
-void cpuset_update_task_memory_state(void);
+extern void __cpuset_update_task_memory_state(bool locked);
+
+static void inline cpuset_update_task_memory_state(void)
+{
+	__cpuset_update_task_memory_state(false);
+}
+
+static void inline cpuset_update_task_memory_state_locked(void)
+{
+	__cpuset_update_task_memory_state(true);
+}
+
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
 extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
_

-- 
	Balbir
