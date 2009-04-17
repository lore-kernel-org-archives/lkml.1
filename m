Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbZDQOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbZDQOTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZDQOTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:19:24 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:47272 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760860AbZDQOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:19:23 -0400
Date: Fri, 17 Apr 2009 19:48:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
	controller (v3)
Message-ID: <20090417141837.GD3896@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090416120316.GG7082@balbir.in.ibm.com> <20090417091459.dac2cc39.kamezawa.hiroyu@jp.fujitsu.com> <20090417014042.GB18558@balbir.in.ibm.com> <20090417110350.3144183d.kamezawa.hiroyu@jp.fujitsu.com> <20090417034539.GD18558@balbir.in.ibm.com> <20090417124951.a8472c86.kamezawa.hiroyu@jp.fujitsu.com> <20090417045623.GA3896@balbir.in.ibm.com> <20090417141726.a69ebdcc.kamezawa.hiroyu@jp.fujitsu.com> <20090417064726.GB3896@balbir.in.ibm.com> <20090417155608.eeed1f02.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090417155608.eeed1f02.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame,

How does this look? I did not use the mapped flag in page_cgroup
flags. page_is_file_cache and page_mapped worked as well.

Feature: Add file RSS tracking per memory cgroup

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Changelog v3 -> v2
1. Fix get_cpu(), put_cpu() matching. Moved away from get_cpu() and use
   smp_processor_id(), since we are in preempt disable context
2. Use pc->mem_cgroup to identify the mem_cgroup instead of mm
3. page_add_file_rmap() and page_remove_rmap() argument changes are undone.

Changelog v2 -> v1

1. Rename file_rss to mapped_file
2. Add hooks into mem_cgroup_move_account for updating MAPPED_FILE statistics
3. Use a better name for the statistics routine.


We currently don't track file RSS, the RSS we report is actually anon RSS.
All the file mapped pages, come in through the page cache and get accounted
there. This patch adds support for accounting file RSS pages. It should

1. Help improve the metrics reported by the memory resource controller
2. Will form the basis for a future shared memory accounting heuristic
   that has been proposed by Kamezawa.

Unfortunately, we cannot rename the existing "rss" keyword used in memory.stat
to "anon_rss". We however, add "mapped_file" data and hope to educate the end
user through documentation.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/memcontrol.h |    7 ++++-
 mm/memcontrol.c            |   66 +++++++++++++++++++++++++++++++++++++++++++-
 mm/rmap.c                  |    5 +++
 3 files changed, 75 insertions(+), 3 deletions(-)


diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 18146c9..05a5c11 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -116,7 +116,7 @@ static inline bool mem_cgroup_disabled(void)
 }
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
-
+void mem_cgroup_update_mapped_file_stat(struct page *page, int val);
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -264,6 +264,11 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
+static inline void mem_cgroup_update_mapped_file_stat(struct page *page,
+							int val)
+{
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e44fb0f..562bd76 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -62,7 +62,8 @@ enum mem_cgroup_stat_index {
 	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
-	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
+	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
+	MEM_CGROUP_STAT_MAPPED_FILE,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 
@@ -321,6 +322,44 @@ static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
 	return css_is_removed(&mem->css);
 }
 
+/*
+ * Currently used to update mapped file statistics, but the routine can be
+ * generalized to update other statistics as well.
+ */
+void mem_cgroup_update_mapped_file_stat(struct page *page, int val)
+{
+	struct mem_cgroup *mem;
+	struct mem_cgroup_stat *stat;
+	struct mem_cgroup_stat_cpu *cpustat;
+	int cpu;
+	struct page_cgroup *pc;
+
+	if (!page_is_file_cache(page))
+		return;
+
+	pc = lookup_page_cgroup(page);
+	if (unlikely(!pc))
+		return;
+
+	lock_page_cgroup(pc);
+	mem = pc->mem_cgroup;
+	if (!mem)
+		goto done;
+
+	if (!PageCgroupUsed(pc))
+		goto done;
+
+	/*
+	 * Preemption is already disabled, we don't need get_cpu()
+	 */
+	cpu = smp_processor_id();
+	stat = &mem->stat;
+	cpustat = &stat->cpustat[cpu];
+
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
+done:
+	unlock_page_cgroup(pc);
+}
 
 /*
  * Call callback function against all cgroup under hierarchy tree.
@@ -1096,6 +1135,10 @@ static int mem_cgroup_move_account(struct page_cgroup *pc,
 	struct mem_cgroup_per_zone *from_mz, *to_mz;
 	int nid, zid;
 	int ret = -EBUSY;
+	struct page *page;
+	int cpu;
+	struct mem_cgroup_stat *stat;
+	struct mem_cgroup_stat_cpu *cpustat;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
@@ -1116,6 +1159,23 @@ static int mem_cgroup_move_account(struct page_cgroup *pc,
 
 	res_counter_uncharge(&from->res, PAGE_SIZE);
 	mem_cgroup_charge_statistics(from, pc, false);
+
+	page = pc->page;
+	if (page_is_file_cache(page) && page_mapped(page)) {
+		cpu = smp_processor_id();
+		/* Update mapped_file data for mem_cgroup "from" */
+		stat = &from->stat;
+		cpustat = &stat->cpustat[cpu];
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+						-1);
+
+		/* Update mapped_file data for mem_cgroup "to" */
+		stat = &to->stat;
+		cpustat = &stat->cpustat[cpu];
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+						1);
+	}
+
 	if (do_swap_account)
 		res_counter_uncharge(&from->memsw, PAGE_SIZE);
 	css_put(&from->css);
@@ -2051,6 +2111,7 @@ static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 enum {
 	MCS_CACHE,
 	MCS_RSS,
+	MCS_MAPPED_FILE,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_INACTIVE_ANON,
@@ -2071,6 +2132,7 @@ struct {
 } memcg_stat_strings[NR_MCS_STAT] = {
 	{"cache", "total_cache"},
 	{"rss", "total_rss"},
+	{"mapped_file", "total_mapped_file"},
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
 	{"inactive_anon", "total_inactive_anon"},
@@ -2091,6 +2153,8 @@ static int mem_cgroup_get_local_stat(struct mem_cgroup *mem, void *data)
 	s->stat[MCS_CACHE] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_MAPPED_FILE);
+	s->stat[MCS_MAPPED_FILE] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGIN_COUNT);
 	s->stat[MCS_PGPGIN] += val;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
diff --git a/mm/rmap.c b/mm/rmap.c
index 1652166..c3ba0b9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -688,8 +688,10 @@ void page_add_new_anon_rmap(struct page *page,
  */
 void page_add_file_rmap(struct page *page)
 {
-	if (atomic_inc_and_test(&page->_mapcount))
+	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
+		mem_cgroup_update_mapped_file_stat(page, 1);
+	}
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -738,6 +740,7 @@ void page_remove_rmap(struct page *page)
 			mem_cgroup_uncharge_page(page);
 		__dec_zone_page_state(page,
 			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
+		mem_cgroup_update_mapped_file_stat(page, -1);
 		/*
 		 * It would be tidy to reset the PageAnon mapping here,
 		 * but that might overwrite a racing page_add_anon_rmap

-- 
	Balbir
