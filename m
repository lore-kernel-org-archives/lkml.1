Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYCZKYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYCZKYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYCZKYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:24:44 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14389 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYCZKYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:24:43 -0400
X-IronPort-AV: E=Sophos;i="4.25,557,1199682000"; 
   d="scan'208";a="65082739"
From: Bryan Wu <cooloney@kernel.org>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [INPUT/KEYBOARD] Blackfin BF54x: Add infrastructure for keypad wakeups
Date: Wed, 26 Mar 2008 18:24:43 -0700
Message-Id: <1206581083-25045-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
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
1.5.4.3
