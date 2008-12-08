Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYLHLje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYLHLje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYLHLhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48263 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 28/45] KVM: IRQ ACK notifier should be used with in-kernel irqchip
Date: Mon,  8 Dec 2008 13:36:39 +0200
Message-Id: <1228736216-15787-29-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Also remove unnecessary parameter of unregister irq ack notifier.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    3 +--
 virt/kvm/irq_comm.c      |    8 ++++++--
 virt/kvm/kvm_main.c      |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bb92be2..3a0fb77 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -316,8 +316,7 @@ void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
-void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
-				     struct kvm_irq_ack_notifier *kian);
+void kvm_unregister_irq_ack_notifier(struct kvm_irq_ack_notifier *kian);
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 55ad76e..9fbbdea 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -58,12 +58,16 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi)
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian)
 {
+	/* Must be called with in-kernel IRQ chip, otherwise it's nonsense */
+	ASSERT(irqchip_in_kernel(kvm));
+	ASSERT(kian);
 	hlist_add_head(&kian->link, &kvm->arch.irq_ack_notifier_list);
 }
 
-void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
-				     struct kvm_irq_ack_notifier *kian)
+void kvm_unregister_irq_ack_notifier(struct kvm_irq_ack_notifier *kian)
 {
+	if (!kian)
+		return;
 	hlist_del(&kian->link);
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a87f45e..4f43abe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -143,7 +143,7 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 	if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested)
 		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
 
-	kvm_unregister_irq_ack_notifier(kvm, &assigned_dev->ack_notifier);
+	kvm_unregister_irq_ack_notifier(&assigned_dev->ack_notifier);
 	kvm_free_irq_source_id(kvm, assigned_dev->irq_source_id);
 
 	if (cancel_work_sync(&assigned_dev->interrupt_work))
-- 
1.6.0.3

