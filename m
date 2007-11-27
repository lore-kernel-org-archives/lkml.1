Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbXK0CzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbXK0CzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbXK0CzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:55:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43200 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbXK0CzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:55:11 -0500
Date: Tue, 27 Nov 2007 11:58:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [1/10] add scan_global_lru macro
Message-Id: <20071127115812.69a83112.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

add macro scan_global_lru().

This is used to detect which scan_control scans global lru or
mem_cgroup lru. And compiled to be static value (1) when 
memory controller is not configured. This may make the meaning obvious.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 mm/vmscan.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

Index: linux-2.6.24-rc3-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.24-rc3-mm1.orig/mm/vmscan.c	2007-11-26 15:31:19.000000000 +0900
+++ linux-2.6.24-rc3-mm1/mm/vmscan.c	2007-11-26 16:38:46.000000000 +0900
@@ -127,6 +127,12 @@
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
+#ifdef CONFIG_CGROUP_MEM_CONT
+#define scan_global_lru(sc)	(!(sc)->mem_cgroup)
+#else
+#define scan_global_lru(sc)	(1)
+#endif
+
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1290,11 +1296,12 @@
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
 		 */
-		if (sc->mem_cgroup == NULL)
+		if (scan_global_lru(sc)) {
 			shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);
-		if (reclaim_state) {
-			nr_reclaimed += reclaim_state->reclaimed_slab;
-			reclaim_state->reclaimed_slab = 0;
+			if (reclaim_state) {
+				nr_reclaimed += reclaim_state->reclaimed_slab;
+				reclaim_state->reclaimed_slab = 0;
+			}
 		}
 		total_scanned += sc->nr_scanned;
 		if (nr_reclaimed >= sc->swap_cluster_max) {
@@ -1321,7 +1328,7 @@
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
-	if (!sc->all_unreclaimable && sc->mem_cgroup == NULL)
+	if (!sc->all_unreclaimable && scan_global_lru(sc))
 		ret = 1;
 out:
 	/*

