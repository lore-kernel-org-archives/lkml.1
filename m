Return-Path: <linux-kernel-owner+w=401wt.eu-S1765505AbXGYOtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765505AbXGYOtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbXGYOts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:49:48 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:33884 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbXGYOts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:49:48 -0400
Date: Wed, 25 Jul 2007 15:49:44 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bob.picco@hp.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of memmap on IA64 SPARSEMEM when mem_section is not a power of 2
Message-ID: <20070725144944.GD32445@skynet.ie>
References: <20070313104201.GA16842@skynet.ie> <20070724220116.0d9fb8b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070724220116.0d9fb8b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (24/07/07 22:01), Andrew Morton didst pronounce:
> On Tue, 13 Mar 2007 10:42:02 +0000 mel@skynet.ie (Mel Gorman) wrote:
> 
> > There are problems in the use of SPARSEMEM and pageblock flags that causes
> > problems on ia64.
> > 
> > <SNIP>
> 
> SuperH allmodconfig blew up:
> 
> mm/sparse.c: In function `sparse_init':
> mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> mm/sparse.c: In function `sparse_add_one_section':
> mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
> mm/sparse.c:553: warning: assignment makes pointer from integer without a cast

This error is due to a bad interaction between
generic-virtual-memmap-support-for-sparsemem.patch and
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
. Functions that are needed whether CONFIG_SPARSEMEM_VMEMMAP is set are
not are depending on CONFIG_SPARSEMEM_VMEMMAP . This breaks on arch/sh
for example where SPARSEMEM may be set but not NUMA.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

---
 sparse.c |   58 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)


diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc1-mm1-clean/mm/sparse.c linux-2.6.23-rc1-mm1-005-sh-sparsemem-fix/mm/sparse.c
--- linux-2.6.23-rc1-mm1-clean/mm/sparse.c	2007-07-25 13:43:30.000000000 +0100
+++ linux-2.6.23-rc1-mm1-005-sh-sparsemem-fix/mm/sparse.c	2007-07-25 14:27:58.000000000 +0100
@@ -220,6 +220,35 @@ void *alloc_bootmem_high_node(pg_data_t 
 	return NULL;
 }
 
+static unsigned long usemap_size(void)
+{
+	unsigned long size_bytes;
+	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
+	size_bytes = roundup(size_bytes, sizeof(unsigned long));
+	return size_bytes;
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+static unsigned long *__kmalloc_section_usemap(void)
+{
+	return kmalloc(usemap_size(), GFP_KERNEL);
+}
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
+{
+	unsigned long *usemap;
+	struct mem_section *ms = __nr_to_section(pnum);
+	int nid = sparse_early_nid(ms);
+
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	if (usemap)
+		return usemap;
+
+	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	return NULL;
+}
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Virtual Memory Map support
@@ -254,35 +283,6 @@ void *alloc_bootmem_high_node(pg_data_t 
  * 	require one PTE/TLB per PAGE_SIZE chunk of the virtual memory map.
  */
 
-static unsigned long usemap_size(void)
-{
-	unsigned long size_bytes;
- 	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
-	size_bytes = roundup(size_bytes, sizeof(unsigned long));
-	return size_bytes;
-}
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-static unsigned long *__kmalloc_section_usemap(void)
-{
-	return kmalloc(usemap_size(), GFP_KERNEL);
-}
-#endif /* CONFIG_MEMORY_HOTPLUG */
-
-static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
-{
-	unsigned long *usemap;
-	struct mem_section *ms = __nr_to_section(pnum);
-	int nid = sparse_early_nid(ms);
-
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
-	if (usemap)
-		return usemap;
-
-	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
-	return NULL;
-}
-
 /*
  * Allocate a block of memory to be used to back the virtual memory map
  * or to back the page tables that are used to create the mapping.
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
