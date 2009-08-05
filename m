Return-Path: <linux-kernel-owner+w=401wt.eu-S934454AbZHENzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454AbZHENzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934381AbZHENzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:55:35 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:48278 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbZHENzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:55:35 -0400
Date: Wed, 5 Aug 2009 15:55:32 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Ville Syrjala <syrjala@sci.fi>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] w1_gpio: switch to new dev_pm_ops
Message-ID: <20090805135532.GW9464@buzzloop.caiaq.de>
References: <1249476412-27362-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249476412-27362-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 02:46:52PM +0200, Daniel Mack wrote:
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ville Syrjala <syrjala@sci.fi>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> ---
>  drivers/w1/masters/w1-gpio.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)

New version below.

Daniel

>From b7d5b54ccb130a77b2b99c950465dbbc1099504b Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Wed, 5 Aug 2009 14:43:31 +0200
Subject: [PATCH] w1_gpio: switch to new dev_pm_ops

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/w1-gpio.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 6f8866d..6554bd4 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -106,9 +106,9 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_PM
 
-static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
+static int w1_gpio_suspend(struct device *dev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev->platform_data;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -116,9 +116,9 @@ static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int w1_gpio_resume(struct platform_device *pdev)
+static int w1_gpio_resume(struct device *dev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev->platform_data;
 
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

