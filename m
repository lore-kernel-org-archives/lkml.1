Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXGZCur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXGZCur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 22:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbXGZCuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 22:50:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57974 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbXGZCui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 22:50:38 -0400
Date: Thu, 26 Jul 2007 11:51:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: [PATCH] config_zone_movable [2/2] config_zone_movable
Message-Id: <20070726115137.2e1cbb9f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070726115020.1ff4513b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070726115020.1ff4513b.kamezawa.hiroyu@jp.fujitsu.com>
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



---
 include/linux/gfp.h    |    3 ++-
 include/linux/mmzone.h |   15 +++++++++++----
 include/linux/vmstat.h |   13 +++++++++++--
 mm/Kconfig             |   12 ++++++++++++
 mm/page_alloc.c        |    6 ++++++
 mm/vmstat.c            |    8 +++++++-
 6 files changed, 49 insertions(+), 8 deletions(-)

Index: linux-2.6.23-rc1/include/linux/mmzone.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/mmzone.h
+++ linux-2.6.23-rc1/include/linux/mmzone.h
@@ -154,7 +154,9 @@ enum zone_type {
 	 */
 	ZONE_HIGHMEM,
 #endif
+#ifdef CONFIG_ZONE_MOVABLE
 	ZONE_MOVABLE,
+#endif
 	MAX_NR_ZONES,
 #ifndef CONFIG_ZONE_DMA
 	ZONE_DMA,
@@ -165,6 +167,9 @@ enum zone_type {
 #ifndef CONFIG_HIGHMEM
 	ZONE_HIGHMEM,
 #endif
+#ifndef CONFIG_ZONE_MOVABLE
+	ZONE_MOVABLE,
+#endif
 };
 
 /*
@@ -550,11 +555,13 @@ static inline int zone_idx_is(enum zone_
 
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
Index: linux-2.6.23-rc1/include/linux/gfp.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/gfp.h
+++ linux-2.6.23-rc1/include/linux/gfp.h
@@ -104,7 +104,8 @@ static inline enum zone_type gfp_zone(gf
 	if (is_configured_zone(ZONE_DMA32) && (flags & __GFP_DMA32))
 		return ZONE_DMA32;
 
-	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
+	if (is_configured_zone(ZONE_MOVABLE) &&
+	    (flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
 			(__GFP_HIGHMEM | __GFP_MOVABLE))
 		return ZONE_MOVABLE;
 
Index: linux-2.6.23-rc1/mm/Kconfig
===================================================================
--- linux-2.6.23-rc1.orig/mm/Kconfig
+++ linux-2.6.23-rc1/mm/Kconfig
@@ -112,6 +112,18 @@ config SPARSEMEM_EXTREME
 	def_bool y
 	depends on SPARSEMEM && !SPARSEMEM_STATIC
 
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
Index: linux-2.6.23-rc1/mm/page_alloc.c
===================================================================
--- linux-2.6.23-rc1.orig/mm/page_alloc.c
+++ linux-2.6.23-rc1/mm/page_alloc.c
@@ -82,7 +82,9 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 #ifdef CONFIG_HIGHMEM
 	 32,
 #endif
+#ifdef CONFIG_ZONE_MOVABLE
 	 32,
+#endif
 };
 
 EXPORT_SYMBOL(totalram_pages);
@@ -3444,6 +3446,10 @@ static int __init cmdline_parse_core(cha
 	if (!p)
 		return -EINVAL;
 
+	if (!is_configured_zone(ZONE_MOVABLE)) {
+		printk ("ZONE_MOVABLE is not configured, %s is ignored.\n",p);
+		return 0;
+	}
 	coremem = memparse(p, &p);
 	*core = coremem >> PAGE_SHIFT;
 
Index: linux-2.6.23-rc1/mm/vmstat.c
===================================================================
--- linux-2.6.23-rc1.orig/mm/vmstat.c
+++ linux-2.6.23-rc1/mm/vmstat.c
@@ -471,8 +471,14 @@ const struct seq_operations fragmentatio
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
Index: linux-2.6.23-rc1/include/linux/vmstat.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/vmstat.h
+++ linux-2.6.23-rc1/include/linux/vmstat.h
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
 

