Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYKLMYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYKLMYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYKLMXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:23:21 -0500
Received: from ozlabs.org ([203.10.76.45]:36487 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYKLMXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:23:19 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 12 Nov 2008 06:23:16 -0600
Cc: Hollis Blanchard <hollisb@us.ibm.com>, aliguori@us.ibm.com,
       markmc@redhat.com, kvm@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 6/7] virtio: hand virtio ring alignment as argument to vring_new_virtqueue
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122253.16611.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows each virtio user to hand in the alignment appropriate to
their virtio_ring structures.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest_device.c |    4 ++--
 drivers/s390/kvm/kvm_virtio.c  |    3 ++-
 drivers/virtio/virtio_pci.c    |    4 ++--
 drivers/virtio/virtio_ring.c   |    3 ++-
 include/linux/virtio_ring.h    |    1 +
 5 files changed, 9 insertions(+), 6 deletions(-)

diff -r 6ea441813d18 drivers/lguest/lguest_device.c
--- a/drivers/lguest/lguest_device.c	Wed Nov 12 21:57:55 2008 +1030
+++ b/drivers/lguest/lguest_device.c	Wed Nov 12 22:01:45 2008 +1030
@@ -259,8 +259,8 @@
 
 	/* OK, tell virtio_ring.c to set up a virtqueue now we know its size
 	 * and we've got a pointer to its pages. */
-	vq = vring_new_virtqueue(lvq->config.num, vdev, lvq->pages,
-				 lg_notify, callback);
+	vq = vring_new_virtqueue(lvq->config.num, LGUEST_VRING_ALIGN,
+				 vdev, lvq->pages, lg_notify, callback);
 	if (!vq) {
 		err = -ENOMEM;
 		goto unmap;
diff -r 6ea441813d18 drivers/s390/kvm/kvm_virtio.c
--- a/drivers/s390/kvm/kvm_virtio.c	Wed Nov 12 21:57:55 2008 +1030
+++ b/drivers/s390/kvm/kvm_virtio.c	Wed Nov 12 22:01:45 2008 +1030
@@ -192,7 +192,8 @@
 	if (err)
 		goto out;
 
-	vq = vring_new_virtqueue(config->num, vdev, (void *) config->address,
+	vq = vring_new_virtqueue(config->num, KVM_S390_VIRTIO_RING_ALIGN,
+				 vdev, (void *) config->address,
 				 kvm_notify, callback);
 	if (!vq) {
 		err = -ENOMEM;
diff -r 6ea441813d18 drivers/virtio/virtio_pci.c
--- a/drivers/virtio/virtio_pci.c	Wed Nov 12 21:57:55 2008 +1030
+++ b/drivers/virtio/virtio_pci.c	Wed Nov 12 22:01:45 2008 +1030
@@ -249,8 +249,8 @@
 		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	/* create the vring */
-	vq = vring_new_virtqueue(info->num, vdev, info->queue,
-				 vp_notify, callback);
+	vq = vring_new_virtqueue(info->num, VIRTIO_PCI_VRING_ALIGN,
+				 vdev, info->queue, vp_notify, callback);
 	if (!vq) {
 		err = -ENOMEM;
 		goto out_activate_queue;
diff -r 6ea441813d18 drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c	Wed Nov 12 21:57:55 2008 +1030
+++ b/drivers/virtio/virtio_ring.c	Wed Nov 12 22:01:45 2008 +1030
@@ -274,6 +274,7 @@
 };
 
 struct virtqueue *vring_new_virtqueue(unsigned int num,
+				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      void *pages,
 				      void (*notify)(struct virtqueue *),
@@ -292,7 +293,7 @@
 	if (!vq)
 		return NULL;
 
-	vring_init(&vq->vring, num, pages, PAGE_SIZE);
+	vring_init(&vq->vring, num, pages, vring_align);
 	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
 	vq->vq.vq_ops = &vring_vq_ops;
diff -r 6ea441813d18 include/linux/virtio_ring.h
--- a/include/linux/virtio_ring.h	Wed Nov 12 21:57:55 2008 +1030
+++ b/include/linux/virtio_ring.h	Wed Nov 12 22:01:45 2008 +1030
@@ -115,6 +115,7 @@
 struct virtqueue;
 
 struct virtqueue *vring_new_virtqueue(unsigned int num,
+				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      void *pages,
 				      void (*notify)(struct virtqueue *vq),


