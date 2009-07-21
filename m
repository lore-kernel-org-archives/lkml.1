Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZGUCWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZGUCWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZGUCWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:22:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60142 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZGUCWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:22:02 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Riku Voipio <riku.voipio@iki.fi>, Richard Purdie <rpurdie@rpsys.net>,
       gregkh <gregkh@suse.de>, Raphael Assenat <raph@8d.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jul 2009 07:50:51 +0530
Message-Id: <20090721022051.30530.40861.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 03/06][RESEND] Fix compilation warning for drivers/leds/leds_gpio.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.4.1 generates the following build warning on i386:

drivers/leds/leds-gpio.c:75: warning: 'create_gpio_led' defined but not used
drivers/leds/leds-gpio.c:126: warning: 'delete_gpio_led' defined but not used
drivers/leds/leds-gpio.c: In function 'gpio_led_init':
drivers/leds/leds-gpio.c:316: warning: 'ret' is used uninitialized in this function

Fix them as below:
1) Put the definitions of create_gpio_led() and delete_gpio_led() inside:
	"#ifdef CONFIG_LEDS_GPIO_PLATFORM"
when you are actually using them only inside:
	"#ifdef CONFIG_LEDS_GPIO_PLATFORM"

2) And then initialize "ret = 0", as Ingo suggests:
http://lkml.org/lkml/2009/7/18/89,

This patch is rebased from an earlier version:
http://lkml.org/lkml/2009/7/14/361,

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
+	int ret = 0;
 
 #ifdef CONFIG_LEDS_GPIO_PLATFORM	
 	ret = platform_driver_register(&gpio_led_driver);

---
Regards--
Subrata

