Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZETLVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZETLVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZETLS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:18:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55253 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbZETLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:46 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 02/46] KVM: VMX: Correct wrong vmcs field sizes
Date: Wed, 20 May 2009 14:17:59 +0300
Message-Id: <1242818323-10413-3-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

EXIT_QUALIFICATION and GUEST_LINEAR_ADDRESS are natural width, not 64-bit.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 37ae13d..aba41ae 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2991,7 +2991,7 @@ static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_invlpg(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u64 exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
+	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 
 	kvm_mmu_invlpg(vcpu, exit_qualification);
 	skip_emulated_instruction(vcpu);
@@ -3007,11 +3007,11 @@ static int handle_wbinvd(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_apic_access(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u64 exit_qualification;
+	unsigned long exit_qualification;
 	enum emulation_result er;
 	unsigned long offset;
 
-	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	offset = exit_qualification & 0xffful;
 
 	er = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
@@ -3062,11 +3062,11 @@ static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u64 exit_qualification;
+	unsigned long exit_qualification;
 	gpa_t gpa;
 	int gla_validity;
 
-	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 
 	if (exit_qualification & (1 << 6)) {
 		printk(KERN_ERR "EPT: GPA exceeds GAW!\n");
@@ -3078,7 +3078,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		printk(KERN_ERR "EPT: Handling EPT violation failed!\n");
 		printk(KERN_ERR "EPT: GPA: 0x%lx, GVA: 0x%lx\n",
 			(long unsigned int)vmcs_read64(GUEST_PHYSICAL_ADDRESS),
-			(long unsigned int)vmcs_read64(GUEST_LINEAR_ADDRESS));
+			vmcs_readl(GUEST_LINEAR_ADDRESS));
 		printk(KERN_ERR "EPT: Exit qualification is 0x%lx\n",
 			(long unsigned int)exit_qualification);
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
-- 
1.6.0.6

