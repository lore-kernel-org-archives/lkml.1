Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXFRKB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXFRKB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760931AbXFRJ7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47914 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759315AbXFRJ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:16 -0400
Message-Id: <20070618095915.359753174@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:46 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 08/26] SLUB: Extract dma_kmalloc_cache from get_cache.
Content-Disposition: inline; filename=slub_extract_dma_cache
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The rarely used dma functionality in get_slab() makes the function too
complex. The compiler begins to spill variables from the working set onto
the stack. The created function is only used in extremely rare cases so make
sure that the compiler does not decide on its own to merge it back into
get_slab().

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   66 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-17 18:12:04.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-17 18:12:10.000000000 -0700
@@ -2281,6 +2281,40 @@ panic:
 	panic("Creation of kmalloc slab %s size=%d failed.\n", name, size);
 }
 
+#ifdef CONFIG_ZONE_DMA
+static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
+{
+	struct kmem_cache *s;
+	struct kmem_cache *x;
+	char *text;
+	size_t realsize;
+
+	s = kmalloc_caches_dma[index];
+	if (s)
+		return s;
+
+	/* Dynamically create dma cache */
+	x = kmalloc(kmem_size, flags & ~SLUB_DMA);
+	if (!x)
+		panic("Unable to allocate memory for dma cache\n");
+
+	if (index <= KMALLOC_SHIFT_HIGH)
+		realsize = 1 << index;
+	else {
+		if (index == 1)
+			realsize = 96;
+		else
+			realsize = 192;
+	}
+
+	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
+			(unsigned int)realsize);
+	s = create_kmalloc_cache(x, text, realsize, flags);
+	kmalloc_caches_dma[index] = s;
+	return s;
+}
+#endif
+
 static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 {
 	int index = kmalloc_index(size);
@@ -2293,36 +2327,8 @@ static struct kmem_cache *get_slab(size_
 		return NULL;
 
 #ifdef CONFIG_ZONE_DMA
-	if ((flags & SLUB_DMA)) {
-		struct kmem_cache *s;
-		struct kmem_cache *x;
-		char *text;
-		size_t realsize;
-
-		s = kmalloc_caches_dma[index];
-		if (s)
-			return s;
-
-		/* Dynamically create dma cache */
-		x = kmalloc(kmem_size, flags & ~SLUB_DMA);
-		if (!x)
-			panic("Unable to allocate memory for dma cache\n");
-
-		if (index <= KMALLOC_SHIFT_HIGH)
-			realsize = 1 << index;
-		else {
-			if (index == 1)
-				realsize = 96;
-			else
-				realsize = 192;
-		}
-
-		text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
-				(unsigned int)realsize);
-		s = create_kmalloc_cache(x, text, realsize, flags);
-		kmalloc_caches_dma[index] = s;
-		return s;
-	}
+	if ((flags & SLUB_DMA))
+		return dma_kmalloc_cache(index, flags);
 #endif
 	return &kmalloc_caches[index];
 }

-- 
