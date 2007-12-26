Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXLZLVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXLZLVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXLZLHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:50464 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbXLZLGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:12 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 55/55] KVM: Portability: Make kvm_vcpu_ioctl_translate arch dependent
Date: Wed, 26 Dec 2007 13:06:00 +0200
Message-Id: <1198667160-22953-56-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Move kvm_vcpu_ioctl_translate to arch, since mmu would be put under arch.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   24 +-----------------------
 drivers/kvm/x86.c      |   22 ++++++++++++++++++++++
 3 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a7be073..e34e246 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -642,6 +642,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				    struct kvm_translation *tr);
+
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9d63a10..bce4216 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -761,28 +761,6 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-/*
- * Translate a guest virtual address to a guest physical address.
- */
-static int kvm_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
-				    struct kvm_translation *tr)
-{
-	unsigned long vaddr = tr->linear_address;
-	gpa_t gpa;
-
-	vcpu_load(vcpu);
-	mutex_lock(&vcpu->kvm->lock);
-	gpa = vcpu->mmu.gva_to_gpa(vcpu, vaddr);
-	tr->physical_address = gpa;
-	tr->valid = gpa != UNMAPPED_GVA;
-	tr->writeable = 1;
-	tr->usermode = 0;
-	mutex_unlock(&vcpu->kvm->lock);
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 				    struct kvm_interrupt *irq)
 {
@@ -986,7 +964,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&tr, argp, sizeof tr))
 			goto out;
-		r = kvm_vcpu_ioctl_translate(vcpu, &tr);
+		r = kvm_arch_vcpu_ioctl_translate(vcpu, &tr);
 		if (r)
 			goto out;
 		r = -EFAULT;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 6097926..f1746af 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -2318,6 +2318,28 @@ struct fxsave {
 #endif
 };
 
+/*
+ * Translate a guest virtual address to a guest physical address.
+ */
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				    struct kvm_translation *tr)
+{
+	unsigned long vaddr = tr->linear_address;
+	gpa_t gpa;
+
+	vcpu_load(vcpu);
+	mutex_lock(&vcpu->kvm->lock);
+	gpa = vcpu->mmu.gva_to_gpa(vcpu, vaddr);
+	tr->physical_address = gpa;
+	tr->valid = gpa != UNMAPPED_GVA;
+	tr->writeable = 1;
+	tr->usermode = 0;
+	mutex_unlock(&vcpu->kvm->lock);
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
-- 
1.5.3.7

