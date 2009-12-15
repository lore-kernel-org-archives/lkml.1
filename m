Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZLOEIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZLOEIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZLOEIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:08:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563AbZLOEHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:37 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 19/20] IOCTL for different TSC modes
Date: Mon, 14 Dec 2009 18:08:46 -1000
Message-Id: <1260850127-9766-20-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-19-git-send-email-zamsden@redhat.com>
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
 <1260850127-9766-19-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the previous ioctl to add a mode field specifying the
mode of TSC virtualization.

There are three modes.

1) Pure passthrough - TSC is always passed through.  Hardware offset
features are used.  Great for fixed frequency machines with VMs that
will not be migrated.

2) Pure intercept - TSC reads are always intercepted.  Great for SMP
VMs which require perfect synchronization across CPUs.

3) Hybrid mode - TSC is passed through when possible, even if the
actual CPU frequency is lower than the VM's frequency.  On exits,
the TSC offset is adjusted to keep in sync with the VM frequency.
If the hardware frequency exceeds the VM frequency, intercept mode
is used instead.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   21 ++++++++++++---------
 include/linux/kvm.h             |   17 ++++++++++++++---
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 313befc..f2cf4c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -418,6 +418,7 @@ struct kvm_arch{
 	unsigned long irq_sources_bitmap;
 	u64 vm_init_tsc;
 	s64 kvmclock_offset;
+	unsigned int tsc_mode;
 	unsigned int tsc_khz;
 	unsigned long tsc_multiplier;
 	int tsc_shift;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1bed03..f8fa978 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1727,7 +1727,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
 	case KVM_CAP_XEN_HVM:
 	case KVM_CAP_ADJUST_CLOCK:
-	case KVM_CAP_SET_TSC_RATE:
+	case KVM_CAP_SET_TSC_MODE:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -3015,23 +3015,26 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		break;
 	}
-	case KVM_X86_GET_TSC_RATE: {
-		u32 rate = kvm->arch.tsc_khz;
+	case KVM_X86_GET_TSC_MODE: {
+		struct kvm_tsc_state state;
+		state.rate = kvm->arch.tsc_khz;
+		state.mode = kvm->arch.tsc_mode;
 		r = -EFAULT;
-		if (copy_to_user(argp, &rate, sizeof(rate)))
+		if (copy_to_user(argp, &state, sizeof(state)))
 			goto out;
 		r = 0;
 		break;
 	}
-	case KVM_X86_SET_TSC_RATE: {
-		u32 tsc_rate;
+	case KVM_X86_SET_TSC_MODE: {
+		struct kvm_tsc_state state;
 		r = -EFAULT;
-		if (copy_from_user(&tsc_rate, argp, sizeof tsc_rate))
+		if (copy_from_user(&state, argp, sizeof(state)))
 			goto out;
 		r = -EINVAL;
-		if (tsc_rate == 0 || tsc_rate > (1ULL << 30))
+		if (state.rate == 0 || state.rate > (1ULL << 30) ||
+		    state.mode > KVM_TSC_MODE_HYBRID)
 			goto out;
-		r = kvm_set_tsc_rate(kvm, tsc_rate);
+		r = kvm_set_tsc_rate(kvm, state.rate);
 		break;
 	}
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ac2f0af..85ad3e0 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -440,7 +440,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_XEN_HVM 38
 #endif
 #define KVM_CAP_ADJUST_CLOCK 39
-#define KVM_CAP_SET_TSC_RATE 40
+#define KVM_CAP_SET_TSC_MODE 40
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -520,6 +520,17 @@ struct kvm_clock_data {
 	__u32 pad[9];
 };
 
+struct kvm_tsc_state {
+	__u32 rate;
+	__u32 mode;
+};
+
+enum {
+	KVM_TSC_MODE_PASSTHROUGH,
+	KVM_TSC_MODE_INTERCEPT,
+	KVM_TSC_MODE_HYBRID
+};
+
 /*
  * ioctls for VM fds
  */
@@ -620,8 +631,8 @@ struct kvm_clock_data {
 #define KVM_X86_SETUP_MCE         _IOW(KVMIO,  0x9c, __u64)
 #define KVM_X86_GET_MCE_CAP_SUPPORTED _IOR(KVMIO,  0x9d, __u64)
 #define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9e, struct kvm_x86_mce)
-#define KVM_X86_GET_TSC_RATE      _IOR(KVMIO,  0x9f, __u64)
-#define KVM_X86_SET_TSC_RATE      _IOW(KVMIO,  0xa0, __u64)
+#define KVM_X86_GET_TSC_MODE      _IOR(KVMIO,  0x9f, struct kvm_tsc_state)
+#define KVM_X86_SET_TSC_MODE      _IOW(KVMIO,  0xa0, struct kvm_tsc_state)
 
 /*
  * Deprecated interfaces
-- 
1.6.5.2

