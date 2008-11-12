Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYKLMX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYKLMX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYKLMWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:22:43 -0500
Received: from ozlabs.org ([203.10.76.45]:36463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbYKLMWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:22:41 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 12 Nov 2008 06:22:38 -0600
Cc: Hollis Blanchard <hollisb@us.ibm.com>, aliguori@us.ibm.com,
       markmc@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 3/7] virtio: Don't use PAGE_SIZE for vring alignment in virtio_pci.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122252.38378.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That doesn't work for non-4k guests which are now appearing.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_pci.c |    5 +++--
 include/linux/virtio_pci.h  |    4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -r c6f6a3ab173b drivers/virtio/virtio_pci.c
--- a/drivers/virtio/virtio_pci.c	Wed Nov 12 21:51:09 2008 +1030
+++ b/drivers/virtio/virtio_pci.c	Wed Nov 12 21:57:25 2008 +1030
@@ -216,7 +216,7 @@
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_vq_info *info;
 	struct virtqueue *vq;
-	unsigned long flags;
+	unsigned long flags, size;
 	u16 num;
 	int err;
 
@@ -237,7 +237,8 @@
 	info->queue_index = index;
 	info->num = num;
 
-	info->queue = kzalloc(PAGE_ALIGN(vring_size(num,PAGE_SIZE)), GFP_KERNEL);
+	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
+	info->queue = kzalloc(size, GFP_KERNEL);
 	if (info->queue == NULL) {
 		err = -ENOMEM;
 		goto out_info;
diff -r c6f6a3ab173b include/linux/virtio_pci.h
--- a/include/linux/virtio_pci.h	Wed Nov 12 21:51:09 2008 +1030
+++ b/include/linux/virtio_pci.h	Wed Nov 12 21:57:25 2008 +1030
@@ -57,4 +57,8 @@
 /* How many bits to shift physical queue address written to QUEUE_PFN.
  * 12 is historical, and due to x86 page size. */
 #define VIRTIO_PCI_QUEUE_ADDR_SHIFT	12
+
+/* The alignment to use between consumer and producer parts of vring.
+ * x86 pagesize again. */
+#define VIRTIO_PCI_VRING_ALIGN		4096
 #endif


