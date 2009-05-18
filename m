Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbZERJhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbZERJhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZERJXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38417 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZERJXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:10 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 18/43] KVM: Merge kvm_ioapic_get_delivery_bitmask into kvm_get_intr_delivery_bitmask
Date: Mon, 18 May 2009 12:22:40 +0300
Message-Id: <1242638585-18470-19-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Gleb fixed bitmap ops usage in kvm_ioapic_get_delivery_bitmask.

Sheng merged two functions, as well as fixed several issues in
kvm_get_intr_delivery_bitmask
1. deliver_bitmask is a bitmap rather than a unsigned long intereger.
2. Lowest priority target bitmap wrong calculated by mistake.
3. Prevent potential NULL reference.
4. Declaration in include/kvm_host.h caused powerpc compilation warning.
5. Add warning for guest broadcast interrupt with lowest priority delivery mode.
6. Removed duplicate bitmap clean up in caller of kvm_get_intr_delivery_bitmask.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 virt/kvm/ioapic.c   |   46 +++-------------------------------------------
 virt/kvm/ioapic.h   |    5 +++--
 virt/kvm/irq_comm.c |   49 +++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 7c2cb2b..ea268a8 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -161,45 +161,6 @@ static void ioapic_inj_nmi(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-void kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
-				     u8 dest_mode, unsigned long *mask)
-{
-	int i;
-	struct kvm *kvm = ioapic->kvm;
-	struct kvm_vcpu *vcpu;
-
-	ioapic_debug("dest %d dest_mode %d\n", dest, dest_mode);
-
-	*mask = 0;
-	if (dest_mode == 0) {	/* Physical mode. */
-		if (dest == 0xFF) {	/* Broadcast. */
-			for (i = 0; i < KVM_MAX_VCPUS; ++i)
-				if (kvm->vcpus[i] && kvm->vcpus[i]->arch.apic)
-					*mask |= 1 << i;
-			return;
-		}
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = kvm->vcpus[i];
-			if (!vcpu)
-				continue;
-			if (kvm_apic_match_physical_addr(vcpu->arch.apic, dest)) {
-				if (vcpu->arch.apic)
-					*mask = 1 << i;
-				break;
-			}
-		}
-	} else if (dest != 0)	/* Logical mode, MDA non-zero. */
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = kvm->vcpus[i];
-			if (!vcpu)
-				continue;
-			if (vcpu->arch.apic &&
-			    kvm_apic_match_logical_addr(vcpu->arch.apic, dest))
-				*mask |= 1 << vcpu->vcpu_id;
-		}
-	ioapic_debug("mask %x\n", *mask);
-}
-
 static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 {
 	union kvm_ioapic_redirect_entry entry = ioapic->redirtbl[irq];
@@ -213,13 +174,12 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 		     entry.fields.delivery_mode, entry.fields.vector,
 		     entry.fields.trig_mode);
 
-	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
-
 	/* Always delivery PIT interrupt to vcpu 0 */
 #ifdef CONFIG_X86
-	if (irq == 0)
+	if (irq == 0) {
+                bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
 		__set_bit(0, deliver_bitmask);
-	else
+        } else
 #endif
 		kvm_get_intr_delivery_bitmask(ioapic, &entry, deliver_bitmask);
 
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 7275f87..c8032ab 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -70,7 +70,8 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
-void kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
-				     u8 dest_mode, unsigned long *mask);
+void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
+				   union kvm_ioapic_redirect_entry *entry,
+				   unsigned long *deliver_bitmask);
 
 #endif
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index d165e05..1c6ff6d 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -47,15 +47,54 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 				   union kvm_ioapic_redirect_entry *entry,
 				   unsigned long *deliver_bitmask)
 {
+	int i;
+	struct kvm *kvm = ioapic->kvm;
 	struct kvm_vcpu *vcpu;
 
-	kvm_ioapic_get_delivery_bitmask(ioapic, entry->fields.dest_id,
-					entry->fields.dest_mode,
-					deliver_bitmask);
+	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
+
+	if (entry->fields.dest_mode == 0) {	/* Physical mode. */
+		if (entry->fields.dest_id == 0xFF) {	/* Broadcast. */
+			for (i = 0; i < KVM_MAX_VCPUS; ++i)
+				if (kvm->vcpus[i] && kvm->vcpus[i]->arch.apic)
+					__set_bit(i, deliver_bitmask);
+			/* Lowest priority shouldn't combine with broadcast */
+			if (entry->fields.delivery_mode ==
+			    IOAPIC_LOWEST_PRIORITY && printk_ratelimit())
+				printk(KERN_INFO "kvm: apic: phys broadcast "
+						  "and lowest prio\n");
+			return;
+		}
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = kvm->vcpus[i];
+			if (!vcpu)
+				continue;
+			if (kvm_apic_match_physical_addr(vcpu->arch.apic,
+					entry->fields.dest_id)) {
+				if (vcpu->arch.apic)
+					__set_bit(i, deliver_bitmask);
+				break;
+			}
+		}
+	} else if (entry->fields.dest_id != 0) /* Logical mode, MDA non-zero. */
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = kvm->vcpus[i];
+			if (!vcpu)
+				continue;
+			if (vcpu->arch.apic &&
+			    kvm_apic_match_logical_addr(vcpu->arch.apic,
+					entry->fields.dest_id))
+				__set_bit(i, deliver_bitmask);
+		}
+
 	switch (entry->fields.delivery_mode) {
 	case IOAPIC_LOWEST_PRIORITY:
+		/* Select one in deliver_bitmask */
 		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm,
 				entry->fields.vector, deliver_bitmask);
+		bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
+		if (!vcpu)
+			return;
 		__set_bit(vcpu->vcpu_id, deliver_bitmask);
 		break;
 	case IOAPIC_FIXED:
@@ -65,7 +104,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 		if (printk_ratelimit())
 			printk(KERN_INFO "kvm: unsupported delivery mode %d\n",
 				entry->fields.delivery_mode);
-		*deliver_bitmask = 0;
+		bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
 	}
 }
 
@@ -80,8 +119,6 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 
 	BUG_ON(!ioapic);
 
-	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
-
 	entry.bits = 0;
 	entry.fields.dest_id = (e->msi.address_lo &
 			MSI_ADDR_DEST_ID_MASK) >> MSI_ADDR_DEST_ID_SHIFT;
-- 
1.6.0.6

