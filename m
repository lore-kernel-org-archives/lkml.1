Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYG0Gjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYG0Gjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758799AbYG0Gi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:38:57 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795AbYG0Gi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=wLssKduqykI+NTzBE0fDu3tBPHy/zDHqyJOQi5jOlu6rIZkzPndytpH+DFCz7BRlKO
         JnV3lBMdbytfqA6x0ZhAJa22AdCknA00p6oDISVMd7vY8MzNAYUhaZtafnRMVoqvlgHV
         3ZEJgVohuSfcnBRQdKvUpx1qXG6IMrr/UEnsM=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <bryan.wu@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/8] [Blackfin] RTC driver: add support for power management framework
Date: Sun, 27 Jul 2008 14:38:22 +0800
Message-Id: <1217140707-21263-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
References: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index a568d29..23b991d 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -2,7 +2,7 @@
  * Blackfin On-Chip Real Time Clock Driver
  *  Supports BF52[257]/BF53[123]/BF53[467]/BF54[24789]
  *
- * Copyright 2004-2007 Analog Devices Inc.
+ * Copyright 2004-2008 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -412,6 +412,8 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	return 0;
 
  err:
@@ -433,25 +435,28 @@ static int __devexit bfin_rtc_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-#ifdef PM_WAKEUP_SIC_IWR
 	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
-#endif
-	bfin_rtc_reset(&pdev->dev);
-#ifdef PM_WAKEUP_SIC_IWR
-	bfin_write_RTC_SWCNT(10);
-	bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
-#endif
+
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(IRQ_RTC);
+	else
+		bfin_rtc_int_clear(rtc, -1);
+
 	return 0;
 }
 
 static int bfin_rtc_resume(struct platform_device *pdev)
 {
-#ifdef PM_WAKEUP_SIC_IWR
-	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
-	bfin_rtc_int_clear(rtc, RTC_ISTAT_STOPWATCH);
-#endif
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(IRQ_RTC);
+	else
+		bfin_write_RTC_ISTAT(-1);
+
 	return 0;
 }
+#else
+# define bfin_rtc_suspend NULL
+# define bfin_rtc_resume  NULL
 #endif
 
 static struct platform_driver bfin_rtc_driver = {
@@ -461,10 +466,8 @@ static struct platform_driver bfin_rtc_driver = {
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= __devexit_p(bfin_rtc_remove),
-#ifdef CONFIG_PM
 	.suspend	= bfin_rtc_suspend,
 	.resume		= bfin_rtc_resume,
-#endif
 };
 
 static int __init bfin_rtc_init(void)
-- 
1.5.6

