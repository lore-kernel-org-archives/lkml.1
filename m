Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYFYKJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYFYKJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYFYKJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:09:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59552 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbYFYKJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:09:24 -0400
Date: Wed, 25 Jun 2008 19:09:06 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [-mm][PATCH 8/10] fix shmem page migration incorrectness on memcgroup
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080625190750.D864.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


=
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_uncharge() against old page is done after radix-tree-replacement.
And there were special handling to ingore swap-cache page. But, shmem can
be swap-cache and file-cache at the same time. Chekcing PageSwapCache() is
not correct here. Check PageAnon() instead.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/migrate.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: b/mm/migrate.c
===================================================================
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -332,7 +332,13 @@ static int migrate_page_move_mapping(str
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
 	spin_unlock_irq(&mapping->tree_lock);
-	if (!PageSwapCache(newpage))
+
+	/*
+	 * The page is removed from radix-tree implicitly.
+	 * We uncharge it here but swap cache of anonymous page should be
+	 * uncharged by mem_cgroup_ucharge_page().
+	 */
+	if (!PageAnon(newpage))
 		mem_cgroup_uncharge_cache_page(page);
 
 	return 0;
@@ -381,7 +387,8 @@ static void migrate_page_copy(struct pag
 		/*
 		 * SwapCache is removed implicitly. Uncharge against swapcache
 		 * should be called after ClearPageSwapCache() because
-		 * mem_cgroup_uncharge_page checks the flag.
+		 * mem_cgroup_uncharge_page checks the flag. shmem's swap cache
+		 * is uncharged before here.
 		 */
 		mem_cgroup_uncharge_page(page);
 	}


