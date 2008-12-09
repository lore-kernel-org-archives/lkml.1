Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYLIUeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYLIUeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYLIUYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34886 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 35/44] KVM: Move ack notifier register and IRQ sourcd ID request
Date: Tue,  9 Dec 2008 22:22:50 +0200
Message-Id: <1228854179-23002-36-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Distinguish common part for device assignment and INTx part, perparing for
refactor later.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4727c08..8966fd1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -192,16 +192,31 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 		return -EINVAL;
 	}
 
-	if (match->irq_requested) {
+	if (!match->irq_requested) {
+		INIT_WORK(&match->interrupt_work,
+				kvm_assigned_dev_interrupt_work_handler);
+		if (irqchip_in_kernel(kvm)) {
+			/* Register ack nofitier */
+			match->ack_notifier.gsi = -1;
+			match->ack_notifier.irq_acked =
+					kvm_assigned_dev_ack_irq;
+			kvm_register_irq_ack_notifier(kvm,
+					&match->ack_notifier);
+
+			/* Request IRQ source ID */
+			r = kvm_request_irq_source_id(kvm);
+			if (r < 0)
+				goto out_release;
+			else
+				match->irq_source_id = r;
+		}
+	} else {
 		match->guest_irq = assigned_irq->guest_irq;
 		match->ack_notifier.gsi = assigned_irq->guest_irq;
 		mutex_unlock(&kvm->lock);
 		return 0;
 	}
 
-	INIT_WORK(&match->interrupt_work,
-		  kvm_assigned_dev_interrupt_work_handler);
-
 	if (irqchip_in_kernel(kvm)) {
 		if (!capable(CAP_SYS_RAWIO)) {
 			r = -EPERM;
@@ -214,13 +229,6 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 			match->host_irq = match->dev->irq;
 		match->guest_irq = assigned_irq->guest_irq;
 		match->ack_notifier.gsi = assigned_irq->guest_irq;
-		match->ack_notifier.irq_acked = kvm_assigned_dev_ack_irq;
-		kvm_register_irq_ack_notifier(kvm, &match->ack_notifier);
-		r = kvm_request_irq_source_id(kvm);
-		if (r < 0)
-			goto out_release;
-		else
-			match->irq_source_id = r;
 
 		/* Even though this is PCI, we don't want to use shared
 		 * interrupts. Sharing host devices with guest-assigned devices
-- 
1.6.0.3

