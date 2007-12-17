Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbXLQQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbXLQQRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXLQQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:17:12 -0500
Received: from wombat.diezmil.com ([209.190.27.106]:34419 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbXLQQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:17:12 -0500
Date: Mon, 17 Dec 2007 11:17:10 -0500
Message-ID: <12954112.1197908230928.JavaMail.root@wombat.diezmil.com>
From: shyam_iyer@dell.com
Reply-To: shyam_iyer@dell.com
To: linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
In-Reply-To: <9170930.1197891872373.JavaMail.root@wombat.diezmil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that the patch Robert has provided hasn't gone into 2.6.24-rc5 so maybe it is not working.

At the same time I did apply a small patch to 2.6.24-rc5 that seems to fix the issue.

I feel this could just be added to 2.6.24-rc5 without Robert's patch because of Jeff Garzik's" sata_nv: don't use legacy DMA in ADMA mode (v3)" patch.

It doesn't work without this patch because there is an allocation of memory from  hpriv before the mask can be set.

Please review.

Signed-off-by: Shyam Iyer

--- sata_nv.c.orig	2007-12-17 21:08:12.000000000 +0530
+++ sata_nv.c	2007-12-17 21:08:25.000000000 +0530
@@ -2407,6 +2407,12 @@
 			type = GENERIC;
 	}
 
+	/* set 64bit dma masks, may fail */
+	if (type == ADMA) {
+		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0)
+			pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	}
+
 	ppi[0] = &nv_port_info[type];
 	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
 	if (rc)
@@ -2418,12 +2424,6 @@
 	hpriv->type = type;
 	host->private_data = hpriv;
 
-	/* set 64bit dma masks, may fail */
-	if (type == ADMA) {
-		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0)
-			pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-	}
-
 	/* request and iomap NV_MMIO_BAR */
 	rc = pcim_iomap_regions(pdev, 1 << NV_MMIO_BAR, DRV_NAME);
 	if (rc)


--
This message was sent on behalf of shyam_iyer@dell.com at openSubscriber.com
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/8211470.html
