Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbYAFOs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbYAFOs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbYAFOkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:46651 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 24/33] KVM: local APIC TPR access reporting facility
Date: Sun,  6 Jan 2008 16:39:30 +0200
Message-Id: <1199630379-28638-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a facility to report on accesses to the local apic tpr even if the
local apic is emulated in the kernel.  This is basically a hack that
allows userspace to patch Windows which tends to bang on the tpr a lot.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/lapic.c       |   21 +++++++++++++++++++++
 arch/x86/kvm/x86.c         |   25 +++++++++++++++++++++++++
 include/asm-x86/kvm_host.h |    1 +
 include/linux/kvm.h        |   17 +++++++++++++++++
 include/linux/kvm_host.h   |    2 +-
 5 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4076331..50c3f3a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -551,6 +551,23 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	return tmcct;
 }
 
+static void __report_tpr_access(struct kvm_lapic *apic, bool write)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+	struct kvm_run *run = vcpu->run;
+
+	set_bit(KVM_REQ_REPORT_TPR_ACCESS, &vcpu->requests);
+	kvm_x86_ops->cache_regs(vcpu);
+	run->tpr_access.rip = vcpu->arch.rip;
+	run->tpr_access.is_write = write;
+}
+
+static inline void report_tpr_access(struct kvm_lapic *apic, bool write)
+{
+	if (apic->vcpu->arch.tpr_access_reporting)
+		__report_tpr_access(apic, write);
+}
+
 static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
 {
 	u32 val = 0;
@@ -568,6 +585,9 @@ static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
 		val = apic_get_tmcct(apic);
 		break;
 
+	case APIC_TASKPRI:
+		report_tpr_access(apic, false);
+		/* fall thru */
 	default:
 		apic_update_ppr(apic);
 		val = apic_get_reg(apic, offset);
@@ -677,6 +697,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 		break;
 
 	case APIC_TASKPRI:
+		report_tpr_access(apic, true);
 		apic_set_tpr(apic, val & 0xff);
 		break;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 513258c..c2b8088 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -684,6 +684,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SET_TSS_ADDR:
 	case KVM_CAP_EXT_CPUID:
+	case KVM_CAP_VAPIC:
 		r = 1;
 		break;
 	default:
@@ -1055,6 +1056,15 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
+					   struct kvm_tpr_access_ctl *tac)
+{
+	if (tac->flags)
+		return -EINVAL;
+	vcpu->arch.tpr_access_reporting = !!tac->enabled;
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -1148,6 +1158,21 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_MSRS:
 		r = msr_io(vcpu, argp, do_set_msr, 0);
 		break;
+	case KVM_TPR_ACCESS_REPORTING: {
+		struct kvm_tpr_access_ctl tac;
+
+		r = -EFAULT;
+		if (copy_from_user(&tac, argp, sizeof tac))
+			goto out;
+		r = vcpu_ioctl_tpr_access_reporting(vcpu, &tac);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &tac, sizeof tac))
+			goto out;
+		r = 0;
+		break;
+	};
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index ced1beb..6e649af 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -211,6 +211,7 @@ struct kvm_vcpu_arch {
 	int mp_state;
 	int sipi_vector;
 	u64 ia32_misc_enable_msr;
+	bool tpr_access_reporting;
 
 	struct kvm_mmu mmu;
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index de9f28d..850f5ef 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -72,6 +72,7 @@ struct kvm_irqchip {
 #define KVM_EXIT_FAIL_ENTRY       9
 #define KVM_EXIT_INTR             10
 #define KVM_EXIT_SET_TPR          11
+#define KVM_EXIT_TPR_ACCESS       12
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -130,6 +131,12 @@ struct kvm_run {
 			__u32 longmode;
 			__u32 pad;
 		} hypercall;
+		/* KVM_EXIT_TPR_ACCESS */
+		struct {
+			__u64 rip;
+			__u32 is_write;
+			__u32 pad;
+		} tpr_access;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -202,6 +209,13 @@ struct kvm_signal_mask {
 	__u8  sigset[0];
 };
 
+/* for KVM_TPR_ACCESS_REPORTING */
+struct kvm_tpr_access_ctl {
+	__u32 enabled;
+	__u32 flags;
+	__u32 reserved[8];
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -229,6 +243,7 @@ struct kvm_signal_mask {
 #define KVM_CAP_USER_MEMORY 3
 #define KVM_CAP_SET_TSS_ADDR 4
 #define KVM_CAP_EXT_CPUID 5
+#define KVM_CAP_VAPIC 6
 
 /*
  * ioctls for VM fds
@@ -274,5 +289,7 @@ struct kvm_signal_mask {
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
+/* Available with KVM_CAP_VAPIC */
+#define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO,  0x92, struct kvm_tpr_access_ctl)
 
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 953b50a..9ff5904 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -35,7 +35,7 @@
  * vcpu->requests bit members
  */
 #define KVM_REQ_TLB_FLUSH          0
-
+#define KVM_REQ_REPORT_TPR_ACCESS  2
 
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
-- 
1.5.3.7

