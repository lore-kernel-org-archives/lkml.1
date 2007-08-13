Return-Path: <linux-kernel-owner+w=401wt.eu-S1032118AbXHMRy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032118AbXHMRy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974056AbXHMRp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:45:29 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33790 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032600AbXHMRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:45:15 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 13 Aug 2007 23:15:05 +0530
Message-Id: <20070813174505.15210.33547.sendpatchset@balbir-laptop>
In-Reply-To: <20070813174454.15210.40573.sendpatchset@balbir-laptop>
References: <20070813174454.15210.40573.sendpatchset@balbir-laptop>
Subject: [-mm PATCH 7/9] Memory controller OOM handling (v5)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pavel Emelianov <xemul@openvz.org>

Out of memory handling for containers over their limit. A task from the
container over limit is chosen using the existing OOM logic and killed.

TODO:
1. As discussed in the OLS BOF session, consider implementing a user
space policy for OOM handling.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

Signed-off-by: <balbir@linux.vnet.ibm.com>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |    1 +
 mm/oom_kill.c              |   42 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 40 insertions(+), 4 deletions(-)

diff -puN include/linux/memcontrol.h~mem-control-out-of-memory include/linux/memcontrol.h
--- linux-2.6.23-rc1-mm1/include/linux/memcontrol.h~mem-control-out-of-memory	2007-08-13 23:06:12.000000000 +0530
+++ linux-2.6.23-rc1-mm1-balbir/include/linux/memcontrol.h	2007-08-13 23:06:12.000000000 +0530
@@ -39,6 +39,7 @@ extern unsigned long mem_container_isola
 					int mode, struct zone *z,
 					struct mem_container *mem_cont,
 					int active);
+extern void mem_container_out_of_memory(struct mem_container *mem);
 
 static inline void mem_container_uncharge_page(struct page *page)
 {
diff -puN mm/memcontrol.c~mem-control-out-of-memory mm/memcontrol.c
--- linux-2.6.23-rc1-mm1/mm/memcontrol.c~mem-control-out-of-memory	2007-08-13 23:06:12.000000000 +0530
+++ linux-2.6.23-rc1-mm1-balbir/mm/memcontrol.c	2007-08-13 23:06:12.000000000 +0530
@@ -321,6 +321,7 @@ int mem_container_charge(struct page *pa
 		}
 
 		css_put(&mem->css);
+		mem_container_out_of_memory(mem);
 		goto free_pc;
 	}
 
diff -puN mm/oom_kill.c~mem-control-out-of-memory mm/oom_kill.c
--- linux-2.6.23-rc1-mm1/mm/oom_kill.c~mem-control-out-of-memory	2007-08-13 23:06:12.000000000 +0530
+++ linux-2.6.23-rc1-mm1-balbir/mm/oom_kill.c	2007-08-13 23:06:12.000000000 +0530
@@ -24,6 +24,7 @@
 #include <linux/cpuset.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/memcontrol.h>
 
 int sysctl_panic_on_oom;
 /* #define DEBUG */
@@ -47,7 +48,8 @@ int sysctl_panic_on_oom;
  *    of least surprise ... (be careful when you change it)
  */
 
-unsigned long badness(struct task_struct *p, unsigned long uptime)
+unsigned long badness(struct task_struct *p, unsigned long uptime,
+			struct mem_container *mem)
 {
 	unsigned long points, cpu_time, run_time, s;
 	struct mm_struct *mm;
@@ -60,6 +62,13 @@ unsigned long badness(struct task_struct
 		return 0;
 	}
 
+#ifdef CONFIG_CONTAINER_MEM_CONT
+	if (mem != NULL && mm->mem_container != mem) {
+		task_unlock(p);
+		return 0;
+	}
+#endif
+
 	/*
 	 * The memory size of the process is the basis for the badness.
 	 */
@@ -204,7 +213,8 @@ static inline int constrained_alloc(stru
  *
  * (not docbooked, we don't want this one cluttering up the manual)
  */
-static struct task_struct *select_bad_process(unsigned long *ppoints)
+static struct task_struct *select_bad_process(unsigned long *ppoints,
+						struct mem_container *mem)
 {
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
@@ -258,7 +268,7 @@ static struct task_struct *select_bad_pr
 		if (p->oomkilladj == OOM_DISABLE)
 			continue;
 
-		points = badness(p, uptime.tv_sec);
+		points = badness(p, uptime.tv_sec, mem);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
@@ -370,6 +380,30 @@ static int oom_kill_process(struct task_
 	return oom_kill_task(p);
 }
 
+#ifdef CONFIG_CONTAINER_MEM_CONT
+void mem_container_out_of_memory(struct mem_container *mem)
+{
+	unsigned long points = 0;
+	struct task_struct *p;
+
+	container_lock();
+	rcu_read_lock();
+retry:
+	p = select_bad_process(&points, mem);
+	if (PTR_ERR(p) == -1UL)
+		goto out;
+
+	if (!p)
+		p = current;
+
+	if (oom_kill_process(p, points, "Memory container out of memory"))
+		goto retry;
+out:
+	rcu_read_unlock();
+	container_unlock();
+}
+#endif
+
 static BLOCKING_NOTIFIER_HEAD(oom_notify_list);
 
 int register_oom_notifier(struct notifier_block *nb)
@@ -442,7 +476,7 @@ retry:
 		 * Rambo mode: Shoot down a process and hope it solves whatever
 		 * issues we may have.
 		 */
-		p = select_bad_process(&points);
+		p = select_bad_process(&points, NULL);
 
 		if (PTR_ERR(p) == -1UL)
 			goto out;
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
