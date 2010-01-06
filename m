Return-Path: <linux-kernel-owner+w=401wt.eu-S932281Ab0AFQ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0AFQ0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274Ab0AFQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:26:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55717 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235Ab0AFQ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:26:13 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/7] Export fragmentation index via /proc/pagetypeinfo
Date: Wed,  6 Jan 2010 16:26:05 +0000
Message-Id: <1262795169-9095-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fragmentation index is a value that makes sense when an allocation of a
given size would fail. the index indicates whether an allocation failure is
due to a lack of memory (values towards 0) or due to external fragmentation
(value towards 1).  For the most part, the huge page size will be the size
of interest but not necessarily so it is exported on a per-order and per-zone
basis via /proc/pagetypeinfo.

The index is normally calculated as a value between 0 and 1 which is
obviously unsuitable within the kernel. Instead, the first three decimal
places are used as a value between 0 and 1000 for an integer approximation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmstat.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index e1ea2d5..560ee08 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -494,6 +494,35 @@ static void fill_contig_page_info(struct zone *zone,
 }
 
 /*
+ * A fragmentation index only makes sense if an allocation of a requested
+ * size would fail. If that is true, the fragmentation index indicates
+ * whether external fragmentation or a lack of memory was the problem.
+ * The value can be used to determine if page reclaim or compaction
+ * should be used
+ */
+int fragmentation_index(struct zone *zone,
+				unsigned int order,
+				struct config_page_info *info)
+{
+	unsigned long requested = 1UL << order;
+
+	if (!info->free_blocks_total)
+		return 0;
+
+	/* Fragmentation index only makes sense when a request would fail */
+	if (info->free_blocks_suitable)
+		return -1;
+
+	/*
+	 * Index is between 0 and 1 so return within 3 decimal places
+	 *
+	 * 0 => allocation would fail due to lack of memory
+	 * 1 => allocation would fail due to fragmentation
+	 */
+	return 1000 - ( (1000+(info->free_pages * 1000 / requested)) / info->free_blocks_total);
+}
+
+/*
  * Return an index indicating how much of the available free memory is
  * unusable for an allocation of the requested size.
  */
@@ -516,6 +545,39 @@ int unusable_free_index(struct zone *zone,
 
 }
 
+static void pagetypeinfo_showfragmentation_print(struct seq_file *m,
+					pg_data_t *pgdat, struct zone *zone)
+{
+	unsigned int order;
+
+	/* Alloc on stack as interrupts are disabled for zone walk */
+	struct config_page_info info;
+
+	seq_printf(m, "Node %4d, zone %8s %19s",
+				pgdat->node_id,
+				zone->name, " ");
+	for (order = 0; order < MAX_ORDER; ++order) {
+		fill_contig_page_info(zone, order, &info);
+		seq_printf(m, "%6d ", fragmentation_index(zone, order, &info));
+	}
+
+	seq_putc(m, '\n');
+}
+
+/*
+ * Display fragmentation index for orders that allocations would fail for
+ * XXX: Could be a lot more efficient, but it's not a critical path
+ */
+static int pagetypeinfo_showfragmentation(struct seq_file *m, void *arg)
+{
+	pg_data_t *pgdat = (pg_data_t *)arg;
+
+	seq_printf(m, "\nFragmentation index at order\n");
+	walk_zones_in_node(m, pgdat, pagetypeinfo_showfragmentation_print);
+
+	return 0;
+}
+
 static void pagetypeinfo_showunusable_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -657,6 +719,7 @@ static int pagetypeinfo_show(struct seq_file *m, void *arg)
 	seq_putc(m, '\n');
 	pagetypeinfo_showfree(m, pgdat);
 	pagetypeinfo_showunusable(m, pgdat);
+	pagetypeinfo_showfragmentation(m, pgdat);
 	pagetypeinfo_showblockcount(m, pgdat);
 
 	return 0;
-- 
1.6.5

