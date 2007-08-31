Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbXHaKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbXHaKOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbXHaKOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:14:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56515 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968AbXHaKOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:14:01 -0400
Date: Fri, 31 Aug 2007 19:14:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: [PATCH] CONFIG_ZONE_MOVABLE [2/2] config zone movable
Message-Id: <20070831191415.a111636b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070831191202.50fe90b3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070831191202.50fe90b3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Makes ZONE_MOVABLE as configurable

Based on "zone_ifdef_cleanup_by_renumbering.patch"

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



Index: devel-2.6.23-rc3-mm1/include/linux/mmzone.h
===================================================================
--- devel-2.6.23-rc3-mm1.orig/include/linux/mmzone.h
+++ devel-2.6.23-rc3-mm1/include/linux/mmzone.h
@@ -177,7 +177,9 @@ enum zone_type {
 	 */
 	ZONE_HIGHMEM,
 #endif
+#ifdef CONFIG_ZONE_MOVABLE
 	ZONE_MOVABLE,
+#endif
 	MAX_NR_ZONES,
 #ifndef CONFIG_ZONE_DMA
 	ZONE_DMA,
@@ -188,6 +190,9 @@ enum zone_type {
 #ifndef CONFIG_HIGHMEM
 	ZONE_HIGHMEM,
 #endif
+#ifndef CONFIG_ZONE_MOVABLE
+	ZONE_MOVABLE,
+#endif
 };
 
 /*
@@ -612,11 +617,13 @@ static inline int zone_idx_is(enum zone_
 
 static inline int zone_movable_is_highmem(void)
 {
-#if CONFIG_ARCH_POPULATES_NODE_MAP
-	if (is_configured_zone(ZONE_HIGHMEM))
-		return movable_zone == ZONE_HIGHMEM;
-#endif
+#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+	return is_configured_zone(ZONE_HIGHMEM) &&
+	       is_configured_zone(ZONE_MOVABLE) &&
+		(movable_zone == ZONE_HIGHMEM);
+#else
 	return 0;
+#endif
 }
 
 static inline int is_highmem_idx(enum zone_type idx)
Index: devel-2.6.23-rc3-mm1/include/linux/gfp.h
===================================================================
--- devel-2.6.23-rc3-mm1.orig/include/linux/gfp.h
+++ devel-2.6.23-rc3-mm1/include/linux/gfp.h
@@ -130,7 +130,8 @@ static inline enum zone_type gfp_zone(gf
 	if (is_configured_zone(ZONE_DMA32) && (flags & __GFP_DMA32))
 		return base + ZONE_DMA32;
 
-	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
+	if (is_configured_zone(ZONE_MOVABLE) &&
+	    (flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
 			(__GFP_HIGHMEM | __GFP_MOVABLE))
 		return base + ZONE_MOVABLE;
 
Index: devel-2.6.23-rc3-mm1/mm/Kconfig
===================================================================
--- devel-2.6.23-rc3-mm1.orig/mm/Kconfig
+++ devel-2.6.23-rc3-mm1/mm/Kconfig
@@ -125,6 +125,18 @@ config SPARSEMEM_VMEMMAP
 	depends on SPARSEMEM
 	default y if (SPARSEMEM_VMEMMAP_ENABLE)
 
+
+config ZONE_MOVABLE
+	bool	"Zone for movable pages"
+	depends on ARCH_POPULATES_NODE_MAP
+	help
+	  Allows creating a zone type only for movable pages, e.g. page cache
+	  and anonymous memory. Because movable pages are easily reclaimed
+	  and page migration technique can move them, your chance for allocating
+	  contiguous memory such as huge pages will be better than other zones.
+	  To use this zone, please see "kernelcore=" or "movablecore=" in
+	  Documentation/kernel-parameters.txt
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
Index: devel-2.6.23-rc3-mm1/mm/page_alloc.c
===================================================================
--- devel-2.6.23-rc3-mm1.orig/mm/page_alloc.c
+++ devel-2.6.23-rc3-mm1/mm/page_alloc.c
@@ -95,7 +95,9 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 #ifdef CONFIG_HIGHMEM
 	 32,
 #endif
+#ifdef CONFIG_ZONE_MOVABLE
 	 32,
+#endif
 };
 
 EXPORT_SYMBOL(totalram_pages);
@@ -4000,6 +4002,10 @@ static int __init cmdline_parse_core(cha
 	if (!p)
 		return -EINVAL;
 
+	if (!is_configured_zone(ZONE_MOVABLE)) {
+		printk ("ZONE_MOVABLE is not configured, %s is ignored.\n",p);
+		return 0;
+	}
 	coremem = memparse(p, &p);
 	*core = coremem >> PAGE_SHIFT;
 
Index: devel-2.6.23-rc3-mm1/mm/vmstat.c
===================================================================
--- devel-2.6.23-rc3-mm1.orig/mm/vmstat.c
+++ devel-2.6.23-rc3-mm1/mm/vmstat.c
@@ -678,8 +678,14 @@ const struct seq_operations pagetypeinfo
 #define TEXT_FOR_HIGHMEM(xx)
 #endif
 
+#ifdef CONFIG_ZONE_MOVABLE
+#define TEXT_FOR_MOVABLE(xx) xx "_movable",
+#else
+#define TEXT_FOR_MOVABLE(xx)
+#endif
+
 #define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
-					TEXT_FOR_HIGHMEM(xx) xx "_movable",
+					TEXT_FOR_HIGHMEM(xx) xx TEXT_FOR_MOVABLE(xx)
 
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
Index: devel-2.6.23-rc3-mm1/include/linux/vmstat.h
===================================================================
--- devel-2.6.23-rc3-mm1.orig/include/linux/vmstat.h
+++ devel-2.6.23-rc3-mm1/include/linux/vmstat.h
@@ -25,7 +25,14 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
+#ifdef CONFIG_ZONE_MOVABLE
+#define MOVABLE_ZONE(xx) , xx##_MOVABLE
+#else
+#define MOVABLE_ZONE(xx)
+#endif
+
+
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) MOVABLE_ZONE(xx)
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
@@ -170,7 +177,9 @@ static inline unsigned long node_page_st
 	if (is_configured_zone(ZONE_HIGHMEM))
 		val += zone_page_state(&zones[ZONE_HIGHMEM], item);
 
-	val += zone_page_state(&zones[ZONE_MOVABLE], item);
+	if (is_configured_zone(ZONE_MOVABLE))
+		val += zone_page_state(&zones[ZONE_MOVABLE], item);
+
 	return val;
 }
 

