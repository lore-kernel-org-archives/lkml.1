Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYFICjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYFICjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 22:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYFICiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 22:38:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:11499 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbYFICiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 22:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TqiS+LffIrcrT5CBxsycb5Jc59+75XZgh27VZtoA0G2LJWHco+s/VPTOej6Q0tOskB
         BkO6qOY0NnrtHOjXipFgDwg1LmEQg2jOgMMW6bCTt9d5l6+dADOxKShG931YEtYvzmXf
         ofIvIqJaiijbdVFviLJF+BndCuy5c0Vril3mU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: shrink pages should check all v2
Date: Sun, 8 Jun 2008 19:39:16 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com> <200806061443.57488.yhlu.kernel@gmail.com>
In-Reply-To: <200806061443.57488.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081939.16577.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we are uing register_e820_active_regions instead of add_active_range directly.
so end_pfn could be different between the value in early_node_map to node_end_pfn.

need to make shrink_active_range more smart.

shrink_active_range is only used x86 32 bit, or need to move back in some file
in arch/x86?

v2: use memcpy instead

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -997,8 +997,7 @@ extern void free_area_init_node(int nid,
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
 extern void add_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
-extern void shrink_active_range(unsigned int nid, unsigned long old_end_pfn,
-						unsigned long new_end_pfn);
+extern void shrink_active_range(unsigned int nid, unsigned long new_end_pfn);
 extern void push_node_boundaries(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3592,25 +3592,49 @@ void __init add_active_range(unsigned in
 /**
  * shrink_active_range - Shrink an existing registered range of PFNs
  * @nid: The node id the range is on that should be shrunk
- * @old_end_pfn: The old end PFN of the range
  * @new_end_pfn: The new PFN of the range
  *
  * i386 with NUMA use alloc_remap() to store a node_mem_map on a local node.
- * The map is kept at the end physical page range that has already been
- * registered with add_active_range(). This function allows an arch to shrink
- * an existing registered range.
+ * The map is kept near the end physical page range that has already been
+ * registered. This function allows an arch to shrink an existing registered
+ * range.
  */
-void __init shrink_active_range(unsigned int nid, unsigned long old_end_pfn,
-						unsigned long new_end_pfn)
+void __init shrink_active_range(unsigned int nid, unsigned long new_end_pfn)
 {
-	int i;
+	int i, j;
+	int removed = 0;
 
 	/* Find the old active region end and shrink */
-	for_each_active_range_index_in_nid(i, nid)
-		if (early_node_map[i].end_pfn == old_end_pfn) {
+	for_each_active_range_index_in_nid(i, nid) {
+		if (early_node_map[i].start_pfn >= new_end_pfn) {
+			/* clear it */
+			early_node_map[i].end_pfn = 0;
+			removed = 1;
+			continue;
+		}
+		if (early_node_map[i].end_pfn > new_end_pfn) {
 			early_node_map[i].end_pfn = new_end_pfn;
-			break;
+			continue;
 		}
+	}
+
+	if (!removed)
+		return;
+
+	/* remove the blank ones */
+	for (i = nr_nodemap_entries - 1; i > 0; i--) {
+		if (early_node_map[i].nid != nid)
+			continue;
+		if (early_node_map[i].end_pfn)
+			continue;
+		/* we found it, get rid of it */
+		for (j = i; j < nr_nodemap_entries - 1; j++)
+			memcpy(&early_node_map[j], &early_node_map[j+1],
+				sizeof(early_node_map[j]));
+		j = nr_nodemap_entries - 1;
+		memset(&early_node_map[j], 0, sizeof(early_node_map[j]));
+		nr_nodemap_entries--;
+	}
 }
 
 /**
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -279,7 +279,7 @@ static unsigned long calculate_numa_rema
 
 		node_end_pfn[nid] -= size;
 		node_remap_start_pfn[nid] = node_end_pfn[nid];
-		shrink_active_range(nid, old_end_pfn, node_end_pfn[nid]);
+		shrink_active_range(nid, node_end_pfn[nid]);
 	}
 	printk("Reserving total of %ld pages for numa KVA remap\n",
 			reserve_pages);
