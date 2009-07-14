Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZGNIZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZGNIZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZGNIZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:25:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:42302 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZGNIY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OBl1t8W/5gpG2/yla60LBPoi93r7o8curvyuzyTRx6FJhoHrg7DrXJI0VD1bC1+hk/
         /yA0R99QVL3x2+U4WNWW3wEmpR59wfQ3SSO4VY+ZIiUNx0DgtjBZB4TsDzVXyQTMQtTI
         A/3gmphjZAE6dIAQIfG9CbfApj3fx+DDZIsDE=
Date: Tue, 14 Jul 2009 01:24:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Kim Kyuwon'" <q1.kim@samsung.com>,
       "'Trilok Soni'" <soni.trilok@gmail.com>,
       "'Kim Kyuwon'" <chammoru@gmail.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
Message-ID: <20090714082452.GH2822@dtor-d630.eng.vmware.com>
References: <4A04E5EA.7000103@samsung.com> <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com> <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com> <20090511031208.GA15208@dtor-d630.eng.vmware.com> <5d5443650906191038o797e0c3eu8234a56ee247ea68@mail.gmail.com> <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com> <20090713093147.GJ10819@dtor-d630.eng.vmware.com> <4A5BF6F0.6020403@samsung.com> <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 14, 2009 at 08:28:05AM +0200, Marek Szyprowski wrote:
> Hello,
> 
> On Tuesday, July 14, 2009 5:10 AM, Kim Kyuwon wrote:
> > Dmitry Torokhov wrote:
> > > On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
> > >> I don't see this driver picked up yet in your -next branch. We should
> > >> target this driver to be mainlined in next merge window. This is very
> > >> important driver for some of the embedded systems, including palm pre
> > >> :)
> > > I was wondering if somebody could test the patch below and if it still
> > > works then I will apply to the next branch. Thanks!
> > >
> > 
> > Dear Marek,
> > 
> > Because I don't have the NCP board(which includes the max7359 keypad)
> > now, I can't test this patch. Marek, could you please test this patch?
> 
> I would like to, but I could not find the base version to which I can apply
> that patch. I've tried v2 version posted in '[PATCH] Input: add MAX7359 key
> switch controller driver, v2' mail from Sat 2009-05-09 04:10 with 2 patches
> posted in replies to that main, but the latest patch still fails to apply.
> 
> Could someone send me a complete patch, so I can do a test?
> 

Sending everything as attachments, maybe that will help...

-- 
Dmitry

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="melfas-mcs-5000-fixes.patch"

Input: mcs5000_ts - use threaded IRQs

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Threaded IRQs are exactly what this driver needs since it communicates
with the device over I2C bus, which requires sleeping.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/mcs5000_ts.c |  162 +++++++++++---------------------
 1 files changed, 57 insertions(+), 105 deletions(-)


diff --git a/drivers/input/touchscreen/mcs5000_ts.c b/drivers/input/touchscreen/mcs5000_ts.c
index d6c1a94..ff54ea9 100644
--- a/drivers/input/touchscreen/mcs5000_ts.c
+++ b/drivers/input/touchscreen/mcs5000_ts.c
@@ -20,7 +20,6 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/irq.h>
-#include <linux/workqueue.h>
 
 /* Registers */
 #define MCS5000_TS_STATUS		0x00
@@ -105,17 +104,12 @@ enum mcs5000_ts_read_offset {
 struct mcs5000_ts_data {
 	struct i2c_client *client;
 	struct input_dev *input_dev;
-	struct work_struct ts_event_work;
-	struct mcs5000_ts_platform_data *platform_data;
-
-	unsigned int irq;
-	atomic_t irq_disable;
+	const struct mcs5000_ts_platform_data *platform_data;
 };
 
-static struct i2c_driver mcs5000_ts_driver;
-
-static void mcs5000_ts_input_read(struct mcs5000_ts_data *data)
+static irqreturn_t mcs5000_ts_interrupt(int irq, void *dev_id)
 {
+	struct mcs5000_ts_data *data = dev_id;
 	struct i2c_client *client = data->client;
 	u8 buffer[READ_BLOCK_SIZE];
 	int err;
@@ -126,7 +120,7 @@ static void mcs5000_ts_input_read(struct mcs5000_ts_data *data)
 			READ_BLOCK_SIZE, buffer);
 	if (err < 0) {
 		dev_err(&client->dev, "%s, err[%d]\n", __func__, err);
-		return;
+		goto out;
 	}
 
 	switch (buffer[READ_INPUT_INFO]) {
@@ -134,6 +128,7 @@ static void mcs5000_ts_input_read(struct mcs5000_ts_data *data)
 		input_report_key(data->input_dev, BTN_TOUCH, 0);
 		input_sync(data->input_dev);
 		break;
+
 	case INPUT_TYPE_SINGLE:
 		x = (buffer[READ_X_POS_UPPER] << 8) | buffer[READ_X_POS_LOWER];
 		y = (buffer[READ_Y_POS_UPPER] << 8) | buffer[READ_Y_POS_LOWER];
@@ -143,98 +138,40 @@ static void mcs5000_ts_input_read(struct mcs5000_ts_data *data)
 		input_report_abs(data->input_dev, ABS_Y, y);
 		input_sync(data->input_dev);
 		break;
+
 	case INPUT_TYPE_DUAL:
 		/* TODO */
 		break;
+
 	case INPUT_TYPE_PALM:
 		/* TODO */
 		break;
+
 	case INPUT_TYPE_PROXIMITY:
 		/* TODO */
 		break;
+
 	default:
 		dev_err(&client->dev, "Unknown ts input type %d\n",
 				buffer[READ_INPUT_INFO]);
 		break;
 	}
-}
-
-static void mcs5000_ts_irq_worker(struct work_struct *work)
-{
-	struct mcs5000_ts_data *data = container_of(work,
-			struct mcs5000_ts_data, ts_event_work);
-
-	mcs5000_ts_input_read(data);
-
-	atomic_dec(&data->irq_disable);
-	enable_irq(data->irq);
-}
-
-static irqreturn_t mcs5000_ts_interrupt(int irq, void *dev_id)
-{
-	struct mcs5000_ts_data *data = dev_id;
-
-	if (!work_pending(&data->ts_event_work)) {
-		disable_irq_nosync(data->irq);
-		atomic_inc(&data->irq_disable);
-		schedule_work(&data->ts_event_work);
-	}
 
+ out:
+	enable_irq(irq);
 	return IRQ_HANDLED;
 }
 
-static int mcs5000_ts_input_init(struct mcs5000_ts_data *data)
+static irqreturn_t mcs5000_ts_hardirq(int irq, void *dev_id)
 {
-	struct input_dev *input_dev;
-	int ret = 0;
-
-	INIT_WORK(&data->ts_event_work, mcs5000_ts_irq_worker);
-
-	data->input_dev = input_allocate_device();
-	if (data->input_dev == NULL) {
-		ret = -ENOMEM;
-		goto err_input;
-	}
-
-	input_dev = data->input_dev;
-	input_dev->name = "MELPAS MCS-5000 Touchscreen";
-	input_dev->id.bustype = BUS_I2C;
-	input_dev->dev.parent = &data->client->dev;
-	set_bit(EV_ABS, input_dev->evbit);
-	set_bit(ABS_X, input_dev->absbit);
-	set_bit(ABS_Y, input_dev->absbit);
-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(BTN_TOUCH, input_dev->keybit);
-	input_set_abs_params(input_dev, ABS_X, 0, MCS5000_MAX_XC, 0, 0);
-	input_set_abs_params(input_dev, ABS_Y, 0, MCS5000_MAX_YC, 0, 0);
-
-	ret = input_register_device(data->input_dev);
-	if (ret < 0)
-		goto err_register;
-
-	ret = request_irq(data->irq, mcs5000_ts_interrupt, IRQF_TRIGGER_LOW,
-			"mcs5000_ts_input", data);
-	if (ret < 0) {
-		dev_err(&data->client->dev, "Failed to register interrupt\n");
-		goto err_irq;
-	}
-
-	input_set_drvdata(input_dev, data);
-
-	return 0;
-err_irq:
-	input_unregister_device(data->input_dev);
-	data->input_dev = NULL;
-err_register:
-	input_free_device(data->input_dev);
-err_input:
-	return ret;
+	disable_irq_nosync(irq);
+	return IRQ_WAKE_THREAD;
 }
 
 static void mcs5000_ts_phys_init(struct mcs5000_ts_data *data)
 {
+	const struct mcs5000_ts_platform_data *platform_data = data->platform_data;
 	struct i2c_client *client = data->client;
-	struct mcs5000_ts_platform_data *platform_data = data->platform_data;
 
 	/* Touch reset & sleep mode */
 	i2c_smbus_write_byte_data(client, MCS5000_TS_OP_MODE,
@@ -259,53 +196,69 @@ static int __devinit mcs5000_ts_probe(struct i2c_client *client,
 		const struct i2c_device_id *idp)
 {
 	struct mcs5000_ts_data *data;
-	int ret;
+	struct input_dev *input_dev;
+	int error;
+
+	if (!client->dev.platform_data)
+		return -EINVAL;
 
 	data = kzalloc(sizeof(struct mcs5000_ts_data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&client->dev, "Failed to allocate driver data\n");
-		ret = -ENOMEM;
-		goto exit;
+	input_dev = input_allocate_device();
+	if (!data || !input_dev) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		error = -ENOMEM;
+		goto err_free_mem;
 	}
 
 	data->client = client;
+	data->input_dev = input_dev;
 	data->platform_data = client->dev.platform_data;
-	data->irq = client->irq;
-	atomic_set(&data->irq_disable, 0);
 
-	i2c_set_clientdata(client, data);
+	input_dev->name = "MELPAS MCS-5000 Touchscreen";
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &data->client->dev;
+
+	__set_bit(EV_ABS, input_dev->evbit);
+	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(BTN_TOUCH, input_dev->keybit);
+	input_set_abs_params(input_dev, ABS_X, 0, MCS5000_MAX_XC, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, 0, MCS5000_MAX_YC, 0, 0);
 
-	if (data->platform_data && data->platform_data->set_pin)
+	input_set_drvdata(input_dev, data);
+
+	if (data->platform_data->set_pin)
 		data->platform_data->set_pin();
 
-	ret = mcs5000_ts_input_init(data);
-	if (ret)
-		goto exit_free;
+	error = request_threaded_irq(client->irq,
+				mcs5000_ts_hardirq, mcs5000_ts_interrupt,
+				IRQF_TRIGGER_LOW, "mcs5000_ts_input", data);
+	if (error < 0) {
+		dev_err(&data->client->dev, "Failed to register interrupt\n");
+		goto err_free_mem;
+	}
+
+	error = input_register_device(data->input_dev);
+	if (error < 0)
+		goto err_free_irq;
 
 	mcs5000_ts_phys_init(data);
+	i2c_set_clientdata(client, data);
 
 	return 0;
 
-exit_free:
+err_free_irq:
+	free_irq(client->irq, data);
+err_free_mem:
+	input_free_device(input_dev);
 	kfree(data);
-	i2c_set_clientdata(client, NULL);
-exit:
-	return ret;
+	return error;
 }
 
 static int __devexit mcs5000_ts_remove(struct i2c_client *client)
 {
 	struct mcs5000_ts_data *data = i2c_get_clientdata(client);
 
-	free_irq(data->irq, data);
-	cancel_work_sync(&data->ts_event_work);
-
-	/*
-	 * If work indeed has been cancelled, disable_irq() will have been left
-	 * unbalanced from mcs5000_ts_interrupt().
-	 */
-	while (atomic_dec_return(&data->irq_disable) >= 0)
-		enable_irq(data->irq);
+	free_irq(client->irq, data);
 
 	input_unregister_device(data->input_dev);
 	kfree(data);
@@ -326,9 +279,8 @@ static int mcs5000_ts_suspend(struct i2c_client *client, pm_message_t mesg)
 
 static int mcs5000_ts_resume(struct i2c_client *client)
 {
-	struct mcs5000_ts_data *data;
+	struct mcs5000_ts_data *data = i2c_get_clientdata(client);
 
-	data = i2c_get_clientdata(client);
 	mcs5000_ts_phys_init(data);
 
 	return 0;

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="input-add-touchscreen-driver-for-melfas-mcs-5000-controller.patch"

Input: add touchscreen driver for MELFAS MCS-5000 controller

From: Joonyoung Shim <jy0922.shim@samsung.com>

The MELPAS MCS-5000 is the touchscreen controller. The overview of this
controller can see at the following website:

http://www.melfas.com/product/product01.asp?k_r=eng_

This driver is tested on s3c6410 NCP board and supports only the i2c
interface.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/Kconfig      |   12 +
 drivers/input/touchscreen/Makefile     |    1 
 drivers/input/touchscreen/mcs5000_ts.c |  374 ++++++++++++++++++++++++++++++++
 include/linux/i2c/mcs5000_ts.h         |   11 +
 4 files changed, 398 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/mcs5000_ts.c
 create mode 100644 include/linux/i2c/mcs5000_ts.h


diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 1c05b32..350e2cc 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -505,4 +505,16 @@ config TOUCHSCREEN_W90X900
 	  To compile this driver as a module, choose M here: the
 	  module will be called w90p910_ts.
 
+config TOUCHSCREEN_MCS5000
+	tristate "MELFAS MCS-5000 touchscreen"
+	depends on I2C
+	help
+	  Say Y here if you have the MELFAS MCS-5000 touchscreen controller
+	  chip in your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mcs5000_ts.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 3e1c5e0..91e820f 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -40,3 +40,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ATMEL)	+= atmel-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
+obj-$(CONFIG_TOUCHSCREEN_MCS5000)	+= mcs5000_ts.o
diff --git a/drivers/input/touchscreen/mcs5000_ts.c b/drivers/input/touchscreen/mcs5000_ts.c
new file mode 100644
index 0000000..d6c1a94
--- /dev/null
+++ b/drivers/input/touchscreen/mcs5000_ts.c
@@ -0,0 +1,374 @@
+/*
+ * mcs5000_ts.c - Touch screen driver for MELFAS MCS-5000 controller
+ *
+ * Copyright (C) 2009 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * Based on wm97xx-core.c
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/i2c/mcs5000_ts.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/irq.h>
+#include <linux/workqueue.h>
+
+/* Registers */
+#define MCS5000_TS_STATUS		0x00
+#define STATUS_OFFSET			0
+#define STATUS_NO			(0 << STATUS_OFFSET)
+#define STATUS_INIT			(1 << STATUS_OFFSET)
+#define STATUS_SENSING			(2 << STATUS_OFFSET)
+#define STATUS_COORD			(3 << STATUS_OFFSET)
+#define STATUS_GESTURE			(4 << STATUS_OFFSET)
+#define ERROR_OFFSET			4
+#define ERROR_NO			(0 << ERROR_OFFSET)
+#define ERROR_POWER_ON_RESET		(1 << ERROR_OFFSET)
+#define ERROR_INT_RESET			(2 << ERROR_OFFSET)
+#define ERROR_EXT_RESET			(3 << ERROR_OFFSET)
+#define ERROR_INVALID_REG_ADDRESS	(8 << ERROR_OFFSET)
+#define ERROR_INVALID_REG_VALUE		(9 << ERROR_OFFSET)
+
+#define MCS5000_TS_OP_MODE		0x01
+#define RESET_OFFSET			0
+#define RESET_NO			(0 << RESET_OFFSET)
+#define RESET_EXT_SOFT			(1 << RESET_OFFSET)
+#define OP_MODE_OFFSET			1
+#define OP_MODE_SLEEP			(0 << OP_MODE_OFFSET)
+#define OP_MODE_ACTIVE			(1 << OP_MODE_OFFSET)
+#define GESTURE_OFFSET			4
+#define GESTURE_DISABLE			(0 << GESTURE_OFFSET)
+#define GESTURE_ENABLE			(1 << GESTURE_OFFSET)
+#define PROXIMITY_OFFSET		5
+#define PROXIMITY_DISABLE		(0 << PROXIMITY_OFFSET)
+#define PROXIMITY_ENABLE		(1 << PROXIMITY_OFFSET)
+#define SCAN_MODE_OFFSET		6
+#define SCAN_MODE_INTERRUPT		(0 << SCAN_MODE_OFFSET)
+#define SCAN_MODE_POLLING		(1 << SCAN_MODE_OFFSET)
+#define REPORT_RATE_OFFSET		7
+#define REPORT_RATE_40			(0 << REPORT_RATE_OFFSET)
+#define REPORT_RATE_80			(1 << REPORT_RATE_OFFSET)
+
+#define MCS5000_TS_SENS_CTL		0x02
+#define MCS5000_TS_FILTER_CTL		0x03
+#define PRI_FILTER_OFFSET		0
+#define SEC_FILTER_OFFSET		4
+
+#define MCS5000_TS_X_SIZE_UPPER		0x08
+#define MCS5000_TS_X_SIZE_LOWER		0x09
+#define MCS5000_TS_Y_SIZE_UPPER		0x0A
+#define MCS5000_TS_Y_SIZE_LOWER		0x0B
+
+#define MCS5000_TS_INPUT_INFO		0x10
+#define INPUT_TYPE_OFFSET		0
+#define INPUT_TYPE_NONTOUCH		(0 << INPUT_TYPE_OFFSET)
+#define INPUT_TYPE_SINGLE		(1 << INPUT_TYPE_OFFSET)
+#define INPUT_TYPE_DUAL			(2 << INPUT_TYPE_OFFSET)
+#define INPUT_TYPE_PALM			(3 << INPUT_TYPE_OFFSET)
+#define INPUT_TYPE_PROXIMITY		(7 << INPUT_TYPE_OFFSET)
+#define GESTURE_CODE_OFFSET		3
+#define GESTURE_CODE_NO			(0 << GESTURE_CODE_OFFSET)
+
+#define MCS5000_TS_X_POS_UPPER		0x11
+#define MCS5000_TS_X_POS_LOWER		0x12
+#define MCS5000_TS_Y_POS_UPPER		0x13
+#define MCS5000_TS_Y_POS_LOWER		0x14
+#define MCS5000_TS_Z_POS		0x15
+#define MCS5000_TS_WIDTH		0x16
+#define MCS5000_TS_GESTURE_VAL		0x17
+#define MCS5000_TS_MODULE_REV		0x20
+#define MCS5000_TS_FIRMWARE_VER		0x21
+
+/* Touchscreen absolute values */
+#define MCS5000_MAX_XC			0x3ff
+#define MCS5000_MAX_YC			0x3ff
+
+enum mcs5000_ts_read_offset {
+	READ_INPUT_INFO,
+	READ_X_POS_UPPER,
+	READ_X_POS_LOWER,
+	READ_Y_POS_UPPER,
+	READ_Y_POS_LOWER,
+	READ_BLOCK_SIZE,
+};
+
+/* Each client has this additional data */
+struct mcs5000_ts_data {
+	struct i2c_client *client;
+	struct input_dev *input_dev;
+	struct work_struct ts_event_work;
+	struct mcs5000_ts_platform_data *platform_data;
+
+	unsigned int irq;
+	atomic_t irq_disable;
+};
+
+static struct i2c_driver mcs5000_ts_driver;
+
+static void mcs5000_ts_input_read(struct mcs5000_ts_data *data)
+{
+	struct i2c_client *client = data->client;
+	u8 buffer[READ_BLOCK_SIZE];
+	int err;
+	int x;
+	int y;
+
+	err = i2c_smbus_read_i2c_block_data(client, MCS5000_TS_INPUT_INFO,
+			READ_BLOCK_SIZE, buffer);
+	if (err < 0) {
+		dev_err(&client->dev, "%s, err[%d]\n", __func__, err);
+		return;
+	}
+
+	switch (buffer[READ_INPUT_INFO]) {
+	case INPUT_TYPE_NONTOUCH:
+		input_report_key(data->input_dev, BTN_TOUCH, 0);
+		input_sync(data->input_dev);
+		break;
+	case INPUT_TYPE_SINGLE:
+		x = (buffer[READ_X_POS_UPPER] << 8) | buffer[READ_X_POS_LOWER];
+		y = (buffer[READ_Y_POS_UPPER] << 8) | buffer[READ_Y_POS_LOWER];
+
+		input_report_key(data->input_dev, BTN_TOUCH, 1);
+		input_report_abs(data->input_dev, ABS_X, x);
+		input_report_abs(data->input_dev, ABS_Y, y);
+		input_sync(data->input_dev);
+		break;
+	case INPUT_TYPE_DUAL:
+		/* TODO */
+		break;
+	case INPUT_TYPE_PALM:
+		/* TODO */
+		break;
+	case INPUT_TYPE_PROXIMITY:
+		/* TODO */
+		break;
+	default:
+		dev_err(&client->dev, "Unknown ts input type %d\n",
+				buffer[READ_INPUT_INFO]);
+		break;
+	}
+}
+
+static void mcs5000_ts_irq_worker(struct work_struct *work)
+{
+	struct mcs5000_ts_data *data = container_of(work,
+			struct mcs5000_ts_data, ts_event_work);
+
+	mcs5000_ts_input_read(data);
+
+	atomic_dec(&data->irq_disable);
+	enable_irq(data->irq);
+}
+
+static irqreturn_t mcs5000_ts_interrupt(int irq, void *dev_id)
+{
+	struct mcs5000_ts_data *data = dev_id;
+
+	if (!work_pending(&data->ts_event_work)) {
+		disable_irq_nosync(data->irq);
+		atomic_inc(&data->irq_disable);
+		schedule_work(&data->ts_event_work);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int mcs5000_ts_input_init(struct mcs5000_ts_data *data)
+{
+	struct input_dev *input_dev;
+	int ret = 0;
+
+	INIT_WORK(&data->ts_event_work, mcs5000_ts_irq_worker);
+
+	data->input_dev = input_allocate_device();
+	if (data->input_dev == NULL) {
+		ret = -ENOMEM;
+		goto err_input;
+	}
+
+	input_dev = data->input_dev;
+	input_dev->name = "MELPAS MCS-5000 Touchscreen";
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &data->client->dev;
+	set_bit(EV_ABS, input_dev->evbit);
+	set_bit(ABS_X, input_dev->absbit);
+	set_bit(ABS_Y, input_dev->absbit);
+	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(BTN_TOUCH, input_dev->keybit);
+	input_set_abs_params(input_dev, ABS_X, 0, MCS5000_MAX_XC, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, 0, MCS5000_MAX_YC, 0, 0);
+
+	ret = input_register_device(data->input_dev);
+	if (ret < 0)
+		goto err_register;
+
+	ret = request_irq(data->irq, mcs5000_ts_interrupt, IRQF_TRIGGER_LOW,
+			"mcs5000_ts_input", data);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Failed to register interrupt\n");
+		goto err_irq;
+	}
+
+	input_set_drvdata(input_dev, data);
+
+	return 0;
+err_irq:
+	input_unregister_device(data->input_dev);
+	data->input_dev = NULL;
+err_register:
+	input_free_device(data->input_dev);
+err_input:
+	return ret;
+}
+
+static void mcs5000_ts_phys_init(struct mcs5000_ts_data *data)
+{
+	struct i2c_client *client = data->client;
+	struct mcs5000_ts_platform_data *platform_data = data->platform_data;
+
+	/* Touch reset & sleep mode */
+	i2c_smbus_write_byte_data(client, MCS5000_TS_OP_MODE,
+			RESET_EXT_SOFT | OP_MODE_SLEEP);
+
+	/* Touch size */
+	i2c_smbus_write_byte_data(client, MCS5000_TS_X_SIZE_UPPER,
+			platform_data->x_size >> 8);
+	i2c_smbus_write_byte_data(client, MCS5000_TS_X_SIZE_LOWER,
+			platform_data->x_size & 0xff);
+	i2c_smbus_write_byte_data(client, MCS5000_TS_Y_SIZE_UPPER,
+			platform_data->y_size >> 8);
+	i2c_smbus_write_byte_data(client, MCS5000_TS_Y_SIZE_LOWER,
+			platform_data->y_size & 0xff);
+
+	/* Touch active mode & 80 report rate */
+	i2c_smbus_write_byte_data(data->client, MCS5000_TS_OP_MODE,
+			OP_MODE_ACTIVE | REPORT_RATE_80);
+}
+
+static int __devinit mcs5000_ts_probe(struct i2c_client *client,
+		const struct i2c_device_id *idp)
+{
+	struct mcs5000_ts_data *data;
+	int ret;
+
+	data = kzalloc(sizeof(struct mcs5000_ts_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&client->dev, "Failed to allocate driver data\n");
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	data->client = client;
+	data->platform_data = client->dev.platform_data;
+	data->irq = client->irq;
+	atomic_set(&data->irq_disable, 0);
+
+	i2c_set_clientdata(client, data);
+
+	if (data->platform_data && data->platform_data->set_pin)
+		data->platform_data->set_pin();
+
+	ret = mcs5000_ts_input_init(data);
+	if (ret)
+		goto exit_free;
+
+	mcs5000_ts_phys_init(data);
+
+	return 0;
+
+exit_free:
+	kfree(data);
+	i2c_set_clientdata(client, NULL);
+exit:
+	return ret;
+}
+
+static int __devexit mcs5000_ts_remove(struct i2c_client *client)
+{
+	struct mcs5000_ts_data *data = i2c_get_clientdata(client);
+
+	free_irq(data->irq, data);
+	cancel_work_sync(&data->ts_event_work);
+
+	/*
+	 * If work indeed has been cancelled, disable_irq() will have been left
+	 * unbalanced from mcs5000_ts_interrupt().
+	 */
+	while (atomic_dec_return(&data->irq_disable) >= 0)
+		enable_irq(data->irq);
+
+	input_unregister_device(data->input_dev);
+	kfree(data);
+
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int mcs5000_ts_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	/* Touch sleep mode */
+	i2c_smbus_write_byte_data(client, MCS5000_TS_OP_MODE, OP_MODE_SLEEP);
+
+	return 0;
+}
+
+static int mcs5000_ts_resume(struct i2c_client *client)
+{
+	struct mcs5000_ts_data *data;
+
+	data = i2c_get_clientdata(client);
+	mcs5000_ts_phys_init(data);
+
+	return 0;
+}
+#else
+#define mcs5000_ts_suspend	NULL
+#define mcs5000_ts_resume	NULL
+#endif
+
+static const struct i2c_device_id mcs5000_ts_id[] = {
+	{ "mcs5000_ts", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, mcs5000_ts_id);
+
+static struct i2c_driver mcs5000_ts_driver = {
+	.driver = {
+		.name = "mcs5000_ts",
+	},
+	.probe		= mcs5000_ts_probe,
+	.remove		= __devexit_p(mcs5000_ts_remove),
+	.suspend	= mcs5000_ts_suspend,
+	.resume		= mcs5000_ts_resume,
+	.id_table	= mcs5000_ts_id,
+};
+
+static int __init mcs5000_ts_init(void)
+{
+	return i2c_add_driver(&mcs5000_ts_driver);
+}
+
+static void __exit mcs5000_ts_exit(void)
+{
+	i2c_del_driver(&mcs5000_ts_driver);
+}
+
+module_init(mcs5000_ts_init);
+module_exit(mcs5000_ts_exit);
+
+/* Module information */
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_DESCRIPTION("Touch screen driver for MELFAS MCS-5000 controller");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c/mcs5000_ts.h b/include/linux/i2c/mcs5000_ts.h
new file mode 100644
index 0000000..69d92b6
--- /dev/null
+++ b/include/linux/i2c/mcs5000_ts.h
@@ -0,0 +1,11 @@
+#ifndef __LINUX_MCS5000_TS_H
+#define __LINUX_MCS5000_TS_H
+
+/* platform data for the MELFAS MCS5000 touchscreen driver */
+struct mcs5000_ts_platform_data {
+	void (*set_pin)(void);
+	int x_size;
+	int y_size;
+};
+
+#endif	/* __LINUX_MCS5000_TS_H */

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="input-add-max7359-key-switch-controller-driver-v2.patch"

Input: add MAX7359 key switch controller driver, v2

From: Kim Kyuwon <q1.kim@samsung.com>

The Maxim MAX7359 is a I2C interfaced key switch controller which provides
microprocessors with management of up to 64 key switches.
This patch adds support for the MAX7359 key switch controller.

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
Reviewed-by: Trilok Soni <soni.trilok@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/Kconfig          |   11 +
 drivers/input/keyboard/Makefile         |    1 
 drivers/input/keyboard/max7359_keypad.c |  348 +++++++++++++++++++++++++++++++
 3 files changed, 360 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/max7359_keypad.c


diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index a6b989a..667dfd4 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -250,6 +250,17 @@ config KEYBOARD_MAPLE
 	  To compile this driver as a module, choose M here: the
 	  module will be called maple_keyb.
 
+config KEYBOARD_MAX7359
+	tristate "Maxim MAX7359 Key Switch Controller"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Maxim MAX7359 Key
+	  Switch Controller chip. This providers microprocessors with
+	  management of up to 64 key switches
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called max7359_keypad.
+
 config KEYBOARD_NEWTON
 	tristate "Newton keyboard"
 	select SERIO
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index b5b5eae..1ace21a 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_KEYBOARD_LM8323)		+= lm8323.o
 obj-$(CONFIG_KEYBOARD_LOCOMO)		+= locomokbd.o
 obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_MATRIX)		+= matrix_keypad.o
+obj-$(CONFIG_KEYBOARD_MAX7359)		+= max7359_keypad.o
 obj-$(CONFIG_KEYBOARD_NEWTON)		+= newtonkbd.o
 obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keypad.o
diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
new file mode 100644
index 0000000..e359db3
--- /dev/null
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -0,0 +1,348 @@
+/*
+ * max7359_keypad.c - MAX7359 Key Switch Controller Driver
+ *
+ * Copyright (C) 2009 Samsung Electronics
+ * Kim Kyuwon <q1.kim@samsung.com>
+ *
+ * Based on pxa27x_keypad.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Datasheet: http://www.maxim-ic.com/quick_view2.cfm/qv_pk/5456
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
+
+#define MAX7359_MAX_KEY_ROWS	8
+#define MAX7359_MAX_KEY_COLS	8
+#define MAX7359_MAX_KEY_NUM	(MAX7359_MAX_KEY_ROWS * MAX7359_MAX_KEY_COLS)
+
+/*
+ * MAX7359 registers
+ */
+#define MAX7359_REG_KEYFIFO	0x00
+#define MAX7359_REG_CONFIG	0x01
+#define MAX7359_REG_DEBOUNCE	0x02
+#define MAX7359_REG_INTERRUPT	0x03
+#define MAX7359_REG_PORTS	0x04
+#define MAX7359_REG_KEYREP	0x05
+#define MAX7359_REG_SLEEP	0x06
+
+/*
+ * Configuration register bits
+ */
+#define MAX7359_CFG_SLEEP	(1 << 7)
+#define MAX7359_CFG_INTERRUPT	(1 << 5)
+#define MAX7359_CFG_KEY_RELEASE	(1 << 3)
+#define MAX7359_CFG_WAKEUP	(1 << 1)
+#define MAX7359_CFG_TIMEOUT	(1 << 0)
+
+/*
+ * Autosleep register values (ms)
+ */
+#define MAX7359_AUTOSLEEP_8192	0x01
+#define MAX7359_AUTOSLEEP_4096	0x02
+#define MAX7359_AUTOSLEEP_2048	0x03
+#define MAX7359_AUTOSLEEP_1024	0x04
+#define MAX7359_AUTOSLEEP_512	0x05
+#define MAX7359_AUTOSLEEP_256	0x06
+
+struct max7359_keypad {
+	/* matrix key code map */
+	unsigned short keycodes[MAX7359_MAX_KEY_NUM];
+
+	struct work_struct work;
+
+	struct input_dev *input_dev;
+	struct i2c_client *client;
+
+	u32 irq;
+};
+
+static int max7359_write_reg(struct i2c_client *client, u8 reg, u8 val)
+{
+	int ret = i2c_smbus_write_byte_data(client, reg, val);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: reg 0x%x, val 0x%x, err %d\n",
+			__func__, reg, val, ret);
+	return ret;
+}
+
+static int max7359_read_reg(struct i2c_client *client, int reg)
+{
+	int ret = i2c_smbus_read_byte_data(client, reg);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: reg 0x%x, err %d\n",
+			__func__, reg, ret);
+	return ret;
+}
+
+static void max7359_build_keycode(struct max7359_keypad *keypad,
+				const struct matrix_keymap_data *keymap_data)
+{
+	struct input_dev *input_dev = keypad->input_dev;
+	int i;
+
+	for (i = 0; i < keymap_data->keymap_size; i++) {
+		unsigned int key = keymap_data->keymap[i];
+		unsigned int row = KEY_ROW(key);
+		unsigned int col = KEY_COL(key);
+		unsigned short code = KEY_VAL(key);
+
+		keypad->keycodes[(row << 3) + col] = code;
+		__set_bit(code, input_dev->keybit);
+	}
+	__clear_bit(KEY_RESERVED, input_dev->keybit);
+}
+
+static void max7359_worker(struct work_struct *work)
+{
+	struct max7359_keypad *keypad =
+			container_of(work, struct max7359_keypad, work);
+	struct input_dev *input_dev = keypad->input_dev;
+	int val, row, col, release, code;
+
+	val = max7359_read_reg(keypad->client, MAX7359_REG_KEYFIFO);
+	row = val & 0x7;
+	col = (val >> 3) & 0x7;
+	release = val & 0x40;
+	code = (row << 3) + col;
+
+	input_event(input_dev, EV_MSC, MSC_SCAN, code);
+	input_report_key(input_dev, keypad->keycodes[code], !release);
+	input_sync(input_dev);
+
+	enable_irq(keypad->irq);
+
+	dev_dbg(&keypad->client->dev, "key[%d:%d] %s\n", row, col,
+					(release ? "release" : "press"));
+}
+
+static irqreturn_t max7359_interrupt(int irq, void *dev_id)
+{
+	struct max7359_keypad *keypad = dev_id;
+
+	if (!work_pending(&keypad->work)) {
+		disable_irq_nosync(keypad->irq);
+		schedule_work(&keypad->work);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Let MAX7359 fall into a deep sleep:
+ * If no keys are pressed, enter sleep mode for 8192 ms. And if any
+ * key is pressed, the MAX7359 returns to normal operating mode.
+ */
+static inline void max7359_fall_deepsleep(struct i2c_client *client)
+{
+	max7359_write_reg(client, MAX7359_REG_SLEEP, MAX7359_AUTOSLEEP_8192);
+}
+
+/*
+ * Let MAX7359 take a catnap:
+ * Autosleep just for 256 ms.
+ */
+static inline void max7359_take_catnap(struct i2c_client *client)
+{
+	max7359_write_reg(client, MAX7359_REG_SLEEP, MAX7359_AUTOSLEEP_256);
+}
+
+static int max7359_open(struct input_dev *dev)
+{
+	struct max7359_keypad *keypad = input_get_drvdata(dev);
+
+	max7359_take_catnap(keypad->client);
+
+	return 0;
+}
+
+static void max7359_close(struct input_dev *dev)
+{
+	struct max7359_keypad *keypad = input_get_drvdata(dev);
+
+	max7359_fall_deepsleep(keypad->client);
+}
+
+static void max7359_initialize(struct i2c_client *client)
+{
+	max7359_write_reg(client, MAX7359_REG_CONFIG,
+		MAX7359_CFG_INTERRUPT | /* Irq clears after host read */
+		MAX7359_CFG_KEY_RELEASE | /* Key release enable */
+		MAX7359_CFG_WAKEUP); /* Key press wakeup enable */
+
+	/* Full key-scan functionality */
+	max7359_write_reg(client, MAX7359_REG_DEBOUNCE, 0x1F);
+
+	/* nINT asserts every debounce cycles */
+	max7359_write_reg(client, MAX7359_REG_INTERRUPT, 0x01);
+
+	max7359_fall_deepsleep(client);
+}
+
+static int __devinit max7359_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	const struct matrix_keymap_data *keymap_data = client->dev.platform_data;
+	struct max7359_keypad *keypad;
+	struct input_dev *input_dev;
+	int ret;
+	int error;
+
+	if (!client->irq) {
+		dev_err(&client->dev, "The irq number should not be zero\n");
+		return -EINVAL;
+	}
+
+	/* Detect MAX7359: The initial Keys FIFO value is '0x3F' */
+	ret = max7359_read_reg(client, MAX7359_REG_KEYFIFO);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to detect device\n");
+		return -ENODEV;
+	}
+
+	dev_dbg(&client->dev, "keys FIFO is 0x%02x\n", ret);
+
+	keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!keypad || !input_dev) {
+		dev_err(&client->dev, "failed to allocate memory\n");
+		error = -ENOMEM;
+		goto failed_free_mem;
+	}
+
+	keypad->client = client;
+	keypad->input_dev = input_dev;
+	keypad->irq = client->irq;
+	INIT_WORK(&keypad->work, max7359_worker);
+
+	input_dev->name = client->name;
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->open = max7359_open;
+	input_dev->close = max7359_close;
+	input_dev->dev.parent = &client->dev;
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
+	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
+	input_dev->keycode = keypad->keycodes;
+
+	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
+	input_set_drvdata(input_dev, keypad);
+
+	max7359_build_keycode(keypad, keymap_data);
+
+	error = request_irq(keypad->irq, max7359_interrupt,
+			    IRQF_TRIGGER_LOW, client->name, keypad);
+	if (error) {
+		dev_err(&client->dev, "failed to register interrupt\n");
+		goto failed_free_mem;
+	}
+
+	/* Register the input device */
+	error = input_register_device(input_dev);
+	if (error) {
+		dev_err(&client->dev, "failed to register input device\n");
+		goto failed_free_irq;
+	}
+
+	/* Initialize MAX7359 */
+	max7359_initialize(client);
+
+	i2c_set_clientdata(client, keypad);
+	device_init_wakeup(&client->dev, 1);
+
+	return 0;
+
+failed_free_irq:
+	free_irq(keypad->irq, keypad);
+failed_free_mem:
+	input_free_device(input_dev);
+	kfree(keypad);
+	return error;
+}
+
+static int __devexit max7359_remove(struct i2c_client *client)
+{
+	struct max7359_keypad *keypad = i2c_get_clientdata(client);
+
+	cancel_work_sync(&keypad->work);
+	input_unregister_device(keypad->input_dev);
+	free_irq(keypad->irq, keypad);
+	i2c_set_clientdata(client, NULL);
+	kfree(keypad);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int max7359_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct max7359_keypad *keypad = i2c_get_clientdata(client);
+
+	max7359_fall_deepsleep(client);
+
+	if (device_may_wakeup(&client->dev))
+		enable_irq_wake(keypad->irq);
+
+	return 0;
+}
+
+static int max7359_resume(struct i2c_client *client)
+{
+	struct max7359_keypad *keypad = i2c_get_clientdata(client);
+
+	if (device_may_wakeup(&client->dev))
+		disable_irq_wake(keypad->irq);
+
+	/* Restore the default setting */
+	max7359_take_catnap(client);
+
+	return 0;
+}
+#else
+#define max7359_suspend	NULL
+#define max7359_resume	NULL
+#endif
+
+static const struct i2c_device_id max7359_ids[] = {
+	{ "max7359", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max7359_ids);
+
+static struct i2c_driver max7359_i2c_driver = {
+	.driver = {
+		.name = "max7359",
+	},
+	.probe		= max7359_probe,
+	.remove		= __devexit_p(max7359_remove),
+	.suspend	= max7359_suspend,
+	.resume		= max7359_resume,
+	.id_table	= max7359_ids,
+};
+
+static int __init max7359_init(void)
+{
+	return i2c_add_driver(&max7359_i2c_driver);
+}
+module_init(max7359_init);
+
+static void __exit max7359_exit(void)
+{
+	i2c_del_driver(&max7359_i2c_driver);
+}
+module_exit(max7359_exit);
+
+MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
+MODULE_DESCRIPTION("MAX7359 Key Switch Controller Driver");
+MODULE_LICENSE("GPL v2");

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="max7359-threaded-irq.patch"

Input: max7359 - use threaded IRQs

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Convert max7359 driver to use IRQ threading instead of using
workqueue.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/max7359_keypad.c |   51 +++++++++++--------------------
 1 files changed, 18 insertions(+), 33 deletions(-)


diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index e359db3..1bfd67c 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -57,12 +57,8 @@ struct max7359_keypad {
 	/* matrix key code map */
 	unsigned short keycodes[MAX7359_MAX_KEY_NUM];
 
-	struct work_struct work;
-
 	struct input_dev *input_dev;
 	struct i2c_client *client;
-
-	u32 irq;
 };
 
 static int max7359_write_reg(struct i2c_client *client, u8 reg, u8 val)
@@ -103,10 +99,10 @@ static void max7359_build_keycode(struct max7359_keypad *keypad,
 	__clear_bit(KEY_RESERVED, input_dev->keybit);
 }
 
-static void max7359_worker(struct work_struct *work)
+/* runs in an IRQ thread -- can (and will!) sleep */
+static irqreturn_t max7359_interrupt(int irq, void *dev_id)
 {
-	struct max7359_keypad *keypad =
-			container_of(work, struct max7359_keypad, work);
+	struct max7359_keypad *keypad = dev_id;
 	struct input_dev *input_dev = keypad->input_dev;
 	int val, row, col, release, code;
 
@@ -116,26 +112,21 @@ static void max7359_worker(struct work_struct *work)
 	release = val & 0x40;
 	code = (row << 3) + col;
 
+	dev_dbg(&keypad->client->dev,
+		"key[%d:%d] %s\n", row, col, release ? "release" : "press");
+
 	input_event(input_dev, EV_MSC, MSC_SCAN, code);
 	input_report_key(input_dev, keypad->keycodes[code], !release);
 	input_sync(input_dev);
 
-	enable_irq(keypad->irq);
-
-	dev_dbg(&keypad->client->dev, "key[%d:%d] %s\n", row, col,
-					(release ? "release" : "press"));
+	enable_irq(irq);
+	return IRQ_HANDLED;
 }
 
-static irqreturn_t max7359_interrupt(int irq, void *dev_id)
+static irqreturn_t max7359_hardirq(int irq, void *dev_id)
 {
-	struct max7359_keypad *keypad = dev_id;
-
-	if (!work_pending(&keypad->work)) {
-		disable_irq_nosync(keypad->irq);
-		schedule_work(&keypad->work);
-	}
-
-	return IRQ_HANDLED;
+	disable_irq_nosync(irq);
+	return IRQ_WAKE_THREAD;
 }
 
 /*
@@ -222,8 +213,6 @@ static int __devinit max7359_probe(struct i2c_client *client,
 
 	keypad->client = client;
 	keypad->input_dev = input_dev;
-	keypad->irq = client->irq;
-	INIT_WORK(&keypad->work, max7359_worker);
 
 	input_dev->name = client->name;
 	input_dev->id.bustype = BUS_I2C;
@@ -241,8 +230,9 @@ static int __devinit max7359_probe(struct i2c_client *client,
 
 	max7359_build_keycode(keypad, keymap_data);
 
-	error = request_irq(keypad->irq, max7359_interrupt,
-			    IRQF_TRIGGER_LOW, client->name, keypad);
+	error = request_threaded_irq(client->irq,
+				     max7359_hardirq, max7359_interrupt,
+				     IRQF_TRIGGER_LOW, client->name, keypad);
 	if (error) {
 		dev_err(&client->dev, "failed to register interrupt\n");
 		goto failed_free_mem;
@@ -264,7 +254,7 @@ static int __devinit max7359_probe(struct i2c_client *client,
 	return 0;
 
 failed_free_irq:
-	free_irq(keypad->irq, keypad);
+	free_irq(client->irq, keypad);
 failed_free_mem:
 	input_free_device(input_dev);
 	kfree(keypad);
@@ -275,9 +265,8 @@ static int __devexit max7359_remove(struct i2c_client *client)
 {
 	struct max7359_keypad *keypad = i2c_get_clientdata(client);
 
-	cancel_work_sync(&keypad->work);
+	free_irq(client->irq, keypad);
 	input_unregister_device(keypad->input_dev);
-	free_irq(keypad->irq, keypad);
 	i2c_set_clientdata(client, NULL);
 	kfree(keypad);
 
@@ -287,22 +276,18 @@ static int __devexit max7359_remove(struct i2c_client *client)
 #ifdef CONFIG_PM
 static int max7359_suspend(struct i2c_client *client, pm_message_t mesg)
 {
-	struct max7359_keypad *keypad = i2c_get_clientdata(client);
-
 	max7359_fall_deepsleep(client);
 
 	if (device_may_wakeup(&client->dev))
-		enable_irq_wake(keypad->irq);
+		enable_irq_wake(client->irq);
 
 	return 0;
 }
 
 static int max7359_resume(struct i2c_client *client)
 {
-	struct max7359_keypad *keypad = i2c_get_clientdata(client);
-
 	if (device_may_wakeup(&client->dev))
-		disable_irq_wake(keypad->irq);
+		disable_irq_wake(client->irq);
 
 	/* Restore the default setting */
 	max7359_take_catnap(client);

--17pEHd4RhPHOinZp--
