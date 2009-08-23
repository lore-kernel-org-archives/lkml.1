Return-Path: <linux-kernel-owner+w=401wt.eu-S933809AbZHWMEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbZHWMEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbZHWMDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933528AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/46] KVM: Add Directed EOI support to APIC emulation
Date: Sun, 23 Aug 2009 14:56:04 +0300
Message-Id: <1251028605-31977-6-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Directed EOI is specified by x2APIC, but is available even when lapic is
in xAPIC mode.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/apicdef.h |    2 ++
 arch/x86/kvm/lapic.c           |   38 ++++++++++++++++++++++++++++++--------
 arch/x86/kvm/lapic.h           |    1 +
 arch/x86/kvm/x86.c             |    4 ++--
 arch/x86/kvm/x86.h             |    4 ++++
 5 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 7ddb36a..74ca38f 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -14,6 +14,7 @@
 
 #define	APIC_LVR	0x30
 #define		APIC_LVR_MASK		0xFF00FF
+#define		APIC_LVR_DIRECTED_EOI	(1 << 24)
 #define		GET_APIC_VERSION(x)	((x) & 0xFFu)
 #define		GET_APIC_MAXLVT(x)	(((x) >> 16) & 0xFFu)
 #ifdef CONFIG_X86_32
@@ -40,6 +41,7 @@
 #define		APIC_DFR_CLUSTER		0x0FFFFFFFul
 #define		APIC_DFR_FLAT			0xFFFFFFFFul
 #define	APIC_SPIV	0xF0
+#define		APIC_SPIV_DIRECTED_EOI		(1 << 12)
 #define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
 #define		APIC_SPIV_APIC_ENABLED		(1 << 8)
 #define	APIC_ISR	0x100
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 265a765..62ea2ab 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -35,6 +35,7 @@
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "trace.h"
+#include "x86.h"
 
 #ifndef CONFIG_X86_64
 #define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
@@ -142,6 +143,21 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
 }
 
+void kvm_apic_set_version(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_cpuid_entry2 *feat;
+	u32 v = APIC_VERSION;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return;
+
+	feat = kvm_find_cpuid_entry(apic->vcpu, 0x1, 0);
+	if (feat && (feat->ecx & (1 << (X86_FEATURE_X2APIC & 31))))
+		v |= APIC_LVR_DIRECTED_EOI;
+	apic_set_reg(apic, APIC_LVR, v);
+}
+
 static unsigned int apic_lvt_mask[APIC_LVT_NUM] = {
 	LVT_MASK | APIC_LVT_TIMER_PERIODIC,	/* LVTT */
 	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
@@ -442,9 +458,11 @@ static void apic_set_eoi(struct kvm_lapic *apic)
 		trigger_mode = IOAPIC_LEVEL_TRIG;
 	else
 		trigger_mode = IOAPIC_EDGE_TRIG;
-	mutex_lock(&apic->vcpu->kvm->irq_lock);
-	kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
-	mutex_unlock(&apic->vcpu->kvm->irq_lock);
+	if (!(apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)) {
+		mutex_lock(&apic->vcpu->kvm->irq_lock);
+		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
+		mutex_unlock(&apic->vcpu->kvm->irq_lock);
+	}
 }
 
 static void apic_send_ipi(struct kvm_lapic *apic)
@@ -694,8 +712,11 @@ static int apic_mmio_write(struct kvm_io_device *this,
 		apic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
 		break;
 
-	case APIC_SPIV:
-		apic_set_reg(apic, APIC_SPIV, val & 0x3ff);
+	case APIC_SPIV: {
+		u32 mask = 0x3ff;
+		if (apic_get_reg(apic, APIC_LVR) & APIC_LVR_DIRECTED_EOI)
+			mask |= APIC_SPIV_DIRECTED_EOI;
+		apic_set_reg(apic, APIC_SPIV, val & mask);
 		if (!(val & APIC_SPIV_APIC_ENABLED)) {
 			int i;
 			u32 lvt_val;
@@ -710,7 +731,7 @@ static int apic_mmio_write(struct kvm_io_device *this,
 
 		}
 		break;
-
+	}
 	case APIC_ICR:
 		/* No delay here, so we always clear the pending bit */
 		apic_set_reg(apic, APIC_ICR, val & ~(1 << 12));
@@ -837,7 +858,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
 	apic_set_reg(apic, APIC_ID, vcpu->vcpu_id << 24);
-	apic_set_reg(apic, APIC_LVR, APIC_VERSION);
+	kvm_apic_set_version(apic->vcpu);
 
 	for (i = 0; i < APIC_LVT_NUM; i++)
 		apic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
@@ -1041,7 +1062,8 @@ void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
 
 	apic->base_address = vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
-	apic_set_reg(apic, APIC_LVR, APIC_VERSION);
+	kvm_apic_set_version(vcpu);
+
 	apic_update_ppr(apic);
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	update_divide_count(apic);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 3f3ecc6..bc1c524 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -29,6 +29,7 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
+void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d32e3c6..086f931 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -79,8 +79,6 @@ static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffffeULL;
 
 static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 				    struct kvm_cpuid_entry2 __user *entries);
-struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
-					      u32 function, u32 index);
 
 struct kvm_x86_ops *kvm_x86_ops;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
@@ -1373,6 +1371,7 @@ static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	cpuid_fix_nx_cap(vcpu);
 	r = 0;
+	kvm_apic_set_version(vcpu);
 
 out_free:
 	vfree(cpuid_entries);
@@ -1394,6 +1393,7 @@ static int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
+	kvm_apic_set_version(vcpu);
 	return 0;
 
 out:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4c8e10a..5eadea5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -31,4 +31,8 @@ static inline bool kvm_exception_is_soft(unsigned int nr)
 {
 	return (nr == BP_VECTOR) || (nr == OF_VECTOR);
 }
+
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
+                                             u32 function, u32 index);
+
 #endif
-- 
1.6.4.1

