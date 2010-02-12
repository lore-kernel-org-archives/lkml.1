Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0BLJfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:35:47 -0500
Received: from sh.osrg.net ([192.16.179.4]:35896 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0BLJfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:35:43 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       James Bottomley <James.Bottomley@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH -mm 3/7] pci: convert pci_set_dma_mask to call dma_set_mask
Date: Fri, 12 Feb 2010 18:33:28 +0900
Message-Id: <1265967212-9126-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 18:35:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes pci_set_dma_mask to call the generic DMA API,
dma_set_mask.

pci_set_dma_mask (in drivers/pci/pci.c) does the same things that
dma_set_mask does on all the architectures that use pci_set_dma_mask;
calls dma_supprted and sets dev->dma_mask. So we safely change
pci_set_dma_mask to simply call dma_set_mask.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 drivers/pci/pci.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 315fea4..5c881e9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2121,15 +2121,13 @@ void pci_msi_off(struct pci_dev *dev)
 int
 pci_set_dma_mask(struct pci_dev *dev, u64 mask)
 {
-	if (!pci_dma_supported(dev, mask))
-		return -EIO;
-
-	dev->dma_mask = mask;
+	int ret = dma_set_mask(&dev->dev, mask);
+	if (ret)
+		return ret;
 	dev_dbg(&dev->dev, "using %dbit DMA mask\n", fls64(mask));
-
 	return 0;
 }
-    
+
 int
 pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 {
-- 
1.5.6.5

