Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbZBFJ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbZBFJ4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZBFJ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:56:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47939 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZBFJ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:56:27 -0500
Date: Fri, 6 Feb 2009 18:55:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, davem@davemlloft.net,
       heiko.carstens@de.ibm.com, mel@csn.ul.ie, stable@kernel.org
Subject: [BUGFIX][PATCH] Aditional fix for memmap initalization
Message-Id: <20090206185514.8355c61b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090206171724.77c4b5ed.kamezawa.hiroyu@jp.fujitsu.com>
References: <200902051729.n15HTsCC000590@imap1.linux-foundation.org>
	<20090206171724.77c4b5ed.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 17:17:24 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 05 Feb 2009 09:29:54 -0800
> akpm@linux-foundation.org wrote:
> 
> > 
> > The patch titled
> >      mm: fix memmap init to initialize valid memmap for memory hole
> > has been added to the -mm tree.  Its filename is
> >      mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
<snip>
> > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > 
> Sorry, Kosaki reported me that this patch breaks ia64 compile/boot.
> So, I'm fixing the bug in cooperation with him, now.
> I think I can send a fix soon. But I hope this patch set for BOOT will be
> tested under various arch/configs before going up to.
> 

This is an add-on fix. Tested on ia64 DISCONTIGMEM/SPARSEMEM, x86-64 fake-numa.

The patch mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
breaks ia64's compile and boot.

After investigation, changing return value of early_pfn_to_nid() doesn't seem
to be very good. This patch adds early_pfn_to_nid_solid() for our purpose
(init memmap) and fixes all breakage.

Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/ia64/mm/numa.c   |   12 ++++++++++--
 arch/x86/mm/numa_64.c |    6 +++++-
 include/linux/mm.h    |    1 +
 mm/page_alloc.c       |   39 +++++++++++++++++++++++++++++----------
 4 files changed, 45 insertions(+), 13 deletions(-)

Index: mmotm-2.6.29-Feb05/include/linux/mm.h
===================================================================
--- mmotm-2.6.29-Feb05.orig/include/linux/mm.h
+++ mmotm-2.6.29-Feb05/include/linux/mm.h
@@ -1049,6 +1049,7 @@ extern void work_with_active_regions(int
 extern void sparse_memory_present_with_active_regions(int nid);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
+extern int early_pfn_to_solid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 extern void set_dma_reserve(unsigned long new_dma_reserve);
Index: mmotm-2.6.29-Feb05/arch/ia64/mm/numa.c
===================================================================
--- mmotm-2.6.29-Feb05.orig/arch/ia64/mm/numa.c
+++ mmotm-2.6.29-Feb05/arch/ia64/mm/numa.c
@@ -58,7 +58,7 @@ paddr_to_nid(unsigned long paddr)
  * SPARSEMEM to allocate the SPARSEMEM sectionmap on the NUMA node where
  * the section resides.
  */
-int early_pfn_to_nid(unsigned long pfn)
+int early_pfn_to_nid_solid(unsigned long pfn)
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
 
@@ -70,9 +70,17 @@ int early_pfn_to_nid(unsigned long pfn)
 			return node_memblk[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
 
+int early_pfn_to_nid(unsigned long pfn)
+{
+	int nid = early_pfn_to_nid_solid(pfn);
+
+	if (nid < 0) /* see page_alloc.c */
+		return 0;
+	return nid;
+}
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
  *  SRAT information is stored in node_memblk[], then we can use SRAT
Index: mmotm-2.6.29-Feb05/arch/x86/mm/numa_64.c
===================================================================
--- mmotm-2.6.29-Feb05.orig/arch/x86/mm/numa_64.c
+++ mmotm-2.6.29-Feb05/arch/x86/mm/numa_64.c
@@ -166,10 +166,14 @@ int __init compute_hash_shift(struct boo
 	return shift;
 }
 
-int early_pfn_to_nid(unsigned long pfn)
+int early_pfn_to_nid_solid(unsigned long pfn)
 {
 	return phys_to_nid(pfn << PAGE_SHIFT);
 }
+int early_pfn_to_nid(unsigned long pfn)
+{
+	return early_pfn_to_nid_solid(pfn);
+}
 
 static void * __init early_node_mem(int nodeid, unsigned long start,
 				    unsigned long end, unsigned long size,
Index: mmotm-2.6.29-Feb05/mm/page_alloc.c
===================================================================
--- mmotm-2.6.29-Feb05.orig/mm/page_alloc.c
+++ mmotm-2.6.29-Feb05/mm/page_alloc.c
@@ -2554,6 +2554,21 @@ static inline unsigned long wait_table_b
  * higher will lead to a bigger reserve which will get freed as contiguous
  * blocks as reclaim kicks in
  */
+#ifdef CONFIG_NODE_SPAN_OTHER_NODE
+static inline bool init_pfn_under_nid(unsigned long pfn, int nid)
+{
+	int nid_in_map = early_pfn_to_nid_solid(pfn);
+
+	if (nid_in_map == -1)
+		return true;
+	return (nid_in_map == nid);
+}
+#else
+static inline bool init_pfn_under_nid(unsigned long pfn, int nid)
+{
+	return true;
+}
+#endif
 static void setup_zone_migrate_reserve(struct zone *zone)
 {
 	unsigned long start_pfn, pfn, end_pfn;
@@ -2630,18 +2645,13 @@ void __meminit memmap_init_zone(unsigned
 		 * exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
-			int nid_from_node_memory_map;
-
 			if (!early_pfn_valid(pfn))
 				continue;
 			/*
-			 * early_pfn_to_nid() returns -1 if the page doesn't
-			 * exist in early_node_map[]. Initialize it in force
-			 * and set PG_reserved at el.
+			 * This returns false if the page exists and it's
+			 * not under this node.
 			 */
-			nid_from_node_memory_map = early_pfn_to_nid(pfn);
-			if (nid_from_node_memory_map > -1 &&
-				nid_from_node_memory_map != nid)
+			if (!init_pfn_under_nid(pfn, nid))
 				continue;
 		}
 		page = pfn_to_page(pfn);
@@ -2996,7 +3006,7 @@ static int __meminit next_active_region_
  * was used and there are no special requirements, this is a convenient
  * alternative
  */
-int __meminit early_pfn_to_nid(unsigned long pfn)
+int __meminit early_pfn_to_nid_solid(unsigned long pfn)
 {
 	int i;
 
@@ -3007,9 +3017,18 @@ int __meminit early_pfn_to_nid(unsigned 
 		if (start_pfn <= pfn && pfn < end_pfn)
 			return early_node_map[i].nid;
 	}
-
 	return -1;
 }
+/* Allow fallback to 0 */
+int __meminit early_pfn_to_nid(unsigned long pfn)
+{
+	int nid;
+
+	nid = early_pfn_to_nid_solid(pfn);
+	if (nid < 0)
+		return 0;
+	return nid;
+}
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 /* Basic iterator support to walk early_node_map[] */

