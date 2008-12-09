Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYLIUil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYLIUil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYLIUY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 36/44] KVM: Separate update irq to a single function
Date: Tue,  9 Dec 2008 22:22:51 +0200
Message-Id: <1228854179-23002-37-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Separate INTx enabling part to a independence function, so that we can add MSI
enabling part easily.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   68 ++++++++++++++++++++++++++++----------------------
 1 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8966fd1..ef2f03c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -176,6 +176,41 @@ void kvm_free_all_assigned_devices(struct kvm *kvm)
 	}
 }
 
+static int assigned_device_update_intx(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *adev,
+			struct kvm_assigned_irq *airq)
+{
+	if (adev->irq_requested) {
+		adev->guest_irq = airq->guest_irq;
+		adev->ack_notifier.gsi = airq->guest_irq;
+		return 0;
+	}
+
+	if (irqchip_in_kernel(kvm)) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+
+		if (airq->host_irq)
+			adev->host_irq = airq->host_irq;
+		else
+			adev->host_irq = adev->dev->irq;
+		adev->guest_irq = airq->guest_irq;
+		adev->ack_notifier.gsi = airq->guest_irq;
+
+		/* Even though this is PCI, we don't want to use shared
+		 * interrupts. Sharing host devices with guest-assigned devices
+		 * on the same interrupt line is not a happy situation: there
+		 * are going to be long delays in accepting, acking, etc.
+		 */
+		if (request_irq(adev->host_irq, kvm_assigned_dev_intr,
+				0, "kvm_assigned_intx_device", (void *)adev))
+			return -EIO;
+	}
+
+	adev->irq_requested = true;
+	return 0;
+}
+
 static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 				   struct kvm_assigned_irq
 				   *assigned_irq)
@@ -210,39 +245,12 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 			else
 				match->irq_source_id = r;
 		}
-	} else {
-		match->guest_irq = assigned_irq->guest_irq;
-		match->ack_notifier.gsi = assigned_irq->guest_irq;
-		mutex_unlock(&kvm->lock);
-		return 0;
 	}
 
-	if (irqchip_in_kernel(kvm)) {
-		if (!capable(CAP_SYS_RAWIO)) {
-			r = -EPERM;
-			goto out_release;
-		}
-
-		if (assigned_irq->host_irq)
-			match->host_irq = assigned_irq->host_irq;
-		else
-			match->host_irq = match->dev->irq;
-		match->guest_irq = assigned_irq->guest_irq;
-		match->ack_notifier.gsi = assigned_irq->guest_irq;
-
-		/* Even though this is PCI, we don't want to use shared
-		 * interrupts. Sharing host devices with guest-assigned devices
-		 * on the same interrupt line is not a happy situation: there
-		 * are going to be long delays in accepting, acking, etc.
-		 */
-		if (request_irq(match->host_irq, kvm_assigned_dev_intr, 0,
-				"kvm_assigned_device", (void *)match)) {
-			r = -EIO;
-			goto out_release;
-		}
-	}
+	r = assigned_device_update_intx(kvm, match, assigned_irq);
+	if (r)
+		goto out_release;
 
-	match->irq_requested = true;
 	mutex_unlock(&kvm->lock);
 	return r;
 out_release:
-- 
1.6.0.3

