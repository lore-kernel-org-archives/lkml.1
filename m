Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbYFFQOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbYFFQOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762807AbYFFQMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:39 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39490 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763003AbYFFQMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:38 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 4/8] atmel_nand: Clean up and fix probe() error path
Date: Fri,  6 Jun 2008 18:04:54 +0200
Message-Id: <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0326 (UTC) FILETIME=[FA2A01E0:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes several bugs in the atmel_nand_probe() error path, including
at least one memory leak.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mtd/nand/atmel_nand.c |   41 ++++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 675a82c..325ce29 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -371,6 +371,12 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 	int num_partitions = 0;
 #endif
 
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		printk(KERN_ERR "atmel_nand: can't get I/O resource mem\n");
+		return -ENXIO;
+	}
+
 	/* Allocate memory for the device structure (and zero it) */
 	host = kzalloc(sizeof(struct atmel_nand_host), GFP_KERNEL);
 	if (!host) {
@@ -378,17 +384,11 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		printk(KERN_ERR "atmel_nand: can't get I/O resource mem\n");
-		return -ENXIO;
-	}
-
 	host->io_base = ioremap(mem->start, mem->end - mem->start + 1);
 	if (host->io_base == NULL) {
 		printk(KERN_ERR "atmel_nand: ioremap failed\n");
-		kfree(host);
-		return -EIO;
+		res = -EIO;
+		goto err_nand_ioremap;
 	}
 
 	mtd = &host->mtd;
@@ -446,14 +446,14 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 		if (gpio_get_value(host->board->det_pin)) {
 			printk ("No SmartMedia card inserted.\n");
 			res = ENXIO;
-			goto out;
+			goto err_no_card;
 		}
 	}
 
 	/* first scan to find the device and get the page size */
 	if (nand_scan_ident(mtd, 1)) {
 		res = -ENXIO;
-		goto out;
+		goto err_scan_ident;
 	}
 
 	if (nand_chip->ecc.mode == NAND_ECC_HW_SYNDROME) {
@@ -498,7 +498,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 	/* second phase scan */
 	if (nand_scan_tail(mtd)) {
 		res = -ENXIO;
-		goto out;
+		goto err_scan_tail;
 	}
 
 #ifdef CONFIG_MTD_PARTITIONS
@@ -514,7 +514,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 	if ((!partitions) || (num_partitions == 0)) {
 		printk(KERN_ERR "atmel_nand: No parititions defined, or unsupported device.\n");
 		res = ENXIO;
-		goto release;
+		goto err_no_partitions;
 	}
 
 	res = add_mtd_partitions(mtd, partitions, num_partitions);
@@ -526,17 +526,19 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 		return res;
 
 #ifdef CONFIG_MTD_PARTITIONS
-release:
+err_no_partitions:
 #endif
 	nand_release(mtd);
-
-out:
-	iounmap(host->ecc);
-
-err_ecc_ioremap:
+err_scan_tail:
+err_scan_ident:
+err_no_card:
 	atmel_nand_disable(host);
 	platform_set_drvdata(pdev, NULL);
+	if (host->ecc)
+		iounmap(host->ecc);
+err_ecc_ioremap:
 	iounmap(host->io_base);
+err_nand_ioremap:
 	kfree(host);
 	return res;
 }
@@ -553,8 +555,9 @@ static int __devexit atmel_nand_remove(struct platform_device *pdev)
 
 	atmel_nand_disable(host);
 
+	if (host->ecc)
+		iounmap(host->ecc);
 	iounmap(host->io_base);
-	iounmap(host->ecc);
 	kfree(host);
 
 	return 0;
-- 
1.5.5.1

