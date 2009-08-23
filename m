Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbZHWMCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbZHWMCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933731AbZHWMCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:02:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933539AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/46] KVM: PIT support for HPET legacy mode
Date: Sun, 23 Aug 2009 14:56:18 +0300
Message-Id: <1251028605-31977-20-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beth Kon <eak@us.ibm.com>

When kvm is in hpet_legacy_mode, the hpet is providing the timer
interrupt and the pit should not be. So in legacy mode, the pit timer
is destroyed, but the *state* of the pit is maintained. So if kvm or
the guest tries to modify the state of the pit, this modification is
accepted, *except* that the timer isn't actually started. When we exit
hpet_legacy_mode, the current state of the pit (which is up to date
since we've been accepting modifications) is used to restart the pit
timer.

The saved_mode code in kvm_pit_load_count temporarily changes mode to
0xff in order to destroy the timer, but then restores the actual
value, again maintaining "current" state of the pit for possible later
reenablement.

[avi: add some reserved storage in the ioctl; make SET_PIT2 IOW]

Signed-off-by: Beth Kon <eak@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm.h |    9 +++++++
 arch/x86/kvm/i8254.c       |   22 ++++++++++++++---
 arch/x86/kvm/i8254.h       |    3 +-
 arch/x86/kvm/x86.c         |   55 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/kvm.h        |    6 ++++
 5 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index 708b9c3..4a5fe91 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -18,6 +18,7 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_MSIX
 #define __KVM_HAVE_MCE
+#define __KVM_HAVE_PIT_STATE2
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
@@ -237,6 +238,14 @@ struct kvm_pit_state {
 	struct kvm_pit_channel_state channels[3];
 };
 
+#define KVM_PIT_FLAGS_HPET_LEGACY  0x00000001
+
+struct kvm_pit_state2 {
+	struct kvm_pit_channel_state channels[3];
+	__u32 flags;
+	__u32 reserved[9];
+};
+
 struct kvm_reinject_control {
 	__u8 pit_reinject;
 	__u8 reserved[31];
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 8c3ac30..9b62c57 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -332,20 +332,33 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 	case 1:
         /* FIXME: enhance mode 4 precision */
 	case 4:
-		create_pit_timer(ps, val, 0);
+		if (!(ps->flags & KVM_PIT_FLAGS_HPET_LEGACY)) {
+			create_pit_timer(ps, val, 0);
+		}
 		break;
 	case 2:
 	case 3:
-		create_pit_timer(ps, val, 1);
+		if (!(ps->flags & KVM_PIT_FLAGS_HPET_LEGACY)){
+			create_pit_timer(ps, val, 1);
+		}
 		break;
 	default:
 		destroy_pit_timer(&ps->pit_timer);
 	}
 }
 
-void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val)
+void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val, int hpet_legacy_start)
 {
-	pit_load_count(kvm, channel, val);
+	u8 saved_mode;
+	if (hpet_legacy_start) {
+		/* save existing mode for later reenablement */
+		saved_mode = kvm->arch.vpit->pit_state.channels[0].mode;
+		kvm->arch.vpit->pit_state.channels[0].mode = 0xff; /* disable timer */
+		pit_load_count(kvm, channel, val);
+		kvm->arch.vpit->pit_state.channels[0].mode = saved_mode;
+	} else {
+		pit_load_count(kvm, channel, val);
+	}
 }
 
 static inline struct kvm_pit *dev_to_pit(struct kvm_io_device *dev)
@@ -554,6 +567,7 @@ void kvm_pit_reset(struct kvm_pit *pit)
 	struct kvm_kpit_channel_state *c;
 
 	mutex_lock(&pit->pit_state.lock);
+	pit->pit_state.flags = 0;
 	for (i = 0; i < 3; i++) {
 		c = &pit->pit_state.channels[i];
 		c->mode = 0xff;
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index b267018..d4c1c7f 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -21,6 +21,7 @@ struct kvm_kpit_channel_state {
 
 struct kvm_kpit_state {
 	struct kvm_kpit_channel_state channels[3];
+	u32 flags;
 	struct kvm_timer pit_timer;
 	bool is_periodic;
 	u32    speaker_data_on;
@@ -49,7 +50,7 @@ struct kvm_pit {
 #define KVM_PIT_CHANNEL_MASK	    0x3
 
 void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu);
-void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val);
+void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val, int hpet_legacy_start);
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags);
 void kvm_free_pit(struct kvm *kvm);
 void kvm_pit_reset(struct kvm_pit *pit);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dfb0e37..1fd67dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1213,6 +1213,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_IRQFD:
 	case KVM_CAP_PIT2:
+	case KVM_CAP_PIT_STATE2:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2078,7 +2079,32 @@ static int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 
 	mutex_lock(&kvm->arch.vpit->pit_state.lock);
 	memcpy(&kvm->arch.vpit->pit_state, ps, sizeof(struct kvm_pit_state));
-	kvm_pit_load_count(kvm, 0, ps->channels[0].count);
+	kvm_pit_load_count(kvm, 0, ps->channels[0].count, 0);
+	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+	return r;
+}
+
+static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
+{
+	int r = 0;
+
+	mutex_lock(&kvm->arch.vpit->pit_state.lock);
+	memcpy(ps, &kvm->arch.vpit->pit_state, sizeof(struct kvm_pit_state2));
+	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+	return r;
+}
+
+static int kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
+{
+	int r = 0, start = 0;
+	u32 prev_legacy, cur_legacy;
+	mutex_lock(&kvm->arch.vpit->pit_state.lock);
+	prev_legacy = kvm->arch.vpit->pit_state.flags & KVM_PIT_FLAGS_HPET_LEGACY;
+	cur_legacy = ps->flags & KVM_PIT_FLAGS_HPET_LEGACY;
+	if (!prev_legacy && cur_legacy)
+		start = 1;
+	memcpy(&kvm->arch.vpit->pit_state, ps, sizeof(struct kvm_pit_state2));
+	kvm_pit_load_count(kvm, 0, kvm->arch.vpit->pit_state.channels[0].count, start);
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 	return r;
 }
@@ -2140,6 +2166,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	 */
 	union {
 		struct kvm_pit_state ps;
+		struct kvm_pit_state2 ps2;
 		struct kvm_memory_alias alias;
 		struct kvm_pit_config pit_config;
 	} u;
@@ -2322,6 +2349,32 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_GET_PIT2: {
+		r = -ENXIO;
+		if (!kvm->arch.vpit)
+			goto out;
+		r = kvm_vm_ioctl_get_pit2(kvm, &u.ps2);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &u.ps2, sizeof(u.ps2)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_PIT2: {
+		r = -EFAULT;
+		if (copy_from_user(&u.ps2, argp, sizeof(u.ps2)))
+			goto out;
+		r = -ENXIO;
+		if (!kvm->arch.vpit)
+			goto out;
+		r = kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	case KVM_REINJECT_CONTROL: {
 		struct kvm_reinject_control control;
 		r =  -EFAULT;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 76c6408..a74a1fc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -409,6 +409,9 @@ struct kvm_guest_debug {
 #define KVM_CAP_PIT2 33
 #endif
 #define KVM_CAP_SET_BOOT_CPU_ID 34
+#ifdef __KVM_HAVE_PIT_STATE2
+#define KVM_CAP_PIT_STATE2 35
+#endif
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -586,6 +589,9 @@ struct kvm_debug_guest {
 #define KVM_IA64_VCPU_GET_STACK   _IOR(KVMIO,  0x9a, void *)
 #define KVM_IA64_VCPU_SET_STACK   _IOW(KVMIO,  0x9b, void *)
 
+#define KVM_GET_PIT2   _IOR(KVMIO,   0x9f, struct kvm_pit_state2)
+#define KVM_SET_PIT2   _IOW(KVMIO,   0xa0, struct kvm_pit_state2)
+
 #define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
 #define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
 #define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
-- 
1.6.4.1

