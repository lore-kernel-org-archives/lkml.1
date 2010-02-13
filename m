Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0BMIFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:05:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/39] KVM: SVM: Initialize fpu_active in init_vmcb()
Date: Sat, 13 Feb 2010 10:01:44 +0200
Message-Id: <1266048119-14325-25-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_vmcb() sets up the intercepts as if the fpu is active, so initialize it
there.  This avoids an INIT from setting up intercepts inconsistent with
fpu_active.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5b336a8..949990e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -540,6 +540,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct vmcb_save_area *save = &svm->vmcb->save;
 
+	svm->vcpu.fpu_active = 1;
+
 	control->intercept_cr_read = 	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
 					INTERCEPT_CR4_MASK;
@@ -730,7 +732,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	init_vmcb(svm);
 
 	fx_init(&svm->vcpu);
-	svm->vcpu.fpu_active = 1;
 	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
 	if (kvm_vcpu_is_bsp(&svm->vcpu))
 		svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
-- 
1.6.5.3

