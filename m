Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZHSNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZHSNJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZHSNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50570 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751884AbZHSNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/47] KVM: SVM: Implement INVLPGA
Date: Wed, 19 Aug 2009 16:02:18 +0300
Message-Id: <1250686963-8357-23-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

SVM adds another way to do INVLPG by ASID which Hyper-V makes use of,
so let's implement it!

For now we just do the same thing invlpg does, as asid switching
means we flush the mmu anyways. That might change one day though.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8f80190..cd5a081 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1883,6 +1883,19 @@ static int clgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int invlpga_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	nsvm_printk("INVLPGA\n");
+
+	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
+	kvm_mmu_invlpg(vcpu, vcpu->arch.regs[VCPU_REGS_RAX]);
+
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
+	skip_emulated_instruction(&svm->vcpu);
+	return 1;
+}
+
 static int invalid_op_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
@@ -2228,7 +2241,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
-	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
+	[SVM_EXIT_INVLPGA]			= invlpga_interception,
 	[SVM_EXIT_IOIO] 		  	= io_interception,
 	[SVM_EXIT_MSR]				= msr_interception,
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
-- 
1.6.3.3

