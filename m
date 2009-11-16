Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZKPM1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZKPM1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZKPMUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 28/42] KVM: fix lock imbalance in kvm_*_irq_source_id()
Date: Mon, 16 Nov 2009 14:19:29 +0200
Message-Id: <1258373983-8693-29-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found 2 lock imbalances in kvm_request_irq_source_id and
kvm_free_irq_source_id. They omit to unlock kvm->irq_lock on fail paths.

Fix that by adding unlock labels at the end of the functions and jump
there from the fail paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 15a83b9..00c68d2 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -220,11 +220,13 @@ int kvm_request_irq_source_id(struct kvm *kvm)
 
 	if (irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
 		printk(KERN_WARNING "kvm: exhaust allocatable IRQ sources!\n");
-		return -EFAULT;
+		irq_source_id = -EFAULT;
+		goto unlock;
 	}
 
 	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
 	set_bit(irq_source_id, bitmap);
+unlock:
 	mutex_unlock(&kvm->irq_lock);
 
 	return irq_source_id;
@@ -240,7 +242,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 	if (irq_source_id < 0 ||
 	    irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
-		return;
+		goto unlock;
 	}
 	for (i = 0; i < KVM_IOAPIC_NUM_PINS; i++) {
 		clear_bit(irq_source_id, &kvm->arch.vioapic->irq_states[i]);
@@ -251,6 +253,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 #endif
 	}
 	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
+unlock:
 	mutex_unlock(&kvm->irq_lock);
 }
 
-- 
1.6.5.2

