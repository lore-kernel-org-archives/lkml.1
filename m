Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZKSNlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZKSNlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZKSNjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 15/35] KVM: allow userspace to adjust kvmclock offset
Date: Thu, 19 Nov 2009 15:34:51 +0200
Message-Id: <1258637711-11674-16-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@redhat.com>

When we migrate a kvm guest that uses pvclock between two hosts, we may
suffer a large skew. This is because there can be significant differences
between the monotonic clock of the hosts involved. When a new host with
a much larger monotonic time starts running the guest, the view of time
will be significantly impacted.

Situation is much worse when we do the opposite, and migrate to a host with
a smaller monotonic clock.

This proposed ioctl will allow userspace to inform us what is the monotonic
clock value in the source host, so we can keep the time skew short, and
more importantly, never goes backwards. Userspace may also need to trigger
the current data, since from the first migration onwards, it won't be
reflected by a simple call to clock_gettime() anymore.

[marcelo: future-proof abi with a flags field]
[jan: fix KVM_GET_CLOCK by clearing flags field instead of checking it]

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 Documentation/kvm/api.txt       |   36 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   42 ++++++++++++++++++++++++++++++++++++++-
 include/linux/kvm.h             |   10 +++++++++
 4 files changed, 88 insertions(+), 1 deletions(-)

diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
index 3e8684e..36594ba 100644
--- a/Documentation/kvm/api.txt
+++ b/Documentation/kvm/api.txt
@@ -617,6 +617,42 @@ struct kvm_xen_hvm_config {
 	__u8 pad2[30];
 };
 
+4.27 KVM_GET_CLOCK
+
+Capability: KVM_CAP_ADJUST_CLOCK
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_clock_data (out)
+Returns: 0 on success, -1 on error
+
+Gets the current timestamp of kvmclock as seen by the current guest. In
+conjunction with KVM_SET_CLOCK, it is used to ensure monotonicity on scenarios
+such as migration.
+
+struct kvm_clock_data {
+	__u64 clock;  /* kvmclock current value */
+	__u32 flags;
+	__u32 pad[9];
+};
+
+4.28 KVM_SET_CLOCK
+
+Capability: KVM_CAP_ADJUST_CLOCK
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_clock_data (in)
+Returns: 0 on success, -1 on error
+
+Sets the current timestamp of kvmclock to the valued specific in its parameter.
+In conjunction with KVM_GET_CLOCK, it is used to ensure monotonicity on scenarios
+such as migration.
+
+struct kvm_clock_data {
+	__u64 clock;  /* kvmclock current value */
+	__u32 flags;
+	__u32 pad[9];
+};
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d994ad..0558ff8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -413,6 +413,7 @@ struct kvm_arch{
 
 	unsigned long irq_sources_bitmap;
 	u64 vm_init_tsc;
+	s64 kvmclock_offset;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13f30aa..e16cdc9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -680,7 +680,8 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	/* With all the info we got, fill in the values */
 
 	vcpu->hv_clock.system_time = ts.tv_nsec +
-				     (NSEC_PER_SEC * (u64)ts.tv_sec);
+				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
+
 	/*
 	 * The interface expects us to write an even number signaling that the
 	 * update is finished. Since the guest won't see the intermediate
@@ -1262,6 +1263,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_PIT_STATE2:
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
 	case KVM_CAP_XEN_HVM:
+	case KVM_CAP_ADJUST_CLOCK:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2468,6 +2470,44 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_SET_CLOCK: {
+		struct timespec now;
+		struct kvm_clock_data user_ns;
+		u64 now_ns;
+		s64 delta;
+
+		r = -EFAULT;
+		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
+			goto out;
+
+		r = -EINVAL;
+		if (user_ns.flags)
+			goto out;
+
+		r = 0;
+		ktime_get_ts(&now);
+		now_ns = timespec_to_ns(&now);
+		delta = user_ns.clock - now_ns;
+		kvm->arch.kvmclock_offset = delta;
+		break;
+	}
+	case KVM_GET_CLOCK: {
+		struct timespec now;
+		struct kvm_clock_data user_ns;
+		u64 now_ns;
+
+		ktime_get_ts(&now);
+		now_ns = timespec_to_ns(&now);
+		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
+		user_ns.flags = 0;
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
+			goto out;
+		r = 0;
+		break;
+	}
+
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index b694c1d..6ed1a12 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -439,6 +439,7 @@ struct kvm_ioeventfd {
 #ifdef __KVM_HAVE_XEN_HVM
 #define KVM_CAP_XEN_HVM 38
 #endif
+#define KVM_CAP_ADJUST_CLOCK 39
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -512,6 +513,12 @@ struct kvm_irqfd {
 	__u8  pad[20];
 };
 
+struct kvm_clock_data {
+	__u64 clock;
+	__u32 flags;
+	__u32 pad[9];
+};
+
 /*
  * ioctls for VM fds
  */
@@ -562,6 +569,9 @@ struct kvm_irqfd {
 #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
 #define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
 #define KVM_XEN_HVM_CONFIG        _IOW(KVMIO, 0x7a, struct kvm_xen_hvm_config)
+#define KVM_SET_CLOCK             _IOW(KVMIO, 0x7b, struct kvm_clock_data)
+#define KVM_GET_CLOCK             _IOR(KVMIO, 0x7c, struct kvm_clock_data)
+
 
 /*
  * ioctls for vcpu fds
-- 
1.6.5.2

