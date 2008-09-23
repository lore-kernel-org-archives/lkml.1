Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYIWNwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYIWNwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYIWNrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYIWNr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:27 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 18/40] KVM: SVM: Unify register save/restore across 32 and 64 bit hosts
Date: Tue, 23 Sep 2008 16:46:32 +0300
Message-Id: <1222177614-26669-19-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   78 +++++++++++++++++----------------------------------
 1 files changed, 26 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 743c98d..179c2e0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1697,6 +1697,12 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
 }
 
+#ifdef CONFIG_X86_64
+#define R "r"
+#else
+#define R "e"
+#endif
+
 static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1735,19 +1741,14 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	local_irq_enable();
 
 	asm volatile (
+		"push %%"R"bp; \n\t"
+		"mov %c[rbx](%[svm]), %%"R"bx \n\t"
+		"mov %c[rcx](%[svm]), %%"R"cx \n\t"
+		"mov %c[rdx](%[svm]), %%"R"dx \n\t"
+		"mov %c[rsi](%[svm]), %%"R"si \n\t"
+		"mov %c[rdi](%[svm]), %%"R"di \n\t"
+		"mov %c[rbp](%[svm]), %%"R"bp \n\t"
 #ifdef CONFIG_X86_64
-		"push %%rbp; \n\t"
-#else
-		"push %%ebp; \n\t"
-#endif
-
-#ifdef CONFIG_X86_64
-		"mov %c[rbx](%[svm]), %%rbx \n\t"
-		"mov %c[rcx](%[svm]), %%rcx \n\t"
-		"mov %c[rdx](%[svm]), %%rdx \n\t"
-		"mov %c[rsi](%[svm]), %%rsi \n\t"
-		"mov %c[rdi](%[svm]), %%rdi \n\t"
-		"mov %c[rbp](%[svm]), %%rbp \n\t"
 		"mov %c[r8](%[svm]),  %%r8  \n\t"
 		"mov %c[r9](%[svm]),  %%r9  \n\t"
 		"mov %c[r10](%[svm]), %%r10 \n\t"
@@ -1756,41 +1757,24 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %c[r13](%[svm]), %%r13 \n\t"
 		"mov %c[r14](%[svm]), %%r14 \n\t"
 		"mov %c[r15](%[svm]), %%r15 \n\t"
-#else
-		"mov %c[rbx](%[svm]), %%ebx \n\t"
-		"mov %c[rcx](%[svm]), %%ecx \n\t"
-		"mov %c[rdx](%[svm]), %%edx \n\t"
-		"mov %c[rsi](%[svm]), %%esi \n\t"
-		"mov %c[rdi](%[svm]), %%edi \n\t"
-		"mov %c[rbp](%[svm]), %%ebp \n\t"
 #endif
 
-#ifdef CONFIG_X86_64
 		/* Enter guest mode */
-		"push %%rax \n\t"
-		"mov %c[vmcb](%[svm]), %%rax \n\t"
+		"push %%"R"ax \n\t"
+		"mov %c[vmcb](%[svm]), %%"R"ax \n\t"
 		__ex(SVM_VMLOAD) "\n\t"
 		__ex(SVM_VMRUN) "\n\t"
 		__ex(SVM_VMSAVE) "\n\t"
-		"pop %%rax \n\t"
-#else
-		/* Enter guest mode */
-		"push %%eax \n\t"
-		"mov %c[vmcb](%[svm]), %%eax \n\t"
-		__ex(SVM_VMLOAD) "\n\t"
-		__ex(SVM_VMRUN) "\n\t"
-		__ex(SVM_VMSAVE) "\n\t"
-		"pop %%eax \n\t"
-#endif
+		"pop %%"R"ax \n\t"
 
 		/* Save guest registers, load host registers */
+		"mov %%"R"bx, %c[rbx](%[svm]) \n\t"
+		"mov %%"R"cx, %c[rcx](%[svm]) \n\t"
+		"mov %%"R"dx, %c[rdx](%[svm]) \n\t"
+		"mov %%"R"si, %c[rsi](%[svm]) \n\t"
+		"mov %%"R"di, %c[rdi](%[svm]) \n\t"
+		"mov %%"R"bp, %c[rbp](%[svm]) \n\t"
 #ifdef CONFIG_X86_64
-		"mov %%rbx, %c[rbx](%[svm]) \n\t"
-		"mov %%rcx, %c[rcx](%[svm]) \n\t"
-		"mov %%rdx, %c[rdx](%[svm]) \n\t"
-		"mov %%rsi, %c[rsi](%[svm]) \n\t"
-		"mov %%rdi, %c[rdi](%[svm]) \n\t"
-		"mov %%rbp, %c[rbp](%[svm]) \n\t"
 		"mov %%r8,  %c[r8](%[svm]) \n\t"
 		"mov %%r9,  %c[r9](%[svm]) \n\t"
 		"mov %%r10, %c[r10](%[svm]) \n\t"
@@ -1799,18 +1783,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %%r13, %c[r13](%[svm]) \n\t"
 		"mov %%r14, %c[r14](%[svm]) \n\t"
 		"mov %%r15, %c[r15](%[svm]) \n\t"
-
-		"pop  %%rbp; \n\t"
-#else
-		"mov %%ebx, %c[rbx](%[svm]) \n\t"
-		"mov %%ecx, %c[rcx](%[svm]) \n\t"
-		"mov %%edx, %c[rdx](%[svm]) \n\t"
-		"mov %%esi, %c[rsi](%[svm]) \n\t"
-		"mov %%edi, %c[rdi](%[svm]) \n\t"
-		"mov %%ebp, %c[rbp](%[svm]) \n\t"
-
-		"pop  %%ebp; \n\t"
 #endif
+		"pop %%"R"bp"
 		:
 		: [svm]"a"(svm),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
@@ -1831,11 +1805,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		  [r15]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R15]))
 #endif
 		: "cc", "memory"
+		, R"bx", R"cx", R"dx", R"si", R"di"
 #ifdef CONFIG_X86_64
-		, "rbx", "rcx", "rdx", "rsi", "rdi"
 		, "r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15"
-#else
-		, "ebx", "ecx", "edx" , "esi", "edi"
 #endif
 		);
 
@@ -1867,6 +1839,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	svm->next_rip = 0;
 }
 
+#undef R
+
 static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-- 
1.6.0.1

