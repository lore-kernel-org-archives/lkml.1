Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYLIUba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYLIUba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYLIUX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34902 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbYLIUXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 43/44] KVM: MSI to INTx translate
Date: Tue,  9 Dec 2008 22:22:58 +0200
Message-Id: <1228854179-23002-44-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Now we use MSI as default one, and translate MSI to INTx when guest need
INTx rather than MSI. For legacy device, we provide support for non-sharing
host IRQ.

Provide a parameter msi2intx for this method. The value is true by default in
x86 architecture.

We can't guarantee this mode can work on every device, but for most of us
tested, it works. If your device encounter some trouble with this mode, you can
try set msi2intx modules parameter to 0. If the device is OK with msi2intx=0,
then please report it to KVM mailing list or me. We may prepare a blacklist for
the device that can't work in this mode.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   70 +++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bf36ae9..54d25e6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -64,6 +64,9 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static int msi2intx = 1;
+module_param(msi2intx, bool, 0);
+
 DEFINE_SPINLOCK(kvm_lock);
 LIST_HEAD(vm_list);
 
@@ -250,7 +253,8 @@ static int assigned_device_update_intx(struct kvm *kvm,
 		return 0;
 
 	if (irqchip_in_kernel(kvm)) {
-		if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI) {
+		if (!msi2intx &&
+		    adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI) {
 			free_irq(adev->host_irq, (void *)kvm);
 			pci_disable_msi(adev->dev);
 		}
@@ -285,21 +289,33 @@ static int assigned_device_update_msi(struct kvm *kvm,
 {
 	int r;
 
-	/* x86 don't care upper address of guest msi message addr */
-	adev->guest_msi.address_lo = airq->guest_msi.addr_lo;
-	adev->guest_msi.data = airq->guest_msi.data;
-	adev->ack_notifier.gsi = -1;
+	if (airq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSI) {
+		/* x86 don't care upper address of guest msi message addr */
+		adev->irq_requested_type |= KVM_ASSIGNED_DEV_GUEST_MSI;
+		adev->irq_requested_type &= ~KVM_ASSIGNED_DEV_GUEST_INTX;
+		adev->guest_msi.address_lo = airq->guest_msi.addr_lo;
+		adev->guest_msi.data = airq->guest_msi.data;
+		adev->ack_notifier.gsi = -1;
+	} else if (msi2intx) {
+		adev->irq_requested_type |= KVM_ASSIGNED_DEV_GUEST_INTX;
+		adev->irq_requested_type &= ~KVM_ASSIGNED_DEV_GUEST_MSI;
+		adev->guest_irq = airq->guest_irq;
+		adev->ack_notifier.gsi = airq->guest_irq;
+	}
 
 	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
 		return 0;
 
 	if (irqchip_in_kernel(kvm)) {
-		if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_INTX)
-			free_irq(adev->host_irq, (void *)adev);
-
-		r = pci_enable_msi(adev->dev);
-		if (r)
-			return r;
+		if (!msi2intx) {
+			if (adev->irq_requested_type &
+					KVM_ASSIGNED_DEV_HOST_INTX)
+				free_irq(adev->host_irq, (void *)adev);
+
+			r = pci_enable_msi(adev->dev);
+			if (r)
+				return r;
+		}
 
 		adev->host_irq = adev->dev->irq;
 		if (request_irq(adev->host_irq, kvm_assigned_dev_intr, 0,
@@ -307,8 +323,10 @@ static int assigned_device_update_msi(struct kvm *kvm,
 			return -EIO;
 	}
 
-	adev->irq_requested_type = KVM_ASSIGNED_DEV_GUEST_MSI |
-				   KVM_ASSIGNED_DEV_HOST_MSI;
+	if (!msi2intx)
+		adev->irq_requested_type = KVM_ASSIGNED_DEV_GUEST_MSI;
+
+	adev->irq_requested_type |= KVM_ASSIGNED_DEV_HOST_MSI;
 	return 0;
 }
 #endif
@@ -346,10 +364,19 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 				goto out_release;
 			else
 				match->irq_source_id = r;
+
+#ifdef CONFIG_X86
+			/* Determine host device irq type, we can know the
+			 * result from dev->msi_enabled */
+			if (msi2intx)
+				pci_enable_msi(match->dev);
+#endif
 		}
 	}
 
-	if (assigned_irq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSI) {
+	if ((!msi2intx &&
+	     (assigned_irq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSI)) ||
+	    (msi2intx && match->dev->msi_enabled)) {
 #ifdef CONFIG_X86
 		r = assigned_device_update_msi(kvm, match, assigned_irq);
 		if (r) {
@@ -362,8 +389,16 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 #endif
 	} else if (assigned_irq->host_irq == 0 && match->dev->irq == 0) {
 		/* Host device IRQ 0 means don't support INTx */
-		printk(KERN_WARNING "kvm: wait device to enable MSI!\n");
-		r = 0;
+		if (!msi2intx) {
+			printk(KERN_WARNING
+			       "kvm: wait device to enable MSI!\n");
+			r = 0;
+		} else {
+			printk(KERN_WARNING
+			       "kvm: failed to enable MSI device!\n");
+			r = -ENOTTY;
+			goto out_release;
+		}
 	} else {
 		/* Non-sharing INTx mode */
 		r = assigned_device_update_intx(kvm, match, assigned_irq);
@@ -2209,6 +2244,9 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
+#ifndef CONFIG_X86
+	msi2intx = 0;
+#endif
 
 	return 0;
 
-- 
1.6.0.3

