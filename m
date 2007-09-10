Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbXIJHvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbXIJHvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 03:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXIJHvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 03:51:16 -0400
Received: from mail.artecdesign.ee ([62.65.32.9]:59543 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXIJHvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 03:51:15 -0400
Message-ID: <46E4F76C.6080004@artecdesign.ee>
Date: Mon, 10 Sep 2007 10:51:08 +0300
From: Anti Sullin <anti.sullin@artecdesign.ee>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: dmitry.torokhov@gmail.com
Subject: [PATCH][resend] Add suspend and resume to gpio_keys driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ADG-Spam-Score: -5.9 (-----)
X-ADG-Spam-ScoreInt: -58
X-ADG-Spam-Report: Content analysis details:   (-5.9 points, 5.5 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ADG-ExiScan-Signature: cffc03b04a5f31d6e5ea6fd7f92598fb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suspend/resume support and enables wakeup from gpio_keys 
buttons. Buttons, that generate wakeup events, can be specified in 
platform data.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>

diff -pur linux-2.6.23-rc5-clean/drivers/input/keyboard/gpio_keys.c 
linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c
--- linux-2.6.23-rc5-clean/drivers/input/keyboard/gpio_keys.c    
2007-09-10 09:52:18.000000000 +0300
+++ linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c    2007-09-10 
10:01:56.000000000 +0300
@@ -54,6 +54,7 @@ static int __devinit gpio_keys_probe(str
     struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
     struct input_dev *input;
     int i, error;
+    int wakeup = 0;
 
     input = input_allocate_device();
     if (!input)
@@ -87,6 +88,9 @@ static int __devinit gpio_keys_probe(str
             goto fail;
         }
 
+        if (button->wakeup)
+            wakeup = 1;
+       
         input_set_capability(input, type, button->code);
     }
 
@@ -96,6 +100,8 @@ static int __devinit gpio_keys_probe(str
         goto fail;
     }
 
+    device_init_wakeup(&pdev->dev, wakeup);
+   
     return 0;
 
  fail:
@@ -118,14 +124,52 @@ static int __devexit gpio_keys_remove(st
         free_irq(irq, pdev);
     }
 
+    device_init_wakeup(&pdev->dev, 0);
     input_unregister_device(input);
 
     return 0;
 }
 
+
+#ifdef CONFIG_PM
+static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t 
state)
+{
+    struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+    int i;
+
+    if (device_may_wakeup(&pdev->dev)) {
+        for (i = 0; i < pdata->nbuttons; i++) {
+            int irq = gpio_to_irq(pdata->buttons[i].gpio);
+            if (pdata->buttons[i].wakeup)
+                enable_irq_wake(irq);
+        }
+    }
+
+    return 0;
+}
+
+static int gpio_keys_resume(struct platform_device *pdev)
+{
+    struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+    int i;
+
+    for (i = 0; i < pdata->nbuttons; i++) {
+        int irq = gpio_to_irq(pdata->buttons[i].gpio);
+        disable_irq_wake(irq);
+    }
+
+    return 0;
+}
+#else
+#define gpio_keys_suspend    NULL
+#define gpio_keys_resume    NULL
+#endif
+
 struct platform_driver gpio_keys_device_driver = {
     .probe        = gpio_keys_probe,
     .remove        = __devexit_p(gpio_keys_remove),
+    .suspend    = gpio_keys_suspend,
+    .resume        = gpio_keys_resume,   
     .driver        = {
         .name    = "gpio-keys",
     }
diff -pur linux-2.6.23-rc5-clean/include/linux/gpio_keys.h 
linux-2.6.23-rc5/include/linux/gpio_keys.h
--- linux-2.6.23-rc5-clean/include/linux/gpio_keys.h    2007-09-01 
09:08:24.000000000 +0300
+++ linux-2.6.23-rc5/include/linux/gpio_keys.h    2007-09-10 
10:43:39.000000000 +0300
@@ -8,6 +8,7 @@ struct gpio_keys_button {
     int active_low;
     char *desc;
     int type;        /* input event type (EV_KEY, EV_SW) */
+    int wakeup;        /* configure the button as wake-up source from 
suspend */
 };
 
 struct gpio_keys_platform_data {

