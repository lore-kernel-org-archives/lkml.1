Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbXLMGhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbXLMGhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbXLMGgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:36:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56216 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbXLMGgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:36:46 -0500
Date: Wed, 12 Dec 2007 22:33:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       chrisw@sous-sol.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, csnook@redhat.com,
       kronos.it@gmail.com, Jay Cliburn <jacliburn@bellsouth.net>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 01/36] atl1: disable broken 64-bit DMA
Message-ID: <20071213063348.GB25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atl1-disable-broken-64-bit-dma.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Luca Tettamanti <kronos.it@gmail.com>

atl1: disable broken 64-bit DMA

[ Upstream commit: 5f08e46b621a769e52a9545a23ab1d5fb2aec1d4 ]

The L1 network chip can DMA to 64-bit addresses, but multiple descriptor
rings share a single register for the high 32 bits of their address, so
only a single, aligned, 4 GB physical address range can be used at a time.
As a result, we need to confine the driver to a 32-bit DMA mask, otherwise
we see occasional data corruption errors in systems containing 4 or more
gigabytes of RAM.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Acked-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/atl1/atl1_main.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -2097,21 +2097,26 @@ static int __devinit atl1_probe(struct p
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
@@ -2176,7 +2181,6 @@ static int __devinit atl1_probe(struct p
 
 	netdev->ethtool_ops = &atl1_ethtool_ops;
 	adapter->bd_number = cards_found;
-	adapter->pci_using_64 = pci_using_64;
 
 	/* setup the private structure */
 	err = atl1_sw_init(adapter);
@@ -2193,9 +2197,6 @@ static int __devinit atl1_probe(struct p
 	 */
 	/* netdev->features |= NETIF_F_TSO; */
 
-	if (pci_using_64)
-		netdev->features |= NETIF_F_HIGHDMA;
-
 	netdev->features |= NETIF_F_LLTX;
 
 	/*

-- 
