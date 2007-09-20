Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXITHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXITHCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXITHCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:02:06 -0400
Received: from mail.artecdesign.ee ([62.65.32.9]:43120 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXITHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:02:05 -0400
Message-ID: <46F21ADC.5020801@artecdesign.ee>
Date: Thu, 20 Sep 2007 10:01:48 +0300
From: Anti Sullin <anti.sullin@artecdesign.ee>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: dtor@mail.ru, akpm@linux-foundation.org, david-b@pacbell.net
Subject: [PATCH 1/2][resend 2] gpio_keys: add gpio_to_irq return code check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-ADG-Spam-Score: -5.9 (-----)
X-ADG-Spam-ScoreInt: -58
X-ADG-Spam-Report: Content analysis details:   (-5.9 points, 5.5 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ADG-ExiScan-Signature: 2413d82fcfee70ec6e4bc37b15bc6403
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As David Brownell pointed out when reviewing my suspend patch to 
gpio_keys, the original gpio_keys driver does not check gpio_to_irq 
return code.

This patch adds the gpio_to_irq return code check to gpio_keys and 
moves the IRQ edge type setting to request_irq flags to avoid changing 
the irq type before we have confirmed we can use it.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee> 
---
Resent: Return code changed to irq error value
---

diff -pur clean/linux-2.6.23-rc5-at91/drivers/input/keyboard/gpio_keys.c linux-2.6.23-rc5-at91/drivers/input/keyboard/gpio_keys.c
--- clean/linux-2.6.23-rc5-at91/drivers/input/keyboard/gpio_keys.c	2007-09-01 09:08:24.000000000 +0300
+++ linux-2.6.23-rc5-at91/drivers/input/keyboard/gpio_keys.c	2007-09-18 19:27:25.000000000 +0300
@@ -77,10 +77,16 @@ static int __devinit gpio_keys_probe(str
		int irq = gpio_to_irq(button->gpio);
		unsigned int type = button->type ?: EV_KEY;

-		set_irq_type(irq, IRQ_TYPE_EDGE_BOTH);
-		error = request_irq(irq, gpio_keys_isr, IRQF_SAMPLE_RANDOM,
-				     button->desc ? button->desc : "gpio_keys",
-				     pdev);
+		if (irq < 0) {
+			error = irq;
+			printk(KERN_ERR "gpio-keys: unable to get irq number for GPIO %d; error %d\n",
+				button->gpio, error);
+			goto fail;
+		}
+
+		error = request_irq(irq, gpio_keys_isr, 
+				     IRQF_SAMPLE_RANDOM | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				     button->desc ? button->desc : "gpio_keys", pdev);
		if (error) {
			printk(KERN_ERR "gpio-keys: unable to claim irq %d; error %d\n",
				irq, error);


-- 
Anti Sullin
Embedded Software Engineer
Artec Design LLC
Türi 10C, 11313, Tallinn, Estonia


