Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZHPJcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZHPJcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZHPJcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45372 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbZHPJaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/48] KVM: move coalesced_mmio locking to its own device
Date: Sun, 16 Aug 2009 12:29:56 +0300
Message-Id: <1250415008-17175-37-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Move coalesced_mmio locking to its own device, instead of relying on
kvm->lock.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/coalesced_mmio.c |   10 ++++------
 virt/kvm/coalesced_mmio.h |    1 +
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 7549068..397f419 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -31,10 +31,6 @@ static int coalesced_mmio_in_range(struct kvm_io_device *this,
 	if (!is_write)
 		return 0;
 
-	/* kvm->lock is taken by the caller and must be not released before
-         * dev.read/write
-         */
-
 	/* Are we able to batch it ? */
 
 	/* last is the first free entry
@@ -43,7 +39,7 @@ static int coalesced_mmio_in_range(struct kvm_io_device *this,
 	 */
 	ring = dev->kvm->coalesced_mmio_ring;
 	avail = (ring->first - ring->last - 1) % KVM_COALESCED_MMIO_MAX;
-	if (avail < 1) {
+	if (avail < KVM_MAX_VCPUS) {
 		/* full */
 		return 0;
 	}
@@ -70,7 +66,7 @@ static void coalesced_mmio_write(struct kvm_io_device *this,
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
 
-	/* kvm->lock must be taken by caller before call to in_range()*/
+	spin_lock(&dev->lock);
 
 	/* copy data in first free entry of the ring */
 
@@ -79,6 +75,7 @@ static void coalesced_mmio_write(struct kvm_io_device *this,
 	memcpy(ring->coalesced_mmio[ring->last].data, val, len);
 	smp_wmb();
 	ring->last = (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
+	spin_unlock(&dev->lock);
 }
 
 static void coalesced_mmio_destructor(struct kvm_io_device *this)
@@ -101,6 +98,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
+	spin_lock_init(&dev->lock);
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index 5ac0ec6..4b49f27 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -12,6 +12,7 @@
 struct kvm_coalesced_mmio_dev {
 	struct kvm_io_device dev;
 	struct kvm *kvm;
+	spinlock_t lock;
 	int nb_zones;
 	struct kvm_coalesced_mmio_zone zone[KVM_COALESCED_MMIO_ZONE_MAX];
 };
-- 
1.6.3.3

