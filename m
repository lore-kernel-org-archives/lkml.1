Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbZERJgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbZERJgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZERJYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38421 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 20/43] KVM: APIC: kvm_apic_set_irq deliver all kinds of interrupts
Date: Mon, 18 May 2009 12:22:42 +0300
Message-Id: <1242638585-18470-21-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Get rid of ioapic_inj_irq() and ioapic_inj_nmi() functions.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    1 -
 arch/ia64/kvm/kvm-ia64.c         |    8 +++---
 arch/ia64/kvm/lapic.h            |    2 +-
 arch/x86/kvm/lapic.c             |   47 +++++++++++++++++++++++--------------
 arch/x86/kvm/lapic.h             |    2 +-
 virt/kvm/ioapic.c                |   40 +++++---------------------------
 virt/kvm/irq_comm.c              |    1 +
 7 files changed, 42 insertions(+), 59 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 4542651..5608488 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -585,7 +585,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 void kvm_sal_emul(struct kvm_vcpu *vcpu);
 
-static inline void kvm_inject_nmi(struct kvm_vcpu *vcpu) {}
 #endif /* __ASSEMBLY__*/
 
 #endif
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 774f0d7..99d6d17 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -292,13 +292,13 @@ static void vcpu_deliver_ipi(struct kvm_vcpu *vcpu, uint64_t dm,
 {
 	switch (dm) {
 	case SAPIC_FIXED:
-		kvm_apic_set_irq(vcpu, vector, 0);
+		kvm_apic_set_irq(vcpu, vector, dm, 0);
 		break;
 	case SAPIC_NMI:
-		kvm_apic_set_irq(vcpu, 2, 0);
+		kvm_apic_set_irq(vcpu, 2, dm, 0);
 		break;
 	case SAPIC_EXTINT:
-		kvm_apic_set_irq(vcpu, 0, 0);
+		kvm_apic_set_irq(vcpu, 0, dm, 0);
 		break;
 	case SAPIC_INIT:
 	case SAPIC_PMI:
@@ -1813,7 +1813,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	put_cpu();
 }
 
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig)
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig)
 {
 
 	struct vpd *vpd = to_host(vcpu->kvm, vcpu->arch.vpd);
diff --git a/arch/ia64/kvm/lapic.h b/arch/ia64/kvm/lapic.h
index 6d6cbcb..cbcfaa6 100644
--- a/arch/ia64/kvm/lapic.h
+++ b/arch/ia64/kvm/lapic.h
@@ -20,6 +20,6 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu);
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig);
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig);
 
 #endif
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 27ca43e..a42f968 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -196,20 +196,30 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
 
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig)
+static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
+			     int vector, int level, int trig_mode);
+
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	int lapic_dmode;
 
-	if (!apic_test_and_set_irr(vec, apic)) {
-		/* a new pending irq is set in IRR */
-		if (trig)
-			apic_set_vector(vec, apic->regs + APIC_TMR);
-		else
-			apic_clear_vector(vec, apic->regs + APIC_TMR);
-		kvm_vcpu_kick(apic->vcpu);
-		return 1;
+	switch (dmode) {
+	case IOAPIC_LOWEST_PRIORITY:
+		lapic_dmode = APIC_DM_LOWEST;
+		break;
+	case IOAPIC_FIXED:
+		lapic_dmode = APIC_DM_FIXED;
+		break;
+	case IOAPIC_NMI:
+		lapic_dmode = APIC_DM_NMI;
+		break;
+	default:
+		printk(KERN_DEBUG"Ignoring delivery mode %d\n", dmode);
+		return 0;
+		break;
 	}
-	return 0;
+	return __apic_accept_irq(apic, lapic_dmode, vec, 1, trig);
 }
 
 static inline int apic_find_highest_isr(struct kvm_lapic *apic)
@@ -327,7 +337,7 @@ static int apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode)
 {
-	int orig_irr, result = 0;
+	int result = 0;
 	struct kvm_vcpu *vcpu = apic->vcpu;
 
 	switch (delivery_mode) {
@@ -337,10 +347,11 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		if (unlikely(!apic_enabled(apic)))
 			break;
 
-		orig_irr = apic_test_and_set_irr(vector, apic);
-		if (orig_irr && trig_mode) {
-			apic_debug("level trig mode repeatedly for vector %d",
-				   vector);
+		result = !apic_test_and_set_irr(vector, apic);
+		if (!result) {
+			if (trig_mode)
+				apic_debug("level trig mode repeatedly for "
+						"vector %d", vector);
 			break;
 		}
 
@@ -349,10 +360,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			apic_set_vector(vector, apic->regs + APIC_TMR);
 		} else
 			apic_clear_vector(vector, apic->regs + APIC_TMR);
-
 		kvm_vcpu_kick(vcpu);
-
-		result = (orig_irr == 0);
 		break;
 
 	case APIC_DM_REMRD:
@@ -364,12 +372,14 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		break;
 
 	case APIC_DM_NMI:
+		result = 1;
 		kvm_inject_nmi(vcpu);
 		kvm_vcpu_kick(vcpu);
 		break;
 
 	case APIC_DM_INIT:
 		if (level) {
+			result = 1;
 			if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE)
 				printk(KERN_DEBUG
 				       "INIT on a runnable vcpu %d\n",
@@ -386,6 +396,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		apic_debug("SIPI to vcpu %d vector 0x%02x\n",
 			   vcpu->vcpu_id, vector);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
+			result = 1;
 			vcpu->arch.sipi_vector = vector;
 			vcpu->arch.mp_state = KVM_MP_STATE_SIPI_RECEIVED;
 			kvm_vcpu_kick(vcpu);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2fc0d3c..1b0e3c0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -31,7 +31,7 @@ u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig);
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig);
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index ea268a8..d4a7948 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -142,25 +142,6 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	}
 }
 
-static int ioapic_inj_irq(struct kvm_ioapic *ioapic,
-			   struct kvm_vcpu *vcpu,
-			   u8 vector, u8 trig_mode, u8 delivery_mode)
-{
-	ioapic_debug("irq %d trig %d deliv %d\n", vector, trig_mode,
-		     delivery_mode);
-
-	ASSERT((delivery_mode == IOAPIC_FIXED) ||
-	       (delivery_mode == IOAPIC_LOWEST_PRIORITY));
-
-	return kvm_apic_set_irq(vcpu, vector, trig_mode);
-}
-
-static void ioapic_inj_nmi(struct kvm_vcpu *vcpu)
-{
-	kvm_inject_nmi(vcpu);
-	kvm_vcpu_kick(vcpu);
-}
-
 static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 {
 	union kvm_ioapic_redirect_entry entry = ioapic->redirtbl[irq];
@@ -193,21 +174,12 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 		__clear_bit(vcpu_id, deliver_bitmask);
 		vcpu = ioapic->kvm->vcpus[vcpu_id];
 		if (vcpu) {
-			if (entry.fields.delivery_mode ==
-					IOAPIC_LOWEST_PRIORITY ||
-			    entry.fields.delivery_mode == IOAPIC_FIXED) {
-				if (r < 0)
-					r = 0;
-				r += ioapic_inj_irq(ioapic, vcpu,
-						    entry.fields.vector,
-						    entry.fields.trig_mode,
-						    entry.fields.delivery_mode);
-			} else if (entry.fields.delivery_mode == IOAPIC_NMI) {
-				r = 1;
-				ioapic_inj_nmi(vcpu);
-			} else
-				ioapic_debug("unsupported delivery mode %x!\n",
-					     entry.fields.delivery_mode);
+			if (r < 0)
+				r = 0;
+			r += kvm_apic_set_irq(vcpu,
+					entry.fields.vector,
+					entry.fields.trig_mode,
+					entry.fields.delivery_mode);
 		} else
 			ioapic_debug("null destination vcpu: "
 				     "mask=%x vector=%x delivery_mode=%x\n",
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 1c6ff6d..325c668 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -148,6 +148,7 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 			if (r < 0)
 				r = 0;
 			r += kvm_apic_set_irq(vcpu, entry.fields.vector,
+					      entry.fields.dest_mode,
 					      entry.fields.trig_mode);
 		}
 	}
-- 
1.6.0.6

