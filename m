Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXFEVLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXFEVLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765478AbXFEVLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:11:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35707 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764256AbXFEVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:11:13 -0400
Subject: Re: Linux 2.6.22-rc4
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 14:11:48 -0700
Message-Id: <1181077908.9503.48.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 20:50 -0700, Linus Torvalds wrote:
> So -rc4 is out there now, hopefully shrinking the regression list further. 
> 

Nothing serious, compile warnings ..

mm/sparse.c:244: warning: `__kmalloc_section_memmap' defined but not used
mm/sparse.c:274: warning: `__kfree_section_memmap' defined but not used

Here is the patch.

Thanks,
Badari

__kmalloc_section_memmap(), vaddr_in_vmalloc_area() and
 __kfree_section_memmap() are used only for MEMORY_HOTPLUG.
Moved them under CONFIG_MEMORY_HOTPLUG.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

Index: linux-2.6.22-rc4/mm/sparse.c
===================================================================
--- linux-2.6.22-rc4.orig/mm/sparse.c	2007-06-04 17:57:25.000000000 -0700
+++ linux-2.6.22-rc4/mm/sparse.c	2007-06-05 13:56:29.000000000 -0700
@@ -240,6 +240,27 @@ static struct page __init *sparse_early_
 	return NULL;
 }
 
+/*
+ * Allocate the accumulated non-linear sections, allocate a mem_map
+ * for each and record the physical to section mapping.
+ */
+void __init sparse_init(void)
+{
+	unsigned long pnum;
+	struct page *map;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!valid_section_nr(pnum))
+			continue;
+
+		map = sparse_early_mem_map_alloc(pnum);
+		if (!map)
+			continue;
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
+	}
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
 	struct page *page, *ret;
@@ -280,27 +301,6 @@ static void __kfree_section_memmap(struc
 }
 
 /*
- * Allocate the accumulated non-linear sections, allocate a mem_map
- * for each and record the physical to section mapping.
- */
-void __init sparse_init(void)
-{
-	unsigned long pnum;
-	struct page *map;
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!valid_section_nr(pnum))
-			continue;
-
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
-			continue;
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
-	}
-}
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-/*
  * returns the number of sections whose mem_maps were properly
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.




