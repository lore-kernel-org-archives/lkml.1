Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab0BJR0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:26:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/40] KVM: avoid taking ioapic mutex for non-ioapic EOIs
Date: Wed, 10 Feb 2010 19:23:08 +0200
Message-Id: <1265822589-11155-40-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the guest acknowledges an interrupt, it sends an EOI message to the local
apic, which broadcasts it to the ioapic.  To handle the EOI, we need to take
the ioapic mutex.

On large guests, this causes a lot of contention on this mutex.  Since large
guests usually don't route interrupts via the ioapic (they use msi instead),
this is completely unnecessary.

Avoid taking the mutex by introducing a handled_vectors bitmap.  Before taking
the mutex, check if the ioapic was actually responsible for the acked vector.
If not, we can return early.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 virt/kvm/ioapic.c |   19 +++++++++++++++++++
 virt/kvm/ioapic.h |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index f01392f..a2edfd1 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -100,6 +100,19 @@ static int ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
 	return injected;
 }
 
+static void update_handled_vectors(struct kvm_ioapic *ioapic)
+{
+	DECLARE_BITMAP(handled_vectors, 256);
+	int i;
+
+	memset(handled_vectors, 0, sizeof(handled_vectors));
+	for (i = 0; i < IOAPIC_NUM_PINS; ++i)
+		__set_bit(ioapic->redirtbl[i].fields.vector, handled_vectors);
+	memcpy(ioapic->handled_vectors, handled_vectors,
+	       sizeof(handled_vectors));
+	smp_wmb();
+}
+
 static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 {
 	unsigned index;
@@ -134,6 +147,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			e->bits |= (u32) val;
 			e->fields.remote_irr = 0;
 		}
+		update_handled_vectors(ioapic);
 		mask_after = e->fields.mask;
 		if (mask_before != mask_after)
 			kvm_fire_mask_notifiers(ioapic->kvm, index, mask_after);
@@ -241,6 +255,9 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode)
 {
 	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
 
+	smp_rmb();
+	if (!test_bit(vector, ioapic->handled_vectors))
+		return;
 	mutex_lock(&ioapic->lock);
 	__kvm_ioapic_update_eoi(ioapic, vector, trigger_mode);
 	mutex_unlock(&ioapic->lock);
@@ -352,6 +369,7 @@ void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
 	ioapic->ioregsel = 0;
 	ioapic->irr = 0;
 	ioapic->id = 0;
+	update_handled_vectors(ioapic);
 }
 
 static const struct kvm_io_device_ops ioapic_mmio_ops = {
@@ -401,6 +419,7 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
 
 	mutex_lock(&ioapic->lock);
 	memcpy(ioapic, state, sizeof(struct kvm_ioapic_state));
+	update_handled_vectors(ioapic);
 	mutex_unlock(&ioapic->lock);
 	return 0;
 }
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 419c43b..a505ce9 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -46,6 +46,7 @@ struct kvm_ioapic {
 	struct kvm *kvm;
 	void (*ack_notifier)(void *opaque, int irq);
 	struct mutex lock;
+	DECLARE_BITMAP(handled_vectors, 256);
 };
 
 #ifdef DEBUG
-- 
1.6.5.3

