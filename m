Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbYFGByh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbYFGByh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbYFGByI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:54:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433AbYFGBx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kdhsXxVfn+WPgiGvG8ugNVV4g138zv8U6a1FwTxOBXLfhWh1Gi3KAq6awbKwyhnlCI
         5860xQQw6OCUsjtlIKhVJ39kwi5Ul/G93PwSqmpYKWZY47K36wdtjknejsuUymoYIFGc
         6ccP14KBoahMlB0HdE1AJhBbPPAK5HOPTf1Sc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: numa32 use find_e820_area to find KVA ram on node
Date: Fri, 6 Jun 2008 18:53:33 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com> <200806061443.57488.yhlu.kernel@gmail.com>
In-Reply-To: <200806061443.57488.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061853.33968.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't assume we can use ram near end of every node.
esp some system has less memory. and they could have
kva address and kva ram all below max_low_pfn

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -225,17 +225,21 @@ static unsigned long calculate_numa_rema
 {
 	int nid;
 	unsigned long size, reserve_pages = 0;
-	unsigned long pfn;
 
 	for_each_online_node(nid) {
-		unsigned old_end_pfn = node_end_pfn[nid];
+		u64 node_end_target;
+		u64 node_end_final;
 
 		/*
 		 * The acpi/srat node info can show hot-add memroy zones
 		 * where memory could be added but not currently present.
 		 */
+		printk("node %d pfn: [%lx - %lx]\n",
+			nid, node_start_pfn[nid], node_end_pfn[nid]);
 		if (node_start_pfn[nid] > max_pfn)
 			continue;
+		if (!node_end_pfn[nid])
+			continue;
 		if (node_end_pfn[nid] > max_pfn)
 			node_end_pfn[nid] = max_pfn;
 
@@ -247,37 +251,40 @@ static unsigned long calculate_numa_rema
 		/* now the roundup is correct, convert to PAGE_SIZE pages */
 		size = size * PTRS_PER_PTE;
 
-		/*
-		 * Validate the region we are allocating only contains valid
-		 * pages.
-		 */
-		for (pfn = node_end_pfn[nid] - size;
-		     pfn < node_end_pfn[nid]; pfn++)
-			if (!page_is_ram(pfn))
-				break;
+		node_end_target = round_down(node_end_pfn[nid] - size,
+						 PTRS_PER_PTE);
+		node_end_target <<= PAGE_SHIFT;
+		do {
+			node_end_final = find_e820_area(node_end_target,
+					((u64)node_end_pfn[nid])<<PAGE_SHIFT,
+						((u64)size)<<PAGE_SHIFT,
+						LARGE_PAGE_BYTES);
+			node_end_target -= LARGE_PAGE_BYTES;
+		} while (node_end_final == -1ULL &&
+			 (node_end_target>>PAGE_SHIFT) > (node_start_pfn[nid]));
 
-		if (pfn != node_end_pfn[nid])
-			size = 0;
+		if (node_end_final == -1ULL)
+			panic("Can not get kva ram\n");
 
 		printk("Reserving %ld pages of KVA for lmem_map of node %d\n",
 				size, nid);
 		node_remap_size[nid] = size;
 		node_remap_offset[nid] = reserve_pages;
 		reserve_pages += size;
-		printk("Shrinking node %d from %ld pages to %ld pages\n",
-			nid, node_end_pfn[nid], node_end_pfn[nid] - size);
+		printk("Shrinking node %d from %ld pages to %lld pages\n",
+			nid, node_end_pfn[nid], node_end_final>>PAGE_SHIFT);
 
-		if (node_end_pfn[nid] & (PTRS_PER_PTE-1)) {
-			/*
-			 * Align node_end_pfn[] and node_remap_start_pfn[] to
-			 * pmd boundary. remap_numa_kva will barf otherwise.
-			 */
-			printk("Shrinking node %d further by %ld pages for proper alignment\n",
-				nid, node_end_pfn[nid] & (PTRS_PER_PTE-1));
-			size +=  node_end_pfn[nid] & (PTRS_PER_PTE-1);
-		}
+		/*
+		 *  prevent kva address below max_low_pfn want it on system
+		 *  with less memory later.
+		 *  layout will be: KVA address , KVA RAM
+		 */
+		if ((node_end_final>>PAGE_SHIFT) < max_low_pfn)
+			reserve_early(node_end_final,
+				      node_end_final+(((u64)size)<<PAGE_SHIFT),
+				      "KVA RAM");
 
-		node_end_pfn[nid] -= size;
+		node_end_pfn[nid] = node_end_final>>PAGE_SHIFT;
 		node_remap_start_pfn[nid] = node_end_pfn[nid];
 		shrink_active_range(nid, node_end_pfn[nid]);
 	}
