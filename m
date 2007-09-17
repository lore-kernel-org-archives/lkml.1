Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbXIQIrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbXIQIrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXIQIdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:07 -0400
Received: from il.qumranet.com ([82.166.9.18]:45248 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "He, Qing" <qing.he@intel.com>
Subject: [PATCH 072/104] KVM: in-kernel IOAPIC save and restore support
Date: Mon, 17 Sep 2007 10:31:54 +0200
Message-Id: <1190017948481-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

This patch adds support for in-kernel ioapic save and restore (to
and from userspace). It uses the same get/set_irqchip ioctl as
in-kernel PIC.

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h      |    9 +++++----
 drivers/kvm/kvm.h      |    5 +++++
 drivers/kvm/kvm_main.c |   10 ++++++++++
 include/linux/kvm.h    |   29 ++++++++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index e0133e6..30adddc 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -61,7 +61,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
 void kvm_pic_update_irq(struct kvm_pic *s);
 
-#define IOAPIC_NUM_PINS  24
+#define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
 #define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
 #define IOAPIC_EDGE_TRIG  0
 #define IOAPIC_LEVEL_TRIG 1
@@ -80,12 +80,11 @@ void kvm_pic_update_irq(struct kvm_pic *s);
 #define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
 
 struct kvm_ioapic {
-	struct kvm_io_device dev;
-	unsigned long base_address;
-	struct kvm *kvm;
+	u64 base_address;
 	u32 ioregsel;
 	u32 id;
 	u32 irr;
+	u32 pad;
 	union ioapic_redir_entry {
 		u64 bits;
 		struct {
@@ -102,6 +101,8 @@ struct kvm_ioapic {
 			u8 dest_id;
 		} fields;
 	} redirtbl[IOAPIC_NUM_PINS];
+	struct kvm_io_device dev;
+	struct kvm *kvm;
 };
 
 struct kvm_lapic {
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index f69b482..bb506b7 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -420,6 +420,11 @@ static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
 	return kvm->vpic;
 }
 
+static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
+{
+	return kvm->vioapic;
+}
+
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
 	return pic_irqchip(kvm) != 0;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index c270e4a..61dff55 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -913,6 +913,11 @@ static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 			&pic_irqchip(kvm)->pics[1],
 			sizeof(struct kvm_pic_state));
 		break;
+	case KVM_IRQCHIP_IOAPIC:
+		memcpy (&chip->chip.ioapic,
+			ioapic_irqchip(kvm),
+			sizeof(struct kvm_ioapic_state));
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -936,6 +941,11 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 			&chip->chip.pic,
 			sizeof(struct kvm_pic_state));
 		break;
+	case KVM_IRQCHIP_IOAPIC:
+		memcpy (ioapic_irqchip(kvm),
+			&chip->chip.ioapic,
+			sizeof(struct kvm_ioapic_state));
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6560f11..42d1515 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -45,7 +45,7 @@ struct kvm_irq_level {
 	__u32 level;
 };
 
-/* for KVM_GET_IRQCHIP / KVM_SET_IRQCHIP */
+/* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
 struct kvm_pic_state {
 	__u8 last_irr;	/* edge detection */
 	__u8 irr;		/* interrupt request register */
@@ -65,9 +65,35 @@ struct kvm_pic_state {
 	__u8 elcr_mask;
 };
 
+#define KVM_IOAPIC_NUM_PINS  24
+struct kvm_ioapic_state {
+	__u64 base_address;
+	__u32 ioregsel;
+	__u32 id;
+	__u32 irr;
+	__u32 pad;
+	union {
+		__u64 bits;
+		struct {
+			__u8 vector;
+			__u8 delivery_mode:3;
+			__u8 dest_mode:1;
+			__u8 delivery_status:1;
+			__u8 polarity:1;
+			__u8 remote_irr:1;
+			__u8 trig_mode:1;
+			__u8 mask:1;
+			__u8 reserve:7;
+			__u8 reserved[4];
+			__u8 dest_id;
+		} fields;
+	} redirtbl[KVM_IOAPIC_NUM_PINS];
+};
+
 enum kvm_irqchip_id {
 	KVM_IRQCHIP_PIC_MASTER	 = 0,
 	KVM_IRQCHIP_PIC_SLAVE	 = 1,
+	KVM_IRQCHIP_IOAPIC       = 2,
 };
 
 struct kvm_irqchip {
@@ -76,6 +102,7 @@ struct kvm_irqchip {
         union {
 		char dummy[512];  /* reserving space */
 		struct kvm_pic_state pic;
+		struct kvm_ioapic_state ioapic;
 	} chip;
 };
 
-- 
1.5.3

