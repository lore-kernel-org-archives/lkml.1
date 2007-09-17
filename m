Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbXIQIua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbXIQIua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXIQIdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:45245 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "He, Qing" <qing.he@intel.com>
Subject: [PATCH 080/104] KVM: round robin for APIC lowest priority delivery mode
Date: Mon, 17 Sep 2007 10:32:02 +0200
Message-Id: <11900179492551-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h   |    1 +
 drivers/kvm/lapic.c |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index f8fe87d..dbb929d 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -413,6 +413,7 @@ struct kvm {
 	struct kvm_io_bus pio_bus;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
+	int round_robin_prev_vcpu;
 };
 
 static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 01e7696..ca1db38 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -371,12 +371,35 @@ struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 				       unsigned long bitmap)
 {
 	int vcpu_id;
+	int last;
+	int next;
+	struct kvm_lapic *apic;
+
+	last = kvm->round_robin_prev_vcpu;
+	next = last;
+
+	do {
+		if (++next == KVM_MAX_VCPUS)
+			next = 0;
+		if (kvm->vcpus[next] == NULL || !test_bit(next, &bitmap))
+			continue;
+		apic = kvm->vcpus[next]->apic;
+		if (apic && apic_enabled(apic))
+			break;
+		apic = NULL;
+	} while (next != last);
+	kvm->round_robin_prev_vcpu = next;
+
+	if (!apic) {
+		vcpu_id = ffs(bitmap) - 1;
+		if (vcpu_id < 0) {
+			vcpu_id = 0;
+			printk(KERN_DEBUG "vcpu not ready for apic_round_robin\n");
+		}
+		apic = kvm->vcpus[vcpu_id]->apic;
+	}
 
-	/* TODO for real round robin */
-	vcpu_id = fls(bitmap) - 1;
-	if (vcpu_id < 0)
-		printk(KERN_DEBUG "vcpu not ready for apic_round_robin\n");
-	return kvm->vcpus[vcpu_id]->apic;
+	return apic;
 }
 
 static void apic_set_eoi(struct kvm_lapic *apic)
-- 
1.5.3

