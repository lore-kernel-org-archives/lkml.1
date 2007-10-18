Return-Path: <linux-kernel-owner+w=401wt.eu-S1764737AbXJRBAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764737AbXJRBAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760501AbXJRBAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:00:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:60187 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006AbXJRBAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:00:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="176989968"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH 1/5] I/OAT: cleanup pci issues
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com, davem@davemloft.net
Date: Wed, 17 Oct 2007 18:00:23 -0700
Message-ID: <20071018010023.32161.15960.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder the pci release actions
    Letting go of the resources in the right order helps get rid of
    occasional kernel complaints.

Fix the pci_driver object name [Randy Dunlap]
    Rename the struct pci_driver data so that false section mismatch
    warnings won't be produced.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat.c     |   23 ++++++-----------------
 drivers/dma/ioat_dma.c |    5 ++++-
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index f7276bf..54fdeb7 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -55,9 +55,7 @@ struct ioat_device {
 
 static int __devinit ioat_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
-#ifdef IOAT_DMA_REMOVE
 static void __devexit ioat_remove(struct pci_dev *pdev);
-#endif
 
 static int ioat_dca_enabled = 1;
 module_param(ioat_dca_enabled, int, 0644);
@@ -100,14 +98,12 @@ static void ioat_shutdown_functionality(struct pci_dev *pdev)
 
 }
 
-static struct pci_driver ioat_pci_drv = {
+static struct pci_driver ioat_pci_driver = {
 	.name		= "ioatdma",
 	.id_table	= ioat_pci_tbl,
 	.probe		= ioat_probe,
 	.shutdown	= ioat_shutdown_functionality,
-#ifdef IOAT_DMA_REMOVE
 	.remove		= __devexit_p(ioat_remove),
-#endif
 };
 
 static int __devinit ioat_probe(struct pci_dev *pdev,
@@ -122,7 +118,7 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_enable_device;
 
-	err = pci_request_regions(pdev, ioat_pci_drv.name);
+	err = pci_request_regions(pdev, ioat_pci_driver.name);
 	if (err)
 		goto err_request_regions;
 
@@ -176,13 +172,11 @@ err_enable_device:
 	return err;
 }
 
-#ifdef IOAT_DMA_REMOVE
 /*
  * It is unsafe to remove this module: if removed while a requested
  * dma is outstanding, esp. from tcp, it is possible to hang while
- * waiting for something that will never finish, thus hanging at
- * least one cpu.  However, if you're feeling lucky and need to do
- * some testing, this usually works just fine.
+ * waiting for something that will never finish.  However, if you're
+ * feeling lucky, this usually works just fine.
  */
 static void __devexit ioat_remove(struct pci_dev *pdev)
 {
@@ -191,21 +185,16 @@ static void __devexit ioat_remove(struct pci_dev *pdev)
 	ioat_shutdown_functionality(pdev);
 
 	kfree(device);
-
-	iounmap(device->iobase);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 }
-#endif
 
 static int __init ioat_init_module(void)
 {
-	return pci_register_driver(&ioat_pci_drv);
+	return pci_register_driver(&ioat_pci_driver);
 }
 module_init(ioat_init_module);
 
 static void __exit ioat_exit_module(void)
 {
-	pci_unregister_driver(&ioat_pci_drv);
+	pci_unregister_driver(&ioat_pci_driver);
 }
 module_exit(ioat_exit_module);
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 66c5bb5..59d4344 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -931,7 +931,6 @@ err_completion_pool:
 err_dma_pool:
 	kfree(device);
 err_kzalloc:
-	iounmap(iobase);
 	dev_err(&device->pdev->dev,
 		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
 	return NULL;
@@ -949,6 +948,10 @@ void ioat_dma_remove(struct ioatdma_device *device)
 	pci_pool_destroy(device->dma_pool);
 	pci_pool_destroy(device->completion_pool);
 
+	iounmap(device->reg_base);
+	pci_release_regions(device->pdev);
+	pci_disable_device(device->pdev);
+
 	list_for_each_entry_safe(chan, _chan,
 				 &device->common.channels, device_node) {
 		ioat_chan = to_ioat_chan(chan);
