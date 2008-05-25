Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbYEYK2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbYEYK2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762524AbYEYKYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbYEYKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:08 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 28/28] firmware: convert korg1212 driver to use firmware loader exclusively
Message-Id: <E1K0DOQ-0007Ea-GW@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:58 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 firmware/Makefile                                  |    2 +-
 .../korg1212-firmware.h => firmware/korg/k1212.c   |    5 ++++-
 sound/pci/korg1212/korg1212.c                      |   18 ------------------
 3 files changed, 5 insertions(+), 20 deletions(-)
 rename sound/pci/korg1212/korg1212-firmware.h => firmware/korg/k1212.c (99%)

diff --git a/firmware/Makefile b/firmware/Makefile
index 4243c5a..bcae927 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -2,7 +2,7 @@
 # kbuild file for firmware/
 #
 
-firmware-y :=
+firmware-$(CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL) += korg/k1212
 
 firmware_bins := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
 firmware_srcs := $(patsubst %,$(obj)/%.S, $(firmware_bins))
diff --git a/sound/pci/korg1212/korg1212-firmware.h b/firmware/korg/k1212.c
similarity index 99%
rename from sound/pci/korg1212/korg1212-firmware.h
rename to firmware/korg/k1212.c
index f6f5b91..1ed3ebb 100644
--- a/sound/pci/korg1212/korg1212-firmware.h
+++ b/firmware/korg/k1212.c
@@ -1,4 +1,5 @@
-static char dspCode [] = {
+#include <linux/firmware.h>
+static const char dspCode [] = {
 0x01,0xff,0x18,0xff,0xf5,0xff,0xcf,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
 0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
 0x26,0xff,0x18,0xff,0xff,0xff,0x0f,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
@@ -985,3 +986,5 @@ static char dspCode [] = {
 0x00,0xff,0x40,0xff,0xff,0xff,0xc4,0xff,0x00,0xff,0x0a,0xff,0xff,0xff,0x0f,0xff,
 0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
 0xff,0xff,0xff,0xff };
+
+DECLARE_BUILTIN_FIRMWARE("korg/k1212.dsp", dspCode);
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index f4c85b5..4a44c0f 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -260,14 +260,6 @@ enum MonitorModeSelector {
 #define COMMAND_ACK_DELAY   13         // number of RTC ticks to wait for an acknowledgement
                                        //    from the card after sending a command.
 
-#ifdef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
-#include "korg1212-firmware.h"
-static const struct firmware static_dsp_code = {
-	.data = (u8 *)dspCode,
-	.size = sizeof dspCode
-};
-#endif
-
 enum ClockSourceIndex {
    K1212_CLKIDX_AdatAt44_1K = 0,    // selects source as ADAT at 44.1 kHz
    K1212_CLKIDX_AdatAt48K,          // selects source as ADAT at 48 kHz
@@ -412,9 +404,7 @@ struct snd_korg1212 {
 MODULE_DESCRIPTION("korg1212");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{KORG,korg1212}}");
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 MODULE_FIRMWARE("korg/k1212.dsp");
-#endif
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;     /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	   /* ID for this card */
@@ -2348,9 +2338,6 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
         korg1212->AdatTimeCodePhy = korg1212->sharedBufferPhy +
 		offsetof(struct KorgSharedBuffer, AdatTimeCode);
 
-#ifdef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
-	dsp_code = &static_dsp_code;
-#else
 	err = request_firmware(&dsp_code, "korg/k1212.dsp", &pci->dev);
 	if (err < 0) {
 		release_firmware(dsp_code);
@@ -2358,15 +2345,12 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
 		snd_korg1212_free(korg1212);
 		return err;
 	}
-#endif
 
 	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
 				dsp_code->size, &korg1212->dma_dsp) < 0) {
 		snd_printk(KERN_ERR "korg1212: cannot allocate dsp code memory (%zd bytes)\n", dsp_code->size);
                 snd_korg1212_free(korg1212);
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 		release_firmware(dsp_code);
-#endif
                 return -ENOMEM;
         }
 
@@ -2376,9 +2360,7 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
 
 	memcpy(korg1212->dma_dsp.area, dsp_code->data, dsp_code->size);
 
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 	release_firmware(dsp_code);
-#endif
 
 	rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_RebootCard, 0, 0, 0, 0);
 
-- 
1.5.4.5

