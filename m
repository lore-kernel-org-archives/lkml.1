Return-Path: <linux-kernel-owner+w=401wt.eu-S1762477AbXGaX1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762477AbXGaX1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbXGaXZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:25:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53900 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754857AbXGaXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:25:13 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 6/7] Simple Performance Counters: Reclaim instrumentation
Date: Tue, 31 Jul 2007 16:25:11 -0700
Message-Id: <1185924312396-git-send-email-clameter@sgi.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: simple-perf-counters
References: simple-perf-counters
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add some performance counters that display the performance
of memory reclaim (both direct and background)

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/perf.h |    4 ++++
 kernel/perf.c        |    6 +++++-
 mm/vmscan.c          |   13 +++++++++++++
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf.h b/include/linux/perf.h
index 795b7ec..2dfc497 100644
--- a/include/linux/perf.h
+++ b/include/linux/perf.h
@@ -16,6 +16,10 @@
 enum pc_item {
 	PC_UPDATE_PROCESS_TIMES,
 	PC_ALLOC_PAGES,
+	PC_DIRECT_RECLAIM_SCANNED,
+	PC_DIRECT_RECLAIM_RECLAIMED,
+	PC_RECLAIM_SCANNED,
+	PC_RECLAIM_RECLAIMED,
 	NR_PC_ITEMS
 };
 
diff --git a/kernel/perf.c b/kernel/perf.c
index dd4e850..ecb768b 100644
--- a/kernel/perf.c
+++ b/kernel/perf.c
@@ -22,7 +22,11 @@ static int unsynced_get_cycles = 1;
 
 const char *var_id[NR_PC_ITEMS] = {
 	"update_process_times",
-	"__alloc_pages"
+	"__alloc_pages",
+	"direct_reclaim_scanned",
+	"direct_reclaim_reclaimed",
+	"reclaim_scanned",
+	"reclaim_reclaimed",
 };
 
 struct perf_counter {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d419e10..2836317 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/perf.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1118,6 +1119,8 @@ static unsigned long shrink_zones(int priority, struct zone **zones,
  */
 unsigned long try_to_free_pages(struct zone **zones, int order, gfp_t gfp_mask)
 {
+	INIT_PC(pc_scanned);
+	INIT_PC(pc_reclaimed);
 	int priority;
 	int ret = 0;
 	unsigned long total_scanned = 0;
@@ -1200,6 +1203,10 @@ out:
 
 		zone->prev_priority = priority;
 	}
+	pc_bytes(&pc_scanned, PAGE_SIZE * sc.nr_scanned,
+				PC_DIRECT_RECLAIM_SCANNED);
+	pc_bytes(&pc_reclaimed, PAGE_SIZE * nr_reclaimed,
+				PC_DIRECT_RECLAIM_RECLAIMED);
 	return ret;
 }
 
@@ -1226,6 +1233,8 @@ out:
  */
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 {
+	INIT_PC(pc_reclaim_scanned);
+	INIT_PC(pc_reclaim_reclaimed);
 	int all_zones_ok;
 	int priority;
 	int i;
@@ -1376,6 +1385,10 @@ out:
 		goto loop_again;
 	}
 
+	pc_bytes(&pc_reclaim_scanned, total_scanned * PAGE_SIZE,
+						PC_RECLAIM_SCANNED);
+	pc_bytes(&pc_reclaim_reclaimed, nr_reclaimed * PAGE_SIZE,
+						PC_RECLAIM_RECLAIMED);
 	return nr_reclaimed;
 }
 
-- 
1.5.2.4

