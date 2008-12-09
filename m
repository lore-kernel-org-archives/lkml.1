Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYLIUbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYLIUbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYLIUX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34898 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834AbYLIUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 41/44] KVM: Add assigned_device_msi_dispatch()
Date: Tue,  9 Dec 2008 22:22:56 +0200
Message-Id: <1228854179-23002-42-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

The function is used to dispatch MSI to lapic according to MSI message
address and message data.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2089f8b..228c1d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -47,6 +47,10 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
+#ifdef CONFIG_X86
+#include <asm/msidef.h>
+#endif
+
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 #include "coalesced_mmio.h"
 #endif
@@ -78,6 +82,57 @@ static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 bool kvm_rebooting;
 
 #ifdef KVM_CAP_DEVICE_ASSIGNMENT
+
+#ifdef CONFIG_X86
+static void assigned_device_msi_dispatch(struct kvm_assigned_dev_kernel *dev)
+{
+	int vcpu_id;
+	struct kvm_vcpu *vcpu;
+	struct kvm_ioapic *ioapic = ioapic_irqchip(dev->kvm);
+	int dest_id = (dev->guest_msi.address_lo & MSI_ADDR_DEST_ID_MASK)
+			>> MSI_ADDR_DEST_ID_SHIFT;
+	int vector = (dev->guest_msi.data & MSI_DATA_VECTOR_MASK)
+			>> MSI_DATA_VECTOR_SHIFT;
+	int dest_mode = test_bit(MSI_ADDR_DEST_MODE_SHIFT,
+				(unsigned long *)&dev->guest_msi.address_lo);
+	int trig_mode = test_bit(MSI_DATA_TRIGGER_SHIFT,
+				(unsigned long *)&dev->guest_msi.data);
+	int delivery_mode = test_bit(MSI_DATA_DELIVERY_MODE_SHIFT,
+				(unsigned long *)&dev->guest_msi.data);
+	u32 deliver_bitmask;
+
+	BUG_ON(!ioapic);
+
+	deliver_bitmask = kvm_ioapic_get_delivery_bitmask(ioapic,
+				dest_id, dest_mode);
+	/* IOAPIC delivery mode value is the same as MSI here */
+	switch (delivery_mode) {
+	case IOAPIC_LOWEST_PRIORITY:
+		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm, vector,
+				deliver_bitmask);
+		if (vcpu != NULL)
+			kvm_apic_set_irq(vcpu, vector, trig_mode);
+		else
+			printk(KERN_INFO "kvm: null lowest priority vcpu!\n");
+		break;
+	case IOAPIC_FIXED:
+		for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
+			if (!(deliver_bitmask & (1 << vcpu_id)))
+				continue;
+			deliver_bitmask &= ~(1 << vcpu_id);
+			vcpu = ioapic->kvm->vcpus[vcpu_id];
+			if (vcpu)
+				kvm_apic_set_irq(vcpu, vector, trig_mode);
+		}
+		break;
+	default:
+		printk(KERN_INFO "kvm: unsupported MSI delivery mode\n");
+	}
+}
+#else
+static void assigned_device_msi_dispatch(struct kvm_assigned_dev_kernel *dev) {}
+#endif
+
 static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
 						      int assigned_dev_id)
 {
-- 
1.6.0.3

