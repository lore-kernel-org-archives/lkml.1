Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYE2MVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYE2MVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYE2MVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:21:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYE2MVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:21:16 -0400
Subject: [PATCH N/28] ymfpci: treat firmware data as const
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 15:21:12 +0300
Message-Id: <1212063672.26088.16.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardise both in-kernel and loaded firmware to be stored as
little-endian instead of host-endian.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
As with the maestro3 version, take the least intrusive solution since
it's not going to be there for long.

 sound/pci/ymfpci/ymfpci_main.c |   59 +++++++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index 29b3056..6298b29 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/mutex.h>
 
 #include <sound/core.h>
 #include <sound/control.h>
@@ -2009,11 +2010,34 @@ static struct firmware snd_ymfpci_controller_1e_microcode = {
 	.size = YDSXG_CTRLLENGTH,
 	.data = (u8 *)CntrlInst1E,
 };
+
+#ifdef __BIG_ENDIAN
+static int microcode_swapped;
+static DEFINE_MUTEX(microcode_swap);
+
+static void snd_ymfpci_convert_to_le(const struct firmware *fw)
+{
+	int i;
+	u32 *data = (u32 *)fw->data;
+
+	for (i = 0; i < fw->size / 4; ++i)
+		cpu_to_le32s(&data[i]);
+}
 #endif
 
-#ifdef CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL
 static int snd_ymfpci_request_firmware(struct snd_ymfpci *chip)
 {
+#ifdef __BIG_ENDIAN
+	mutex_lock(&microcode_swap);
+	if (!microcode_swapped) {
+		snd_ymfpci_convert_to_le(&snd_ymfpci_dsp_microcode);
+		snd_ymfpci_convert_to_le(&snd_ymfpci_controller_1e_microcode);
+		snd_ymfpci_convert_to_le(&snd_ymfpci_controller_microcode);
+		microcode_swapped = 1;
+	}
+	mutex_unlock(&microcode_swap);
+#endif
+
 	chip->dsp_microcode = &snd_ymfpci_dsp_microcode;
 	if (chip->device_id == PCI_DEVICE_ID_YAMAHA_724F ||
 	    chip->device_id == PCI_DEVICE_ID_YAMAHA_740C ||
@@ -2029,19 +2053,6 @@ static int snd_ymfpci_request_firmware(struct snd_ymfpci *chip)
 
 #else /* use fw_loader */
 
-#ifdef __LITTLE_ENDIAN
-static inline void snd_ymfpci_convert_from_le(const struct firmware *fw) { }
-#else
-static void snd_ymfpci_convert_from_le(const struct firmware *fw)
-{
-	int i;
-	u32 *data = (u32 *)fw->data;
-
-	for (i = 0; i < fw->size / 4; ++i)
-		le32_to_cpus(&data[i]);
-}
-#endif
-
 static int snd_ymfpci_request_firmware(struct snd_ymfpci *chip)
 {
 	int err, is_1e;
@@ -2050,9 +2061,7 @@ static int snd_ymfpci_request_firmware(struct snd_ymfpci *chip)
 	err = request_firmware(&chip->dsp_microcode, "yamaha/ds1_dsp.fw",
 			       &chip->pci->dev);
 	if (err >= 0) {
-		if (chip->dsp_microcode->size == YDSXG_DSPLENGTH)
-			snd_ymfpci_convert_from_le(chip->dsp_microcode);
-		else {
+		if (chip->dsp_microcode->size != YDSXG_DSPLENGTH) {
 			snd_printk(KERN_ERR "DSP microcode has wrong size\n");
 			err = -EINVAL;
 		}
@@ -2067,9 +2076,7 @@ static int snd_ymfpci_request_firmware(struct snd_ymfpci *chip)
 	err = request_firmware(&chip->controller_microcode, name,
 			       &chip->pci->dev);
 	if (err >= 0) {
-		if (chip->controller_microcode->size == YDSXG_CTRLLENGTH)
-			snd_ymfpci_convert_from_le(chip->controller_microcode);
-		else {
+		if (chip->controller_microcode->size != YDSXG_CTRLLENGTH) {
 			snd_printk(KERN_ERR "controller microcode"
 				   " has wrong size\n");
 			err = -EINVAL;
@@ -2090,7 +2097,7 @@ static void snd_ymfpci_download_image(struct snd_ymfpci *chip)
 {
 	int i;
 	u16 ctrl;
-	u32 *inst;
+	const __le32 *inst;
 
 	snd_ymfpci_writel(chip, YDSXGR_NATIVEDACOUTVOL, 0x00000000);
 	snd_ymfpci_disable_dsp(chip);
@@ -2105,14 +2112,16 @@ static void snd_ymfpci_download_image(struct snd_ymfpci *chip)
 	snd_ymfpci_writew(chip, YDSXGR_GLOBALCTRL, ctrl & ~0x0007);
 
 	/* setup DSP instruction code */
-	inst = (u32 *)chip->dsp_microcode->data;
+	inst = (const __le32 *)chip->dsp_microcode->data;
 	for (i = 0; i < YDSXG_DSPLENGTH / 4; i++)
-		snd_ymfpci_writel(chip, YDSXGR_DSPINSTRAM + (i << 2), inst[i]);
+		snd_ymfpci_writel(chip, YDSXGR_DSPINSTRAM + (i << 2),
+				  le32_to_cpu(inst[i]));
 
 	/* setup control instruction code */
-	inst = (u32 *)chip->controller_microcode->data;
+	inst = (const __le32 *)chip->controller_microcode->data;
 	for (i = 0; i < YDSXG_CTRLLENGTH / 4; i++)
-		snd_ymfpci_writel(chip, YDSXGR_CTRLINSTRAM + (i << 2), inst[i]);
+		snd_ymfpci_writel(chip, YDSXGR_CTRLINSTRAM + (i << 2),
+				  le32_to_cpu(inst[i]));
 
 	snd_ymfpci_enable_dsp(chip);
 }
-- 
1.5.4.5


-- 
dwmw2

