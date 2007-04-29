Return-Path: <linux-kernel-owner+w=401wt.eu-S1031015AbXD2RgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031015AbXD2RgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030951AbXD2RgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:36:14 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38078 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030812AbXD2Rfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:35:50 -0400
Date: Sun, 29 Apr 2007 19:35:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Giridhar Pemmasani <pgiri@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: Boot failure with 2.6.21 with snd-maestro3
Message-ID: <20070429173559.GP3468@stusta.de>
References: <944251.71448.qm@web32407.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <944251.71448.qm@web32407.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sun, Apr 29, 2007 at 09:55:18AM -0700, Giridhar Pemmasani wrote:
> When snd-maestro3 (ESS Maestro 3 driver) is enabled, kernel 2.6.21 fails to
> boot - it seems to stop at various points depending on what other modules are
> enabled. Disabling snd-maestro3 fixes all issues. Moreover, with everything
> else being same, using maestro3.c from 2.6.20 kernel and using it in 2.6.21
> kernel also works - i.e., system boots fine. I will try to isolate the issue
> and follow up.

Thanks for your report.

There were only the two attached patches between 2.6.20 and 2.6.21 to 
this driver:
- maestro3: add request_firmware()
- maestro3 - Use quirk list helper function

2.6.21 + 2.6.20 maestro3.c works for you.

Does 2.6.21 + 2.6.20 maestro3.c + patch-maestro3-1 work?

> Giri

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=patch-maestro3-1

commit 81d7724a8ee84693befbd60d730199ffb3988f29
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Nov 6 09:26:41 2006 +0100

    [ALSA] maestro3: add request_firmware()
    
    Load the ASSP codes using request_firmware(), if possible, instead of
    using the built-in blobs.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Jaroslav Kysela <perex@suse.cz>

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 7573997..1bcfb3a 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -587,6 +587,7 @@ config SND_KORG1212
 config SND_MAESTRO3
 	tristate "ESS Allegro/Maestro3"
 	depends on SND
+	select FW_LOADER
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for soundcards based on ESS Maestro 3
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 6efe6d5..053ea4f 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
+#include <linux/firmware.h>
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
@@ -48,6 +49,7 @@
 #include <sound/mpu401.h>
 #include <sound/ac97_codec.h>
 #include <sound/initval.h>
+#include <asm/byteorder.h>
 
 MODULE_AUTHOR("Zach Brown <zab@zabbo.net>, Takashi Iwai <tiwai@suse.de>");
 MODULE_DESCRIPTION("ESS Maestro3 PCI");
@@ -864,6 +866,9 @@ struct snd_m3 {
 #ifdef CONFIG_PM
 	u16 *suspend_mem;
 #endif
+
+	const struct firmware *assp_kernel_image;
+	const struct firmware *assp_minisrc_image;
 };
 
 /*
@@ -2132,6 +2137,10 @@ static int __devinit snd_m3_mixer(struct snd_m3 *chip)
 }
 
 
+#define FIRMWARE_IN_THE_KERNEL
+
+#ifdef FIRMWARE_IN_THE_KERNEL
+
 /*
  * DSP Code images
  */
@@ -2260,6 +2269,30 @@ static const u16 assp_minisrc_image[] = {
     0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
 };
 
+static const struct firmware assp_kernel = {
+	.data = (u8 *)assp_kernel_image,
+	.size = sizeof assp_kernel_image
+};
+static const struct firmware assp_minisrc = {
+	.data = (u8 *)assp_minisrc_image,
+	.size = sizeof assp_minisrc_image
+};
+
+#endif /* FIRMWARE_IN_THE_KERNEL */
+
+#ifdef __LITTLE_ENDIAN
+static inline void snd_m3_convert_from_le(const struct firmware *fw) { }
+#else
+static void snd_m3_convert_from_le(const struct firmware *fw)
+{
+	int i;
+	u16 *data = (u16 *)fw->data;
+
+	for (i = 0; i < fw->size / 2; ++i)
+		le16_to_cpus(&data[i]);
+}
+#endif
+
 
 /*
  * initialize ASSP
@@ -2274,6 +2307,7 @@ static const u16 minisrc_lpf[MINISRC_LPF_LEN] = {
 static void snd_m3_assp_init(struct snd_m3 *chip)
 {
 	unsigned int i;
+	u16 *data;
 
 	/* zero kernel data */
 	for (i = 0; i < (REV_B_DATA_MEMORY_UNIT_LENGTH * NUM_UNITS_KERNEL_DATA) / 2; i++)
@@ -2291,10 +2325,10 @@ static void snd_m3_assp_init(struct snd_m3 *chip)
 			  KDATA_DMA_XFER0);
 
 	/* write kernel into code memory.. */
-	for (i = 0 ; i < ARRAY_SIZE(assp_kernel_image); i++) {
+	data = (u16 *)chip->assp_kernel_image->data;
+	for (i = 0 ; i * 2 < chip->assp_kernel_image->size; i++) {
 		snd_m3_assp_write(chip, MEMTYPE_INTERNAL_CODE, 
-				  REV_B_CODE_MEMORY_BEGIN + i, 
-				  assp_kernel_image[i]);
+				  REV_B_CODE_MEMORY_BEGIN + i, data[i]);
 	}
 
 	/*
@@ -2303,10 +2337,10 @@ static void snd_m3_assp_init(struct snd_m3 *chip)
 	 * drop it there.  It seems that the minisrc doesn't
 	 * need vectors, so we won't bother with them..
 	 */
-	for (i = 0; i < ARRAY_SIZE(assp_minisrc_image); i++) {
+	data = (u16 *)chip->assp_minisrc_image->data;
+	for (i = 0; i * 2 < chip->assp_minisrc_image->size; i++) {
 		snd_m3_assp_write(chip, MEMTYPE_INTERNAL_CODE, 
-				  0x400 + i, 
-				  assp_minisrc_image[i]);
+				  0x400 + i, data[i]);
 	}
 
 	/*
@@ -2553,6 +2587,15 @@ static int snd_m3_free(struct snd_m3 *chip)
 	if (chip->iobase)
 		pci_release_regions(chip->pci);
 
+#ifdef FIRMWARE_IN_THE_KERNEL
+	if (chip->assp_kernel_image != &assp_kernel)
+#endif
+		release_firmware(chip->assp_kernel_image);
+#ifdef FIRMWARE_IN_THE_KERNEL
+	if (chip->assp_minisrc_image != &assp_minisrc)
+#endif
+		release_firmware(chip->assp_minisrc_image);
+
 	pci_disable_device(chip->pci);
 	kfree(chip);
 	return 0;
@@ -2744,6 +2787,30 @@ snd_m3_create(struct snd_card *card, struct pci_dev *pci,
 		return -ENOMEM;
 	}
 
+	err = request_firmware(&chip->assp_kernel_image,
+			       "ess/maestro3_assp_kernel.fw", &pci->dev);
+	if (err < 0) {
+#ifdef FIRMWARE_IN_THE_KERNEL
+		chip->assp_kernel_image = &assp_kernel;
+#else
+		snd_m3_free(chip);
+		return err;
+#endif
+	} else
+		snd_m3_convert_from_le(chip->assp_kernel_image);
+
+	err = request_firmware(&chip->assp_minisrc_image,
+			       "ess/maestro3_assp_minisrc.fw", &pci->dev);
+	if (err < 0) {
+#ifdef FIRMWARE_IN_THE_KERNEL
+		chip->assp_minisrc_image = &assp_minisrc;
+#else
+		snd_m3_free(chip);
+		return err;
+#endif
+	} else
+		snd_m3_convert_from_le(chip->assp_minisrc_image);
+
 	if ((err = pci_request_regions(pci, card->driver)) < 0) {
 		snd_m3_free(chip);
 		return err;

--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=patch-maestro3-2

commit 1061eeb44493176eb1d12b47d619e61c428c4395
Author: Takashi Iwai <tiwai@suse.de>
Date:   Fri Nov 24 15:36:46 2006 +0100

    [ALSA] maestro3 - Use quirk list helper function
    
    Clean up maestro3 amp and GPIO quirks using snd_pci_quirk_lookup().
    
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Jaroslav Kysela <perex@suse.cz>

diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 053ea4f..4526904 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -770,21 +770,6 @@ MODULE_PARM_DESC(amp_gpio, "GPIO pin number for external amp. (default = -1)");
 /*
  */
 
-/* quirk lists */
-struct m3_quirk {
-	const char *name;	/* device name */
-	u16 vendor, device;	/* subsystem ids */
-	int amp_gpio;		/* gpio pin #  for external amp, -1 = default */
-	int irda_workaround;	/* non-zero if avoid to touch 0x10 on GPIO_DIRECTION
-				   (e.g. for IrDA on Dell Inspirons) */
-};
-
-struct m3_hv_quirk {
-	u16 vendor, device, subsystem_vendor, subsystem_device;
-	u32 config;		/* ALLEGRO_CONFIG hardware volume bits */
-	int is_omnibook;	/* Do HP OmniBook GPIO magic? */
-};
-
 struct m3_list {
 	int curlen;
 	int mem_addr;
@@ -832,8 +817,6 @@ struct snd_m3 {
 	struct snd_pcm *pcm;
 
 	struct pci_dev *pci;
-	const struct m3_quirk *quirk;
-	const struct m3_hv_quirk *hv_quirk;
 
 	int dacs_active;
 	int timer_users;
@@ -847,7 +830,11 @@ struct snd_m3 {
 	u8 reset_state;
 
 	int external_amp;
-	int amp_gpio;
+	int amp_gpio;	/* gpio pin #  for external amp, -1 = default */
+	unsigned int hv_config;		/* hardware-volume config bits */
+	unsigned irda_workaround :1;	/* avoid to touch 0x10 on GPIO_DIRECTION
+					   (e.g. for IrDA on Dell Inspirons) */
+	unsigned is_omnibook :1;	/* Do HP OmniBook GPIO magic? */
 
 	/* midi */
 	struct snd_rawmidi *rmidi;
@@ -896,127 +883,104 @@ static struct pci_device_id snd_m3_ids[] = {
 
 MODULE_DEVICE_TABLE(pci, snd_m3_ids);
 
-static const struct m3_quirk m3_quirk_list[] = {
-	/* panasonic CF-28 "toughbook" */
-	{
-		.name = "Panasonic CF-28",
-		.vendor = 0x10f7,
-		.device = 0x833e,
-		.amp_gpio = 0x0d,
-	},
-	/* panasonic CF-72 "toughbook" */
-	{
-		.name = "Panasonic CF-72",
-		.vendor = 0x10f7,
-		.device = 0x833d,
-		.amp_gpio = 0x0d,
-	},
-	/* Dell Inspiron 4000 */
-	{
-		.name = "Dell Inspiron 4000",
-		.vendor = 0x1028,
-		.device = 0x00b0,
-		.amp_gpio = -1,
-		.irda_workaround = 1,
-	},
-	/* Dell Inspiron 8000 */
-	{
-		.name = "Dell Inspiron 8000",
-		.vendor = 0x1028,
-		.device = 0x00a4,
-		.amp_gpio = -1,
-		.irda_workaround = 1,
-	},
-	/* Dell Inspiron 8100 */
-	{
-		.name = "Dell Inspiron 8100",
-		.vendor = 0x1028,
-		.device = 0x00e6,
-		.amp_gpio = -1,
-		.irda_workaround = 1,
-	},
-	/* NEC LM800J/7 */
-	{
-		.name = "NEC LM800J/7",
-		.vendor = 0x1033,
-		.device = 0x80f1,
-		.amp_gpio = 0x03,
-	},
-	/* LEGEND ZhaoYang 3100CF */
-	{
-		.name = "LEGEND ZhaoYang 3100CF",
-		.vendor = 0x1509,
-		.device = 0x1740,
-		.amp_gpio = 0x03,
-	},
-	/* END */
-	{ NULL }
+static struct snd_pci_quirk m3_amp_quirk_list[] __devinitdata = {
+	SND_PCI_QUIRK(0x10f7, 0x833e, "Panasonic CF-28", 0x0d),
+	SND_PCI_QUIRK(0x10f7, 0x833d, "Panasonic CF-72", 0x0d),
+	SND_PCI_QUIRK(0x1033, 0x80f1, "NEC LM800J/7", 0x03),
+	SND_PCI_QUIRK(0x1509, 0x1740, "LEGEND ZhaoYang 3100CF", 0x03),
+	{ } /* END */
+};
+
+static struct snd_pci_quirk m3_irda_quirk_list[] __devinitdata = {
+	SND_PCI_QUIRK(0x1028, 0x00b0, "Dell Inspiron 4000", 1),
+	SND_PCI_QUIRK(0x1028, 0x00a4, "Dell Inspiron 8000", 1),
+	SND_PCI_QUIRK(0x1028, 0x00e6, "Dell Inspiron 8100", 1),
+	{ } /* END */
 };
 
-/* These values came from the Windows driver. */
-static const struct m3_hv_quirk m3_hv_quirk_list[] = {
+/* hardware volume quirks */
+static struct snd_pci_quirk m3_hv_quirk_list[] __devinitdata = {
 	/* Allegro chips */
-	{ 0x125D, 0x1988, 0x0E11, 0x002E, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x0E11, 0x0094, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x0E11, 0xB112, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x0E11, 0xB114, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x103C, 0x0012, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x103C, 0x0018, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x103C, 0x001C, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x103C, 0x001D, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x103C, 0x001E, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x107B, 0x3350, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x10F7, 0x8338, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x10F7, 0x833C, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x10F7, 0x833D, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x10F7, 0x833E, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x10F7, 0x833F, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x13BD, 0x1018, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x13BD, 0x1019, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x13BD, 0x101A, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x14FF, 0x0F03, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x14FF, 0x0F04, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x14FF, 0x0F05, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x156D, 0xB400, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x156D, 0xB795, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x156D, 0xB797, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x156D, 0xC700, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD, 0 },
-	{ 0x125D, 0x1988, 0x1033, 0x80F1, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x103C, 0x001A, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 }, /* HP OmniBook 6100 */
-	{ 0x125D, 0x1988, 0x107B, 0x340A, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x107B, 0x3450, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x109F, 0x3134, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x109F, 0x3161, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x144D, 0x3280, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x144D, 0x3281, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x144D, 0xC002, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x144D, 0xC003, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x1509, 0x1740, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x1610, 0x0010, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x1988, 0x1042, 0x1042, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1988, 0x107B, 0x9500, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1988, 0x14FF, 0x0F06, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1988, 0x1558, 0x8586, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1988, 0x161F, 0x2011, HV_CTRL_ENABLE, 0 },
+	SND_PCI_QUIRK(0x0E11, 0x002E, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x0E11, 0x0094, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x0E11, 0xB112, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x0E11, 0xB114, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x103C, 0x0012, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x103C, 0x0018, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x103C, 0x001C, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x103C, 0x001D, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x103C, 0x001E, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x107B, 0x3350, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x10F7, 0x8338, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x10F7, 0x833C, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x10F7, 0x833D, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x10F7, 0x833E, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x10F7, 0x833F, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x13BD, 0x1018, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x13BD, 0x1019, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x13BD, 0x101A, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x14FF, 0x0F03, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x14FF, 0x0F04, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x14FF, 0x0F05, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x156D, 0xB400, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x156D, 0xB795, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x156D, 0xB797, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x156D, 0xC700, NULL, HV_CTRL_ENABLE | HV_BUTTON_FROM_GD),
+	SND_PCI_QUIRK(0x1033, 0x80F1, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x103C, 0x001A, NULL, /* HP OmniBook 6100 */
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x107B, 0x340A, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x107B, 0x3450, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x109F, 0x3134, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x109F, 0x3161, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x144D, 0x3280, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x144D, 0x3281, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x144D, 0xC002, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x144D, 0xC003, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x1509, 0x1740, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x1610, 0x0010, NULL,
+		      HV_CTRL_ENABLE | HV_BUTTON_FROM_GD | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x1042, 0x1042, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x107B, 0x9500, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x14FF, 0x0F06, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x1558, 0x8586, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x161F, 0x2011, NULL, HV_CTRL_ENABLE),
 	/* Maestro3 chips */
-	{ 0x125D, 0x1998, 0x103C, 0x000E, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x103C, 0x0010, HV_CTRL_ENABLE, 1 }, /* HP OmniBook 6000 */
-	{ 0x125D, 0x1998, 0x103C, 0x0011, HV_CTRL_ENABLE, 1 }, /* HP OmniBook 500 */
-	{ 0x125D, 0x1998, 0x103C, 0x001B, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x104D, 0x80A6, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x104D, 0x80AA, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x107B, 0x5300, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x110A, 0x1998, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x13BD, 0x1015, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x13BD, 0x101C, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x13BD, 0x1802, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x1599, 0x0715, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x1998, 0x5643, 0x5643, HV_CTRL_ENABLE, 0 },
-	{ 0x125D, 0x199A, 0x144D, 0x3260, HV_CTRL_ENABLE | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x199A, 0x144D, 0x3261, HV_CTRL_ENABLE | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x199A, 0x144D, 0xC000, HV_CTRL_ENABLE | REDUCED_DEBOUNCE, 0 },
-	{ 0x125D, 0x199A, 0x144D, 0xC001, HV_CTRL_ENABLE | REDUCED_DEBOUNCE, 0 },
-	{ 0 }
+	SND_PCI_QUIRK(0x103C, 0x000E, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x103C, 0x0010, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x103C, 0x0011, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x103C, 0x001B, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x104D, 0x80A6, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x104D, 0x80AA, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x107B, 0x5300, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x110A, 0x1998, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x13BD, 0x1015, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x13BD, 0x101C, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x13BD, 0x1802, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x1599, 0x0715, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x5643, 0x5643, NULL, HV_CTRL_ENABLE),
+	SND_PCI_QUIRK(0x144D, 0x3260, NULL, HV_CTRL_ENABLE | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x144D, 0x3261, NULL, HV_CTRL_ENABLE | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x144D, 0xC000, NULL, HV_CTRL_ENABLE | REDUCED_DEBOUNCE),
+	SND_PCI_QUIRK(0x144D, 0xC001, NULL, HV_CTRL_ENABLE | REDUCED_DEBOUNCE),
+	{ } /* END */
+};
+
+/* HP Omnibook quirks */
+static struct snd_pci_quirk m3_omnibook_quirk_list[] __devinitdata = {
+	SND_PCI_QUIRK_ID(0x103c, 0x0010), /* HP OmniBook 6000 */
+	SND_PCI_QUIRK_ID(0x103c, 0x0011), /* HP OmniBook 500 */
+	{ } /* END */
 };
 
 /*
@@ -2055,7 +2019,7 @@ static void snd_m3_ac97_reset(struct snd_m3 *chip)
 
 	for (i = 0; i < 5; i++) {
 		dir = inw(io + GPIO_DIRECTION);
-		if (! chip->quirk || ! chip->quirk->irda_workaround)
+		if (!chip->irda_workaround)
 			dir |= 0x10; /* assuming pci bus master? */
 
 		snd_m3_remote_codec_config(io, 0);
@@ -2478,7 +2442,7 @@ snd_m3_chip_init(struct snd_m3 *chip)
 	       DISABLE_LEGACY);
 	pci_write_config_word(pcidev, PCI_LEGACY_AUDIO_CTRL, w);
 
-	if (chip->hv_quirk && chip->hv_quirk->is_omnibook) {
+	if (chip->is_omnibook) {
 		/*
 		 * Volume buttons on some HP OmniBook laptops don't work
 		 * correctly. This makes them work for the most part.
@@ -2495,8 +2459,7 @@ snd_m3_chip_init(struct snd_m3 *chip)
 	}
 	pci_read_config_dword(pcidev, PCI_ALLEGRO_CONFIG, &n);
 	n &= ~(HV_CTRL_ENABLE | REDUCED_DEBOUNCE | HV_BUTTON_FROM_GD);
-	if (chip->hv_quirk)
-		n |= chip->hv_quirk->config;
+	n |= chip->hv_config;
 	/* For some reason we must always use reduced debounce. */
 	n |= REDUCED_DEBOUNCE;
 	n |= PM_CTRL_ENABLE | CLK_DIV_BY_49 | USE_PCI_TIMING;
@@ -2544,7 +2507,7 @@ snd_m3_enable_ints(struct snd_m3 *chip)
 
 	/* TODO: MPU401 not supported yet */
 	val = ASSP_INT_ENABLE /*| MPU401_INT_ENABLE*/;
-	if (chip->hv_quirk && (chip->hv_quirk->config & HV_CTRL_ENABLE))
+	if (chip->hv_config & HV_CTRL_ENABLE)
 		val |= HV_INT_ENABLE;
 	outw(val, io + HOST_INT_CTRL);
 	outb(inb(io + ASSP_CONTROL_C) | ASSP_HOST_INT_ENABLE,
@@ -2708,8 +2671,7 @@ snd_m3_create(struct snd_card *card, struct pci_dev *pci,
 {
 	struct snd_m3 *chip;
 	int i, err;
-	const struct m3_quirk *quirk;
-	const struct m3_hv_quirk *hv_quirk;
+	const struct snd_pci_quirk *quirk;
 	static struct snd_device_ops ops = {
 		.dev_free =	snd_m3_dev_free,
 	};
@@ -2749,34 +2711,32 @@ snd_m3_create(struct snd_card *card, struct pci_dev *pci,
 	chip->pci = pci;
 	chip->irq = -1;
 
-	for (quirk = m3_quirk_list; quirk->vendor; quirk++) {
-		if (pci->subsystem_vendor == quirk->vendor &&
-		    pci->subsystem_device == quirk->device) {
-			printk(KERN_INFO "maestro3: enabled hack for '%s'\n", quirk->name);
-			chip->quirk = quirk;
-			break;
-		}
-	}
-
-	for (hv_quirk = m3_hv_quirk_list; hv_quirk->vendor; hv_quirk++) {
-		if (pci->vendor == hv_quirk->vendor &&
-		    pci->device == hv_quirk->device &&
-		    pci->subsystem_vendor == hv_quirk->subsystem_vendor &&
-		    pci->subsystem_device == hv_quirk->subsystem_device) {
-			chip->hv_quirk = hv_quirk;
-			break;
-		}
-	}
-
 	chip->external_amp = enable_amp;
 	if (amp_gpio >= 0 && amp_gpio <= 0x0f)
 		chip->amp_gpio = amp_gpio;
-	else if (chip->quirk && chip->quirk->amp_gpio >= 0)
-		chip->amp_gpio = chip->quirk->amp_gpio;
-	else if (chip->allegro_flag)
-		chip->amp_gpio = GPO_EXT_AMP_ALLEGRO;
-	else /* presumably this is for all 'maestro3's.. */
-		chip->amp_gpio = GPO_EXT_AMP_M3;
+	else {
+		quirk = snd_pci_quirk_lookup(pci, m3_amp_quirk_list);
+		if (quirk) {
+			snd_printdd(KERN_INFO "maestro3: set amp-gpio "
+				    "for '%s'\n", quirk->name);
+			chip->amp_gpio = quirk->value;
+		} else if (chip->allegro_flag)
+			chip->amp_gpio = GPO_EXT_AMP_ALLEGRO;
+		else /* presumably this is for all 'maestro3's.. */
+			chip->amp_gpio = GPO_EXT_AMP_M3;
+	}
+
+	quirk = snd_pci_quirk_lookup(pci, m3_irda_quirk_list);
+	if (quirk) {
+		snd_printdd(KERN_INFO "maestro3: enabled irda workaround "
+			    "for '%s'\n", quirk->name);
+		chip->irda_workaround = 1;
+	}
+	quirk = snd_pci_quirk_lookup(pci, m3_hv_quirk_list);
+	if (quirk)
+		chip->hv_config = quirk->value;
+	if (snd_pci_quirk_lookup(pci, m3_omnibook_quirk_list))
+		chip->is_omnibook = 1;
 
 	chip->num_substreams = NR_DSPS;
 	chip->substreams = kcalloc(chip->num_substreams, sizeof(struct m3_dma),

--tMbDGjvJuJijemkf--
