Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbXLZLRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbXLZLRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXLZLGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:50491 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbXLZLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 34/55] KVM: Portability: Move x86 FPU handling to x86.c
Date: Wed, 26 Dec 2007 13:05:39 +0200
Message-Id: <1198667160-22953-35-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +
 drivers/kvm/kvm_main.c |  107 +-----------------------------------------------
 drivers/kvm/x86.c      |  103 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 105 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ef2a6a8..469ca42 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -633,6 +633,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
+
 __init void kvm_arch_init(void);
 
 static inline void kvm_guest_enter(void)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a779d42..4620885 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -73,28 +73,6 @@ static inline int valid_vcpu(int n)
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
 }
 
-void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->fpu_active || vcpu->guest_fpu_loaded)
-		return;
-
-	vcpu->guest_fpu_loaded = 1;
-	fx_save(&vcpu->host_fx_image);
-	fx_restore(&vcpu->guest_fx_image);
-}
-EXPORT_SYMBOL_GPL(kvm_load_guest_fpu);
-
-void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->guest_fpu_loaded)
-		return;
-
-	vcpu->guest_fpu_loaded = 0;
-	fx_save(&vcpu->guest_fx_image);
-	fx_restore(&vcpu->host_fx_image);
-}
-EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
-
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
@@ -294,26 +272,6 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-void fx_init(struct kvm_vcpu *vcpu)
-{
-	unsigned after_mxcsr_mask;
-
-	/* Initialize guest FPU by resetting ours and saving into guest's */
-	preempt_disable();
-	fx_save(&vcpu->host_fx_image);
-	fpu_init();
-	fx_save(&vcpu->guest_fx_image);
-	fx_restore(&vcpu->host_fx_image);
-	preempt_enable();
-
-	vcpu->cr0 |= X86_CR0_ET;
-	after_mxcsr_mask = offsetof(struct i387_fxsave_struct, st_space);
-	vcpu->guest_fx_image.mxcsr = 0x1f80;
-	memset((void *)&vcpu->guest_fx_image + after_mxcsr_mask,
-	       0, sizeof(struct i387_fxsave_struct) - after_mxcsr_mask);
-}
-EXPORT_SYMBOL_GPL(fx_init);
-
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1422,67 +1380,6 @@ static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
 	return 0;
 }
 
-/*
- * fxsave fpu state.  Taken from x86_64/processor.h.  To be killed when
- * we have asm/x86/processor.h
- */
-struct fxsave {
-	u16	cwd;
-	u16	swd;
-	u16	twd;
-	u16	fop;
-	u64	rip;
-	u64	rdp;
-	u32	mxcsr;
-	u32	mxcsr_mask;
-	u32	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
-#ifdef CONFIG_X86_64
-	u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg = 256 bytes */
-#else
-	u32	xmm_space[32];	/* 8*16 bytes for each XMM-reg = 128 bytes */
-#endif
-};
-
-static int kvm_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-{
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
-
-	vcpu_load(vcpu);
-
-	memcpy(fpu->fpr, fxsave->st_space, 128);
-	fpu->fcw = fxsave->cwd;
-	fpu->fsw = fxsave->swd;
-	fpu->ftwx = fxsave->twd;
-	fpu->last_opcode = fxsave->fop;
-	fpu->last_ip = fxsave->rip;
-	fpu->last_dp = fxsave->rdp;
-	memcpy(fpu->xmm, fxsave->xmm_space, sizeof fxsave->xmm_space);
-
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
-static int kvm_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-{
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
-
-	vcpu_load(vcpu);
-
-	memcpy(fxsave->st_space, fpu->fpr, 128);
-	fxsave->cwd = fpu->fcw;
-	fxsave->swd = fpu->fsw;
-	fxsave->twd = fpu->ftwx;
-	fxsave->fop = fpu->last_opcode;
-	fxsave->rip = fpu->last_ip;
-	fxsave->rdp = fpu->last_dp;
-	memcpy(fxsave->xmm_space, fpu->xmm, sizeof fxsave->xmm_space);
-
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -1613,7 +1510,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		struct kvm_fpu fpu;
 
 		memset(&fpu, 0, sizeof fpu);
-		r = kvm_vcpu_ioctl_get_fpu(vcpu, &fpu);
+		r = kvm_arch_vcpu_ioctl_get_fpu(vcpu, &fpu);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -1628,7 +1525,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&fpu, argp, sizeof fpu))
 			goto out;
-		r = kvm_vcpu_ioctl_set_fpu(vcpu, &fpu);
+		r = kvm_arch_vcpu_ioctl_set_fpu(vcpu, &fpu);
 		if (r)
 			goto out;
 		r = 0;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 2cf7eba..ef1661f 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1785,3 +1785,106 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
+
+/*
+ * fxsave fpu state.  Taken from x86_64/processor.h.  To be killed when
+ * we have asm/x86/processor.h
+ */
+struct fxsave {
+	u16	cwd;
+	u16	swd;
+	u16	twd;
+	u16	fop;
+	u64	rip;
+	u64	rdp;
+	u32	mxcsr;
+	u32	mxcsr_mask;
+	u32	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
+#ifdef CONFIG_X86_64
+	u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg = 256 bytes */
+#else
+	u32	xmm_space[32];	/* 8*16 bytes for each XMM-reg = 128 bytes */
+#endif
+};
+
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
+
+	vcpu_load(vcpu);
+
+	memcpy(fpu->fpr, fxsave->st_space, 128);
+	fpu->fcw = fxsave->cwd;
+	fpu->fsw = fxsave->swd;
+	fpu->ftwx = fxsave->twd;
+	fpu->last_opcode = fxsave->fop;
+	fpu->last_ip = fxsave->rip;
+	fpu->last_dp = fxsave->rdp;
+	memcpy(fpu->xmm, fxsave->xmm_space, sizeof fxsave->xmm_space);
+
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
+
+	vcpu_load(vcpu);
+
+	memcpy(fxsave->st_space, fpu->fpr, 128);
+	fxsave->cwd = fpu->fcw;
+	fxsave->swd = fpu->fsw;
+	fxsave->twd = fpu->ftwx;
+	fxsave->fop = fpu->last_opcode;
+	fxsave->rip = fpu->last_ip;
+	fxsave->rdp = fpu->last_dp;
+	memcpy(fxsave->xmm_space, fpu->xmm, sizeof fxsave->xmm_space);
+
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+void fx_init(struct kvm_vcpu *vcpu)
+{
+	unsigned after_mxcsr_mask;
+
+	/* Initialize guest FPU by resetting ours and saving into guest's */
+	preempt_disable();
+	fx_save(&vcpu->host_fx_image);
+	fpu_init();
+	fx_save(&vcpu->guest_fx_image);
+	fx_restore(&vcpu->host_fx_image);
+	preempt_enable();
+
+	vcpu->cr0 |= X86_CR0_ET;
+	after_mxcsr_mask = offsetof(struct i387_fxsave_struct, st_space);
+	vcpu->guest_fx_image.mxcsr = 0x1f80;
+	memset((void *)&vcpu->guest_fx_image + after_mxcsr_mask,
+	       0, sizeof(struct i387_fxsave_struct) - after_mxcsr_mask);
+}
+EXPORT_SYMBOL_GPL(fx_init);
+
+void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->fpu_active || vcpu->guest_fpu_loaded)
+		return;
+
+	vcpu->guest_fpu_loaded = 1;
+	fx_save(&vcpu->host_fx_image);
+	fx_restore(&vcpu->guest_fx_image);
+}
+EXPORT_SYMBOL_GPL(kvm_load_guest_fpu);
+
+void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->guest_fpu_loaded)
+		return;
+
+	vcpu->guest_fpu_loaded = 0;
+	fx_save(&vcpu->guest_fx_image);
+	fx_restore(&vcpu->host_fx_image);
+}
+EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
-- 
1.5.3.7

