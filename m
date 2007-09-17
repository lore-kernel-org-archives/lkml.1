Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbXIQJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbXIQJIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXIQIeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:45259 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 012/104] KVM: Use standard CR4 flags, tighten checking
Date: Mon, 17 Sep 2007 10:30:54 +0200
Message-Id: <11900179462362-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

On this machine (Intel), writing to the CR4 bits 0x00000800 and
0x00001000 cause a GPF.  The Intel manual is a little unclear, but
AFIACT they're reserved, too.

Also fix spelling of CR4_RESEVED_BITS.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   16 +++++-----------
 drivers/kvm/kvm_main.c |   16 ++++++++++------
 drivers/kvm/svm.c      |    7 +++----
 drivers/kvm/vmx.c      |    8 ++++----
 drivers/kvm/vmx.h      |    2 --
 5 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 983c33f..25439a5 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -23,12 +23,6 @@
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
 #define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
 
-#define CR4_VME_MASK (1ULL << 0)
-#define CR4_PSE_MASK (1ULL << 4)
-#define CR4_PAE_MASK (1ULL << 5)
-#define CR4_PGE_MASK (1ULL << 7)
-#define CR4_VMXE_MASK (1ULL << 13)
-
 #define KVM_GUEST_CR0_MASK \
 	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE \
 	 | X86_CR0_NW | X86_CR0_CD)
@@ -36,9 +30,9 @@
 	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE | X86_CR0_TS \
 	 | X86_CR0_MP)
 #define KVM_GUEST_CR4_MASK \
-	(CR4_PSE_MASK | CR4_PAE_MASK | CR4_PGE_MASK | CR4_VMXE_MASK | CR4_VME_MASK)
-#define KVM_PMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK)
-#define KVM_RMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK | CR4_VME_MASK)
+	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
+#define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
+#define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
 
 #define INVALID_PAGE (~(hpa_t)0)
 #define UNMAPPED_GVA (~(gpa_t)0)
@@ -645,12 +639,12 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
 
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr4 & CR4_PAE_MASK;
+	return vcpu->cr4 & X86_CR4_PAE;
 }
 
 static inline int is_pse(struct kvm_vcpu *vcpu)
 {
-	return vcpu->cr4 & CR4_PSE_MASK;
+	return vcpu->cr4 & X86_CR4_PSE;
 }
 
 static inline int is_paging(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 34a571d..af02320 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -86,8 +86,12 @@ static struct dentry *debugfs_dir;
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
 			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
 			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
-#define LMSW_GUEST_MASK 0x0eULL
-#define CR4_RESEVED_BITS (~((1ULL << 11) - 1))
+#define CR4_RESERVED_BITS						\
+	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
+			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE	\
+			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR	\
+			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
+
 #define CR8_RESEVED_BITS (~0x0fULL)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
@@ -537,26 +541,26 @@ EXPORT_SYMBOL_GPL(lmsw);
 
 void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	if (cr4 & CR4_RESEVED_BITS) {
+	if (cr4 & CR4_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr4: #GP, reserved bits\n");
 		inject_gp(vcpu);
 		return;
 	}
 
 	if (is_long_mode(vcpu)) {
-		if (!(cr4 & CR4_PAE_MASK)) {
+		if (!(cr4 & X86_CR4_PAE)) {
 			printk(KERN_DEBUG "set_cr4: #GP, clearing PAE while "
 			       "in long mode\n");
 			inject_gp(vcpu);
 			return;
 		}
-	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & CR4_PAE_MASK)
+	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & X86_CR4_PAE)
 		   && !load_pdptrs(vcpu, vcpu->cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		inject_gp(vcpu);
 	}
 
-	if (cr4 & CR4_VMXE_MASK) {
+	if (cr4 & X86_CR4_VMXE) {
 		printk(KERN_DEBUG "set_cr4: #GP, setting VMXE\n");
 		inject_gp(vcpu);
 		return;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index e920c22..5c058fa 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -38,7 +38,6 @@ MODULE_LICENSE("GPL");
 
 #define DR7_GD_MASK (1 << 13)
 #define DR6_BD_MASK (1 << 13)
-#define CR4_DE_MASK (1UL << 3)
 
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
@@ -564,7 +563,7 @@ static void init_vmcb(struct vmcb *vmcb)
 	 * cache by default. the orderly way is to enable cache in bios.
 	 */
 	save->cr0 = 0x00000010 | X86_CR0_PG | X86_CR0_WP;
-	save->cr4 = CR4_PAE_MASK;
+	save->cr4 = X86_CR4_PAE;
 	/* rdx = ?? */
 }
 
@@ -781,7 +780,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
        vcpu->cr4 = cr4;
-       vcpu->svm->vmcb->save.cr4 = cr4 | CR4_PAE_MASK;
+       vcpu->svm->vmcb->save.cr4 = cr4 | X86_CR4_PAE;
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
@@ -877,7 +876,7 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 		vcpu->svm->db_regs[dr] = value;
 		return;
 	case 4 ... 5:
-		if (vcpu->cr4 & CR4_DE_MASK) {
+		if (vcpu->cr4 & X86_CR4_DE) {
 			*exception = UD_VECTOR;
 			return;
 		}
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index ebd93b4..f3e7818 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -764,7 +764,7 @@ static void hardware_enable(void *garbage)
 	if ((old & 5) != 5)
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | 5);
-	write_cr4(read_cr4() | CR4_VMXE); /* FIXME: not cpu hotplug safe */
+	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
 	asm volatile (ASM_VMX_VMXON_RAX : : "a"(&phys_addr), "m"(phys_addr)
 		      : "memory", "cc");
 }
@@ -879,8 +879,8 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	flags |= (vcpu->rmode.save_iopl << IOPL_SHIFT);
 	vmcs_writel(GUEST_RFLAGS, flags);
 
-	vmcs_writel(GUEST_CR4, (vmcs_readl(GUEST_CR4) & ~CR4_VME_MASK) |
-			(vmcs_readl(CR4_READ_SHADOW) & CR4_VME_MASK));
+	vmcs_writel(GUEST_CR4, (vmcs_readl(GUEST_CR4) & ~X86_CR4_VME) |
+			(vmcs_readl(CR4_READ_SHADOW) & X86_CR4_VME));
 
 	update_exception_bitmap(vcpu);
 
@@ -937,7 +937,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	flags |= IOPL_MASK | X86_EFLAGS_VM;
 
 	vmcs_writel(GUEST_RFLAGS, flags);
-	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | CR4_VME_MASK);
+	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);
 	update_exception_bitmap(vcpu);
 
 	vmcs_write16(GUEST_SS_SELECTOR, vmcs_readl(GUEST_SS_BASE) >> 4);
diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index d0dc93d..76ad793 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -285,8 +285,6 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define CR4_VMXE 0x2000
-
 #define MSR_IA32_VMX_BASIC   		0x480
 #define MSR_IA32_FEATURE_CONTROL 		0x03a
 #define MSR_IA32_VMX_PINBASED_CTLS		0x481
-- 
1.5.3

