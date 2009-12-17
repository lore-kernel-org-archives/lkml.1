Return-Path: <linux-kernel-owner+w=401wt.eu-S935366AbZLQMgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366AbZLQMgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbZLQMge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:36:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58057 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764130AbZLQMgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:36:32 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davinci-linux-open-source@linux.davincidsp.com,
       khilman@deeprootsystems.com, Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH 2/2] davinci: MMC: updates to suspend/resume implementation
Date: Thu, 17 Dec 2009 17:45:01 +0530
Message-Id: <1261052101-14409-1-git-send-email-chaithrika@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the suspend and resume callbacks in DaVinci MMC
host controller driver.

Tested on DA850/OMAP-L138 EVM. This testing requires patches
which add suspend-to-RAM support to DA850/OMAP-L138 SoC[1].

[1]http://linux.davincidsp.com/pipermail/davinci-linux-open-source/
2009-September/016118.html

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies to Linus' kernel tree.

 drivers/mmc/host/davinci_mmc.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 25645bf..7d05cc1 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -170,6 +170,7 @@ struct mmc_davinci_host {
 #define DAVINCI_MMC_DATADIR_READ	1
 #define DAVINCI_MMC_DATADIR_WRITE	2
 	unsigned char data_dir;
+	unsigned char suspended;
 
 	/* buffer is used during PIO of one scatterlist segment, and
 	 * is updated along with buffer_bytes_left.  bytes_left applies
@@ -1300,15 +1301,41 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
 static int davinci_mmcsd_suspend(struct platform_device *pdev, pm_message_t msg)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
+	int ret;
 
-	return mmc_suspend_host(host->mmc, msg);
+	mmc_host_enable(host->mmc);
+	ret = mmc_suspend_host(host->mmc, msg);
+	if (!ret) {
+		writel(0, host->base + DAVINCI_MMCIM);
+		mmc_davinci_reset_ctrl(host, 1);
+		mmc_host_disable(host->mmc);
+		clk_disable(host->clk);
+		host->suspended = 1;
+	} else {
+		host->suspended = 0;
+		mmc_host_disable(host->mmc);
+	}
+
+	return ret;
 }
 
 static int davinci_mmcsd_resume(struct platform_device *pdev)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
+	int ret;
 
-	return mmc_resume_host(host->mmc);
+	if (!host->suspended)
+		return 0;
+
+	clk_enable(host->clk);
+	mmc_host_enable(host->mmc);
+
+	mmc_davinci_reset_ctrl(host, 0);
+	ret = mmc_resume_host(host->mmc);
+	if (!ret)
+		host->suspended = 0;
+
+	return ret;
 }
 #else
 #define davinci_mmcsd_suspend	NULL
-- 
1.5.6

