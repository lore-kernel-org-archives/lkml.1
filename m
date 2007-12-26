Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbXLZLJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbXLZLJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXLZLGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:24 -0500
Received: from il.qumranet.com ([82.166.9.18]:50473 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXLZLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:05 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 12/55] KVM: VMX: Let gcc to choose which registers to save (i386)
Date: Wed, 26 Dec 2007 13:05:17 +0200
Message-Id: <1198667160-22953-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch lets GCC to determine which registers to save when we
switch to/from a VCPU in the case of intel i386.

* Original code saves following registers:

    eax, ebx, ecx, edx, edi, esi, ebp (using popa)

* Patched code:

  - informs GCC that we modify following registers
    using the clobber description:

    ebx, edi, rsi

  - doesn't save eax because it is an output operand (vmx->fail)

  - cannot put ecx in clobber description because it is an input operand,
    but as we modify it and we want to keep its value (vcpu), we must
    save it (pop/push)

  - ebp is saved (pop/push) because GCC seems to ignore its use the clobber
    description.

  - edx is saved (pop/push) because it is reserved by GCC (REGPARM) and
    cannot be put in the clobber description.

  - line "mov (%%esp), %3 \n\t" has been removed because %3
    is ecx and ecx is restored just after.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 3a58a2a..f76677d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2268,7 +2268,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"push %%rdx; push %%rbp;"
 		"push %%rcx \n\t"
 #else
-		"pusha; push %%ecx \n\t"
+		"push %%edx; push %%ebp;"
+		"push %%ecx \n\t"
 #endif
 		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
 		/* Check if vmlaunch of vmresume is needed */
@@ -2342,9 +2343,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %%ebp, %c[rbp](%3) \n\t"
 		"mov %%cr2, %%eax  \n\t"
 		"mov %%eax, %c[cr2](%3) \n\t"
-		"mov (%%esp), %3 \n\t"
 
-		"pop %%ecx; popa \n\t"
+		"pop %%ecx; pop %%ebp; pop %%edx \n\t"
 #endif
 		"setbe %0 \n\t"
 	      : "=q" (vmx->fail)
@@ -2372,6 +2372,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #ifdef CONFIG_X86_64
 		, "rbx", "rdi", "rsi"
 		, "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"
+#else
+		, "ebx", "edi", "rsi"
 #endif
 	      );
 
-- 
1.5.3.7

