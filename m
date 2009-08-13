Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZHMJta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZHMJta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZHMJta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:49:30 -0400
Received: from mail.df.lth.se ([194.47.250.12]:55418 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753244AbZHMJt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:49:29 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/5] MFD AB3100 accessor function cleanups
Date: Thu, 13 Aug 2009 11:49:23 +0200
Message-Id: <1250156963-8828-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the _interruptible suffix to the AB3100 accessor
functions on par with mutex_lock_interruptible() that's used
for blocking simultaneous calls to the AB3100 acessor functions.
Since these accesses are slow on a 100kHz I2C bus and may line
up waiting for the mutex, we need to handle interruption by
system shutdown or kill signals and may just as well denote that
in the function names.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c  |   43 ++++++++++++++++++++++++-------------------
 include/linux/mfd/ab3100.h |    8 ++++----
 2 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 13e7d7b..ffb2af2 100644
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
@@ -109,7 +109,8 @@ int ab3100_set_register(struct ab3100 *ab3100, u8 reg, u8 regval)
 	mutex_unlock(&ab3100->access_mutex);
 	return 0;
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
+
 
-int ab3100_get_register_page(struct ab3100 *ab3100,
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
 
-int ab3100_mask_and_set_register(struct ab3100 *ab3100,
+
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
@@ -435,7 +440,7 @@ static int ab3100_registers_print(struct seq_file *s, void *p)
 	seq_printf(s, "AB3100 registers:\n");
 
 	for (reg = 0; reg < 0xff; reg++) {
-		ab3100_get_register(ab3100, reg, &value);
+		ab3100_get_register_interruptible(ab3100, reg, &value);
 		seq_printf(s, "[0x%x]:  0x%x\n", reg, value);
 	}
 	return 0;
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
index 7a3f316..56343b8 100644
--- a/include/linux/mfd/ab3100.h
+++ b/include/linux/mfd/ab3100.h
@@ -86,11 +86,11 @@ struct ab3100 {
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

