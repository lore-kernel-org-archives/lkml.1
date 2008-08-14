Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYHNATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYHNATS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYHNATD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:19:03 -0400
Received: from saeurebad.de ([85.214.36.134]:38387 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbYHNATA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:19:00 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH -v2] bootmem: fix aligning of node-relative indexes and offsets
References: <20080812095336.GE5952@alberich.amd.com>
	<877iam41bk.fsf@skyscraper.fehenstaub.lan>
	<20080813164121.GA5985@alberich.amd.com>
	<87tzdo93tv.fsf@skyscraper.fehenstaub.lan>
	<20080813193158.GB5985@alberich.amd.com>
Date: Thu, 14 Aug 2008 02:18:35 +0200
In-Reply-To: <20080813193158.GB5985@alberich.amd.com> (Andreas Herrmann's
	message of "Wed, 13 Aug 2008 21:31:58 +0200")
Message-ID: <87proc8n50.fsf_-_@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Absolute alignment requirements may never be applied to node-relative
offsets.  Andreas Herrmann spotted this flaw when a bootmem allocation
on an unaligned node was itself not aligned because the combination of
an unaligned node with an aligned offset into that node is not
garuanteed to be aligned itself.

This patch introduces two helper functions that align a node-relative
index or offset with respect to the node's starting address so that
the absolute PFN or virtual address that results from combining the
two satisfies the requested alignment.

Then all the broken ALIGN()s in alloc_bootmem_core() are replaced by
these helpers.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Reported-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Debugged-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---

Andrew could you pull this in?  Replaces
alloc_bootmem_core-fix-misaligned-allocation-of-1g-page.patch and is
also needed in upstream.

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 4af15d0..6262d43 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -405,6 +405,29 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
+static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
+			unsigned long step)
+{
+	unsigned long base = bdata->node_min_pfn;
+
+	/*
+	 * Align the index with respect to the node start so that the
+	 * combination of both satisfies the requested alignment.
+	 */
+
+	return ALIGN(base + idx, step) - base;
+}
+
+static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
+			unsigned long align)
+{
+	unsigned long base = PFN_PHYS(bdata->node_min_pfn);
+
+	/* Same as align_idx for byte offsets */
+
+	return ALIGN(base + off, align) - base;
+}
+
 static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
@@ -441,7 +464,7 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - bdata->node_min_pfn;;
+	sidx = start - bdata->node_min_pfn;
 	midx = max - bdata->node_min_pfn;
 
 	if (bdata->hint_idx > sidx) {
@@ -450,7 +473,7 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 		 * catch the fallback below.
 		 */
 		fallback = sidx + 1;
-		sidx = ALIGN(bdata->hint_idx, step);
+		sidx = align_idx(bdata, bdata->hint_idx, step);
 	}
 
 	while (1) {
@@ -459,7 +482,7 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 		unsigned long eidx, i, start_off, end_off;
 find_block:
 		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
-		sidx = ALIGN(sidx, step);
+		sidx = align_idx(bdata, sidx, step);
 		eidx = sidx + PFN_UP(size);
 
 		if (sidx >= midx || eidx > midx)
@@ -467,7 +490,7 @@ find_block:
 
 		for (i = sidx; i < eidx; i++)
 			if (test_bit(i, bdata->node_bootmem_map)) {
-				sidx = ALIGN(i, step);
+				sidx = align_idx(bdata, i, step);
 				if (sidx == i)
 					sidx += step;
 				goto find_block;
@@ -475,7 +498,7 @@ find_block:
 
 		if (bdata->last_end_off &&
 				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
-			start_off = ALIGN(bdata->last_end_off, align);
+			start_off = align_off(bdata, bdata->last_end_off, align);
 		else
 			start_off = PFN_PHYS(sidx);
 
@@ -499,7 +522,7 @@ find_block:
 	}
 
 	if (fallback) {
-		sidx = ALIGN(fallback - 1, step);
+		sidx = align_idx(bdata, fallback - 1, step);
 		fallback = 0;
 		goto find_block;
 	}
