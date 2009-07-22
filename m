Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZGVPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZGVPSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZGVPSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:18:44 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37149 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZGVPSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vH5vR/fQh8NaDfya0bOlredcmOXwOzqpWaZBh/3zpzoVnEWhK4ek078baICqSjcfhT
         S3KqUxf+szJoiaZbPyClV+BY6rvYT+gNeRgxVqpFsDNTZuiNPRFOawbjvTBYVSMW8WuJ
         5Tx/IUkrORT74RhxKSTDXmxG502aeAbZ8MPj8=
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>,
       Frans Pop <elendil@planet.nl>
Subject: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Wed, 22 Jul 2009 17:18:39 +0200
Message-Id: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Frans Pop <elendil@planet.nl>
Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
V1->V2: don't remove CONFIG_PM

 drivers/mmc/host/au1xmmc.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index d3f5561..2d4e20f 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1132,12 +1132,12 @@ static int __devexit au1xmmc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int au1xmmc_suspend(struct device *dev)
 {
-	struct au1xmmc_host *host = platform_get_drvdata(pdev);
+	struct au1xmmc_host *host = dev_get_drvdata(dev);
 	int ret;
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc, PMSG_SUSPEND);
 	if (ret)
 		return ret;
 
@@ -1150,27 +1150,33 @@ static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int au1xmmc_resume(struct platform_device *pdev)
+static int au1xmmc_resume(struct device *dev)
 {
-	struct au1xmmc_host *host = platform_get_drvdata(pdev);
+	struct au1xmmc_host *host = dev_get_drvdata(dev);
 
 	au1xmmc_reset_controller(host);
 
 	return mmc_resume_host(host->mmc);
 }
+
+static struct dev_pm_ops au1xmmc_pmops = {
+	.resume		= au1xmmc_resume,
+	.suspend	= au1xmmc_suspend,
+};
+
+#define AU1XMMC_PMOPS &au1xmmc_pmops
+
 #else
-#define au1xmmc_suspend NULL
-#define au1xmmc_resume NULL
+#define AU1XMMC_PMOPS NULL
 #endif
 
 static struct platform_driver au1xmmc_driver = {
 	.probe         = au1xmmc_probe,
 	.remove        = au1xmmc_remove,
-	.suspend       = au1xmmc_suspend,
-	.resume        = au1xmmc_resume,
 	.driver        = {
 		.name  = DRIVER_NAME,
 		.owner = THIS_MODULE,
+		.pm    = AU1XMMC_PMOPS,
 	},
 };
 
-- 
1.6.3.3

