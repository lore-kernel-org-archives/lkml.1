Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZJVLPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZJVLPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZJVLPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:15:10 -0400
Received: from smtp.nokia.com ([192.100.105.134]:55611 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZJVLPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:15:09 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [PATCH v2] twl4030: Enable low-power mode to 32kHz oscillator
Date: Thu, 22 Oct 2009 14:14:09 +0300
Message-Id: <1256210049-4567-1-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 22 Oct 2009 11:14:57.0270 (UTC) FILETIME=[E35AC160:01CA5308]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows TWL's 32kHz oscillator to go in low-power mode when
main battery voltage is running low.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/mfd/twl4030-core.c  |    9 +++++++--
 include/linux/i2c/twl4030.h |    5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index eee5af8..004a8be 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -177,6 +177,7 @@
 #define HFCLK_FREQ_26_MHZ		(2 << 0)
 #define HFCLK_FREQ_38p4_MHZ		(3 << 0)
 #define HIGH_PERF_SQ			(1 << 3)
+#define CK32K_LOWPWR_EN			(1 << 7)
 
 
 /* chip-specific feature flags, for i2c_device_id.driver_data */
@@ -681,7 +682,8 @@ static inline int __init unprotect_pm_master(void)
 	return e;
 }
 
-static void clocks_init(struct device *dev)
+static void clocks_init(struct device *dev,
+			struct twl4030_clock_init_data *clock)
 {
 	int e = 0;
 	struct clk *osc;
@@ -728,6 +730,9 @@ static void clocks_init(struct device *dev)
 	}
 
 	ctrl |= HIGH_PERF_SQ;
+	if (clock && clock->ck32k_lowpwr_enable)
+		ctrl |= CK32K_LOWPWR_EN;
+
 	e |= unprotect_pm_master();
 	/* effect->MADC+USB ck en */
 	e |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, ctrl, R_CFG_BOOT);
@@ -806,7 +811,7 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	inuse = true;
 
 	/* setup clock framework */
-	clocks_init(&client->dev);
+	clocks_init(&client->dev, pdata->clock);
 
 	/* load power event scripts */
 	if (twl_has_power() && pdata->power)
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 4a2fb27..10e68cb 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -313,6 +313,10 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
+struct twl4030_clock_init_data {
+	bool ck32k_lowpwr_enable;
+};
+
 struct twl4030_bci_platform_data {
 	int *battery_tmp_tbl;
 	unsigned int tblsize;
@@ -407,6 +411,7 @@ extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
 
 struct twl4030_platform_data {
 	unsigned				irq_base, irq_end;
+	struct twl4030_clock_init_data		*clock;
 	struct twl4030_bci_platform_data	*bci;
 	struct twl4030_gpio_platform_data	*gpio;
 	struct twl4030_madc_platform_data	*madc;
-- 
1.6.0.4

