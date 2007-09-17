Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXIQJCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXIQJCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXIQIdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:45265 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 031/104] KVM: VMX: pass vcpu_vmx internally
Date: Mon, 17 Sep 2007 10:31:13 +0200
Message-Id: <11900179472777-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

container_of is wonderful, but not casting at all is better.  This
patch changes vmx.c's internal functions to pass "struct vcpu_vmx"
instead of "struct kvm_vcpu" and using container_of.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |  140 ++++++++++++++++++++++++----------------------------
 1 files changed, 65 insertions(+), 75 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 5b77d9b..cc7ee3d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -140,9 +140,8 @@ static inline u64 msr_efer_save_restore_bits(struct kvm_msr_entry msr)
 	return (u64)msr.data & EFER_SAVE_RESTORE_BITS;
 }
 
-static inline int msr_efer_need_save_restore(struct kvm_vcpu *vcpu)
+static inline int msr_efer_need_save_restore(struct vcpu_vmx *vmx)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int efer_offset = vmx->msr_offset_efer;
 	return msr_efer_save_restore_bits(vmx->host_msrs[efer_offset]) !=
 		msr_efer_save_restore_bits(vmx->guest_msrs[efer_offset]);
@@ -168,9 +167,8 @@ static inline int is_external_interrupt(u32 intr_info)
 		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
 }
 
-static int __find_msr_index(struct kvm_vcpu *vcpu, u32 msr)
+static int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int i;
 
 	for (i = 0; i < vmx->nmsrs; ++i)
@@ -179,12 +177,11 @@ static int __find_msr_index(struct kvm_vcpu *vcpu, u32 msr)
 	return -1;
 }
 
-static struct kvm_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
+static struct kvm_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int i;
 
-	i = __find_msr_index(vcpu, msr);
+	i = __find_msr_index(vmx, msr);
 	if (i >= 0)
 		return &vmx->guest_msrs[i];
 	return NULL;
@@ -205,24 +202,24 @@ static void vmcs_clear(struct vmcs *vmcs)
 
 static void __vcpu_clear(void *arg)
 {
-	struct kvm_vcpu *vcpu = arg;
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vmx *vmx = arg;
 	int cpu = raw_smp_processor_id();
 
-	if (vcpu->cpu == cpu)
+	if (vmx->vcpu.cpu == cpu)
 		vmcs_clear(vmx->vmcs);
 	if (per_cpu(current_vmcs, cpu) == vmx->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
-	rdtscll(vcpu->host_tsc);
+	rdtscll(vmx->vcpu.host_tsc);
 }
 
-static void vcpu_clear(struct kvm_vcpu *vcpu)
+static void vcpu_clear(struct vcpu_vmx *vmx)
 {
-	if (vcpu->cpu != raw_smp_processor_id() && vcpu->cpu != -1)
-		smp_call_function_single(vcpu->cpu, __vcpu_clear, vcpu, 0, 1);
+	if (vmx->vcpu.cpu != raw_smp_processor_id() && vmx->vcpu.cpu != -1)
+		smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear,
+					 vmx, 0, 1);
 	else
-		__vcpu_clear(vcpu);
-	to_vmx(vcpu)->launched = 0;
+		__vcpu_clear(vmx);
+	vmx->launched = 0;
 }
 
 static unsigned long vmcs_readl(unsigned long field)
@@ -332,23 +329,20 @@ static void reload_tss(void)
 #endif
 }
 
-static void load_transition_efer(struct kvm_vcpu *vcpu)
+static void load_transition_efer(struct vcpu_vmx *vmx)
 {
 	u64 trans_efer;
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int efer_offset = vmx->msr_offset_efer;
 
 	trans_efer = vmx->host_msrs[efer_offset].data;
 	trans_efer &= ~EFER_SAVE_RESTORE_BITS;
 	trans_efer |= msr_efer_save_restore_bits(vmx->guest_msrs[efer_offset]);
 	wrmsrl(MSR_EFER, trans_efer);
-	vcpu->stat.efer_reload++;
+	vmx->vcpu.stat.efer_reload++;
 }
 
-static void vmx_save_host_state(struct kvm_vcpu *vcpu)
+static void vmx_save_host_state(struct vcpu_vmx *vmx)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
 	if (vmx->host_state.loaded)
 		return;
 
@@ -383,19 +377,18 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 #endif
 
 #ifdef CONFIG_X86_64
-	if (is_long_mode(vcpu)) {
+	if (is_long_mode(&vmx->vcpu)) {
 		save_msrs(vmx->host_msrs +
 			  vmx->msr_offset_kernel_gs_base, 1);
 	}
 #endif
 	load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
-	if (msr_efer_need_save_restore(vcpu))
-		load_transition_efer(vcpu);
+	if (msr_efer_need_save_restore(vmx))
+		load_transition_efer(vmx);
 }
 
-static void vmx_load_host_state(struct kvm_vcpu *vcpu)
+static void vmx_load_host_state(struct vcpu_vmx *vmx)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long flags;
 
 	if (!vmx->host_state.loaded)
@@ -420,7 +413,7 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 	}
 	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
-	if (msr_efer_need_save_restore(vcpu))
+	if (msr_efer_need_save_restore(vmx))
 		load_msrs(vmx->host_msrs + vmx->msr_offset_efer, 1);
 }
 
@@ -435,7 +428,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	u64 tsc_this, delta;
 
 	if (vcpu->cpu != cpu)
-		vcpu_clear(vcpu);
+		vcpu_clear(vmx);
 
 	if (per_cpu(current_vmcs, cpu) != vmx->vmcs) {
 		u8 error;
@@ -476,7 +469,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	vmx_load_host_state(vcpu);
+	vmx_load_host_state(to_vmx(vcpu));
 	kvm_put_guest_fpu(vcpu);
 }
 
@@ -502,7 +495,7 @@ static void vmx_fpu_deactivate(struct kvm_vcpu *vcpu)
 
 static void vmx_vcpu_decache(struct kvm_vcpu *vcpu)
 {
-	vcpu_clear(vcpu);
+	vcpu_clear(to_vmx(vcpu));
 }
 
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
@@ -550,9 +543,8 @@ static void vmx_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
-void move_msr_up(struct kvm_vcpu *vcpu, int from, int to)
+static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_msr_entry tmp;
 
 	tmp = vmx->guest_msrs[to];
@@ -568,44 +560,43 @@ void move_msr_up(struct kvm_vcpu *vcpu, int from, int to)
  * msrs.  Don't touch the 64-bit msrs if the guest is in legacy
  * mode, as fiddling with msrs is very expensive.
  */
-static void setup_msrs(struct kvm_vcpu *vcpu)
+static void setup_msrs(struct vcpu_vmx *vmx)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int save_nmsrs;
 
 	save_nmsrs = 0;
 #ifdef CONFIG_X86_64
-	if (is_long_mode(vcpu)) {
+	if (is_long_mode(&vmx->vcpu)) {
 		int index;
 
-		index = __find_msr_index(vcpu, MSR_SYSCALL_MASK);
+		index = __find_msr_index(vmx, MSR_SYSCALL_MASK);
 		if (index >= 0)
-			move_msr_up(vcpu, index, save_nmsrs++);
-		index = __find_msr_index(vcpu, MSR_LSTAR);
+			move_msr_up(vmx, index, save_nmsrs++);
+		index = __find_msr_index(vmx, MSR_LSTAR);
 		if (index >= 0)
-			move_msr_up(vcpu, index, save_nmsrs++);
-		index = __find_msr_index(vcpu, MSR_CSTAR);
+			move_msr_up(vmx, index, save_nmsrs++);
+		index = __find_msr_index(vmx, MSR_CSTAR);
 		if (index >= 0)
-			move_msr_up(vcpu, index, save_nmsrs++);
-		index = __find_msr_index(vcpu, MSR_KERNEL_GS_BASE);
+			move_msr_up(vmx, index, save_nmsrs++);
+		index = __find_msr_index(vmx, MSR_KERNEL_GS_BASE);
 		if (index >= 0)
-			move_msr_up(vcpu, index, save_nmsrs++);
+			move_msr_up(vmx, index, save_nmsrs++);
 		/*
 		 * MSR_K6_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
 		 */
-		index = __find_msr_index(vcpu, MSR_K6_STAR);
-		if ((index >= 0) && (vcpu->shadow_efer & EFER_SCE))
-			move_msr_up(vcpu, index, save_nmsrs++);
+		index = __find_msr_index(vmx, MSR_K6_STAR);
+		if ((index >= 0) && (vmx->vcpu.shadow_efer & EFER_SCE))
+			move_msr_up(vmx, index, save_nmsrs++);
 	}
 #endif
 	vmx->save_nmsrs = save_nmsrs;
 
 #ifdef CONFIG_X86_64
 	vmx->msr_offset_kernel_gs_base =
-		__find_msr_index(vcpu, MSR_KERNEL_GS_BASE);
+		__find_msr_index(vmx, MSR_KERNEL_GS_BASE);
 #endif
-	vmx->msr_offset_efer = __find_msr_index(vcpu, MSR_EFER);
+	vmx->msr_offset_efer = __find_msr_index(vmx, MSR_EFER);
 }
 
 /*
@@ -672,7 +663,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
 	default:
-		msr = find_msr_entry(vcpu, msr_index);
+		msr = find_msr_entry(to_vmx(vcpu), msr_index);
 		if (msr) {
 			data = msr->data;
 			break;
@@ -700,7 +691,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_index, data);
 		if (vmx->host_state.loaded)
-			load_transition_efer(vcpu);
+			load_transition_efer(vmx);
 		break;
 	case MSR_FS_BASE:
 		vmcs_writel(GUEST_FS_BASE, data);
@@ -722,7 +713,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		guest_write_tsc(data);
 		break;
 	default:
-		msr = find_msr_entry(vcpu, msr_index);
+		msr = find_msr_entry(vmx, msr_index);
 		if (msr) {
 			msr->data = data;
 			if (vmx->host_state.loaded)
@@ -1116,7 +1107,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 
 	vcpu->shadow_efer |= EFER_LMA;
 
-	find_msr_entry(vcpu, MSR_EFER)->data |= EFER_LMA | EFER_LME;
+	find_msr_entry(to_vmx(vcpu), MSR_EFER)->data |= EFER_LMA | EFER_LME;
 	vmcs_write32(VM_ENTRY_CONTROLS,
 		     vmcs_read32(VM_ENTRY_CONTROLS)
 		     | VM_ENTRY_CONTROLS_IA32E_MASK);
@@ -1186,7 +1177,8 @@ static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	struct kvm_msr_entry *msr = find_msr_entry(vcpu, MSR_EFER);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
 
 	vcpu->shadow_efer = efer;
 	if (efer & EFER_LMA) {
@@ -1202,7 +1194,7 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 		msr->data = efer & ~EFER_LME;
 	}
-	setup_msrs(vcpu);
+	setup_msrs(vmx);
 }
 
 #endif
@@ -1364,9 +1356,8 @@ static void seg_setup(int seg)
 /*
  * Sets up the vmcs for emulated real mode.
  */
-static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
+static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 host_sysenter_cs;
 	u32 junk;
 	unsigned long a;
@@ -1375,19 +1366,18 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	int ret = 0;
 	unsigned long kvm_vmx_return;
 
-	if (!init_rmode_tss(vcpu->kvm)) {
+	if (!init_rmode_tss(vmx->vcpu.kvm)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	memset(vcpu->regs, 0, sizeof(vcpu->regs));
-	vcpu->regs[VCPU_REGS_RDX] = get_rdx_init_val();
-	vcpu->cr8 = 0;
-	vcpu->apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
-	if (vcpu->vcpu_id == 0)
-		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
+	vmx->vcpu.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	vmx->vcpu.cr8 = 0;
+	vmx->vcpu.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	if (vmx->vcpu.vcpu_id == 0)
+		vmx->vcpu.apic_base |= MSR_IA32_APICBASE_BSP;
 
-	fx_init(vcpu);
+	fx_init(&vmx->vcpu);
 
 	/*
 	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
@@ -1512,7 +1502,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 		++vmx->nmsrs;
 	}
 
-	setup_msrs(vcpu);
+	setup_msrs(vmx);
 
 	vmcs_write32(VM_EXIT_CONTROLS, vmcs_config.vmexit_ctrl);
 
@@ -1529,14 +1519,14 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
 
-	vcpu->cr0 = 0x60000010;
-	vmx_set_cr0(vcpu, vcpu->cr0); // enter rmode
-	vmx_set_cr4(vcpu, 0);
+	vmx->vcpu.cr0 = 0x60000010;
+	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.cr0); // enter rmode
+	vmx_set_cr4(&vmx->vcpu, 0);
 #ifdef CONFIG_X86_64
-	vmx_set_efer(vcpu, 0);
+	vmx_set_efer(&vmx->vcpu, 0);
 #endif
-	vmx_fpu_activate(vcpu);
-	update_exception_bitmap(vcpu);
+	vmx_fpu_activate(&vmx->vcpu);
+	update_exception_bitmap(&vmx->vcpu);
 
 	return 0;
 
@@ -2129,7 +2119,7 @@ again:
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
-	vmx_save_host_state(vcpu);
+	vmx_save_host_state(vmx);
 	kvm_load_guest_fpu(vcpu);
 
 	/*
@@ -2352,7 +2342,7 @@ static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (vmx->vmcs) {
-		on_each_cpu(__vcpu_clear, vcpu, 0, 1);
+		on_each_cpu(__vcpu_clear, vmx, 0, 1);
 		free_vmcs(vmx->vmcs);
 		vmx->vmcs = NULL;
 	}
@@ -2400,7 +2390,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	cpu = get_cpu();
 	vmx_vcpu_load(&vmx->vcpu, cpu);
-	err = vmx_vcpu_setup(&vmx->vcpu);
+	err = vmx_vcpu_setup(vmx);
 	vmx_vcpu_put(&vmx->vcpu);
 	put_cpu();
 	if (err)
-- 
1.5.3

