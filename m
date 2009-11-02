Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZKBQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZKBQw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZKBQw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:52:28 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48011 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755897AbZKBQw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:52:26 -0500
Subject: tps60501: Allow configuration of VDCDC2
Message-Id: <20091102165230.757607586@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben@simtec.co.uk>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       dbrownell@users.sourceforge.net
Cc: Simtec Linux Team <linux@simtec.co.uk>
Content-Disposition: inline; filename=tps65010-add-vdcdc2.patch
Date: Mon, 02 Nov 2009 16:52:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function to allow the configuation fo the VDCDC2 register by
external users, to allow changing of the standard and low-power
running modes.

This is needed, for example, for the Simtec IM2440D20 where we need
to use the low-power mode to shutdown the LDO/DCDC that are not needed
during suspend (saving substantial power) and the runtime use of the
low-power mode to change VCore.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>

---
 drivers/mfd/tps65010.c       |   28 ++++++++++++++++++++++++++++
 include/linux/i2c/tps65010.h |   19 +++++++++++++++++++
 2 files changed, 47 insertions(+)

Index: b/drivers/mfd/tps65010.c
===================================================================
--- a/drivers/mfd/tps65010.c	2009-11-02 15:55:43.000000000 +0000
+++ b/drivers/mfd/tps65010.c	2009-11-02 16:40:04.000000000 +0000
@@ -964,6 +964,34 @@ int tps65010_config_vregs1(unsigned valu
 }
 EXPORT_SYMBOL(tps65010_config_vregs1);
 
+int tps65010_config_vdcdc2(unsigned value)
+{
+	struct i2c_client *c;
+	int	 status;
+
+	if (!the_tps)
+		return -ENODEV;
+
+	c = the_tps->client;
+	mutex_lock(&the_tps->lock);
+
+	pr_debug("%s: vdcdc2 0x%02x\n", DRIVER_NAME,
+		 i2c_smbus_read_byte_data(c, TPS_VDCDC2));
+
+	status = i2c_smbus_write_byte_data(c, TPS_VDCDC2, value);
+
+	if (status != 0)
+		printk(KERN_ERR "%s: Failed to write vdcdc2 register\n",
+			DRIVER_NAME);
+	else
+		pr_debug("%s: vregs1 0x%02x\n", DRIVER_NAME,
+			 i2c_smbus_read_byte_data(c, TPS_VDCDC2));
+
+	mutex_unlock(&the_tps->lock);
+	return status;
+}
+EXPORT_SYMBOL(tps65010_config_vdcdc2);
+
 /*-------------------------------------------------------------------------*/
 /* tps65013_set_low_pwr parameter:
  * mode: ON or OFF
Index: b/include/linux/i2c/tps65010.h
===================================================================
--- a/include/linux/i2c/tps65010.h	2009-11-02 15:55:26.000000000 +0000
+++ b/include/linux/i2c/tps65010.h	2009-11-02 15:55:43.000000000 +0000
@@ -72,6 +72,21 @@
 #define	TPS_VDCDC1		0x0c
 #	define	TPS_ENABLE_LP		(1 << 3)
 #define	TPS_VDCDC2		0x0d
+#	define	TPS_LP_COREOFF	(1 << 7)
+#	define 	TPS_VCORE_1_8V	(7<<4)
+#	define 	TPS_VCORE_1_5V	(6 << 4)
+#	define 	TPS_VCORE_1_4V	(5 << 4)
+#	define 	TPS_VCORE_1_3V	(4 << 4)
+#	define 	TPS_VCORE_1_2V	(3 << 4)
+#	define 	TPS_VCORE_1_1V	(2 << 4)
+#	define 	TPS_VCORE_1_0V	(1 << 4)
+#	define 	TPS_VCORE_0_85V	(0 << 4)
+#	define	TPS_VCORE_LP_1_2V (3 << 2)
+#	define	TPS_VCORE_LP_1_1V (2 << 2)
+#	define	TPS_VCORE_LP_1_0V (1 << 2)
+#	define	TPS_VCORE_LP_0_85V (0 << 2)
+#	define	TPS_VIB		(1 << 1)
+#	define	TPS_VCORE_DISCH	(1 << 0)
 #define	TPS_VREGS1		0x0e
 #	define	TPS_LDO2_ENABLE	(1 << 7)
 #	define	TPS_LDO2_OFF	(1 << 6)
@@ -152,6 +167,10 @@ extern int tps65010_config_vregs1(unsign
  */
 extern int tps65013_set_low_pwr(unsigned mode);
 
+/* tps65010_set_vdcdc2
+ *  value to be written to VDCDC2
+ */
+extern int tps65010_config_vdcdc2(unsigned value);
 
 struct i2c_client;
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
