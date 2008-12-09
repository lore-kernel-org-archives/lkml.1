Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYLIUem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYLIUem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYLIUYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34882 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 37/44] KVM: Replace irq_requested with more generic irq_requested_type
Date: Tue,  9 Dec 2008 22:22:52 +0200
Message-Id: <1228854179-23002-38-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Separate guest irq type and host irq type, for we can support guest using INTx
with host using MSI (but not opposite combination).

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    4 +++-
 virt/kvm/kvm_main.c      |    9 +++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3a0fb77..c3d4b96 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -307,7 +307,9 @@ struct kvm_assigned_dev_kernel {
 	int host_devfn;
 	int host_irq;
 	int guest_irq;
-	int irq_requested;
+#define KVM_ASSIGNED_DEV_GUEST_INTX	(1 << 0)
+#define KVM_ASSIGNED_DEV_HOST_INTX	(1 << 8)
+	unsigned long irq_requested_type;
 	int irq_source_id;
 	struct pci_dev *dev;
 	struct kvm *kvm;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ef2f03c..638de47 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -140,7 +140,7 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 				     struct kvm_assigned_dev_kernel
 				     *assigned_dev)
 {
-	if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested)
+	if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested_type)
 		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
 
 	kvm_unregister_irq_ack_notifier(&assigned_dev->ack_notifier);
@@ -180,7 +180,7 @@ static int assigned_device_update_intx(struct kvm *kvm,
 			struct kvm_assigned_dev_kernel *adev,
 			struct kvm_assigned_irq *airq)
 {
-	if (adev->irq_requested) {
+	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_GUEST_INTX) {
 		adev->guest_irq = airq->guest_irq;
 		adev->ack_notifier.gsi = airq->guest_irq;
 		return 0;
@@ -207,7 +207,8 @@ static int assigned_device_update_intx(struct kvm *kvm,
 			return -EIO;
 	}
 
-	adev->irq_requested = true;
+	adev->irq_requested_type = KVM_ASSIGNED_DEV_GUEST_INTX |
+				   KVM_ASSIGNED_DEV_HOST_INTX;
 	return 0;
 }
 
@@ -227,7 +228,7 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 		return -EINVAL;
 	}
 
-	if (!match->irq_requested) {
+	if (!match->irq_requested_type) {
 		INIT_WORK(&match->interrupt_work,
 				kvm_assigned_dev_interrupt_work_handler);
 		if (irqchip_in_kernel(kvm)) {
-- 
1.6.0.3

