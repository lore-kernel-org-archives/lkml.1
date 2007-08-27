Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbXH0PTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbXH0PTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbXH0PTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:19:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58604 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbXH0PTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:19:39 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>, Avi Kivity <avi@qumranet.com>,
       Ingo Molnar <mingo@elte.hu>, Dor Laor <dor.laor@qumranet.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Refactor hypercall infrastructure
Date: Mon, 27 Aug 2007 10:16:45 -0500
Message-Id: <11882278082826-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1188227808405-git-send-email-aliguori@us.ibm.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
 <1188227808405-git-send-email-aliguori@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors the current hypercall infrastructure to better support live
migration and SMP.  It eliminates the hypercall page by trapping the UD
exception that would occur if you used the wrong hypercall instruction for the
underlying architecture and replacing it with the right one lazily.

It also introduces the infrastructure to probe for hypercall available via
CPUID leaves 0x40000002 and 0x40000003.

A fall-out of this patch is that the unhandled hypercalls no longer trap to
userspace.  There is very little reason though to use a hypercall to communicate
with userspace as PIO or MMIO can be used.  There is no code in tree that uses
userspace hypercalls.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a42a6f3..38c0eaf 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -46,6 +46,7 @@
 #define KVM_MAX_CPUID_ENTRIES 40
 
 #define DE_VECTOR 0
+#define UD_VECTOR 6
 #define NM_VECTOR 7
 #define DF_VECTOR 8
 #define TS_VECTOR 10
@@ -316,9 +317,6 @@ struct kvm_vcpu {
 	unsigned long cr0;
 	unsigned long cr2;
 	unsigned long cr3;
-	gpa_t para_state_gpa;
-	struct page *para_state_page;
-	gpa_t hypercall_gpa;
 	unsigned long cr4;
 	unsigned long cr8;
 	u64 pdptrs[4]; /* pae */
@@ -587,7 +585,9 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 
-int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
+
+int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
 
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				     u32 error_code)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ebcc5c9..996d0ee 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1294,51 +1294,49 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
-int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
-	unsigned long nr, a0, a1, a2, a3, a4, a5, ret;
+	unsigned long nr, a0, a1, a2, a3, ret;
 
 	kvm_arch_ops->cache_regs(vcpu);
-	ret = -KVM_EINVAL;
-#ifdef CONFIG_X86_64
-	if (is_long_mode(vcpu)) {
-		nr = vcpu->regs[VCPU_REGS_RAX];
-		a0 = vcpu->regs[VCPU_REGS_RDI];
-		a1 = vcpu->regs[VCPU_REGS_RSI];
-		a2 = vcpu->regs[VCPU_REGS_RDX];
-		a3 = vcpu->regs[VCPU_REGS_RCX];
-		a4 = vcpu->regs[VCPU_REGS_R8];
-		a5 = vcpu->regs[VCPU_REGS_R9];
-	} else
-#endif
-	{
-		nr = vcpu->regs[VCPU_REGS_RBX] & -1u;
-		a0 = vcpu->regs[VCPU_REGS_RAX] & -1u;
-		a1 = vcpu->regs[VCPU_REGS_RCX] & -1u;
-		a2 = vcpu->regs[VCPU_REGS_RDX] & -1u;
-		a3 = vcpu->regs[VCPU_REGS_RSI] & -1u;
-		a4 = vcpu->regs[VCPU_REGS_RDI] & -1u;
-		a5 = vcpu->regs[VCPU_REGS_RBP] & -1u;
+
+	nr = vcpu->regs[VCPU_REGS_RAX];
+	a0 = vcpu->regs[VCPU_REGS_RBX];
+	a1 = vcpu->regs[VCPU_REGS_RCX];
+	a2 = vcpu->regs[VCPU_REGS_RDX];
+	a3 = vcpu->regs[VCPU_REGS_RSI];
+
+	if (!is_long_mode(vcpu)) {
+		nr &= ~1u;
+		a0 &= ~1u;
+		a1 &= ~1u;
+		a2 &= ~1u;
+		a3 &= ~1u;
 	}
+
 	switch (nr) {
 	default:
-		run->hypercall.nr = nr;
-		run->hypercall.args[0] = a0;
-		run->hypercall.args[1] = a1;
-		run->hypercall.args[2] = a2;
-		run->hypercall.args[3] = a3;
-		run->hypercall.args[4] = a4;
-		run->hypercall.args[5] = a5;
-		run->hypercall.ret = ret;
-		run->hypercall.longmode = is_long_mode(vcpu);
-		kvm_arch_ops->decache_regs(vcpu);
-		return 0;
+		ret = -KVM_ENOSYS;
+		break;
 	}
 	vcpu->regs[VCPU_REGS_RAX] = ret;
 	kvm_arch_ops->decache_regs(vcpu);
-	return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
+
+int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
+{
+	char instruction[3];
+
+	kvm_arch_ops->cache_regs(vcpu);
+	kvm_arch_ops->patch_hypercall(vcpu, instruction);
+	if (emulator_write_std(vcpu->rip, instruction, 3, vcpu)
+	    != X86EMUL_CONTINUE)
+		return -EFAULT;
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_hypercall);
 
 static u64 mk_cr_64(u64 curr_cr, u32 new_val)
 {
@@ -1406,75 +1404,6 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 	}
 }
 
-/*
- * Register the para guest with the host:
- */
-static int vcpu_register_para(struct kvm_vcpu *vcpu, gpa_t para_state_gpa)
-{
-	struct kvm_vcpu_para_state *para_state;
-	hpa_t para_state_hpa, hypercall_hpa;
-	struct page *para_state_page;
-	unsigned char *hypercall;
-	gpa_t hypercall_gpa;
-
-	printk(KERN_DEBUG "kvm: guest trying to enter paravirtual mode\n");
-	printk(KERN_DEBUG ".... para_state_gpa: %08Lx\n", para_state_gpa);
-
-	/*
-	 * Needs to be page aligned:
-	 */
-	if (para_state_gpa != PAGE_ALIGN(para_state_gpa))
-		goto err_gp;
-
-	para_state_hpa = gpa_to_hpa(vcpu, para_state_gpa);
-	printk(KERN_DEBUG ".... para_state_hpa: %08Lx\n", para_state_hpa);
-	if (is_error_hpa(para_state_hpa))
-		goto err_gp;
-
-	mark_page_dirty(vcpu->kvm, para_state_gpa >> PAGE_SHIFT);
-	para_state_page = pfn_to_page(para_state_hpa >> PAGE_SHIFT);
-	para_state = kmap(para_state_page);
-
-	printk(KERN_DEBUG "....  guest version: %d\n", para_state->guest_version);
-	printk(KERN_DEBUG "....           size: %d\n", para_state->size);
-
-	para_state->host_version = KVM_PARA_API_VERSION;
-	/*
-	 * We cannot support guests that try to register themselves
-	 * with a newer API version than the host supports:
-	 */
-	if (para_state->guest_version > KVM_PARA_API_VERSION) {
-		para_state->ret = -KVM_EINVAL;
-		goto err_kunmap_skip;
-	}
-
-	hypercall_gpa = para_state->hypercall_gpa;
-	hypercall_hpa = gpa_to_hpa(vcpu, hypercall_gpa);
-	printk(KERN_DEBUG ".... hypercall_hpa: %08Lx\n", hypercall_hpa);
-	if (is_error_hpa(hypercall_hpa)) {
-		para_state->ret = -KVM_EINVAL;
-		goto err_kunmap_skip;
-	}
-
-	printk(KERN_DEBUG "kvm: para guest successfully registered.\n");
-	vcpu->para_state_page = para_state_page;
-	vcpu->para_state_gpa = para_state_gpa;
-	vcpu->hypercall_gpa = hypercall_gpa;
-
-	mark_page_dirty(vcpu->kvm, hypercall_gpa >> PAGE_SHIFT);
-	hypercall = kmap_atomic(pfn_to_page(hypercall_hpa >> PAGE_SHIFT),
-				KM_USER1) + (hypercall_hpa & ~PAGE_MASK);
-	kvm_arch_ops->patch_hypercall(vcpu, hypercall);
-	kunmap_atomic(hypercall, KM_USER1);
-
-	para_state->ret = 0;
-err_kunmap_skip:
-	kunmap(para_state_page);
-	return 0;
-err_gp:
-	return 1;
-}
-
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
 	u64 data;
@@ -1588,12 +1517,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->ia32_misc_enable_msr = data;
 		break;
-	/*
-	 * This is the 'probe whether the host is KVM' logic:
-	 */
-	case MSR_KVM_API_MAGIC:
-		return vcpu_register_para(vcpu, data);
-
 	default:
 		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x\n", msr);
 		return 1;
@@ -1620,6 +1543,26 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
+static void emulate_paravirt_cpuid(struct kvm_vcpu *vcpu, u32 function)
+{
+	u32 signature[3];
+
+	switch (function & 0xFFFF) {
+	case 2:
+		memcpy(signature, "LinuxPVLinux", 12);
+		vcpu->regs[VCPU_REGS_RAX] = 0;
+		vcpu->regs[VCPU_REGS_RBX] = signature[0];
+		vcpu->regs[VCPU_REGS_RCX] = signature[1];
+		vcpu->regs[VCPU_REGS_RDX] = signature[2];
+		break;
+	case 3:
+		vcpu->regs[VCPU_REGS_RAX] 
+			= (1 << KVM_PARA_FEATURE_NOP_IO_DELAY);
+		break;
+	}
+		
+}
+
 void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -1632,6 +1575,12 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->regs[VCPU_REGS_RBX] = 0;
 	vcpu->regs[VCPU_REGS_RCX] = 0;
 	vcpu->regs[VCPU_REGS_RDX] = 0;
+
+	if ((function & 0xFFFF0000) == 0x40000000) {
+		emulate_paravirt_cpuid(vcpu, function);
+		goto out;
+	}
+
 	best = NULL;
 	for (i = 0; i < vcpu->cpuid_nent; ++i) {
 		e = &vcpu->cpuid_entries[i];
@@ -1652,6 +1601,7 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->regs[VCPU_REGS_RCX] = best->ecx;
 		vcpu->regs[VCPU_REGS_RDX] = best->edx;
 	}
+out:
 	kvm_arch_ops->decache_regs(vcpu);
 	kvm_arch_ops->skip_emulated_instruction(vcpu);
 }
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index cc674bf..cb9b05b 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -476,7 +476,8 @@ static void init_vmcb(struct vmcb *vmcb)
 					INTERCEPT_DR5_MASK |
 					INTERCEPT_DR7_MASK;
 
-	control->intercept_exceptions = 1 << PF_VECTOR;
+	control->intercept_exceptions = (1 << PF_VECTOR) |
+					(1 << UD_VECTOR);
 
 
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
@@ -958,6 +959,24 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	return 0;
 }
 
+static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	int er;
+	
+	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
+
+	/* we should only succeed here in the case of hypercalls which
+	   cannot generate an MMIO event.  MMIO means that the emulator
+	   is mistakenly allowing an instruction that should generate
+	   a UD fault so it's a bug. */
+	BUG_ON(er == EMULATE_DO_MMIO);
+
+	if (er == EMULATE_FAIL)
+		inject_ud(&svm->vcpu);
+
+	return 1;
+}
+
 static int nm_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
@@ -1024,7 +1043,8 @@ static int vmmcall_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	svm->next_rip = svm->vmcb->save.rip + 3;
 	skip_emulated_instruction(&svm->vcpu);
-	return kvm_hypercall(&svm->vcpu, kvm_run);
+	kvm_emulate_hypercall(&svm->vcpu);
+	return 1;
 }
 
 static int invalid_op_interception(struct vcpu_svm *svm,
@@ -1218,6 +1238,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_WRITE_DR3]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR5]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR7]			= emulate_on_interception,
+	[SVM_EXIT_EXCP_BASE + UD_VECTOR]	= ud_interception,
 	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
 	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
 	[SVM_EXIT_INTR] 			= nop_on_interception,
@@ -1665,7 +1686,6 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[0] = 0x0f;
 	hypercall[1] = 0x01;
 	hypercall[2] = 0xd9;
-	hypercall[3] = 0xc3;
 }
 
 static void svm_check_processor_compat(void *rtn)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index d63e82e..1840802 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -163,6 +163,13 @@ static inline int is_no_device(u32 intr_info)
 		(INTR_TYPE_EXCEPTION | NM_VECTOR | INTR_INFO_VALID_MASK);
 }
 
+static inline int is_invalid_opcode(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
+			     INTR_INFO_VALID_MASK)) ==
+		(INTR_TYPE_EXCEPTION | UD_VECTOR | INTR_INFO_VALID_MASK);
+}
+
 static inline int is_external_interrupt(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
@@ -304,7 +311,7 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	u32 eb;
 
-	eb = 1u << PF_VECTOR;
+	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR);
 	if (!vcpu->fpu_active)
 		eb |= 1u << NM_VECTOR;
 	if (vcpu->guest_debug.enabled)
@@ -543,6 +550,15 @@ static void vmx_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
 		     INTR_INFO_VALID_MASK);
 }
 
+static void vmx_inject_ud(struct kvm_vcpu *vcpu)
+{
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+		     GP_VECTOR |
+		     INTR_TYPE_EXCEPTION |
+		     INTR_INFO_DELIEVER_CODE_MASK |
+		     INTR_INFO_VALID_MASK);
+}
+
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
@@ -1697,6 +1713,21 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 	}
 
+	if (is_invalid_opcode(intr_info)) {
+		er = emulate_instruction(vcpu, kvm_run, 0, 0);
+
+		/* we should only succeed here in the case of hypercalls which
+		   cannot generate an MMIO event.  MMIO means that the emulator
+		   is mistakenly allowing an instruction that should generate
+		   a UD fault so it's a bug. */
+		BUG_ON(er == EMULATE_DO_MMIO);
+
+		if (er == EMULATE_FAIL)
+			vmx_inject_ud(vcpu);
+
+		return 1;
+	}
+
 	error_code = 0;
 	rip = vmcs_readl(GUEST_RIP);
 	if (intr_info & INTR_INFO_DELIEVER_CODE_MASK)
@@ -1799,7 +1830,6 @@ vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[0] = 0x0f;
 	hypercall[1] = 0x01;
 	hypercall[2] = 0xc1;
-	hypercall[3] = 0xc3;
 }
 
 static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
@@ -1983,7 +2013,8 @@ static int handle_halt(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	skip_emulated_instruction(vcpu);
-	return kvm_hypercall(vcpu, kvm_run);
+	kvm_emulate_hypercall(vcpu);
+	return 1;
 }
 
 /*
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 7439b34..1767983 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1273,19 +1273,37 @@ twobyte_insn:
 			u16 size;
 			unsigned long address;
 
-		case 2: /* lgdt */
-			rc = read_descriptor(ctxt, ops, src.ptr,
-					     &size, &address, op_bytes);
+		case 0: /* vmcall */
+			if (modrm_mod != 3 || modrm_rm != 1)
+				goto cannot_emulate;
+
+			rc = kvm_fix_hypercall(ctxt->vcpu);
 			if (rc)
 				goto done;
-			realmode_lgdt(ctxt->vcpu, size, address);
+
+			kvm_emulate_hypercall(ctxt->vcpu);
 			break;
-		case 3: /* lidt */
+		case 2: /* lgdt */
 			rc = read_descriptor(ctxt, ops, src.ptr,
 					     &size, &address, op_bytes);
 			if (rc)
 				goto done;
-			realmode_lidt(ctxt->vcpu, size, address);
+			realmode_lgdt(ctxt->vcpu, size, address);
+			break;
+		case 3: /* lidt/vmmcall */
+			if (modrm_mod == 3 && modrm_rm == 1) {
+				rc = kvm_fix_hypercall(ctxt->vcpu);
+				if (rc)
+					goto done;
+				kvm_emulate_hypercall(ctxt->vcpu);
+			} else {
+				rc = read_descriptor(ctxt, ops, src.ptr,
+						     &size, &address,
+						     op_bytes);
+				if (rc)
+					goto done;
+				realmode_lidt(ctxt->vcpu, size, address);
+			}
 			break;
 		case 4: /* smsw */
 			if (modrm_mod != 3)
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 3b29256..e92ea3e 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -1,73 +1,85 @@
 #ifndef __LINUX_KVM_PARA_H
 #define __LINUX_KVM_PARA_H
 
-/*
- * Guest OS interface for KVM paravirtualization
- *
- * Note: this interface is totally experimental, and is certain to change
- *       as we make progress.
- */
+#include <asm/processor.h>
 
-/*
- * Per-VCPU descriptor area shared between guest and host. Writable to
- * both guest and host. Registered with the host by the guest when
- * a guest acknowledges paravirtual mode.
- *
- * NOTE: all addresses are guest-physical addresses (gpa), to make it
- * easier for the hypervisor to map between the various addresses.
- */
-struct kvm_vcpu_para_state {
-	/*
-	 * API version information for compatibility. If there's any support
-	 * mismatch (too old host trying to execute too new guest) then
-	 * the host will deny entry into paravirtual mode. Any other
-	 * combination (new host + old guest and new host + new guest)
-	 * is supposed to work - new host versions will support all old
-	 * guest API versions.
-	 */
-	u32 guest_version;
-	u32 host_version;
-	u32 size;
-	u32 ret;
+#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
 
-	/*
-	 * The address of the vm exit instruction (VMCALL or VMMCALL),
-	 * which the host will patch according to the CPU model the
-	 * VM runs on:
-	 */
-	u64 hypercall_gpa;
+static inline long kvm_hypercall0(unsigned int nr)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr));
+	return ret;
+}
 
-} __attribute__ ((aligned(PAGE_SIZE)));
+static inline long kvm_hypercall1(unsigned int nr, unsigned long p1)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1));
+	return ret;
+}
 
-#define KVM_PARA_API_VERSION 1
+static inline long kvm_hypercall2(unsigned int nr, unsigned long p1,
+				  unsigned long p2)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2));
+	return ret;
+}
 
-/*
- * This is used for an RDMSR's ECX parameter to probe for a KVM host.
- * Hopefully no CPU vendor will use up this number. This is placed well
- * out of way of the typical space occupied by CPU vendors' MSR indices,
- * and we think (or at least hope) it wont be occupied in the future
- * either.
- */
-#define MSR_KVM_API_MAGIC 0x87655678
+static inline long kvm_hypercall3(unsigned int nr, unsigned long p1,
+				  unsigned long p2, unsigned long p3)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3));
+	return ret;
+}
 
-#define KVM_EINVAL 1
+static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
+				  unsigned long p2, unsigned long p3,
+				  unsigned long p4)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3), "S"(p4));
+	return ret;
+}
 
-/*
- * Hypercall calling convention:
- *
- * Each hypercall may have 0-6 parameters.
- *
- * 64-bit hypercall index is in RAX, goes from 0 to __NR_hypercalls-1
- *
- * 64-bit parameters 1-6 are in the standard gcc x86_64 calling convention
- * order: RDI, RSI, RDX, RCX, R8, R9.
- *
- * 32-bit index is EBX, parameters are: EAX, ECX, EDX, ESI, EDI, EBP.
- * (the first 3 are according to the gcc regparm calling convention)
- *
- * No registers are clobbered by the hypercall, except that the
- * return value is in RAX.
- */
-#define __NR_hypercalls			0
+static inline int kvm_para_available(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	char signature[13];
+
+	cpuid(0x40000002, &eax, &ebx, &ecx, &edx);
+	memcpy(signature + 0, &ebx, 4);
+	memcpy(signature + 4, &ecx, 4);
+	memcpy(signature + 8, &edx, 4);
+	signature[12] = 0;
+
+	if (strcmp(signature, "LinuxPVLinux") == 0)
+		return 1;
+
+	return 0;
+}
+
+static inline int kvm_para_has_feature(unsigned int feature)
+{
+	if (cpuid_eax(0x40000003) & (1UL << feature))
+		return 1;
+	return 0;
+}
+
+#define KVM_PARA_FEATURE_NOP_IO_DELAY		0
+
+#define KVM_ENOSYS		ENOSYS
 
 #endif
