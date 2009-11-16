Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZKPM3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZKPM3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZKPM3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZKPMTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:40 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 13/42] KVM: Move irq ack notifier list to arch independent code
Date: Mon, 16 Nov 2009 14:19:14 +0200
Message-Id: <1258373983-8693-14-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Mask irq notifier list is already there.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    1 -
 arch/x86/include/asm/kvm_host.h  |    1 -
 include/linux/kvm_host.h         |    1 +
 virt/kvm/irq_comm.c              |    5 ++---
 virt/kvm/kvm_main.c              |    1 +
 5 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index d9b6325..a362e67 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -475,7 +475,6 @@ struct kvm_arch {
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	int iommu_flags;
-	struct hlist_head irq_ack_notifier_list;
 
 	unsigned long irq_sources_bitmap;
 	unsigned long irq_states[KVM_IOAPIC_NUM_PINS];
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35d3236..a46e2dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -397,7 +397,6 @@ struct kvm_arch{
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
-	struct hlist_head irq_ack_notifier_list;
 	int vapics_in_nmi_mode;
 
 	unsigned int tss_addr;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cc2d749..4aa5e1d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -187,6 +187,7 @@ struct kvm {
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 	struct kvm_irq_routing_table *irq_routing;
 	struct hlist_head mask_notifier_list;
+	struct hlist_head irq_ack_notifier_list;
 #endif
 
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index fb861dd..f019725 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -186,8 +186,7 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	rcu_read_unlock();
 
 	if (gsi != -1)
-		hlist_for_each_entry(kian, n, &kvm->arch.irq_ack_notifier_list,
-				     link)
+		hlist_for_each_entry(kian, n, &kvm->irq_ack_notifier_list, link)
 			if (kian->gsi == gsi)
 				kian->irq_acked(kian);
 }
@@ -196,7 +195,7 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian)
 {
 	mutex_lock(&kvm->irq_lock);
-	hlist_add_head(&kian->link, &kvm->arch.irq_ack_notifier_list);
+	hlist_add_head(&kian->link, &kvm->irq_ack_notifier_list);
 	mutex_unlock(&kvm->irq_lock);
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3bee948..6eca153 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -958,6 +958,7 @@ static struct kvm *kvm_create_vm(void)
 		goto out;
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
+	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
-- 
1.6.5.2

