Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXA2SPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXA2SPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXA2SPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:15:40 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:21079 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXA2SPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:15:39 -0500
Date: Mon, 29 Jan 2007 20:15:23 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH] fix I/OAT for kexec
Message-ID: <20070129181522.GA17362@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Under kexec, I/OAT initialization breaks over busy resources
because the previous kernel did not release them.

I'm not sure this fix can be considered a complete one but 
it works for me. I guess something similar to the *_remove
method should occur there..


Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 8e87261..9a50701 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -42,6 +42,7 @@ #define to_ioat_desc(lh) container_of(lh
 
 /* internal functions */
 static int __devinit ioat_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void ioat_shutdown(struct pci_dev *pdev);
 static void __devexit ioat_remove(struct pci_dev *pdev);
 
 static int enumerate_dma_channels(struct ioat_device *device)
@@ -560,6 +561,7 @@ static struct pci_driver ioat_pci_drv = 
 	.name 	= "ioatdma",
 	.id_table = ioat_pci_tbl,
 	.probe	= ioat_probe,
+	.shutdown = ioat_shutdown,
 	.remove	= __devexit_p(ioat_remove),
 };
 
@@ -787,9 +789,20 @@ err_request_regions:
 err_set_dma_mask:
 	pci_disable_device(pdev);
 err_enable_device:
+
+	printk(KERN_ERR "Intel(R) I/OAT DMA Engine initialization failed\n");
+
 	return err;
 }
 
+static void ioat_shutdown(struct pci_dev *pdev)
+{
+	struct ioat_device *device;
+	device = pci_get_drvdata(pdev);
+
+	dma_async_device_unregister(&device->common);
+}
+
 static void __devexit ioat_remove(struct pci_dev *pdev)
 {
 	struct ioat_device *device;



-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
