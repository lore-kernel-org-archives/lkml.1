Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYEOJ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYEOJ0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYEOJ0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:26:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54732 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYEOJ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:26:33 -0400
Date: Thu, 15 May 2008 18:31:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>, minchan.kim@gmail.com
Subject: [PATCH -mm 3/5] memcg: helper function for relcaim from shmem.
Message-Id: <20080515183149.3a3182a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080515182516.763967cc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080515182516.763967cc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new call, mem_cgroup_shrink_usage() is added for shmem handling
and relacing non-standard usage of mem_cgroup_charge/uncharge.

Now, shmem calls mem_cgroup_charge() just for reclaim some pages from
mem_cgroup. In general, shmem is used by some process group and not for
global resource (like file caches). So, it's reasonable to reclaim pages from
mem_cgroup where shmem is mainly used.

Changelog v3->v4
 - fixed while loop to be do_while loop.
 - fixed declaration in header file.
 - adjusted to 2.6.26-rc2-mm1

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   25 +++++++++++++++++++++++++
 mm/shmem.c                 |    5 ++---
 3 files changed, 34 insertions(+), 3 deletions(-)

Index: mm-2.6.26-rc2-mm1/mm/memcontrol.c
===================================================================
--- mm-2.6.26-rc2-mm1.orig/mm/memcontrol.c
+++ mm-2.6.26-rc2-mm1/mm/memcontrol.c
@@ -770,6 +770,31 @@ void mem_cgroup_end_migration(struct pag
 }
 
 /*
+ * A call to try to shrink memory usage under specified resource controller.
+ * This is typically used for page reclaiming for shmem for reducing side
+ * effect of page allocation from shmem, which is used by some mem_cgroup.
+ */
+int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+{
+	struct mem_cgroup *mem;
+	int progress = 0;
+	int retry = MEM_CGROUP_RECLAIM_RETRIES;
+
+	rcu_read_lock();
+	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	css_get(&mem->css);
+	rcu_read_unlock();
+
+	do {
+		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
+	} while (!progress && --retry);
+
+	if (!retry)
+		return -ENOMEM;
+	return 0;
+}
+
+/*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
  */
Index: mm-2.6.26-rc2-mm1/mm/shmem.c
===================================================================
--- mm-2.6.26-rc2-mm1.orig/mm/shmem.c
+++ mm-2.6.26-rc2-mm1/mm/shmem.c
@@ -1321,13 +1321,12 @@ repeat:
 			unlock_page(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
-				error = mem_cgroup_cache_charge(swappage,
-					current->mm, gfp & ~__GFP_HIGHMEM);
+				error = mem_cgroup_shrink_usage(current->mm,
+					gfp & ~__GFP_HIGHMEM);
 				if (error) {
 					page_cache_release(swappage);
 					goto failed;
 				}
-				mem_cgroup_uncharge_cache_page(swappage);
 			}
 			page_cache_release(swappage);
 			goto repeat;
Index: mm-2.6.26-rc2-mm1/include/linux/memcontrol.h
===================================================================
--- mm-2.6.26-rc2-mm1.orig/include/linux/memcontrol.h
+++ mm-2.6.26-rc2-mm1/include/linux/memcontrol.h
@@ -37,6 +37,8 @@ extern int mem_cgroup_cache_charge(struc
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
 extern void mem_cgroup_move_lists(struct page *page, bool active);
+extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);
+
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
@@ -102,6 +104,11 @@ static inline void mem_cgroup_uncharge_c
 {
 }
 
+static inline int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+{
+	return 0;
+}
+
 static inline void mem_cgroup_move_lists(struct page *page, bool active)
 {
 }

