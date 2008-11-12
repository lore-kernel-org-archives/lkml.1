Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYKLMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYKLMXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYKLMWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:22:51 -0500
Received: from ozlabs.org ([203.10.76.45]:36470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYKLMWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:22:50 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 12 Nov 2008 06:22:46 -0600
Cc: Hollis Blanchard <hollisb@us.ibm.com>, aliguori@us.ibm.com,
       markmc@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 4/7] virtio: use LGUEST_VRING_ALIGN instead of relying on pagesize
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122252.47195.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't really matter, since lguest is i386 only at the moment,
but we could actually choose a different value.  (lguest doesn't have
a guarenteed ABI).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c   |    6 +++---
 drivers/lguest/lguest_device.c  |    2 +-
 include/linux/lguest_launcher.h |    2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -r c6744f753314 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Wed Nov 12 22:02:52 2008 +1030
+++ b/Documentation/lguest/lguest.c	Wed Nov 12 22:11:03 2008 +1030
@@ -1030,7 +1030,7 @@
 		/* Zero out the virtqueues. */
 		for (vq = dev->vq; vq; vq = vq->next) {
 			memset(vq->vring.desc, 0,
-			       vring_size(vq->config.num, getpagesize()));
+			       vring_size(vq->config.num, LGUEST_VRING_ALIGN));
 			lg_last_avail(vq) = 0;
 		}
 	} else if (dev->desc->status & VIRTIO_CONFIG_S_FAILED) {
@@ -1211,7 +1211,7 @@
 	void *p;
 
 	/* First we need some memory for this virtqueue. */
-	pages = (vring_size(num_descs, getpagesize()) + getpagesize() - 1)
+	pages = (vring_size(num_descs, LGUEST_VRING_ALIGN) + getpagesize() - 1)
 		/ getpagesize();
 	p = get_pages(pages);
 
@@ -1228,7 +1228,7 @@
 	vq->config.pfn = to_guest_phys(p) / getpagesize();
 
 	/* Initialize the vring. */
-	vring_init(&vq->vring, num_descs, p, getpagesize());
+	vring_init(&vq->vring, num_descs, p, LGUEST_VRING_ALIGN);
 
 	/* Append virtqueue to this device's descriptor.  We use
 	 * device_config() to get the end of the device's current virtqueues;
diff -r c6744f753314 drivers/lguest/lguest_device.c
--- a/drivers/lguest/lguest_device.c	Wed Nov 12 22:02:52 2008 +1030
+++ b/drivers/lguest/lguest_device.c	Wed Nov 12 22:11:03 2008 +1030
@@ -250,7 +250,7 @@
 	/* Figure out how many pages the ring will take, and map that memory */
 	lvq->pages = lguest_map((unsigned long)lvq->config.pfn << PAGE_SHIFT,
 				DIV_ROUND_UP(vring_size(lvq->config.num,
-							PAGE_SIZE),
+							LGUEST_VRING_ALIGN),
 					     PAGE_SIZE));
 	if (!lvq->pages) {
 		err = -ENOMEM;
diff -r c6744f753314 include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h	Wed Nov 12 22:02:52 2008 +1030
+++ b/include/linux/lguest_launcher.h	Wed Nov 12 22:11:03 2008 +1030
@@ -59,4 +59,6 @@
 	LHREQ_IRQ, /* + irq */
 	LHREQ_BREAK, /* + on/off flag (on blocks until someone does off) */
 };
+
+#define LGUEST_VRING_ALIGN	4096
 #endif /* _LINUX_LGUEST_LAUNCHER */


