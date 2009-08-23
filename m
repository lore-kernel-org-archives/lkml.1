Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbZHWMET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbZHWMET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933806AbZHWMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933506AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/46] KVM: x2apic interface to lapic
Date: Sun, 23 Aug 2009 14:56:05 +0300
Message-Id: <1251028605-31977-7-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

This patch implements MSR interface to local apic as defines by x2apic
Intel specification.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |  217 ++++++++++++++++++++++++++++++++++++-------------
 arch/x86/kvm/lapic.h |    2 +
 arch/x86/kvm/x86.c   |    7 ++-
 3 files changed, 167 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 62ea2ab..dc6bec2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -32,6 +32,7 @@
 #include <asm/current.h>
 #include <asm/apicdef.h>
 #include <asm/atomic.h>
+#include <asm/apicdef.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "trace.h"
@@ -158,6 +159,11 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 	apic_set_reg(apic, APIC_LVR, v);
 }
 
+static inline int apic_x2apic_mode(struct kvm_lapic *apic)
+{
+	return apic->vcpu->arch.apic_base & X2APIC_ENABLE;
+}
+
 static unsigned int apic_lvt_mask[APIC_LVT_NUM] = {
 	LVT_MASK | APIC_LVT_TIMER_PERIODIC,	/* LVTT */
 	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
@@ -284,7 +290,12 @@ int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest)
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
 {
 	int result = 0;
-	u8 logical_id;
+	u32 logical_id;
+
+	if (apic_x2apic_mode(apic)) {
+		logical_id = apic_get_reg(apic, APIC_LDR);
+		return logical_id & mda;
+	}
 
 	logical_id = GET_APIC_LOGICAL_ID(apic_get_reg(apic, APIC_LDR));
 
@@ -477,7 +488,10 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	irq.level = icr_low & APIC_INT_ASSERT;
 	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
 	irq.shorthand = icr_low & APIC_SHORT_MASK;
-	irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
+	if (apic_x2apic_mode(apic))
+		irq.dest_id = icr_high;
+	else
+		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
 
 	apic_debug("icr_high 0x%x, icr_low 0x%x, "
 		   "short_hand 0x%x, dest 0x%x, trig_mode 0x%x, level 0x%x, "
@@ -564,28 +578,26 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_lapic, dev);
 }
 
-static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
-{
-	return apic_hw_enabled(apic) &&
-	    addr >= apic->base_address &&
-	    addr < apic->base_address + LAPIC_MMIO_LENGTH;
-}
-
-static int apic_mmio_read(struct kvm_io_device *this,
-			  gpa_t address, int len, void *data)
+static int apic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
+		void *data)
 {
-	struct kvm_lapic *apic = to_lapic(this);
-	unsigned int offset = address - apic->base_address;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
-	if (!apic_mmio_in_range(apic, address))
-		return -EOPNOTSUPP;
+	/* this bitmask has a bit cleared for each reserver register */
+	static const u64 rmask = 0x43ff01ffffffe70cULL;
 
 	if ((alignment + len) > 4) {
-		printk(KERN_ERR "KVM_APIC_READ: alignment error %lx %d",
-		       (unsigned long)address, len);
-		return 0;
+		printk(KERN_ERR "KVM_APIC_READ: alignment error %x %d\n",
+				offset, len);
+		return 1;
+	}
+
+	if (offset > 0x3f0 || !(rmask & (1ULL << (offset >> 4)))) {
+		printk(KERN_ERR "KVM_APIC_READ: read reserved register %x\n",
+				offset);
+		return 1;
 	}
+
 	result = __apic_read(apic, offset & ~0xf);
 
 	trace_kvm_apic_read(offset, result);
@@ -604,6 +616,27 @@ static int apic_mmio_read(struct kvm_io_device *this,
 	return 0;
 }
 
+static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
+{
+	return apic_hw_enabled(apic) &&
+	    addr >= apic->base_address &&
+	    addr < apic->base_address + LAPIC_MMIO_LENGTH;
+}
+
+static int apic_mmio_read(struct kvm_io_device *this,
+			   gpa_t address, int len, void *data)
+{
+	struct kvm_lapic *apic = to_lapic(this);
+	u32 offset = address - apic->base_address;
+
+	if (!apic_mmio_in_range(apic, address))
+		return -EOPNOTSUPP;
+
+	apic_reg_read(apic, offset, len, data);
+
+	return 0;
+}
+
 static void update_divide_count(struct kvm_lapic *apic)
 {
 	u32 tmp1, tmp2, tdcr;
@@ -657,42 +690,18 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 		apic->vcpu->kvm->arch.vapics_in_nmi_mode--;
 }
 
-static int apic_mmio_write(struct kvm_io_device *this,
-			   gpa_t address, int len, const void *data)
+static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
-	struct kvm_lapic *apic = to_lapic(this);
-	unsigned int offset = address - apic->base_address;
-	unsigned char alignment = offset & 0xf;
-	u32 val;
-	if (!apic_mmio_in_range(apic, address))
-		return -EOPNOTSUPP;
-
-	/*
-	 * APIC register must be aligned on 128-bits boundary.
-	 * 32/64/128 bits registers must be accessed thru 32 bits.
-	 * Refer SDM 8.4.1
-	 */
-	if (len != 4 || alignment) {
-		/* Don't shout loud, $infamous_os would cause only noise. */
-		apic_debug("apic write: bad size=%d %lx\n",
-			   len, (long)address);
-		return 0;
-	}
-
-	val = *(u32 *) data;
-
-	/* too common printing */
-	if (offset != APIC_EOI)
-		apic_debug("%s: offset 0x%x with length 0x%x, and value is "
-			   "0x%x\n", __func__, offset, len, val);
+	int ret = 0;
 
-	offset &= 0xff0;
+	trace_kvm_apic_write(reg, val);
 
-	trace_kvm_apic_write(offset, val);
-
-	switch (offset) {
+	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		apic_set_reg(apic, APIC_ID, val);
+		if (!apic_x2apic_mode(apic))
+			apic_set_reg(apic, APIC_ID, val);
+		else
+			ret = 1;
 		break;
 
 	case APIC_TASKPRI:
@@ -705,11 +714,17 @@ static int apic_mmio_write(struct kvm_io_device *this,
 		break;
 
 	case APIC_LDR:
-		apic_set_reg(apic, APIC_LDR, val & APIC_LDR_MASK);
+		if (!apic_x2apic_mode(apic))
+			apic_set_reg(apic, APIC_LDR, val & APIC_LDR_MASK);
+		else
+			ret = 1;
 		break;
 
 	case APIC_DFR:
-		apic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
+		if (!apic_x2apic_mode(apic))
+			apic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
+		else
+			ret = 1;
 		break;
 
 	case APIC_SPIV: {
@@ -739,7 +754,9 @@ static int apic_mmio_write(struct kvm_io_device *this,
 		break;
 
 	case APIC_ICR2:
-		apic_set_reg(apic, APIC_ICR2, val & 0xff000000);
+		if (!apic_x2apic_mode(apic))
+			val &= 0xff000000;
+		apic_set_reg(apic, APIC_ICR2, val);
 		break;
 
 	case APIC_LVT0:
@@ -753,8 +770,8 @@ static int apic_mmio_write(struct kvm_io_device *this,
 		if (!apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
 
-		val &= apic_lvt_mask[(offset - APIC_LVTT) >> 4];
-		apic_set_reg(apic, offset, val);
+		val &= apic_lvt_mask[(reg - APIC_LVTT) >> 4];
+		apic_set_reg(apic, reg, val);
 
 		break;
 
@@ -762,7 +779,7 @@ static int apic_mmio_write(struct kvm_io_device *this,
 		hrtimer_cancel(&apic->lapic_timer.timer);
 		apic_set_reg(apic, APIC_TMICT, val);
 		start_apic_timer(apic);
-		return 0;
+		break;
 
 	case APIC_TDCR:
 		if (val & 4)
@@ -771,11 +788,58 @@ static int apic_mmio_write(struct kvm_io_device *this,
 		update_divide_count(apic);
 		break;
 
+	case APIC_ESR:
+		if (apic_x2apic_mode(apic) && val != 0) {
+			printk(KERN_ERR "KVM_WRITE:ESR not zero %x\n", val);
+			ret = 1;
+		}
+		break;
+
+	case APIC_SELF_IPI:
+		if (apic_x2apic_mode(apic)) {
+			apic_reg_write(apic, APIC_ICR, 0x40000 | (val & 0xff));
+		} else
+			ret = 1;
+		break;
 	default:
-		apic_debug("Local APIC Write to read-only register %x\n",
-			   offset);
+		ret = 1;
 		break;
 	}
+	if (ret)
+		apic_debug("Local APIC Write to read-only register %x\n", reg);
+	return ret;
+}
+
+static int apic_mmio_write(struct kvm_io_device *this,
+			    gpa_t address, int len, const void *data)
+{
+	struct kvm_lapic *apic = to_lapic(this);
+	unsigned int offset = address - apic->base_address;
+	u32 val;
+
+	if (!apic_mmio_in_range(apic, address))
+		return -EOPNOTSUPP;
+
+	/*
+	 * APIC register must be aligned on 128-bits boundary.
+	 * 32/64/128 bits registers must be accessed thru 32 bits.
+	 * Refer SDM 8.4.1
+	 */
+	if (len != 4 || (offset & 0xf)) {
+		/* Don't shout loud, $infamous_os would cause only noise. */
+		apic_debug("apic write: bad size=%d %lx\n", len, (long)address);
+		return;
+	}
+
+	val = *(u32*)data;
+
+	/* too common printing */
+	if (offset != APIC_EOI)
+		apic_debug("%s: offset 0x%x with length 0x%x, and value is "
+			   "0x%x\n", __func__, offset, len, val);
+
+	apic_reg_write(apic, offset & 0xff0, val);
+
 	return 0;
 }
 
@@ -834,6 +898,11 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		value &= ~MSR_IA32_APICBASE_BSP;
 
 	vcpu->arch.apic_base = value;
+	if (apic_x2apic_mode(apic)) {
+		u32 id = kvm_apic_id(apic);
+		u32 ldr = ((id & ~0xf) << 16) | (1 << (id & 0xf));
+		apic_set_reg(apic, APIC_LDR, ldr);
+	}
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
 
@@ -1130,3 +1199,35 @@ void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 
 	vcpu->arch.apic->vapic_addr = vapic_addr;
 }
+
+int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u32 reg = (msr - APIC_BASE_MSR) << 4;
+
+	if (!irqchip_in_kernel(vcpu->kvm) || !apic_x2apic_mode(apic))
+		return 1;
+
+	/* if this is ICR write vector before command */
+	if (msr == 0x830)
+		apic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	return apic_reg_write(apic, reg, (u32)data);
+}
+
+int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u32 reg = (msr - APIC_BASE_MSR) << 4, low, high = 0;
+
+	if (!irqchip_in_kernel(vcpu->kvm) || !apic_x2apic_mode(apic))
+		return 1;
+
+	if (apic_reg_read(apic, reg, 4, &low))
+		return 1;
+	if (msr == 0x830)
+		apic_reg_read(apic, APIC_ICR2, 4, &high);
+
+	*data = (((u64)high) << 32) | low;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index bc1c524..40010b0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -46,4 +46,6 @@ void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
+int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
+int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 086f931..a50c832 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -867,6 +867,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_IA32_APICBASE:
 		kvm_set_apic_base(vcpu, data);
 		break;
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
+		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
@@ -1065,6 +1067,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_APICBASE:
 		data = kvm_get_apic_base(vcpu);
 		break;
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
+		return kvm_x2apic_msr_read(vcpu, msr, pdata);
+		break;
 	case MSR_IA32_MISC_ENABLE:
 		data = vcpu->arch.ia32_misc_enable_msr;
 		break;
@@ -1469,7 +1474,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
 		0 /* Reserved */ | F(CX16) | 0 /* xTPR Update, PDCM */ |
 		0 /* Reserved, DCA */ | F(XMM4_1) |
-		F(XMM4_2) | 0 /* x2APIC */ | F(MOVBE) | F(POPCNT) |
+		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved, XSAVE, OSXSAVE */;
 	/* cpuid 0x80000001.ecx */
 	const u32 kvm_supported_word6_x86_features =
-- 
1.6.4.1

