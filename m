Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0BMIIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:08:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/39] KVM: VMX: Allow the guest to own some cr0 bits
Date: Sat, 13 Feb 2010 10:01:39 +0200
Message-Id: <1266048119-14325-20-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use this later to give the guest ownership of cr0.ts.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/kvm_cache_regs.h   |    2 ++
 arch/x86/kvm/svm.c              |    5 +++++
 arch/x86/kvm/vmx.c              |    9 +++++++++
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a4de557..693046a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -269,6 +269,7 @@ struct kvm_vcpu_arch {
 	u32 regs_dirty;
 
 	unsigned long cr0;
+	unsigned long cr0_guest_owned_bits;
 	unsigned long cr2;
 	unsigned long cr3;
 	unsigned long cr4;
@@ -489,6 +490,7 @@ struct kvm_x86_ops {
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
+	void (*decache_cr0_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*decache_cr4_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index f468597..6b419a3 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -40,6 +40,8 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 
 static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
+	if (mask & vcpu->arch.cr0_guest_owned_bits)
+		kvm_x86_ops->decache_cr0_guest_bits(vcpu);
 	return vcpu->arch.cr0 & mask;
 }
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d3246ce..3899c2d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -956,6 +956,10 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 	svm->vmcb->save.gdtr.base = dt->base ;
 }
 
+static void svm_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
+{
+}
+
 static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
 }
@@ -2948,6 +2952,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_segment = svm_set_segment,
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
+	.decache_cr0_guest_bits = svm_decache_cr0_guest_bits,
 	.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
 	.set_cr0 = svm_set_cr0,
 	.set_cr3 = svm_set_cr3,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4c7177c..dbcdb55 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1653,6 +1653,14 @@ static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 		ept_sync_context(construct_eptp(vcpu->arch.mmu.root_hpa));
 }
 
+static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
+{
+	ulong cr0_guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
+
+	vcpu->arch.cr0 &= ~cr0_guest_owned_bits;
+	vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & cr0_guest_owned_bits;
+}
+
 static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
 	ulong cr4_guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
@@ -4106,6 +4114,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_segment = vmx_set_segment,
 	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
+	.decache_cr0_guest_bits = vmx_decache_cr0_guest_bits,
 	.decache_cr4_guest_bits = vmx_decache_cr4_guest_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr3 = vmx_set_cr3,
-- 
1.6.5.3

