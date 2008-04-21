Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYDUKfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYDUKfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYDUKaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:21 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37944
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbYDUKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:06 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 13/31] KVM: add ioctls to save/store mpstate
Date: Mon, 21 Apr 2008 13:29:39 +0300
Message-Id: <1208773797-7829-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

So userspace can save/restore the mpstate during migration.

[avi: export the #define constants describing the value]
[christian: add s390 stubs]
[avi: ditto for ia64]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

KVM: ia64: provide get/set_mp_state stubs to fix compile error

Since

commit ded6fb24fb694bcc5f308a02ec504d45fbc8aaa6
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Apr 11 13:24:45 2008 -0300
    KVM: add ioctls to save/store mpstate

kvm does not compile on ia64.
This patch provides ioctl stubs for ia64 to make kvm.git compile again.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm-ia64.c   |   12 ++++++++++++
 arch/s390/kvm/kvm-s390.c   |   12 ++++++++++++
 arch/x86/kvm/x86.c         |   19 +++++++++++++++++++
 include/asm-x86/kvm_host.h |    5 -----
 include/linux/kvm.h        |   15 +++++++++++++++
 include/linux/kvm_host.h   |    4 ++++
 virt/kvm/kvm_main.c        |   24 ++++++++++++++++++++++++
 7 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index f7589db..6df0732 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1792,3 +1792,15 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE;
 }
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL;
+}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d966137..98d1e73 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -414,6 +414,18 @@ int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
 	return -EINVAL; /* not implemented yet */
 }
 
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL; /* not implemented yet */
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL; /* not implemented yet */
+}
+
 static void __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	memcpy(&vcpu->arch.sie_block->gg14, &vcpu->arch.guest_gprs[14], 16);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b364d19..5c3c9d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -817,6 +817,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_CLOCKSOURCE:
 	case KVM_CAP_PIT:
 	case KVM_CAP_NOP_IO_DELAY:
+	case KVM_CAP_MP_STATE:
 		r = 1;
 		break;
 	case KVM_CAP_VAPIC:
@@ -3083,6 +3084,24 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	vcpu_load(vcpu);
+	mp_state->mp_state = vcpu->arch.mp_state;
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	vcpu_load(vcpu);
+	vcpu->arch.mp_state = mp_state->mp_state;
+	vcpu_put(vcpu);
+	return 0;
+}
+
 static void set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index f35a6ad..9d963cd 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -227,11 +227,6 @@ struct kvm_vcpu_arch {
 	u64 shadow_efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
-#define KVM_MP_STATE_RUNNABLE          0
-#define KVM_MP_STATE_UNINITIALIZED     1
-#define KVM_MP_STATE_INIT_RECEIVED     2
-#define KVM_MP_STATE_SIPI_RECEIVED     3
-#define KVM_MP_STATE_HALTED            4
 	int mp_state;
 	int sipi_vector;
 	u64 ia32_misc_enable_msr;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d302d63..f8e211d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -228,6 +228,18 @@ struct kvm_vapic_addr {
 	__u64 vapic_addr;
 };
 
+/* for KVM_SET_MPSTATE */
+
+#define KVM_MP_STATE_RUNNABLE          0
+#define KVM_MP_STATE_UNINITIALIZED     1
+#define KVM_MP_STATE_INIT_RECEIVED     2
+#define KVM_MP_STATE_HALTED            3
+#define KVM_MP_STATE_SIPI_RECEIVED     4
+
+struct kvm_mp_state {
+	__u32 mp_state;
+};
+
 struct kvm_s390_psw {
 	__u64 mask;
 	__u64 addr;
@@ -326,6 +338,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_PIT 11
 #define KVM_CAP_NOP_IO_DELAY 12
 #define KVM_CAP_PV_MMU 13
+#define KVM_CAP_MP_STATE 14
 
 /*
  * ioctls for VM fds
@@ -387,5 +400,7 @@ struct kvm_trace_rec {
 #define KVM_S390_SET_INITIAL_PSW  _IOW(KVMIO,  0x96, struct kvm_s390_psw)
 /* initial reset for s390 */
 #define KVM_S390_INITIAL_RESET    _IO(KVMIO,  0x97)
+#define KVM_GET_MP_STATE          _IOR(KVMIO,  0x98, struct kvm_mp_state)
+#define KVM_SET_MP_STATE          _IOW(KVMIO,  0x99, struct kvm_mp_state)
 
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0bc4003..81d4c33 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -237,6 +237,10 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state);
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state);
 int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
 				    struct kvm_debug_guest *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 47cbc6e..0998455 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -979,6 +979,30 @@ out_free2:
 		r = 0;
 		break;
 	}
+	case KVM_GET_MP_STATE: {
+		struct kvm_mp_state mp_state;
+
+		r = kvm_arch_vcpu_ioctl_get_mpstate(vcpu, &mp_state);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &mp_state, sizeof mp_state))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_MP_STATE: {
+		struct kvm_mp_state mp_state;
+
+		r = -EFAULT;
+		if (copy_from_user(&mp_state, argp, sizeof mp_state))
+			goto out;
+		r = kvm_arch_vcpu_ioctl_set_mpstate(vcpu, &mp_state);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	case KVM_TRANSLATE: {
 		struct kvm_translation tr;
 
-- 
1.5.5

