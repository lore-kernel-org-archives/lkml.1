Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbYDCToM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbYDCToM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760270AbYDCTdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:31 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53036
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 16/35] KVM: Add save/restore supporting of in kernel PIT
Date: Thu,  3 Apr 2008 22:32:31 +0300
Message-Id: <1207251170-5013-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c  |    7 +++++++
 arch/x86/kvm/i8254.h  |    1 +
 arch/x86/kvm/x86.c    |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kvm.h |   21 +++++++++++++++++++++
 include/linux/kvm.h   |    2 ++
 5 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 1031901..7776f50 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -286,6 +286,13 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 	}
 }
 
+void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val)
+{
+	mutex_lock(&kvm->arch.vpit->pit_state.lock);
+	pit_load_count(kvm, channel, val);
+	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+}
+
 static void pit_ioport_write(struct kvm_io_device *this,
 			     gpa_t addr, int len, const void *data)
 {
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 38184d5..586bbf0 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -54,6 +54,7 @@ struct kvm_pit {
 
 void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_pit_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
+void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val);
 struct kvm_pit *kvm_create_pit(struct kvm *kvm);
 void kvm_free_pit(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c33a457..621a8e3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1504,6 +1504,23 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	return r;
 }
 
+static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
+{
+	int r = 0;
+
+	memcpy(ps, &kvm->arch.vpit->pit_state, sizeof(struct kvm_pit_state));
+	return r;
+}
+
+static int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
+{
+	int r = 0;
+
+	memcpy(&kvm->arch.vpit->pit_state, ps, sizeof(struct kvm_pit_state));
+	kvm_pit_load_count(kvm, 0, ps->channels[0].count);
+	return r;
+}
+
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
@@ -1657,6 +1674,37 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_GET_PIT: {
+		struct kvm_pit_state ps;
+		r = -EFAULT;
+		if (copy_from_user(&ps, argp, sizeof ps))
+			goto out;
+		r = -ENXIO;
+		if (!kvm->arch.vpit)
+			goto out;
+		r = kvm_vm_ioctl_get_pit(kvm, &ps);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &ps, sizeof ps))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_PIT: {
+		struct kvm_pit_state ps;
+		r = -EFAULT;
+		if (copy_from_user(&ps, argp, sizeof ps))
+			goto out;
+		r = -ENXIO;
+		if (!kvm->arch.vpit)
+			goto out;
+		r = kvm_vm_ioctl_set_pit(kvm, &ps);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 7a71120..12b4b25 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -188,4 +188,25 @@ struct kvm_cpuid2 {
 	struct kvm_cpuid_entry2 entries[0];
 };
 
+/* for KVM_GET_PIT and KVM_SET_PIT */
+struct kvm_pit_channel_state {
+	__u32 count; /* can be 65536 */
+	__u16 latched_count;
+	__u8 count_latched;
+	__u8 status_latched;
+	__u8 status;
+	__u8 read_state;
+	__u8 write_state;
+	__u8 write_latch;
+	__u8 rw_mode;
+	__u8 mode;
+	__u8 bcd;
+	__u8 gate;
+	__s64 count_load_time;
+};
+
+struct kvm_pit_state {
+	struct kvm_pit_channel_state channels[3];
+};
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index cefa9a2..a2f3274 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -260,6 +260,8 @@ struct kvm_vapic_addr {
 #define KVM_GET_IRQCHIP		  _IOWR(KVMIO, 0x62, struct kvm_irqchip)
 #define KVM_SET_IRQCHIP		  _IOR(KVMIO,  0x63, struct kvm_irqchip)
 #define KVM_CREATE_PIT		  _IO(KVMIO,  0x64)
+#define KVM_GET_PIT		  _IOWR(KVMIO, 0x65, struct kvm_pit_state)
+#define KVM_SET_PIT		  _IOR(KVMIO,  0x66, struct kvm_pit_state)
 
 /*
  * ioctls for vcpu fds
-- 
1.5.4.5

