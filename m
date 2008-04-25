Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYDYDz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYDYDz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYDYDzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:55:50 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:8754 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbYDYDzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:55:49 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67099514"
From: Bryan Wu <cooloney@kernel.org>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [INPUT/KEYBOARD] Blackfin BF54x: Add infrastructure for keypad wakeups
Date: Fri, 25 Apr 2008 11:55:28 +0800
Message-Id: <1209095728-21119-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/input/keyboard/bf54x-keys.c |   36 ++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 05e3494..2db5d37 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -312,6 +312,8 @@ static int __devinit bfin_kpad_probe(struct platform_device *pdev)
 
 	bfin_write_KPAD_CTL(bfin_read_KPAD_CTL() | KPAD_EN);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	printk(KERN_ERR DRV_NAME
 		": Blackfin BF54x Keypad registered IRQ %d\n", bf54x_kpad->irq);
 
@@ -354,12 +356,40 @@ static int __devexit bfin_kpad_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int bfin_kpad_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
+
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(bf54x_kpad->irq);
+
+	return 0;
+}
+
+static int bfin_kpad_resume(struct platform_device *pdev)
+{
+	struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
+
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(bf54x_kpad->irq);
+
+	return 0;
+}
+#else
+# define bfin_kpad_suspend NULL
+# define bfin_kpad_resume  NULL
+#endif
+
 struct platform_driver bfin_kpad_device_driver = {
-	.probe		= bfin_kpad_probe,
-	.remove		= __devexit_p(bfin_kpad_remove),
 	.driver		= {
 		.name	= DRV_NAME,
-	}
+		.owner	= THIS_MODULE,
+	},
+	.probe		= bfin_kpad_probe,
+	.remove		= __devexit_p(bfin_kpad_remove),
+	.suspend	= bfin_kpad_suspend,
+	.resume		= bfin_kpad_resume,
 };
 
 static int __init bfin_kpad_init(void)
-- 
1.5.5
