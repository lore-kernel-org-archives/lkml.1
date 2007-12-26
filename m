Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXLZLLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXLZLLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXLZLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:32 -0500
Received: from il.qumranet.com ([82.166.9.18]:50478 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbXLZLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:05 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 13/55] KVM: SVM: Let gcc to choose which registers to save (x86_64)
Date: Wed, 26 Dec 2007 13:05:18 +0200
Message-Id: <1198667160-22953-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch lets GCC to determine which registers to save when we
switch to/from a VCPU in the case of AMD x86_64.

* Original code saves following registers:

    rbx, rcx, rdx, rsi, rdi, rbp,
    r8, r9, r10, r11, r12, r13, r14, r15

* Patched code:

  - informs GCC that we modify following registers
    using the clobber description:

    rbx, rcx, rdx, rsi, rdi
    r8, r9, r10, r11, r12, r13, r14, r15

  - rbp is saved (pop/push) because GCC seems to ignore its use in the clobber
    description.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 56d1ad6..1298bde 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1499,10 +1499,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	asm volatile (
 #ifdef CONFIG_X86_64
-		"push %%rbx; push %%rcx; push %%rdx;"
-		"push %%rsi; push %%rdi; push %%rbp;"
-		"push %%r8;  push %%r9;  push %%r10; push %%r11;"
-		"push %%r12; push %%r13; push %%r14; push %%r15;"
+		"push %%rbp; \n\t"
 #else
 		"push %%ebx; push %%ecx; push %%edx;"
 		"push %%esi; push %%edi; push %%ebp;"
@@ -1567,10 +1564,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %%r14, %c[r14](%[svm]) \n\t"
 		"mov %%r15, %c[r15](%[svm]) \n\t"
 
-		"pop  %%r15; pop  %%r14; pop  %%r13; pop  %%r12;"
-		"pop  %%r11; pop  %%r10; pop  %%r9;  pop  %%r8;"
-		"pop  %%rbp; pop  %%rdi; pop  %%rsi;"
-		"pop  %%rdx; pop  %%rcx; pop  %%rbx; \n\t"
+		"pop  %%rbp; \n\t"
 #else
 		"mov %%ebx, %c[rbx](%[svm]) \n\t"
 		"mov %%ecx, %c[rcx](%[svm]) \n\t"
@@ -1601,7 +1595,12 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		  [r14]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R14])),
 		  [r15]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R15]))
 #endif
-		: "cc", "memory");
+		: "cc", "memory"
+#ifdef CONFIG_X86_64
+		, "rbx", "rcx", "rdx", "rsi", "rdi"
+		, "r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15"
+#endif
+		);
 
 	if ((svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(svm->host_db_regs);
-- 
1.5.3.7

