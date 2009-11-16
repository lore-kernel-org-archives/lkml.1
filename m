Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZKPM3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZKPM3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZKPM3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:29:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZKPMTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:40 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 14/42] KVM: Convert irq notifiers lists to RCU locking
Date: Mon, 16 Nov 2009 14:19:15 +0200
Message-Id: <1258373983-8693-15-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Use RCU locking for mask/ack notifiers lists.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index f019725..6c94614 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -183,19 +183,19 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 
 	rcu_read_lock();
 	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
-	rcu_read_unlock();
-
 	if (gsi != -1)
-		hlist_for_each_entry(kian, n, &kvm->irq_ack_notifier_list, link)
+		hlist_for_each_entry_rcu(kian, n, &kvm->irq_ack_notifier_list,
+					 link)
 			if (kian->gsi == gsi)
 				kian->irq_acked(kian);
+	rcu_read_unlock();
 }
 
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian)
 {
 	mutex_lock(&kvm->irq_lock);
-	hlist_add_head(&kian->link, &kvm->irq_ack_notifier_list);
+	hlist_add_head_rcu(&kian->link, &kvm->irq_ack_notifier_list);
 	mutex_unlock(&kvm->irq_lock);
 }
 
@@ -203,8 +203,9 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				    struct kvm_irq_ack_notifier *kian)
 {
 	mutex_lock(&kvm->irq_lock);
-	hlist_del_init(&kian->link);
+	hlist_del_init_rcu(&kian->link);
 	mutex_unlock(&kvm->irq_lock);
+	synchronize_rcu();
 }
 
 int kvm_request_irq_source_id(struct kvm *kvm)
@@ -257,7 +258,7 @@ void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
 {
 	mutex_lock(&kvm->irq_lock);
 	kimn->irq = irq;
-	hlist_add_head(&kimn->link, &kvm->mask_notifier_list);
+	hlist_add_head_rcu(&kimn->link, &kvm->mask_notifier_list);
 	mutex_unlock(&kvm->irq_lock);
 }
 
@@ -265,8 +266,9 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 				      struct kvm_irq_mask_notifier *kimn)
 {
 	mutex_lock(&kvm->irq_lock);
-	hlist_del(&kimn->link);
+	hlist_del_rcu(&kimn->link);
 	mutex_unlock(&kvm->irq_lock);
+	synchronize_rcu();
 }
 
 void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask)
@@ -274,11 +276,11 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask)
 	struct kvm_irq_mask_notifier *kimn;
 	struct hlist_node *n;
 
-	WARN_ON(!mutex_is_locked(&kvm->irq_lock));
-
-	hlist_for_each_entry(kimn, n, &kvm->mask_notifier_list, link)
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(kimn, n, &kvm->mask_notifier_list, link)
 		if (kimn->irq == irq)
 			kimn->func(kimn, mask);
+	rcu_read_unlock();
 }
 
 void kvm_free_irq_routing(struct kvm *kvm)
-- 
1.6.5.2

