Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbYGOMRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbYGOMRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbYGOMM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:59 -0400
Received: from il.qumranet.com ([212.179.150.194]:30353 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbYGOMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] KVM: Prefix some x86 low level function with kvm_, to avoid namespace issues
Date: Tue, 15 Jul 2008 15:12:34 +0300
Message-Id: <1216123958-10717-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compilation with CONFIG_VMI enabled.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |   12 ++++++------
 arch/x86/kvm/vmx.c         |   24 ++++++++++++------------
 arch/x86/kvm/x86.c         |   18 +++++++++---------
 include/asm-x86/kvm_host.h |   26 ++++++++++++--------------
 4 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 858e297..b756e87 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1710,9 +1710,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	sync_lapic_to_cr8(vcpu);
 
 	save_host_msrs(vcpu);
-	fs_selector = read_fs();
-	gs_selector = read_gs();
-	ldt_selector = read_ldt();
+	fs_selector = kvm_read_fs();
+	gs_selector = kvm_read_gs();
+	ldt_selector = kvm_read_ldt();
 	svm->host_cr2 = kvm_read_cr2();
 	svm->host_dr6 = read_dr6();
 	svm->host_dr7 = read_dr7();
@@ -1845,9 +1845,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	write_dr7(svm->host_dr7);
 	kvm_write_cr2(svm->host_cr2);
 
-	load_fs(fs_selector);
-	load_gs(gs_selector);
-	load_ldt(ldt_selector);
+	kvm_load_fs(fs_selector);
+	kvm_load_gs(gs_selector);
+	kvm_load_ldt(ldt_selector);
 	load_host_msrs(vcpu);
 
 	reload_tss(vcpu);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d300aa1..c4d8a4c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -484,7 +484,7 @@ static void reload_tss(void)
 	struct descriptor_table gdt;
 	struct desc_struct *descs;
 
-	get_gdt(&gdt);
+	kvm_get_gdt(&gdt);
 	descs = (void *)gdt.base;
 	descs[GDT_ENTRY_TSS].type = 9; /* available TSS */
 	load_TR_desc();
@@ -540,9 +540,9 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 	 * Set host fs and gs selectors.  Unfortunately, 22.2.3 does not
 	 * allow segment selectors with cpl > 0 or ti == 1.
 	 */
-	vmx->host_state.ldt_sel = read_ldt();
+	vmx->host_state.ldt_sel = kvm_read_ldt();
 	vmx->host_state.gs_ldt_reload_needed = vmx->host_state.ldt_sel;
-	vmx->host_state.fs_sel = read_fs();
+	vmx->host_state.fs_sel = kvm_read_fs();
 	if (!(vmx->host_state.fs_sel & 7)) {
 		vmcs_write16(HOST_FS_SELECTOR, vmx->host_state.fs_sel);
 		vmx->host_state.fs_reload_needed = 0;
@@ -550,7 +550,7 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 		vmcs_write16(HOST_FS_SELECTOR, 0);
 		vmx->host_state.fs_reload_needed = 1;
 	}
-	vmx->host_state.gs_sel = read_gs();
+	vmx->host_state.gs_sel = kvm_read_gs();
 	if (!(vmx->host_state.gs_sel & 7))
 		vmcs_write16(HOST_GS_SELECTOR, vmx->host_state.gs_sel);
 	else {
@@ -586,15 +586,15 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
 	if (vmx->host_state.fs_reload_needed)
-		load_fs(vmx->host_state.fs_sel);
+		kvm_load_fs(vmx->host_state.fs_sel);
 	if (vmx->host_state.gs_ldt_reload_needed) {
-		load_ldt(vmx->host_state.ldt_sel);
+		kvm_load_ldt(vmx->host_state.ldt_sel);
 		/*
 		 * If we have to reload gs, we must take care to
 		 * preserve our gs base.
 		 */
 		local_irq_save(flags);
-		load_gs(vmx->host_state.gs_sel);
+		kvm_load_gs(vmx->host_state.gs_sel);
 #ifdef CONFIG_X86_64
 		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
 #endif
@@ -654,8 +654,8 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * Linux uses per-cpu TSS and GDT, so set these when switching
 		 * processors.
 		 */
-		vmcs_writel(HOST_TR_BASE, read_tr_base()); /* 22.2.4 */
-		get_gdt(&dt);
+		vmcs_writel(HOST_TR_BASE, kvm_read_tr_base()); /* 22.2.4 */
+		kvm_get_gdt(&dt);
 		vmcs_writel(HOST_GDTR_BASE, dt.base);   /* 22.2.4 */
 
 		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
@@ -1943,8 +1943,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);  /* 22.2.4 */
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
-	vmcs_write16(HOST_FS_SELECTOR, read_fs());    /* 22.2.4 */
-	vmcs_write16(HOST_GS_SELECTOR, read_gs());    /* 22.2.4 */
+	vmcs_write16(HOST_FS_SELECTOR, kvm_read_fs());    /* 22.2.4 */
+	vmcs_write16(HOST_GS_SELECTOR, kvm_read_gs());    /* 22.2.4 */
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_FS_BASE, a);
@@ -1958,7 +1958,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);  /* 22.2.4 */
 
-	get_idt(&dt);
+	kvm_get_idt(&dt);
 	vmcs_writel(HOST_IDTR_BASE, dt.base);   /* 22.2.4 */
 
 	asm("mov $.Lkvm_vmx_return, %0" : "=r"(kvm_vmx_return));
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3d146d..200e215 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3767,14 +3767,14 @@ void fx_init(struct kvm_vcpu *vcpu)
 	 * allocate ram with GFP_KERNEL.
 	 */
 	if (!used_math())
-		fx_save(&vcpu->arch.host_fx_image);
+		kvm_fx_save(&vcpu->arch.host_fx_image);
 
 	/* Initialize guest FPU by resetting ours and saving into guest's */
 	preempt_disable();
-	fx_save(&vcpu->arch.host_fx_image);
-	fx_finit();
-	fx_save(&vcpu->arch.guest_fx_image);
-	fx_restore(&vcpu->arch.host_fx_image);
+	kvm_fx_save(&vcpu->arch.host_fx_image);
+	kvm_fx_finit();
+	kvm_fx_save(&vcpu->arch.guest_fx_image);
+	kvm_fx_restore(&vcpu->arch.host_fx_image);
 	preempt_enable();
 
 	vcpu->arch.cr0 |= X86_CR0_ET;
@@ -3791,8 +3791,8 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 1;
-	fx_save(&vcpu->arch.host_fx_image);
-	fx_restore(&vcpu->arch.guest_fx_image);
+	kvm_fx_save(&vcpu->arch.host_fx_image);
+	kvm_fx_restore(&vcpu->arch.guest_fx_image);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_fpu);
 
@@ -3802,8 +3802,8 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	fx_save(&vcpu->arch.guest_fx_image);
-	fx_restore(&vcpu->arch.host_fx_image);
+	kvm_fx_save(&vcpu->arch.guest_fx_image);
+	kvm_fx_restore(&vcpu->arch.host_fx_image);
 	++vcpu->stat.fpu_reload;
 }
 EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index c64d124..f995783 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -567,55 +567,53 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 	return (struct kvm_mmu_page *)page_private(page);
 }
 
-static inline u16 read_fs(void)
+static inline u16 kvm_read_fs(void)
 {
 	u16 seg;
 	asm("mov %%fs, %0" : "=g"(seg));
 	return seg;
 }
 
-static inline u16 read_gs(void)
+static inline u16 kvm_read_gs(void)
 {
 	u16 seg;
 	asm("mov %%gs, %0" : "=g"(seg));
 	return seg;
 }
 
-static inline u16 read_ldt(void)
+static inline u16 kvm_read_ldt(void)
 {
 	u16 ldt;
 	asm("sldt %0" : "=g"(ldt));
 	return ldt;
 }
 
-static inline void load_fs(u16 sel)
+static inline void kvm_load_fs(u16 sel)
 {
 	asm("mov %0, %%fs" : : "rm"(sel));
 }
 
-static inline void load_gs(u16 sel)
+static inline void kvm_load_gs(u16 sel)
 {
 	asm("mov %0, %%gs" : : "rm"(sel));
 }
 
-#ifndef load_ldt
-static inline void load_ldt(u16 sel)
+static inline void kvm_load_ldt(u16 sel)
 {
 	asm("lldt %0" : : "rm"(sel));
 }
-#endif
 
-static inline void get_idt(struct descriptor_table *table)
+static inline void kvm_get_idt(struct descriptor_table *table)
 {
 	asm("sidt %0" : "=m"(*table));
 }
 
-static inline void get_gdt(struct descriptor_table *table)
+static inline void kvm_get_gdt(struct descriptor_table *table)
 {
 	asm("sgdt %0" : "=m"(*table));
 }
 
-static inline unsigned long read_tr_base(void)
+static inline unsigned long kvm_read_tr_base(void)
 {
 	u16 tr;
 	asm("str %0" : "=g"(tr));
@@ -632,17 +630,17 @@ static inline unsigned long read_msr(unsigned long msr)
 }
 #endif
 
-static inline void fx_save(struct i387_fxsave_struct *image)
+static inline void kvm_fx_save(struct i387_fxsave_struct *image)
 {
 	asm("fxsave (%0)":: "r" (image));
 }
 
-static inline void fx_restore(struct i387_fxsave_struct *image)
+static inline void kvm_fx_restore(struct i387_fxsave_struct *image)
 {
 	asm("fxrstor (%0)":: "r" (image));
 }
 
-static inline void fx_finit(void)
+static inline void kvm_fx_finit(void)
 {
 	asm("finit");
 }
-- 
1.5.6.1

