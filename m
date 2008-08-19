Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYHSIcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYHSIcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYHSIcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:32:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56001 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYHSIcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:32:31 -0400
Date: Tue, 19 Aug 2008 17:38:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [2/9]
Message-Id: <20080819173834.f6baad3f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes placement of mem_cgroup_uncharge_cache_page().

After this patch, mem_cgroup_uncharge_cache_page() is called only after
page->mapping is cleared. This will make uncharge() handling easier in future.
(And error check code is added.)

Signed-off-by: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/filemap.c    |    2 +-
 mm/memcontrol.c |    1 +
 mm/migrate.c    |   13 ++++++++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.27-rc1-mm1/mm/filemap.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/filemap.c
+++ linux-2.6.27-rc1-mm1/mm/filemap.c
@@ -116,12 +116,12 @@ void __remove_from_page_cache(struct pag
 {
 	struct address_space *mapping = page->mapping;
 
-	mem_cgroup_uncharge_cache_page(page);
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	BUG_ON(page_mapped(page));
+	mem_cgroup_uncharge_cache_page(page);
 
 	/*
 	 * Some filesystems seem to re-dirty the page even after
Index: linux-2.6.27-rc1-mm1/mm/migrate.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/migrate.c
+++ linux-2.6.27-rc1-mm1/mm/migrate.c
@@ -330,8 +330,6 @@ static int migrate_page_move_mapping(str
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
 	spin_unlock_irq(&mapping->tree_lock);
-	if (!PageSwapCache(newpage))
-		mem_cgroup_uncharge_cache_page(page);
 
 	return 0;
 }
@@ -378,7 +376,16 @@ static void migrate_page_copy(struct pag
 #endif
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	page->mapping = NULL;
+
+	/* PageAnon() checks page->mapping's bit */
+	if (PageAnon(page)) {
+		/* This page is uncharged in try_to_unmap() */
+		page->mapping = NULL;
+	} else {
+		/* This page was removed from radix-tree.*/
+		page->mapping = NULL;
+		mem_cgroup_uncharge_cache_page(page);
+	}
 
 	/*
 	 * If any waiters have accumulated on the new page then
Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -804,6 +804,7 @@ void mem_cgroup_uncharge_page(struct pag
 void mem_cgroup_uncharge_cache_page(struct page *page)
 {
 	VM_BUG_ON(page_mapped(page));
+	VM_BUG_ON(page->mapping);
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
 }
 

