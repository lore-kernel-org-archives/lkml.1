Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZIYHdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZIYHdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZIYHdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:33:37 -0400
Received: from server1.wserver.cz ([82.113.45.157]:44852 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZIYHdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:33:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/1] KVM: fix lock imbalance
Date: Fri, 25 Sep 2009 09:33:38 +0200
Message-Id: <1253864018-7547-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found 2 lock imbalances in kvm_request_irq_source_id and
kvm_free_irq_source_id. They omit to unlock kvm->irq_lock on fail paths.

Fix that by adding unlock labels at the end of the functions and jump
there from the fail paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
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
1.6.4.2

