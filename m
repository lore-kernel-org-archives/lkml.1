Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbXLZLMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbXLZLMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXLZLGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:36 -0500
Received: from il.qumranet.com ([82.166.9.18]:50479 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbXLZLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:05 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 14/55] KVM: SVM: Let gcc to choose which registers to save (i386)
Date: Wed, 26 Dec 2007 13:05:19 +0200
Message-Id: <1198667160-22953-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch lets GCC to determine which registers to save when we
switch to/from a VCPU in the case of AMD i386

* Original code saves following registers:

    ebx, ecx, edx, esi, edi, ebp

* Patched code:

  - informs GCC that we modify following registers
    using the clobber description:

    ebx, ecx, edx, esi, edi

  - rbp is saved (pop/push) because GCC seems to ignore its use in the clobber
    description.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 1298bde..cdd4fd2 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1501,8 +1501,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #ifdef CONFIG_X86_64
 		"push %%rbp; \n\t"
 #else
-		"push %%ebx; push %%ecx; push %%edx;"
-		"push %%esi; push %%edi; push %%ebp;"
+		"push %%ebp; \n\t"
 #endif
 
 #ifdef CONFIG_X86_64
@@ -1573,8 +1572,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %%edi, %c[rdi](%[svm]) \n\t"
 		"mov %%ebp, %c[rbp](%[svm]) \n\t"
 
-		"pop  %%ebp; pop  %%edi; pop  %%esi;"
-		"pop  %%edx; pop  %%ecx; pop  %%ebx; \n\t"
+		"pop  %%ebp; \n\t"
 #endif
 		:
 		: [svm]"a"(svm),
@@ -1599,6 +1597,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #ifdef CONFIG_X86_64
 		, "rbx", "rcx", "rdx", "rsi", "rdi"
 		, "r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15"
+#else
+		, "ebx", "ecx", "edx" , "esi", "edi"
 #endif
 		);
 
-- 
1.5.3.7

