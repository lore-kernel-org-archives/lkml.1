Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbXIRPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbXIRPrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbXIRPrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:47:32 -0400
Received: from mail.artecdesign.ee ([62.65.32.9]:36256 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025AbXIRPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:47:30 -0400
Message-ID: <46EFF30B.5010709@artecdesign.ee>
Date: Tue, 18 Sep 2007 18:47:23 +0300
From: Anti Sullin <anti.sullin@artecdesign.ee>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: dtor@mail.ru, akpm@linux-foundation.org, david-b@pacbell.net
Subject: [PATCH 2/2][resend] gpio_keys: Add suspend and resume
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ADG-Spam-Score: -5.9 (-----)
X-ADG-Spam-ScoreInt: -58
X-ADG-Spam-Report: Content analysis details:   (-5.9 points, 5.5 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ADG-ExiScan-Signature: 0f1ff8aeff96eebb3430572e7500aab1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suspend/resume support and enables wakeup from gpio_keys 
buttons.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>

---
Compared to  previous patch sent, in this version the disable_irq_wake is
called only for those IRQs, that were enabled earlier.

---
diff -pur linux-2.6.23-rc5-old/drivers/input/keyboard/gpio_keys.c linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c
--- linux-2.6.23-rc5-old/drivers/input/keyboard/gpio_keys.c	2007-09-18 17:43:54.000000000 +0300
+++ linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c	2007-09-18 17:25:14.000000000 +0300
@@ -54,6 +54,7 @@ static int __devinit gpio_keys_probe(str
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct input_dev *input;
 	int i, error;
+	int wakeup = 0;
 
 	input = input_allocate_device();
 	if (!input)
@@ -89,6 +90,9 @@ static int __devinit gpio_keys_probe(str
 			goto fail;
 		}
 
+		if (button->wakeup) 
+			wakeup = 1;
+		
 		input_set_capability(input, type, button->code);
 	}
 
@@ -98,6 +102,8 @@ static int __devinit gpio_keys_probe(str
 		goto fail;
 	}
 
+	device_init_wakeup(&pdev->dev, wakeup);
+	
 	return 0;
 
  fail:
@@ -120,14 +126,55 @@ static int __devexit gpio_keys_remove(st
 		free_irq(irq, pdev);
 	}
 
+	device_init_wakeup(&pdev->dev, 0);
 	input_unregister_device(input);
 
 	return 0;
 }
 
+
+#ifdef CONFIG_PM
+static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	int i;
+
+	if (device_may_wakeup(&pdev->dev)) {
+		for (i = 0; i < pdata->nbuttons; i++) {
+			int irq = gpio_to_irq(pdata->buttons[i].gpio);
+			if (pdata->buttons[i].wakeup)
+				enable_irq_wake(irq);
+		}
+	}
+
+	return 0;
+}
+
+static int gpio_keys_resume(struct platform_device *pdev)
+{
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	int i;
+
+	if (device_may_wakeup(&pdev->dev)) {
+		for (i = 0; i < pdata->nbuttons; i++) {
+			int irq = gpio_to_irq(pdata->buttons[i].gpio);
+			if (pdata->buttons[i].wakeup)
+				disable_irq_wake(irq);
+		}
+	}
+
+	return 0;
+}
+#else
+#define gpio_keys_suspend	NULL
+#define gpio_keys_resume	NULL
+#endif
+
 struct platform_driver gpio_keys_device_driver = {
 	.probe		= gpio_keys_probe,
 	.remove		= __devexit_p(gpio_keys_remove),
+	.suspend	= gpio_keys_suspend,
+	.resume		= gpio_keys_resume,	
 	.driver		= {
 		.name	= "gpio-keys",
 	}
diff -pur linux-2.6.23-rc5-old/include/linux/gpio_keys.h linux-2.6.23-rc5/include/linux/gpio_keys.h
--- linux-2.6.23-rc5-old/include/linux/gpio_keys.h	2007-09-01 09:08:24.000000000 +0300
+++ linux-2.6.23-rc5/include/linux/gpio_keys.h	2007-09-10 10:43:39.000000000 +0300
@@ -8,6 +8,7 @@ struct gpio_keys_button {
 	int active_low;
 	char *desc;
 	int type;		/* input event type (EV_KEY, EV_SW) */
+	int wakeup;		/* configure the button as wake-up source from suspend */
 };
 
 struct gpio_keys_platform_data {


-- 
Anti Sullin
Embedded Software Engineer
Artec Design LLC
Türi 10C, 11313, Tallinn, Estonia
Phone: +3726718550; Direct: +3726718564
Fax: +3726718555; GSM: +3725583068
email: anti.sullin@artecdesign.ee
http://www.artecdesign.ee 

