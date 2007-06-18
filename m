Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbXFRKCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbXFRKCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760966AbXFRJ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58632 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759370AbXFRJ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:16 -0400
Message-Id: <20070618095915.600066736@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:47 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 09/26] SLUB: Do proper locking during dma slab creation
Content-Disposition: inline; filename=slub_dma_create_lock
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We modify the kmalloc_cache_dma[] array without proper locking.
Do the proper locking and undo the dma cache creation if another processor
has already created it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-17 18:12:10.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-17 18:12:13.000000000 -0700
@@ -2310,8 +2310,15 @@ static struct kmem_cache *dma_kmalloc_ca
 	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
 			(unsigned int)realsize);
 	s = create_kmalloc_cache(x, text, realsize, flags);
-	kmalloc_caches_dma[index] = s;
-	return s;
+	down_write(&slub_lock);
+	if (!kmalloc_caches_dma[index]) {
+		kmalloc_caches_dma[index] = s;
+		up_write(&slub_lock);
+		return s;
+	}
+	up_write(&slub_lock);
+	kmem_cache_destroy(s);
+	return kmalloc_caches_dma[index];
 }
 #endif
 

-- 
