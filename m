Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750Ab0AEULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0AEULl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730Ab0AEULd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:11:33 -0500
Received: from kroah.org ([198.145.64.141]:49977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab0AEUGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:13 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200301.449062585@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Roger Oksanen <roger.oksanen@cs.helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [19/39] e100: Use pci pool to work around GFP_ATOMIC order 5 memory allocation failure
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>

commit 98468efddb101f8a29af974101c17ba513b07be1 upstream.

pci_alloc_consistent uses GFP_ATOMIC allocation that may fail on some systems
with limited memory (Bug #14265). pci_pool_alloc allows waiting with
GFP_KERNEL.

Tested-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e100.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -156,6 +156,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/mii.h>
@@ -601,6 +602,7 @@ struct nic {
 	struct mem *mem;
 	dma_addr_t dma_addr;
 
+	struct pci_pool *cbs_pool;
 	dma_addr_t cbs_dma_addr;
 	u8 adaptive_ifs;
 	u8 tx_threshold;
@@ -1779,9 +1781,7 @@ static void e100_clean_cbs(struct nic *n
 			nic->cb_to_clean = nic->cb_to_clean->next;
 			nic->cbs_avail++;
 		}
-		pci_free_consistent(nic->pdev,
-			sizeof(struct cb) * nic->params.cbs.count,
-			nic->cbs, nic->cbs_dma_addr);
+		pci_pool_free(nic->cbs_pool, nic->cbs, nic->cbs_dma_addr);
 		nic->cbs = NULL;
 		nic->cbs_avail = 0;
 	}
@@ -1799,8 +1799,8 @@ static int e100_alloc_cbs(struct nic *ni
 	nic->cb_to_use = nic->cb_to_send = nic->cb_to_clean = NULL;
 	nic->cbs_avail = 0;
 
-	nic->cbs = pci_alloc_consistent(nic->pdev,
-		sizeof(struct cb) * count, &nic->cbs_dma_addr);
+	nic->cbs = pci_pool_alloc(nic->cbs_pool, GFP_KERNEL,
+				  &nic->cbs_dma_addr);
 	if (!nic->cbs)
 		return -ENOMEM;
 
@@ -2827,7 +2827,11 @@ static int __devinit e100_probe(struct p
 		DPRINTK(PROBE, ERR, "Cannot register net device, aborting.\n");
 		goto err_out_free;
 	}
-
+	nic->cbs_pool = pci_pool_create(netdev->name,
+			   nic->pdev,
+			   nic->params.cbs.count * sizeof(struct cb),
+			   sizeof(u32),
+			   0);
 	DPRINTK(PROBE, INFO, "addr 0x%llx, irq %d, MAC addr %pM\n",
 		(unsigned long long)pci_resource_start(pdev, use_io ? 1 : 0),
 		pdev->irq, netdev->dev_addr);
@@ -2857,6 +2861,7 @@ static void __devexit e100_remove(struct
 		unregister_netdev(netdev);
 		e100_free(nic);
 		pci_iounmap(pdev, nic->csr);
+		pci_pool_destroy(nic->cbs_pool);
 		free_netdev(netdev);
 		pci_release_regions(pdev);
 		pci_disable_device(pdev);


