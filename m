Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZB1Bqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZB1Bqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbZB1BmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41771 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/30] KVM: VMX: Use kvm_mmu_page_fault() handle EPT violation mmio
Date: Sat, 28 Feb 2009 03:41:32 +0200
Message-Id: <1235785309-12835-14-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Removed duplicated code.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 509b353..cb27ffc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3058,11 +3058,8 @@ static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification;
-	enum emulation_result er;
 	gpa_t gpa;
-	unsigned long hva;
 	int gla_validity;
-	int r;
 
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
 
@@ -3085,32 +3082,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
-	hva = gfn_to_hva(vcpu->kvm, gpa >> PAGE_SHIFT);
-	if (!kvm_is_error_hva(hva)) {
-		r = kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, 0);
-		if (r < 0) {
-			printk(KERN_ERR "EPT: Not enough memory!\n");
-			return -ENOMEM;
-		}
-		return 1;
-	} else {
-		/* must be MMIO */
-		er = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
-
-		if (er == EMULATE_FAIL) {
-			printk(KERN_ERR
-			 "EPT: Fail to handle EPT violation vmexit!er is %d\n",
-			 er);
-			printk(KERN_ERR "EPT: GPA: 0x%lx, GVA: 0x%lx\n",
-			 (long unsigned int)vmcs_read64(GUEST_PHYSICAL_ADDRESS),
-			 (long unsigned int)vmcs_read64(GUEST_LINEAR_ADDRESS));
-			printk(KERN_ERR "EPT: Exit qualification is 0x%lx\n",
-				(long unsigned int)exit_qualification);
-			return -ENOTSUPP;
-		} else if (er == EMULATE_DO_MMIO)
-			return 0;
-	}
-	return 1;
+	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, 0);
 }
 
 static int handle_nmi_window(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-- 
1.6.0.6

