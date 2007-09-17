Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbXIQIqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbXIQIqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXIQIdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:04 -0400
Received: from il.qumranet.com ([82.166.9.18]:45292 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 073/104] KVM: in-kernel LAPIC save and restore support
Date: Mon, 17 Sep 2007 10:31:55 +0200
Message-Id: <1190017948774-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

This patch adds a new vcpu-based IOCTL to save and restore the local
apic registers for a single vcpu. The kernel only copies the apic page as
a whole, extraction of registers is left to userspace side. On restore, the
APIC timer is restarted from the initial count, this introduces a little
delay, but works fine.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h      |    1 +
 drivers/kvm/kvm_main.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/lapic.c    |   13 +++++++++++++
 include/linux/kvm.h    |    8 ++++++++
 4 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 30adddc..24b871f 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -149,6 +149,7 @@ int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
 int kvm_apic_set_irq(struct kvm_lapic *apic, u8 vec, u8 trig);
+void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 61dff55..a012d70 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2642,6 +2642,27 @@ static int kvm_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
+				    struct kvm_lapic_state *s)
+{
+	vcpu_load(vcpu);
+	memcpy(s->regs, vcpu->apic->regs, sizeof *s);
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
+				    struct kvm_lapic_state *s)
+{
+	vcpu_load(vcpu);
+	memcpy(vcpu->apic->regs, s->regs, sizeof *s);
+	kvm_apic_post_state_restore(vcpu);
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -2811,6 +2832,31 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_GET_LAPIC: {
+		struct kvm_lapic_state lapic;
+
+		memset(&lapic, 0, sizeof lapic);
+		r = kvm_vcpu_ioctl_get_lapic(vcpu, &lapic);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &lapic, sizeof lapic))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_LAPIC: {
+		struct kvm_lapic_state lapic;
+
+		r = -EFAULT;
+		if (copy_from_user(&lapic, argp, sizeof lapic))
+			goto out;
+		r = kvm_vcpu_ioctl_set_lapic(vcpu, &lapic);;
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 4b5c77d..df636bf 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -931,3 +931,16 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	apic_clear_irr(vector, apic);
 	return vector;
 }
+
+void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->apic;
+
+	apic->base_address = vcpu->apic_base &
+			     MSR_IA32_APICBASE_BASE;
+	apic_set_reg(apic, APIC_LVR, APIC_VERSION);
+	apic_update_ppr(apic);
+	hrtimer_cancel(&apic->timer.dev);
+	update_divide_count(apic);
+	start_apic_timer(apic);
+}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 42d1515..30a8369 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -208,6 +208,12 @@ struct kvm_fpu {
 	__u32 pad2;
 };
 
+/* for KVM_GET_LAPIC and KVM_SET_LAPIC */
+#define KVM_APIC_REG_SIZE 0x400
+struct kvm_lapic_state {
+	char regs[KVM_APIC_REG_SIZE];
+};
+
 struct kvm_segment {
 	__u64 base;
 	__u32 limit;
@@ -380,5 +386,7 @@ struct kvm_signal_mask {
 #define KVM_SET_SIGNAL_MASK       _IOW(KVMIO,  0x8b, struct kvm_signal_mask)
 #define KVM_GET_FPU               _IOR(KVMIO,  0x8c, struct kvm_fpu)
 #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
+#define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
+#define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
 
 #endif
-- 
1.5.3

