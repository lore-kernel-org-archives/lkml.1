Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZGTNiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZGTNiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZGTNiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:38:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59763 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbZGTNiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:38:22 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Rajendra Nayak <rnayak@ti.com>
Subject: [RFC][PATCH 4/4] OMAP4: PMIC: Update TWL mfd driver to create twl6030 regulators
Date: Mon, 20 Jul 2009 19:07:53 +0530
Message-Id: <1248097073-14838-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

This patch adds initial support for creating twl6030 PMIC
specific voltage regulators in the twl mfd driver.

Board specific regulator configurations will have to be passed from
respective board files.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/mfd/twl-core.c  |   64 +++++++++++++++++++++++++++++++++++++++++-----
 include/linux/i2c/twl.h |   18 +++++++++---
 2 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index cf4fec4..2ad01dd 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -76,11 +76,18 @@
 #define twl_has_gpio()	false
 #endif
 
-#if defined(CONFIG_REGULATOR_TWL4030) \
-	|| defined(CONFIG_REGULATOR_TWL4030_MODULE)
-#define twl_has_regulator()	true
+#if defined(CONFIG_REGULATOR_TWL) \
+	|| defined(CONFIG_REGULATOR_TWL_MODULE)
+#ifdef CONFIG_TWL4030_CORE
+#define twl_has_4030regulator()	true
+#define twl_has_6030regulator() false
+#elif CONFIG_TWL6030_CORE
+#define twl_has_6030regulator() true
+#define twl_has_4030regulator()	false
+#endif
 #else
-#define twl_has_regulator()	false
+#define twl_has_4030regulator()	false
+#define twl_has_6030regulator()	false
 #endif
 
 #if defined(CONFIG_TWL4030_MADC) || defined(CONFIG_TWL4030_MADC_MODULE)
@@ -630,7 +637,7 @@ add_children(struct twl_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_regulator()) {
+	if (twl_has_4030regulator()) {
 		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
 		if (IS_ERR(child))
@@ -653,7 +660,7 @@ add_children(struct twl_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_regulator() && usb_transceiver) {
+	if (twl_has_4030regulator() && usb_transceiver) {
 		static struct regulator_consumer_supply usb1v5 = {
 			.supply =	"usb1v5",
 		};
@@ -695,7 +702,7 @@ add_children(struct twl_platform_data *pdata, unsigned long features)
 	}
 
 	/* maybe add LDOs that are omitted on cost-reduced parts */
-	if (twl_has_regulator() && !(features & TPS_SUBSET)) {
+	if (twl_has_4030regulator() && !(features & TPS_SUBSET)) {
 		child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
@@ -721,6 +728,49 @@ add_children(struct twl_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
+	/* twl6030 regulators */
+	if (twl_has_6030regulator()) {
+		child = add_regulator(TWL6030_REG_VMMC, pdata->vmmc);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VPP, pdata->vpp);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VUSIM, pdata->vusim);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VANA, pdata->vana);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VCXIO, pdata->vcxio);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VDAC, pdata->vdac);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VUSB, pdata->vusb);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VAUX1_6030, pdata->vaux1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VAUX2_6030, pdata->vaux2);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VAUX3_6030, pdata->vaux3);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index b128831..16dc692 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -360,6 +360,7 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 #define TWL4030_INT_PWR_EDR2		0x6
 #define TWL4030_INT_PWR_SIH_CTRL	0x7
 
+
 /*----------------------------------------------------------------------*/
 
 /* Power bus message definitions */
@@ -478,18 +479,25 @@ struct twl_platform_data {
 	struct twl_keypad_data		*keypad;
 	struct twl_usb_data			*usb;
 
-	/* LDO regulators */
+	/* LDO regulators common to TWL4030/TWL6030 */
 	struct regulator_init_data		*vdac;
+	struct regulator_init_data		*vaux1;
+	struct regulator_init_data		*vaux2;
+	struct regulator_init_data		*vaux3;
+	/* TWL4030 LDO regulators */
 	struct regulator_init_data		*vpll1;
 	struct regulator_init_data		*vpll2;
 	struct regulator_init_data		*vmmc1;
 	struct regulator_init_data		*vmmc2;
 	struct regulator_init_data		*vsim;
-	struct regulator_init_data		*vaux1;
-	struct regulator_init_data		*vaux2;
-	struct regulator_init_data		*vaux3;
 	struct regulator_init_data		*vaux4;
-
+	/* TWL6030 LDO regulators */
+	struct regulator_init_data              *vmmc;
+	struct regulator_init_data              *vpp;
+	struct regulator_init_data              *vusim;
+	struct regulator_init_data              *vana;
+	struct regulator_init_data              *vcxio;
+	struct regulator_init_data              *vusb;
 	/* REVISIT more to come ... _nothing_ should be hard-wired */
 };
 
-- 
1.5.4.7

