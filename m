Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbXH3J0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbXH3J0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXH3J03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:26:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbXH3J02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:26:28 -0400
Date: Thu, 30 Aug 2007 11:26:04 +0200
From: Markus Dahms <mad@automagically.de>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix ALSA compilation on Sparc32
Message-ID: <20070830092604.GA17041@vimes.madsworld.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Provags-ID: V01U2FsdGVkX18IDdyeI8tiiGrjcHYZAzIp+PO6VGn5/rTVyPg
 WJbq7hx4596dECxzCi69HG2Bd03e6MbZTs8kJUmAh+wb8A3bxG
 q4OrSs7HtRJNLZnOEE/Hw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_alloc_coherent and dma_free_coherent function seem to be not
available on sparc(32) architecture. It is not used by SBus sound
drivers, so it's disabled via #ifndef for CONFIG_SPARC32.

Signed-off-by: Markus Dahms <mad@automagically.de>

---
It is tested on a SparcStation 5 with the cs4231 driver. The ALSA list
should have been CCed, but as it is subscriber-only I skipped it.


--- linux-2.6/sound/core/memalloc.c	2007-08-30 10:59:50.000000000 +0200
+++ linux-2.6/sound/core/memalloc.c.patched	2007-08-23 18:41:41.000000000 +0200
@@ -205,6 +205,8 @@ void snd_free_pages(void *ptr, size_t si
  *
  */
 
+#ifndef CONFIG_SPARC32
+
 /* allocate the coherent DMA pages */
 static void *snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *dma)
 {
@@ -239,6 +241,8 @@ static void snd_free_dev_pages(struct de
 	dma_free_coherent(dev, PAGE_SIZE << pg, ptr, dma);
 }
 
+#endif
+
 #ifdef CONFIG_SBUS
 
 static void *snd_malloc_sbus_pages(struct device *dev, size_t size,
@@ -311,9 +315,11 @@ int snd_dma_alloc_pages(int type, struct
 		dmab->area = snd_malloc_sbus_pages(device, size, &dmab->addr);
 		break;
 #endif
+#ifndef CONFIG_SPARC32
 	case SNDRV_DMA_TYPE_DEV:
 		dmab->area = snd_malloc_dev_pages(device, size, &dmab->addr);
 		break;
+#endif
 	case SNDRV_DMA_TYPE_DEV_SG:
 		snd_malloc_sgbuf_pages(device, size, dmab, NULL);
 		break;
@@ -382,9 +388,11 @@ void snd_dma_free_pages(struct snd_dma_b
 		snd_free_sbus_pages(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
 		break;
 #endif
+#ifndef CONFIG_SPARC32
 	case SNDRV_DMA_TYPE_DEV:
 		snd_free_dev_pages(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
 		break;
+#endif
 	case SNDRV_DMA_TYPE_DEV_SG:
 		snd_free_sgbuf_pages(dmab);
 		break;
