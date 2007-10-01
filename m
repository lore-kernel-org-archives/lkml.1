Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbXJAP75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbXJAP75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXJAP6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:58:49 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:41665 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbXJAP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:58:48 -0400
Date: Mon, 01 Oct 2007 09:57:54 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 5/6] Xilinxfb: cleanup platform_bus binding to use platform	bus
 API.
In-reply-to: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
Message-id: <20071001155754.6114.6830.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Change the platform bus binding to make use of the established
platform_bus API.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/video/xilinxfb.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 12d9127..e482bb5 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -339,26 +339,24 @@ static int xilinxfb_release(struct device *dev)
  */
 
 static int
-xilinxfb_drv_probe(struct device *dev)
+xilinxfb_platform_probe(struct platform_device *pdev)
 {
-	struct platform_device *pdev;
 	struct xilinxfb_platform_data *pdata;
 	struct resource *res;
 	int width_mm;
 	int height_mm;
 	int rotate;
 
-	pdev = to_platform_device(dev);
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
-		dev_err(dev, "Missing pdata structure\n");
+		dev_err(&pdev->dev, "Missing pdata structure\n");
 		return -ENODEV;
 	}
 
 	/* Find the registers address */
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!res) {
-		dev_err(dev, "Couldn't get registers resource\n");
+		dev_err(&pdev->dev, "Couldn't get registers resource\n");
 		return -ENODEV;
 	}
 
@@ -366,22 +364,24 @@ xilinxfb_drv_probe(struct device *dev)
 	width_mm = pdata->screen_width_mm;
 	rotate = pdata->rotate_screen ? 1 : 0;
 
-	return xilinxfb_assign(dev, res->start, width_mm, height_mm, rotate);
+	return xilinxfb_assign(&pdev->dev, res->start, width_mm, height_mm,
+			       rotate);
 }
 
 static int
-xilinxfb_drv_remove(struct device *dev)
+xilinxfb_platform_remove(struct platform_device *pdev)
 {
-	return xilinxfb_release(dev);
+	return xilinxfb_release(&pdev->dev);
 }
 
 
-static struct device_driver xilinxfb_driver = {
-	.name		= DRIVER_NAME,
-	.bus		= &platform_bus_type,
-
-	.probe		= xilinxfb_drv_probe,
-	.remove		= xilinxfb_drv_remove
+static struct platform_driver xilinxfb_platform_driver = {
+	.probe		= xilinxfb_platform_probe,
+	.remove		= xilinxfb_platform_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRIVER_NAME,
+	},
 };
 
 static int __init
@@ -391,13 +391,13 @@ xilinxfb_init(void)
 	 * No kernel boot options used,
 	 * so we just need to register the driver
 	 */
-	return driver_register(&xilinxfb_driver);
+	return platform_driver_register(&xilinxfb_platform_driver);
 }
 
 static void __exit
 xilinxfb_cleanup(void)
 {
-	driver_unregister(&xilinxfb_driver);
+	platform_driver_unregister(&xilinxfb_platform_driver);
 }
 
 module_init(xilinxfb_init);

