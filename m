Return-Path: <linux-kernel-owner+w=401wt.eu-S934283AbZHEMrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283AbZHEMrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbZHEMrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:47:03 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55364 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934256AbZHEMrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:47:01 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Ville Syrjala <syrjala@sci.fi>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 2/2] w1_gpio: switch to new dev_pm_ops
Date: Wed,  5 Aug 2009 14:46:52 +0200
Message-Id: <1249476412-27362-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/w1-gpio.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 6f8866d..4a940fb 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -106,9 +106,9 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_PM
 
-static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
+static int w1_gpio_suspend(struct device *dev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_drvdata(dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -116,9 +116,9 @@ static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int w1_gpio_resume(struct platform_device *pdev)
+static int w1_gpio_resume(struct device *dev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_drvdata(dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
@@ -126,19 +126,24 @@ static int w1_gpio_resume(struct platform_device *pdev)
 	return 0;
 }
 
+static struct dev_pm_ops w1_gpio_pm_ops = {
+	.suspend = w1_gpio_suspend,
+	.resume = w1_gpio_resume,
+};
+
+#define W1_GPIO_PM_OPS (&w1_gpio_pm_ops)
+
 #else
-#define w1_gpio_suspend	NULL
-#define w1_gpio_resume	NULL
+#define W1_GPIO_PM_OPS NULL
 #endif
 
 static struct platform_driver w1_gpio_driver = {
 	.driver = {
 		.name	= "w1-gpio",
 		.owner	= THIS_MODULE,
+		.pm	= W1_GPIO_PM_OPS,
 	},
 	.remove	= __exit_p(w1_gpio_remove),
-	.suspend = w1_gpio_suspend,
-	.resume = w1_gpio_resume,
 };
 
 static int __init w1_gpio_init(void)
-- 
1.6.3.3

