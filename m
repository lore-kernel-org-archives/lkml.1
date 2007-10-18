Return-Path: <linux-kernel-owner+w=401wt.eu-S932916AbXJRAQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbXJRAQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762687AbXJRAPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:15:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:40642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762679AbXJRAPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:15:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="249617425"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH 2/5] I/OAT: clean up of dca provider start and stop
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com,
       randy.dunlap@oracle.com
Date: Wed, 17 Oct 2007 17:14:23 -0700
Message-ID: <20071018001423.31147.82007.stgit@localhost.localdomain>
In-Reply-To: <20071018001416.31147.86176.stgit@localhost.localdomain>
References: <20071018001416.31147.86176.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't start ioat_dca if ioat_dma didn't start, and then stop ioat_dca
before stopping ioat_dma.  Since the ioat_dma side does the pci device
work, This takes care of ioat_dca trying to use a bad device reference.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat.c     |   11 +++++------
 drivers/dma/ioat_dma.c |    4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index 54fdeb7..a45872f 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -71,7 +71,7 @@ static int ioat_setup_functionality(struct pci_dev *pdev, void __iomem *iobase)
 	switch (version) {
 	case IOAT_VER_1_2:
 		device->dma = ioat_dma_probe(pdev, iobase);
-		if (ioat_dca_enabled)
+		if (device->dma && ioat_dca_enabled)
 			device->dca = ioat_dca_init(pdev, iobase);
 		break;
 	default:
@@ -85,17 +85,16 @@ static void ioat_shutdown_functionality(struct pci_dev *pdev)
 {
 	struct ioat_device *device = pci_get_drvdata(pdev);
 
-	if (device->dma) {
-		ioat_dma_remove(device->dma);
-		device->dma = NULL;
-	}
-
 	if (device->dca) {
 		unregister_dca_provider(device->dca);
 		free_dca_provider(device->dca);
 		device->dca = NULL;
 	}
 
+	if (device->dma) {
+		ioat_dma_remove(device->dma);
+		device->dma = NULL;
+	}
 }
 
 static struct pci_driver ioat_pci_driver = {
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 59d4344..725f83f 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -941,10 +941,10 @@ void ioat_dma_remove(struct ioatdma_device *device)
 	struct dma_chan *chan, *_chan;
 	struct ioat_dma_chan *ioat_chan;
 
-	dma_async_device_unregister(&device->common);
-
 	ioat_dma_remove_interrupts(device);
 
+	dma_async_device_unregister(&device->common);
+
 	pci_pool_destroy(device->dma_pool);
 	pci_pool_destroy(device->completion_pool);
 
