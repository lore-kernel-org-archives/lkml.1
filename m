Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZFIRCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZFIRCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZFIRBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:01:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59495 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbZFIRBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:01:45 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] Count the number of times zone_reclaim() scans and fails
Date: Tue,  9 Jun 2009 18:01:43 +0100
Message-Id: <1244566904-31470-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1244566904-31470-1-git-send-email-mel@csn.ul.ie>
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim. On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
unmapped pages will be reclaimed if the zone watermarks are not being met.

There is a heuristic that determines if the scan is worthwhile but it is
possible that the heuristic will fail and the CPU gets tied up scanning
uselessly. Detecting the situation requires some guesswork and experimentation
so this patch adds a counter "zreclaim_failed" to /proc/vmstat. If during
high CPU utilisation this counter is increasing rapidly, then the resolution
to the problem may be to set /proc/sys/vm/zone_reclaim_mode to 0.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/vmstat.h |    3 +++
 mm/vmscan.c            |    4 ++++
 mm/vmstat.c            |    3 +++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index ff4696c..416f748 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -36,6 +36,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGSTEAL),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
+#ifdef CONFIG_NUMA
+		PGSCAN_ZONERECLAIM_FAILED,
+#endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_HUGETLB_PAGE
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e862fc9..8be4582 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2489,6 +2489,10 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	ret = __zone_reclaim(zone, gfp_mask, order);
 	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 
+	if (!ret) {
+		count_vm_events(PGSCAN_ZONERECLAIM_FAILED, 1);
+	}
+
 	return ret;
 }
 #endif
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 1e3aa81..02677d1 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -673,6 +673,9 @@ static const char * const vmstat_text[] = {
 	TEXTS_FOR_ZONES("pgscan_kswapd")
 	TEXTS_FOR_ZONES("pgscan_direct")
 
+#ifdef CONFIG_NUMA
+	"zreclaim_failed",
+#endif
 	"pginodesteal",
 	"slabs_scanned",
 	"kswapd_steal",
-- 
1.5.6.5

