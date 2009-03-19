Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbZCSSkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbZCSSkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZCSSk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:40:26 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:51030 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZCSSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:40:26 -0400
Date: Thu, 19 Mar 2009 14:37:59 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 24/27] Convert gfp_zone() to use a table of precalculated
 values
In-Reply-To: <20090319181116.GA24586@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903191437030.11663@qirst.com>
References: <20090318135222.GA4629@csn.ul.ie> <alpine.DEB.1.10.0903181011210.7901@qirst.com> <20090318153508.GA24462@csn.ul.ie> <alpine.DEB.1.10.0903181300540.15570@qirst.com> <20090318181717.GC24462@csn.ul.ie> <alpine.DEB.1.10.0903181507120.10154@qirst.com>
 <20090318194604.GD24462@csn.ul.ie> <20090319090456.fb11e23c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0903191105090.8100@qirst.com> <alpine.DEB.1.10.0903191251310.24152@qirst.com> <20090319181116.GA24586@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some macros can get us around the problems:


Subject: Use a table lookup for gfp_zone and check for errors in flags passed to the page allocator

Use a table to lookup the zone to use given gfp_flags using gfp_zone().

This simplifies the code in gfp_zone() and also keeps the ability of the compiler to
use constant folding to get rid of gfp_zone processing.

We are doing some macro tricks here to convince the compiler to always do the
constant folding if possible.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h	2009-03-19 11:43:32.000000000 -0500
+++ linux-2.6/include/linux/gfp.h	2009-03-19 13:32:48.000000000 -0500
@@ -19,7 +19,8 @@
 #define __GFP_DMA	((__force gfp_t)0x01u)
 #define __GFP_HIGHMEM	((__force gfp_t)0x02u)
 #define __GFP_DMA32	((__force gfp_t)0x04u)
-
+#define __GFP_MOVABLE	((__force gfp_t)0x08u)  /* Page is movable */
+#define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
 /*
  * Action modifiers - doesn't change the zoning
  *
@@ -49,7 +50,6 @@
 #define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
-#define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */

 #define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
@@ -111,24 +111,63 @@
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }

-static inline enum zone_type gfp_zone(gfp_t flags)
-{
+#ifdef CONFIG_ZONE_HIGHMEM
+#define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
+#else
+#define OPT_ZONE_HIGHMEM ZONE_NORMAL
+#endif
+
 #ifdef CONFIG_ZONE_DMA
-	if (flags & __GFP_DMA)
-		return ZONE_DMA;
+#define OPT_ZONE_DMA ZONE_DMA
+#else
+#define OPT_ZONE_DMA ZONE_NORMAL
 #endif
+
 #ifdef CONFIG_ZONE_DMA32
-	if (flags & __GFP_DMA32)
-		return ZONE_DMA32;
+#define OPT_ZONE_DMA32 ZONE_DMA32
+#else
+#define OPT_ZONE_DMA32 OPT_ZONE_DMA
 #endif
-	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
-			(__GFP_HIGHMEM | __GFP_MOVABLE))
-		return ZONE_MOVABLE;
-#ifdef CONFIG_HIGHMEM
-	if (flags & __GFP_HIGHMEM)
-		return ZONE_HIGHMEM;
+
+#define GFP_ZONE_TABLE \
+const enum zone_type gfp_zone_table[GFP_ZONEMASK + 1] = {		\
+	ZONE_NORMAL,		/* 00 No flags set */			\
+	OPT_ZONE_DMA,		/* 01 GFP_DMA */			\
+	OPT_ZONE_HIGHMEM,	/* 02 GFP_HIGHMEM */			\
+	BAD_ZONE,		/* 03 GFP_HIGHMEM GFP_DMA */		\
+	OPT_ZONE_DMA32,		/* 04 GFP_DMA32 */			\
+	BAD_ZONE,		/* 05 GFP_DMA32 GFP_DMA */		\
+	BAD_ZONE,		/* 06 GFP_DMA32 GFP_HIGHMEM */		\
+	BAD_ZONE,		/* 07 GFP_DMA32 GFP_HIGHMEM GFP_DMA */	\
+	ZONE_NORMAL,		/* 08 ZONE_MOVABLE */			\
+	OPT_ZONE_DMA,		/* 09 MOVABLE + DMA */			\
+	ZONE_MOVABLE,		/* 0A MOVABLE + HIGHMEM */		\
+	BAD_ZONE,		/* 0B MOVABLE + HIGHMEM + DMA */	\
+	OPT_ZONE_DMA32,		/* 0C MOVABLE + DMA32 */		\
+	BAD_ZONE,		/* 0D MOVABLE + DMA32 + DMA */		\
+	BAD_ZONE,		/* 0E MOVABLE + DMA32 + HIGHMEM */	\
+	BAD_ZONE		/* 0F MOVABLE + DMA32 + HIGHMEM + DMA */\
+};
+
+extern const enum zone_type gfp_zone_table[GFP_ZONEMASK + 1];
+
+static inline enum zone_type gfp_zone(gfp_t flags)
+{
+
+	if (__builtin_constant_p(flags)) {
+		GFP_ZONE_TABLE
+		enum zone_type zone = gfp_zone_table[flags & GFP_ZONEMASK];
+
+		BUILD_BUG_ON(zone == BAD_ZONE);
+		return zone;
+	} else {
+
+		enum zone_type zone = gfp_zone_table[flags & GFP_ZONEMASK];
+#ifdef CONFIG_DEBUG_VM
+		BUG_ON(zone == BAD_ZONE);
 #endif
-	return ZONE_NORMAL;
+		return zone;
+	}
 }

 /*
Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2009-03-19 11:47:00.000000000 -0500
+++ linux-2.6/include/linux/mmzone.h	2009-03-19 11:47:54.000000000 -0500
@@ -240,7 +240,8 @@
 	ZONE_HIGHMEM,
 #endif
 	ZONE_MOVABLE,
-	__MAX_NR_ZONES
+	__MAX_NR_ZONES,
+	BAD_ZONE
 };

 #ifndef __GENERATING_BOUNDS_H
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2009-03-19 13:28:35.000000000 -0500
+++ linux-2.6/mm/page_alloc.c	2009-03-19 13:32:21.000000000 -0500
@@ -67,6 +67,9 @@
 };
 EXPORT_SYMBOL(node_states);

+GFP_ZONE_TABLE
+EXPORT_SYMBOL(gfp_zone_table);
+
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 unsigned long highest_memmap_pfn __read_mostly;
