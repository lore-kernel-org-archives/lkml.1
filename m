Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYEWNvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYEWNvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYEWNu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:50:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYEWNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:50:58 -0400
Subject: Re: [PATCH 2/3] firmware: convert korg1212 driver to use firmware
	loader exclusively
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1211550374.28967.10.camel@pmac.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 14:50:54 +0100
Message-Id: <1211550654.28967.16.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can build firmware into the kernel and have the firmware
loader find it, we don't need this kind of special case in drivers...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 sound/pci/korg1212/Makefile                        |    1 +
 .../{korg1212-firmware.h => korg1212-firmware.c}   |    4 ++++
 sound/pci/korg1212/korg1212.c                      |   18 ------------------
 3 files changed, 5 insertions(+), 18 deletions(-)

 (git diff to keep size down;
  cf. {git,http}://git.infradead.org/users/dwmw2/firmware-2.6.git )

diff --git a/sound/pci/korg1212/Makefile b/sound/pci/korg1212/Makefile
index f11ce1b..7a5ebdf 100644
--- a/sound/pci/korg1212/Makefile
+++ b/sound/pci/korg1212/Makefile
@@ -7,3 +7,4 @@ snd-korg1212-objs := korg1212.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_KORG1212) += snd-korg1212.o
+obj-$(CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL) += korg1212-firmware.o
diff --git a/sound/pci/korg1212/korg1212-firmware.h b/sound/pci/korg1212/korg1212-firmware.c
similarity index 99%
rename from sound/pci/korg1212/korg1212-firmware.h
rename to sound/pci/korg1212/korg1212-firmware.c
index f6f5b91..2468ee2 100644
--- a/sound/pci/korg1212/korg1212-firmware.h
+++ b/sound/pci/korg1212/korg1212-firmware.c
@@ -1,3 +1,4 @@
+#include <linux/firmware.h>
 static char dspCode [] = {
 0x01,0xff,0x18,0xff,0xf5,0xff,0xcf,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
 0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
@@ -985,3 +986,6 @@ static char dspCode [] = {
 0x00,0xff,0x40,0xff,0xff,0xff,0xc4,0xff,0x00,0xff,0x0a,0xff,0xff,0xff,0x0f,0xff,
 0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
 0xff,0xff,0xff,0xff };
+
+DECLARE_BUILTIN_FIRMWARE("korg/k1212.dsp", dspCode);
+
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
dwmw2

