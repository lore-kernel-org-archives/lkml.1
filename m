Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbZLKBod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbZLKBod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762122AbZLKBob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:44:31 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:53742 "EHLO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbZLKBo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:44:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] dw_dmac.c: remove unnecessary memset() and use resource_size()
Date: Thu, 10 Dec 2009 20:44:32 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB0FCA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] dw_dmac.c: remove unnecessary memset() and use resource_size()
Thread-Index: Acp6A3yWhWAW4PpCRLWLI1+/JddRQw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 11 Dec 2009 01:44:34.0076 (UTC) FILETIME=[7D6545C0:01CA7A03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memset() is unnecessary since kzalloc already zero's the memory.

The platform resource is properly defined so use resource_size()
instead of the magic number DW_REGLEN for the ioremap() and
{request/release}_mem_region().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

---

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2eea823..97ea99a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1265,14 +1265,13 @@ static int __init dw_probe(struct platform_device *pdev)
 	if (!dw)
 		return -ENOMEM;
 
-	if (!request_mem_region(io->start, DW_REGLEN, pdev->dev.driver->name)) {
+	if (!request_mem_region(io->start, resource_size(io),
+				pdev->dev.driver->name)) {
 		err = -EBUSY;
 		goto err_kfree;
 	}
 
-	memset(dw, 0, sizeof *dw);
-
-	dw->regs = ioremap(io->start, DW_REGLEN);
+	dw->regs = ioremap(io->start, resource_size(io));
 	if (!dw->regs) {
 		err = -ENOMEM;
 		goto err_release_r;
@@ -1392,7 +1391,7 @@ static int __exit dw_remove(struct platform_device *pdev)
 	dw->regs = NULL;
 
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(io->start, DW_REGLEN);
+	release_mem_region(io->start, resource_size(io));
 
 	kfree(dw);
  
