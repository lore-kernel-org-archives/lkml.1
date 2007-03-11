Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbXCKNyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbXCKNyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXCKNyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:54:25 -0400
Received: from il.qumranet.com ([82.166.9.18]:43431 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933581AbXCKNxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 13/15] KVM: Add guest mode signal mask
Date: Sun, 11 Mar 2007 15:53:25 +0200
Message-Id: <11736212083646-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a special signal mask to be used while executing in guest mode.  This
allows signals to be used to interrupt a vcpu without requiring signal
delivery to a userspace handler, which is quite expensive.  Userspace still
receives -EINTR and can get the signal via sigwait().

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h    |    7 +++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index be3a0e7..1c4a581 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -277,6 +277,9 @@ struct kvm_vcpu {
 	gpa_t mmio_phys_addr;
 	int pio_pending;
 
+	int sigset_active;
+	sigset_t sigset;
+
 	struct {
 		int active;
 		u8 save_iopl;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0e28f58..ed95c9b 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1591,9 +1591,13 @@ static void complete_pio(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
+	sigset_t sigsaved;
 
 	vcpu_load(vcpu);
 
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
+
 	/* re-sync apic's tpr */
 	vcpu->cr8 = kvm_run->cr8;
 
@@ -1616,6 +1620,9 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	r = kvm_arch_ops->run(vcpu, kvm_run);
 
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+
 	vcpu_put(vcpu);
 	return r;
 }
@@ -2142,6 +2149,17 @@ out:
 	return r;
 }
 
+static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
+{
+	if (sigset) {
+		sigdelsetmask(sigset, sigmask(SIGKILL)|sigmask(SIGSTOP));
+		vcpu->sigset_active = 1;
+		vcpu->sigset = *sigset;
+	} else
+		vcpu->sigset_active = 0;
+	return 0;
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -2260,6 +2278,29 @@ static long kvm_vcpu_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+	case KVM_SET_SIGNAL_MASK: {
+		struct kvm_signal_mask __user *sigmask_arg = argp;
+		struct kvm_signal_mask kvm_sigmask;
+		sigset_t sigset, *p;
+
+		p = NULL;
+		if (argp) {
+			r = -EFAULT;
+			if (copy_from_user(&kvm_sigmask, argp,
+					   sizeof kvm_sigmask))
+				goto out;
+			r = -EINVAL;
+			if (kvm_sigmask.len != sizeof sigset)
+				goto out;
+			r = -EFAULT;
+			if (copy_from_user(&sigset, sigmask_arg->sigset,
+					   sizeof sigset))
+				goto out;
+			p = &sigset;
+		}
+		r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
+		break;
+	}
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index b3af92e..c0d10cd 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -234,6 +234,12 @@ struct kvm_cpuid {
 	struct kvm_cpuid_entry entries[0];
 };
 
+/* for KVM_SET_SIGNAL_MASK */
+struct kvm_signal_mask {
+	__u32 len;
+	__u8  sigset[0];
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -273,5 +279,6 @@ struct kvm_cpuid {
 #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
 #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
+#define KVM_SET_SIGNAL_MASK       _IOW(KVMIO,  0x8b, struct kvm_signal_mask)
 
 #endif
-- 
1.5.0.2

