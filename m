Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZEXP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZEXP57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbZEXPxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:53:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41841 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 23/45] KVM: protect assigned dev workqueue, int handler and irq acker
Date: Sun, 24 May 2009 18:50:08 +0300
Message-Id: <1243180230-2480-24-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

kvm_assigned_dev_ack_irq is vulnerable to a race condition with the
interrupt handler function. It does:

        if (dev->host_irq_disabled) {
                enable_irq(dev->host_irq);
                dev->host_irq_disabled = false;
        }

If an interrupt triggers before the host->dev_irq_disabled assignment,
it will disable the interrupt and set dev->host_irq_disabled to true.

On return to kvm_assigned_dev_ack_irq, dev->host_irq_disabled is set to
false, and the next kvm_assigned_dev_ack_irq call will fail to reenable
it.

Other than that, having the interrupt handler and work handlers run in
parallel sounds like asking for trouble (could not spot any obvious
problem, but better not have to, its fragile).

CC: sheng.yang@intel.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1618162..aacc544 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -345,6 +345,7 @@ struct kvm_assigned_dev_kernel {
 	int flags;
 	struct pci_dev *dev;
 	struct kvm *kvm;
+	spinlock_t assigned_dev_lock;
 };
 
 struct kvm_irq_mask_notifier {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2b73e19..4d00942 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -42,6 +42,7 @@
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/bitops.h>
+#include <linux/spinlock.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -130,6 +131,7 @@ static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 	 * finer-grained lock, update this
 	 */
 	mutex_lock(&kvm->lock);
+	spin_lock_irq(&assigned_dev->assigned_dev_lock);
 	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) {
 		struct kvm_guest_msix_entry *guest_entries =
 			assigned_dev->guest_msix_entries;
@@ -156,18 +158,21 @@ static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 		}
 	}
 
+	spin_unlock_irq(&assigned_dev->assigned_dev_lock);
 	mutex_unlock(&assigned_dev->kvm->lock);
 }
 
 static irqreturn_t kvm_assigned_dev_intr(int irq, void *dev_id)
 {
+	unsigned long flags;
 	struct kvm_assigned_dev_kernel *assigned_dev =
 		(struct kvm_assigned_dev_kernel *) dev_id;
 
+	spin_lock_irqsave(&assigned_dev->assigned_dev_lock, flags);
 	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) {
 		int index = find_index_from_host_irq(assigned_dev, irq);
 		if (index < 0)
-			return IRQ_HANDLED;
+			goto out;
 		assigned_dev->guest_msix_entries[index].flags |=
 			KVM_ASSIGNED_MSIX_PENDING;
 	}
@@ -177,6 +182,8 @@ static irqreturn_t kvm_assigned_dev_intr(int irq, void *dev_id)
 	disable_irq_nosync(irq);
 	assigned_dev->host_irq_disabled = true;
 
+out:
+	spin_unlock_irqrestore(&assigned_dev->assigned_dev_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -184,6 +191,7 @@ static irqreturn_t kvm_assigned_dev_intr(int irq, void *dev_id)
 static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 {
 	struct kvm_assigned_dev_kernel *dev;
+	unsigned long flags;
 
 	if (kian->gsi == -1)
 		return;
@@ -196,10 +204,12 @@ static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 	/* The guest irq may be shared so this ack may be
 	 * from another device.
 	 */
+	spin_lock_irqsave(&dev->assigned_dev_lock, flags);
 	if (dev->host_irq_disabled) {
 		enable_irq(dev->host_irq);
 		dev->host_irq_disabled = false;
 	}
+	spin_unlock_irqrestore(&dev->assigned_dev_lock, flags);
 }
 
 static void deassign_guest_irq(struct kvm *kvm,
@@ -615,6 +625,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	match->host_devfn = assigned_dev->devfn;
 	match->flags = assigned_dev->flags;
 	match->dev = dev;
+	spin_lock_init(&match->assigned_dev_lock);
 	match->irq_source_id = -1;
 	match->kvm = kvm;
 	match->ack_notifier.irq_acked = kvm_assigned_dev_ack_irq;
-- 
1.6.0.6

