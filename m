Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785Ab0AFJvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0AFJvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765Ab0AFJva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:51:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57575 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab0AFJvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:51:24 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-i2c@vger.kernel.org
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Chaithrika U S <chaithrika@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v2 2/4] i2c: davinci: Add helper functions
Date: Wed,  6 Jan 2010 14:54:58 +0530
Message-Id: <1262769900-2710-3-git-send-email-chaithrika@ti.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1262769900-2710-2-git-send-email-chaithrika@ti.com>
References: <1262769900-2710-1-git-send-email-chaithrika@ti.com>
 <1262769900-2710-2-git-send-email-chaithrika@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c reset control and clock divider calculation functions
which will be useful for power management features.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/i2c/busses/i2c-davinci.c |   56 +++++++++++++++++++++++++-------------
 1 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 44a3cb3..81c1049 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -124,12 +124,21 @@ static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
 	return __raw_readw(i2c_dev->base + reg);
 }
 
-/*
- * This functions configures I2C and brings I2C out of reset.
- * This function is called during I2C init function. This function
- * also gets called if I2C encounters any errors.
- */
-static int i2c_davinci_init(struct davinci_i2c_dev *dev)
+static inline void davinci_i2c_reset_ctrl(struct davinci_i2c_dev *i2c_dev,
+								int val)
+{
+	u16 w;
+
+	w = davinci_i2c_read_reg(i2c_dev, DAVINCI_I2C_MDR_REG);
+	if (!val)	/* put I2C into reset */
+		w &= ~DAVINCI_I2C_MDR_IRS;
+	else		/* take I2C out of reset */
+		w |= DAVINCI_I2C_MDR_IRS;
+
+	davinci_i2c_write_reg(i2c_dev, DAVINCI_I2C_MDR_REG, w);
+}
+
+static void i2c_davinci_calc_clk_dividers(struct davinci_i2c_dev *dev)
 {
 	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
 	u16 psc;
@@ -138,15 +147,6 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 	u32 clkh;
 	u32 clkl;
 	u32 input_clock = clk_get_rate(dev->clk);
-	u16 w;
-
-	if (!pdata)
-		pdata = &davinci_i2c_platform_data_default;
-
-	/* put I2C into reset */
-	w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-	w &= ~DAVINCI_I2C_MDR_IRS;
-	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
 
 	/* NOTE: I2C Clock divider programming info
 	 * As per I2C specs the following formulas provide prescaler
@@ -178,12 +178,32 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_CLKH_REG, clkh);
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_CLKL_REG, clkl);
 
+	dev_dbg(dev->dev, "input_clock = %d, CLK = %d\n", input_clock, clk);
+}
+
+/*
+ * This function configures I2C and brings I2C out of reset.
+ * This function is called during I2C init function. This function
+ * also gets called if I2C encounters any errors.
+ */
+static int i2c_davinci_init(struct davinci_i2c_dev *dev)
+{
+	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
+
+	if (!pdata)
+		pdata = &davinci_i2c_platform_data_default;
+
+	/* put I2C into reset */
+	davinci_i2c_reset_ctrl(dev, 0);
+
+	/* compute clock dividers */
+	i2c_davinci_calc_clk_dividers(dev);
+
 	/* Respond at reserved "SMBus Host" slave address" (and zero);
 	 * we seem to have no option to not respond...
 	 */
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_OAR_REG, 0x08);
 
-	dev_dbg(dev->dev, "input_clock = %d, CLK = %d\n", input_clock, clk);
 	dev_dbg(dev->dev, "PSC  = %d\n",
 		davinci_i2c_read_reg(dev, DAVINCI_I2C_PSC_REG));
 	dev_dbg(dev->dev, "CLKL = %d\n",
@@ -194,9 +214,7 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 		pdata->bus_freq, pdata->bus_delay);
 
 	/* Take the I2C module out of reset: */
-	w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-	w |= DAVINCI_I2C_MDR_IRS;
-	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
+	davinci_i2c_reset_ctrl(dev, 1);
 
 	/* Enable interrupts */
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_IMR_REG, I2C_DAVINCI_INTR_ALL);
-- 
1.5.6

