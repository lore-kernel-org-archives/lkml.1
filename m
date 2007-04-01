Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXDAOoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXDAOoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933281AbXDAOmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:42:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:47567 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933245AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 24/41] KVM: Remove set_cr0_no_modeswitch() arch op
Date: Sun,  1 Apr 2007 17:35:21 +0300
Message-Id: <1175438139960-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139530-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

set_cr0_no_modeswitch() was a hack to avoid corrupting segment registers.
As we now cache the protected mode values on entry to real mode, this
isn't an issue anymore, and it interferes with reboot (which usually _is_
a modeswitch).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 --
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/svm.c      |    1 -
 drivers/kvm/vmx.c      |   17 -----------------
 4 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a4331da..7361c45 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -383,8 +383,6 @@ struct kvm_arch_ops {
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*decache_cr0_cr4_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
-	void (*set_cr0_no_modeswitch)(struct kvm_vcpu *vcpu,
-				      unsigned long cr0);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0c30e1b..5ada7aa 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1927,7 +1927,7 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_arch_ops->decache_cr0_cr4_guest_bits(vcpu);
 
 	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
-	kvm_arch_ops->set_cr0_no_modeswitch(vcpu, sregs->cr0);
+	kvm_arch_ops->set_cr0(vcpu, sregs->cr0);
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
 	kvm_arch_ops->set_cr4(vcpu, sregs->cr4);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 64afc5c..d3cc115 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1716,7 +1716,6 @@ static struct kvm_arch_ops svm_arch_ops = {
 	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
 	.decache_cr0_cr4_guest_bits = svm_decache_cr0_cr4_guest_bits,
 	.set_cr0 = svm_set_cr0,
-	.set_cr0_no_modeswitch = svm_set_cr0,
 	.set_cr3 = svm_set_cr3,
 	.set_cr4 = svm_set_cr4,
 	.set_efer = svm_set_efer,
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index aa7e2ba..027a962 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -788,22 +788,6 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vcpu->cr0 = cr0;
 }
 
-/*
- * Used when restoring the VM to avoid corrupting segment registers
- */
-static void vmx_set_cr0_no_modeswitch(struct kvm_vcpu *vcpu, unsigned long cr0)
-{
-	if (!vcpu->rmode.active && !(cr0 & CR0_PE_MASK))
-		enter_rmode(vcpu);
-
-	vcpu->rmode.active = ((cr0 & CR0_PE_MASK) == 0);
-	update_exception_bitmap(vcpu);
-	vmcs_writel(CR0_READ_SHADOW, cr0);
-	vmcs_writel(GUEST_CR0,
-		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
-	vcpu->cr0 = cr0;
-}
-
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	vmcs_writel(GUEST_CR3, cr3);
@@ -2069,7 +2053,6 @@ static struct kvm_arch_ops vmx_arch_ops = {
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.decache_cr0_cr4_guest_bits = vmx_decache_cr0_cr4_guest_bits,
 	.set_cr0 = vmx_set_cr0,
-	.set_cr0_no_modeswitch = vmx_set_cr0_no_modeswitch,
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
 #ifdef CONFIG_X86_64
-- 
1.5.0.5

