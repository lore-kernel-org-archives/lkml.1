Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZIPMpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZIPMpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758932AbZIPMpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929AbZIPMpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:45:40 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: VMX: Use shared msr infrastructure
Date: Wed, 16 Sep 2009 15:45:34 +0300
Message-Id: <1253105134-8862-5-git-send-email-avi@redhat.com>
In-Reply-To: <1253105134-8862-1-git-send-email-avi@redhat.com>
References: <1253105134-8862-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reloading syscall MSRs on every preemption, use the new shared
msr infrastructure to reload them at the last possible minute (just before
exit to userspace).

Improves vcpu/idle/vcpu switches by about 2000 cycles (when EFER needs to be
reloaded as well).

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |  108 +++++++++++++++++++--------------------------------
 1 files changed, 40 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 547881a..8dae1dc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -67,6 +67,11 @@ struct vmcs {
 	char data[0];
 };
 
+struct shared_msr_entry {
+	unsigned index;
+	u64 data;
+};
+
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 	struct list_head      local_vcpus_link;
@@ -74,8 +79,7 @@ struct vcpu_vmx {
 	int                   launched;
 	u8                    fail;
 	u32                   idt_vectoring_info;
-	struct kvm_msr_entry *guest_msrs;
-	struct kvm_msr_entry *host_msrs;
+	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
 	int                   msr_offset_efer;
@@ -89,7 +93,6 @@ struct vcpu_vmx {
 		u16           fs_sel, gs_sel, ldt_sel;
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
-		int           guest_efer_loaded;
 	} host_state;
 	struct {
 		int vm86_active;
@@ -176,6 +179,8 @@ static struct kvm_vmx_segment_field {
 	VMX_SEGMENT_FIELD(LDTR),
 };
 
+static u64 host_efer;
+
 static void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 
 /*
@@ -190,22 +195,6 @@ static const u32 vmx_msr_index[] = {
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
-static void load_msrs(struct kvm_msr_entry *e, int n)
-{
-	int i;
-
-	for (i = 0; i < n; ++i)
-		wrmsrl(e[i].index, e[i].data);
-}
-
-static void save_msrs(struct kvm_msr_entry *e, int n)
-{
-	int i;
-
-	for (i = 0; i < n; ++i)
-		rdmsrl(e[i].index, e[i].data);
-}
-
 static inline int is_page_fault(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
@@ -348,7 +337,7 @@ static int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 	int i;
 
 	for (i = 0; i < vmx->nmsrs; ++i)
-		if (vmx->guest_msrs[i].index == msr)
+		if (vmx_msr_index[vmx->guest_msrs[i].index] == msr)
 			return i;
 	return -1;
 }
@@ -379,7 +368,7 @@ static inline void __invept(int ext, u64 eptp, gpa_t gpa)
 			: : "a" (&operand), "c" (ext) : "cc", "memory");
 }
 
-static struct kvm_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
+static struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
@@ -570,17 +559,15 @@ static void reload_tss(void)
 	load_TR_desc();
 }
 
-static void load_transition_efer(struct vcpu_vmx *vmx)
+static bool update_transition_efer(struct vcpu_vmx *vmx)
 {
 	int efer_offset = vmx->msr_offset_efer;
-	u64 host_efer;
 	u64 guest_efer;
 	u64 ignore_bits;
 
 	if (efer_offset < 0)
-		return;
-	host_efer = vmx->host_msrs[efer_offset].data;
-	guest_efer = vmx->guest_msrs[efer_offset].data;
+		return false;
+	guest_efer = vmx->vcpu.arch.shadow_efer;
 
 	/*
 	 * NX is emulated; LMA and LME handled by hardware; SCE meaninless
@@ -594,26 +581,18 @@ static void load_transition_efer(struct vcpu_vmx *vmx)
 		ignore_bits &= ~(u64)EFER_SCE;
 #endif
 	if ((guest_efer & ~ignore_bits) == (host_efer & ~ignore_bits))
-		return;
+		return false;
 
-	vmx->host_state.guest_efer_loaded = 1;
 	guest_efer &= ~ignore_bits;
 	guest_efer |= host_efer & ignore_bits;
-	wrmsrl(MSR_EFER, guest_efer);
-	vmx->vcpu.stat.efer_reload++;
-}
-
-static void reload_host_efer(struct vcpu_vmx *vmx)
-{
-	if (vmx->host_state.guest_efer_loaded) {
-		vmx->host_state.guest_efer_loaded = 0;
-		load_msrs(vmx->host_msrs + vmx->msr_offset_efer, 1);
-	}
+	vmx->guest_msrs[efer_offset].data = guest_efer;
+	return true;
 }
 
 static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int i;
 
 	if (vmx->host_state.loaded)
 		return;
@@ -655,8 +634,8 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 	}
 #endif
-	load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
-	load_transition_efer(vmx);
+	for (i = 0; i < vmx->save_nmsrs; ++i)
+		kvm_set_shared_msr(i, vmx->guest_msrs[i].data);
 }
 
 static void __vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -684,9 +663,6 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 		local_irq_restore(flags);
 	}
 	reload_tss();
-	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
-	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
-	reload_host_efer(vmx);
 #ifdef CONFIG_X86_64
 	if (is_long_mode(&vmx->vcpu)) {
 		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
@@ -886,14 +862,11 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 #ifdef CONFIG_X86_64
 static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
 {
-	struct kvm_msr_entry tmp;
+	struct shared_msr_entry tmp;
 
 	tmp = vmx->guest_msrs[to];
 	vmx->guest_msrs[to] = vmx->guest_msrs[from];
 	vmx->guest_msrs[from] = tmp;
-	tmp = vmx->host_msrs[to];
-	vmx->host_msrs[to] = vmx->host_msrs[from];
-	vmx->host_msrs[from] = tmp;
 }
 #endif
 
@@ -904,15 +877,13 @@ static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
  */
 static void setup_msrs(struct vcpu_vmx *vmx)
 {
-	int save_nmsrs;
+	int save_nmsrs, index;
 	unsigned long *msr_bitmap;
 
 	vmx_load_host_state(vmx);
 	save_nmsrs = 0;
 #ifdef CONFIG_X86_64
 	if (is_long_mode(&vmx->vcpu)) {
-		int index;
-
 		index = __find_msr_index(vmx, MSR_SYSCALL_MASK);
 		if (index >= 0)
 			move_msr_up(vmx, index, save_nmsrs++);
@@ -931,9 +902,11 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 			move_msr_up(vmx, index, save_nmsrs++);
 	}
 #endif
-	vmx->save_nmsrs = save_nmsrs;
+	vmx->msr_offset_efer = index = __find_msr_index(vmx, MSR_EFER);
+	if (index >= 0 && update_transition_efer(vmx))
+		move_msr_up(vmx, index, save_nmsrs++);
 
-	vmx->msr_offset_efer = __find_msr_index(vmx, MSR_EFER);
+	vmx->save_nmsrs = save_nmsrs;
 
 	if (cpu_has_vmx_msr_bitmap()) {
 		if (is_long_mode(&vmx->vcpu))
@@ -975,7 +948,7 @@ static void guest_write_tsc(u64 guest_tsc, u64 host_tsc)
 static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	u64 data;
-	struct kvm_msr_entry *msr;
+	struct shared_msr_entry *msr;
 
 	if (!pdata) {
 		printk(KERN_ERR "BUG: get_msr called with NULL pdata\n");
@@ -994,9 +967,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 		vmx_load_host_state(to_vmx(vcpu));
 		data = to_vmx(vcpu)->msr_guest_kernel_gs_base;
 		break;
+#endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_index, pdata);
-#endif
 	case MSR_IA32_TSC:
 		data = guest_read_tsc();
 		break;
@@ -1010,6 +983,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
 	default:
+		vmx_load_host_state(to_vmx(vcpu));
 		msr = find_msr_entry(to_vmx(vcpu), msr_index);
 		if (msr) {
 			vmx_load_host_state(to_vmx(vcpu));
@@ -1031,7 +1005,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_msr_entry *msr;
+	struct shared_msr_entry *msr;
 	u64 host_tsc;
 	int ret = 0;
 
@@ -1543,8 +1517,10 @@ continue_rmode:
 static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
+	struct shared_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
 
+	if (!msr)
+		return;
 	vcpu->arch.shadow_efer = efer;
 	if (!msr)
 		return;
@@ -2383,10 +2359,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;
 		data = data_low | ((u64)data_high << 32);
-		vmx->host_msrs[j].index = index;
-		vmx->host_msrs[j].reserved = 0;
-		vmx->host_msrs[j].data = data;
-		vmx->guest_msrs[j] = vmx->host_msrs[j];
+		vmx->guest_msrs[j].index = i;
+		vmx->guest_msrs[j].data = 0;
 		++vmx->nmsrs;
 	}
 
@@ -3774,7 +3748,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 		__clear_bit(vmx->vpid, vmx_vpid_bitmap);
 	spin_unlock(&vmx_vpid_lock);
 	vmx_free_vmcs(vcpu);
-	kfree(vmx->host_msrs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
@@ -3801,10 +3774,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto uninit_vcpu;
 	}
 
-	vmx->host_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!vmx->host_msrs)
-		goto free_guest_msrs;
-
 	vmx->vmcs = alloc_vmcs();
 	if (!vmx->vmcs)
 		goto free_msrs;
@@ -3835,8 +3804,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 free_vmcs:
 	free_vmcs(vmx->vmcs);
 free_msrs:
-	kfree(vmx->host_msrs);
-free_guest_msrs:
 	kfree(vmx->guest_msrs);
 uninit_vcpu:
 	kvm_vcpu_uninit(&vmx->vcpu);
@@ -3986,7 +3953,12 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 static int __init vmx_init(void)
 {
-	int r;
+	int r, i;
+
+	rdmsrl_safe(MSR_EFER, &host_efer);
+
+	for (i = 0; i < NR_VMX_MSR; ++i)
+		kvm_define_shared_msr(i, vmx_msr_index[i]);
 
 	vmx_io_bitmap_a = (unsigned long *)__get_free_page(GFP_KERNEL);
 	if (!vmx_io_bitmap_a)
-- 
1.6.4.1

