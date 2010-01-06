Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824Ab0AFJvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0AFJvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813Ab0AFJvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:51:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57565 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0AFJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:51:23 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-i2c@vger.kernel.org
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Chaithrika U S <chaithrika@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v3 3/4] i2c: davinci: Add suspend/resume support
Date: Wed,  6 Jan 2010 14:54:59 +0530
Message-Id: <1262769900-2710-4-git-send-email-chaithrika@ti.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1262769900-2710-3-git-send-email-chaithrika@ti.com>
References: <1262769900-2710-1-git-send-email-chaithrika@ti.com>
 <1262769900-2710-2-git-send-email-chaithrika@ti.com>
 <1262769900-2710-3-git-send-email-chaithrika@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend and resume callbacks to DaVinci I2C driver.
This has been tested on DA850/OMAP-L138 EVM. The SoC specific
suspend-to-RAM support patch series [1] is needed to test this feature.

[1] http://linux.davincidsp.com/pipermail/davinci-linux-open-source/
2009-November/016958.html

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/i2c/busses/i2c-davinci.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 81c1049..d2a4844 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -622,6 +622,41 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int davinci_i2c_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct davinci_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
+
+	/* put I2C into reset */
+	davinci_i2c_reset_ctrl(i2c_dev, 0);
+	clk_disable(i2c_dev->clk);
+
+	return 0;
+}
+
+static int davinci_i2c_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct davinci_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
+
+	clk_enable(i2c_dev->clk);
+	/* take I2C out of reset */
+	davinci_i2c_reset_ctrl(i2c_dev, 1);
+
+	return 0;
+}
+
+static struct dev_pm_ops davinci_i2c_pm = {
+	.suspend        = davinci_i2c_suspend,
+	.resume         = davinci_i2c_resume,
+};
+
+#define davinci_i2c_pm_ops (&davinci_i2c_pm)
+#else
+#define davinci_i2c_pm_ops NULL
+#endif
+
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:i2c_davinci");
 
@@ -631,6 +666,7 @@ static struct platform_driver davinci_i2c_driver = {
 	.driver		= {
 		.name	= "i2c_davinci",
 		.owner	= THIS_MODULE,
+		.pm	= davinci_i2c_pm_ops,
 	},
 };
 
-- 
1.5.6

