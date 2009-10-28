Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbZJ1DSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbZJ1DSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932503AbZJ1DSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:18:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51426 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbZJ1DSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:18:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 12:16:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] memcg: make memcg's file mapped consistent with global VM
Message-Id: <20091028121619.c094e9c0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on mmotm-Oct13 + some patches in -mm queue.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memcg-cleanup-file-mapped-consistent-with-globarl-vm-stat.patch

In global VM, FILE_MAPPED is used but memcg uses MAPPED_FILE.
This makes grep difficult. Replace memcg's MAPPED_FILE with FILE_MAPPED

And in global VM, mapped shared memory is accounted into FILE_MAPPED.
But memcg doesn't. fix it.
Note:
  page_is_file_cache() just checks SwapBacked or not.
  So, we need to check PageAnon.

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   21 +++++++++------------
 mm/rmap.c                  |    4 ++--
 3 files changed, 13 insertions(+), 16 deletions(-)

Index: mm-test-kernel/mm/memcontrol.c
===================================================================
--- mm-test-kernel.orig/mm/memcontrol.c
+++ mm-test-kernel/mm/memcontrol.c
@@ -67,7 +67,7 @@ enum mem_cgroup_stat_index {
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
-	MEM_CGROUP_STAT_MAPPED_FILE,  /* # of pages charged as file rss */
+	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
@@ -1227,7 +1227,7 @@ static void record_last_oom(struct mem_c
  * Currently used to update mapped file statistics, but the routine can be
  * generalized to update other statistics as well.
  */
-void mem_cgroup_update_mapped_file_stat(struct page *page, int val)
+void mem_cgroup_update_file_mapped(struct page *page, int val)
 {
 	struct mem_cgroup *mem;
 	struct mem_cgroup_stat *stat;
@@ -1235,9 +1235,6 @@ void mem_cgroup_update_mapped_file_stat(
 	int cpu;
 	struct page_cgroup *pc;
 
-	if (!page_is_file_cache(page))
-		return;
-
 	pc = lookup_page_cgroup(page);
 	if (unlikely(!pc))
 		return;
@@ -1257,7 +1254,7 @@ void mem_cgroup_update_mapped_file_stat(
 	stat = &mem->stat;
 	cpustat = &stat->cpustat[cpu];
 
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED, val);
 done:
 	unlock_page_cgroup(pc);
 }
@@ -1654,18 +1651,18 @@ static int mem_cgroup_move_account(struc
 	mem_cgroup_charge_statistics(from, pc, false);
 
 	page = pc->page;
-	if (page_is_file_cache(page) && page_mapped(page)) {
+	if (page_mapped(page) && !PageAnon(page)) {
 		cpu = smp_processor_id();
 		/* Update mapped_file data for mem_cgroup "from" */
 		stat = &from->stat;
 		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
 						-1);
 
 		/* Update mapped_file data for mem_cgroup "to" */
 		stat = &to->stat;
 		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
 						1);
 	}
 
@@ -2887,7 +2884,7 @@ static int mem_cgroup_reset(struct cgrou
 enum {
 	MCS_CACHE,
 	MCS_RSS,
-	MCS_MAPPED_FILE,
+	MCS_FILE_MAPPED,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_SWAP,
@@ -2931,8 +2928,8 @@ static int mem_cgroup_get_local_stat(str
 	s->stat[MCS_CACHE] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_MAPPED_FILE);
-	s->stat[MCS_MAPPED_FILE] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_FILE_MAPPED);
+	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGIN_COUNT);
 	s->stat[MCS_PGPGIN] += val;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
Index: mm-test-kernel/include/linux/memcontrol.h
===================================================================
--- mm-test-kernel.orig/include/linux/memcontrol.h
+++ mm-test-kernel/include/linux/memcontrol.h
@@ -122,7 +122,7 @@ static inline bool mem_cgroup_disabled(v
 }
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
-void mem_cgroup_update_mapped_file_stat(struct page *page, int val);
+void mem_cgroup_update_file_mapped(struct page *page, int val);
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask, int nid,
 						int zid);
@@ -287,7 +287,7 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline void mem_cgroup_update_mapped_file_stat(struct page *page,
+static inline void mem_cgroup_update_file_mapped(struct page *page,
 							int val)
 {
 }
Index: mm-test-kernel/mm/rmap.c
===================================================================
--- mm-test-kernel.orig/mm/rmap.c
+++ mm-test-kernel/mm/rmap.c
@@ -711,7 +711,7 @@ void page_add_file_rmap(struct page *pag
 {
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_update_mapped_file_stat(page, 1);
+		mem_cgroup_update_file_mapped(page, 1);
 	}
 }
 
@@ -743,8 +743,8 @@ void page_remove_rmap(struct page *page)
 		__dec_zone_page_state(page, NR_ANON_PAGES);
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
+		mem_cgroup_update_file_mapped(page, -1);
 	}
-	mem_cgroup_update_mapped_file_stat(page, -1);
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap

