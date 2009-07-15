Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbZGOCTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbZGOCTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZGOCTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:19:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34831 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZGOCTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:19:51 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Richard Purdie <rpurdie@rpsys.net>, Raphael Assenat <raph@8d.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>, gregkh <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jul 2009 07:49:37 +0530
Message-Id: <20090715021934.4169.26505.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 03/06] Fix compilation warning for drivers/leds/leds_gpio.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.4.1 generates the following build warning on i386:

drivers/leds/leds-gpio.c:75: warning: ‘create_gpio_led’ defined but not used
drivers/leds/leds-gpio.c:126: warning: ‘delete_gpio_led’ defined but not used
drivers/leds/leds-gpio.c: In function ‘gpio_led_init’:
drivers/leds/leds-gpio.c:316: warning: ‘ret’ is used uninitialized in this function

Fix them as below:
Put the definitions of create_gpio_led() and delete_gpio_led()
inside
	#ifdef CONFIG_LEDS_GPIO_PLATFORM
when you actually call them inside
	#ifdef CONFIG_LEDS_GPIO_PLATFORM

And the remaining fix is inspired by David Howells fix few days back:
http://lkml.org/lkml/2009/7/9/109,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
---

--- a/drivers/leds/leds-gpio.c	2009-06-29 19:20:42.000000000 +0530
+++ b/drivers/leds/leds-gpio.c	2009-07-15 05:51:21.000000000 +0530
@@ -29,6 +29,7 @@ struct gpio_led_data {
 			unsigned long *delay_on, unsigned long *delay_off);
 };
 
+#ifdef CONFIG_LEDS_GPIO_PLATFORM
 static void gpio_led_work(struct work_struct *work)
 {
 	struct gpio_led_data	*led_dat =
@@ -132,7 +133,6 @@ static void delete_gpio_led(struct gpio_
 	gpio_free(led->gpio);
 }
 
-#ifdef CONFIG_LEDS_GPIO_PLATFORM
 static int __devinit gpio_led_probe(struct platform_device *pdev)
 {
 	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
@@ -298,7 +298,7 @@ static struct of_platform_driver of_gpio
 
 static int __init gpio_led_init(void)
 {
-	int ret;
+	int uninitialized_var(ret);
 
 #ifdef CONFIG_LEDS_GPIO_PLATFORM	
 	ret = platform_driver_register(&gpio_led_driver);

---
Regards--
Subrata

