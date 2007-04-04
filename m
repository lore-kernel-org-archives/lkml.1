Return-Path: <linux-kernel-owner+w=401wt.eu-S2993023AbXDDSlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993023AbXDDSlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992996AbXDDSjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:39:45 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36410 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXDDSH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:07:27 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 19/90] ARM: OMAP: Register tsc2102 on Palm Tungsten E
Date: Wed,  4 Apr 2007 14:04:58 -0400
Message-Id: <11757100143517-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100112473-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrzej Zaborowski <balrog@zabor.org>

Add palmte board config bits for TSC2102 controlled devices. This will
enable touchscreen, audio and APM code to report battery level.

If there are other boards at some point that use a TSC2102, similar
code can be used.

Signed-off-by: Andrzej Zaborowski <balrog@zabor.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-palmte.c |  123 ++++++++++++++++++++++++++++++++++++
 1 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index c23e8b6..4c5b443 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -321,6 +321,116 @@ static struct tsc2102_config palmte_tsc2102_config = {
 	.alsa_config	= &palmte_alsa_config,
 };
 
+static struct omap_mcbsp_reg_cfg palmte_mcbsp1_regs = {
+	.spcr2	= FRST | GRST | XRST | XINTM(3),
+	.xcr2	= XDATDLY(1) | XFIG,
+	.xcr1	= XWDLEN1(OMAP_MCBSP_WORD_32),
+	.pcr0	= SCLKME | FSXP | CLKXP,
+};
+
+static struct omap_alsa_codec_config palmte_alsa_config = {
+	.name			= "TSC2102 audio",
+	.mcbsp_regs_alsa	= &palmte_mcbsp1_regs,
+	.codec_configure_dev	= NULL,	/* tsc2102_configure, */
+	.codec_set_samplerate	= NULL,	/* tsc2102_set_samplerate, */
+	.codec_clock_setup	= NULL,	/* tsc2102_clock_setup, */
+	.codec_clock_on		= NULL,	/* tsc2102_clock_on, */
+	.codec_clock_off	= NULL,	/* tsc2102_clock_off, */
+	.get_default_samplerate	= NULL,	/* tsc2102_get_default_samplerate, */
+};
+
+#ifdef CONFIG_APM
+/*
+ * Values measured in 10 minute intervals averaged over 10 samples.
+ * May differ slightly from device to device but should be accurate
+ * enough to give basic idea of battery life left and trigger
+ * potential alerts.
+ */
+static const int palmte_battery_sample[] = {
+	2194, 2157, 2138, 2120,
+	2104, 2089, 2075, 2061,
+	2048, 2038, 2026, 2016,
+	2008, 1998, 1989, 1980,
+	1970, 1958, 1945, 1928,
+	1910, 1888, 1860, 1827,
+	1791, 1751, 1709, 1656,
+};
+
+#define INTERVAL		10
+#define BATTERY_HIGH_TRESHOLD	66
+#define BATTERY_LOW_TRESHOLD	33
+
+static void palmte_get_power_status(struct apm_power_info *info, int *battery)
+{
+	int charging, batt, hi, lo, mid;
+
+	charging = !omap_get_gpio_datain(PALMTE_DC_GPIO);
+	batt = battery[0];
+	if (charging)
+		batt -= 60;
+
+	hi = ARRAY_SIZE(palmte_battery_sample);
+	lo = 0;
+
+	info->battery_flag = 0;
+	info->units = APM_UNITS_MINS;
+
+	if (batt > palmte_battery_sample[lo]) {
+		info->battery_life = 100;
+		info->time = INTERVAL * ARRAY_SIZE(palmte_battery_sample);
+	} else if (batt <= palmte_battery_sample[hi - 1]) {
+		info->battery_life = 0;
+		info->time = 0;
+	} else {
+		while (hi > lo + 1) {
+			mid = (hi + lo) >> 2;
+			if (batt <= palmte_battery_sample[mid])
+				lo = mid;
+			else
+				hi = mid;
+		}
+
+		mid = palmte_battery_sample[lo] - palmte_battery_sample[hi];
+		hi = palmte_battery_sample[lo] - batt;
+		info->battery_life = 100 - (100 * lo + 100 * hi / mid) /
+			ARRAY_SIZE(palmte_battery_sample);
+		info->time = INTERVAL * (ARRAY_SIZE(palmte_battery_sample) -
+				lo) - INTERVAL * hi / mid;
+	}
+
+	if (charging) {
+		info->ac_line_status = APM_AC_ONLINE;
+		info->battery_status = APM_BATTERY_STATUS_CHARGING;
+		info->battery_flag |= APM_BATTERY_FLAG_CHARGING;
+	} else {
+		info->ac_line_status = APM_AC_OFFLINE;
+		if (info->battery_life > BATTERY_HIGH_TRESHOLD)
+			info->battery_status = APM_BATTERY_STATUS_HIGH;
+		else if (info->battery_life > BATTERY_LOW_TRESHOLD)
+			info->battery_status = APM_BATTERY_STATUS_LOW;
+		else
+			info->battery_status = APM_BATTERY_STATUS_CRITICAL;
+	}
+
+	if (info->battery_life > BATTERY_HIGH_TRESHOLD)
+		info->battery_flag |= APM_BATTERY_FLAG_HIGH;
+	else if (info->battery_life > BATTERY_LOW_TRESHOLD)
+		info->battery_flag |= APM_BATTERY_FLAG_LOW;
+	else
+		info->battery_flag |= APM_BATTERY_FLAG_CRITICAL;
+}
+#else
+#define palmte_get_power_status	NULL
+#endif
+
+static struct tsc2102_config palmte_tsc2102_config = {
+	.use_internal	= 0,
+	.monitor	= TSC_BAT1 | TSC_AUX | TSC_TEMP,
+	.temp_at25c	= { 2200, 2615 },
+	.apm_report	= palmte_get_power_status,
+	.alsa_config	= &palmte_alsa_config,
+};
+
 static struct omap_board_config_kernel palmte_config[] = {
 	{ OMAP_TAG_USB,		&palmte_usb_config },
 	{ OMAP_TAG_MMC,		&palmte_mmc_config },
@@ -339,6 +449,17 @@ static struct spi_board_info palmte_spi_info[] __initdata = {
 	},
 };
 
+static struct spi_board_info palmte_spi_info[] __initdata = {
+	{
+		.modalias	= "tsc2102",
+		.bus_num	= 2,	/* uWire (officially) */
+		.chip_select	= 0,	/* As opposed to 3 */
+		.irq		= OMAP_GPIO_IRQ(PALMTE_PINTDAV_GPIO),
+		.platform_data	= &palmte_tsc2102_config,
+		.max_speed_hz	= 8000000,
+	},
+};
+
 /* Periodically check for changes on important input pins */
 struct timer_list palmte_pin_timer;
 int prev_power, prev_headphones;
@@ -418,6 +539,8 @@ static void __init omap_palmte_init(void)
 
 	spi_register_board_info(palmte_spi_info, ARRAY_SIZE(palmte_spi_info));
 
+	spi_register_board_info(palmte_spi_info, ARRAY_SIZE(palmte_spi_info));
+
 	omap_serial_init();
 	palmte_gpio_setup();
 }
-- 
1.4.4.2

