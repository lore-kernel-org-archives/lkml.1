Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbYKVAx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbYKVAx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYKVAxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:53:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:19398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbYKVAxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:53:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,648,1220252400"; 
   d="scan'208";a="362951671"
Subject: Re: next-20081121:WARNING: at drivers/dma/dmaengine.c:665
	dma_async_device_unregister()
From: Dan Williams <dan.j.williams@intel.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
In-Reply-To: <a4423d670811210240t77ec97d1pbe1ef0e4ae3a1a2e@mail.gmail.com>
References: <a4423d670811210240t77ec97d1pbe1ef0e4ae3a1a2e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 17:53:44 -0700
Message-Id: <1227315224.32103.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 03:40 -0700, Alexander Beregalov wrote:
> Hi
> 
> It occured during shutdown process:
> 
> sd 0:2:0:0: [sda] Synchronizing SCSI cache
> ioatdma 0000:00:08.0: Removing dma and dca services
> ------------[ cut here ]------------
> WARNING: at drivers/dma/dmaengine.c:665 dma_async_device_unregister+0x90/0xd0()
> dma_async_device_unregister called while 1 clients hold a reference
...
> WARNING: at drivers/base/core.c:122 device_release+0x66/0x68()
> Device 'dma0chan0' does not have a release() function, it is broken and must be
> fixed.

The following fixes these up for me.  Maciej, do these look alright?:

commit 16f5de60e2406c0c879627177aecd7ef489c30e5
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Nov 21 17:48:55 2008 -0700

    dmaengine: add a release for dma class devices
    
    Resolves:
    WARNING: at drivers/base/core.c:122 device_release+0x4d/0x52()
    Device 'dma0chan0' does not have a release() function, it is broken and must be fixed.
    
    Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 6fc6595..94dcc64 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -103,9 +103,16 @@ static struct device_attribute dma_attrs[] = {
 	__ATTR_NULL
 };
 
+static void chan_dev_release(struct device *dev)
+{
+	/* nothing to do */
+	do { } while (0);
+}
+
 static struct class dma_devclass = {
 	.name		= "dma",
 	.dev_attrs	= dma_attrs,
+	.dev_release	= chan_dev_release,
 };
 
 /* --- client and device registration --- */

commit 34323672c38c8e4e8fdd3aa5fa37daa617b51a29
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Nov 21 17:39:18 2008 -0700

    ioat: do not perform removal actions at shutdown
    
    Unregistering services should only happen at "remove" time.  This prevents
    the device from being unregistered while dmaengine clients are still
    active.  Also, the comment on ioat_remove is stale since removal is prevented
    while a channel may be in use.
    
    Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index 9b16a3a..4105d65 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -75,60 +75,10 @@ static int ioat_dca_enabled = 1;
 module_param(ioat_dca_enabled, int, 0644);
 MODULE_PARM_DESC(ioat_dca_enabled, "control support of dca service (default: 1)");
 
-static int ioat_setup_functionality(struct pci_dev *pdev, void __iomem *iobase)
-{
-	struct ioat_device *device = pci_get_drvdata(pdev);
-	u8 version;
-	int err = 0;
-
-	version = readb(iobase + IOAT_VER_OFFSET);
-	switch (version) {
-	case IOAT_VER_1_2:
-		device->dma = ioat_dma_probe(pdev, iobase);
-		if (device->dma && ioat_dca_enabled)
-			device->dca = ioat_dca_init(pdev, iobase);
-		break;
-	case IOAT_VER_2_0:
-		device->dma = ioat_dma_probe(pdev, iobase);
-		if (device->dma && ioat_dca_enabled)
-			device->dca = ioat2_dca_init(pdev, iobase);
-		break;
-	case IOAT_VER_3_0:
-		device->dma = ioat_dma_probe(pdev, iobase);
-		if (device->dma && ioat_dca_enabled)
-			device->dca = ioat3_dca_init(pdev, iobase);
-		break;
-	default:
-		err = -ENODEV;
-		break;
-	}
-	if (!device->dma)
-		err = -ENODEV;
-	return err;
-}
-
-static void ioat_shutdown_functionality(struct pci_dev *pdev)
-{
-	struct ioat_device *device = pci_get_drvdata(pdev);
-
-	dev_err(&pdev->dev, "Removing dma and dca services\n");
-	if (device->dca) {
-		unregister_dca_provider(device->dca);
-		free_dca_provider(device->dca);
-		device->dca = NULL;
-	}
-
-	if (device->dma) {
-		ioat_dma_remove(device->dma);
-		device->dma = NULL;
-	}
-}
-
 static struct pci_driver ioat_pci_driver = {
 	.name		= "ioatdma",
 	.id_table	= ioat_pci_tbl,
 	.probe		= ioat_probe,
-	.shutdown	= ioat_shutdown_functionality,
 	.remove		= __devexit_p(ioat_remove),
 };
 
@@ -179,7 +129,29 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	err = ioat_setup_functionality(pdev, iobase);
+	switch (readb(iobase + IOAT_VER_OFFSET)) {
+	case IOAT_VER_1_2:
+		device->dma = ioat_dma_probe(pdev, iobase);
+		if (device->dma && ioat_dca_enabled)
+			device->dca = ioat_dca_init(pdev, iobase);
+		break;
+	case IOAT_VER_2_0:
+		device->dma = ioat_dma_probe(pdev, iobase);
+		if (device->dma && ioat_dca_enabled)
+			device->dca = ioat2_dca_init(pdev, iobase);
+		break;
+	case IOAT_VER_3_0:
+		device->dma = ioat_dma_probe(pdev, iobase);
+		if (device->dma && ioat_dca_enabled)
+			device->dca = ioat3_dca_init(pdev, iobase);
+		break;
+	default:
+		err = -ENODEV;
+		break;
+	}
+	if (!device->dma)
+		err = -ENODEV;
+
 	if (err)
 		goto err_version;
 
@@ -198,17 +170,21 @@ err_enable_device:
 	return err;
 }
 
-/*
- * It is unsafe to remove this module: if removed while a requested
- * dma is outstanding, esp. from tcp, it is possible to hang while
- * waiting for something that will never finish.  However, if you're
- * feeling lucky, this usually works just fine.
- */
 static void __devexit ioat_remove(struct pci_dev *pdev)
 {
 	struct ioat_device *device = pci_get_drvdata(pdev);
 
-	ioat_shutdown_functionality(pdev);
+	dev_err(&pdev->dev, "Removing dma and dca services\n");
+	if (device->dca) {
+		unregister_dca_provider(device->dca);
+		free_dca_provider(device->dca);
+		device->dca = NULL;
+	}
+
+	if (device->dma) {
+		ioat_dma_remove(device->dma);
+		device->dma = NULL;
+	}
 
 	kfree(device);
 }


