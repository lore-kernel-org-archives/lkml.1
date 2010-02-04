Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0BDI03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:26:29 -0500
Received: from smtp.nokia.com ([192.100.105.134]:40161 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab0BDIYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:24:53 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: pavel@ucw.cz, daniel@caiaq.de, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 5/6] lis3: Add skeletons for interrupt handlers
Date: Thu,  4 Feb 2010 10:24:07 +0200
Message-Id: <1265271848-26559-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 04 Feb 2010 08:24:27.0602 (UTC) FILETIME=[775F0B20:01CAA573]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original lis3 driver didn't provide interrupt handler(s) for
click or threshold event handling. This patch adds threaded handlers
for one or two interrupt lines for 8 bit device.
Actual content for interrupt handling is provided in the
separate patch.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   87 +++++++++++++++++++++++++++++++++------------
 include/linux/lis3lv02d.h |    1 +
 2 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 5948a3a..7de42f6 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -276,6 +276,9 @@ static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
 
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
+	if (!test_bit(0, &lis3_dev.misc_opened))
+		goto out;
+
 	/*
 	 * Be careful: on some HP laptops the bios force DD when on battery and
 	 * the lid is closed. This leads to interrupts as soon as a little move
@@ -285,45 +288,36 @@ static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 
 	wake_up_interruptible(&lis3_dev.misc_wait);
 	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
+out:
+	if (lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
+	    lis3_dev.idev->input->users)
+		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
 }
 
-static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
 {
-	int ret;
+	return IRQ_HANDLED;
+}
 
+static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
+{
+	return IRQ_HANDLED;
+}
+
+static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+{
 	if (test_and_set_bit(0, &lis3_dev.misc_opened))
 		return -EBUSY; /* already open */
 
 	lis3lv02d_add_users(&lis3_dev);
 	atomic_set(&lis3_dev.count, 0);
-
-	/*
-	 * The sensor can generate interrupts for free-fall and direction
-	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
-	 * the things simple and _fast_ we activate it only for free-fall, so
-	 * no need to read register (very slow with ACPI). For the same reason,
-	 * we forbid shared interrupts.
-	 *
-	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
-	 * io-apic is not configurable (and generates a warning) but I keep it
-	 * in case of support for other hardware.
-	 */
-	ret = request_irq(lis3_dev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
-			  DRIVER_NAME, &lis3_dev);
-
-	if (ret) {
-		clear_bit(0, &lis3_dev.misc_opened);
-		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", lis3_dev.irq);
-		return -EBUSY;
-	}
 	return 0;
 }
 
 static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 {
 	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
-	free_irq(lis3_dev.irq, &lis3_dev);
 	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
 	lis3lv02d_remove_users(&lis3_dev);
 	return 0;
@@ -463,6 +457,11 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
 void lis3lv02d_joystick_disable(void)
 {
+	if (lis3_dev.irq)
+		free_irq(lis3_dev.irq, &lis3_dev);
+	if (lis3_dev.pdata && lis3_dev.pdata->irq2)
+		free_irq(lis3_dev.pdata->irq2, &lis3_dev);
+
 	if (!lis3_dev.idev)
 		return;
 
@@ -592,6 +591,7 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 				struct lis3lv02d_platform_data *p)
 {
+	int err;
 	int ctrl2 = p->hipass_ctrl;
 
 	if (p->click_flags) {
@@ -622,6 +622,18 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 	}
 	/* Configure hipass filters */
 	dev->write(dev, CTRL_REG2, ctrl2);
+
+	if (p->irq2) {
+		err = request_threaded_irq(p->irq2,
+					NULL,
+					lis302dl_interrupt_thread2_8b,
+					IRQF_TRIGGER_RISING |
+					IRQF_ONESHOT,
+					DRIVER_NAME, &lis3_dev);
+		if (err < 0)
+			printk(KERN_ERR DRIVER_NAME
+				"No second IRQ. Limited functionality\n");
+	}
 }
 
 /*
@@ -630,6 +642,9 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
  */
 int lis3lv02d_init_device(struct lis3lv02d *dev)
 {
+	int err;
+	irq_handler_t thread_fn;
+
 	dev->whoami = lis3lv02d_read_8(dev, WHO_AM_I);
 
 	switch (dev->whoami) {
@@ -685,6 +700,32 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		goto out;
 	}
 
+	/*
+	 * The sensor can generate interrupts for free-fall and direction
+	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
+	 * the things simple and _fast_ we activate it only for free-fall, so
+	 * no need to read register (very slow with ACPI). For the same reason,
+	 * we forbid shared interrupts.
+	 *
+	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
+	 * io-apic is not configurable (and generates a warning) but I keep it
+	 * in case of support for other hardware.
+	 */
+	if (dev->whoami == WAI_8B)
+		thread_fn = lis302dl_interrupt_thread1_8b;
+	else
+		thread_fn = NULL;
+
+	err = request_threaded_irq(dev->irq, lis302dl_interrupt,
+				thread_fn,
+				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				DRIVER_NAME, &lis3_dev);
+
+	if (err < 0) {
+		printk(KERN_ERR DRIVER_NAME "Cannot get IRQ\n");
+		goto out;
+	}
+
 	if (misc_register(&lis3lv02d_misc_device))
 		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
 out:
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index d625199..fd289b1 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -67,6 +67,7 @@ struct lis3lv02d_platform_data {
 	/* Limits for selftest are specified in chip data sheet */
 	s16 st_min_limits[3]; /* min pass limit x, y, z */
 	s16 st_max_limits[3]; /* max pass limit x, y, z */
+	int irq2;
 };
 
 #endif /* __LIS3LV02D_H_ */
-- 
1.6.0.4

