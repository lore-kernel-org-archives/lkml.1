Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZHMKBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZHMKBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZHMKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:01:50 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:45527 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754057AbZHMKBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:01:48 -0400
Message-Id: <20090813100639.146131879@fluff.org>
References: <20090813100602.545180197@fluff.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:06:08 +0100
From: Ben Dooks <ben@simtec.co.uk>
To: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.ne
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 6/7] spi_s3c24xx: use dev_pm_ops
Content-Disposition: inline; filename=spi-use-pmops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the spi_s3c24xx driver to use dev_pm_ops to avoid the
following warning during probe:

Platform driver 's3c2410-spi' needs updating - please use dev_pm_ops

Signed-off-by: Ben Dooks <ben@simtec.co.uk>

---
 drivers/spi/spi_s3c24xx.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: b/drivers/spi/spi_s3c24xx.c
===================================================================
--- a/drivers/spi/spi_s3c24xx.c	2009-07-28 15:20:16.000000000 +0100
+++ b/drivers/spi/spi_s3c24xx.c	2009-07-28 15:20:22.000000000 +0100
@@ -418,9 +418,9 @@ static int __exit s3c24xx_spi_remove(str
 
 #ifdef CONFIG_PM
 
-static int s3c24xx_spi_suspend(struct platform_device *pdev, pm_message_t msg)
+static int s3c24xx_spi_suspend(struct device *dev)
 {
-	struct s3c24xx_spi *hw = platform_get_drvdata(pdev);
+	struct s3c24xx_spi *hw = platform_get_drvdata(to_platform_device(dev));
 
 	if (hw->pdata && hw->pdata->gpio_setup)
 		hw->pdata->gpio_setup(hw->pdata, 0);
@@ -429,27 +429,31 @@ static int s3c24xx_spi_suspend(struct pl
 	return 0;
 }
 
-static int s3c24xx_spi_resume(struct platform_device *pdev)
+static int s3c24xx_spi_resume(struct device *dev)
 {
-	struct s3c24xx_spi *hw = platform_get_drvdata(pdev);
+	struct s3c24xx_spi *hw = platform_get_drvdata(to_platform_device(dev));
 
 	s3c24xx_spi_initialsetup(hw);
 	return 0;
 }
 
+static struct dev_pm_ops s3c24xx_spi_pmops = {
+	.suspend	= s3c24xx_spi_suspend,
+	.resume		= s3c24xx_spi_resume,
+};
+
+#define S3C24XX_SPI_PMOPS &s3c24xx_spi_pmops
 #else
-#define s3c24xx_spi_suspend NULL
-#define s3c24xx_spi_resume  NULL
-#endif
+#define S3C24XX_SPI_PMOPS NULL
+#endif /* CONFIG_PM */
 
 MODULE_ALIAS("platform:s3c2410-spi");
 static struct platform_driver s3c24xx_spi_driver = {
 	.remove		= __exit_p(s3c24xx_spi_remove),
-	.suspend	= s3c24xx_spi_suspend,
-	.resume		= s3c24xx_spi_resume,
 	.driver		= {
 		.name	= "s3c2410-spi",
 		.owner	= THIS_MODULE,
+		.pm	= S3C24XX_SPI_PMOPS,
 	},
 };
 

-- 
