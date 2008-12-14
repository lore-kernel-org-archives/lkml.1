Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYLNIPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYLNIPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYLNIHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59928 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbYLNIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:16 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 18/36] KVM: split out kvm_free_assigned_irq()
Date: Sun, 14 Dec 2008 10:06:51 +0200
Message-Id: <1229242029-13410-19-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Split out the logic corresponding to undoing assign_irq() and
clean it up a bit.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 63fd882..e41d39d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -200,14 +200,11 @@ static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 	enable_irq(dev->host_irq);
 }
 
-static void kvm_free_assigned_device(struct kvm *kvm,
-				     struct kvm_assigned_dev_kernel
-				     *assigned_dev)
+static void kvm_free_assigned_irq(struct kvm *kvm,
+				  struct kvm_assigned_dev_kernel *assigned_dev)
 {
-	if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested_type)
-		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
-	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
-		pci_disable_msi(assigned_dev->dev);
+	if (!irqchip_in_kernel(kvm))
+		return;
 
 	kvm_unregister_irq_ack_notifier(&assigned_dev->ack_notifier);
 
@@ -215,12 +212,30 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 		kvm_free_irq_source_id(kvm, assigned_dev->irq_source_id);
 	assigned_dev->irq_source_id = -1;
 
+	if (!assigned_dev->irq_requested_type)
+		return;
+
 	if (cancel_work_sync(&assigned_dev->interrupt_work))
 		/* We had pending work. That means we will have to take
 		 * care of kvm_put_kvm.
 		 */
 		kvm_put_kvm(kvm);
 
+	free_irq(assigned_dev->host_irq, (void *)assigned_dev);
+
+	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
+		pci_disable_msi(assigned_dev->dev);
+
+	assigned_dev->irq_requested_type = 0;
+}
+
+
+static void kvm_free_assigned_device(struct kvm *kvm,
+				     struct kvm_assigned_dev_kernel
+				     *assigned_dev)
+{
+	kvm_free_assigned_irq(kvm, assigned_dev);
+
 	pci_reset_function(assigned_dev->dev);
 
 	pci_release_regions(assigned_dev->dev);
-- 
1.6.0.3

