Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZERJ2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZERJ2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZERJX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 09/43] KVM: Add MSI-X interrupt injection logic
Date: Mon, 18 May 2009 12:22:31 +0300
Message-Id: <1242638585-18470-10-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

We have to handle more than one interrupt with one handler for MSI-X. Avi
suggested to use a flag to indicate the pending. So here is it.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   66 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 432edc2..3832243 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -319,6 +319,7 @@ struct kvm_irq_ack_notifier {
 	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
 };
 
+#define KVM_ASSIGNED_MSIX_PENDING		0x1
 struct kvm_guest_msix_entry {
 	u32 vector;
 	u16 entry;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd33def..7c20e06 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -95,25 +95,69 @@ static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *h
 	return NULL;
 }
 
+static int find_index_from_host_irq(struct kvm_assigned_dev_kernel
+				    *assigned_dev, int irq)
+{
+	int i, index;
+	struct msix_entry *host_msix_entries;
+
+	host_msix_entries = assigned_dev->host_msix_entries;
+
+	index = -1;
+	for (i = 0; i < assigned_dev->entries_nr; i++)
+		if (irq == host_msix_entries[i].vector) {
+			index = i;
+			break;
+		}
+	if (index < 0) {
+		printk(KERN_WARNING "Fail to find correlated MSI-X entry!\n");
+		return 0;
+	}
+
+	return index;
+}
+
 static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 {
 	struct kvm_assigned_dev_kernel *assigned_dev;
+	struct kvm *kvm;
+	int irq, i;
 
 	assigned_dev = container_of(work, struct kvm_assigned_dev_kernel,
 				    interrupt_work);
+	kvm = assigned_dev->kvm;
 
 	/* This is taken to safely inject irq inside the guest. When
 	 * the interrupt injection (or the ioapic code) uses a
 	 * finer-grained lock, update this
 	 */
-	mutex_lock(&assigned_dev->kvm->lock);
-	kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
-		    assigned_dev->guest_irq, 1);
-
-	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_GUEST_MSI) {
-		enable_irq(assigned_dev->host_irq);
-		assigned_dev->host_irq_disabled = false;
+	mutex_lock(&kvm->lock);
+	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_MSIX) {
+		struct kvm_guest_msix_entry *guest_entries =
+			assigned_dev->guest_msix_entries;
+		for (i = 0; i < assigned_dev->entries_nr; i++) {
+			if (!(guest_entries[i].flags &
+					KVM_ASSIGNED_MSIX_PENDING))
+				continue;
+			guest_entries[i].flags &= ~KVM_ASSIGNED_MSIX_PENDING;
+			kvm_set_irq(assigned_dev->kvm,
+				    assigned_dev->irq_source_id,
+				    guest_entries[i].vector, 1);
+			irq = assigned_dev->host_msix_entries[i].vector;
+			if (irq != 0)
+				enable_irq(irq);
+			assigned_dev->host_irq_disabled = false;
+		}
+	} else {
+		kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
+			    assigned_dev->guest_irq, 1);
+		if (assigned_dev->irq_requested_type &
+				KVM_ASSIGNED_DEV_GUEST_MSI) {
+			enable_irq(assigned_dev->host_irq);
+			assigned_dev->host_irq_disabled = false;
+		}
 	}
+
 	mutex_unlock(&assigned_dev->kvm->lock);
 }
 
@@ -122,6 +166,14 @@ static irqreturn_t kvm_assigned_dev_intr(int irq, void *dev_id)
 	struct kvm_assigned_dev_kernel *assigned_dev =
 		(struct kvm_assigned_dev_kernel *) dev_id;
 
+	if (assigned_dev->irq_requested_type == KVM_ASSIGNED_DEV_MSIX) {
+		int index = find_index_from_host_irq(assigned_dev, irq);
+		if (index < 0)
+			return IRQ_HANDLED;
+		assigned_dev->guest_msix_entries[index].flags |=
+			KVM_ASSIGNED_MSIX_PENDING;
+	}
+
 	schedule_work(&assigned_dev->interrupt_work);
 
 	disable_irq_nosync(irq);
-- 
1.6.0.6

