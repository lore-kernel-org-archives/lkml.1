Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbXLZLKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbXLZLKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXLZLG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:27 -0500
Received: from il.qumranet.com ([82.166.9.18]:50472 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbXLZLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:05 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 11/55] KVM: VMX: Let gcc to choose which registers to save (x86_64)
Date: Wed, 26 Dec 2007 13:05:16 +0200
Message-Id: <1198667160-22953-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch lets GCC to determine which registers to save when we
switch to/from a VCPU in the case of intel x86_64.

* Original code saves following registers:

    rax, rbx, rcx, rdx, rsi, rdi, rbp,
    r8, r9, r10, r11, r12, r13, r14, r15

* Patched code:

  - informs GCC that we modify following registers
    using the clobber description:

    rbx, rdi, rsi,
    r8, r9, r10, r11, r12, r13, r14, r15

  - doesn't save rax because it is an output operand (vmx->fail)

  - cannot put rcx in clobber description because it is an input operand,
    but as we modify it and we want to keep its value (vcpu), we must
    save it (pop/push)

  - rbp is saved (pop/push) because GCC seems to ignore its use in the clobber
    description.

  - rdx is saved (pop/push) because it is reserved by GCC (REGPARM) and
    cannot be put in the clobber description.

  - line "mov (%%rsp), %3 \n\t" has been removed because %3
    is rcx and rcx is restored just after.

  - line ASM_VMX_VMWRITE_RSP_RDX() is moved out of the ifdef/else/endif

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 50c151e..3a58a2a 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2265,16 +2265,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	asm(
 		/* Store host registers */
 #ifdef CONFIG_X86_64
-		"push %%rax; push %%rbx; push %%rdx;"
-		"push %%rsi; push %%rdi; push %%rbp;"
-		"push %%r8;  push %%r9;  push %%r10; push %%r11;"
-		"push %%r12; push %%r13; push %%r14; push %%r15;"
+		"push %%rdx; push %%rbp;"
 		"push %%rcx \n\t"
-		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
 #else
 		"pusha; push %%ecx \n\t"
-		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
 #endif
+		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
 		/* Check if vmlaunch of vmresume is needed */
 		"cmp $0, %1 \n\t"
 		/* Load guest registers.  Don't clobber flags. */
@@ -2333,12 +2329,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %%r15, %c[r15](%3) \n\t"
 		"mov %%cr2, %%rax   \n\t"
 		"mov %%rax, %c[cr2](%3) \n\t"
-		"mov (%%rsp), %3 \n\t"
 
-		"pop  %%rcx; pop  %%r15; pop  %%r14; pop  %%r13; pop  %%r12;"
-		"pop  %%r11; pop  %%r10; pop  %%r9;  pop  %%r8;"
-		"pop  %%rbp; pop  %%rdi; pop  %%rsi;"
-		"pop  %%rdx; pop  %%rbx; pop  %%rax \n\t"
+		"pop  %%rcx; pop  %%rbp; pop  %%rdx \n\t"
 #else
 		"xchg %3, (%%esp) \n\t"
 		"mov %%eax, %c[rax](%3) \n\t"
@@ -2376,7 +2368,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		[r15]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R15])),
 #endif
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
-	      : "cc", "memory");
+	      : "cc", "memory"
+#ifdef CONFIG_X86_64
+		, "rbx", "rdi", "rsi"
+		, "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"
+#endif
+	      );
 
 	vcpu->interrupt_window_open =
 		(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
-- 
1.5.3.7

