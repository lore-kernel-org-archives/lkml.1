Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZLOELw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZLOELw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbZLOELd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:11:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758766AbZLOEHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:08 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 07/20] Basic SVM implementation of RDTSC trapping.
Date: Mon, 14 Dec 2009 18:08:34 -1000
Message-Id: <1260850127-9766-8-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-7-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dumb version of RDTSC trapping for SVM which just passes
through the hardware counter.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/emulate.c |    2 +-
 arch/x86/kvm/svm.c     |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d226dff..76e180f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -226,7 +226,7 @@ static u32 twobyte_table[256] = {
 	ModRM | ImplicitOps, ModRM, ModRM | ImplicitOps, ModRM, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x30 - 0x3F */
-	ImplicitOps, 0, ImplicitOps, 0,
+	ImplicitOps, ImplicitOps, ImplicitOps, 0,
 	ImplicitOps, ImplicitOps, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x40 - 0x47 */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 34b700f..16c9048 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -571,6 +571,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
 				(1ULL << INTERCEPT_SMI) |
+				(1ULL << INTERCEPT_RDTSC) |
 				(1ULL << INTERCEPT_CPUID) |
 				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
@@ -2029,6 +2030,19 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	return kvm_task_switch(&svm->vcpu, tss_selector, reason);
 }
 
+static int rdtsc_interception(struct vcpu_svm *svm)
+{
+	u64 tsc;
+
+	rdtscll(tsc);
+	tsc += svm->vmcb->control.tsc_offset;
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, tsc & 0xffffffff);
+	tsc >>= 32;
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RDX, tsc & 0xffffffff);
+	skip_emulated_instruction(&svm->vcpu);
+	return 1;
+}
+
 static int cpuid_interception(struct vcpu_svm *svm)
 {
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
@@ -2326,6 +2340,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_INIT]				= nop_on_interception,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	/* [SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception, */
+	[SVM_EXIT_RDTSC]			= rdtsc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
-- 
1.6.5.2

