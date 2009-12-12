Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZLLHmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZLLHmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 02:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZLLHmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 02:42:15 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:52731 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZLLHmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 02:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=s8xl0Di2WRe8GZ4Nj+qooeiCaeUjnhW5ZVGbVQQGfkU3lJ5L7mNLDamOvfxJK/eRwO
         Vq7HxQSoD0PR+vui0Lws44/kHUMam2Q9XZQ8nkr+URY5njfY5XSr/nNiEdDZCWJDtaPt
         L36Cd/ppJtu6lRqJXb4ixzve5X0vxRXf+R8js=
Date: Fri, 11 Dec 2009 23:42:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-input@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] [input] add mc13783 touchscreen driver
Message-ID: <20091212074214.GB2956@core.coreip.homeip.net>
References: <20090813162321.5A2F5526EC9@mailhub.coreip.homeip.net> <1259956377-32173-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259956377-32173-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Fri, Dec 04, 2009 at 08:52:57PM +0100, Uwe Kleine-König wrote:
> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> This driver provides support for the touchscreen interface
> integrated into the Freescale MC13783.
> 

Unfortunately the driver as presented does not compile because changes
to mc13783 core that are needed by this driver are not in mainline (and
therefore are not in my tree) yet. Do you know when they willbe
submitted to Linus?

At this point we have 2 option - wait till the necessary changes hit
mainline or merge through some other tree. I am OK with merging through
other tree (MFD?) provided that the patch below is applied (just fold it
into original patch). The main changes:

 - we should free IRQ if we fail to activate the device. The old code
   was returning error from mc13783_ts_open() but was leaving IRQ
   registered

 - use cancel_delayed_work_sync() instead of cancel_delayed_work(). You
   want to make sure that work function is not running. It also should
   be called form mc13783_ts_close() and not mc13783_ts_remove()

 - miscellaneous formatting changes.

In this case please feel free add:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry


diff -u b/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
--- b/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -46,6 +46,12 @@
 
 	mc13783_ackirq(priv->mc13783, irq);
 
+	/*
+	 * Kick off reading coordinates. Note that if work happens already
+	 * be queued for future execution (it rearms itself) it will not
+	 * be rescheduled for immediate execution here. However the rearm
+	 * delay is HZ / 50 which is acceptable.
+	 */
 	queue_delayed_work(priv->workq, &priv->work, 0);
 
 	return IRQ_HANDLED;
@@ -62,6 +68,7 @@
 
 static void mc13783_ts_report_sample(struct mc13783_ts_priv *priv)
 {
+	struct input_dev *idev = priv->idev;
 	int x0, x1, x2, y0, y1, y2;
 	int cr0, cr1;
 
@@ -78,8 +85,9 @@
 	cr0 = (priv->sample[2] >> 12) & 0xfff;
 	cr1 = (priv->sample[3] >> 12) & 0xfff;
 
-	dev_dbg(&priv->idev->dev, "x: (% 4d,% 4d,% 4d) y: (% 4d, % 4d,% 4d) "
-			"cr: (% 4d, % 4d)\n", x0, x1, x2, y0, y1, y2, cr0, cr1);
+	dev_dbg(&idev->dev,
+		"x: (% 4d,% 4d,% 4d) y: (% 4d, % 4d,% 4d) cr: (% 4d, % 4d)\n",
+		x0, x1, x2, y0, y1, y2, cr0, cr1);
 
 	sort3(x0, x1, x2);
 	sort3(y0, y1, y2);
@@ -87,26 +95,24 @@
 	cr0 = (cr0 + cr1) / 2;
 
 	if (!cr0 || !sample_tolerance ||
-			(x2 - x0 < sample_tolerance &&
-			 y2 - y0 < sample_tolerance))
-	{
+	    (x2 - x0 < sample_tolerance && y2 - y0 < sample_tolerance)) {
 		/* report the median coordinate and average pressure */
 		if (cr0) {
-			input_report_abs(priv->idev, ABS_X, x1);
-			input_report_abs(priv->idev, ABS_Y, y1);
+			input_report_abs(idev, ABS_X, x1);
+			input_report_abs(idev, ABS_Y, y1);
 
-			dev_dbg(&priv->idev->dev, "report (%d, %d, %d)\n",
-					x1, y1, 0x1000 - cr0);
+			dev_dbg(&idev->dev,
+				"report (%d, %d, %d)\n", x1, y1, 0x1000 - cr0);
 			queue_delayed_work(priv->workq, &priv->work, HZ / 50);
 		} else
-			dev_dbg(&priv->idev->dev, "report release\n");
+			dev_dbg(&idev->dev, "report release\n");
 
-		input_report_abs(priv->idev, ABS_PRESSURE,
-				cr0 ? 0x1000 - cr0 : cr0);
-		input_report_key(priv->idev, BTN_TOUCH, !!cr0);
-		input_sync(priv->idev);
+		input_report_abs(idev, ABS_PRESSURE,
+				 cr0 ? 0x1000 - cr0 : cr0);
+		input_report_key(idev, BTN_TOUCH, cr0);
+		input_sync(idev);
 	} else
-		dev_dbg(&priv->idev->dev, "discard event\n");
+		dev_dbg(&idev->dev, "discard event\n");
 }
 
 static void mc13783_ts_work(struct work_struct *work)
@@ -115,13 +121,11 @@
 		container_of(work, struct mc13783_ts_priv, work.work);
 	unsigned int mode = MC13783_ADC_MODE_TS;
 	unsigned int channel = 12;
-	int ret;
 
-	ret = mc13783_adc_do_conversion(priv->mc13783, mode, channel,
-			priv->sample);
-
-	if (!ret)
+	if (mc13783_adc_do_conversion(priv->mc13783,
+				      mode, channel, priv->sample) == 0) {
 		mc13783_ts_report_sample(priv);
+	}
 }
 
 static int mc13783_ts_open(struct input_dev *dev)
@@ -140,10 +144,10 @@
 
 	ret = mc13783_reg_rmw(priv->mc13783, MC13783_ADC0,
 			MC13783_ADC0_TSMOD_MASK, MC13783_ADC0_TSMOD0);
-
+	if (ret)
+		mc13783_irq_free(priv->mc13783, MC13783_IRQ_TS, priv);
 out:
 	mc13783_unlock(priv->mc13783);
-
 	return ret;
 }
 
@@ -156,65 +160,67 @@
 			MC13783_ADC0_TSMOD_MASK, 0);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_TS, priv);
 	mc13783_unlock(priv->mc13783);
+
+	cancel_delayed_work_sync(&priv->work);
 }
 
 static int __init mc13783_ts_probe(struct platform_device *pdev)
 {
 	struct mc13783_ts_priv *priv;
 	struct input_dev *idev;
-	int ret;
+	int error;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	idev = input_allocate_device();
+	if (!priv || !idev) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
 
+	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
 	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+	priv->idev = idev;
 
-	idev = input_allocate_device();
-	if (!idev) {
-		ret = -ENOMEM;
-		goto err_input_alloc;
+	/*
+	 * We need separate workqueue because mc13783_adc_do_conversion
+	 * uses keventd and thus would deadlock.
+	 */
+	priv->workq = create_singlethread_workqueue("mc13783_ts");
+	if (!priv->workq) {
+		error = -ENOMEM;
+		goto err_free_mem;
 	}
 
-	priv->idev = idev;
 	idev->name = MC13783_TS_NAME;
+	idev->dev.parent = &pdev->dev;
+
 	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
-	idev->open = mc13783_ts_open;
-	idev->close = mc13783_ts_close;
 	input_set_abs_params(idev, ABS_X, 0, 0xfff, 0, 0);
 	input_set_abs_params(idev, ABS_Y, 0, 0xfff, 0, 0);
 	input_set_abs_params(idev, ABS_PRESSURE, 0, 0xfff, 0, 0);
 
-	platform_set_drvdata(pdev, priv);
-
-	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
-
-	priv->workq = create_singlethread_workqueue("mc13783_ts");
-	if (!priv->workq) {
-		ret = -ENOMEM;
-		goto err_input_alloc;
-	}
+	idev->open = mc13783_ts_open;
+	idev->close = mc13783_ts_close;
 
 	input_set_drvdata(idev, priv);
 
-	ret = input_register_device(priv->idev);
-	if (ret) {
+	error = input_register_device(priv->idev);
+	if (error) {
 		dev_err(&pdev->dev,
-				"register input device failed with %d\n", ret);
-		goto err_failed_register;
+			"register input device failed with %d\n", error);
+		goto err_destroy_wq;
 	}
 
+	platform_set_drvdata(pdev, priv);
 	return 0;
 
-err_failed_register:
-	input_free_device(priv->idev);
-
-err_input_alloc:
-	platform_set_drvdata(pdev, NULL);
+err_destroy_wq:
+	destroy_workqueue(priv->workq);
+err_free_mem:
+	input_free_device(idev);
 	kfree(priv);
-
-	return ret;
+	return error;
 }
 
 static int __devexit mc13783_ts_remove(struct platform_device *pdev)
@@ -223,11 +229,8 @@
 
 	platform_set_drvdata(pdev, NULL);
 
-	cancel_delayed_work(&priv->work);
 	destroy_workqueue(priv->workq);
-
 	input_unregister_device(priv->idev);
-
 	kfree(priv);
 
 	return 0;
