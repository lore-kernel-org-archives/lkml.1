Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbXIQIpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbXIQIpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXIQIdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:45319 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "He, Qing" <qing.he@intel.com>
Subject: [PATCH 070/104] KVM: Add get/set irqchip ioctls for in-kernel PIC live migration support
Date: Mon, 17 Sep 2007 10:31:52 +0200
Message-Id: <1190017948850-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

This patch adds two new ioctls to dump and write kernel irqchips for
save/restore and live migration. PIC s/r and l/m is implemented in this
patch.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/i8259.c    |    5 +++
 drivers/kvm/irq.h      |    1 +
 drivers/kvm/kvm_main.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h    |   36 +++++++++++++++++++++
 4 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/i8259.c b/drivers/kvm/i8259.c
index ee6030d..a679157 100644
--- a/drivers/kvm/i8259.c
+++ b/drivers/kvm/i8259.c
@@ -119,6 +119,11 @@ static void pic_update_irq(struct kvm_pic *s)
 		s->irq_request(s->irq_request_opaque, 0);
 }
 
+void kvm_pic_update_irq(struct kvm_pic *s)
+{
+	pic_update_irq(s);
+}
+
 void kvm_pic_set_irq(void *opaque, int irq, int level)
 {
 	struct kvm_pic *s = opaque;
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index fff5733..e0133e6 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -59,6 +59,7 @@ void kvm_pic_set_irq(void *opaque, int irq, int level);
 int kvm_pic_read_irq(struct kvm_pic *s);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
+void kvm_pic_update_irq(struct kvm_pic *s);
 
 #define IOAPIC_NUM_PINS  24
 #define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5063b3a..6e2c5f3 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -897,6 +897,53 @@ out:
 	return r;
 }
 
+static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
+{
+	int r;
+
+	r = 0;
+	switch (chip->chip_id) {
+	case KVM_IRQCHIP_PIC_MASTER:
+		memcpy (&chip->chip.pic,
+			&pic_irqchip(kvm)->pics[0],
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_PIC_SLAVE:
+		memcpy (&chip->chip.pic,
+			&pic_irqchip(kvm)->pics[1],
+			sizeof(struct kvm_pic_state));
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+	return r;
+}
+
+static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
+{
+	int r;
+
+	r = 0;
+	switch (chip->chip_id) {
+	case KVM_IRQCHIP_PIC_MASTER:
+		memcpy (&pic_irqchip(kvm)->pics[0],
+			&chip->chip.pic,
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_PIC_SLAVE:
+		memcpy (&pic_irqchip(kvm)->pics[1],
+			&chip->chip.pic,
+			sizeof(struct kvm_pic_state));
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+	kvm_pic_update_irq(pic_irqchip(kvm));
+	return r;
+}
+
 static gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
@@ -2835,6 +2882,41 @@ static long kvm_vm_ioctl(struct file *filp,
 		}
 		break;
 	}
+	case KVM_GET_IRQCHIP: {
+		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
+		struct kvm_irqchip chip;
+
+		r = -EFAULT;
+		if (copy_from_user(&chip, argp, sizeof chip))
+			goto out;
+		r = -ENXIO;
+		if (!irqchip_in_kernel(kvm))
+			goto out;
+		r = kvm_vm_ioctl_get_irqchip(kvm, &chip);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &chip, sizeof chip))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_IRQCHIP: {
+		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
+		struct kvm_irqchip chip;
+
+		r = -EFAULT;
+		if (copy_from_user(&chip, argp, sizeof chip))
+			goto out;
+		r = -ENXIO;
+		if (!irqchip_in_kernel(kvm))
+			goto out;
+		r = kvm_vm_ioctl_set_irqchip(kvm, &chip);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index b0a13d1..6560f11 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -45,6 +45,40 @@ struct kvm_irq_level {
 	__u32 level;
 };
 
+/* for KVM_GET_IRQCHIP / KVM_SET_IRQCHIP */
+struct kvm_pic_state {
+	__u8 last_irr;	/* edge detection */
+	__u8 irr;		/* interrupt request register */
+	__u8 imr;		/* interrupt mask register */
+	__u8 isr;		/* interrupt service register */
+	__u8 priority_add;	/* highest irq priority */
+	__u8 irq_base;
+	__u8 read_reg_select;
+	__u8 poll;
+	__u8 special_mask;
+	__u8 init_state;
+	__u8 auto_eoi;
+	__u8 rotate_on_auto_eoi;
+	__u8 special_fully_nested_mode;
+	__u8 init4;		/* true if 4 byte init */
+	__u8 elcr;		/* PIIX edge/trigger selection */
+	__u8 elcr_mask;
+};
+
+enum kvm_irqchip_id {
+	KVM_IRQCHIP_PIC_MASTER	 = 0,
+	KVM_IRQCHIP_PIC_SLAVE	 = 1,
+};
+
+struct kvm_irqchip {
+	__u32 chip_id;
+	__u32 pad;
+        union {
+		char dummy[512];  /* reserving space */
+		struct kvm_pic_state pic;
+	} chip;
+};
+
 enum kvm_exit_reason {
 	KVM_EXIT_UNKNOWN          = 0,
 	KVM_EXIT_EXCEPTION        = 1,
@@ -299,6 +333,8 @@ struct kvm_signal_mask {
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP	  _IO(KVMIO,  0x60)
 #define KVM_IRQ_LINE		  _IOW(KVMIO, 0x61, struct kvm_irq_level)
+#define KVM_GET_IRQCHIP		  _IOWR(KVMIO, 0x62, struct kvm_irqchip)
+#define KVM_SET_IRQCHIP		  _IOR(KVMIO,  0x63, struct kvm_irqchip)
 
 /*
  * ioctls for vcpu fds
-- 
1.5.3

