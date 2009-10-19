Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZJSMLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZJSMLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZJSMLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:11:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:51183 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbZJSMLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:11:01 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: sameo@linux.intel.com, linux-omap@vger.kernel.org
Subject: [PATCH 4/5] mfd: twl4030-power: Add support for remapping power states
Date: Mon, 19 Oct 2009 15:11:00 +0300
Message-Id: <1255954260-29043-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 19 Oct 2009 12:11:01.0140 (UTC) FILETIME=[39235540:01CA50B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The <RESOURCE>_REMAP register allows configuration of the <RESOURCE> in case
of a sleep or off transition.

Allow this property of resources to be configured (through twl4030_resconfig)
and add code to parse these values to program the registers accordingly.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/twl4030-power.c |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h |    3 +++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 2c38ac1..3e41e0c 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -75,6 +75,8 @@ static u8 twl4030_start_script_address = 0x2b;
 */
 #define DEV_GRP_OFFSET		0
 #define TYPE_OFFSET		1
+#define REMAP_OFFSET		2
+#define DEDICATED_OFFSET	3
 
 /* Bit positions in the registers */
 
@@ -88,6 +90,12 @@ static u8 twl4030_start_script_address = 0x2b;
 #define TYPE2_SHIFT		3
 #define TYPE2_MASK		(3 << TYPE2_SHIFT)
 
+/* <RESOURCE>_REMAP */
+#define SLEEP_STATE_SHIFT	0
+#define SLEEP_STATE_MASK	(0xf << SLEEP_STATE_SHIFT)
+#define OFF_STATE_SHIFT		4
+#define OFF_STATE_MASK		(0xf << OFF_STATE_SHIFT)
+
 static u8 res_config_addrs[] = {
 	[RES_VAUX1]	= 0x17,
 	[RES_VAUX2]	= 0x1b,
@@ -325,6 +333,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 	int err;
 	u8 type;
 	u8 grp;
+	u8 remap;
 
 	if (rconfig->resource > TOTAL_RESOURCES) {
 		pr_err("TWL4030 Resource %d does not exist\n",
@@ -380,6 +389,33 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
+	/* Set remap states */
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &remap,
+				rconfig_addr + REMAP_OFFSET);
+	if (err < 0) {
+		pr_err("TWL4030 Resource %d remap could not be read\n",
+			rconfig->resource);
+		return err;
+	}
+
+	if (rconfig->remap_off >= 0) {
+		remap &= ~OFF_STATE_MASK;
+		remap |= rconfig->remap_off << OFF_STATE_SHIFT;
+	}
+
+	if (rconfig->remap_sleep >= 0) {
+		remap &= ~SLEEP_STATE_MASK;
+		remap |= rconfig->remap_off << SLEEP_STATE_SHIFT;
+	}
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				remap,
+				rconfig_addr + REMAP_OFFSET);
+	if (err < 0) {
+		pr_err("TWL4030 failed to program remap\n");
+		return err;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 4bc2836..ef21575 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -326,6 +326,7 @@ struct twl4030_script {
 
 #define RES_TYPE_ALL		0x7
 
+/* Resource states */
 #define RES_STATE_WRST		0xF
 #define RES_STATE_ACTIVE	0xE
 #define RES_STATE_SLEEP		0x8
@@ -393,6 +394,8 @@ struct twl4030_resconfig {
 	u8 devgroup;	/* Processor group that Power resource belongs to */
 	u8 type;	/* Power resource addressed, 6 / broadcast message */
 	u8 type2;	/* Power resource addressed, 3 / broadcast message */
+	u8 remap_off;	/* off state remapping */
+	u8 remap_sleep;	/* sleep state remapping */
 };
 
 struct twl4030_power_data {
-- 
1.6.3.3

