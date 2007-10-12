Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbXJLHht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbXJLHht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbXJLHhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:37:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37461 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbXJLHhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:37:35 -0400
Date: Fri, 12 Oct 2007 16:38:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][PATCH][ for -mm] bugfix for memory cgroup controller [4/5]
 avoid !PageLRU page in mem_cgroup_isolate_pages
Message-Id: <20071012163829.61ce374f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes mem_cgroup_isolate_pages() to be

  - ignore !PageLRU pages.
  - fixes the bug that isolation makes no progress if page_zone(page) != zone
    page once find. (just increment scan in this case.)

kswapd and memory migration removes a page from list when it handles
a page for reclaiming/migration.

Because __isolate_lru_page() doesn't moves page !PageLRU pages, it will
be safe to avoid touching !PageLRU() page and its page_cgroup.

Chnagelog v1 -> v2:
 * adjusted to 2.6.23-mm1

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memcontrol.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: devel-2.6.23-mm1/mm/memcontrol.c
===================================================================
--- devel-2.6.23-mm1.orig/mm/memcontrol.c
+++ devel-2.6.23-mm1/mm/memcontrol.c
@@ -250,7 +250,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	unsigned long scan;
 	LIST_HEAD(pc_list);
 	struct list_head *src;
-	struct page_cgroup *pc;
+	struct page_cgroup *pc, *tmp;
 
 	if (active)
 		src = &mem_cont->active_list;
@@ -258,11 +258,18 @@ unsigned long mem_cgroup_isolate_pages(u
 		src = &mem_cont->inactive_list;
 
 	spin_lock(&mem_cont->lru_lock);
-	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
-		pc = list_entry(src->prev, struct page_cgroup, lru);
+	scan = 0;
+	list_for_each_entry_safe_reverse(pc, tmp, src, lru) {
+		if (scan++ > nr_taken)
+			break;
 		page = pc->page;
 		VM_BUG_ON(!pc);
 
+		if (unlikely(!PageLRU(page))) {
+			scan--;
+			continue;
+		}
+
 		if (PageActive(page) && !active) {
 			__mem_cgroup_move_lists(pc, true);
 			scan--;

