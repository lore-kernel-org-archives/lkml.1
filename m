Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYG0GjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYG0GjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbYG0Giu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:38:50 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbYG0Git (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=bBWkcnQxxpJQ6Nt9FYQODZfbHMns2msf1lyhX1LDRuKxa3lngDvKg8ZWWVphXfolgH
         8+gMRm7KJCPMmMN0djzF+g/crshg647429xAISIEcQppIrsed0COHLE4eZEVDBiJtxPs
         eSWOp+pWk2AtzKQxS1fTPQ9haa5U0eHsdqJv4=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <bryan.wu@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/8] [Blackfin] RTC driver: Fix bug Only RTC interrupt can wake up deeper sleep core.
Date: Sun, 27 Jul 2008 14:38:21 +0800
Message-Id: <1217140707-21263-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
References: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 48ada59..a568d29 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -430,6 +430,30 @@ static int __devexit bfin_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+#ifdef PM_WAKEUP_SIC_IWR
+	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
+#endif
+	bfin_rtc_reset(&pdev->dev);
+#ifdef PM_WAKEUP_SIC_IWR
+	bfin_write_RTC_SWCNT(10);
+	bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
+#endif
+	return 0;
+}
+
+static int bfin_rtc_resume(struct platform_device *pdev)
+{
+#ifdef PM_WAKEUP_SIC_IWR
+	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
+	bfin_rtc_int_clear(rtc, RTC_ISTAT_STOPWATCH);
+#endif
+	return 0;
+}
+#endif
+
 static struct platform_driver bfin_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-bfin",
@@ -437,6 +461,10 @@ static struct platform_driver bfin_rtc_driver = {
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= __devexit_p(bfin_rtc_remove),
+#ifdef CONFIG_PM
+	.suspend	= bfin_rtc_suspend,
+	.resume		= bfin_rtc_resume,
+#endif
 };
 
 static int __init bfin_rtc_init(void)
-- 
1.5.6

