Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYIWNzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYIWNzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYIWNr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52430 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYIWNrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 30/40] KVM: Add irq ack notifier list
Date: Tue, 23 Sep 2008 16:46:44 +0300
Message-Id: <1222177614-26669-31-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

This can be used by kvm subsystems that are interested in when
interrupts are acked, for example time drift compensation.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/irq.c         |   22 ++++++++++++++++++++++
 arch/x86/kvm/irq.h         |    5 +++++
 include/asm-x86/kvm_host.h |    7 +++++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 0d9e552..9091195 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -111,3 +111,25 @@ void kvm_set_irq(struct kvm *kvm, int irq, int level)
 	kvm_ioapic_set_irq(kvm->arch.vioapic, irq, level);
 	kvm_pic_set_irq(pic_irqchip(kvm), irq, level);
 }
+
+void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi)
+{
+	struct kvm_irq_ack_notifier *kian;
+	struct hlist_node *n;
+
+	hlist_for_each_entry(kian, n, &kvm->arch.irq_ack_notifier_list, link)
+		if (kian->gsi == gsi)
+			kian->irq_acked(kian);
+}
+
+void kvm_register_irq_ack_notifier(struct kvm *kvm,
+				   struct kvm_irq_ack_notifier *kian)
+{
+	hlist_add_head(&kian->link, &kvm->arch.irq_ack_notifier_list);
+}
+
+void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
+				     struct kvm_irq_ack_notifier *kian)
+{
+	hlist_del(&kian->link);
+}
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 07ff2ae..95fe718 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -83,6 +83,11 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 void kvm_pic_reset(struct kvm_kpic_state *s);
 
 void kvm_set_irq(struct kvm *kvm, int irq, int level);
+void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi);
+void kvm_register_irq_ack_notifier(struct kvm *kvm,
+				   struct kvm_irq_ack_notifier *kian);
+void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
+				     struct kvm_irq_ack_notifier *kian);
 
 void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 4104cb2..e4297b8 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -321,6 +321,12 @@ struct kvm_mem_alias {
 	gfn_t target_gfn;
 };
 
+struct kvm_irq_ack_notifier {
+	struct hlist_node link;
+	unsigned gsi;
+	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
+};
+
 struct kvm_arch{
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
@@ -336,6 +342,7 @@ struct kvm_arch{
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
+	struct hlist_head irq_ack_notifier_list;
 
 	int round_robin_prev_vcpu;
 	unsigned int tss_addr;
-- 
1.6.0.1

