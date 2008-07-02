Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbYGBCLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbYGBCLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbYGBCK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:10:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35287 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751AbYGBCK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:10:58 -0400
Date: Wed, 2 Jul 2008 11:16:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH] memcg: shmem swap cache
Message-Id: <20080702111618.3d7138bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <25019527.1214873805265.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0806302024050.27080@blonde.site>
	<Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290120270.21758@blonde.site>
	<20080630173631.a252bb0e.kamezawa.hiroyu@jp.fujitsu.com>
	<25019527.1214873805265.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 09:56:45 +0900 (JST)
kamezawa.hiroyu@jp.fujitsu.com wrote:

> >>   - shmem's page is removed by mem_cgroup_uncharge_cache_page(), So,
> >>     shmem's swapcache is not charged.
> >
> >Ah, that's interesting: I'd assumed you'd changed that in your
> >no-refcount patches, and had been surprised not to notice a slowdown
> >(waiting for swap to be written and freed before coming under limit).
> >Now you want to make them wait: not entirely an improvement,
> >but I see your point.
> >
> To do this is (maybe) a few line patch. I'll CC you if I wrote some.
> 
maybe like this. how do you feel ?
I'll stack this on my queue and test for a while.

==
SwapCache handling fix.

memcg failed to handle shmem's swapcache. This patch tries to fix it.

After this:

Any page marked as SwapCache is not uncharged.
(until delelte_from_swap_cache() delete the flag.)

To check a page is alive shmem-page-cache or not we use
 page->mapping && !PageAnon(page) instead of pc->flags & PAGE_CGROUP_FLAG_CACHE.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: test-2.6.26-rc5-mm3++/mm/memcontrol.c
===================================================================
--- test-2.6.26-rc5-mm3++.orig/mm/memcontrol.c	2008-07-02 09:29:52.000000000 +0900
+++ test-2.6.26-rc5-mm3++/mm/memcontrol.c	2008-07-02 10:58:15.000000000 +0900
@@ -685,11 +685,45 @@
 
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

