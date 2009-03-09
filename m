Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZCINae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZCINae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZCINaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:30:13 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:20000 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZCINaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:30:09 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 09:30:08 EDT
X-IronPort-AV: E=Sophos;i="4.38,329,1233550800"; 
   d="scan'208";a="67564951"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] Input/Touchscreen Driver: add support AD7877touchscreen driver (try #5)
Date: Mon, 9 Mar 2009 13:20:13 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D094ACB34@limkexm3.ad.analog.com>
In-Reply-To: <20090308063834.GA7102@dtor-d630.eng.vmware.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] Input/Touchscreen Driver: add support AD7877touchscreen driver (try #5)
Thread-Index: AcmfuJFs2Di9thLHSeigCOQL4EuFWQA/4Guw
References: <1224179768-14475-1-git-send-email-cooloney@kernel.org> <20090308063834.GA7102@dtor-d630.eng.vmware.com>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Bryan Wu" <cooloney@kernel.org>
Cc: <akpm@linux-foundation.org>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Mar 2009 13:20:17.0095 (UTC) FILETIME=[C9BFBD70:01C9A0B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>Subject: Re: [PATCH 1/1] Input/Touchscreen Driver: add support
>AD7877touchscreen driver (try #5)
>
>Hi Bryan, Michael,
>
>On Fri, Oct 17, 2008 at 01:56:08AM +0800, Bryan Wu wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> [try #5]
>>  - Fix indention
>>  - Lock spi_async()
>>  - Remove useless header comments
>>  - Use strict_strtoul
>>  - Use EDGE triggered interrupts ?\226?\128?\147 this simplifies some
of
>the IRQ handling.
>>  - Fix error cleanup path
>>  - Remove duplicated code
>>  - SPI access functions parameter use struct spi_device
>>
>
>I looked at the latest version of the driver in Andrew's queue and I
>think it needs the following changes:
>
>- you can't have parts of bitfield updated from IRQ context and part
from
>  process context unless every field is protected by the same spinlock.
>
>- You need more full mutual exclusion between enable and disable so you
>  don't inadvertingly kill the timer if you disable and enable from
>  different processes.
>
>- I think you need serialization in various store() methods so that
>  consistent values are written into chip's registers.
>
>- There were coule of inverted logic errors in disabling chip code.
>
>- Kay is trying to get rid of bus_id in devices, you need to use
>  dev_name() instead.

Andrew folded a patch addressing this issue, submitted by
[randy.dunlap@oracle.com: touchscreen/ad787x: don't use bus_id] into his

[patch 03/22] input: AD7879 Touchscreen driver patch.

You must have missed this one.

>
>Could you please try the patch below and let me know if the driver
still
>works so I can commit it. I also did some formatting changes, I hope
you
>don't mind. Thanks!

Thanks a lot for your great efforts!

But your patch doesn't apply on Andrews folded patch send to you last
Wednesday. I also tried it without the "don't use bus_id" patch.

Can you please send me your modified files?

Best regards,
Michael


>
>--
>Dmitry
>
>Input: ad7877 fixups
>
>Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>---
>
> drivers/input/touchscreen/ad7877.c |  226
++++++++++++++++----------------
>----
> 1 files changed, 99 insertions(+), 127 deletions(-)
>
>
>diff --git a/drivers/input/touchscreen/ad7877.c
>b/drivers/input/touchscreen/ad7877.c
>index 6615bcd..6702364 100644
>--- a/drivers/input/touchscreen/ad7877.c
>+++ b/drivers/input/touchscreen/ad7877.c
>@@ -1,7 +1,7 @@
> /*
>  * File:        drivers/input/touchscreen/ad7877.c
>  *
>- * Based on: 	ads7846.c
>+ * Based on:	ads7846.c
>  *
>  *		Copyright (C) 2006-2008 Michael Hennerich, Analog
Devices Inc.
>  *
>@@ -185,21 +185,24 @@ struct ad7877 {
> 	u8			averaging;
> 	u8			pen_down_acc_interval;
>
>-	u16 			conversion_data[AD7877_NR_SENSE];
>+	u16			conversion_data[AD7877_NR_SENSE];
>
> 	struct spi_transfer	xfer[AD7877_NR_SENSE + 2];
> 	struct spi_message	msg;
>
>+	struct mutex		mutex;
>+	unsigned		disabled:1;	/* P: mutex */
>+	unsigned		gpio3:1;	/* P: mutex */
>+	unsigned		gpio4:1;	/* P: mutex */
>+
> 	spinlock_t		lock;
> 	struct timer_list	timer;		/* P: lock */
>-	unsigned		pendown:1;	/* P: lock */
> 	unsigned		pending:1;	/* P: lock */
>-	unsigned		disabled:1;
>-	unsigned		gpio3:1;
>-	unsigned		gpio4:1;
> };
>
> static int gpio3;
>+module_param(gpio3, int, 0);
>+MODULE_PARM_DESC(gpio3, "If gpio3 is set to 1 AUX3 acts as GPIO3");
>
> /*
>  * ad7877_read/write are only used for initial setup and for sysfs
>controls.
>@@ -208,9 +211,10 @@ static int gpio3;
>
> static int ad7877_read(struct spi_device *spi, u16 reg)
> {
>-	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
>-	int			status, ret;
>+	struct ser_req *req;
>+	int status, ret;
>
>+	req = kzalloc(sizeof *req, GFP_KERNEL);
> 	if (!req)
> 		return -ENOMEM;
>
>@@ -228,11 +232,8 @@ static int ad7877_read(struct spi_device *spi, u16
>reg)
> 	spi_message_add_tail(&req->xfer[1], &req->msg);
>
> 	status = spi_sync(spi, &req->msg);
>+	ret = status ? : req->sample;
>
>-	if (status == 0)
>-		status = req->msg.status;
>-
>-	ret = status ? status : req->sample;
> 	kfree(req);
>
> 	return ret;
>@@ -240,9 +241,10 @@ static int ad7877_read(struct spi_device *spi, u16
>reg)
>
> static int ad7877_write(struct spi_device *spi, u16 reg, u16 val)
> {
>-	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
>-	int			status;
>+	struct ser_req *req;
>+	int status;
>
>+	req = kzalloc(sizeof *req, GFP_KERNEL);
> 	if (!req)
> 		return -ENOMEM;
>
>@@ -256,9 +258,6 @@ static int ad7877_write(struct spi_device *spi, u16
>reg, u16 val)
>
> 	status = spi_sync(spi, &req->msg);
>
>-	if (status == 0)
>-		status = req->msg.status;
>-
> 	kfree(req);
>
> 	return status;
>@@ -266,12 +265,13 @@ static int ad7877_write(struct spi_device *spi,
u16
>reg, u16 val)
>
> static int ad7877_read_adc(struct spi_device *spi, unsigned command)
> {
>-	struct ad7877 		*ts = dev_get_drvdata(&spi->dev);
>-	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
>-	int			status;
>-	int			sample;
>-	int			i;
>+	struct ad7877 *ts = dev_get_drvdata(&spi->dev);
>+	struct ser_req *req;
>+	int status;
>+	int sample;
>+	int i;
>
>+	req = kzalloc(sizeof *req, GFP_KERNEL);
> 	if (!req)
> 		return -ENOMEM;
>
>@@ -314,21 +314,18 @@ static int ad7877_read_adc(struct spi_device
*spi,
>unsigned command)
> 		spi_message_add_tail(&req->xfer[i], &req->msg);
>
> 	status = spi_sync(spi, &req->msg);
>-
>-	if (status == 0)
>-		status = req->msg.status;
>-
> 	sample = req->sample;
>
> 	kfree(req);
>-	return status ? status : sample;
>+
>+	return status ? : sample;
> }
>
> static void ad7877_rx(struct ad7877 *ts)
> {
>-	struct input_dev	*input_dev = ts->input;
>-	unsigned		Rt;
>-	u16			x, y, z1, z2;
>+	struct input_dev *input_dev = ts->input;
>+	unsigned Rt;
>+	u16 x, y, z1, z2;
>
> 	x = ts->conversion_data[AD7877_SEQ_XPOS] & MAX_12BIT;
> 	y = ts->conversion_data[AD7877_SEQ_YPOS] & MAX_12BIT;
>@@ -350,10 +347,7 @@ static void ad7877_rx(struct ad7877 *ts)
> 		Rt = (z2 - z1) * x * ts->x_plate_ohms;
> 		Rt /= z1;
> 		Rt = (Rt + 2047) >> 12;
>-	} else
>-		Rt = 0;
>
>-	if (Rt) {
> 		input_report_abs(input_dev, ABS_X, x);
> 		input_report_abs(input_dev, ABS_Y, y);
> 		input_report_abs(input_dev, ABS_PRESSURE, Rt);
>@@ -371,7 +365,7 @@ static inline void ad7877_ts_event_release(struct
>ad7877 *ts)
>
> static void ad7877_timer(unsigned long handle)
> {
>-	struct ad7877	*ts = (void *)handle;
>+	struct ad7877 *ts = (void *)handle;
>
> 	ad7877_ts_event_release(ts);
> }
>@@ -382,78 +376,72 @@ static irqreturn_t ad7877_irq(int irq, void
*handle)
> 	unsigned long flags;
> 	int status;
>
>-	/* The repeated conversion sequencer controlled by TMR kicked
off too
>fast.
>-	 * We ignore the last and process the sample sequence currently
in
>the queue
>-	 * It can't be older than 9.4ms, and we need to avoid that
ts->msg
>-	 * doesn't get issued twice while in work.
>+	/*
>+	 * The repeated conversion sequencer controlled by TMR kicked
off
>+	 * too fast. We ignore the last and process the sample sequence
>+	 * currently in the queue. It can't be older than 9.4ms, and we
>+	 * need to avoid that ts->msg doesn't get issued twice while in
work.
> 	 */
>
> 	spin_lock_irqsave(&ts->lock, flags);
>-	if (ts->pending) {
>-		spin_unlock_irqrestore(&ts->lock, flags);
>-		return IRQ_HANDLED;
>+	if (!ts->pending) {
>+		ts->pending = 1;
>+
>+		status = spi_async(ts->spi, &ts->msg);
>+		if (status)
>+			dev_err(&ts->spi->dev, "spi_sync --> %d\n",
status);
> 	}
>-	ts->pending = 1;
> 	spin_unlock_irqrestore(&ts->lock, flags);
>
>-	status = spi_async(ts->spi, &ts->msg);
>-
>-	if (status)
>-		dev_err(&ts->spi->dev, "spi_sync --> %d\n", status);
>-
> 	return IRQ_HANDLED;
> }
>
> static void ad7877_callback(void *_ts)
> {
> 	struct ad7877 *ts = _ts;
>-	unsigned long flags;
>
>-	ad7877_rx(ts);
>+	spin_lock_irq(&ts->lock);
>
>-	spin_lock_irqsave(&ts->lock, flags);
>+	ad7877_rx(ts);
> 	ts->pending = 0;
> 	mod_timer(&ts->timer, jiffies + TS_PEN_UP_TIMEOUT);
>-	spin_unlock_irqrestore(&ts->lock, flags);
>+
>+	spin_unlock_irq(&ts->lock);
> }
>
> static void ad7877_disable(struct ad7877 *ts)
> {
>-	unsigned long flags;
>-
>-	spin_lock_irqsave(&ts->lock, flags);
>-	if (ts->disabled) {
>-		spin_unlock_irqrestore(&ts->lock, flags);
>-		return;
>-	}
>+	mutex_lock(&ts->mutex);
>
>-	ts->disabled = 1;
>-	disable_irq(ts->spi->irq);
>-	spin_unlock_irqrestore(&ts->lock, flags);
>+	if (!ts->disabled) {
>+		ts->disabled = 1;
>+		disable_irq(ts->spi->irq);
>
>-	while (ts->pending) /* Wait for spi_async callback */
>-		msleep(1);
>+		/* Wait for spi_async callback */
>+		while (ts->pending)
>+			msleep(1);
>
>-	if (del_timer_sync(&ts->timer))
>-		ad7877_ts_event_release(ts);
>+		if (del_timer_sync(&ts->timer))
>+			ad7877_ts_event_release(ts);
>+	}
>
> 	/* we know the chip's in lowpower mode since we always
> 	 * leave it that way after every request
> 	 */
>+
>+	mutex_unlock(&ts->mutex);
> }
>
> static void ad7877_enable(struct ad7877 *ts)
> {
>-	unsigned long flags;
>+	mutex_lock(&ts->mutex);
>
>-	spin_lock_irqsave(&ts->lock, flags);
> 	if (ts->disabled) {
>-		spin_unlock_irqrestore(&ts->lock, flags);
>-		return;
>+		ts->disabled = 0;
>+		enable_irq(ts->spi->irq);
> 	}
>-	ts->disabled = 0;
>-	enable_irq(ts->spi->irq);
>-	spin_unlock_irqrestore(&ts->lock, flags);
>+
>+	mutex_unlock(&ts->mutex);
> }
>
> #define SHOW(name) static ssize_t \
>@@ -490,12 +478,11 @@ static ssize_t ad7877_disable_store(struct device
>*dev,
> {
> 	struct ad7877 *ts = dev_get_drvdata(dev);
> 	unsigned long val;
>-	int ret;
>+	int error;
>
>-	ret = strict_strtoul(buf, 10, &val);
>-
>-	if (ret)
>-		return ret;
>+	error = strict_strtoul(buf, 10, &val);
>+	if (error)
>+		return error;
>
> 	if (val)
> 		ad7877_disable(ts);
>@@ -521,16 +508,16 @@ static ssize_t ad7877_dac_store(struct device
*dev,
> {
> 	struct ad7877 *ts = dev_get_drvdata(dev);
> 	unsigned long val;
>-	int ret;
>-
>-	ret = strict_strtoul(buf, 10, &val);
>+	int error;
>
>-	if (ret)
>-		return ret;
>+	error = strict_strtoul(buf, 10, &val);
>+	if (error)
>+		return error;
>
>+	mutex_lock(&ts->mutex);
> 	ts->dac = val & 0xFF;
>-
> 	ad7877_write(ts->spi, AD7877_REG_DAC, (ts->dac << 4) |
>AD7877_DAC_CONF);
>+	mutex_unlock(&ts->mutex);
>
> 	return count;
> }
>@@ -551,16 +538,17 @@ static ssize_t ad7877_gpio3_store(struct device
*dev,
> {
> 	struct ad7877 *ts = dev_get_drvdata(dev);
> 	unsigned long val;
>-	int ret;
>+	int error;
>
>-	ret = strict_strtoul(buf, 10, &val);
>-	if (ret)
>-		return ret;
>+	error = strict_strtoul(buf, 10, &val);
>+	if (error)
>+		return error;
>
>+	mutex_lock(&ts->mutex);
> 	ts->gpio3 = !!val;
>-
> 	ad7877_write(ts->spi, AD7877_REG_EXTWRITE, AD7877_EXTW_GPIO_DATA
|
> 		 (ts->gpio4 << 4) | (ts->gpio3 << 5));
>+	mutex_unlock(&ts->mutex);
>
> 	return count;
> }
>@@ -581,16 +569,17 @@ static ssize_t ad7877_gpio4_store(struct device
*dev,
> {
> 	struct ad7877 *ts = dev_get_drvdata(dev);
> 	unsigned long val;
>-	int ret;
>+	int error;
>
>-	ret = strict_strtoul(buf, 10, &val);
>-	if (ret)
>-		return ret;
>+	error = strict_strtoul(buf, 10, &val);
>+	if (error)
>+		return error;
>
>+	mutex_lock(&ts->mutex);
> 	ts->gpio4 = !!val;
>-
> 	ad7877_write(ts->spi, AD7877_REG_EXTWRITE, AD7877_EXTW_GPIO_DATA
|
>-		 (ts->gpio4 << 4) | (ts->gpio3 << 5));
>+		     (ts->gpio4 << 4) | (ts->gpio3 << 5));
>+	mutex_unlock(&ts->mutex);
>
> 	return count;
> }
>@@ -685,14 +674,10 @@ static int __devinit ad7877_probe(struct
spi_device
>*spi)
> 	}
>
> 	ts = kzalloc(sizeof(struct ad7877), GFP_KERNEL);
>-	if (!ts)
>-		return -ENOMEM;
>-
>-
> 	input_dev = input_allocate_device();
>-	if (!input_dev) {
>-		kfree(ts);
>-		return -ENOMEM;
>+	if (!ts || !input_dev) {
>+		err = -ENOMEM;
>+		goto err_free_mem;
> 	}
>
> 	dev_set_drvdata(&spi->dev, ts);
>@@ -700,6 +685,7 @@ static int __devinit ad7877_probe(struct spi_device
>*spi)
> 	ts->input = input_dev;
>
> 	setup_timer(&ts->timer, ad7877_timer, (unsigned long) ts);
>+	mutex_init(&ts->mutex);
> 	spin_lock_init(&ts->lock);
>
> 	ts->model = pdata->model ? : 7877;
>@@ -713,7 +699,7 @@ static int __devinit ad7877_probe(struct spi_device
>*spi)
> 	ts->averaging = pdata->averaging;
> 	ts->pen_down_acc_interval = pdata->pen_down_acc_interval;
>
>-	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX",
spi->dev.bus_id);
>+	snprintf(ts->phys, sizeof(ts->phys), "%s/input0", dev_name(&spi-
>>dev));
>
> 	input_dev->name = "AD7877 Touchscreen";
> 	input_dev->phys = ts->phys;
>@@ -761,30 +747,25 @@ static int __devinit ad7877_probe(struct
spi_device
>*spi)
> 	}
>
> 	err = sysfs_create_group(&spi->dev.kobj, &ad7877_attr_group);
>-
>-	if (gpio3)
>-		err |= device_create_file(&spi->dev, &dev_attr_gpio3);
>-	else
>-		err |= device_create_file(&spi->dev, &dev_attr_aux3);
>-
> 	if (err)
> 		goto err_free_irq;
>
>+	err = device_create_file(&spi->dev,
>+				 gpio3 ? &dev_attr_gpio3 :
&dev_attr_aux3);
>+	if (err)
>+		goto err_remove_attr_group;
>+
> 	err = input_register_device(input_dev);
> 	if (err)
> 		goto err_remove_attr;
>
>-	dev_info(&spi->dev, "touchscreen, irq %d\n", spi->irq);
>-
> 	return 0;
>
> err_remove_attr:
>+	device_remove_file(&spi->dev,
>+			   gpio3 ? &dev_attr_gpio3 : &dev_attr_aux3);
>+err_remove_attr_group:
> 	sysfs_remove_group(&spi->dev.kobj, &ad7877_attr_group);
>-
>-	if (gpio3)
>-		device_remove_file(&spi->dev, &dev_attr_gpio3);
>-	else
>-		device_remove_file(&spi->dev, &dev_attr_aux3);
> err_free_irq:
> 	free_irq(spi->irq, ts);
> err_free_mem:
>@@ -798,19 +779,14 @@ static int __devexit ad7877_remove(struct
spi_device
>*spi)
> {
> 	struct ad7877		*ts = dev_get_drvdata(&spi->dev);
>
>-	ad7877_disable(ts);
>-
> 	sysfs_remove_group(&spi->dev.kobj, &ad7877_attr_group);
>+	device_remove_file(&spi->dev,
>+			   gpio3 ? &dev_attr_gpio3 : &dev_attr_aux3);
>
>-	if (gpio3)
>-		device_remove_file(&spi->dev, &dev_attr_gpio3);
>-	else
>-		device_remove_file(&spi->dev, &dev_attr_aux3);
>-
>+	ad7877_disable(ts);
> 	free_irq(ts->spi->irq, ts);
>
> 	input_unregister_device(ts->input);
>-
> 	kfree(ts);
>
> 	dev_dbg(&spi->dev, "unregistered touchscreen\n");
>@@ -866,10 +842,6 @@ static void __exit ad7877_exit(void)
> }
> module_exit(ad7877_exit);
>
>-module_param(gpio3, int, 0);
>-MODULE_PARM_DESC(gpio3,
>-	"If gpio3 is set to 1 AUX3 acts as GPIO3");
>-
> MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
> MODULE_DESCRIPTION("AD7877 touchscreen Driver");
> MODULE_LICENSE("GPL");
