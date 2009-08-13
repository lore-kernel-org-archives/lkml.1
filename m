Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZHMIll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZHMIll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZHMIll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:41:41 -0400
Received: from mail.df.lth.se ([194.47.250.12]:54391 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753275AbZHMIlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:41:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: dann frazier <dannf@debian.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] Fix various issues with AB3100 MFD driver
Date: Thu, 13 Aug 2009 10:40:58 +0200
Message-Id: <1250152858-8032-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames the AB3100 accessor functions with the _interruptible
suffix for clarity, makes ab3100_set_register_interruptible()
propagate any errors, corrects a default setting, make us disable
IRQs on the external line asyncronously. It further fixes a
compilation warning reported by both Stephen Rotwell and Dann
Frazier.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c  |   51 ++++++++++++++++++++++++-------------------
 include/linux/mfd/ab3100.h |    9 ++++---
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 13e7d7b..098e825 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -77,7 +77,7 @@ u8 ab3100_get_chip_type(struct ab3100 *ab3100)
 }
 EXPORT_SYMBOL(ab3100_get_chip_type);
 
-int ab3100_set_register(struct ab3100 *ab3100, u8 reg, u8 regval)
+int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval)
 {
 	u8 regandval[2] = {reg, regval};
 	int err;
@@ -107,9 +107,10 @@ int ab3100_set_register(struct ab3100 *ab3100, u8 reg, u8 regval)
 		err = 0;
 	}
 	mutex_unlock(&ab3100->access_mutex);
-	return 0;
+	return err;
 }
-EXPORT_SYMBOL(ab3100_set_register);
+EXPORT_SYMBOL(ab3100_set_register_interruptible);
+
 
 /*
  * The test registers exist at an I2C bus address up one
@@ -118,7 +119,7 @@ EXPORT_SYMBOL(ab3100_set_register);
  * anyway. It's currently only used from this file so declare
  * it static and do not export.
  */
-static int ab3100_set_test_register(struct ab3100 *ab3100,
+static int ab3100_set_test_register_interruptible(struct ab3100 *ab3100,
 				    u8 reg, u8 regval)
 {
 	u8 regandval[2] = {reg, regval};
@@ -148,7 +149,8 @@ static int ab3100_set_test_register(struct ab3100 *ab3100,
 	return err;
 }
 
-int ab3100_get_register(struct ab3100 *ab3100, u8 reg, u8 *regval)
+
+int ab3100_get_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 *regval)
 {
 	int err;
 
@@ -202,9 +204,10 @@ int ab3100_get_register(struct ab3100 *ab3100, u8 reg, u8 *regval)
 	mutex_unlock(&ab3100->access_mutex);
 	return err;
 }
-EXPORT_SYMBOL(ab3100_get_register);
+EXPORT_SYMBOL(ab3100_get_register_interruptible);
 
-int ab3100_get_register_page(struct ab3100 *ab3100,
+
+int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
 			     u8 first_reg, u8 *regvals, u8 numregs)
 {
 	int err;
@@ -258,9 +261,10 @@ int ab3100_get_register_page(struct ab3100 *ab3100,
 	mutex_unlock(&ab3100->access_mutex);
 	return err;
 }
-EXPORT_SYMBOL(ab3100_get_register_page);
+EXPORT_SYMBOL(ab3100_get_register_page_interruptible);
+
 
-int ab3100_mask_and_set_register(struct ab3100 *ab3100,
+int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
 				 u8 reg, u8 andmask, u8 ormask)
 {
 	u8 regandval[2] = {reg, 0};
@@ -328,7 +332,8 @@ int ab3100_mask_and_set_register(struct ab3100 *ab3100,
 	mutex_unlock(&ab3100->access_mutex);
 	return err;
 }
-EXPORT_SYMBOL(ab3100_mask_and_set_register);
+EXPORT_SYMBOL(ab3100_mask_and_set_register_interruptible);
+
 
 /*
  * Register a simple callback for handling any AB3100 events.
@@ -371,7 +376,7 @@ static void ab3100_work(struct work_struct *work)
 	u32 fatevent;
 	int err;
 
-	err = ab3100_get_register_page(ab3100, AB3100_EVENTA1,
+	err = ab3100_get_register_page_interruptible(ab3100, AB3100_EVENTA1,
 				       event_regs, 3);
 	if (err)
 		goto err_event_wq;
@@ -417,7 +422,7 @@ static irqreturn_t ab3100_irq_handler(int irq, void *data)
 	 * stuff and we will re-enable the interrupts once th
 	 * worker has finished.
 	 */
-	disable_irq(ab3100->i2c_client->irq);
+	disable_irq_nosync(irq);
 	schedule_work(&ab3100->work);
 	return IRQ_HANDLED;
 }
@@ -435,7 +440,7 @@ static int ab3100_registers_print(struct seq_file *s, void *p)
 	seq_printf(s, "AB3100 registers:\n");
 
 	for (reg = 0; reg < 0xff; reg++) {
-		ab3100_get_register(ab3100, reg, &value);
+		ab3100_get_register_interruptible(ab3100, reg, &value);
 		seq_printf(s, "[0x%x]:  0x%x\n", reg, value);
 	}
 	return 0;
@@ -465,7 +470,7 @@ static int ab3100_get_set_reg_open_file(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int ab3100_get_set_reg(struct file *file,
+static ssize_t ab3100_get_set_reg(struct file *file,
 			      const char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
@@ -515,7 +520,7 @@ static int ab3100_get_set_reg(struct file *file,
 		u8 reg = (u8) user_reg;
 		u8 regvalue;
 
-		ab3100_get_register(ab3100, reg, &regvalue);
+		ab3100_get_register_interruptible(ab3100, reg, &regvalue);
 
 		dev_info(ab3100->dev,
 			 "debug read AB3100 reg[0x%02x]: 0x%02x\n",
@@ -547,8 +552,8 @@ static int ab3100_get_set_reg(struct file *file,
 			return -EINVAL;
 
 		value = (u8) user_value;
-		ab3100_set_register(ab3100, reg, value);
-		ab3100_get_register(ab3100, reg, &regvalue);
+		ab3100_set_register_interruptible(ab3100, reg, value);
+		ab3100_get_register_interruptible(ab3100, reg, &regvalue);
 
 		dev_info(ab3100->dev,
 			 "debug write reg[0x%02x] with 0x%02x, "
@@ -662,7 +667,7 @@ ab3100_init_settings[] = {
 		.setting = 0x01
 	}, {
 		.abreg = AB3100_IMRB1,
-		.setting = 0xFF
+		.setting = 0xBF
 	}, {
 		.abreg = AB3100_IMRB2,
 		.setting = 0xFF
@@ -696,7 +701,7 @@ static int __init ab3100_setup(struct ab3100 *ab3100)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(ab3100_init_settings); i++) {
-		err = ab3100_set_register(ab3100,
+		err = ab3100_set_register_interruptible(ab3100,
 					  ab3100_init_settings[i].abreg,
 					  ab3100_init_settings[i].setting);
 		if (err)
@@ -705,14 +710,14 @@ static int __init ab3100_setup(struct ab3100 *ab3100)
 
 	/*
 	 * Special trick to make the AB3100 use the 32kHz clock (RTC)
-	 * bit 3 in test registe 0x02 is a special, undocumented test
+	 * bit 3 in test register 0x02 is a special, undocumented test
 	 * register bit that only exist in AB3100 P1E
 	 */
 	if (ab3100->chip_id == 0xc4) {
 		dev_warn(ab3100->dev,
 			 "AB3100 P1E variant detected, "
 			 "forcing chip to 32KHz\n");
-		err = ab3100_set_test_register(ab3100, 0x02, 0x08);
+		err = ab3100_set_test_register_interruptible(ab3100, 0x02, 0x08);
 	}
 
  exit_no_setup:
@@ -852,8 +857,8 @@ static int __init ab3100_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, ab3100);
 
 	/* Read chip ID register */
-	err = ab3100_get_register(ab3100, AB3100_CID,
-				  &ab3100->chip_id);
+	err = ab3100_get_register_interruptible(ab3100, AB3100_CID,
+						&ab3100->chip_id);
 	if (err) {
 		dev_err(&client->dev,
 			"could not communicate with the AB3100 analog "
diff --git a/include/linux/mfd/ab3100.h b/include/linux/mfd/ab3100.h
index 7a3f316..b3e7d70 100644
--- a/include/linux/mfd/ab3100.h
+++ b/include/linux/mfd/ab3100.h
@@ -56,6 +56,7 @@
 #define AB3100_STR_BATT_REMOVAL				(0x40)
 #define AB3100_STR_VBUS					(0x80)
 
+
 /**
  * struct ab3100
  * @access_mutex: lock out concurrent accesses to the AB3100 registers
@@ -86,11 +87,11 @@ struct ab3100 {
 	bool startup_events_read;
 };
 
-int ab3100_set_register(struct ab3100 *ab3100, u8 reg, u8 regval);
-int ab3100_get_register(struct ab3100 *ab3100, u8 reg, u8 *regval);
-int ab3100_get_register_page(struct ab3100 *ab3100,
+int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval);
+int ab3100_get_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 *regval);
+int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
 			     u8 first_reg, u8 *regvals, u8 numregs);
-int ab3100_mask_and_set_register(struct ab3100 *ab3100,
+int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
 				 u8 reg, u8 andmask, u8 ormask);
 u8 ab3100_get_chip_type(struct ab3100 *ab3100);
 int ab3100_event_register(struct ab3100 *ab3100,
-- 
1.6.2.1

