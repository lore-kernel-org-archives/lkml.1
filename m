Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZJOFXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZJOFXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZJOFXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:23:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33071 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZJOFXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:23:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] twl4030-gpio: drop __devexit markings from remove func
Date: Thu, 15 Oct 2009 01:22:56 -0400
Message-Id: <1255584176-3457-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio_twl4030_probe() function calls gpio_twl4030_remove(), and the
former has __devinit, so the latter cannot use __devexit.  Otherwise we
hit the section mismatch warning:

WARNING: drivers/gpio/built-in.o(.devinit.text+0x71a): Section mismatch
	in reference from the function _gpio_twl4030_probe() to the function
	.devexit.text:_gpio_twl4030_remove()
The function __devinit _gpio_twl4030_probe() references a function
	__devexit _gpio_twl4030_remove().
This is often seen when error handling in the init function uses
	functionality in the exit path.
The fix is often to remove the __devexit annotation of
	_gpio_twl4030_remove() so it may be used outside an exit section.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/gpio/twl4030-gpio.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/twl4030-gpio.c b/drivers/gpio/twl4030-gpio.c
index afad147..49384a7 100644
--- a/drivers/gpio/twl4030-gpio.c
+++ b/drivers/gpio/twl4030-gpio.c
@@ -460,7 +460,8 @@ no_irqs:
 	return ret;
 }
 
-static int __devexit gpio_twl4030_remove(struct platform_device *pdev)
+/* Cannot use __devexit as gpio_twl4030_probe() calls us */
+static int gpio_twl4030_remove(struct platform_device *pdev)
 {
 	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int status;
@@ -493,7 +494,7 @@ static struct platform_driver gpio_twl4030_driver = {
 	.driver.name	= "twl4030_gpio",
 	.driver.owner	= THIS_MODULE,
 	.probe		= gpio_twl4030_probe,
-	.remove		= __devexit_p(gpio_twl4030_remove),
+	.remove		= gpio_twl4030_remove,
 };
 
 static int __init gpio_twl4030_init(void)
-- 
1.6.5

