Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbXIQJDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbXIQJDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbXIQIeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:45297 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 024/104] KVM: Remove arch specific components from the general code
Date: Mon, 17 Sep 2007 10:31:06 +0200
Message-Id: <11900179473083-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

struct kvm_vcpu has vmx-specific members; remove them to a private structure.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   31 +----
 drivers/kvm/kvm_main.c |   26 +---
 drivers/kvm/kvm_svm.h  |    3 +
 drivers/kvm/svm.c      |  394 ++++++++++++++++++++++++++++--------------------
 drivers/kvm/vmx.c      |  249 +++++++++++++++++++-----------
 5 files changed, 397 insertions(+), 306 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 57504ae..954a140 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -15,7 +15,6 @@
 #include <linux/mm.h>
 #include <asm/signal.h>
 
-#include "vmx.h"
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
@@ -140,14 +139,6 @@ struct kvm_mmu_page {
 	};
 };
 
-struct vmcs {
-	u32 revision_id;
-	u32 abort;
-	char data[0];
-};
-
-#define vmx_msr_entry kvm_msr_entry
-
 struct kvm_vcpu;
 
 /*
@@ -309,15 +300,12 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
 struct kvm_vcpu {
+	int valid;
 	struct kvm *kvm;
 	int vcpu_id;
-	union {
-		struct vmcs *vmcs;
-		struct vcpu_svm *svm;
-	};
+	void *_priv;
 	struct mutex mutex;
 	int   cpu;
-	int   launched;
 	u64 host_tsc;
 	struct kvm_run *run;
 	int interrupt_window_open;
@@ -340,14 +328,6 @@ struct kvm_vcpu {
 	u64 shadow_efer;
 	u64 apic_base;
 	u64 ia32_misc_enable_msr;
-	int nmsrs;
-	int save_nmsrs;
-	int msr_offset_efer;
-#ifdef CONFIG_X86_64
-	int msr_offset_kernel_gs_base;
-#endif
-	struct vmx_msr_entry *guest_msrs;
-	struct vmx_msr_entry *host_msrs;
 
 	struct kvm_mmu mmu;
 
@@ -366,11 +346,6 @@ struct kvm_vcpu {
 	char *guest_fx_image;
 	int fpu_active;
 	int guest_fpu_loaded;
-	struct vmx_host_state {
-		int loaded;
-		u16 fs_sel, gs_sel, ldt_sel;
-		int fs_gs_ldt_reload_needed;
-	} vmx_host_state;
 
 	int mmio_needed;
 	int mmio_read_completed;
@@ -579,8 +554,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 
 void fx_init(struct kvm_vcpu *vcpu);
 
-void load_msrs(struct vmx_msr_entry *e, int n);
-void save_msrs(struct vmx_msr_entry *e, int n);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 65c9a31..bf8b8f0 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -367,7 +367,7 @@ static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
 
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->vmcs)
+	if (!vcpu->valid)
 		return;
 
 	vcpu_load(vcpu);
@@ -377,7 +377,7 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->vmcs)
+	if (!vcpu->valid)
 		return;
 
 	vcpu_load(vcpu);
@@ -1645,24 +1645,6 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-void load_msrs(struct vmx_msr_entry *e, int n)
-{
-	int i;
-
-	for (i = 0; i < n; ++i)
-		wrmsrl(e[i].index, e[i].data);
-}
-EXPORT_SYMBOL_GPL(load_msrs);
-
-void save_msrs(struct vmx_msr_entry *e, int n)
-{
-	int i;
-
-	for (i = 0; i < n; ++i)
-		rdmsrl(e[i].index, e[i].data);
-}
-EXPORT_SYMBOL_GPL(save_msrs);
-
 void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -2401,7 +2383,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 
 	mutex_lock(&vcpu->mutex);
 
-	if (vcpu->vmcs) {
+	if (vcpu->valid) {
 		mutex_unlock(&vcpu->mutex);
 		return -EEXIST;
 	}
@@ -2449,6 +2431,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 		kvm->nvcpus = n + 1;
 	spin_unlock(&kvm_lock);
 
+	vcpu->valid = 1;
+
 	return r;
 
 out_free_vcpus:
diff --git a/drivers/kvm/kvm_svm.h b/drivers/kvm/kvm_svm.h
index a869983..82e5d77 100644
--- a/drivers/kvm/kvm_svm.h
+++ b/drivers/kvm/kvm_svm.h
@@ -20,7 +20,10 @@ static const u32 host_save_user_msrs[] = {
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 #define NUM_DB_REGS 4
 
+struct kvm_vcpu;
+
 struct vcpu_svm {
+	struct kvm_vcpu *vcpu;
 	struct vmcb *vmcb;
 	unsigned long vmcb_pa;
 	struct svm_cpu_data *svm_data;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 850a1b1..3248187 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -49,6 +49,11 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
 
+static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
+{
+	return (struct vcpu_svm*)vcpu->_priv;
+}
+
 unsigned long iopm_base;
 unsigned long msrpm_base;
 
@@ -95,7 +100,7 @@ static inline u32 svm_has(u32 feat)
 
 static unsigned get_addr_size(struct kvm_vcpu *vcpu)
 {
-	struct vmcb_save_area *sa = &vcpu->svm->vmcb->save;
+	struct vmcb_save_area *sa = &to_svm(vcpu)->vmcb->save;
 	u16 cs_attrib;
 
 	if (!(sa->cr0 & X86_CR0_PE) || (sa->rflags & X86_EFLAGS_VM))
@@ -181,7 +186,7 @@ static inline void write_dr7(unsigned long val)
 
 static inline void force_new_asid(struct kvm_vcpu *vcpu)
 {
-	vcpu->svm->asid_generation--;
+	to_svm(vcpu)->asid_generation--;
 }
 
 static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
@@ -194,22 +199,24 @@ static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if (!(efer & KVM_EFER_LMA))
 		efer &= ~KVM_EFER_LME;
 
-	vcpu->svm->vmcb->save.efer = efer | MSR_EFER_SVME_MASK;
+	to_svm(vcpu)->vmcb->save.efer = efer | MSR_EFER_SVME_MASK;
 	vcpu->shadow_efer = efer;
 }
 
 static void svm_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
 {
-	vcpu->svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.event_inj =		SVM_EVTINJ_VALID |
 						SVM_EVTINJ_VALID_ERR |
 						SVM_EVTINJ_TYPE_EXEPT |
 						GP_VECTOR;
-	vcpu->svm->vmcb->control.event_inj_err = error_code;
+	svm->vmcb->control.event_inj_err = error_code;
 }
 
 static void inject_ud(struct kvm_vcpu *vcpu)
 {
-	vcpu->svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
+	to_svm(vcpu)->vmcb->control.event_inj = SVM_EVTINJ_VALID |
 						SVM_EVTINJ_TYPE_EXEPT |
 						UD_VECTOR;
 }
@@ -228,19 +235,21 @@ static int is_external_interrupt(u32 info)
 
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->svm->next_rip) {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!svm->next_rip) {
 		printk(KERN_DEBUG "%s: NOP\n", __FUNCTION__);
 		return;
 	}
-	if (vcpu->svm->next_rip - vcpu->svm->vmcb->save.rip > 15) {
+	if (svm->next_rip - svm->vmcb->save.rip > 15) {
 		printk(KERN_ERR "%s: ip 0x%llx next 0x%llx\n",
 		       __FUNCTION__,
-		       vcpu->svm->vmcb->save.rip,
-		       vcpu->svm->next_rip);
+		       svm->vmcb->save.rip,
+		       svm->next_rip);
 	}
 
-	vcpu->rip = vcpu->svm->vmcb->save.rip = vcpu->svm->next_rip;
-	vcpu->svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
+	vcpu->rip = svm->vmcb->save.rip = svm->next_rip;
+	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
 
 	vcpu->interrupt_window_open = 1;
 }
@@ -569,23 +578,27 @@ static void init_vmcb(struct vmcb *vmcb)
 
 static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm;
 	struct page *page;
 	int r;
 
 	r = -ENOMEM;
-	vcpu->svm = kzalloc(sizeof *vcpu->svm, GFP_KERNEL);
-	if (!vcpu->svm)
+	svm = kzalloc(sizeof *svm, GFP_KERNEL);
+	if (!svm)
 		goto out1;
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
 		goto out2;
 
-	vcpu->svm->vmcb = page_address(page);
-	clear_page(vcpu->svm->vmcb);
-	vcpu->svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
-	vcpu->svm->asid_generation = 0;
-	memset(vcpu->svm->db_regs, 0, sizeof(vcpu->svm->db_regs));
-	init_vmcb(vcpu->svm->vmcb);
+	svm->vmcb = page_address(page);
+	clear_page(svm->vmcb);
+	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
+	svm->asid_generation = 0;
+	memset(svm->db_regs, 0, sizeof(svm->db_regs));
+	init_vmcb(svm->vmcb);
+
+	svm->vcpu   = vcpu;
+	vcpu->_priv = svm;
 
 	fx_init(vcpu);
 	vcpu->fpu_active = 1;
@@ -596,22 +609,26 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	return 0;
 
 out2:
-	kfree(vcpu->svm);
+	kfree(svm);
 out1:
 	return r;
 }
 
 static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->svm)
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!svm)
 		return;
-	if (vcpu->svm->vmcb)
-		__free_page(pfn_to_page(vcpu->svm->vmcb_pa >> PAGE_SHIFT));
-	kfree(vcpu->svm);
+	if (svm->vmcb)
+		__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
+	kfree(svm);
+	vcpu->_priv = NULL;
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int cpu, i;
 
 	cpu = get_cpu();
@@ -624,20 +641,21 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu)
 		 */
 		rdtscll(tsc_this);
 		delta = vcpu->host_tsc - tsc_this;
-		vcpu->svm->vmcb->control.tsc_offset += delta;
+		svm->vmcb->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 	}
 
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		rdmsrl(host_save_user_msrs[i], vcpu->svm->host_user_msrs[i]);
+		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int i;
 
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		wrmsrl(host_save_user_msrs[i], vcpu->svm->host_user_msrs[i]);
+		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 	rdtscll(vcpu->host_tsc);
 	put_cpu();
@@ -649,31 +667,34 @@ static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
 
 static void svm_cache_regs(struct kvm_vcpu *vcpu)
 {
-	vcpu->regs[VCPU_REGS_RAX] = vcpu->svm->vmcb->save.rax;
-	vcpu->regs[VCPU_REGS_RSP] = vcpu->svm->vmcb->save.rsp;
-	vcpu->rip = vcpu->svm->vmcb->save.rip;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	vcpu->regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
+	vcpu->regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
+	vcpu->rip = svm->vmcb->save.rip;
 }
 
 static void svm_decache_regs(struct kvm_vcpu *vcpu)
 {
-	vcpu->svm->vmcb->save.rax = vcpu->regs[VCPU_REGS_RAX];
-	vcpu->svm->vmcb->save.rsp = vcpu->regs[VCPU_REGS_RSP];
-	vcpu->svm->vmcb->save.rip = vcpu->rip;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	svm->vmcb->save.rax = vcpu->regs[VCPU_REGS_RAX];
+	svm->vmcb->save.rsp = vcpu->regs[VCPU_REGS_RSP];
+	svm->vmcb->save.rip = vcpu->rip;
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
 {
-	return vcpu->svm->vmcb->save.rflags;
+	return to_svm(vcpu)->vmcb->save.rflags;
 }
 
 static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
-	vcpu->svm->vmcb->save.rflags = rflags;
+	to_svm(vcpu)->vmcb->save.rflags = rflags;
 }
 
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 {
-	struct vmcb_save_area *save = &vcpu->svm->vmcb->save;
+	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
 
 	switch (seg) {
 	case VCPU_SREG_CS: return &save->cs;
@@ -725,26 +746,34 @@ static void svm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 
 static void svm_get_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	dt->limit = vcpu->svm->vmcb->save.idtr.limit;
-	dt->base = vcpu->svm->vmcb->save.idtr.base;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	dt->limit = svm->vmcb->save.idtr.limit;
+	dt->base = svm->vmcb->save.idtr.base;
 }
 
 static void svm_set_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	vcpu->svm->vmcb->save.idtr.limit = dt->limit;
-	vcpu->svm->vmcb->save.idtr.base = dt->base ;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->save.idtr.limit = dt->limit;
+	svm->vmcb->save.idtr.base = dt->base ;
 }
 
 static void svm_get_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	dt->limit = vcpu->svm->vmcb->save.gdtr.limit;
-	dt->base = vcpu->svm->vmcb->save.gdtr.base;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	dt->limit = svm->vmcb->save.gdtr.limit;
+	dt->base = svm->vmcb->save.gdtr.base;
 }
 
 static void svm_set_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	vcpu->svm->vmcb->save.gdtr.limit = dt->limit;
-	vcpu->svm->vmcb->save.gdtr.base = dt->base ;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->save.gdtr.limit = dt->limit;
+	svm->vmcb->save.gdtr.base = dt->base ;
 }
 
 static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
@@ -753,39 +782,42 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 #ifdef CONFIG_X86_64
 	if (vcpu->shadow_efer & KVM_EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->shadow_efer |= KVM_EFER_LMA;
-			vcpu->svm->vmcb->save.efer |= KVM_EFER_LMA | KVM_EFER_LME;
+			svm->vmcb->save.efer |= KVM_EFER_LMA | KVM_EFER_LME;
 		}
 
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG) ) {
 			vcpu->shadow_efer &= ~KVM_EFER_LMA;
-			vcpu->svm->vmcb->save.efer &= ~(KVM_EFER_LMA | KVM_EFER_LME);
+			svm->vmcb->save.efer &= ~(KVM_EFER_LMA | KVM_EFER_LME);
 		}
 	}
 #endif
 	if ((vcpu->cr0 & X86_CR0_TS) && !(cr0 & X86_CR0_TS)) {
-		vcpu->svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
+		svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
 		vcpu->fpu_active = 1;
 	}
 
 	vcpu->cr0 = cr0;
 	cr0 |= X86_CR0_PG | X86_CR0_WP;
 	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
-	vcpu->svm->vmcb->save.cr0 = cr0;
+	svm->vmcb->save.cr0 = cr0;
 }
 
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
        vcpu->cr4 = cr4;
-       vcpu->svm->vmcb->save.cr4 = cr4 | X86_CR4_PAE;
+       to_svm(vcpu)->vmcb->save.cr4 = cr4 | X86_CR4_PAE;
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_seg *s = svm_seg(vcpu, seg);
 
 	s->base = var->base;
@@ -804,16 +836,16 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 		s->attrib |= (var->g & 1) << SVM_SELECTOR_G_SHIFT;
 	}
 	if (seg == VCPU_SREG_CS)
-		vcpu->svm->vmcb->save.cpl
-			= (vcpu->svm->vmcb->save.cs.attrib
+		svm->vmcb->save.cpl
+			= (svm->vmcb->save.cs.attrib
 			   >> SVM_SELECTOR_DPL_SHIFT) & 3;
 
 }
 
 /* FIXME:
 
-	vcpu->svm->vmcb->control.int_ctl &= ~V_TPR_MASK;
-	vcpu->svm->vmcb->control.int_ctl |= (sregs->cr8 & V_TPR_MASK);
+	svm(vcpu)->vmcb->control.int_ctl &= ~V_TPR_MASK;
+	svm(vcpu)->vmcb->control.int_ctl |= (sregs->cr8 & V_TPR_MASK);
 
 */
 
@@ -825,55 +857,59 @@ static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 static void load_host_msrs(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	wrmsrl(MSR_GS_BASE, vcpu->svm->host_gs_base);
+	wrmsrl(MSR_GS_BASE, to_svm(vcpu)->host_gs_base);
 #endif
 }
 
 static void save_host_msrs(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	rdmsrl(MSR_GS_BASE, vcpu->svm->host_gs_base);
+	rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host_gs_base);
 #endif
 }
 
 static void new_asid(struct kvm_vcpu *vcpu, struct svm_cpu_data *svm_data)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	if (svm_data->next_asid > svm_data->max_asid) {
 		++svm_data->asid_generation;
 		svm_data->next_asid = 1;
-		vcpu->svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 
 	vcpu->cpu = svm_data->cpu;
-	vcpu->svm->asid_generation = svm_data->asid_generation;
-	vcpu->svm->vmcb->control.asid = svm_data->next_asid++;
+	svm->asid_generation = svm_data->asid_generation;
+	svm->vmcb->control.asid = svm_data->next_asid++;
 }
 
 static void svm_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 {
-	invlpga(address, vcpu->svm->vmcb->control.asid); // is needed?
+	invlpga(address, to_svm(vcpu)->vmcb->control.asid); // is needed?
 }
 
 static unsigned long svm_get_dr(struct kvm_vcpu *vcpu, int dr)
 {
-	return vcpu->svm->db_regs[dr];
+	return to_svm(vcpu)->db_regs[dr];
 }
 
 static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 		       int *exception)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	*exception = 0;
 
-	if (vcpu->svm->vmcb->save.dr7 & DR7_GD_MASK) {
-		vcpu->svm->vmcb->save.dr7 &= ~DR7_GD_MASK;
-		vcpu->svm->vmcb->save.dr6 |= DR6_BD_MASK;
+	if (svm->vmcb->save.dr7 & DR7_GD_MASK) {
+		svm->vmcb->save.dr7 &= ~DR7_GD_MASK;
+		svm->vmcb->save.dr6 |= DR6_BD_MASK;
 		*exception = DB_VECTOR;
 		return;
 	}
 
 	switch (dr) {
 	case 0 ... 3:
-		vcpu->svm->db_regs[dr] = value;
+		svm->db_regs[dr] = value;
 		return;
 	case 4 ... 5:
 		if (vcpu->cr4 & X86_CR4_DE) {
@@ -885,7 +921,7 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 			*exception = GP_VECTOR;
 			return;
 		}
-		vcpu->svm->vmcb->save.dr7 = value;
+		svm->vmcb->save.dr7 = value;
 		return;
 	}
 	default:
@@ -898,7 +934,8 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 
 static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u32 exit_int_info = vcpu->svm->vmcb->control.exit_int_info;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 exit_int_info = svm->vmcb->control.exit_int_info;
 	u64 fault_address;
 	u32 error_code;
 	enum emulation_result er;
@@ -909,8 +946,8 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	spin_lock(&vcpu->kvm->lock);
 
-	fault_address  = vcpu->svm->vmcb->control.exit_info_2;
-	error_code = vcpu->svm->vmcb->control.exit_info_1;
+	fault_address  = svm->vmcb->control.exit_info_2;
+	error_code = svm->vmcb->control.exit_info_1;
 	r = kvm_mmu_page_fault(vcpu, fault_address, error_code);
 	if (r < 0) {
 		spin_unlock(&vcpu->kvm->lock);
@@ -942,22 +979,25 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int nm_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-       vcpu->svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
-       if (!(vcpu->cr0 & X86_CR0_TS))
-               vcpu->svm->vmcb->save.cr0 &= ~X86_CR0_TS;
-       vcpu->fpu_active = 1;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
-       return 1;
+	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
+	if (!(vcpu->cr0 & X86_CR0_TS))
+		svm->vmcb->save.cr0 &= ~X86_CR0_TS;
+	vcpu->fpu_active = 1;
+
+	return 1;
 }
 
 static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept
 	 * so reinitialize it.
 	 */
-	clear_page(vcpu->svm->vmcb);
-	init_vmcb(vcpu->svm->vmcb);
+	clear_page(svm->vmcb);
+	init_vmcb(svm->vmcb);
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
 	return 0;
@@ -967,23 +1007,24 @@ static int io_get_override(struct kvm_vcpu *vcpu,
 			  struct vmcb_seg **seg,
 			  int *addr_override)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u8 inst[MAX_INST_SIZE];
 	unsigned ins_length;
 	gva_t rip;
 	int i;
 
-	rip =  vcpu->svm->vmcb->save.rip;
-	ins_length = vcpu->svm->next_rip - rip;
-	rip += vcpu->svm->vmcb->save.cs.base;
+	rip =  svm->vmcb->save.rip;
+	ins_length = svm->next_rip - rip;
+	rip += svm->vmcb->save.cs.base;
 
 	if (ins_length > MAX_INST_SIZE)
 		printk(KERN_DEBUG
 		       "%s: inst length err, cs base 0x%llx rip 0x%llx "
 		       "next rip 0x%llx ins_length %u\n",
 		       __FUNCTION__,
-		       vcpu->svm->vmcb->save.cs.base,
-		       vcpu->svm->vmcb->save.rip,
-		       vcpu->svm->vmcb->control.exit_info_2,
+		       svm->vmcb->save.cs.base,
+		       svm->vmcb->save.rip,
+		       svm->vmcb->control.exit_info_2,
 		       ins_length);
 
 	if (kvm_read_guest(vcpu, rip, ins_length, inst) != ins_length)
@@ -1003,22 +1044,22 @@ static int io_get_override(struct kvm_vcpu *vcpu,
 			*addr_override = 1;
 			continue;
 		case 0x2e:
-			*seg = &vcpu->svm->vmcb->save.cs;
+			*seg = &svm->vmcb->save.cs;
 			continue;
 		case 0x36:
-			*seg = &vcpu->svm->vmcb->save.ss;
+			*seg = &svm->vmcb->save.ss;
 			continue;
 		case 0x3e:
-			*seg = &vcpu->svm->vmcb->save.ds;
+			*seg = &svm->vmcb->save.ds;
 			continue;
 		case 0x26:
-			*seg = &vcpu->svm->vmcb->save.es;
+			*seg = &svm->vmcb->save.es;
 			continue;
 		case 0x64:
-			*seg = &vcpu->svm->vmcb->save.fs;
+			*seg = &svm->vmcb->save.fs;
 			continue;
 		case 0x65:
-			*seg = &vcpu->svm->vmcb->save.gs;
+			*seg = &svm->vmcb->save.gs;
 			continue;
 		default:
 			return 1;
@@ -1033,7 +1074,8 @@ static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, gva_t *address)
 	unsigned long *reg;
 	struct vmcb_seg *seg;
 	int addr_override;
-	struct vmcb_save_area *save_area = &vcpu->svm->vmcb->save;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_save_area *save_area = &svm->vmcb->save;
 	u16 cs_attrib = save_area->cs.attrib;
 	unsigned addr_size = get_addr_size(vcpu);
 
@@ -1045,16 +1087,16 @@ static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, gva_t *address)
 
 	if (ins) {
 		reg = &vcpu->regs[VCPU_REGS_RDI];
-		seg = &vcpu->svm->vmcb->save.es;
+		seg = &svm->vmcb->save.es;
 	} else {
 		reg = &vcpu->regs[VCPU_REGS_RSI];
-		seg = (seg) ? seg : &vcpu->svm->vmcb->save.ds;
+		seg = (seg) ? seg : &svm->vmcb->save.ds;
 	}
 
 	addr_mask = ~0ULL >> (64 - (addr_size * 8));
 
 	if ((cs_attrib & SVM_SELECTOR_L_MASK) &&
-	    !(vcpu->svm->vmcb->save.rflags & X86_EFLAGS_VM)) {
+	    !(svm->vmcb->save.rflags & X86_EFLAGS_VM)) {
 		*address = (*reg & addr_mask);
 		return addr_mask;
 	}
@@ -1070,7 +1112,8 @@ static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, gva_t *address)
 
 static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u32 io_info = vcpu->svm->vmcb->control.exit_info_1; //address size bug?
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 io_info = svm->vmcb->control.exit_info_1; //address size bug?
 	int size, down, in, string, rep;
 	unsigned port;
 	unsigned long count;
@@ -1078,7 +1121,7 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	++vcpu->stat.io_exits;
 
-	vcpu->svm->next_rip = vcpu->svm->vmcb->control.exit_info_2;
+	svm->next_rip = svm->vmcb->control.exit_info_2;
 
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
 	port = io_info >> 16;
@@ -1086,7 +1129,7 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	rep = (io_info & SVM_IOIO_REP_MASK) != 0;
 	count = 1;
-	down = (vcpu->svm->vmcb->save.rflags & X86_EFLAGS_DF) != 0;
+	down = (svm->vmcb->save.rflags & X86_EFLAGS_DF) != 0;
 
 	if (string) {
 		unsigned addr_mask;
@@ -1112,14 +1155,18 @@ static int nop_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int halt_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 1;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->next_rip = svm->vmcb->save.rip + 1;
 	skip_emulated_instruction(vcpu);
 	return kvm_emulate_halt(vcpu);
 }
 
 static int vmmcall_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 3;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->next_rip = svm->vmcb->save.rip + 3;
 	skip_emulated_instruction(vcpu);
 	return kvm_hypercall(vcpu, kvm_run);
 }
@@ -1139,7 +1186,9 @@ static int task_switch_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_r
 
 static int cpuid_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 2;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->next_rip = svm->vmcb->save.rip + 2;
 	kvm_emulate_cpuid(vcpu);
 	return 1;
 }
@@ -1153,39 +1202,41 @@ static int emulate_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_ru
 
 static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	switch (ecx) {
 	case MSR_IA32_TIME_STAMP_COUNTER: {
 		u64 tsc;
 
 		rdtscll(tsc);
-		*data = vcpu->svm->vmcb->control.tsc_offset + tsc;
+		*data = svm->vmcb->control.tsc_offset + tsc;
 		break;
 	}
 	case MSR_K6_STAR:
-		*data = vcpu->svm->vmcb->save.star;
+		*data = svm->vmcb->save.star;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_LSTAR:
-		*data = vcpu->svm->vmcb->save.lstar;
+		*data = svm->vmcb->save.lstar;
 		break;
 	case MSR_CSTAR:
-		*data = vcpu->svm->vmcb->save.cstar;
+		*data = svm->vmcb->save.cstar;
 		break;
 	case MSR_KERNEL_GS_BASE:
-		*data = vcpu->svm->vmcb->save.kernel_gs_base;
+		*data = svm->vmcb->save.kernel_gs_base;
 		break;
 	case MSR_SYSCALL_MASK:
-		*data = vcpu->svm->vmcb->save.sfmask;
+		*data = svm->vmcb->save.sfmask;
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		*data = vcpu->svm->vmcb->save.sysenter_cs;
+		*data = svm->vmcb->save.sysenter_cs;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		*data = vcpu->svm->vmcb->save.sysenter_eip;
+		*data = svm->vmcb->save.sysenter_eip;
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		*data = vcpu->svm->vmcb->save.sysenter_esp;
+		*data = svm->vmcb->save.sysenter_esp;
 		break;
 	default:
 		return kvm_get_msr_common(vcpu, ecx, data);
@@ -1195,15 +1246,16 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 
 static int rdmsr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
 	u64 data;
 
 	if (svm_get_msr(vcpu, ecx, &data))
 		svm_inject_gp(vcpu, 0);
 	else {
-		vcpu->svm->vmcb->save.rax = data & 0xffffffff;
+		svm->vmcb->save.rax = data & 0xffffffff;
 		vcpu->regs[VCPU_REGS_RDX] = data >> 32;
-		vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 2;
+		svm->next_rip = svm->vmcb->save.rip + 2;
 		skip_emulated_instruction(vcpu);
 	}
 	return 1;
@@ -1211,39 +1263,41 @@ static int rdmsr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	switch (ecx) {
 	case MSR_IA32_TIME_STAMP_COUNTER: {
 		u64 tsc;
 
 		rdtscll(tsc);
-		vcpu->svm->vmcb->control.tsc_offset = data - tsc;
+		svm->vmcb->control.tsc_offset = data - tsc;
 		break;
 	}
 	case MSR_K6_STAR:
-		vcpu->svm->vmcb->save.star = data;
+		svm->vmcb->save.star = data;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_LSTAR:
-		vcpu->svm->vmcb->save.lstar = data;
+		svm->vmcb->save.lstar = data;
 		break;
 	case MSR_CSTAR:
-		vcpu->svm->vmcb->save.cstar = data;
+		svm->vmcb->save.cstar = data;
 		break;
 	case MSR_KERNEL_GS_BASE:
-		vcpu->svm->vmcb->save.kernel_gs_base = data;
+		svm->vmcb->save.kernel_gs_base = data;
 		break;
 	case MSR_SYSCALL_MASK:
-		vcpu->svm->vmcb->save.sfmask = data;
+		svm->vmcb->save.sfmask = data;
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		vcpu->svm->vmcb->save.sysenter_cs = data;
+		svm->vmcb->save.sysenter_cs = data;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		vcpu->svm->vmcb->save.sysenter_eip = data;
+		svm->vmcb->save.sysenter_eip = data;
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		vcpu->svm->vmcb->save.sysenter_esp = data;
+		svm->vmcb->save.sysenter_esp = data;
 		break;
 	default:
 		return kvm_set_msr_common(vcpu, ecx, data);
@@ -1253,10 +1307,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 
 static int wrmsr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
-	u64 data = (vcpu->svm->vmcb->save.rax & -1u)
+	u64 data = (svm->vmcb->save.rax & -1u)
 		| ((u64)(vcpu->regs[VCPU_REGS_RDX] & -1u) << 32);
-	vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 2;
+	svm->next_rip = svm->vmcb->save.rip + 2;
 	if (svm_set_msr(vcpu, ecx, data))
 		svm_inject_gp(vcpu, 0);
 	else
@@ -1266,7 +1321,7 @@ static int wrmsr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int msr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	if (vcpu->svm->vmcb->control.exit_info_1)
+	if (to_svm(vcpu)->vmcb->control.exit_info_1)
 		return wrmsr_interception(vcpu, kvm_run);
 	else
 		return rdmsr_interception(vcpu, kvm_run);
@@ -1338,13 +1393,14 @@ static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
 
 static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u32 exit_code = vcpu->svm->vmcb->control.exit_code;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 exit_code = svm->vmcb->control.exit_code;
 
-	if (is_external_interrupt(vcpu->svm->vmcb->control.exit_int_info) &&
+	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
 	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
 		       "exit_code 0x%x\n",
-		       __FUNCTION__, vcpu->svm->vmcb->control.exit_int_info,
+		       __FUNCTION__, svm->vmcb->control.exit_int_info,
 		       exit_code);
 
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
@@ -1368,13 +1424,14 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 
 static void pre_svm_run(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int cpu = raw_smp_processor_id();
 
 	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
 
-	vcpu->svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 	if (vcpu->cpu != cpu ||
-	    vcpu->svm->asid_generation != svm_data->asid_generation)
+	    svm->asid_generation != svm_data->asid_generation)
 		new_asid(vcpu, svm_data);
 }
 
@@ -1383,7 +1440,7 @@ static inline void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vmcb_control_area *control;
 
-	control = &vcpu->svm->vmcb->control;
+	control = &to_svm(vcpu)->vmcb->control;
 	control->int_vector = pop_irq(vcpu);
 	control->int_ctl &= ~V_INTR_PRIO_MASK;
 	control->int_ctl |= V_IRQ_MASK |
@@ -1392,7 +1449,7 @@ static inline void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 
 static void kvm_reput_irq(struct kvm_vcpu *vcpu)
 {
-	struct vmcb_control_area *control = &vcpu->svm->vmcb->control;
+	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
 
 	if (control->int_ctl & V_IRQ_MASK) {
 		control->int_ctl &= ~V_IRQ_MASK;
@@ -1406,11 +1463,12 @@ static void kvm_reput_irq(struct kvm_vcpu *vcpu)
 static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 				       struct kvm_run *kvm_run)
 {
-	struct vmcb_control_area *control = &vcpu->svm->vmcb->control;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
 
 	vcpu->interrupt_window_open =
 		(!(control->int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		 (vcpu->svm->vmcb->save.rflags & X86_EFLAGS_IF));
+		 (svm->vmcb->save.rflags & X86_EFLAGS_IF));
 
 	if (vcpu->interrupt_window_open && vcpu->irq_summary)
 		/*
@@ -1431,9 +1489,11 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 			      struct kvm_run *kvm_run)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	kvm_run->ready_for_interrupt_injection = (vcpu->interrupt_window_open &&
 						  vcpu->irq_summary == 0);
-	kvm_run->if_flag = (vcpu->svm->vmcb->save.rflags & X86_EFLAGS_IF) != 0;
+	kvm_run->if_flag = (svm->vmcb->save.rflags & X86_EFLAGS_IF) != 0;
 	kvm_run->cr8 = vcpu->cr8;
 	kvm_run->apic_base = vcpu->apic_base;
 }
@@ -1450,7 +1510,7 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 	return (!vcpu->irq_summary &&
 		kvm_run->request_interrupt_window &&
 		vcpu->interrupt_window_open &&
-		(vcpu->svm->vmcb->save.rflags & X86_EFLAGS_IF));
+		(to_svm(vcpu)->vmcb->save.rflags & X86_EFLAGS_IF));
 }
 
 static void save_db_regs(unsigned long *db_regs)
@@ -1476,6 +1536,7 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 
 static int svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u16 fs_selector;
 	u16 gs_selector;
 	u16 ldt_selector;
@@ -1502,15 +1563,15 @@ again:
 	fs_selector = read_fs();
 	gs_selector = read_gs();
 	ldt_selector = read_ldt();
-	vcpu->svm->host_cr2 = kvm_read_cr2();
-	vcpu->svm->host_dr6 = read_dr6();
-	vcpu->svm->host_dr7 = read_dr7();
-	vcpu->svm->vmcb->save.cr2 = vcpu->cr2;
+	svm->host_cr2 = kvm_read_cr2();
+	svm->host_dr6 = read_dr6();
+	svm->host_dr7 = read_dr7();
+	svm->vmcb->save.cr2 = vcpu->cr2;
 
-	if (vcpu->svm->vmcb->save.dr7 & 0xff) {
+	if (svm->vmcb->save.dr7 & 0xff) {
 		write_dr7(0);
-		save_db_regs(vcpu->svm->host_db_regs);
-		load_db_regs(vcpu->svm->db_regs);
+		save_db_regs(svm->host_db_regs);
+		load_db_regs(svm->db_regs);
 	}
 
 	if (vcpu->fpu_active) {
@@ -1607,7 +1668,7 @@ again:
 #endif
 		:
 		: [vcpu]"a"(vcpu),
-		  [svm]"i"(offsetof(struct kvm_vcpu, svm)),
+		  [svm]"i"(offsetof(struct kvm_vcpu, _priv)),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
 		  [rbx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBX])),
 		  [rcx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RCX])),
@@ -1634,14 +1695,14 @@ again:
 		fx_restore(vcpu->host_fx_image);
 	}
 
-	if ((vcpu->svm->vmcb->save.dr7 & 0xff))
-		load_db_regs(vcpu->svm->host_db_regs);
+	if ((svm->vmcb->save.dr7 & 0xff))
+		load_db_regs(svm->host_db_regs);
 
-	vcpu->cr2 = vcpu->svm->vmcb->save.cr2;
+	vcpu->cr2 = svm->vmcb->save.cr2;
 
-	write_dr6(vcpu->svm->host_dr6);
-	write_dr7(vcpu->svm->host_dr7);
-	kvm_write_cr2(vcpu->svm->host_cr2);
+	write_dr6(svm->host_dr6);
+	write_dr7(svm->host_dr7);
+	kvm_write_cr2(svm->host_cr2);
 
 	load_fs(fs_selector);
 	load_gs(gs_selector);
@@ -1655,18 +1716,18 @@ again:
 	 */
 	if (unlikely(prof_on == KVM_PROFILING))
 		profile_hit(KVM_PROFILING,
-			(void *)(unsigned long)vcpu->svm->vmcb->save.rip);
+			(void *)(unsigned long)svm->vmcb->save.rip);
 
 	stgi();
 
 	kvm_reput_irq(vcpu);
 
-	vcpu->svm->next_rip = 0;
+	svm->next_rip = 0;
 
-	if (vcpu->svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
+	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
-			= vcpu->svm->vmcb->control.exit_code;
+			= svm->vmcb->control.exit_code;
 		post_kvm_run_save(vcpu, kvm_run);
 		return 0;
 	}
@@ -1695,12 +1756,14 @@ again:
 
 static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 {
-	vcpu->svm->vmcb->save.cr3 = root;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->save.cr3 = root;
 	force_new_asid(vcpu);
 
 	if (vcpu->fpu_active) {
-		vcpu->svm->vmcb->control.intercept_exceptions |= (1 << NM_VECTOR);
-		vcpu->svm->vmcb->save.cr0 |= X86_CR0_TS;
+		svm->vmcb->control.intercept_exceptions |= (1 << NM_VECTOR);
+		svm->vmcb->save.cr0 |= X86_CR0_TS;
 		vcpu->fpu_active = 0;
 	}
 }
@@ -1709,26 +1772,27 @@ static void svm_inject_page_fault(struct kvm_vcpu *vcpu,
 				  unsigned long  addr,
 				  uint32_t err_code)
 {
-	uint32_t exit_int_info = vcpu->svm->vmcb->control.exit_int_info;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	uint32_t exit_int_info = svm->vmcb->control.exit_int_info;
 
 	++vcpu->stat.pf_guest;
 
 	if (is_page_fault(exit_int_info)) {
 
-		vcpu->svm->vmcb->control.event_inj_err = 0;
-		vcpu->svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
-							SVM_EVTINJ_VALID_ERR |
-							SVM_EVTINJ_TYPE_EXEPT |
-							DF_VECTOR;
+		svm->vmcb->control.event_inj_err = 0;
+		svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
+						SVM_EVTINJ_VALID_ERR |
+						SVM_EVTINJ_TYPE_EXEPT |
+						DF_VECTOR;
 		return;
 	}
 	vcpu->cr2 = addr;
-	vcpu->svm->vmcb->save.cr2 = addr;
-	vcpu->svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
-						SVM_EVTINJ_VALID_ERR |
-						SVM_EVTINJ_TYPE_EXEPT |
-						PF_VECTOR;
-	vcpu->svm->vmcb->control.event_inj_err = err_code;
+	svm->vmcb->save.cr2 = addr;
+	svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
+					SVM_EVTINJ_VALID_ERR |
+					SVM_EVTINJ_TYPE_EXEPT |
+					PF_VECTOR;
+	svm->vmcb->control.event_inj_err = err_code;
 }
 
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index dac2f93..96837d6 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -32,6 +32,37 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+struct vmcs {
+	u32 revision_id;
+	u32 abort;
+	char data[0];
+};
+
+struct vcpu_vmx {
+	struct kvm_vcpu      *vcpu;
+	int                   launched;
+	struct kvm_msr_entry *guest_msrs;
+	struct kvm_msr_entry *host_msrs;
+	int                   nmsrs;
+	int                   save_nmsrs;
+	int                   msr_offset_efer;
+#ifdef CONFIG_X86_64
+	int                   msr_offset_kernel_gs_base;
+#endif
+	struct vmcs          *vmcs;
+	struct {
+		int           loaded;
+		u16           fs_sel, gs_sel, ldt_sel;
+		int           fs_gs_ldt_reload_needed;
+	}host_state;
+
+};
+
+static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
+{
+	return (struct vcpu_vmx*)vcpu->_priv;
+}
+
 static int init_rmode_tss(struct kvm *kvm);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
@@ -89,16 +120,33 @@ static const u32 vmx_msr_index[] = {
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
-static inline u64 msr_efer_save_restore_bits(struct vmx_msr_entry msr)
+static void load_msrs(struct kvm_msr_entry *e, int n)
+{
+	int i;
+
+	for (i = 0; i < n; ++i)
+		wrmsrl(e[i].index, e[i].data);
+}
+
+static void save_msrs(struct kvm_msr_entry *e, int n)
+{
+	int i;
+
+	for (i = 0; i < n; ++i)
+		rdmsrl(e[i].index, e[i].data);
+}
+
+static inline u64 msr_efer_save_restore_bits(struct kvm_msr_entry msr)
 {
 	return (u64)msr.data & EFER_SAVE_RESTORE_BITS;
 }
 
 static inline int msr_efer_need_save_restore(struct kvm_vcpu *vcpu)
 {
-	int efer_offset = vcpu->msr_offset_efer;
-	return msr_efer_save_restore_bits(vcpu->host_msrs[efer_offset]) !=
-		msr_efer_save_restore_bits(vcpu->guest_msrs[efer_offset]);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int efer_offset = vmx->msr_offset_efer;
+	return msr_efer_save_restore_bits(vmx->host_msrs[efer_offset]) !=
+		msr_efer_save_restore_bits(vmx->guest_msrs[efer_offset]);
 }
 
 static inline int is_page_fault(u32 intr_info)
@@ -123,21 +171,23 @@ static inline int is_external_interrupt(u32 intr_info)
 
 static int __find_msr_index(struct kvm_vcpu *vcpu, u32 msr)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int i;
 
-	for (i = 0; i < vcpu->nmsrs; ++i)
-		if (vcpu->guest_msrs[i].index == msr)
+	for (i = 0; i < vmx->nmsrs; ++i)
+		if (vmx->guest_msrs[i].index == msr)
 			return i;
 	return -1;
 }
 
-static struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
+static struct kvm_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int i;
 
 	i = __find_msr_index(vcpu, msr);
 	if (i >= 0)
-		return &vcpu->guest_msrs[i];
+		return &vmx->guest_msrs[i];
 	return NULL;
 }
 
@@ -157,11 +207,12 @@ static void vmcs_clear(struct vmcs *vmcs)
 static void __vcpu_clear(void *arg)
 {
 	struct kvm_vcpu *vcpu = arg;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int cpu = raw_smp_processor_id();
 
 	if (vcpu->cpu == cpu)
-		vmcs_clear(vcpu->vmcs);
-	if (per_cpu(current_vmcs, cpu) == vcpu->vmcs)
+		vmcs_clear(vmx->vmcs);
+	if (per_cpu(current_vmcs, cpu) == vmx->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
 	rdtscll(vcpu->host_tsc);
 }
@@ -172,7 +223,7 @@ static void vcpu_clear(struct kvm_vcpu *vcpu)
 		smp_call_function_single(vcpu->cpu, __vcpu_clear, vcpu, 0, 1);
 	else
 		__vcpu_clear(vcpu);
-	vcpu->launched = 0;
+	to_vmx(vcpu)->launched = 0;
 }
 
 static unsigned long vmcs_readl(unsigned long field)
@@ -285,80 +336,81 @@ static void reload_tss(void)
 static void load_transition_efer(struct kvm_vcpu *vcpu)
 {
 	u64 trans_efer;
-	int efer_offset = vcpu->msr_offset_efer;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int efer_offset = vmx->msr_offset_efer;
 
-	trans_efer = vcpu->host_msrs[efer_offset].data;
+	trans_efer = vmx->host_msrs[efer_offset].data;
 	trans_efer &= ~EFER_SAVE_RESTORE_BITS;
-	trans_efer |= msr_efer_save_restore_bits(
-				vcpu->guest_msrs[efer_offset]);
+	trans_efer |= msr_efer_save_restore_bits(vmx->guest_msrs[efer_offset]);
 	wrmsrl(MSR_EFER, trans_efer);
 	vcpu->stat.efer_reload++;
 }
 
 static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 {
-	struct vmx_host_state *hs = &vcpu->vmx_host_state;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (hs->loaded)
+	if (vmx->host_state.loaded)
 		return;
 
-	hs->loaded = 1;
+	vmx->host_state.loaded = 1;
 	/*
 	 * Set host fs and gs selectors.  Unfortunately, 22.2.3 does not
 	 * allow segment selectors with cpl > 0 or ti == 1.
 	 */
-	hs->ldt_sel = read_ldt();
-	hs->fs_gs_ldt_reload_needed = hs->ldt_sel;
-	hs->fs_sel = read_fs();
-	if (!(hs->fs_sel & 7))
-		vmcs_write16(HOST_FS_SELECTOR, hs->fs_sel);
+	vmx->host_state.ldt_sel = read_ldt();
+	vmx->host_state.fs_gs_ldt_reload_needed = vmx->host_state.ldt_sel;
+	vmx->host_state.fs_sel = read_fs();
+	if (!(vmx->host_state.fs_sel & 7))
+		vmcs_write16(HOST_FS_SELECTOR, vmx->host_state.fs_sel);
 	else {
 		vmcs_write16(HOST_FS_SELECTOR, 0);
-		hs->fs_gs_ldt_reload_needed = 1;
+		vmx->host_state.fs_gs_ldt_reload_needed = 1;
 	}
-	hs->gs_sel = read_gs();
-	if (!(hs->gs_sel & 7))
-		vmcs_write16(HOST_GS_SELECTOR, hs->gs_sel);
+	vmx->host_state.gs_sel = read_gs();
+	if (!(vmx->host_state.gs_sel & 7))
+		vmcs_write16(HOST_GS_SELECTOR, vmx->host_state.gs_sel);
 	else {
 		vmcs_write16(HOST_GS_SELECTOR, 0);
-		hs->fs_gs_ldt_reload_needed = 1;
+		vmx->host_state.fs_gs_ldt_reload_needed = 1;
 	}
 
 #ifdef CONFIG_X86_64
 	vmcs_writel(HOST_FS_BASE, read_msr(MSR_FS_BASE));
 	vmcs_writel(HOST_GS_BASE, read_msr(MSR_GS_BASE));
 #else
-	vmcs_writel(HOST_FS_BASE, segment_base(hs->fs_sel));
-	vmcs_writel(HOST_GS_BASE, segment_base(hs->gs_sel));
+	vmcs_writel(HOST_FS_BASE, segment_base(vmx->host_state.fs_sel));
+	vmcs_writel(HOST_GS_BASE, segment_base(vmx->host_state.gs_sel));
 #endif
 
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
-		save_msrs(vcpu->host_msrs + vcpu->msr_offset_kernel_gs_base, 1);
+		save_msrs(vmx->host_msrs +
+			  vmx->msr_offset_kernel_gs_base, 1);
 	}
 #endif
-	load_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
+	load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	if (msr_efer_need_save_restore(vcpu))
 		load_transition_efer(vcpu);
 }
 
 static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 {
-	struct vmx_host_state *hs = &vcpu->vmx_host_state;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!hs->loaded)
+	if (!vmx->host_state.loaded)
 		return;
 
-	hs->loaded = 0;
-	if (hs->fs_gs_ldt_reload_needed) {
-		load_ldt(hs->ldt_sel);
-		load_fs(hs->fs_sel);
+	vmx->host_state.loaded = 0;
+	if (vmx->host_state.fs_gs_ldt_reload_needed) {
+		load_ldt(vmx->host_state.ldt_sel);
+		load_fs(vmx->host_state.fs_sel);
 		/*
 		 * If we have to reload gs, we must take care to
 		 * preserve our gs base.
 		 */
 		local_irq_disable();
-		load_gs(hs->gs_sel);
+		load_gs(vmx->host_state.gs_sel);
 #ifdef CONFIG_X86_64
 		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
 #endif
@@ -366,10 +418,10 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 
 		reload_tss();
 	}
-	save_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
-	load_msrs(vcpu->host_msrs, vcpu->save_nmsrs);
+	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
+	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
 	if (msr_efer_need_save_restore(vcpu))
-		load_msrs(vcpu->host_msrs + vcpu->msr_offset_efer, 1);
+		load_msrs(vmx->host_msrs + vmx->msr_offset_efer, 1);
 }
 
 /*
@@ -378,7 +430,8 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
  */
 static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 {
-	u64 phys_addr = __pa(vcpu->vmcs);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 phys_addr = __pa(vmx->vmcs);
 	int cpu;
 	u64 tsc_this, delta;
 
@@ -387,16 +440,16 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 	if (vcpu->cpu != cpu)
 		vcpu_clear(vcpu);
 
-	if (per_cpu(current_vmcs, cpu) != vcpu->vmcs) {
+	if (per_cpu(current_vmcs, cpu) != vmx->vmcs) {
 		u8 error;
 
-		per_cpu(current_vmcs, cpu) = vcpu->vmcs;
+		per_cpu(current_vmcs, cpu) = vmx->vmcs;
 		asm volatile (ASM_VMX_VMPTRLD_RAX "; setna %0"
 			      : "=g"(error) : "a"(&phys_addr), "m"(phys_addr)
 			      : "cc");
 		if (error)
 			printk(KERN_ERR "kvm: vmptrld %p/%llx fail\n",
-			       vcpu->vmcs, phys_addr);
+			       vmx->vmcs, phys_addr);
 	}
 
 	if (vcpu->cpu != cpu) {
@@ -503,13 +556,15 @@ static void vmx_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
  */
 void move_msr_up(struct kvm_vcpu *vcpu, int from, int to)
 {
-	struct vmx_msr_entry tmp;
-	tmp = vcpu->guest_msrs[to];
-	vcpu->guest_msrs[to] = vcpu->guest_msrs[from];
-	vcpu->guest_msrs[from] = tmp;
-	tmp = vcpu->host_msrs[to];
-	vcpu->host_msrs[to] = vcpu->host_msrs[from];
-	vcpu->host_msrs[from] = tmp;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_msr_entry tmp;
+
+	tmp = vmx->guest_msrs[to];
+	vmx->guest_msrs[to] = vmx->guest_msrs[from];
+	vmx->guest_msrs[from] = tmp;
+	tmp = vmx->host_msrs[to];
+	vmx->host_msrs[to] = vmx->host_msrs[from];
+	vmx->host_msrs[from] = tmp;
 }
 
 /*
@@ -519,6 +574,7 @@ void move_msr_up(struct kvm_vcpu *vcpu, int from, int to)
  */
 static void setup_msrs(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int save_nmsrs;
 
 	save_nmsrs = 0;
@@ -547,13 +603,13 @@ static void setup_msrs(struct kvm_vcpu *vcpu)
 			move_msr_up(vcpu, index, save_nmsrs++);
 	}
 #endif
-	vcpu->save_nmsrs = save_nmsrs;
+	vmx->save_nmsrs = save_nmsrs;
 
 #ifdef CONFIG_X86_64
-	vcpu->msr_offset_kernel_gs_base =
+	vmx->msr_offset_kernel_gs_base =
 		__find_msr_index(vcpu, MSR_KERNEL_GS_BASE);
 #endif
-	vcpu->msr_offset_efer = __find_msr_index(vcpu, MSR_EFER);
+	vmx->msr_offset_efer = __find_msr_index(vcpu, MSR_EFER);
 }
 
 /*
@@ -589,7 +645,7 @@ static void guest_write_tsc(u64 guest_tsc)
 static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	u64 data;
-	struct vmx_msr_entry *msr;
+	struct kvm_msr_entry *msr;
 
 	if (!pdata) {
 		printk(KERN_ERR "BUG: get_msr called with NULL pdata\n");
@@ -639,14 +695,15 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
  */
 static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
-	struct vmx_msr_entry *msr;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_msr_entry *msr;
 	int ret = 0;
 
 	switch (msr_index) {
 #ifdef CONFIG_X86_64
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_index, data);
-		if (vcpu->vmx_host_state.loaded)
+		if (vmx->host_state.loaded)
 			load_transition_efer(vcpu);
 		break;
 	case MSR_FS_BASE:
@@ -672,8 +729,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		msr = find_msr_entry(vcpu, msr_index);
 		if (msr) {
 			msr->data = data;
-			if (vcpu->vmx_host_state.loaded)
-				load_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
+			if (vmx->host_state.loaded)
+				load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 			break;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_index, data);
@@ -1053,7 +1110,7 @@ static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	struct vmx_msr_entry *msr = find_msr_entry(vcpu, MSR_EFER);
+	struct kvm_msr_entry *msr = find_msr_entry(vcpu, MSR_EFER);
 
 	vcpu->shadow_efer = efer;
 	if (efer & EFER_LMA) {
@@ -1244,6 +1301,7 @@ static void seg_setup(int seg)
  */
 static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 host_sysenter_cs;
 	u32 junk;
 	unsigned long a;
@@ -1385,18 +1443,18 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
 		u64 data;
-		int j = vcpu->nmsrs;
+		int j = vmx->nmsrs;
 
 		if (rdmsr_safe(index, &data_low, &data_high) < 0)
 			continue;
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;
 		data = data_low | ((u64)data_high << 32);
-		vcpu->host_msrs[j].index = index;
-		vcpu->host_msrs[j].reserved = 0;
-		vcpu->host_msrs[j].data = data;
-		vcpu->guest_msrs[j] = vcpu->host_msrs[j];
-		++vcpu->nmsrs;
+		vmx->host_msrs[j].index = index;
+		vmx->host_msrs[j].reserved = 0;
+		vmx->host_msrs[j].data = data;
+		vmx->guest_msrs[j] = vmx->host_msrs[j];
+		++vmx->nmsrs;
 	}
 
 	setup_msrs(vcpu);
@@ -1999,6 +2057,7 @@ static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 
 static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u8 fail;
 	int r;
 
@@ -2123,7 +2182,7 @@ again:
 #endif
 		"setbe %0 \n\t"
 	      : "=q" (fail)
-	      : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
+	      : "r"(vmx->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
 		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
 		[rbx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBX])),
@@ -2167,7 +2226,7 @@ again:
 	if (unlikely(prof_on == KVM_PROFILING))
 		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
-	vcpu->launched = 1;
+	vmx->launched = 1;
 	r = kvm_handle_exit(kvm_run, vcpu);
 	if (r > 0) {
 		/* Give scheduler a change to reschedule. */
@@ -2232,10 +2291,12 @@ static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
 
 static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->vmcs) {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (vmx->vmcs) {
 		on_each_cpu(__vcpu_clear, vcpu, 0, 1);
-		free_vmcs(vcpu->vmcs);
-		vcpu->vmcs = NULL;
+		free_vmcs(vmx->vmcs);
+		vmx->vmcs = NULL;
 	}
 }
 
@@ -2246,33 +2307,39 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 
 static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 {
-	struct vmcs *vmcs;
+	struct vcpu_vmx *vmx;
 
-	vcpu->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!vcpu->guest_msrs)
+	vmx = kzalloc(sizeof(*vmx), GFP_KERNEL);
+	if (!vmx)
 		return -ENOMEM;
 
-	vcpu->host_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!vcpu->host_msrs)
-		goto out_free_guest_msrs;
+	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!vmx->guest_msrs)
+		goto out_free;
 
-	vmcs = alloc_vmcs();
-	if (!vmcs)
-		goto out_free_msrs;
+	vmx->host_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!vmx->host_msrs)
+		goto out_free;
 
-	vmcs_clear(vmcs);
-	vcpu->vmcs = vmcs;
-	vcpu->launched = 0;
+	vmx->vmcs = alloc_vmcs();
+	if (!vmx->vmcs)
+		goto out_free;
+
+	vmcs_clear(vmx->vmcs);
+
+	vmx->vcpu   = vcpu;
+	vcpu->_priv = vmx;
 
 	return 0;
 
-out_free_msrs:
-	kfree(vcpu->host_msrs);
-	vcpu->host_msrs = NULL;
+out_free:
+	if (vmx->host_msrs)
+		kfree(vmx->host_msrs);
+
+	if (vmx->guest_msrs)
+		kfree(vmx->guest_msrs);
 
-out_free_guest_msrs:
-	kfree(vcpu->guest_msrs);
-	vcpu->guest_msrs = NULL;
+	kfree(vmx);
 
 	return -ENOMEM;
 }
-- 
1.5.3

