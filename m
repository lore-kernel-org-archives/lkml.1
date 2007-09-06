Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXIFQNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXIFQNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 12:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbXIFQNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 12:13:42 -0400
Received: from mail.artecdesign.ee ([62.65.32.9]:40729 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbXIFQNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 12:13:41 -0400
X-Greylist: delayed 2105 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 12:13:41 EDT
Message-ID: <46E01EF7.7010605@artecdesign.ee>
Date: Thu, 06 Sep 2007 18:38:31 +0300
From: Anti Sullin <anti.sullin@artecdesign.ee>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add suspend and resume to gpio_keys driver
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
X-ADG-ExiScan-Signature: 424c9a4de33dbfb08789f72b0af0e53c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suspend/resume support and enables wakeup from gpio_keys 
buttons.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>

diff -pur linux-2.6.23-rc5-old/drivers/input/keyboard/gpio_keys.c linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c
--- linux-2.6.23-rc5-old/drivers/input/keyboard/gpio_keys.c	2007-09-06 18:24:23.000000000 +0300
+++ linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c	2007-09-06 18:23:37.000000000 +0300
@@ -59,6 +59,7 @@ static int __devinit gpio_keys_probe(str
 	if (!input)
 		return -ENOMEM;
 
+	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, input);
 
 	input->evbit[0] = BIT(EV_KEY);
@@ -103,6 +104,7 @@ static int __devinit gpio_keys_probe(str
 		free_irq(gpio_to_irq(pdata->buttons[i].gpio), pdev);
 
 	input_free_device(input);
+	device_init_wakeup(&pdev->dev, 0);
 
 	return error;
 }
@@ -118,14 +120,51 @@ static int __devexit gpio_keys_remove(st
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
+			enable_irq_wake(irq);
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
+	for (i = 0; i < pdata->nbuttons; i++) {
+		int irq = gpio_to_irq(pdata->buttons[i].gpio);
+		disable_irq_wake(irq);
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


-- 
Anti Sullin
Embedded Software Engineer
Artec Design LLC
Türi 10C, 11313, Tallinn, Estonia

