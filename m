Return-Path: <linux-kernel-owner+w=401wt.eu-S936792AbZFPF73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936792AbZFPF73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935173AbZFPFvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:25 -0400
Received: from kroah.org ([198.145.64.141]:48400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935845AbZFPFvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/64] eisa: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:26 -0700
Message-Id: <1245131213-24168-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/eisa/pci_eisa.c     |    2 +-
 drivers/eisa/virtual_root.c |    2 +-
 include/linux/eisa.h        |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index 74edb1d..0dd0f63 100644
--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -31,11 +31,11 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
 	}
 
 	pci_eisa_root.dev              = &pdev->dev;
-	pci_eisa_root.dev->driver_data = &pci_eisa_root;
 	pci_eisa_root.res	       = pdev->bus->resource[0];
 	pci_eisa_root.bus_base_addr    = pdev->bus->resource[0]->start;
 	pci_eisa_root.slots	       = EISA_MAX_SLOTS;
 	pci_eisa_root.dma_mask         = pdev->dma_mask;
+	dev_set_drvdata(pci_eisa_root.dev, &pci_eisa_root);
 
 	if (eisa_root_register (&pci_eisa_root)) {
 		printk (KERN_ERR "pci_eisa : Could not register EISA root\n");
diff --git a/drivers/eisa/virtual_root.c b/drivers/eisa/virtual_root.c
index 3074879..535e4f9 100644
--- a/drivers/eisa/virtual_root.c
+++ b/drivers/eisa/virtual_root.c
@@ -57,7 +57,7 @@ static int __init virtual_eisa_root_init (void)
 
 	eisa_bus_root.force_probe = force_probe;
 	
-	eisa_root_dev.dev.driver_data = &eisa_bus_root;
+	dev_set_drvdata(&eisa_root_dev.dev, &eisa_bus_root);
 
 	if (eisa_root_register (&eisa_bus_root)) {
 		/* A real bridge may have been registered before
diff --git a/include/linux/eisa.h b/include/linux/eisa.h
index e61c0be..6925249 100644
--- a/include/linux/eisa.h
+++ b/include/linux/eisa.h
@@ -78,12 +78,12 @@ static inline void eisa_driver_unregister (struct eisa_driver *edrv) { }
 /* Mimics pci.h... */
 static inline void *eisa_get_drvdata (struct eisa_device *edev)
 {
-        return edev->dev.driver_data;
+        return dev_get_drvdata(&edev->dev);
 }
 
 static inline void eisa_set_drvdata (struct eisa_device *edev, void *data)
 {
-        edev->dev.driver_data = data;
+        dev_set_drvdata(&edev->dev, data);
 }
 
 /* The EISA root device. There's rumours about machines with multiple
-- 
1.6.3.2

