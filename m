Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZAHKH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZAHKH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZAHKHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:07:15 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:42091 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZAHKHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Lc0AQ9i29v1ZTE1JSDY8kYY5u4pS/yUfl7OinfXNAh1DZo6Y6CJsP3l88vokDbcaoq
         6Zdz10nTON7uTrAZ5Wt6JVr9k2VFrcK0MxVEPaxigNicPa86znndguCDtfSziEWgcuze
         8J/u1WUJvSIv0+4y4e+HpyYaclA/5cczF4bJc=
Message-ID: <8447d6730901080207i5dffd0c7t6c0d1e1f8aee4c9d@mail.gmail.com>
Date: Thu, 8 Jan 2009 11:07:11 +0100
From: "Davide Rizzo" <elpa.rizzo@gmail.com>
To: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       ben-linux@fluff.org
Subject: [PATCH 2/2] Driver for user access to internal timer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the function pwm_one_shot to the pwm interface, to use a timer to wait for
 a short period and call a callback at the end. This is for ms range delays.
There is also the implementation for the Samsung S3C24xx platform.

Signed-off-by: Davide Rizzo <elpa-rizzo@gmail.com>
---
diff -urNp linux-2.6.28/arch/arm/plat-s3c24xx/pwm.c
linux-2.6.28.elpa/arch/arm/plat-s3c24xx/pwm.c
--- linux-2.6.28/arch/arm/plat-s3c24xx/pwm.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28.elpa/arch/arm/plat-s3c24xx/pwm.c	2009-01-06
19:04:44.000000000 +0100
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
+#include <linux/interrupt.h>
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/pwm.h>
@@ -22,6 +23,8 @@
 #include <plat/devs.h>
 #include <plat/regs-timer.h>

+#define DEV_NAME "s3c24xx-pwm"
+
 struct pwm_device {
 	struct list_head	 list;
 	struct platform_device	*pdev;
@@ -37,6 +40,11 @@ struct pwm_device {
 	unsigned char		 running;
 	unsigned char		 use_count;
 	unsigned char		 pwm_id;
+
+	/* For one-shot mode callback*/
+	int irq;
+	void (*expired)(struct pwm_device *, void *arg);
+	void *arg;
 };

 #define pwm_dbg(_pwm, msg...) dev_dbg(&(_pwm)->pdev->dev, msg)
@@ -57,7 +65,7 @@ static struct clk *clk_scaler[2];
 	}

 #define DEFINE_S3C_TIMER(_tmr_no, _irq)			\
-	.name		= "s3c24xx-pwm",		\
+	.name		= DEV_NAME,		\
 	.id		= _tmr_no,			\
 	.num_resources	= TIMER_RESOURCE_SIZE,		\
 	.resource	= TIMER_RESOURCE(_tmr_no, _irq),	\
@@ -272,6 +280,88 @@ int pwm_config(struct pwm_device *pwm, i

 EXPORT_SYMBOL(pwm_config);

+static irqreturn_t timer_isr(int irq, void *arg)
+{
+	struct pwm_device *pwm = arg;
+
+	if (pwm->expired) {
+		disable_irq(irq);
+		pwm_disable(pwm);
+		pwm->expired(pwm, pwm->arg);
+		pwm->expired = NULL;
+	}
+	return IRQ_HANDLED;
+}
+
+int pwm_one_shot(struct pwm_device *pwm, int timeout_ns,
+	void(*expired)(struct pwm_device *, void *arg), void *arg)
+{
+	unsigned long tin_rate;
+	unsigned long tin_ns;
+	unsigned long period;
+	unsigned long flags;
+	unsigned long tcon;
+	unsigned long tcnt;
+
+	/* We currently avoid using 64bit arithmetic by using the
+	 * fact that anything faster than 1Hz is easily representable
+	 * by 32bits. */
+
+	if (timeout_ns > NS_IN_HZ)
+		return -ERANGE;
+
+	/* The TCMP and TCNT can be read without a lock, they're not
+	 * shared between the timers. */
+
+	tcnt = __raw_readl(S3C2410_TCNTB(pwm->pwm_id));
+
+	period = NS_IN_HZ / timeout_ns;
+
+	pwm_dbg(pwm, "one shot timeout_ns=%d\n", timeout_ns);
+
+	if (pwm_is_tdiv(pwm)) {
+		tin_rate = pwm_calc_tin(pwm, period);
+		clk_set_rate(pwm->clk_div, tin_rate);
+	} else
+		tin_rate = clk_get_rate(pwm->clk);
+
+	pwm_dbg(pwm, "tin_rate=%lu\n", tin_rate);
+
+	tin_ns = NS_IN_HZ / tin_rate;
+	tcnt = timeout_ns / tin_ns;
+	/* Note, counters count down */
+
+	pwm_dbg(pwm, "tin_ns=%lu\n", tin_ns);
+
+	/* Update the PWM register block. */
+
+	local_irq_save(flags);
+
+	if (!pwm->expired)
+		enable_irq(pwm->irq);
+
+	__raw_writel(tcnt, S3C2410_TCNTB(pwm->pwm_id));
+
+	tcon = __raw_readl(S3C2410_TCON);
+	tcon |= pwm_tcon_manulupdate(pwm);
+	tcon &= ~pwm_tcon_autoreload(pwm);
+	tcon &= ~pwm_tcon_start(pwm);
+	__raw_writel(tcon, S3C2410_TCON);
+
+
+	pwm->expired = expired;
+	pwm->arg = arg;
+
+	tcon &= ~pwm_tcon_manulupdate(pwm);
+	tcon |= pwm_tcon_start(pwm);
+	__raw_writel(tcon, S3C2410_TCON);
+
+	local_irq_restore(flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_one_shot);
+
 static int pwm_register(struct pwm_device *pwm)
 {
 	pwm->duty_ns = -1;
@@ -288,6 +378,7 @@ static int s3c_pwm_probe(struct platform
 {
 	struct device *dev = &pdev->dev;
 	struct pwm_device *pwm;
+	struct resource *res;
 	unsigned long flags;
 	unsigned long tcon;
 	unsigned int id = pdev->id;
@@ -306,6 +397,22 @@ static int s3c_pwm_probe(struct platform

 	pwm->pdev = pdev;
 	pwm->pwm_id = id;
+	pwm->expired = NULL;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "cannot get platform interrupt resource\n");
+		ret = -EBUSY;
+		goto err_getresources;
+	}
+	pwm->irq = res->start;
+	ret = request_irq(pwm->irq, timer_isr, IRQF_DISABLED,
+		DEV_NAME, pwm);
+	if (ret) {
+		dev_err(dev, "request_irq failed\n");
+		goto err_getirq;
+	}
+	disable_irq(pwm->irq);

 	/* calculate base of control bits in TCON */
 	pwm->tcon_base = id == 0 ? 0 : (id * 4) + 4;
@@ -354,6 +461,10 @@ static int s3c_pwm_probe(struct platform
 	clk_put(pwm->clk_div);

  err_clk_tin:
+ err_getresources:
+	free_irq(pwm->irq, DEV_NAME);
+
+ err_getirq:
 	clk_put(pwm->clk);

  err_alloc:
@@ -365,6 +476,7 @@ static int s3c_pwm_remove(struct platfor
 {
 	struct pwm_device *pwm = platform_get_drvdata(pdev);

+	free_irq(pwm->irq, DEV_NAME);
 	clk_put(pwm->clk_div);
 	clk_put(pwm->clk);
 	kfree(pwm);
@@ -374,7 +486,7 @@ static int s3c_pwm_remove(struct platfor

 static struct platform_driver s3c_pwm_driver = {
 	.driver		= {
-		.name	= "s3c24xx-pwm",
+		.name	= DEV_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= s3c_pwm_probe,
diff -urNp linux-2.6.28/include/linux/pwm.h
linux-2.6.28.elpa/include/linux/pwm.h
--- linux-2.6.28/include/linux/pwm.h	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28.elpa/include/linux/pwm.h	2009-01-06 19:35:19.000000000 +0100
@@ -19,6 +19,13 @@ void pwm_free(struct pwm_device *pwm);
 int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);

 /*
+ * pwm_one_shot - programs and starts a timer for one-shot operation
+ *  when expired calls callback
+ */
+int pwm_one_shot(struct pwm_device *pwm, int timeout_ns,
+	void(*expired)(struct pwm_device *, void *arg), void *arg);
+
+/*
  * pwm_enable - start a PWM output toggling
  */
 int pwm_enable(struct pwm_device *pwm);
