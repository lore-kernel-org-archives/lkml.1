Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXD2Pv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXD2Pv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbXD2Put
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:50:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:34351 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbXD2PuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:50:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 1/7] KVM: VMX: Properly shadow the CR0 register in the vcpu struct
Date: Sun, 29 Apr 2007 18:50:16 +0300
Message-Id: <11778618221380-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1177861822889-git-send-email-avi@qumranet.com>
References: <1177861822889-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

Set all of the host mask bits for CR0 so that we can maintain a proper
shadow of CR0.  This exposes CR0.TS, paving the way for lazy fpu handling.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    8 +++-----
 drivers/kvm/svm.c      |    4 ++--
 drivers/kvm/vmx.c      |   14 ++++++++------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 61ff085..f99e89e 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -397,7 +397,7 @@ struct kvm_arch_ops {
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
-	void (*decache_cr0_cr4_guest_bits)(struct kvm_vcpu *vcpu);
+	void (*decache_cr4_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 6755403..cdf0b17 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -510,7 +510,6 @@ EXPORT_SYMBOL_GPL(set_cr0);
 
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-	kvm_arch_ops->decache_cr0_cr4_guest_bits(vcpu);
 	set_cr0(vcpu, (vcpu->cr0 & ~0x0ful) | (msw & 0x0f));
 }
 EXPORT_SYMBOL_GPL(lmsw);
@@ -1117,7 +1116,6 @@ int emulate_clts(struct kvm_vcpu *vcpu)
 {
 	unsigned long cr0;
 
-	kvm_arch_ops->decache_cr0_cr4_guest_bits(vcpu);
 	cr0 = vcpu->cr0 & ~CR0_TS_MASK;
 	kvm_arch_ops->set_cr0(vcpu, cr0);
 	return X86EMUL_CONTINUE;
@@ -1318,7 +1316,7 @@ void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
 
 unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 {
-	kvm_arch_ops->decache_cr0_cr4_guest_bits(vcpu);
+	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
 	switch (cr) {
 	case 0:
 		return vcpu->cr0;
@@ -1934,7 +1932,7 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->gdt.limit = dt.limit;
 	sregs->gdt.base = dt.base;
 
-	kvm_arch_ops->decache_cr0_cr4_guest_bits(vcpu);
+	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
 	sregs->cr0 = vcpu->cr0;
 	sregs->cr2 = vcpu->cr2;
 	sregs->cr3 = vcpu->cr3;
@@ -1985,7 +1983,7 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 #endif
 	vcpu->apic_base = sregs->apic_base;
 
-	kvm_arch_ops->decache_cr0_cr4_guest_bits(vcpu);
+	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
 
 	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
 	kvm_arch_ops->set_cr0(vcpu, sregs->cr0);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 2a7a039..bddd023 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -738,7 +738,7 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 	vcpu->svm->vmcb->save.gdtr.base = dt->base ;
 }
 
-static void svm_decache_cr0_cr4_guest_bits(struct kvm_vcpu *vcpu)
+static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
 }
 
@@ -1759,7 +1759,7 @@ static struct kvm_arch_ops svm_arch_ops = {
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
 	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
-	.decache_cr0_cr4_guest_bits = svm_decache_cr0_cr4_guest_bits,
+	.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
 	.set_cr0 = svm_set_cr0,
 	.set_cr3 = svm_set_cr3,
 	.set_cr4 = svm_set_cr4,
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index d28c848..0960811 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -810,11 +810,8 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
-static void vmx_decache_cr0_cr4_guest_bits(struct kvm_vcpu *vcpu)
+static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
-	vcpu->cr0 &= KVM_GUEST_CR0_MASK;
-	vcpu->cr0 |= vmcs_readl(GUEST_CR0) & ~KVM_GUEST_CR0_MASK;
-
 	vcpu->cr4 &= KVM_GUEST_CR4_MASK;
 	vcpu->cr4 |= vmcs_readl(GUEST_CR4) & ~KVM_GUEST_CR4_MASK;
 }
@@ -1205,7 +1202,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	vmcs_writel(TPR_THRESHOLD, 0);
 #endif
 
-	vmcs_writel(CR0_GUEST_HOST_MASK, KVM_GUEST_CR0_MASK);
+	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
 
 	vcpu->cr0 = 0x60000010;
@@ -1557,6 +1554,11 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			return 1;
 		};
 		break;
+	case 2: /* clts */
+		vcpu_load_rsp_rip(vcpu);
+		set_cr0(vcpu, vcpu->cr0 & ~CR0_TS_MASK);
+		skip_emulated_instruction(vcpu);
+		return 1;
 	case 1: /*mov from cr*/
 		switch (cr) {
 		case 3:
@@ -2112,7 +2114,7 @@ static struct kvm_arch_ops vmx_arch_ops = {
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
-	.decache_cr0_cr4_guest_bits = vmx_decache_cr0_cr4_guest_bits,
+	.decache_cr4_guest_bits = vmx_decache_cr4_guest_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
-- 
1.5.0.6

