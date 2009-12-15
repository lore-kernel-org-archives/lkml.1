Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbZLOEIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbZLOEIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbZLOEIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:08:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538AbZLOEHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:35 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 18/20] Implement variable speed TSC
Date: Mon, 14 Dec 2009 18:08:45 -1000
Message-Id: <1260850127-9766-19-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-18-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
 <1260850127-9766-10-git-send-email-zamsden@redhat.com>
 <1260850127-9766-11-git-send-email-zamsden@redhat.com>
 <1260850127-9766-12-git-send-email-zamsden@redhat.com>
 <1260850127-9766-13-git-send-email-zamsden@redhat.com>
 <1260850127-9766-14-git-send-email-zamsden@redhat.com>
 <1260850127-9766-15-git-send-email-zamsden@redhat.com>
 <1260850127-9766-16-git-send-email-zamsden@redhat.com>
 <1260850127-9766-17-git-send-email-zamsden@redhat.com>
 <1260850127-9766-18-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ioctl's to get and set TSC rate per-VM.  The TSC rate is set at
creation to the reference tsc rate.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 +++
 arch/x86/kvm/kvm_timer.h        |   14 +---------
 arch/x86/kvm/x86.c              |   49 +++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h             |    3 ++
 4 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8e4d606..313befc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -276,6 +276,7 @@ struct kvm_mmu {
 struct kvm_vcpu_arch {
 	u64 host_tsc;
 	u64 tsc_msr_offset;
+
 	/*
 	 * rip and regs accesses must go through
 	 * kvm_{register,rip}_{read,write} functions.
@@ -417,6 +418,9 @@ struct kvm_arch{
 	unsigned long irq_sources_bitmap;
 	u64 vm_init_tsc;
 	s64 kvmclock_offset;
+	unsigned int tsc_khz;
+	unsigned long tsc_multiplier;
+	int tsc_shift;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 };
diff --git a/arch/x86/kvm/kvm_timer.h b/arch/x86/kvm/kvm_timer.h
index 3863161..670be31 100644
--- a/arch/x86/kvm/kvm_timer.h
+++ b/arch/x86/kvm/kvm_timer.h
@@ -23,15 +23,5 @@ static inline u64 kvm_get_elapsed_tsc(struct kvm *kvm)
 	return kvm_get_ref_tsc() - kvm->arch.vm_init_tsc;
 }
 
-static inline u64 kvm_get_cpu_tsc(struct kvm_vcpu *vcpu)
-{
-	return kvm_get_elapsed_tsc(vcpu->kvm) + vcpu->arch.tsc_msr_offset;
-}
-
-static inline void kvm_set_cpu_tsc(struct kvm_vcpu *vcpu, u64 data)
-{
-	u64 tsc_offset;
-
-	tsc_offset = data - kvm_get_cpu_tsc(vcpu);
-	vcpu->arch.tsc_msr_offset = tsc_offset;
-}
+extern u64 kvm_get_cpu_tsc(struct kvm_vcpu *vcpu);
+extern void kvm_set_cpu_tsc(struct kvm_vcpu *vcpu, u64 data);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3a854ec..c1bed03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1727,6 +1727,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
 	case KVM_CAP_XEN_HVM:
 	case KVM_CAP_ADJUST_CLOCK:
+	case KVM_CAP_SET_TSC_RATE:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2680,6 +2681,34 @@ out:
 	return r;
 }
 
+u64 kvm_get_cpu_tsc(struct kvm_vcpu *vcpu)
+{
+	u64 tsc;
+	struct kvm *kvm = vcpu->kvm;
+
+	tsc = kvm_get_elapsed_tsc(kvm) + vcpu->arch.tsc_msr_offset;
+	tsc = mult_precise(tsc, kvm->arch.tsc_multiplier, kvm->arch.tsc_shift);
+	return tsc;
+}
+EXPORT_SYMBOL_GPL(kvm_get_cpu_tsc);
+
+void kvm_set_cpu_tsc(struct kvm_vcpu *vcpu, u64 data)
+{
+	u64 tsc_offset;
+
+	tsc_offset = data - kvm_get_cpu_tsc(vcpu);
+	vcpu->arch.tsc_msr_offset = tsc_offset;
+}
+EXPORT_SYMBOL_GPL(kvm_set_cpu_tsc);
+
+static int kvm_set_tsc_rate(struct kvm *kvm, u32 new_tsc_khz)
+{
+	kvm->arch.tsc_khz = new_tsc_khz;
+	compute_best_multiplier(new_tsc_khz, ref_tsc_khz,
+		&kvm->arch.tsc_multiplier, &kvm->arch.tsc_shift);
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -2986,6 +3015,25 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		break;
 	}
+	case KVM_X86_GET_TSC_RATE: {
+		u32 rate = kvm->arch.tsc_khz;
+		r = -EFAULT;
+		if (copy_to_user(argp, &rate, sizeof(rate)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_X86_SET_TSC_RATE: {
+		u32 tsc_rate;
+		r = -EFAULT;
+		if (copy_from_user(&tsc_rate, argp, sizeof tsc_rate))
+			goto out;
+		r = -EINVAL;
+		if (tsc_rate == 0 || tsc_rate > (1ULL << 30))
+			goto out;
+		r = kvm_set_tsc_rate(kvm, tsc_rate);
+		break;
+	}
 
 	default:
 		;
@@ -5611,6 +5659,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
 	kvm->arch.vm_init_tsc = kvm_get_ref_tsc();
+	kvm_set_tsc_rate(kvm, ref_tsc_khz);
 
 	return kvm;
 }
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6ed1a12..ac2f0af 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -440,6 +440,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_XEN_HVM 38
 #endif
 #define KVM_CAP_ADJUST_CLOCK 39
+#define KVM_CAP_SET_TSC_RATE 40
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -619,6 +620,8 @@ struct kvm_clock_data {
 #define KVM_X86_SETUP_MCE         _IOW(KVMIO,  0x9c, __u64)
 #define KVM_X86_GET_MCE_CAP_SUPPORTED _IOR(KVMIO,  0x9d, __u64)
 #define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9e, struct kvm_x86_mce)
+#define KVM_X86_GET_TSC_RATE      _IOR(KVMIO,  0x9f, __u64)
+#define KVM_X86_SET_TSC_RATE      _IOW(KVMIO,  0xa0, __u64)
 
 /*
  * Deprecated interfaces
-- 
1.6.5.2

