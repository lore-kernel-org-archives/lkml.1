Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbYENIJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbYENIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbYENIIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:08:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33026 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761513AbYENIIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:08:34 -0400
Date: Wed, 14 May 2008 17:13:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC/PATCH 6/6] memcg: remove redundant check at charge
Message-Id: <20080514171301.99e5d55e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of remove refcnt patch, it's very rare case to that
mem_cgroup_charge_common() is called against a page which is accounted.

mem_cgroup_charge_common() is called when.
 1. a page is added into file cache.
 2. an anon page is _newly_ mapped.

A racy case is that a newly-swapped-in anonymous page is referred from
prural threads in do_swap_page() at the same time.
(a page is not Locked when mem_cgroup_charge() is called from do_swap_page.)

Signed-off-by : KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |   34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

Index: linux-2.6.26-rc2/mm/memcontrol.c
===================================================================
--- linux-2.6.26-rc2.orig/mm/memcontrol.c
+++ linux-2.6.26-rc2/mm/memcontrol.c
@@ -536,28 +536,6 @@ static int mem_cgroup_charge_common(stru
 	if (mem_cgroup_subsys.disabled)
 		return 0;
 
-	/*
-	 * Should page_cgroup's go to their own slab?
-	 * One could optimize the performance of the charging routine
-	 * by saving a bit in the page_flags and using it as a lock
-	 * to see if the cgroup page already has a page_cgroup associated
-	 * with it
-	 */
-retry:
-	lock_page_cgroup(page);
-	pc = page_get_page_cgroup(page);
-	/*
-	 * The page_cgroup exists and
-	 * the page has already been accounted.
-	 */
-	if (unlikely(pc)) {
-		VM_BUG_ON(pc->page != page);
-		VM_BUG_ON(!pc->mem_cgroup);
-		unlock_page_cgroup(page);
-		goto done;
-	}
-	unlock_page_cgroup(page);
-
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (unlikely(pc == NULL))
 		goto err;
@@ -618,15 +596,10 @@ retry:
 	lock_page_cgroup(page);
 	if (unlikely(page_get_page_cgroup(page))) {
 		unlock_page_cgroup(page);
-		/*
-		 * Another charge has been added to this page already.
-		 * We take lock_page_cgroup(page) again and read
-		 * page->cgroup, increment refcnt.... just retry is OK.
-		 */
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 		kmem_cache_free(page_cgroup_cache, pc);
-		goto retry;
+		goto done;
 	}
 	page_assign_page_cgroup(page, pc);
 

