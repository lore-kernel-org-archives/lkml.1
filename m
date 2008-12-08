Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYLHL4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYLHL4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbYLHLvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:51:08 -0500
Received: from mail14.svc.cra.dublin.eircom.net ([159.134.118.30]:32603 "HELO
	mail14.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757488AbYLHLvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:51:04 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Jiri Slaby <jirislaby@gmail.com>,
       Greg KH <gregkh@suse.de>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/2] virtio: add PCI device release() function
Date: Mon,  8 Dec 2008 11:49:39 +0000
Message-Id: <1228736980-19539-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20081205184603.GC13133@suse.de>
References: <20081205184603.GC13133@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a release() function for virtio_pci devices so as to avoid:

  Device 'virtio0' does not have a release() function, it is broken and must be fixed

Move the code to free the resources associated with the device
from virtio_pci_remove() into this new function. virtio_pci_remove()
now merely unregisters the device which should cause the final
ref to be dropped and virtio_pci_release_dev() to be called.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: Anthony Liguori <aliguori@us.ibm.com>
---
 drivers/virtio/virtio_pci.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 7462a51..265fdf2 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -307,6 +307,20 @@ static struct virtio_config_ops virtio_pci_config_ops = {
 	.finalize_features = vp_finalize_features,
 };
 
+static void virtio_pci_release_dev(struct device *_d)
+{
+	struct virtio_device *dev = container_of(_d, struct virtio_device, dev);
+	struct virtio_pci_device *vp_dev = to_vp_device(dev);
+	struct pci_dev *pci_dev = vp_dev->pci_dev;
+
+	free_irq(pci_dev->irq, vp_dev);
+	pci_set_drvdata(pci_dev, NULL);
+	pci_iounmap(pci_dev, vp_dev->ioaddr);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	kfree(vp_dev);
+}
+
 /* the PCI probing function */
 static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 				      const struct pci_device_id *id)
@@ -330,6 +344,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 
 	vp_dev->vdev.dev.parent = &virtio_pci_root;
+	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
 	INIT_LIST_HEAD(&vp_dev->virtqueues);
@@ -389,12 +404,6 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 
 	unregister_virtio_device(&vp_dev->vdev);
-	free_irq(pci_dev->irq, vp_dev);
-	pci_set_drvdata(pci_dev, NULL);
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
-	kfree(vp_dev);
 }
 
 #ifdef CONFIG_PM
-- 
1.5.4.3

