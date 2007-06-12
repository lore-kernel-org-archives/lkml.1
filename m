Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXFLDQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXFLDQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbXFLDQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:16:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33443 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753057AbXFLDQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:16:32 -0400
Date: Mon, 11 Jun 2007 20:16:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <1defaf580706111253q2a4910b1v4802436e32e94953@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706112016030.25563@schroedinger.engr.sgi.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com> 
 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com> 
 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com> 
 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com> 
 <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com> 
 <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com> 
 <1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com> 
 <Pine.LNX.4.64.0706111208580.19316@schroedinger.engr.sgi.com> 
 <1defaf580706111235p7da29d25xc33d221134f3f7a8@mail.gmail.com> 
 <Pine.LNX.4.64.0706111239230.19654@schroedinger.engr.sgi.com>
 <1defaf580706111253q2a4910b1v4802436e32e94953@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> and I can't do that over VPN. I'll test it first thing in the morning.

Here is a more general fix



SLUB: minimum alignment fixes

If ARCH_KMALLOC_MIN_ALIGN is set to a value greater than 8 (SLUBs smallest
kmalloc cache) then SLUB may generate duplicate slabs in sysfs (yes again).
No arch sets ARCH_KMALLOC_MINALIGN larger than 8 though excepts mips which
needs a 128 byte cache.

This patch increases the size of the smallest cache if ARCH_KMALLOC_MINALIGN
is greater than 8. In that case more and more of the smallest caches are
disabled.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   11 +++++++++--
 mm/slub.c                |   18 ++++++++++--------
 2 files changed, 19 insertions(+), 10 deletions(-)

Index: vps/include/linux/slub_def.h
===================================================================
--- vps.orig/include/linux/slub_def.h	2007-06-11 15:56:37.000000000 -0700
+++ vps/include/linux/slub_def.h	2007-06-11 19:31:15.000000000 -0700
@@ -28,7 +28,7 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
-	unsigned int order;
+	int order;
 
 	/*
 	 * Avoid an extra cache line for UP, SMP and for the node local to
@@ -56,7 +56,11 @@ struct kmem_cache {
 /*
  * Kmalloc subsystem.
  */
-#define KMALLOC_SHIFT_LOW 3
+#ifdef ARCH_KMALLOC_MIN_ALIGN
+#define KMALLOC_MIN_SIZE max(8, ARCH_KMALLOC_MIN_ALIGN)
+#else
+#define KMALLOC_MIN_SIZE 8
+#endif
 
 /*
  * We keep the general caches in an array of slab caches that are used for
@@ -76,6 +80,9 @@ static inline int kmalloc_index(size_t s
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
 
+	if (size <= KMALLOC_MIN_SIZE)
+		return ilog2(KMALLOC_MIN_SIZE);
+
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
Index: vps/mm/slub.c
===================================================================
--- vps.orig/mm/slub.c	2007-06-11 15:56:37.000000000 -0700
+++ vps/mm/slub.c	2007-06-11 19:13:41.000000000 -0700
@@ -2193,11 +2193,11 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  *		Kmalloc subsystem
  *******************************************************************/
 
-struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1] __cacheline_aligned;
+struct kmem_cache kmalloc_caches[ilog2(KMALLOC_MAX_SIZE) + 1] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
 #ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_caches_dma[KMALLOC_SHIFT_HIGH + 1];
+static struct kmem_cache *kmalloc_caches_dma[ilog2(KMALLOC_MAX_SIZE) + 1];
 #endif
 
 static int __init setup_slub_min_order(char *str)
@@ -2284,7 +2284,7 @@ static struct kmem_cache *get_slab(size_
 		if (!x)
 			panic("Unable to allocate memory for dma cache\n");
 
-		if (index <= KMALLOC_SHIFT_HIGH)
+		if (index <= ilog2(KMALLOC_MAX_SIZE))
 			realsize = 1 << index;
 		else {
 			if (index == 1)
@@ -2529,19 +2529,21 @@ void __init kmem_cache_init(void)
 	slab_state = PARTIAL;
 
 	/* Caches that are not of the two-to-the-power-of size */
-	create_kmalloc_cache(&kmalloc_caches[1],
+	if (KMALLOC_MIN_SIZE < 96)
+		create_kmalloc_cache(&kmalloc_caches[1],
 				"kmalloc-96", 96, GFP_KERNEL);
-	create_kmalloc_cache(&kmalloc_caches[2],
+	if (KMALLOC_MIN_SIZE < 192)
+		create_kmalloc_cache(&kmalloc_caches[2],
 				"kmalloc-192", 192, GFP_KERNEL);
 
-	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
+	for (i = ilog2(KMALLOC_MIN_SIZE); i <= ilog2(KMALLOC_MAX_SIZE); i++)
 		create_kmalloc_cache(&kmalloc_caches[i],
 			"kmalloc", 1 << i, GFP_KERNEL);
 
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
-	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
+	for (i = ilog2(KMALLOC_MIN_SIZE); i <= ilog2(KMALLOC_MAX_SIZE); i++)
 		kmalloc_caches[i]. name =
 			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
 
@@ -2554,7 +2556,7 @@ void __init kmem_cache_init(void)
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" Processors=%d, Nodes=%d\n",
-		KMALLOC_SHIFT_HIGH, cache_line_size(),
+		ilog2(KMALLOC_MAX_SIZE), cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
 }
