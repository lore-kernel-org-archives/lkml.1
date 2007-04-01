Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXDAOuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXDAOuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXDAOtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:49:03 -0400
Received: from il.qumranet.com ([82.166.9.18]:47549 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133AbXDAOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/41] KVM: Handle cpuid in the kernel instead of punting to userspace
Date: Sun,  1 Apr 2007 17:35:05 +0300
Message-Id: <1175438139242-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381381597-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KVM used to handle cpuid by letting userspace decide what values to
return to the guest.  We now handle cpuid completely in the kernel.  We
still let userspace decide which values the guest will see by having
userspace set up the value table beforehand (this is necessary to allow
management software to set the cpu features to the least common denominator,
so that live migration can work).

The motivation for the change is that kvm kernel code can be impacted by
cpuid features, for example the x86 emulator.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    5 +++
 drivers/kvm/kvm_main.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/svm.c      |    4 +-
 drivers/kvm/vmx.c      |    4 +-
 include/linux/kvm.h    |   18 ++++++++++++-
 5 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 59cbc5b..be3a0e7 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -55,6 +55,7 @@
 #define KVM_NUM_MMU_PAGES 256
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
+#define KVM_MAX_CPUID_ENTRIES 40
 
 #define FX_IMAGE_SIZE 512
 #define FX_IMAGE_ALIGN 16
@@ -286,6 +287,9 @@ struct kvm_vcpu {
 			u32 ar;
 		} tr, es, ds, fs, gs;
 	} rmode;
+
+	int cpuid_nent;
+	struct kvm_cpuid_entry cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 };
 
 struct kvm_memory_slot {
@@ -446,6 +450,7 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
 
 struct x86_emulate_ctxt;
 
+void kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address);
 int emulate_clts(struct kvm_vcpu *vcpu);
 int emulator_get_dr(struct x86_emulate_ctxt* ctxt, int dr,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ff8bcfe..caec54f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1504,6 +1504,43 @@ void save_msrs(struct vmx_msr_entry *e, int n)
 }
 EXPORT_SYMBOL_GPL(save_msrs);
 
+void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	int i;
+	u32 function;
+	struct kvm_cpuid_entry *e, *best;
+
+	kvm_arch_ops->cache_regs(vcpu);
+	function = vcpu->regs[VCPU_REGS_RAX];
+	vcpu->regs[VCPU_REGS_RAX] = 0;
+	vcpu->regs[VCPU_REGS_RBX] = 0;
+	vcpu->regs[VCPU_REGS_RCX] = 0;
+	vcpu->regs[VCPU_REGS_RDX] = 0;
+	best = NULL;
+	for (i = 0; i < vcpu->cpuid_nent; ++i) {
+		e = &vcpu->cpuid_entries[i];
+		if (e->function == function) {
+			best = e;
+			break;
+		}
+		/*
+		 * Both basic or both extended?
+		 */
+		if (((e->function ^ function) & 0x80000000) == 0)
+			if (!best || e->function > best->function)
+				best = e;
+	}
+	if (best) {
+		vcpu->regs[VCPU_REGS_RAX] = best->eax;
+		vcpu->regs[VCPU_REGS_RBX] = best->ebx;
+		vcpu->regs[VCPU_REGS_RCX] = best->ecx;
+		vcpu->regs[VCPU_REGS_RDX] = best->edx;
+	}
+	kvm_arch_ops->decache_regs(vcpu);
+	kvm_arch_ops->skip_emulated_instruction(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
+
 static void complete_pio(struct kvm_vcpu *vcpu)
 {
 	struct kvm_io *io = &vcpu->run->io;
@@ -2075,6 +2112,26 @@ out:
 	return r;
 }
 
+static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
+				    struct kvm_cpuid *cpuid,
+				    struct kvm_cpuid_entry __user *entries)
+{
+	int r;
+
+	r = -E2BIG;
+	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
+		goto out;
+	r = -EFAULT;
+	if (copy_from_user(&vcpu->cpuid_entries, entries,
+			   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
+		goto out;
+	vcpu->cpuid_nent = cpuid->nent;
+	return 0;
+
+out:
+	return r;
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -2181,6 +2238,18 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	case KVM_SET_MSRS:
 		r = msr_io(vcpu, argp, do_set_msr, 0);
 		break;
+	case KVM_SET_CPUID: {
+		struct kvm_cpuid __user *cpuid_arg = argp;
+		struct kvm_cpuid cpuid;
+
+		r = -EFAULT;
+		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
+			goto out;
+		r = kvm_vcpu_ioctl_set_cpuid(vcpu, &cpuid, cpuid_arg->entries);
+		if (r)
+			goto out;
+		break;
+	}
 	default:
 		;
 	}
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index c35b8c8..d4b2936 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1101,8 +1101,8 @@ static int task_switch_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_r
 static int cpuid_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 2;
-	kvm_run->exit_reason = KVM_EXIT_CPUID;
-	return 0;
+	kvm_emulate_cpuid(vcpu);
+	return 1;
 }
 
 static int emulate_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 4d5f40f..71410a6 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1585,8 +1585,8 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_cpuid(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	kvm_run->exit_reason = KVM_EXIT_CPUID;
-	return 0;
+	kvm_emulate_cpuid(vcpu);
+	return 1;
 }
 
 static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 19aeb33..15e23bc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -41,7 +41,6 @@ enum kvm_exit_reason {
 	KVM_EXIT_UNKNOWN          = 0,
 	KVM_EXIT_EXCEPTION        = 1,
 	KVM_EXIT_IO               = 2,
-	KVM_EXIT_CPUID            = 3,
 	KVM_EXIT_DEBUG            = 4,
 	KVM_EXIT_HLT              = 5,
 	KVM_EXIT_MMIO             = 6,
@@ -210,6 +209,22 @@ struct kvm_dirty_log {
 	};
 };
 
+struct kvm_cpuid_entry {
+	__u32 function;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+	__u32 padding;
+};
+
+/* for KVM_SET_CPUID */
+struct kvm_cpuid {
+	__u32 nent;
+	__u32 padding;
+	struct kvm_cpuid_entry entries[0];
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -243,5 +258,6 @@ struct kvm_dirty_log {
 #define KVM_DEBUG_GUEST           _IOW(KVMIO, 9, struct kvm_debug_guest)
 #define KVM_GET_MSRS              _IOWR(KVMIO, 13, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOW(KVMIO, 14, struct kvm_msrs)
+#define KVM_SET_CPUID             _IOW(KVMIO, 17, struct kvm_cpuid)
 
 #endif
-- 
1.5.0.5

