Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbYDDWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbYDDWDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYDDWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:03:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:62384 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYDDWDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ne84qp5PcAj84Dz5V2cTH0q8HB0grMspTafBNpMYo62PMJtq6cgCeO0JLi6eT9UJbON8IEi+elB2oN8zAYFmw5lY+TyVcjpOAG8ldEv6GqkFoWtCHoDEh7mFKW9WWvMRq3WzI1HQWu9fpLKWws+OM+tUIW9a320XJ9+iBcSdXIg=
Message-ID: <5767b9100804041503o7395ff34nd13002c111e11c8a@mail.gmail.com>
Date: Sat, 5 Apr 2008 06:03:32 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, rmk@arm.linux.org.uk
Subject: [PATCH] add AT73C213 DAC support for AT91SAM9261
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many AT91SAM9261-based boards use AT73C213 as external audio DAC, this
patch makes it work.

Signed-off-by: Conke Hu <conke.hu@gmail.com>
---------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c
b/arch/arm/mach-at91/at91sam9261_devices.c
old mode 100644
new mode 100755
diff --git a/arch/arm/mach-at91/board-sam9261ek.c
b/arch/arm/mach-at91/board-sam9261ek.c
old mode 100644
new mode 100755
index 0ce38df..a739cfe
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -30,6 +30,8 @@
 #include <linux/fb.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
+#include <linux/clk.h>
+#include <linux/spi/at73c213.h>

 #include <video/atmel_lcdc.h>

@@ -239,6 +241,45 @@ static void __init ek_add_device_ts(void) {}
 #endif

 /*
+ * AT73C213 Audio
+ */
+#if defined(CONFIG_SND_AT73C213) || defined(CONFIG_SND_AT73C213_MODULE)
+static struct at73c213_board_info at73c213_info = {
+	.ssc_id    = 1,
+	.shortname = "at72c213",
+};
+
+static void __init at91_setup_at73c213(void)
+{
+	struct clk *mclk;
+	struct clk *plla;
+
+	mclk = clk_get(NULL, "pck2");
+	if (IS_ERR(mclk))
+		goto err_mclk;
+
+	plla = clk_get(NULL, "plla");
+	if (IS_ERR(plla))
+		goto err_plla;
+
+	if (clk_set_parent(mclk, plla))
+		goto err_clk;
+
+	at91_set_B_periph(AT91_PIN_PB31, 0);
+	at73c213_info.dac_clk = mclk;
+
+err_clk:
+	clk_put(plla);
+err_plla:
+	clk_put(mclk);
+err_mclk:
+	return;
+}
+#else
+static void __init at91_setup_at73c213(void) {}
+#endif
+
+/*
  * SPI devices
  */
 static struct spi_board_info ek_spi_devices[] = {
@@ -271,6 +312,8 @@ static struct spi_board_info ek_spi_devices[] = {
 		.chip_select	= 3,
 		.max_speed_hz	= 10 * 1000 * 1000,
 		.bus_num	= 0,
+		.platform_data = &at73c213_info,
+		.controller_data = (void*)AT91_PIN_PA29,
 	},
 #endif
 };
@@ -477,6 +520,8 @@ static void __init ek_board_init(void)

 	/* spi0 and mmc/sd share the same PIO pins */
 #if defined(CONFIG_SPI_ATMEL) || defined(CONFIG_SPI_ATMEL_MODULE)
+	/* Audio */
+	at91_setup_at73c213();
 	/* SPI */
 	at91_add_device_spi(ek_spi_devices, ARRAY_SIZE(ek_spi_devices));
 	/* Touchscreen */
@@ -489,6 +534,10 @@ static void __init ek_board_init(void)
 	at91_add_device_lcdc(&ek_lcdc_data);
 	/* Push Buttons */
 	ek_add_device_buttons();
+	/* SSC */
+#if defined(CONFIG_ATMEL_SSC) || defined(CONFIG_ATMEL_SSC_MODULE)
+	at91_add_device_ssc(AT91SAM9261_ID_SSC1, ATMEL_SSC_TX);
+#endif
 }

 MACHINE_START(AT91SAM9261EK, "Atmel AT91SAM9261-EK")
diff --git a/sound/core/control.c b/sound/core/control.c
old mode 100644
new mode 100755
diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
old mode 100644
new mode 100755
index 89d6e9c..b8e43fe
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -114,7 +114,11 @@ snd_at73c213_write_reg(struct snd_at73c213 *chip,
u8 reg, u8 val)
 static struct snd_pcm_hardware snd_at73c213_playback_hw = {
 	.info		= SNDRV_PCM_INFO_INTERLEAVED |
 			  SNDRV_PCM_INFO_BLOCK_TRANSFER,
+#ifdef __BIG_ENDIAN
 	.formats	= SNDRV_PCM_FMTBIT_S16_BE,
+#else
+	.formats	= SNDRV_PCM_FMTBIT_S16_LE,
+#endif
 	.rates		= SNDRV_PCM_RATE_CONTINUOUS,
 	.rate_min	= 8000,  /* Replaced by chip->bitrate later. */
 	.rate_max	= 50000, /* Replaced by chip->bitrate later. */
