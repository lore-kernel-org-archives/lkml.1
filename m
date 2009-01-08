Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZAHJda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZAHJda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZAHJdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:33:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36460 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZAHJdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:33:12 -0500
Date: Thu, 8 Jan 2009 18:32:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Subject: [RFC][PATCH 3/4] memcg: fix OOM KILL under hierarchy
Message-Id: <20090108183207.26d88794.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Current memcg's oom-killer has 2 problems when hierarchy is used.

Assume following tree,
	Group_A/     use_hierarchy = 1, limit=1G
	        01/  nolimit
		02/  nolimit
		03/  nolimit
In this case, sum of memory usage from 01,02,03 is limited to 1G (of Group_A).

Assume a task in Group_A/01 causes OOM by limit of Group_A, in this case,
bad_process() will select a process in Group_A, not in 01,02,03.

This patch fixes the behavior and all processes under Group_A's hierarchy
01,02,03 will be OOM kill candidates.

And now, to avoid calling oom_kill twice, mem_cgroup_oom_called() hook is
used in pagefault_out_of_memory(). This check the timestamp of the most
recent OOM in memcg. This timestamp should be updated per hierarchy.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


---
 Documentation/controllers/memcg_test.txt |   15 ++++++++
 include/linux/memcontrol.h               |    4 +-
 mm/memcontrol.c                          |   55 +++++++++++++++++++++++++++++--
 mm/oom_kill.c                            |    4 +-
 4 files changed, 72 insertions(+), 6 deletions(-)

Index: mmotm-2.6.28-Jan7/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Jan7.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Jan7/mm/memcontrol.c
@@ -431,12 +431,31 @@ void mem_cgroup_move_lists(struct page *
 	mem_cgroup_add_lru_list(page, to);
 }
 
-int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
+static int
+mm_match_cgroup_hierarchy(struct mm_struct *mm, struct mem_cgroup *mem)
+{
+	struct mem_cgroup *curr;
+	int ret;
+
+	if (!mm)
+		return 0;
+	rcu_read_lock();
+	curr = mem_cgroup_from_task(mm->owner);
+	if (mem->use_hierarchy)
+		ret = css_is_ancestor(&curr->css, &mem->css);
+	else
+		ret = (curr == mem);
+	rcu_read_unlock();
+	return ret;
+}
+
+int task_in_mem_cgroup_hierarchy(struct task_struct *task,
+				 struct mem_cgroup *mem)
 {
 	int ret;
 
 	task_lock(task);
-	ret = task->mm && mm_match_cgroup(task->mm, mem);
+	ret = mm_match_cgroup_hierarchy(task->mm, mem);
 	task_unlock(task);
 	return ret;
 }
@@ -723,6 +742,36 @@ static int mem_cgroup_hierarchical_recla
 	return total;
 }
 
+/*
+ *  Update last_oom_jiffies of hierarchy.
+ */
+void mem_cgroup_update_oom_jiffies(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *cur;
+	struct cgroup_subsys_state *css;
+	int id, found;
+
+	if (!mem->use_hierarchy) {
+		mem->last_oom_jiffies = jiffies;
+		return;
+	}
+
+	id = 0;
+	rcu_read_lock();
+	while (1) {
+		css = css_get_next(&mem_cgroup_subsys, id, &mem->css, &found);
+		if (!css)
+			break;
+		if (css_tryget(css)) {
+			cur = container_of(css, struct mem_cgroup, css);
+			cur->last_oom_jiffies = jiffies;
+			css_put(css);
+		}
+		id = found + 1;
+	}
+	rcu_read_unlock();
+	return;
+}
 bool mem_cgroup_oom_called(struct task_struct *task)
 {
 	bool ret = false;
@@ -819,7 +868,7 @@ static int __mem_cgroup_try_charge(struc
 				mutex_lock(&memcg_tasklist);
 				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
 				mutex_unlock(&memcg_tasklist);
-				mem_over_limit->last_oom_jiffies = jiffies;
+				mem_cgroup_update_oom_jiffies(mem_over_limit);
 			}
 			goto nomem;
 		}
Index: mmotm-2.6.28-Jan7/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.28-Jan7.orig/include/linux/memcontrol.h
+++ mmotm-2.6.28-Jan7/include/linux/memcontrol.h
@@ -66,7 +66,9 @@ extern unsigned long mem_cgroup_isolate_
 					struct mem_cgroup *mem_cont,
 					int active, int file);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
-int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
+
+int task_in_mem_cgroup_hierarchy(struct task_struct *task,
+			struct mem_cgroup *mem);
 
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
Index: mmotm-2.6.28-Jan7/mm/oom_kill.c
===================================================================
--- mmotm-2.6.28-Jan7.orig/mm/oom_kill.c
+++ mmotm-2.6.28-Jan7/mm/oom_kill.c
@@ -220,7 +220,7 @@ static struct task_struct *select_bad_pr
 		/* skip the init task */
 		if (is_global_init(p))
 			continue;
-		if (mem && !task_in_mem_cgroup(p, mem))
+		if (mem && !task_in_mem_cgroup_hierarchy(p, mem))
 			continue;
 
 		/*
@@ -292,7 +292,7 @@ static void dump_tasks(const struct mem_
 		 */
 		if (!p->mm)
 			continue;
-		if (mem && !task_in_mem_cgroup(p, mem))
+		if (mem && !task_in_mem_cgroup_hierarchy(p, mem))
 			continue;
 		if (!thread_group_leader(p))
 			continue;
Index: mmotm-2.6.28-Jan7/Documentation/controllers/memcg_test.txt
===================================================================
--- mmotm-2.6.28-Jan7.orig/Documentation/controllers/memcg_test.txt
+++ mmotm-2.6.28-Jan7/Documentation/controllers/memcg_test.txt
@@ -340,3 +340,18 @@ Under below explanation, we assume CONFI
 	# mount -t cgroup none /cgroup -t cpuset,memory,cpu,devices
 
 	and do task move, mkdir, rmdir etc...under this.
+
+ 9.7 OOM-KILL
+	If memcg finds out-of-memory, OOM Kill should kill a task in memcg.
+	The select_bad_process() should take hierarchy into account and
+	OOM-KILL itself shoudn't call panic_on_oom or some hooks for generic
+	OOM.
+
+	It's not difficult to cause OOM under memcg by setting memsw.limit
+	as following.
+	# echo 50M > memory.limit_in_bytes
+	# echo 50M > memory.memsw.limit_in_bytes
+	and run malloc(51M) program.
+	(Alternative is do swapoff/mlock and malloc())
+
+

