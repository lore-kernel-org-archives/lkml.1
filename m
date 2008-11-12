Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYKLMX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYKLMX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYKLMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:23:08 -0500
Received: from ozlabs.org ([203.10.76.45]:36480 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYKLMXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:23:07 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 12 Nov 2008 06:23:02 -0600
Cc: Hollis Blanchard <hollisb@us.ibm.com>, aliguori@us.ibm.com,
       markmc@redhat.com, kvm@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5/7] virtio: use KVM_S390_VIRTIO_RING_ALIGN instead of relying on pagesize
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122253.02759.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't really matter, since s390 pagesize is 4k anyway.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/s390/include/asm/kvm_virtio.h |    3 +++
 drivers/s390/kvm/kvm_virtio.c      |    9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -r 5c9c0cc58458 arch/s390/include/asm/kvm_virtio.h
--- a/arch/s390/include/asm/kvm_virtio.h	Wed Nov 12 22:05:59 2008 +1030
+++ b/arch/s390/include/asm/kvm_virtio.h	Wed Nov 12 22:10:29 2008 +1030
@@ -50,6 +50,9 @@
 #define KVM_S390_VIRTIO_RESET		1
 #define KVM_S390_VIRTIO_SET_STATUS	2
 
+/* Overkill: we have the consumer and producer writing to separate pages. */
+#define KVM_S390_VIRTIO_RING_ALIGN	4096
+
 #ifdef __KERNEL__
 /* early virtio console setup */
 #ifdef CONFIG_S390_GUEST
diff -r 5c9c0cc58458 drivers/s390/kvm/kvm_virtio.c
--- a/drivers/s390/kvm/kvm_virtio.c	Wed Nov 12 22:05:59 2008 +1030
+++ b/drivers/s390/kvm/kvm_virtio.c	Wed Nov 12 22:10:29 2008 +1030
@@ -188,7 +188,8 @@
 	config = kvm_vq_config(kdev->desc)+index;
 
 	err = vmem_add_mapping(config->address,
-			       vring_size(config->num, PAGE_SIZE));
+			       vring_size(config->num,
+					  KVM_S390_VIRTIO_RING_ALIGN));
 	if (err)
 		goto out;
 
@@ -209,7 +210,8 @@
 	return vq;
 unmap:
 	vmem_remove_mapping(config->address,
-			    vring_size(config->num, PAGE_SIZE));
+			    vring_size(config->num,
+				       KVM_S390_VIRTIO_RING_ALIGN));
 out:
 	return ERR_PTR(err);
 }
@@ -220,7 +222,8 @@
 
 	vring_del_virtqueue(vq);
 	vmem_remove_mapping(config->address,
-			    vring_size(config->num, PAGE_SIZE));
+			    vring_size(config->num,
+				       KVM_S390_VIRTIO_RING_ALIGN));
 }
 
 /*


