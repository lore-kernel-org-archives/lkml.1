Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZJKRGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZJKRGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZJKRGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:06:52 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:52282 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbZJKRGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:06:51 -0400
Date: Mon, 12 Oct 2009 02:05:34 +0900 (JST)
Message-Id: <20091012.020534.137327942.anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 2/3] rtc-ds1742: Fix races around device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Call dev_set_drvdata before rtc device creation
* Use devres APIs and simplify error/remove path

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-ds1742.c |   51 ++++++++++++++-------------------------------
 1 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 0924945..19d2f33 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-#define DRV_VERSION "0.3"
+#define DRV_VERSION "0.4"
 
 #define RTC_SIZE		8
 
@@ -55,7 +55,6 @@ struct rtc_plat_data {
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
 	size_t size;
-	resource_size_t baseaddr;
 	unsigned long last_jiffies;
 	struct bin_attribute nvram_attr;
 };
@@ -163,27 +162,24 @@ static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 	struct rtc_device *rtc;
 	struct resource *res;
 	unsigned int cen, sec;
-	struct rtc_plat_data *pdata = NULL;
-	void __iomem *ioaddr = NULL;
+	struct rtc_plat_data *pdata;
+	void __iomem *ioaddr;
 	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 	pdata->size = res->end - res->start + 1;
-	if (!request_mem_region(res->start, pdata->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	pdata->baseaddr = res->start;
-	ioaddr = ioremap(pdata->baseaddr, pdata->size);
-	if (!ioaddr) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
+		pdev->name))
+		return -EBUSY;
+	ioaddr = devm_ioremap(&pdev->dev, res->start, pdata->size);
+	if (!ioaddr)
+		return -ENOMEM;
+
 	pdata->ioaddr_nvram = ioaddr;
 	pdata->size_nvram = pdata->size - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
@@ -207,31 +203,19 @@ static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 	if (!(readb(ioaddr + RTC_DAY) & RTC_BATT_FLAG))
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
+	pdata->last_jiffies = jiffies;
+	platform_set_drvdata(pdev, pdata);
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &ds1742_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto out;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
-	pdata->last_jiffies = jiffies;
-	platform_set_drvdata(pdev, pdata);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 	if (ret) {
 		dev_err(&pdev->dev, "creating nvram file in sysfs failed\n");
-		goto out;
+		rtc_device_unregister(rtc);
 	}
-
-	return 0;
- out:
-	if (pdata->rtc)
-		rtc_device_unregister(pdata->rtc);
-	if (pdata->ioaddr_nvram)
-		iounmap(pdata->ioaddr_nvram);
-	if (pdata->baseaddr)
-		release_mem_region(pdata->baseaddr, pdata->size);
-	kfree(pdata);
 	return ret;
 }
 
@@ -241,9 +225,6 @@ static int __devexit ds1742_rtc_remove(struct platform_device *pdev)
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	iounmap(pdata->ioaddr_nvram);
-	release_mem_region(pdata->baseaddr, pdata->size);
-	kfree(pdata);
 	return 0;
 }
 
-- 
1.5.6.5


