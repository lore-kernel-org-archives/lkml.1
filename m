Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXLZLHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXLZLHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbXLZLGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:19 -0500
Received: from il.qumranet.com ([82.166.9.18]:50464 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXLZLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:04 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 05/55] KVM: Split IOAPIC reset function and export for kernel RESET
Date: Wed, 26 Dec 2007 13:05:10 +0200
Message-Id: <1198667160-22953-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c |   17 +++++++++++++----
 drivers/kvm/irq.h    |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index e14b7c7..cf1d50b 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -371,18 +371,27 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	}
 }
 
+void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
+{
+	int i;
+
+	for (i = 0; i < IOAPIC_NUM_PINS; i++)
+		ioapic->redirtbl[i].fields.mask = 1;
+	ioapic->base_address = IOAPIC_DEFAULT_BASE_ADDRESS;
+	ioapic->ioregsel = 0;
+	ioapic->irr = 0;
+	ioapic->id = 0;
+}
+
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
-	int i;
 
 	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
 	if (!ioapic)
 		return -ENOMEM;
 	kvm->vioapic = ioapic;
-	for (i = 0; i < IOAPIC_NUM_PINS; i++)
-		ioapic->redirtbl[i].fields.mask = 1;
-	ioapic->base_address = IOAPIC_DEFAULT_BASE_ADDRESS;
+	kvm_ioapic_reset(ioapic);
 	ioapic->dev.read = ioapic_mmio_read;
 	ioapic->dev.write = ioapic_mmio_write;
 	ioapic->dev.in_range = ioapic_in_range;
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index e08ae10..5ad3cfd 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -140,6 +140,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu);
 void kvm_pic_reset(struct kvm_kpic_state *s);
+void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
-- 
1.5.3.7

