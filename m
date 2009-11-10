Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZKJCi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZKJCi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZKJCi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:38:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:46851 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZKJCiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NKNDvXIXcWjzcg9mGgfdPu1nby2L7BXn7Mjhdp7fZEvpLClDT2sJywhhyDNyrDzX5n
         rY0knf53FYRGCOcZLGkTVIQeQtb2q/KnzG/gQHKu2bWDhQMLFmGUF1xiicFDFcdK8oGg
         4ABKXA7AMiVnHiG2FfJJxvhdYF4UJbiZdqPmU=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, zaurus-devel@www.linuxtogo.org,
       Paul Fertser <fercerpav@gmail.com>
Subject: [RFC PATCH 2/2] gta02: add support for platform_battery
Date: Tue, 10 Nov 2009 05:37:53 +0300
Message-Id: <1257820673-30801-3-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257820673-30801-2-git-send-email-fercerpav@gmail.com>
References: <1257820673-30801-1-git-send-email-fercerpav@gmail.com>
 <1257820673-30801-2-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for platform_battery driver which allows to specify a set
of power supply properties and callbacks to acquire them. It is needed to
support dumb batteries where all the information about their status can
only be obtained by platform-specific actions such as specific ADC
measurements, some guessimation etc.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 arch/arm/mach-s3c2442/mach-gta02.c |  113 ++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2442/mach-gta02.c b/arch/arm/mach-s3c2442/mach-gta02.c
index 8c61026..2159066 100644
--- a/arch/arm/mach-s3c2442/mach-gta02.c
+++ b/arch/arm/mach-s3c2442/mach-gta02.c
@@ -106,6 +106,8 @@
 #include <linux/hdq.h>
 #include <linux/bq27000_battery.h>
 
+#include <linux/platform_battery.h>
+
 #include <linux/gta02-vibrator.h>
 
 #include <mach/ts.h>
@@ -866,6 +868,117 @@ struct platform_device bq27000_battery_device = {
 	},
 };
 
+/* Platform battery */
+
+/* Capacity of a typical BL-5C dumb battery */
+#define GTA02_BAT_CHARGE_FULL	850000
+
+static int gta02_bat_voltscale(int volt)
+{
+	/* This table is suggested by SpeedEvil based on analysis of
+	 * experimental data */
+	static const int lut[][2] = {
+		{ 4120, 100 },
+		{ 3900, 60 },
+		{ 3740, 25 },
+		{ 3600, 5 },
+		{ 3000, 0 } };
+	int i, res = 0;
+
+	if (volt > lut[0][0])
+		res = lut[0][1];
+	else
+		for (i = 0; lut[i][1]; i++) {
+			if (volt <= lut[i][0] && volt >= lut[i+1][0]) {
+				res = lut[i][1] - (lut[i][0]-volt)*
+					(lut[i][1]-lut[i+1][1])/
+					(lut[i][0]-lut[i+1][0]);
+				break;
+			}
+		}
+	return res;
+}
+
+static int gta02_bat_get_voltage(void)
+{
+	struct pcf50633 *pcf = gta02_pcf;
+	u16 adc, mv = 0;
+	adc = pcf50633_adc_sync_read(pcf,
+		PCF50633_ADCC1_MUX_BATSNS_RES,
+		PCF50633_ADCC1_AVERAGE_16);
+	/* The formula from DS is for divide-by-two mode, current driver uses
+	divide-by-three */
+	mv = (adc * 6000) / 1023;
+	return mv * 1000;
+}
+
+static int gta02_bat_get_present(void)
+{
+	/* There is no reliable way to tell if it is present or not */
+	return 1;
+}
+
+static int gta02_bat_get_status(void)
+{
+#ifdef CONFIG_CHARGER_PCF50633
+	if (gta02_get_charger_active_status())
+		return POWER_SUPPLY_STATUS_CHARGING;
+	else
+		return POWER_SUPPLY_STATUS_DISCHARGING;
+#else
+	return POWER_SUPPLY_STATUS_UNKNOWN;
+#endif
+}
+
+static int gta02_bat_get_capacity(void)
+{
+	return gta02_bat_voltscale(gta02_bat_get_voltage()/1000);
+}
+
+static int gta02_bat_get_charge_full(void)
+{
+	return GTA02_BAT_CHARGE_FULL;
+}
+
+static int gta02_bat_get_charge_now(void)
+{
+	return gta02_bat_get_capacity() * gta02_bat_get_charge_full() / 100;
+}
+
+static enum power_supply_property gta02_platform_bat_properties[] = {
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+};
+
+int (*gta02_platform_bat_get_property[])(void) = {
+	gta02_bat_get_present,
+	gta02_bat_get_status,
+	gta02_bat_get_voltage,
+	gta02_bat_get_capacity,
+	gta02_bat_get_charge_full,
+	gta02_bat_get_charge_now,
+};
+
+static struct platform_bat_platform_data gta02_platform_bat_pdata = {
+	.name = "battery",
+	.properties = gta02_platform_bat_properties,
+	.num_properties = ARRAY_SIZE(gta02_platform_bat_properties),
+	.get_property = gta02_platform_bat_get_property,
+	.is_present = gta02_bat_get_present,
+};
+
+struct platform_device gta02_platform_bat = {
+	.name = "platform_battery",
+	.id = -1,
+	.dev = {
+		.platform_data = &gta02_platform_bat_pdata,
+	}
+};
+
 /* HDQ */
 
 static void gta02_hdq_attach_child_devices(struct device *parent_device)
-- 
1.6.4.4

