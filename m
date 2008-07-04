Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYGDJDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYGDJDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 05:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYGDJDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 05:03:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52301 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYGDJD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 05:03:28 -0400
Date: Fri, 4 Jul 2008 18:09:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "hugh@veritas.com" <hugh@veritas.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: [PATCH] memcg: handle shmem's swap cache (Was 2.6.26-rc8-mm1
Message-Id: <20080704180913.bb1a3fc6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My swapcache accounting under memcg patch failed to catch tmpfs(shmem)'s one.
Can I test this under -mm tree ?
(If -mm is busy, I'm not in hurry.)
This patch works well in my box.
=
SwapCache handling fix.

shmem's swapcache behavior is a little different from anonymous's one and
memcg failed to handle it. This patch tries to fix it.

After this:

Any page marked as SwapCache is not uncharged. (delelte_from_swap_cache()
delete the SwapCache flag.)

To check a shmem-page-cache is alive or not we use
 page->mapping && !PageAnon(page) instead of
 pc->flags & PAGE_CGROUP_FLAG_CACHE.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: test-2.6.26-rc8-mm1/mm/memcontrol.c
===================================================================
--- test-2.6.26-rc8-mm1.orig/mm/memcontrol.c
+++ test-2.6.26-rc8-mm1/mm/memcontrol.c
@@ -687,11 +687,45 @@ __mem_cgroup_uncharge_common(struct page
 
 	VM_BUG_ON(pc->page != page);
 
-	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
-	    && ((pc->flags & PAGE_CGROUP_FLAG_CACHE)
-		|| page_mapped(page)
-		|| PageSwapCache(page)))
+	/*
+	 * File Cache
+	 * If called with MEM_CGROUP_CHARGE_TYPE_MAPPED, check page->mapping.
+	 * add_to_page_cache() .... charged before inserting radix-tree.
+	 * remove_from_page_cache() .... uncharged at removing from radix-tree.
+	 * page->mapping && !PageAnon(page) catches file cache.
+	 *
+	 * Anon/Shmem.....We check PageSwapCache(page).
+	 * Anon .... charged before mapped.
+	 * Shmem .... charged at add_to_page_cache() as usual File Cache.
+	 *
+	 * This page will be finally uncharged when removed from swap-cache
+	 *
+	 * we treat 2 cases here.
+	 * A. anonymous page  B. shmem.
+	 * We never uncharge if page is marked as SwapCache.
+	 * add_to_swap_cache() have nothing to do with charge/uncharge.
+	 * SwapCache flag is deleted before delete_from_swap_cache() calls this
+	 *
+	 * shmem's behavior is following. (see shmem.c/swap_state.c also)
+	 * at swap-out:
+	 * 	0. add_to_page_cache()//charged at page creation.
+	 * 	1. add_to_swap_cache() (marked as SwapCache)
+	 *	2. remove_from_page_cache().  (calls this.)
+	 *	(finally) delete_from_swap_cache(). (calls this.)
+	 * at swap-in:
+	 * 	3. add_to_swap_cache() (no charge here.)
+	 * 	4. add_to_page_cache() (charged here.)
+	 * 	5. delete_from_swap_cache() (calls this.)
+	 * PageSwapCache(page) catches "2".
+	 * page->mapping && !PageAnon() catches "5" and avoid uncharging.
+	 */
+	if (PageSwapCache(page))
 		goto unlock;
+	/* called from unmap or delete_from_swap_cache() */
+	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+		&& (page_mapped(page)
+		    || (page->mapping && !PageAnon(page))))/* alive cache ? */
+			goto unlock;
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);

