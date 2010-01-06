Return-Path: <linux-kernel-owner+w=401wt.eu-S932296Ab0AFQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0AFQ0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244Ab0AFQ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:26:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55707 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab0AFQ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:26:12 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/7] Export unusable free space index via /proc/pagetypeinfo
Date: Wed,  6 Jan 2010 16:26:04 +0000
Message-Id: <1262795169-9095-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unusuable free space index is a measure of external fragmentation that
takes the allocation size into account. For the most part, the huge page
size will be the size of interest but not necessarily so it is exported
on a per-order and per-zone basis via /proc/pagetypeinfo.

The index is normally calculated as a value between 0 and 1 which is
obviously unsuitable within the kernel. Instead, the first three decimal
places are used as a value between 0 and 1000 for an integer approximation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmstat.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6051fba..e1ea2d5 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -451,6 +451,104 @@ static int frag_show(struct seq_file *m, void *arg)
 	return 0;
 }
 
+
+struct config_page_info {
+	unsigned long free_pages;
+	unsigned long free_blocks_total;
+	unsigned long free_blocks_suitable;
+};
+
+/*
+ * Calculate the number of free pages in a zone, how many contiguous
+ * pages are free and how many are large enough to satisfy an allocation of
+ * the target size. Note that this function makes to attempt to estimate
+ * how many suitable free blocks there *might* be if MOVABLE pages were
+ * migrated. Calculating that is possible, but expensive and can be
+ * figured out from userspace
+ */
+static void fill_contig_page_info(struct zone *zone,
+				unsigned int suitable_order,
+				struct config_page_info *info)
+{
+	unsigned int order;
+
+	info->free_pages = 0;
+	info->free_blocks_total = 0;
+	info->free_blocks_suitable = 0;
+
+	for (order = 0; order < MAX_ORDER; order++) {
+		unsigned long blocks;
+
+		/* Count number of free blocks */
+		blocks = zone->free_area[order].nr_free;
+		info->free_blocks_total += blocks;
+
+		/* Count free base pages */
+		info->free_pages += blocks << order;
+
+		/* Count the suitable free blocks */
+		if (order >= suitable_order)
+			info->free_blocks_suitable += blocks <<
+						(order - suitable_order);
+	}
+}
+
+/*
+ * Return an index indicating how much of the available free memory is
+ * unusable for an allocation of the requested size.
+ */
+int unusable_free_index(struct zone *zone,
+				unsigned int order,
+				struct config_page_info *info)
+{
+	/* No free memory is interpreted as all free memory is unusable */
+	if (info->free_pages == 0)
+		return 100;
+
+	/*
+	 * Index should be a value between 0 and 1. Return a value to 3
+	 * decimal places.
+	 *
+	 * 0 => no fragmentation
+	 * 1 => high fragmentation
+	 */
+	return ((info->free_pages - (info->free_blocks_suitable << order)) * 1000) / info->free_pages;
+
+}
+
+static void pagetypeinfo_showunusable_print(struct seq_file *m,
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
+		seq_printf(m, "%6d ", unusable_free_index(zone, order, &info));
+	}
+
+	seq_putc(m, '\n');
+}
+
+/*
+ * Display unusable free space index
+ * XXX: Could be a lot more efficient, but it's not a critical path
+ */
+static int pagetypeinfo_showunusable(struct seq_file *m, void *arg)
+{
+	pg_data_t *pgdat = (pg_data_t *)arg;
+
+	seq_printf(m, "\nUnusable free space index at order\n");
+	walk_zones_in_node(m, pgdat, pagetypeinfo_showunusable_print);
+
+	return 0;
+}
+
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -558,6 +656,7 @@ static int pagetypeinfo_show(struct seq_file *m, void *arg)
 	seq_printf(m, "Pages per block:  %lu\n", pageblock_nr_pages);
 	seq_putc(m, '\n');
 	pagetypeinfo_showfree(m, pgdat);
+	pagetypeinfo_showunusable(m, pgdat);
 	pagetypeinfo_showblockcount(m, pgdat);
 
 	return 0;
-- 
1.6.5

