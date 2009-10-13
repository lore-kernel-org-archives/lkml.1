Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbZJMN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbZJMN4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbZJMN4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758511AbZJMN4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:56:17 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] v2: allow userspace to adjust kvmclock offset
Date: Tue, 13 Oct 2009 09:55:50 -0400
Message-Id: <1255442150-8840-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we migrate a kvm guest that uses pvclock between two hosts, we may
suffer a large skew. This is because there can be significant differences
between the monotonic clock of the hosts involved. When a new host with
a much larger monotonic time starts running the guest, the view of time
will be significantly impacted.

Situation is much worse when we do the opposite, and migrate to a host with
a smaller monotonic clock.

This new proposed ioctl will allow userspace to inform us what is the monotonic
clock value in the source host, so we can keep the time skew short, and more
importantly, never goes backwards.

[ v2: uses a struct with a padding ]

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   20 +++++++++++++++++++-
 include/linux/kvm.h             |    6 ++++++
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 179a919..c9b0d9f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -410,6 +410,7 @@ struct kvm_arch{
 
 	unsigned long irq_sources_bitmap;
 	u64 vm_init_tsc;
+	s64 kvmclock_offset;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9601bc6..1b6c193 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -699,7 +699,8 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	/* With all the info we got, fill in the values */
 
 	vcpu->hv_clock.system_time = ts.tv_nsec +
-				     (NSEC_PER_SEC * (u64)ts.tv_sec);
+				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
+
 	/*
 	 * The interface expects us to write an even number signaling that the
 	 * update is finished. Since the guest won't see the intermediate
@@ -2441,6 +2442,23 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_ADJUST_CLOCK: {
+		struct timespec now;
+		struct kvm_adjust_clock user_ns;
+		u64 now_ns;
+		long delta;
+
+		r =  -EFAULT;
+		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
+			goto out;
+
+		r = 0;
+		ktime_get_ts(&now);
+		now_ns = timespec_to_ns(&now);
+		delta = user_ns.clock - now_ns;
+		kvm->arch.kvmclock_offset = delta;
+		break;	
+	}
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f8f8900..c07fc23 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -497,6 +497,11 @@ struct kvm_irqfd {
 	__u8  pad[20];
 };
 
+struct kvm_adjust_clock {
+	__u64 clock;
+	__u64 pad[2];
+};
+
 /*
  * ioctls for VM fds
  */
@@ -546,6 +551,7 @@ struct kvm_irqfd {
 #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
 #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
 #define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
+#define KVM_ADJUST_CLOCK	  _IOW(KVMIO, 0x7a, struct kvm_adjust_clock)
 
 /*
  * ioctls for vcpu fds
-- 
1.6.2.2

