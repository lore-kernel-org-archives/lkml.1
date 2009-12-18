Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZLRTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZLRTib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZLRThv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:37:51 -0500
Received: from kroah.org ([198.145.64.141]:47463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbZLRTgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:35 -0500
Subject: patch staging-slicoss-use-pci_set_consistent_dma_mask.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:54 -0800
In-Reply-To: <20091218080209.GA4549@coldcone>
Message-ID: <12611648342211@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: slicoss Use pci_set_consistent_dma_mask.

to my gregkh-2.6 tree.  Its filename is

    staging-slicoss-use-pci_set_consistent_dma_mask.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kirjanov@gmail.com  Fri Dec 18 10:34:29 2009
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
Date: Fri, 18 Dec 2009 11:02:09 +0300
Subject: staging: slicoss Use pci_set_consistent_dma_mask.
To: gregkh@suse.de, liodot@gmail.com, charrer@alacritech.com
Cc: devel@linuxdriverproject.org
Message-ID: <20091218080209.GA4549@coldcone>
Content-Disposition: inline


Use pci_set_consistent_dma_mask() in the case of 64-bit consistent allocations.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/staging/slicoss/slicoss.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -366,6 +366,7 @@ static int __devinit slic_entry_probe(st
 	ulong mmio_start = 0;
 	ulong mmio_len = 0;
 	struct sliccard *card = NULL;
+	int pci_using_dac = 0;
 
 	slic_global.dynamic_intagg = dynamic_intagg;
 
@@ -379,16 +380,26 @@ static int __devinit slic_entry_probe(st
 		printk(KERN_DEBUG "%s\n", slic_proc_version);
 	}
 
-	err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64));
-	if (err) {
-		err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
-		if (err)
+	if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+		pci_using_dac = 1;
+		if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+			dev_err(&pcidev->dev, "unable to obtain 64-bit DMA for "
+					"consistent allocations\n");
 			goto err_out_disable_pci;
+		}
+	} else if (pci_set_dma_mask(pcidev, DMA_BIT_MASK(32))) {
+		pci_using_dac = 0;
+		pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
+	} else {
+		dev_err(&pcidev->dev, "no usable DMA configuration\n");
+		goto err_out_disable_pci;
 	}
 
 	err = pci_request_regions(pcidev, DRV_NAME);
-	if (err)
+	if (err) {
+		dev_err(&pcidev->dev, "can't obtain PCI resources\n");
 		goto err_out_disable_pci;
+	}
 
 	pci_set_master(pcidev);
 
@@ -404,6 +415,8 @@ static int __devinit slic_entry_probe(st
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pcidev = pcidev;
+	if (pci_using_dac)
+		netdev->features |= NETIF_F_HIGHDMA;
 
 	mmio_start = pci_resource_start(pcidev, 0);
 	mmio_len = pci_resource_len(pcidev, 0);

