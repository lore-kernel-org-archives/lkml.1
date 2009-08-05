Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZHES36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZHES36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZHES35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:29:57 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38167 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZHES3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:29:54 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Phil Blundell <pb@handhelds.org>, linux-input@vger.kernel.org
Subject: [PATCH 4/5] input: gpio-keys: switch to new dev_pm_ops
Date: Wed,  5 Aug 2009 20:29:30 +0200
Message-Id: <1249496971-9019-4-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249496971-9019-3-git-send-email-daniel@caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
 <1249496971-9019-2-git-send-email-daniel@caiaq.de>
 <1249496971-9019-3-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Phil Blundell <pb@handhelds.org>
Cc: linux-input@vger.kernel.org
---
 drivers/input/keyboard/gpio_keys.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index efed0c9..bfb6fc3 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -216,12 +216,12 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 
 
 #ifdef CONFIG_PM
-static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
+static int gpio_keys_suspend(struct device *dev)
 {
-	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_keys_platform_data *pdata = dev->platform_data;
 	int i;
 
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
 			if (button->wakeup) {
@@ -234,12 +234,12 @@ static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int gpio_keys_resume(struct platform_device *pdev)
+static int gpio_keys_resume(struct device *dev)
 {
-	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_keys_platform_data *pdata = dev->platform_data;
 	int i;
 
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
 			if (button->wakeup) {
@@ -251,19 +251,27 @@ static int gpio_keys_resume(struct platform_device *pdev)
 
 	return 0;
 }
+
+static struct dev_pm_ops gpio_keys_pm_ops = {
+	.suspend	= gpio_keys_suspend,
+	.freeze		= gpio_keys_suspend,
+	.resume		= gpio_keys_resume,
+	.thaw		= gpio_keys_resume,
+};
+
+#define GPIO_KEYS_PM_OPS (&gpio_keys_pm_ops)
+
 #else
-#define gpio_keys_suspend	NULL
-#define gpio_keys_resume	NULL
+#define GPIO_KEYS_PM_OPS NULL
 #endif
 
 static struct platform_driver gpio_keys_device_driver = {
 	.probe		= gpio_keys_probe,
 	.remove		= __devexit_p(gpio_keys_remove),
-	.suspend	= gpio_keys_suspend,
-	.resume		= gpio_keys_resume,
 	.driver		= {
 		.name	= "gpio-keys",
 		.owner	= THIS_MODULE,
+		.pm	= GPIO_KEYS_PM_OPS,
 	}
 };
 
-- 
1.6.3.3

