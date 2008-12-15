Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYLONAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYLONAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYLOM75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:59:57 -0500
Received: from mail05.svc.cra.dublin.eircom.net ([159.134.118.21]:40247 "HELO
	mail05.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751004AbYLOM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:59:56 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 2/4] virtio: do not statically allocate root device
Date: Mon, 15 Dec 2008 12:58:27 +0000
Message-Id: <1229345909-27229-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1229345909-27229-1-git-send-email-markmc@redhat.com>
References: <20081212190730.GB2950@kroah.com>
 <1229345909-27229-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't be statically allocating the root device object,
so dynamically allocate it using root_device_register()
instead.

Also avoids this warning from 'rmmod virtio_pci':

  Device 'virtio-pci' does not have a release() function, it is broken and must be fixed

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
---
 drivers/virtio/virtio_pci.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 265fdf2..bef6b45 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -73,10 +73,7 @@ MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
 /* A PCI device has it's own struct device and so does a virtio device so
  * we create a place for the virtio devices to show up in sysfs.  I think it
  * would make more sense for virtio to not insist on having it's own device. */
-static struct device virtio_pci_root = {
-	.parent		= NULL,
-	.init_name	= "virtio-pci",
-};
+static struct device *virtio_pci_root;
 
 /* Convert a generic virtio device to our structure */
 static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
@@ -343,7 +340,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	if (vp_dev == NULL)
 		return -ENOMEM;
 
-	vp_dev->vdev.dev.parent = &virtio_pci_root;
+	vp_dev->vdev.dev.parent = virtio_pci_root;
 	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
@@ -437,13 +434,13 @@ static int __init virtio_pci_init(void)
 {
 	int err;
 
-	err = device_register(&virtio_pci_root);
-	if (err)
-		return err;
+	virtio_pci_root = root_device_register("virtio-pci");
+	if (IS_ERR(virtio_pci_root))
+		return PTR_ERR(virtio_pci_root);
 
 	err = pci_register_driver(&virtio_pci_driver);
 	if (err)
-		device_unregister(&virtio_pci_root);
+		device_unregister(virtio_pci_root);
 
 	return err;
 }
@@ -452,8 +449,8 @@ module_init(virtio_pci_init);
 
 static void __exit virtio_pci_exit(void)
 {
-	device_unregister(&virtio_pci_root);
 	pci_unregister_driver(&virtio_pci_driver);
+	root_device_unregister(virtio_pci_root);
 }
 
 module_exit(virtio_pci_exit);
-- 
1.5.4.3

