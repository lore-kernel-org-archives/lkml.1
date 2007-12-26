Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbXLZLZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbXLZLZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXLZLHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:18 -0500
Received: from il.qumranet.com ([82.166.9.18]:50468 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbXLZLGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:12 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 54/55] KVM: VMX: Consolidate register usage in vmx_vcpu_run()
Date: Wed, 26 Dec 2007 13:05:59 +0200
Message-Id: <1198667160-22953-55-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We pass vcpu, vmx->fail, and vmx->launched to assembly code, but all three
are fields within vmx.  Consolidate by only passing in vmx and offsets for
the rest.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |  146 ++++++++++++++++++++++++++--------------------------
 1 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 18fd918..30220ea 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2350,36 +2350,36 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
 		/* Check if vmlaunch of vmresume is needed */
-		"cmp $0, %1 \n\t"
+		"cmpl $0, %c[launched](%0) \n\t"
 		/* Load guest registers.  Don't clobber flags. */
 #ifdef CONFIG_X86_64
-		"mov %c[cr2](%3), %%rax \n\t"
+		"mov %c[cr2](%0), %%rax \n\t"
 		"mov %%rax, %%cr2 \n\t"
-		"mov %c[rax](%3), %%rax \n\t"
-		"mov %c[rbx](%3), %%rbx \n\t"
-		"mov %c[rdx](%3), %%rdx \n\t"
-		"mov %c[rsi](%3), %%rsi \n\t"
-		"mov %c[rdi](%3), %%rdi \n\t"
-		"mov %c[rbp](%3), %%rbp \n\t"
-		"mov %c[r8](%3),  %%r8  \n\t"
-		"mov %c[r9](%3),  %%r9  \n\t"
-		"mov %c[r10](%3), %%r10 \n\t"
-		"mov %c[r11](%3), %%r11 \n\t"
-		"mov %c[r12](%3), %%r12 \n\t"
-		"mov %c[r13](%3), %%r13 \n\t"
-		"mov %c[r14](%3), %%r14 \n\t"
-		"mov %c[r15](%3), %%r15 \n\t"
-		"mov %c[rcx](%3), %%rcx \n\t" /* kills %3 (rcx) */
+		"mov %c[rax](%0), %%rax \n\t"
+		"mov %c[rbx](%0), %%rbx \n\t"
+		"mov %c[rdx](%0), %%rdx \n\t"
+		"mov %c[rsi](%0), %%rsi \n\t"
+		"mov %c[rdi](%0), %%rdi \n\t"
+		"mov %c[rbp](%0), %%rbp \n\t"
+		"mov %c[r8](%0),  %%r8  \n\t"
+		"mov %c[r9](%0),  %%r9  \n\t"
+		"mov %c[r10](%0), %%r10 \n\t"
+		"mov %c[r11](%0), %%r11 \n\t"
+		"mov %c[r12](%0), %%r12 \n\t"
+		"mov %c[r13](%0), %%r13 \n\t"
+		"mov %c[r14](%0), %%r14 \n\t"
+		"mov %c[r15](%0), %%r15 \n\t"
+		"mov %c[rcx](%0), %%rcx \n\t" /* kills %0 (rcx) */
 #else
-		"mov %c[cr2](%3), %%eax \n\t"
+		"mov %c[cr2](%0), %%eax \n\t"
 		"mov %%eax,   %%cr2 \n\t"
-		"mov %c[rax](%3), %%eax \n\t"
-		"mov %c[rbx](%3), %%ebx \n\t"
-		"mov %c[rdx](%3), %%edx \n\t"
-		"mov %c[rsi](%3), %%esi \n\t"
-		"mov %c[rdi](%3), %%edi \n\t"
-		"mov %c[rbp](%3), %%ebp \n\t"
-		"mov %c[rcx](%3), %%ecx \n\t" /* kills %3 (ecx) */
+		"mov %c[rax](%0), %%eax \n\t"
+		"mov %c[rbx](%0), %%ebx \n\t"
+		"mov %c[rdx](%0), %%edx \n\t"
+		"mov %c[rsi](%0), %%esi \n\t"
+		"mov %c[rdi](%0), %%edi \n\t"
+		"mov %c[rbp](%0), %%ebp \n\t"
+		"mov %c[rcx](%0), %%ecx \n\t" /* kills %0 (ecx) */
 #endif
 		/* Enter guest mode */
 		"jne .Llaunched \n\t"
@@ -2389,62 +2389,62 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		".Lkvm_vmx_return: "
 		/* Save guest registers, load host registers, keep flags */
 #ifdef CONFIG_X86_64
-		"xchg %3,     (%%rsp) \n\t"
-		"mov %%rax, %c[rax](%3) \n\t"
-		"mov %%rbx, %c[rbx](%3) \n\t"
-		"pushq (%%rsp); popq %c[rcx](%3) \n\t"
-		"mov %%rdx, %c[rdx](%3) \n\t"
-		"mov %%rsi, %c[rsi](%3) \n\t"
-		"mov %%rdi, %c[rdi](%3) \n\t"
-		"mov %%rbp, %c[rbp](%3) \n\t"
-		"mov %%r8,  %c[r8](%3) \n\t"
-		"mov %%r9,  %c[r9](%3) \n\t"
-		"mov %%r10, %c[r10](%3) \n\t"
-		"mov %%r11, %c[r11](%3) \n\t"
-		"mov %%r12, %c[r12](%3) \n\t"
-		"mov %%r13, %c[r13](%3) \n\t"
-		"mov %%r14, %c[r14](%3) \n\t"
-		"mov %%r15, %c[r15](%3) \n\t"
+		"xchg %0,     (%%rsp) \n\t"
+		"mov %%rax, %c[rax](%0) \n\t"
+		"mov %%rbx, %c[rbx](%0) \n\t"
+		"pushq (%%rsp); popq %c[rcx](%0) \n\t"
+		"mov %%rdx, %c[rdx](%0) \n\t"
+		"mov %%rsi, %c[rsi](%0) \n\t"
+		"mov %%rdi, %c[rdi](%0) \n\t"
+		"mov %%rbp, %c[rbp](%0) \n\t"
+		"mov %%r8,  %c[r8](%0) \n\t"
+		"mov %%r9,  %c[r9](%0) \n\t"
+		"mov %%r10, %c[r10](%0) \n\t"
+		"mov %%r11, %c[r11](%0) \n\t"
+		"mov %%r12, %c[r12](%0) \n\t"
+		"mov %%r13, %c[r13](%0) \n\t"
+		"mov %%r14, %c[r14](%0) \n\t"
+		"mov %%r15, %c[r15](%0) \n\t"
 		"mov %%cr2, %%rax   \n\t"
-		"mov %%rax, %c[cr2](%3) \n\t"
+		"mov %%rax, %c[cr2](%0) \n\t"
 
-		"pop  %%rcx; pop  %%rbp; pop  %%rdx \n\t"
+		"pop  %%rbp; pop  %%rbp; pop  %%rdx \n\t"
 #else
-		"xchg %3, (%%esp) \n\t"
-		"mov %%eax, %c[rax](%3) \n\t"
-		"mov %%ebx, %c[rbx](%3) \n\t"
-		"pushl (%%esp); popl %c[rcx](%3) \n\t"
-		"mov %%edx, %c[rdx](%3) \n\t"
-		"mov %%esi, %c[rsi](%3) \n\t"
-		"mov %%edi, %c[rdi](%3) \n\t"
-		"mov %%ebp, %c[rbp](%3) \n\t"
+		"xchg %0, (%%esp) \n\t"
+		"mov %%eax, %c[rax](%0) \n\t"
+		"mov %%ebx, %c[rbx](%0) \n\t"
+		"pushl (%%esp); popl %c[rcx](%0) \n\t"
+		"mov %%edx, %c[rdx](%0) \n\t"
+		"mov %%esi, %c[rsi](%0) \n\t"
+		"mov %%edi, %c[rdi](%0) \n\t"
+		"mov %%ebp, %c[rbp](%0) \n\t"
 		"mov %%cr2, %%eax  \n\t"
-		"mov %%eax, %c[cr2](%3) \n\t"
+		"mov %%eax, %c[cr2](%0) \n\t"
 
-		"pop %%ecx; pop %%ebp; pop %%edx \n\t"
+		"pop %%ebp; pop %%ebp; pop %%edx \n\t"
 #endif
-		"setbe %0 \n\t"
-	      : "=q" (vmx->fail)
-	      : "r"(vmx->launched), "d"((unsigned long)HOST_RSP),
-		"c"(vcpu),
-		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
-		[rbx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBX])),
-		[rcx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RCX])),
-		[rdx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDX])),
-		[rsi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RSI])),
-		[rdi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDI])),
-		[rbp]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBP])),
+		"setbe %c[fail](%0) \n\t"
+	      : : "c"(vmx), "d"((unsigned long)HOST_RSP),
+		[launched]"i"(offsetof(struct vcpu_vmx, launched)),
+		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
+		[rax]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RAX])),
+		[rbx]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RBX])),
+		[rcx]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RCX])),
+		[rdx]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RDX])),
+		[rsi]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RSI])),
+		[rdi]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RDI])),
+		[rbp]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_RBP])),
 #ifdef CONFIG_X86_64
-		[r8]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8])),
-		[r9]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R9])),
-		[r10]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R10])),
-		[r11]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R11])),
-		[r12]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R12])),
-		[r13]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R13])),
-		[r14]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R14])),
-		[r15]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R15])),
+		[r8]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R8])),
+		[r9]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R9])),
+		[r10]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R10])),
+		[r11]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R11])),
+		[r12]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R12])),
+		[r13]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R13])),
+		[r14]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R14])),
+		[r15]"i"(offsetof(struct vcpu_vmx, vcpu.regs[VCPU_REGS_R15])),
 #endif
-		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
+		[cr2]"i"(offsetof(struct vcpu_vmx, vcpu.cr2))
 	      : "cc", "memory"
 #ifdef CONFIG_X86_64
 		, "rbx", "rdi", "rsi"
-- 
1.5.3.7

