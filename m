Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbZARIHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbZARIHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762981AbZARIGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:06:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60268 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762867AbZARIGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:06:40 -0500
Message-ID: <4972E311.5010603@cn.fujitsu.com>
Date: Sun, 18 Jan 2009 16:06:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, miaox@cn.fujitsu.com, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cpuset: fix possible deadlock in async_rebuild_sched_domains
References: <496FEFCA.9050908@cn.fujitsu.com>	<4970000E.7040902@cn.fujitsu.com> <20090116125738.22c21bf2.akpm@linux-foundation.org>
In-Reply-To: <20090116125738.22c21bf2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep reported some possible circular locking info when we tested cpuset on
NUMA/fake NUMA box.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc1-00224-ga652504 #111
-------------------------------------------------------
bash/2968 is trying to acquire lock:
 (events){--..}, at: [<ffffffff8024c8cd>] flush_work+0x24/0xd8

but task is already holding lock:
 (cgroup_mutex){--..}, at: [<ffffffff8026ad1e>] cgroup_lock_live_group+0x12/0x29

which lock already depends on the new lock.
......
-------------------------------------------------------

Steps to reproduce:
# mkdir /dev/cpuset
# mount -t cpuset xxx /dev/cpuset
# mkdir /dev/cpuset/0
# echo 0 > /dev/cpuset/0/cpus
# echo 0 > /dev/cpuset/0/mems
# echo 1 > /dev/cpuset/0/memory_migrate
# cat /dev/zero > /dev/null &
# echo $! > /dev/cpuset/0/tasks

This is because async_rebuild_sched_domains has the following lock sequence:
run_workqueue(async_rebuild_sched_domains)
	-> do_rebuild_sched_domains -> cgroup_lock

But, attaching tasks when memory_migrate is set has following:
cgroup_lock_live_group(cgroup_tasks_write)
	-> do_migrate_pages -> flush_work

This can be fixed by using a separate workqueue thread.

But queuing a work to an other thread is adding some overhead for cpuset.
And a new separate workqueue thread is wasteful, this thread is sleeping
at most time.

This patch add cgroup_queue_defer_work(). And the works will be deferring
processed with cgroup_mutex released. And this patch just add very very
little overhead for cgroup_unlock()'s fast path.

Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 647c77a..5a8c6b7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -57,7 +57,6 @@
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
 #include <linux/mutex.h>
-#include <linux/workqueue.h>
 #include <linux/cgroup.h>
 
 /*
@@ -789,7 +788,7 @@ done:
  * to the cpuset pseudo-filesystem, because it cannot be called
  * from code that already holds cgroup_mutex.
  */
-static void do_rebuild_sched_domains(struct work_struct *unused)
+static void do_rebuild_sched_domains(struct cgroup_deferred_work *unused)
 {
 	struct sched_domain_attr *attr;
 	struct cpumask *doms;
@@ -808,10 +807,11 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
 	put_online_cpus();
 }
 
-static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
+static CGROUP_DEFERRED_WORK(rebuild_sched_domains_work,
+		do_rebuild_sched_domains);
 
 /*
- * Rebuild scheduler domains, asynchronously via workqueue.
+ * Rebuild scheduler domains, defer it after cgroup_lock released.
  *
  * If the flag 'sched_load_balance' of any cpuset with non-empty
  * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
@@ -826,19 +826,18 @@ static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
  *
  * So in order to avoid an ABBA deadlock, the cpuset code handling
  * these user changes delegates the actual sched domain rebuilding
- * to a separate workqueue thread, which ends up processing the
- * above do_rebuild_sched_domains() function.
+ * to a deferred work queue, and cgroup_unlock() will flush the deferred
+ * work queue and process the above do_rebuild_sched_domains() function.
  */
-static void async_rebuild_sched_domains(void)
+static void defer_rebuild_sched_domains(void)
 {
-	schedule_work(&rebuild_sched_domains_work);
+	cgroup_queue_deferred_work(&rebuild_sched_domains_work);
 }
 
 /*
  * Accomplishes the same scheduler domain rebuild as the above
- * async_rebuild_sched_domains(), however it directly calls the
- * rebuild routine synchronously rather than calling it via an
- * asynchronous work thread.
+ * defer_rebuild_sched_domains(), however it directly calls the
+ * rebuild routine synchronously rather than deferring it.
  *
  * This can only be called from code that is not holding
  * cgroup_mutex (not nested in a cgroup_lock() call.)
@@ -965,7 +964,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	heap_free(&heap);
 
 	if (is_load_balanced)
-		async_rebuild_sched_domains();
+		defer_rebuild_sched_domains();
 	return 0;
 }
 
@@ -1191,7 +1190,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 		cs->relax_domain_level = val;
 		if (!cpumask_empty(cs->cpus_allowed) &&
 		    is_sched_load_balance(cs))
-			async_rebuild_sched_domains();
+			defer_rebuild_sched_domains();
 	}
 
 	return 0;
@@ -1234,7 +1233,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	mutex_unlock(&callback_mutex);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
-		async_rebuild_sched_domains();
+		defer_rebuild_sched_domains();
 
 out:
 	free_trial_cpuset(trialcs);
@@ -1821,7 +1820,7 @@ static struct cgroup_subsys_state *cpuset_create(
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call async_rebuild_sched_domains().
+ * will call defer_rebuild_sched_domains().
  */
 
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)




