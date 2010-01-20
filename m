Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234Ab0ATARb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0ATARb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421Ab0ATARa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:17:30 -0500
Received: from [206.15.93.42] ([206.15.93.42]:21119 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754188Ab0ATAR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:17:29 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com
Subject: [PATCH] rtc-ep93xx.c: cleanup probe/remove routines
Date: Tue, 19 Jan 2010 17:17:35 -0700
Cc: a.zummo@towertech.it, p_gortmaker@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001191717.35708.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix issue with rtc device not getting unregistered in probe error path.

Use the devres managed resource functions in the probe routine to
cleanup the error path.

Use sysfs_{create/remove}_group to add/remove the sysfs files.

Reduces the text size by 132 bytes, increases data by 12 bytes:
    text	   data	    bss	    dec	    hex	filename
-    937	    124	      0	   1061	    425	rtc-ep93xx.o
+    805	    136	      0	    941	    3ad	rtc-ep93xx.o

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>

---

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 9da02d1..91bde97 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -115,6 +115,15 @@ static ssize_t ep93xx_rtc_show_comp_delete(struct device *dev,
 }
 static DEVICE_ATTR(comp_delete, S_IRUGO, ep93xx_rtc_show_comp_delete, NULL);
 
+static struct attribute *ep93xx_rtc_attrs[] = {
+	&dev_attr_comp_preload.attr,
+	&dev_attr_comp_delete.attr,
+	NULL
+};
+
+static const struct attribute_group ep93xx_rtc_sysfs_files = {
+	.attrs	= ep93xx_rtc_attrs,
+};
 
 static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 {
@@ -123,27 +132,22 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 	struct rtc_device *rtc;
 	int err;
 
-	ep93xx_rtc = kzalloc(sizeof(struct ep93xx_rtc), GFP_KERNEL);
-	if (ep93xx_rtc == NULL)
+	ep93xx_rtc = devm_kzalloc(&pdev->dev, sizeof(*ep93xx_rtc), GFP_KERNEL);
+	if (!ep93xx_rtc)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		err = -ENXIO;
-		goto fail_free;
-	}
+	if (!res)
+		return -ENXIO;
 
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (res == NULL) {
-		err = -EBUSY;
-		goto fail_free;
-	}
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				     resource_size(res), pdev->name))
+		return -EBUSY;
 
-	ep93xx_rtc->mmio_base = ioremap(res->start, resource_size(res));
-	if (ep93xx_rtc->mmio_base == NULL) {
-		err = -ENXIO;
-		goto fail;
-	}
+	ep93xx_rtc->mmio_base = devm_ioremap(&pdev->dev, res->start,
+					     resource_size(res));
+	if (!ep93xx_rtc->mmio_base)
+		return -ENXIO;
 
 	pdev->dev.platform_data = ep93xx_rtc;
 
@@ -151,53 +155,34 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		err = PTR_ERR(rtc);
-		goto fail;
+		goto exit;
 	}
 
 	platform_set_drvdata(pdev, rtc);
 
-	err = device_create_file(&pdev->dev, &dev_attr_comp_preload);
+	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	if (err)
 		goto fail;
-	err = device_create_file(&pdev->dev, &dev_attr_comp_delete);
-	if (err) {
-		device_remove_file(&pdev->dev, &dev_attr_comp_preload);
-		goto fail;
-	}
 
 	return 0;
 
 fail:
-	if (ep93xx_rtc->mmio_base) {
-		iounmap(ep93xx_rtc->mmio_base);
-		pdev->dev.platform_data = NULL;
-	}
-	release_mem_region(res->start, resource_size(res));
-fail_free:
-	kfree(ep93xx_rtc);
+	platform_set_drvdata(pdev, NULL);
+	rtc_device_unregister(rtc);
+exit:
+	pdev->dev.platform_data = NULL;
 	return err;
 }
 
 static int __exit ep93xx_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct ep93xx_rtc *ep93xx_rtc = pdev->dev.platform_data;
-	struct resource *res;
-
-	/* cleanup sysfs */
-	device_remove_file(&pdev->dev, &dev_attr_comp_delete);
-	device_remove_file(&pdev->dev, &dev_attr_comp_preload);
 
+	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
+	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(rtc);
-
-	iounmap(ep93xx_rtc->mmio_base);
 	pdev->dev.platform_data = NULL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
