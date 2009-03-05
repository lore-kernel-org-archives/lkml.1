Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZCEX66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZCEX66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZCEX6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:58:44 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:52943 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755950AbZCEX6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:58:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mtd: plat_nand: add platform probe/remove callbacks
Date: Thu, 5 Mar 2009 18:58:12 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909013B7114@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mtd: plat_nand: add platform probe/remove callbacks
Thread-Index: Acmd7j4oCoWej2IDQqOIqGQ4v5RlKw==
From: "hartleys" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mtd@lists.infradead.org>, "Alexander Clouter" <alex@digriz.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>, <vitalywool@gmail.com>
X-OriginalArrivalTime: 05 Mar 2009 23:58:39.0666 (UTC) FILETIME=[4E354120:01C99DEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optional probe and remove callbacks to the plat_nand driver.

Some platforms may require additional setup, such as configuring
the memory controller, before the nand device can be accessed.
This patch provides an optional callback to handle this setup as
well as a callback to teardown the setup.

This patch was originally submitted to linux-mtd but it was
suggested I post it here for a broader review.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Tested-By: Alexander Clouter <alex@digriz.org.uk>

---

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 75f9f48..600fbe9 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -70,6 +70,13 @@ static int __init plat_nand_probe(struct
platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
+	/* Handle any platform specific setup */
+	if (pdata->ctrl.probe) {
+		res = pdata->ctrl.probe(pdev);
+		if (res)
+			goto out;
+	}
+
 	/* Scan to find existance of the device */
 	if (nand_scan(&data->mtd, 1)) {
 		res = -ENXIO;
@@ -99,6 +106,8 @@ static int __init plat_nand_probe(struct
platform_device *pdev)
 
 	nand_release(&data->mtd);
 out:
+	if (pdata->ctrl.remove)
+		pdata->ctrl.remove(pdev);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(data->io_base);
 	kfree(data);
@@ -111,15 +120,15 @@ out:
 static int __devexit plat_nand_remove(struct platform_device *pdev)
 {
 	struct plat_nand_data *data = platform_get_drvdata(pdev);
-#ifdef CONFIG_MTD_PARTITIONS
 	struct platform_nand_data *pdata = pdev->dev.platform_data;
-#endif
 
 	nand_release(&data->mtd);
 #ifdef CONFIG_MTD_PARTITIONS
 	if (data->parts && data->parts != pdata->chip.partitions)
 		kfree(data->parts);
 #endif
+	if (pdata->ctrl.remove)
+		pdata->ctrl.remove(pdev);
 	iounmap(data->io_base);
 	kfree(data);
 
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index db5b63d..4c88163 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -577,8 +577,13 @@ struct platform_nand_chip {
 	void			*priv;
 };
 
+/* Keep gcc happy */
+struct platform_device;
+
 /**
  * struct platform_nand_ctrl - controller level device structure
+ * @probe:		platform specific function to probe/setup
hardware
+ * @remove:		platform specific function to remove/teardown
hardware
  * @hwcontrol:		platform specific hardware control structure
  * @dev_ready:		platform specific function to read ready/busy
pin
  * @select_chip:	platform specific chip select function
@@ -589,6 +594,8 @@ struct platform_nand_chip {
  * All fields are optional and depend on the hardware driver
requirements
  */
 struct platform_nand_ctrl {
+	int		(*probe)(struct platform_device *pdev);
+	void		(*remove)(struct platform_device *pdev);
 	void		(*hwcontrol)(struct mtd_info *mtd, int cmd);
 	int		(*dev_ready)(struct mtd_info *mtd);
 	void		(*select_chip)(struct mtd_info *mtd, int chip); 
