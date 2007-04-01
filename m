Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbXDAOiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbXDAOiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbXDAOgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:36:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:47548 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331AbXDAOfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 40/41] KVM: Add fpu get/set operations
Date: Sun,  1 Apr 2007 17:35:37 +0300
Message-Id: <11754381393751-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381393962-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com> <1175438139249-git-send-email-avi@qumranet.com> <11754381391161-git-send-email-avi@qumranet.com> <11754381393714-git-send-email-avi@qumranet.com> <11754381392948-git-send-email-avi@qumranet.com> <1175438139458-git-send-email-avi@qumranet.com> <117543813933-git-send-email-avi@qumranet.com> <11754381393962-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are really helpful when migrating an floating point app to another
machine.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h    |   17 +++++++++
 2 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 56ddbc1..4473174 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2389,6 +2389,67 @@ static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
 	return 0;
 }
 
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
+static int kvm_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	struct fxsave *fxsave = (struct fxsave *)vcpu->guest_fx_image;
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
+static int kvm_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	struct fxsave *fxsave = (struct fxsave *)vcpu->guest_fx_image;
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
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -2533,6 +2594,31 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
 		break;
 	}
+	case KVM_GET_FPU: {
+		struct kvm_fpu fpu;
+
+		memset(&fpu, 0, sizeof fpu);
+		r = kvm_vcpu_ioctl_get_fpu(vcpu, &fpu);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &fpu, sizeof fpu))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_FPU: {
+		struct kvm_fpu fpu;
+
+		r = -EFAULT;
+		if (copy_from_user(&fpu, argp, sizeof fpu))
+			goto out;
+		r = kvm_vcpu_ioctl_set_fpu(vcpu, &fpu);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index da9b23f..07bf353 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -126,6 +126,21 @@ struct kvm_regs {
 	__u64 rip, rflags;
 };
 
+/* for KVM_GET_FPU and KVM_SET_FPU */
+struct kvm_fpu {
+	__u8  fpr[8][16];
+	__u16 fcw;
+	__u16 fsw;
+	__u8  ftwx;  /* in fxsave format */
+	__u8  pad1;
+	__u16 last_opcode;
+	__u64 last_ip;
+	__u64 last_dp;
+	__u8  xmm[16][16];
+	__u32 mxcsr;
+	__u32 pad2;
+};
+
 struct kvm_segment {
 	__u64 base;
 	__u32 limit;
@@ -285,5 +300,7 @@ struct kvm_signal_mask {
 #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
 #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
 #define KVM_SET_SIGNAL_MASK       _IOW(KVMIO,  0x8b, struct kvm_signal_mask)
+#define KVM_GET_FPU               _IOR(KVMIO,  0x8c, struct kvm_fpu)
+#define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
 
 #endif
-- 
1.5.0.5

