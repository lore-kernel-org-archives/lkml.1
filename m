Return-Path: <linux-kernel-owner+w=401wt.eu-S932426AbYEWCtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbYEWCtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbYEWCss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:48:48 -0400
Received: from ozlabs.org ([203.10.76.45]:59381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761183AbYEWCsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:48:46 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 22 May 2008 21:48:33 -0500
Subject: [PATCH 3/3] virtio: set device index in common code.
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231248.33645.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori points out that three different transports use the virtio code,
but each one keeps its own counter to set the virtio_device's index field.  In
theory (though not in current practice) this means that names could be
duplicated, and that risk grows as more transports are created.

So we move the selection of the unique virtio_device.index into the common code
in virtio.c, which has the side-benefit of removing duplicate code.

The only complexity is that lguest and S/390 use the index to uniquely identify
the device in case of catastrophic failure before register_virtio_device() is
called: now we use the offset within the descriptor page as a unique identifier
for the printks.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
---
 drivers/lguest/lguest_device.c |   23 +++++++++--------------
 drivers/s390/kvm/kvm_virtio.c  |   18 ++++++------------
 drivers/virtio/virtio.c        |    6 ++++++
 drivers/virtio/virtio_pci.c    |    6 ------
 4 files changed, 21 insertions(+), 32 deletions(-)

diff -r 2f0d0ce2adbf drivers/lguest/lguest_device.c
--- a/drivers/lguest/lguest_device.c	Fri May 23 11:55:02 2008 +1000
+++ b/drivers/lguest/lguest_device.c	Fri May 23 12:23:39 2008 +1000
@@ -19,9 +19,6 @@
 
 /* The pointer to our (page) of device descriptions. */
 static void *lguest_devices;
-
-/* Unique numbering for lguest devices. */
-static unsigned int dev_index;
 
 /* For Guests, device memory can be used as normal memory, so we cast away the
  * __iomem to quieten sparse. */
@@ -325,8 +322,10 @@ static struct device lguest_root = {
  * As Andrew Tridgell says, "Untested code is buggy code".
  *
  * It's worth reading this carefully: we start with a pointer to the new device
- * descriptor in the "lguest_devices" page. */
-static void add_lguest_device(struct lguest_device_desc *d)
+ * descriptor in the "lguest_devices" page, and the offset into the device
+ * descriptor page so we can uniquely identify it if things go badly wrong. */
+static void add_lguest_device(struct lguest_device_desc *d,
+			      unsigned int offset)
 {
 	struct lguest_device *ldev;
 
@@ -334,18 +333,14 @@ static void add_lguest_device(struct lgu
 	 * it. */
 	ldev = kzalloc(sizeof(*ldev), GFP_KERNEL);
 	if (!ldev) {
-		printk(KERN_EMERG "Cannot allocate lguest dev %u\n",
-		       dev_index++);
+		printk(KERN_EMERG "Cannot allocate lguest dev %u type %u\n",
+		       offset, d->type);
 		return;
 	}
 
 	/* This devices' parent is the lguest/ dir. */
 	ldev->vdev.dev.parent = &lguest_root;
 	/* We have a unique device index thanks to the dev_index counter. */
-	ldev->vdev.index = dev_index++;
-	/* The device type comes straight from the descriptor.  There's also a
-	 * device vendor field in the virtio_device struct, which we leave as
-	 * 0. */
 	ldev->vdev.id.device = d->type;
 	/* We have a simple set of routines for querying the device's
 	 * configuration information and setting its status. */
@@ -357,8 +352,8 @@ static void add_lguest_device(struct lgu
 	 * virtio_device and calls device_register().  This makes the bus
 	 * infrastructure look for a matching driver. */
 	if (register_virtio_device(&ldev->vdev) != 0) {
-		printk(KERN_ERR "Failed to register lguest device %u\n",
-		       ldev->vdev.index);
+		printk(KERN_ERR "Failed to register lguest dev %u type %u\n",
+		       offset, d->type);
 		kfree(ldev);
 	}
 }
@@ -379,7 +374,7 @@ static void scan_devices(void)
 			break;
 
 		printk("Device at %i has size %u\n", i, desc_size(d));
-		add_lguest_device(d);
+		add_lguest_device(d, i);
 	}
 }
 
diff -r 2f0d0ce2adbf drivers/s390/kvm/kvm_virtio.c
--- a/drivers/s390/kvm/kvm_virtio.c	Fri May 23 11:55:02 2008 +1000
+++ b/drivers/s390/kvm/kvm_virtio.c	Fri May 23 12:23:39 2008 +1000
@@ -30,11 +30,6 @@
  * The pointer to our (page) of device descriptions.
  */
 static void *kvm_devices;
-
-/*
- * Unique numbering for kvm devices.
- */
-static unsigned int dev_index;
 
 struct kvm_device {
 	struct virtio_device vdev;
@@ -250,26 +245,25 @@ static struct device kvm_root = {
  * adds a new device and register it with virtio
  * appropriate drivers are loaded by the device model
  */
-static void add_kvm_device(struct kvm_device_desc *d)
+static void add_kvm_device(struct kvm_device_desc *d, unsigned int offset)
 {
 	struct kvm_device *kdev;
 
 	kdev = kzalloc(sizeof(*kdev), GFP_KERNEL);
 	if (!kdev) {
-		printk(KERN_EMERG "Cannot allocate kvm dev %u\n",
-		       dev_index++);
+		printk(KERN_EMERG "Cannot allocate kvm dev %u type %u\n",
+		       offset, d->type);
 		return;
 	}
 
 	kdev->vdev.dev.parent = &kvm_root;
-	kdev->vdev.index = dev_index++;
 	kdev->vdev.id.device = d->type;
 	kdev->vdev.config = &kvm_vq_configspace_ops;
 	kdev->desc = d;
 
 	if (register_virtio_device(&kdev->vdev) != 0) {
-		printk(KERN_ERR "Failed to register kvm device %u\n",
-		       kdev->vdev.index);
+		printk(KERN_ERR "Failed to register kvm device %u type %u\n",
+		       offset, d->type);
 		kfree(kdev);
 	}
 }
@@ -289,7 +283,7 @@ static void scan_devices(void)
 		if (d->type == 0)
 			break;
 
-		add_kvm_device(d);
+		add_kvm_device(d, i);
 	}
 }
 
diff -r 2f0d0ce2adbf drivers/virtio/virtio.c
--- a/drivers/virtio/virtio.c	Fri May 23 11:55:02 2008 +1000
+++ b/drivers/virtio/virtio.c	Fri May 23 12:23:39 2008 +1000
@@ -1,6 +1,9 @@
 #include <linux/virtio.h>
 #include <linux/spinlock.h>
 #include <linux/virtio_config.h>
+
+/* Unique numbering for virtio devices. */
+static unsigned int dev_index;
 
 static ssize_t device_show(struct device *_d,
 			   struct device_attribute *attr, char *buf)
@@ -166,7 +169,10 @@ int register_virtio_device(struct virtio
 	int err;
 
 	dev->dev.bus = &virtio_bus;
+
+	/* Assign a unique device index and hence name. */
+	dev->index = dev_index++;
 	sprintf(dev->dev.bus_id, "virtio%u", dev->index);
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
diff -r 2f0d0ce2adbf drivers/virtio/virtio_pci.c
--- a/drivers/virtio/virtio_pci.c	Fri May 23 11:55:02 2008 +1000
+++ b/drivers/virtio/virtio_pci.c	Fri May 23 12:23:39 2008 +1000
@@ -77,9 +77,6 @@ static struct device virtio_pci_root = {
 	.parent		= NULL,
 	.bus_id		= "virtio-pci",
 };
-
-/* Unique numbering for devices under the kvm root */
-static unsigned int dev_index;
 
 /* Convert a generic virtio device to our structure */
 static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
@@ -325,9 +322,6 @@ static int __devinit virtio_pci_probe(st
 	if (vp_dev == NULL)
 		return -ENOMEM;
 
-	vp_dev->vdev.index = dev_index;
-	dev_index++;
-
 	vp_dev->vdev.dev.parent = &virtio_pci_root;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;

