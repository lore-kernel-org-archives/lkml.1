Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbZLNVso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbZLNVso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbZLNVsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:48:36 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:48485 "EHLO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392AbZLNVse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:48:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] orion_nand.c: add error handling and use resource_size()
Date: Mon, 14 Dec 2009 16:48:34 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA65@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] orion_nand.c: add error handling and use resource_size()
Thread-Index: Acp9By9Eyu2wnvO7TfqSSEdOKv9sUQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:48:32.0767 (UTC) FILETIME=[2E4000F0:01CA7D07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use platform_get_resource() to fetch the memory resource and
add error handling for when it is missing. Use resource_size()
for the ioremap().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index f59c074..9903460 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -74,6 +74,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	struct mtd_info *mtd;
 	struct nand_chip *nc;
 	struct orion_nand_data *board;
+	struct resource *res;
 	void __iomem *io_base;
 	int ret = 0;
 #ifdef CONFIG_MTD_PARTITIONS
@@ -89,8 +90,13 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	}
 	mtd = (struct mtd_info *)(nc + 1);
 
-	io_base = ioremap(pdev->resource[0].start,
-			pdev->resource[0].end - pdev->resource[0].start + 1);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -ENODEV;
+		goto no_res;
+	}
+
+	io_base = ioremap(res->start, resource_size(res));
 	if (!io_base) {
 		printk(KERN_ERR "orion_nand: ioremap failed\n");
 		ret = -EIO; 
