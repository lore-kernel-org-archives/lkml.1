Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbXKXTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbXKXTU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 14:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXKXTUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 14:20:22 -0500
Received: from fmailhost01.isp.att.net ([204.127.217.101]:45791 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXKXTUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 14:20:21 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2007 14:20:21 EST
X-Originating-IP: [70.152.123.66]
Date: Sat, 24 Nov 2007 13:15:18 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: greg@kroah.com, chrisw@sous-sol.org
Cc: csnook@redhat.com, kronos.it@gmail.com, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [2.6.22.y][PATCH] atl1: disable broken 64-bit DMA
Message-ID: <20071124191518.GA3672@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atl1: disable broken 64-bit DMA

[ Upstream commit: 5f08e46b621a769e52a9545a23ab1d5fb2aec1d4 ]

The L1 network chip can DMA to 64-bit addresses, but multiple descriptor
rings share a single register for the high 32 bits of their address, so
only a single, aligned, 4 GB physical address range can be used at a time.
As a result, we need to confine the driver to a 32-bit DMA mask, otherwise
we see occasional data corruption errors in systems containing 4 or more
gigabytes of RAM.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Luca Tettamanti <kronos.it@gmail.com>
Cc: Chris Snook <csnook@redhat.com>
---
 drivers/net/atl1/atl1_main.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 6862c11..1b7a5a8 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -2097,21 +2097,26 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct atl1_adapter *adapter;
 	static int cards_found = 0;
-	bool pci_using_64 = true;
 	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	/*
+	 * The atl1 chip can DMA to 64-bit addresses, but it uses a single
+	 * shared register for the high 32 bits, so only a single, aligned,
+	 * 4 GB physical address range can be used at a time.
+	 *
+	 * Supporting 64-bit DMA on this hardware is more trouble than it's
+	 * worth.  It is far easier to limit to 32-bit DMA than update
+	 * various kernel subsystems to support the mechanics required by a
+	 * fixed-high-32-bit system.
+	 */
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		if (err) {
-			dev_err(&pdev->dev, "no usable DMA configuration\n");
-			goto err_dma;
-		}
-		pci_using_64 = false;
+		dev_err(&pdev->dev, "no usable DMA configuration\n");
+		goto err_dma;
 	}
 	/* Mark all PCI regions associated with PCI device
 	 * pdev as being reserved by owner atl1_driver_name
@@ -2176,7 +2181,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 
 	netdev->ethtool_ops = &atl1_ethtool_ops;
 	adapter->bd_number = cards_found;
-	adapter->pci_using_64 = pci_using_64;
 
 	/* setup the private structure */
 	err = atl1_sw_init(adapter);
@@ -2193,9 +2197,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	 */
 	/* netdev->features |= NETIF_F_TSO; */
 
-	if (pci_using_64)
-		netdev->features |= NETIF_F_HIGHDMA;
-
 	netdev->features |= NETIF_F_LLTX;
 
 	/*
-- 
1.5.3.3

