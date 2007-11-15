Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbXKOG4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbXKOG4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbXKOGrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57903 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbXKOGrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:03 -0500
Date: Wed, 14 Nov 2007 22:44:29 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 11/40] ALSA: Fix build error without CONFIG_HAS_DMA
Message-ID: <20071115064429.GL19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-fix-build-error-without-config_has_dma.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

patch 8f11551b1798170dcffdd28475075ca4f1c6c990 in mainline

[ALSA] Fix build error without CONFIG_HAS_DMA

The recent change of include/asm-generic/dma-mapping-broken.h breaks
the build without CONFIG_HAS_DMA.  This patch is an ad hoc fix.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/Makefile   |    3 ++-
 sound/core/memalloc.c |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/sound/core/Makefile
+++ b/sound/core/Makefile
@@ -14,7 +14,8 @@ endif
 snd-pcm-objs := pcm.o pcm_native.o pcm_lib.o pcm_timer.o pcm_misc.o \
 		pcm_memory.o
 
-snd-page-alloc-objs := memalloc.o sgbuf.o
+snd-page-alloc-y := memalloc.o
+snd-page-alloc-$(CONFIG_HAS_DMA) += sgbuf.o
 
 snd-rawmidi-objs  := rawmidi.o
 snd-timer-objs    := timer.o
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -206,6 +206,7 @@ void snd_free_pages(void *ptr, size_t si
  *
  */
 
+#ifdef CONFIG_HAS_DMA
 /* allocate the coherent DMA pages */
 static void *snd_malloc_dev_pages(struct device *dev, size_t size, dma_addr_t *dma)
 {
@@ -239,6 +240,7 @@ static void snd_free_dev_pages(struct de
 	dec_snd_pages(pg);
 	dma_free_coherent(dev, PAGE_SIZE << pg, ptr, dma);
 }
+#endif /* CONFIG_HAS_DMA */
 
 #ifdef CONFIG_SBUS
 
@@ -312,12 +314,14 @@ int snd_dma_alloc_pages(int type, struct
 		dmab->area = snd_malloc_sbus_pages(device, size, &dmab->addr);
 		break;
 #endif
+#ifdef CONFIG_HAS_DMA
 	case SNDRV_DMA_TYPE_DEV:
 		dmab->area = snd_malloc_dev_pages(device, size, &dmab->addr);
 		break;
 	case SNDRV_DMA_TYPE_DEV_SG:
 		snd_malloc_sgbuf_pages(device, size, dmab, NULL);
 		break;
+#endif
 	default:
 		printk(KERN_ERR "snd-malloc: invalid device type %d\n", type);
 		dmab->area = NULL;
@@ -383,12 +387,14 @@ void snd_dma_free_pages(struct snd_dma_b
 		snd_free_sbus_pages(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
 		break;
 #endif
+#ifdef CONFIG_HAS_DMA
 	case SNDRV_DMA_TYPE_DEV:
 		snd_free_dev_pages(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
 		break;
 	case SNDRV_DMA_TYPE_DEV_SG:
 		snd_free_sgbuf_pages(dmab);
 		break;
+#endif
 	default:
 		printk(KERN_ERR "snd-malloc: invalid device type %d\n", dmab->dev.type);
 	}

-- 
