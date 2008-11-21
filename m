Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYKUKCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYKUKCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYKUKCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:02:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50070 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYKUKCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:02:37 -0500
Date: Fri, 21 Nov 2008 19:01:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       pbadari@us.ibm.com, jblunck@suse.de, taka@valinux.co.jp,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Subject: [PATCH 1/2] memcg: avoid unnecessary system-wide-oom-killer
Message-Id: <20081121190152.fa6843fb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081121185829.e04c8116.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>
	<20081114191949.926bf99d.kamezawa.hiroyu@jp.fujitsu.com>
	<49261F87.50209@cn.fujitsu.com>
	<20081121185829.e04c8116.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current mmtom has new oom function as pagefault_out_of_memory().
It's added for select bad process rathar than killing current.

When memcg hit limit and calls OOM at page_fault, this handler
called and system-wide-oom handling happens.
(means kernel panics if panic_on_oom is true....)

For avoiding overkill, check memcg's recent behavior before
starting system-wide-oom.

And this patch also fixes to guarantee "don't accnout against
process with TIF_MEMDIE". This is necessary for smooth OOM.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   33 +++++++++++++++++++++++++++++----
 mm/oom_kill.c              |    8 ++++++++
 3 files changed, 43 insertions(+), 4 deletions(-)

Index: mmotm-2.6.28-Nov20/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.28-Nov20.orig/include/linux/memcontrol.h
+++ mmotm-2.6.28-Nov20/include/linux/memcontrol.h
@@ -95,6 +95,8 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
+extern bool mem_cgroup_oom_called(struct task_struct *task);
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -227,6 +229,10 @@ static inline bool mem_cgroup_disabled(v
 {
 	return true;
 }
+static inline bool mem_cgroup_oom_called(struct task_struct *task);
+{
+	return false;
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
Index: mmotm-2.6.28-Nov20/mm/oom_kill.c
===================================================================
--- mmotm-2.6.28-Nov20.orig/mm/oom_kill.c
+++ mmotm-2.6.28-Nov20/mm/oom_kill.c
@@ -560,6 +560,13 @@ void pagefault_out_of_memory(void)
 		/* Got some memory back in the last second. */
 		return;
 
+	/*
+	 * If this is from memcg, oom-killer is already invoked.
+	 * and not worth to go system-wide-oom.
+	 */
+	if (mem_cgroup_oom_called(current))
+		goto rest_and_return;
+
 	if (sysctl_panic_on_oom)
 		panic("out of memory from page fault. panic_on_oom is selected.\n");
 
@@ -571,6 +578,7 @@ void pagefault_out_of_memory(void)
 	 * Give "p" a good chance of killing itself before we
 	 * retry to allocate memory.
 	 */
+rest_and_return:
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
Index: mmotm-2.6.28-Nov20/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov20.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov20/mm/memcontrol.c
@@ -153,7 +153,7 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-
+	unsigned long	last_oom_jiffies;
 	int		obsolete;
 	atomic_t	refcnt;
 	/*
@@ -618,6 +618,22 @@ static int mem_cgroup_hierarchical_recla
 	return ret;
 }
 
+bool mem_cgroup_oom_called(struct task_struct *task)
+{
+	bool ret = false;
+	struct mem_cgroup *mem;
+	struct mm_struct *mm;
+
+	rcu_read_lock();
+	mm = task->mm;
+	if (!mm)
+		mm = &init_mm;
+	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (mem && time_before(jiffies, mem->last_oom_jiffies + HZ/10))
+		ret = true;
+	rcu_read_unlock();
+	return ret;
+}
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -629,6 +645,13 @@ static int __mem_cgroup_try_charge(struc
 	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct res_counter *fail_res;
+
+	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
+		/* Don't account this! */
+		*memcg = NULL;
+		return 0;
+	}
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
@@ -699,8 +722,10 @@ static int __mem_cgroup_try_charge(struc
 			continue;
 
 		if (!nr_retries--) {
-			if (oom)
+			if (oom) {
 				mem_cgroup_out_of_memory(mem, gfp_mask);
+				mem->last_oom_jiffies = jiffies;
+			}
 			goto nomem;
 		}
 	}
@@ -837,7 +862,7 @@ static int mem_cgroup_move_parent(struct
 
 
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false);
-	if (ret)
+	if (ret || !parent)
 		return ret;
 
 	if (!get_page_unless_zero(page))
@@ -888,7 +913,7 @@ static int mem_cgroup_charge_common(stru
 
 	mem = memcg;
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
-	if (ret)
+	if (ret || !mem)
 		return ret;
 
 	__mem_cgroup_commit_charge(mem, pc, ctype);

