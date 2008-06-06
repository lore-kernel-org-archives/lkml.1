Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbYFFVoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbYFFVoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbYFFVnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:43:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:36857 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbYFFVnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JYVoVWzo/rhBLnvUni0YmIDGWhuX0zC6QAnS8XpLgdLMCbYFmhs3doFrWQjMDhTcgj
         9yGkyBjIDRzs3zgnDcvrQKDXoDd+9eLbT9I+vWPz0TlMUynIgBe64z9HaKeP6+bj14Nk
         9iNu6+BGYeZJ+Yv7XqMun9tGv8zIY8rHgfNtc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: shrink pages should check all
Date: Fri, 6 Jun 2008 14:43:57 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031934.01198.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com>
In-Reply-To: <200806031935.05202.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061443.57488.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we are uing register_e820_active_regions instead of add_active_range directly.
so end_pfn could be different between the value in early_node_map to node_end_pfn.

need to make shrink_active_range more smart.

shrink_active_range is only used x86 32 bit, or need to move back in some file
in arch/x86?

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

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
@@ -3592,25 +3592,51 @@ void __init add_active_range(unsigned in
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
+	int i,j;
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
+		}
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
+		for (j = i; j < nr_nodemap_entries - 1; j++) {
+			early_node_map[j].nid = early_node_map[j+1].nid;
+			early_node_map[j].start_pfn = early_node_map[j+1].start_pfn;
+			early_node_map[j].end_pfn = early_node_map[j+1].end_pfn;
 		}
+		j = nr_nodemap_entries - 1;
+		memset(&early_node_map[j], 0, sizeof(early_node_map[j]));
+		nr_nodemap_entries--;
+	}
 }
 
 /**
