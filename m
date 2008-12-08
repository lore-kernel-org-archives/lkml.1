Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYLHLzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYLHLzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbYLHLvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:51:05 -0500
Received: from mail06.svc.cra.dublin.eircom.net ([159.134.118.22]:32619 "HELO
	mail06.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755240AbYLHLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:51:03 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Jiri Slaby <jirislaby@gmail.com>,
       Greg KH <gregkh@suse.de>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 2/2] virtio: do not statically allocate root device
Date: Mon,  8 Dec 2008 11:49:40 +0000
Message-Id: <1228736980-19539-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1228736980-19539-1-git-send-email-markmc@redhat.com>
References: <20081205184603.GC13133@suse.de>
 <1228736980-19539-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently we shouldn't be statically allocating the root device
object, so dynamically allocate it instead.

Also add a release() function to avoid this warning:

  Device 'virtio-pci' does not have a release() function, it is broken and must be fixed

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
---
 drivers/virtio/virtio_pci.c |   48 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 265fdf2..939e0b4 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -73,10 +73,42 @@ MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
 /* A PCI device has it's own struct device and so does a virtio device so
  * we create a place for the virtio devices to show up in sysfs.  I think it
  * would make more sense for virtio to not insist on having it's own device. */
-static struct device virtio_pci_root = {
-	.parent		= NULL,
-	.init_name	= "virtio-pci",
-};
+static struct device *virtio_pci_root;
+
+static void virtio_pci_release_root(struct device *root)
+{
+	kfree(root);
+}
+
+static int virtio_pci_init_root(void)
+{
+	struct device *root;
+	int err = -ENOMEM;
+
+	root = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (root == NULL)
+		goto out;
+
+	err = dev_set_name(root, "virtio-pci");
+	if (err)
+		goto free_root;
+
+	err = device_register(root);
+	if (err)
+		goto free_root;
+
+	root->parent  = NULL;
+	root->release = virtio_pci_release_root;
+
+	virtio_pci_root = root;
+
+	return 0;
+
+free_root:
+	kfree(root);
+out:
+	return err;
+}
 
 /* Convert a generic virtio device to our structure */
 static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
@@ -343,7 +375,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	if (vp_dev == NULL)
 		return -ENOMEM;
 
-	vp_dev->vdev.dev.parent = &virtio_pci_root;
+	vp_dev->vdev.dev.parent = virtio_pci_root;
 	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
@@ -437,13 +469,13 @@ static int __init virtio_pci_init(void)
 {
 	int err;
 
-	err = device_register(&virtio_pci_root);
+	err = virtio_pci_init_root();
 	if (err)
 		return err;
 
 	err = pci_register_driver(&virtio_pci_driver);
 	if (err)
-		device_unregister(&virtio_pci_root);
+		device_unregister(virtio_pci_root);
 
 	return err;
 }
@@ -452,8 +484,8 @@ module_init(virtio_pci_init);
 
 static void __exit virtio_pci_exit(void)
 {
-	device_unregister(&virtio_pci_root);
 	pci_unregister_driver(&virtio_pci_driver);
+	device_unregister(virtio_pci_root);
 }
 
 module_exit(virtio_pci_exit);
-- 
1.5.4.3

