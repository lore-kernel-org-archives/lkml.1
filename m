Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYE2JJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYE2JJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYE2JJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:09:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYE2JJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:09:47 -0400
Subject: [PATCHv2 #ERROR!/28] maestro3: treat firmware data as const
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Zach Brown <zab@zabbo.net>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 12:09:44 +0300
Message-Id: <1212052184.26088.5.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maestro3 driver is byte-swapping its firmware to be host-endian in
advance, when it doesn't seem to be necessary -- we could just use
le16_to_cpu() as we load it.

Doing that means that we need to switch the in-tree firmware to be
little-endian too.

Take the least intrusive way of doing this, which is to switch the
existing snd_m3_convert_from_le() function to convert _to_ little-endian
instead, and use it on the in-tree firmware instead of the loaded
firmware. It's a bit suboptimal but doesn't matter much right now
because we're about to remove the special cases for the in-tree version
anyway.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 sound/pci/maestro3.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index a536c59..cbb08d9 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2240,18 +2240,16 @@ static const struct firmware assp_minisrc = {
 	.size = sizeof assp_minisrc_image
 };
 
-#else /* CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL */
-
 #ifdef __LITTLE_ENDIAN
-static inline void snd_m3_convert_from_le(const struct firmware *fw) { }
+static inline void snd_m3_convert_to_le(const struct firmware *fw) { }
 #else
-static void snd_m3_convert_from_le(const struct firmware *fw)
+static void snd_m3_convert_to_le(const struct firmware *fw)
 {
 	int i;
 	u16 *data = (u16 *)fw->data;
 
 	for (i = 0; i < fw->size / 2; ++i)
-		le16_to_cpus(&data[i]);
+		cpu_to_le16s(&data[i]);
 }
 #endif
 
@@ -2271,7 +2269,7 @@ static const u16 minisrc_lpf[MINISRC_LPF_LEN] = {
 static void snd_m3_assp_init(struct snd_m3 *chip)
 {
 	unsigned int i;
-	u16 *data;
+	const u16 *data;
 
 	/* zero kernel data */
 	for (i = 0; i < (REV_B_DATA_MEMORY_UNIT_LENGTH * NUM_UNITS_KERNEL_DATA) / 2; i++)
@@ -2289,10 +2287,11 @@ static void snd_m3_assp_init(struct snd_m3 *chip)
 			  KDATA_DMA_XFER0);
 
 	/* write kernel into code memory.. */
-	data = (u16 *)chip->assp_kernel_image->data;
+	data = (const u16 *)chip->assp_kernel_image->data;
 	for (i = 0 ; i * 2 < chip->assp_kernel_image->size; i++) {
 		snd_m3_assp_write(chip, MEMTYPE_INTERNAL_CODE, 
-				  REV_B_CODE_MEMORY_BEGIN + i, data[i]);
+				  REV_B_CODE_MEMORY_BEGIN + i,
+				  le16_to_cpu(data[i]));
 	}
 
 	/*
@@ -2301,10 +2300,10 @@ static void snd_m3_assp_init(struct snd_m3 *chip)
 	 * drop it there.  It seems that the minisrc doesn't
 	 * need vectors, so we won't bother with them..
 	 */
-	data = (u16 *)chip->assp_minisrc_image->data;
+	data = (const u16 *)chip->assp_minisrc_image->data;
 	for (i = 0; i * 2 < chip->assp_minisrc_image->size; i++) {
 		snd_m3_assp_write(chip, MEMTYPE_INTERNAL_CODE, 
-				  0x400 + i, data[i]);
+				  0x400 + i, le16_to_cpu(data[i]));
 	}
 
 	/*
@@ -2743,26 +2742,26 @@ snd_m3_create(struct snd_card *card, struct pci_dev *pci,
 
 #ifdef CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL
 	chip->assp_kernel_image = &assp_kernel;
+	snd_m3_convert_to_le(chip->assp_kernel_image);
 #else
 	err = request_firmware(&chip->assp_kernel_image,
 			       "ess/maestro3_assp_kernel.fw", &pci->dev);
 	if (err < 0) {
 		snd_m3_free(chip);
 		return err;
-	} else
-		snd_m3_convert_from_le(chip->assp_kernel_image);
+	}
 #endif
 
 #ifdef CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL
 	chip->assp_minisrc_image = &assp_minisrc;
+	snd_m3_convert_to_le(chip->assp_minisrc_image);
 #else
 	err = request_firmware(&chip->assp_minisrc_image,
 			       "ess/maestro3_assp_minisrc.fw", &pci->dev);
 	if (err < 0) {
 		snd_m3_free(chip);
 		return err;
-	} else
-		snd_m3_convert_from_le(chip->assp_minisrc_image);
+	}
 #endif
 
 	if ((err = pci_request_regions(pci, card->driver)) < 0) {
-- 
1.5.4.5


-- 
dwmw2

