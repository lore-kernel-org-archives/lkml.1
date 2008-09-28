Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYI1PuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYI1PuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYI1Ppy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50885 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYI1Ppu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 21/25] KVM: Device Assignment: Free device structures if IRQ allocation fails
Date: Sun, 28 Sep 2008 18:44:57 +0300
Message-Id: <1222616701-1206-22-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

When an IRQ allocation fails, we free up the device structures and
disable the device so that we can unregister the device in the
userspace and not expose it to the guest at all.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   86 +++++++++++++++++++++++++++-------------------------
 1 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c8a2793..61eddbe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -166,6 +166,43 @@ static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 	enable_irq(dev->host_irq);
 }
 
+static void kvm_free_assigned_device(struct kvm *kvm,
+				     struct kvm_assigned_dev_kernel
+				     *assigned_dev)
+{
+	if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested)
+		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
+
+	kvm_unregister_irq_ack_notifier(kvm, &assigned_dev->ack_notifier);
+
+	if (cancel_work_sync(&assigned_dev->interrupt_work))
+		/* We had pending work. That means we will have to take
+		 * care of kvm_put_kvm.
+		 */
+		kvm_put_kvm(kvm);
+
+	pci_release_regions(assigned_dev->dev);
+	pci_disable_device(assigned_dev->dev);
+	pci_dev_put(assigned_dev->dev);
+
+	list_del(&assigned_dev->list);
+	kfree(assigned_dev);
+}
+
+static void kvm_free_all_assigned_devices(struct kvm *kvm)
+{
+	struct list_head *ptr, *ptr2;
+	struct kvm_assigned_dev_kernel *assigned_dev;
+
+	list_for_each_safe(ptr, ptr2, &kvm->arch.assigned_dev_head) {
+		assigned_dev = list_entry(ptr,
+					  struct kvm_assigned_dev_kernel,
+					  list);
+
+		kvm_free_assigned_device(kvm, assigned_dev);
+	}
+}
+
 static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 				   struct kvm_assigned_irq
 				   *assigned_irq)
@@ -194,8 +231,8 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 
 	if (irqchip_in_kernel(kvm)) {
 		if (!capable(CAP_SYS_RAWIO)) {
-			return -EPERM;
-			goto out;
+			r = -EPERM;
+			goto out_release;
 		}
 
 		if (assigned_irq->host_irq)
@@ -214,17 +251,18 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 		 */
 		if (request_irq(match->host_irq, kvm_assigned_dev_intr, 0,
 				"kvm_assigned_device", (void *)match)) {
-			printk(KERN_INFO "%s: couldn't allocate irq for pv "
-			       "device\n", __func__);
 			r = -EIO;
-			goto out;
+			goto out_release;
 		}
 	}
 
 	match->irq_requested = true;
-out:
 	mutex_unlock(&kvm->lock);
 	return r;
+out_release:
+	mutex_unlock(&kvm->lock);
+	kvm_free_assigned_device(kvm, match);
+	return r;
 }
 
 static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
@@ -300,40 +338,6 @@ out_free:
 	return r;
 }
 
-static void kvm_free_assigned_devices(struct kvm *kvm)
-{
-	struct list_head *ptr, *ptr2;
-	struct kvm_assigned_dev_kernel *assigned_dev;
-
-	list_for_each_safe(ptr, ptr2, &kvm->arch.assigned_dev_head) {
-		assigned_dev = list_entry(ptr,
-					  struct kvm_assigned_dev_kernel,
-					  list);
-
-		if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested) {
-			free_irq(assigned_dev->host_irq,
-				 (void *)assigned_dev);
-
-			kvm_unregister_irq_ack_notifier(kvm,
-							&assigned_dev->
-							ack_notifier);
-		}
-
-		if (cancel_work_sync(&assigned_dev->interrupt_work))
-			/* We had pending work. That means we will have to take
-			 * care of kvm_put_kvm.
-			 */
-			kvm_put_kvm(kvm);
-
-		pci_release_regions(assigned_dev->dev);
-		pci_disable_device(assigned_dev->dev);
-		pci_dev_put(assigned_dev->dev);
-
-		list_del(&assigned_dev->list);
-		kfree(assigned_dev);
-	}
-}
-
 unsigned long segment_base(u16 selector)
 {
 	struct descriptor_table gdt;
@@ -4296,7 +4300,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_iommu_unmap_guest(kvm);
-	kvm_free_assigned_devices(kvm);
+	kvm_free_all_assigned_devices(kvm);
 	kvm_free_pit(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
-- 
1.6.0.1

