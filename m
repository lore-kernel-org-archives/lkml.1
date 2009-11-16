Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZKPMVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZKPMVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZKPMU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZKPMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:41 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 11/42] KVM: Maintain back mapping from irqchip/pin to gsi
Date: Mon, 16 Nov 2009 14:19:12 +0200
Message-Id: <1258373983-8693-12-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Maintain back mapping from irqchip/pin to gsi to speedup
interrupt acknowledgment notifications.

[avi: build fix on non-x86/ia64]

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm.h |    1 +
 arch/x86/include/asm/kvm.h  |    1 +
 include/linux/kvm_host.h    |    9 +++++++++
 virt/kvm/irq_comm.c         |   31 ++++++++++++++-----------------
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/ia64/include/asm/kvm.h b/arch/ia64/include/asm/kvm.h
index 18a7e49..bc90c75 100644
--- a/arch/ia64/include/asm/kvm.h
+++ b/arch/ia64/include/asm/kvm.h
@@ -60,6 +60,7 @@ struct kvm_ioapic_state {
 #define KVM_IRQCHIP_PIC_MASTER   0
 #define KVM_IRQCHIP_PIC_SLAVE    1
 #define KVM_IRQCHIP_IOAPIC       2
+#define KVM_NR_IRQCHIPS          3
 
 #define KVM_CONTEXT_SIZE	8*1024
 
diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index 4a5fe91..f02e87a 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -79,6 +79,7 @@ struct kvm_ioapic_state {
 #define KVM_IRQCHIP_PIC_MASTER   0
 #define KVM_IRQCHIP_PIC_SLAVE    1
 #define KVM_IRQCHIP_IOAPIC       2
+#define KVM_NR_IRQCHIPS          3
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f403e66..cc2d749 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -131,7 +131,10 @@ struct kvm_kernel_irq_routing_entry {
 	struct hlist_node link;
 };
 
+#ifdef __KVM_HAVE_IOAPIC
+
 struct kvm_irq_routing_table {
+	int chip[KVM_NR_IRQCHIPS][KVM_IOAPIC_NUM_PINS];
 	struct kvm_kernel_irq_routing_entry *rt_entries;
 	u32 nr_rt_entries;
 	/*
@@ -141,6 +144,12 @@ struct kvm_irq_routing_table {
 	struct hlist_head map[0];
 };
 
+#else
+
+struct kvm_irq_routing_table {};
+
+#endif
+
 struct kvm {
 	spinlock_t mmu_lock;
 	spinlock_t requests_lock;
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 81950f6..59cf8da 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -175,25 +175,16 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
 	struct kvm_irq_ack_notifier *kian;
 	struct hlist_node *n;
-	unsigned gsi = pin;
-	int i;
+	int gsi;
 
 	trace_kvm_ack_irq(irqchip, pin);
 
-	for (i = 0; i < kvm->irq_routing->nr_rt_entries; i++) {
-		struct kvm_kernel_irq_routing_entry *e;
-		e = &kvm->irq_routing->rt_entries[i];
-		if (e->type == KVM_IRQ_ROUTING_IRQCHIP &&
-		    e->irqchip.irqchip == irqchip &&
-		    e->irqchip.pin == pin) {
-			gsi = e->gsi;
-			break;
-		}
-	}
-
-	hlist_for_each_entry(kian, n, &kvm->arch.irq_ack_notifier_list, link)
-		if (kian->gsi == gsi)
-			kian->irq_acked(kian);
+	gsi = kvm->irq_routing->chip[irqchip][pin];
+	if (gsi != -1)
+		hlist_for_each_entry(kian, n, &kvm->arch.irq_ack_notifier_list,
+				     link)
+			if (kian->gsi == gsi)
+				kian->irq_acked(kian);
 }
 
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
@@ -332,6 +323,9 @@ static int setup_routing_entry(struct kvm_irq_routing_table *rt,
 		}
 		e->irqchip.irqchip = ue->u.irqchip.irqchip;
 		e->irqchip.pin = ue->u.irqchip.pin + delta;
+		if (e->irqchip.pin >= KVM_IOAPIC_NUM_PINS)
+			goto out;
+		rt->chip[ue->u.irqchip.irqchip][e->irqchip.pin] = ue->gsi;
 		break;
 	case KVM_IRQ_ROUTING_MSI:
 		e->set = kvm_set_msi;
@@ -356,7 +350,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			unsigned flags)
 {
 	struct kvm_irq_routing_table *new, *old;
-	u32 i, nr_rt_entries = 0;
+	u32 i, j, nr_rt_entries = 0;
 	int r;
 
 	for (i = 0; i < nr; ++i) {
@@ -377,6 +371,9 @@ int kvm_set_irq_routing(struct kvm *kvm,
 	new->rt_entries = (void *)&new->map[nr_rt_entries];
 
 	new->nr_rt_entries = nr_rt_entries;
+	for (i = 0; i < 3; i++)
+		for (j = 0; j < KVM_IOAPIC_NUM_PINS; j++)
+			new->chip[i][j] = -1;
 
 	for (i = 0; i < nr; ++i) {
 		r = -EINVAL;
-- 
1.6.5.2

