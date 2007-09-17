Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbXIQIfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbXIQIfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXIQIcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:45251 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 010/104] KVM: Trivial: Use standard CR0 flags macros from asm/cpu-features.h
Date: Mon, 17 Sep 2007 10:30:52 +0200
Message-Id: <1190017946989-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

The kernel now has asm/cpu-features.h: use those macros instead of
inventing our own.

Also spell out definition of CR0_RESEVED_BITS (no code change) and fix typo.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   19 +++++--------------
 drivers/kvm/kvm_main.c |   15 +++++++++------
 drivers/kvm/mmu.c      |    2 +-
 drivers/kvm/svm.c      |   20 ++++++++++----------
 drivers/kvm/vmx.c      |   22 +++++++++++-----------
 5 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index b629a83..7117c3b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -19,15 +19,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
-#define CR0_PE_MASK (1ULL << 0)
-#define CR0_MP_MASK (1ULL << 1)
-#define CR0_TS_MASK (1ULL << 3)
-#define CR0_NE_MASK (1ULL << 5)
-#define CR0_WP_MASK (1ULL << 16)
-#define CR0_NW_MASK (1ULL << 29)
-#define CR0_CD_MASK (1ULL << 30)
-#define CR0_PG_MASK (1ULL << 31)
-
 #define CR3_WPT_MASK (1ULL << 3)
 #define CR3_PCD_MASK (1ULL << 4)
 
@@ -42,11 +33,11 @@
 #define CR4_VMXE_MASK (1ULL << 13)
 
 #define KVM_GUEST_CR0_MASK \
-	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK \
-	 | CR0_NW_MASK | CR0_CD_MASK)
+	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE \
+	 | X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON \
-	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK | CR0_TS_MASK \
-	 | CR0_MP_MASK)
+	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE | X86_CR0_TS \
+	 | X86_CR0_MP)
 #define KVM_GUEST_CR4_MASK \
 	(CR4_PSE_MASK | CR4_PAE_MASK | CR4_PGE_MASK | CR4_VMXE_MASK | CR4_VME_MASK)
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK)
@@ -667,7 +658,7 @@ static inline int is_pse(struct kvm_vcpu *vcpu)
 
 static inline int is_paging(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr0 & CR0_PG_MASK;
+	return vcpu->cr0 & X86_CR0_PG;
 }
 
 static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 326fa79..5d8febe 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -82,7 +82,10 @@ static struct dentry *debugfs_dir;
 
 #define MAX_IO_MSRS 256
 
-#define CR0_RESEVED_BITS 0xffffffff1ffaffc0ULL
+#define CR0_RESERVED_BITS						\
+	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
+			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
+			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
 #define LMSW_GUEST_MASK 0x0eULL
 #define CR4_RESEVED_BITS (~((1ULL << 11) - 1))
 #define CR8_RESEVED_BITS (~0x0fULL)
@@ -466,27 +469,27 @@ out:
 
 void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
-	if (cr0 & CR0_RESEVED_BITS) {
+	if (cr0 & CR0_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
 		       cr0, vcpu->cr0);
 		inject_gp(vcpu);
 		return;
 	}
 
-	if ((cr0 & CR0_NW_MASK) && !(cr0 & CR0_CD_MASK)) {
+	if ((cr0 & X86_CR0_NW) && !(cr0 & X86_CR0_CD)) {
 		printk(KERN_DEBUG "set_cr0: #GP, CD == 0 && NW == 1\n");
 		inject_gp(vcpu);
 		return;
 	}
 
-	if ((cr0 & CR0_PG_MASK) && !(cr0 & CR0_PE_MASK)) {
+	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE)) {
 		printk(KERN_DEBUG "set_cr0: #GP, set PG flag "
 		       "and a clear PE flag\n");
 		inject_gp(vcpu);
 		return;
 	}
 
-	if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK)) {
+	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 #ifdef CONFIG_X86_64
 		if ((vcpu->shadow_efer & EFER_LME)) {
 			int cs_db, cs_l;
@@ -1158,7 +1161,7 @@ int emulate_clts(struct kvm_vcpu *vcpu)
 {
 	unsigned long cr0;
 
-	cr0 = vcpu->cr0 & ~CR0_TS_MASK;
+	cr0 = vcpu->cr0 & ~X86_CR0_TS;
 	kvm_arch_ops->set_cr0(vcpu, cr0);
 	return X86EMUL_CONTINUE;
 }
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 23965aa..75faef4 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -158,7 +158,7 @@ static struct kmem_cache *mmu_page_header_cache;
 
 static int is_write_protection(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr0 & CR0_WP_MASK;
+	return vcpu->cr0 & X86_CR0_WP;
 }
 
 static int is_cpuid_PSE36(void)
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 52a11cc..e920c22 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -99,7 +99,7 @@ static unsigned get_addr_size(struct kvm_vcpu *vcpu)
 	struct vmcb_save_area *sa = &vcpu->svm->vmcb->save;
 	u16 cs_attrib;
 
-	if (!(sa->cr0 & CR0_PE_MASK) || (sa->rflags & X86_EFLAGS_VM))
+	if (!(sa->cr0 & X86_CR0_PE) || (sa->rflags & X86_EFLAGS_VM))
 		return 2;
 
 	cs_attrib = sa->cs.attrib;
@@ -563,7 +563,7 @@ static void init_vmcb(struct vmcb *vmcb)
 	 * cr0 val on cpu init should be 0x60000010, we enable cpu
 	 * cache by default. the orderly way is to enable cache in bios.
 	 */
-	save->cr0 = 0x00000010 | CR0_PG_MASK | CR0_WP_MASK;
+	save->cr0 = 0x00000010 | X86_CR0_PG | X86_CR0_WP;
 	save->cr4 = CR4_PAE_MASK;
 	/* rdx = ?? */
 }
@@ -756,25 +756,25 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 #ifdef CONFIG_X86_64
 	if (vcpu->shadow_efer & KVM_EFER_LME) {
-		if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK)) {
+		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->shadow_efer |= KVM_EFER_LMA;
 			vcpu->svm->vmcb->save.efer |= KVM_EFER_LMA | KVM_EFER_LME;
 		}
 
-		if (is_paging(vcpu) && !(cr0 & CR0_PG_MASK) ) {
+		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG) ) {
 			vcpu->shadow_efer &= ~KVM_EFER_LMA;
 			vcpu->svm->vmcb->save.efer &= ~(KVM_EFER_LMA | KVM_EFER_LME);
 		}
 	}
 #endif
-	if ((vcpu->cr0 & CR0_TS_MASK) && !(cr0 & CR0_TS_MASK)) {
+	if ((vcpu->cr0 & X86_CR0_TS) && !(cr0 & X86_CR0_TS)) {
 		vcpu->svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
 		vcpu->fpu_active = 1;
 	}
 
 	vcpu->cr0 = cr0;
-	cr0 |= CR0_PG_MASK | CR0_WP_MASK;
-	cr0 &= ~(CR0_CD_MASK | CR0_NW_MASK);
+	cr0 |= X86_CR0_PG | X86_CR0_WP;
+	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	vcpu->svm->vmcb->save.cr0 = cr0;
 }
 
@@ -945,8 +945,8 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 static int nm_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
        vcpu->svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
-       if (!(vcpu->cr0 & CR0_TS_MASK))
-               vcpu->svm->vmcb->save.cr0 &= ~CR0_TS_MASK;
+       if (!(vcpu->cr0 & X86_CR0_TS))
+               vcpu->svm->vmcb->save.cr0 &= ~X86_CR0_TS;
        vcpu->fpu_active = 1;
 
        return 1;
@@ -1702,7 +1702,7 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 
 	if (vcpu->fpu_active) {
 		vcpu->svm->vmcb->control.intercept_exceptions |= (1 << NM_VECTOR);
-		vcpu->svm->vmcb->save.cr0 |= CR0_TS_MASK;
+		vcpu->svm->vmcb->save.cr0 |= X86_CR0_TS;
 		vcpu->fpu_active = 0;
 	}
 }
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 7fa62c7..ebd93b4 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -436,9 +436,9 @@ static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
 	if (vcpu->fpu_active)
 		return;
 	vcpu->fpu_active = 1;
-	vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
-	if (vcpu->cr0 & CR0_TS_MASK)
-		vmcs_set_bits(GUEST_CR0, CR0_TS_MASK);
+	vmcs_clear_bits(GUEST_CR0, X86_CR0_TS);
+	if (vcpu->cr0 & X86_CR0_TS)
+		vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
 	update_exception_bitmap(vcpu);
 }
 
@@ -447,7 +447,7 @@ static void vmx_fpu_deactivate(struct kvm_vcpu *vcpu)
 	if (!vcpu->fpu_active)
 		return;
 	vcpu->fpu_active = 0;
-	vmcs_set_bits(GUEST_CR0, CR0_TS_MASK);
+	vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
 	update_exception_bitmap(vcpu);
 }
 
@@ -1002,17 +1002,17 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	vmx_fpu_deactivate(vcpu);
 
-	if (vcpu->rmode.active && (cr0 & CR0_PE_MASK))
+	if (vcpu->rmode.active && (cr0 & X86_CR0_PE))
 		enter_pmode(vcpu);
 
-	if (!vcpu->rmode.active && !(cr0 & CR0_PE_MASK))
+	if (!vcpu->rmode.active && !(cr0 & X86_CR0_PE))
 		enter_rmode(vcpu);
 
 #ifdef CONFIG_X86_64
 	if (vcpu->shadow_efer & EFER_LME) {
-		if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK))
+		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG))
 			enter_lmode(vcpu);
-		if (is_paging(vcpu) && !(cr0 & CR0_PG_MASK))
+		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG))
 			exit_lmode(vcpu);
 	}
 #endif
@@ -1022,14 +1022,14 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
 	vcpu->cr0 = cr0;
 
-	if (!(cr0 & CR0_TS_MASK) || !(cr0 & CR0_PE_MASK))
+	if (!(cr0 & X86_CR0_TS) || !(cr0 & X86_CR0_PE))
 		vmx_fpu_activate(vcpu);
 }
 
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	vmcs_writel(GUEST_CR3, cr3);
-	if (vcpu->cr0 & CR0_PE_MASK)
+	if (vcpu->cr0 & X86_CR0_PE)
 		vmx_fpu_deactivate(vcpu);
 }
 
@@ -1778,7 +1778,7 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	case 2: /* clts */
 		vcpu_load_rsp_rip(vcpu);
 		vmx_fpu_deactivate(vcpu);
-		vcpu->cr0 &= ~CR0_TS_MASK;
+		vcpu->cr0 &= ~X86_CR0_TS;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->cr0);
 		vmx_fpu_activate(vcpu);
 		skip_emulated_instruction(vcpu);
-- 
1.5.3

