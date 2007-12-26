Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbXLZLHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbXLZLHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXLZLGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:50434 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbXLZLGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:03 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 02/55] KVM: Move vmx_vcpu_reset() out of vmx_vcpu_setup()
Date: Wed, 26 Dec 2007 13:05:07 +0200
Message-Id: <1198667160-22953-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split guest reset code out of vmx_vcpu_setup().  Besides being cleaner, this
moves the realmode tss setup (which can sleep) outside vmx_vcpu_setup()
(which is executed with preemption enabled).

[izik: remove unused variable]

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    8 ++-
 drivers/kvm/svm.c      |    4 +-
 drivers/kvm/vmx.c      |  178 ++++++++++++++++++++++++------------------------
 4 files changed, 99 insertions(+), 93 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index db18d27..f7181a4 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -412,7 +412,7 @@ struct kvm_x86_ops {
 	/* Create, but do not attach this VCPU */
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
-	void (*vcpu_reset)(struct kvm_vcpu *vcpu);
+	int (*vcpu_reset)(struct kvm_vcpu *vcpu);
 
 	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 41d4a93..ff77175 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2122,7 +2122,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		pr_debug("vcpu %d received sipi with vector # %x\n",
 		       vcpu->vcpu_id, vcpu->sipi_vector);
 		kvm_lapic_reset(vcpu);
-		kvm_x86_ops->vcpu_reset(vcpu);
+		r = kvm_x86_ops->vcpu_reset(vcpu);
+		if (r)
+			return r;
 		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
 	}
 
@@ -2637,7 +2639,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	BUG_ON((unsigned long)&vcpu->host_fx_image & 0xF);
 
 	vcpu_load(vcpu);
-	r = kvm_mmu_setup(vcpu);
+	r = kvm_x86_ops->vcpu_reset(vcpu);
+	if (r == 0)
+		r = kvm_mmu_setup(vcpu);
 	vcpu_put(vcpu);
 	if (r < 0)
 		goto free_vcpu;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 09c4b14..4a70168 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -557,7 +557,7 @@ static void init_vmcb(struct vmcb *vmcb)
 	/* rdx = ?? */
 }
 
-static void svm_vcpu_reset(struct kvm_vcpu *vcpu)
+static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -568,6 +568,8 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu)
 		svm->vmcb->save.cs.base = svm->vcpu.sipi_vector << 12;
 		svm->vmcb->save.cs.selector = svm->vcpu.sipi_vector << 8;
 	}
+
+	return 0;
 }
 
 static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 828d3cb..77083e4 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1433,92 +1433,15 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	unsigned long a;
 	struct descriptor_table dt;
 	int i;
-	int ret = 0;
 	unsigned long kvm_vmx_return;
-	u64 msr;
 	u32 exec_control;
 
-	if (!init_rmode_tss(vmx->vcpu.kvm)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	vmx->vcpu.rmode.active = 0;
-
-	vmx->vcpu.regs[VCPU_REGS_RDX] = get_rdx_init_val();
-	set_cr8(&vmx->vcpu, 0);
-	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
-	if (vmx->vcpu.vcpu_id == 0)
-		msr |= MSR_IA32_APICBASE_BSP;
-	kvm_set_apic_base(&vmx->vcpu, msr);
-
-	fx_init(&vmx->vcpu);
-
-	/*
-	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
-	 * insists on having GUEST_CS_BASE == GUEST_CS_SELECTOR << 4.  Sigh.
-	 */
-	if (vmx->vcpu.vcpu_id == 0) {
-		vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
-		vmcs_writel(GUEST_CS_BASE, 0x000f0000);
-	} else {
-		vmcs_write16(GUEST_CS_SELECTOR, vmx->vcpu.sipi_vector << 8);
-		vmcs_writel(GUEST_CS_BASE, vmx->vcpu.sipi_vector << 12);
-	}
-	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
-	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
-
-	seg_setup(VCPU_SREG_DS);
-	seg_setup(VCPU_SREG_ES);
-	seg_setup(VCPU_SREG_FS);
-	seg_setup(VCPU_SREG_GS);
-	seg_setup(VCPU_SREG_SS);
-
-	vmcs_write16(GUEST_TR_SELECTOR, 0);
-	vmcs_writel(GUEST_TR_BASE, 0);
-	vmcs_write32(GUEST_TR_LIMIT, 0xffff);
-	vmcs_write32(GUEST_TR_AR_BYTES, 0x008b);
-
-	vmcs_write16(GUEST_LDTR_SELECTOR, 0);
-	vmcs_writel(GUEST_LDTR_BASE, 0);
-	vmcs_write32(GUEST_LDTR_LIMIT, 0xffff);
-	vmcs_write32(GUEST_LDTR_AR_BYTES, 0x00082);
-
-	vmcs_write32(GUEST_SYSENTER_CS, 0);
-	vmcs_writel(GUEST_SYSENTER_ESP, 0);
-	vmcs_writel(GUEST_SYSENTER_EIP, 0);
-
-	vmcs_writel(GUEST_RFLAGS, 0x02);
-	if (vmx->vcpu.vcpu_id == 0)
-		vmcs_writel(GUEST_RIP, 0xfff0);
-	else
-		vmcs_writel(GUEST_RIP, 0);
-	vmcs_writel(GUEST_RSP, 0);
-
-	/* todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0 */
-	vmcs_writel(GUEST_DR7, 0x400);
-
-	vmcs_writel(GUEST_GDTR_BASE, 0);
-	vmcs_write32(GUEST_GDTR_LIMIT, 0xffff);
-
-	vmcs_writel(GUEST_IDTR_BASE, 0);
-	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
-
-	vmcs_write32(GUEST_ACTIVITY_STATE, 0);
-	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
-	vmcs_write32(GUEST_PENDING_DBG_EXCEPTIONS, 0);
-
 	/* I/O */
 	vmcs_write64(IO_BITMAP_A, page_to_phys(vmx_io_bitmap_a));
 	vmcs_write64(IO_BITMAP_B, page_to_phys(vmx_io_bitmap_b));
 
-	guest_write_tsc(0);
-
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
-	/* Special registers */
-	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
-
 	/* Control */
 	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL,
 		vmcs_config.pin_based_exec_ctrl);
@@ -1593,13 +1516,100 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		++vmx->nmsrs;
 	}
 
-	setup_msrs(vmx);
-
 	vmcs_write32(VM_EXIT_CONTROLS, vmcs_config.vmexit_ctrl);
 
 	/* 22.2.1, 20.8.1 */
 	vmcs_write32(VM_ENTRY_CONTROLS, vmcs_config.vmentry_ctrl);
 
+	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
+	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
+
+	return 0;
+}
+
+static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 msr;
+	int ret;
+
+	if (!init_rmode_tss(vmx->vcpu.kvm)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	vmx->vcpu.rmode.active = 0;
+
+	vmx->vcpu.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	set_cr8(&vmx->vcpu, 0);
+	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	if (vmx->vcpu.vcpu_id == 0)
+		msr |= MSR_IA32_APICBASE_BSP;
+	kvm_set_apic_base(&vmx->vcpu, msr);
+
+	fx_init(&vmx->vcpu);
+
+	/*
+	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
+	 * insists on having GUEST_CS_BASE == GUEST_CS_SELECTOR << 4.  Sigh.
+	 */
+	if (vmx->vcpu.vcpu_id == 0) {
+		vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
+		vmcs_writel(GUEST_CS_BASE, 0x000f0000);
+	} else {
+		vmcs_write16(GUEST_CS_SELECTOR, vmx->vcpu.sipi_vector << 8);
+		vmcs_writel(GUEST_CS_BASE, vmx->vcpu.sipi_vector << 12);
+	}
+	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
+	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
+
+	seg_setup(VCPU_SREG_DS);
+	seg_setup(VCPU_SREG_ES);
+	seg_setup(VCPU_SREG_FS);
+	seg_setup(VCPU_SREG_GS);
+	seg_setup(VCPU_SREG_SS);
+
+	vmcs_write16(GUEST_TR_SELECTOR, 0);
+	vmcs_writel(GUEST_TR_BASE, 0);
+	vmcs_write32(GUEST_TR_LIMIT, 0xffff);
+	vmcs_write32(GUEST_TR_AR_BYTES, 0x008b);
+
+	vmcs_write16(GUEST_LDTR_SELECTOR, 0);
+	vmcs_writel(GUEST_LDTR_BASE, 0);
+	vmcs_write32(GUEST_LDTR_LIMIT, 0xffff);
+	vmcs_write32(GUEST_LDTR_AR_BYTES, 0x00082);
+
+	vmcs_write32(GUEST_SYSENTER_CS, 0);
+	vmcs_writel(GUEST_SYSENTER_ESP, 0);
+	vmcs_writel(GUEST_SYSENTER_EIP, 0);
+
+	vmcs_writel(GUEST_RFLAGS, 0x02);
+	if (vmx->vcpu.vcpu_id == 0)
+		vmcs_writel(GUEST_RIP, 0xfff0);
+	else
+		vmcs_writel(GUEST_RIP, 0);
+	vmcs_writel(GUEST_RSP, 0);
+
+	/* todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0 */
+	vmcs_writel(GUEST_DR7, 0x400);
+
+	vmcs_writel(GUEST_GDTR_BASE, 0);
+	vmcs_write32(GUEST_GDTR_LIMIT, 0xffff);
+
+	vmcs_writel(GUEST_IDTR_BASE, 0);
+	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
+
+	vmcs_write32(GUEST_ACTIVITY_STATE, 0);
+	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
+	vmcs_write32(GUEST_PENDING_DBG_EXCEPTIONS, 0);
+
+	guest_write_tsc(0);
+
+	/* Special registers */
+	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+
+	setup_msrs(vmx);
+
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
 #ifdef CONFIG_X86_64
@@ -1610,9 +1620,6 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write32(TPR_THRESHOLD, 0);
 #endif
 
-	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
-	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
-
 	vmx->vcpu.cr0 = 0x60000010;
 	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.cr0); /* enter rmode */
 	vmx_set_cr4(&vmx->vcpu, 0);
@@ -1628,13 +1635,6 @@ out:
 	return ret;
 }
 
-static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	vmx_vcpu_setup(vmx);
-}
-
 static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 {
 	u16 ent[2];
-- 
1.5.3.7

