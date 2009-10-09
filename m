Return-Path: <linux-kernel-owner+w=401wt.eu-S1761196AbZJIQ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbZJIQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761186AbZJIQ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:58:16 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:30539
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761184AbZJIQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:58:15 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i2a8h6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KR9B2G-02-63L-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] KVM: SVM: Remove nsvm_printk debugging code
Date: Fri, 9 Oct 2009 16:08:33 +0200
Message-ID: <1255097313-23267-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2009 14:08:36.0637 (UTC) FILETIME=[FE693CD0:01CA48E9]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all important informations now delivered through
tracepoints we can savely remove the nsvm_printk debugging
code for nested svm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8b9f6fb..69610c5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -53,15 +53,6 @@ MODULE_LICENSE("GPL");
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
-/* Turn on to get debugging output*/
-/* #define NESTED_DEBUG */
-
-#ifdef NESTED_DEBUG
-#define nsvm_printk(fmt, args...) printk(KERN_INFO fmt, ## args)
-#else
-#define nsvm_printk(fmt, args...) do {} while(0)
-#endif
-
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
 	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
@@ -1540,14 +1531,12 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm)
 	}
 	default: {
 		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
-		nsvm_printk("exit code: 0x%x\n", exit_code);
 		if (svm->nested.intercept & exit_bits)
 			vmexit = NESTED_EXIT_DONE;
 	}
 	}
 
 	if (vmexit == NESTED_EXIT_DONE) {
-		nsvm_printk("#VMEXIT reason=%04x\n", exit_code);
 		nested_svm_vmexit(svm);
 	}
 
@@ -1658,10 +1647,6 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Restore the original control entries */
 	copy_vmcb_control_area(vmcb, hsave);
 
-	/* Kill any pending exceptions */
-	if (svm->vcpu.arch.exception.pending == true)
-		nsvm_printk("WARNING: Pending Exception\n");
-
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
@@ -1826,25 +1811,14 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	force_new_asid(&svm->vcpu);
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
-	if (nested_vmcb->control.int_ctl & V_IRQ_MASK) {
-		nsvm_printk("nSVM Injecting Interrupt: 0x%x\n",
-				nested_vmcb->control.int_ctl);
-	}
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
-	nsvm_printk("nSVM exit_int_info: 0x%x | int_state: 0x%x\n",
-			nested_vmcb->control.exit_int_info,
-			nested_vmcb->control.int_state);
-
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
 	svm->vmcb->control.tsc_offset += nested_vmcb->control.tsc_offset;
-	if (nested_vmcb->control.event_inj & SVM_EVTINJ_VALID)
-		nsvm_printk("Injecting Event: 0x%x\n",
-				nested_vmcb->control.event_inj);
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
@@ -1913,8 +1887,6 @@ static int vmsave_interception(struct vcpu_svm *svm)
 
 static int vmrun_interception(struct vcpu_svm *svm)
 {
-	nsvm_printk("VMrun\n");
-
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
@@ -1974,7 +1946,6 @@ static int clgi_interception(struct vcpu_svm *svm)
 static int invlpga_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	nsvm_printk("INVLPGA\n");
 
 	trace_kvm_invlpga(svm->vmcb->save.rip, vcpu->arch.regs[VCPU_REGS_RCX],
 			  vcpu->arch.regs[VCPU_REGS_RAX]);
@@ -2389,10 +2360,6 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 					svm->vmcb->control.exit_int_info,
 					svm->vmcb->control.exit_int_info_err);
 
-		nsvm_printk("nested handle_exit: 0x%x | 0x%lx | 0x%lx | 0x%lx\n",
-			    exit_code, svm->vmcb->control.exit_info_1,
-			    svm->vmcb->control.exit_info_2, svm->vmcb->save.rip);
-
 		vmexit = nested_svm_exit_special(svm);
 
 		if (vmexit == NESTED_EXIT_CONTINUE)
@@ -2539,7 +2506,6 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	nsvm_printk("Trying to open IRQ window\n");
 
 	nested_svm_intr(svm);
 
-- 
1.6.4.3


