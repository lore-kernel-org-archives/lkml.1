Return-Path: <linux-kernel-owner+w=401wt.eu-S1762119AbXFQJ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762119AbXFQJ7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbXFQJpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:38 -0400
Received: from il.qumranet.com ([82.166.9.18]:55212 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759469AbXFQJov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:51 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 57/58] KVM: Initialize the BSP bit in the APIC_BASE msr correctly
Date: Sun, 17 Jun 2007 12:44:38 +0300
Message-Id: <11820734823256-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Needs to be set on vcpu 0 only.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    6 +++---
 drivers/kvm/vmx.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 68841ef..62ec38c 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -589,9 +589,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	fx_init(vcpu);
 	vcpu->fpu_active = 1;
-	vcpu->apic_base = 0xfee00000 |
-			/*for vcpu 0*/ MSR_IA32_APICBASE_BSP |
-			MSR_IA32_APICBASE_ENABLE;
+	vcpu->apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	if (vcpu == &vcpu->kvm->vcpus[0])
+		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
 
 	return 0;
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index b909b54..0b2aace 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1238,9 +1238,9 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	memset(vcpu->regs, 0, sizeof(vcpu->regs));
 	vcpu->regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	vcpu->cr8 = 0;
-	vcpu->apic_base = 0xfee00000 |
-			/*for vcpu 0*/ MSR_IA32_APICBASE_BSP |
-			MSR_IA32_APICBASE_ENABLE;
+	vcpu->apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	if (vcpu == &vcpu->kvm->vcpus[0])
+		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
 
 	fx_init(vcpu);
 
-- 
1.5.0.6

