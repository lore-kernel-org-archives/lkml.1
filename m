Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbXA2UMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbXA2UMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXA2UMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:12:45 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53976 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbXA2UMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:12:44 -0500
Date: Mon, 29 Jan 2007 15:05:17 -0500
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org, Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] slab.c ifdef reduction breaks build
Message-ID: <20070129200517.GA6229@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-
no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs converts some
ifdefs into ifs.

One of them causes cs_dmacachep to be referenced, when that field
doesn't exist, because it's ifdefed on CONFIG_ZONE_DMA.

I'd suggest reverting that chunk.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 mm/slab.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.18-mm/mm/slab.c
===================================================================
--- linux-2.6.18-mm.orig/mm/slab.c	2007-01-29 14:32:13.000000000 -0500
+++ linux-2.6.18-mm/mm/slab.c	2007-01-29 15:04:18.000000000 -0500
@@ -1492,14 +1492,15 @@ void __init kmem_cache_init(void)
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL, NULL);
 		}
-		if (CONFIG_ZONE_DMA_FLAG)
-			sizes->cs_dmacachep = kmem_cache_create(
+#if CONFIG_ZONE_DMA_FLAG
+		sizes->cs_dmacachep = kmem_cache_create(
 					names->name_dma,
 					sizes->cs_size,
 					ARCH_KMALLOC_MINALIGN,
 					ARCH_KMALLOC_FLAGS|SLAB_CACHE_DMA|
 						SLAB_PANIC,
 					NULL, NULL);
+#endif
 		sizes++;
 		names++;
 	}

-- 
Work email - jdike at linux dot intel dot com
