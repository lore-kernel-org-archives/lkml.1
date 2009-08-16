Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZHPJhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZHPJhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZHPJh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:37:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45347 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbZHPJaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/48] KVM: No disable_irq for MSI/MSI-X interrupt on device assignment
Date: Sun, 16 Aug 2009 12:29:39 +0300
Message-Id: <1250415008-17175-20-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Disable interrupt at interrupt handler and enable it when guest ack is for
the level triggered interrupt, to prevent reinjected interrupt. MSI/MSI-X don't
need it.

One possible problem is multiply same vector interrupt injected between irq
handler and scheduled work handler would be merged as one for MSI/MSI-X.
But AFAIK, the drivers handle it well.

The patch fixed the oplin card performance issue(MSI-X performance is half of
MSI/INTx).

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dee321e..2d9bc43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -120,7 +120,7 @@ static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 {
 	struct kvm_assigned_dev_kernel *assigned_dev;
 	struct kvm *kvm;
-	int irq, i;
+	int i;
 
 	assigned_dev = container_of(work, struct kvm_assigned_dev_kernel,
 				    interrupt_work);
@@ -143,20 +143,10 @@ static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 			kvm_set_irq(assigned_dev->kvm,
 				    assigned_dev->irq_source_id,
 				    guest_entries[i].vector, 1);
-			irq = assigned_dev->host_msix_entries[i].vector;
-			if (irq != 0)
-				enable_irq(irq);
-			assigned_dev->host_irq_disabled = false;
 		}
-	} else {
+	} else
 		kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
 			    assigned_dev->guest_irq, 1);
-		if (assigned_dev->irq_requested_type &
-				KVM_DEV_IRQ_GUEST_MSI) {
-			enable_irq(assigned_dev->host_irq);
-			assigned_dev->host_irq_disabled = false;
-		}
-	}
 
 	spin_unlock_irq(&assigned_dev->assigned_dev_lock);
 	mutex_unlock(&assigned_dev->kvm->lock);
@@ -179,8 +169,10 @@ static irqreturn_t kvm_assigned_dev_intr(int irq, void *dev_id)
 
 	schedule_work(&assigned_dev->interrupt_work);
 
-	disable_irq_nosync(irq);
-	assigned_dev->host_irq_disabled = true;
+	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_GUEST_INTX) {
+		disable_irq_nosync(irq);
+		assigned_dev->host_irq_disabled = true;
+	}
 
 out:
 	spin_unlock_irqrestore(&assigned_dev->assigned_dev_lock, flags);
@@ -417,6 +409,7 @@ static int assigned_device_enable_guest_msi(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
+	dev->host_irq_disabled = false;
 	return 0;
 }
 #endif
@@ -427,6 +420,7 @@ static int assigned_device_enable_guest_msix(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
+	dev->host_irq_disabled = false;
 	return 0;
 }
 #endif
-- 
1.6.3.3

