Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZKPM3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZKPM3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZKPM3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZKPMTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:40 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 12/42] KVM: Move irq routing data structure to rcu locking
Date: Mon, 16 Nov 2009 14:19:13 +0200
Message-Id: <1258373983-8693-13-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 59cf8da..fb861dd 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -159,7 +159,8 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
 	 * IOAPIC.  So set the bit in both. The guest will ignore
 	 * writes to the unused one.
 	 */
-	irq_rt = kvm->irq_routing;
+	rcu_read_lock();
+	irq_rt = rcu_dereference(kvm->irq_routing);
 	if (irq < irq_rt->nr_rt_entries)
 		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {
 			int r = e->set(e, kvm, irq_source_id, level);
@@ -168,6 +169,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
 
 			ret = r + ((ret < 0) ? 0 : ret);
 		}
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -179,7 +181,10 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 
 	trace_kvm_ack_irq(irqchip, pin);
 
-	gsi = kvm->irq_routing->chip[irqchip][pin];
+	rcu_read_lock();
+	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
+	rcu_read_unlock();
+
 	if (gsi != -1)
 		hlist_for_each_entry(kian, n, &kvm->arch.irq_ack_notifier_list,
 				     link)
@@ -279,9 +284,9 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask)
 
 void kvm_free_irq_routing(struct kvm *kvm)
 {
-	mutex_lock(&kvm->irq_lock);
+	/* Called only during vm destruction. Nobody can use the pointer
+	   at this stage */
 	kfree(kvm->irq_routing);
-	mutex_unlock(&kvm->irq_lock);
 }
 
 static int setup_routing_entry(struct kvm_irq_routing_table *rt,
@@ -387,8 +392,9 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	mutex_lock(&kvm->irq_lock);
 	old = kvm->irq_routing;
-	kvm->irq_routing = new;
+	rcu_assign_pointer(kvm->irq_routing, new);
 	mutex_unlock(&kvm->irq_lock);
+	synchronize_rcu();
 
 	new = old;
 	r = 0;
-- 
1.6.5.2

