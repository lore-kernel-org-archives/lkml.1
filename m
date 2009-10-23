Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbZJWCjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbZJWCjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 22:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZJWCi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 22:38:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51169 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZJWCi4 (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Thu, 22 Oct 2009 22:38:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 1/2] KVM: export lockless GSI attribute
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Date: Thu, 22 Oct 2009 22:38:45 -0400
Message-ID: <20091023023845.3891.36857.stgit@dev.haskins.net>
In-Reply-To: <20091023023512.3891.65889.stgit@dev.haskins.net>
References: <20091023023512.3891.65889.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain GSI's support lockless injecton, but we have no way to detect
which ones at the GSI level.  Knowledge of this attribute will be
useful later in the series so that we can optimize irqfd injection
paths for cases where we know the code will not sleep.  Therefore,
we provide an API to query a specific GSI.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm_host.h |    2 ++
 virt/kvm/irq_comm.c      |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bd5a616..93393a4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -119,6 +119,7 @@ struct kvm_memory_slot {
 struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
 	u32 type;
+	bool lockless;
 	int (*set)(struct kvm_kernel_irq_routing_entry *e,
 		   struct kvm *kvm, int irq_source_id, int level);
 	union {
@@ -417,6 +418,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 				   unsigned long *deliver_bitmask);
 #endif
 int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
+int kvm_irq_check_lockless(struct kvm *kvm, u32 irq);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 00c68d2..04f0134 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -174,6 +174,23 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
 	return ret;
 }
 
+int kvm_irq_check_lockless(struct kvm *kvm, u32 irq)
+{
+	struct kvm_kernel_irq_routing_entry *e;
+	struct kvm_irq_routing_table *irq_rt;
+	struct hlist_node *n;
+	int ret = -ENOENT;
+
+	rcu_read_lock();
+	irq_rt = rcu_dereference(kvm->irq_routing);
+	if (irq < irq_rt->nr_rt_entries)
+		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
+			ret = e->lockless ? 1 : 0;
+	rcu_read_unlock();
+
+	return ret;
+}
+
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
 	struct kvm_irq_ack_notifier *kian;
@@ -314,6 +331,7 @@ static int setup_routing_entry(struct kvm_irq_routing_table *rt,
 
 	e->gsi = ue->gsi;
 	e->type = ue->type;
+	e->lockless = false;
 	switch (ue->type) {
 	case KVM_IRQ_ROUTING_IRQCHIP:
 		delta = 0;
@@ -342,6 +360,7 @@ static int setup_routing_entry(struct kvm_irq_routing_table *rt,
 		e->msi.address_lo = ue->u.msi.address_lo;
 		e->msi.address_hi = ue->u.msi.address_hi;
 		e->msi.data = ue->u.msi.data;
+		e->lockless = true;
 		break;
 	default:
 		goto out;

