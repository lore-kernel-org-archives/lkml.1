Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZI3PLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZI3PLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZI3PLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:11:33 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52040 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZI3PLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:11:31 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org, ilkka.koskinen@nokia.com
Subject: [PATCH 2/2] twl4030: Enable low-power mode to 32KHz oscillator
Date: Wed, 30 Sep 2009 18:11:55 +0300
Message-Id: <1254323515-30866-2-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1254323515-30866-1-git-send-email-ilkka.koskinen@nokia.com>
References: <1254323515-30866-1-git-send-email-ilkka.koskinen@nokia.com>
X-OriginalArrivalTime: 30 Sep 2009 15:11:26.0558 (UTC) FILETIME=[47BDC7E0:01CA41E0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows TWL's 32KHz oscillator to go in low-power mode when
main battery voltage is running low.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/mfd/twl4030-core.c  |    9 +++++++--
 include/linux/i2c/twl4030.h |    5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index 8cf0a02..5596bb4 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -177,6 +177,7 @@
 #define HFCLK_FREQ_26_MHZ		(2 << 0)
 #define HFCLK_FREQ_38p4_MHZ		(3 << 0)
 #define HIGH_PERF_SQ			(1 << 3)
+#define CK32K_LOWPWR_EN			(1 << 7)
 
 
 /* chip-specific feature flags, for i2c_device_id.driver_data */
@@ -678,7 +679,8 @@ static inline int __init unprotect_pm_master(void)
 	return e;
 }
 
-static void clocks_init(struct device *dev)
+static void clocks_init(struct device *dev,
+			struct twl4030_clock_init_data *clock)
 {
 	int e = 0;
 	struct clk *osc;
@@ -725,6 +727,9 @@ static void clocks_init(struct device *dev)
 	}
 
 	ctrl |= HIGH_PERF_SQ;
+	if (clock && clock->ck32k_lowpwr_enable)
+		ctrl |= CK32K_LOWPWR_EN;
+
 	e |= unprotect_pm_master();
 	/* effect->MADC+USB ck en */
 	e |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, ctrl, R_CFG_BOOT);
@@ -805,7 +810,7 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	inuse = true;
 
 	/* setup clock framework */
-	clocks_init(&client->dev);
+	clocks_init(&client->dev, pdata->clock);
 
 	/* load power event scripts */
 	if (twl_has_power() && pdata->power)
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 2d02dfd..612d0b7 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -312,6 +312,10 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
+struct twl4030_clock_init_data {
+	int ck32k_lowpwr_enable;
+};
+
 struct twl4030_bci_platform_data {
 	int *battery_tmp_tbl;
 	unsigned int tblsize;
@@ -403,6 +407,7 @@ extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
 
 struct twl4030_platform_data {
 	unsigned				irq_base, irq_end;
+	struct twl4030_clock_init_data		*clock;
 	struct twl4030_bci_platform_data	*bci;
 	struct twl4030_gpio_platform_data	*gpio;
 	struct twl4030_madc_platform_data	*madc;
-- 
1.6.0.4

