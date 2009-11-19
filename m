Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZKSNjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZKSNjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZKSNjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 30/35] KVM: only clear irq_source_id if irqchip is present
Date: Thu, 19 Nov 2009 15:35:06 +0200
Message-Id: <1258637711-11674-31-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Otherwise kvm might attempt to dereference a NULL pointer.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 0d454d3..9b07734 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -243,6 +243,10 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
 		goto unlock;
 	}
+	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
+	if (!irqchip_in_kernel(kvm))
+		goto unlock;
+
 	for (i = 0; i < KVM_IOAPIC_NUM_PINS; i++) {
 		clear_bit(irq_source_id, &kvm->arch.vioapic->irq_states[i]);
 		if (i >= 16)
@@ -251,7 +255,6 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 		clear_bit(irq_source_id, &pic_irqchip(kvm)->irq_states[i]);
 #endif
 	}
-	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
 unlock:
 	mutex_unlock(&kvm->irq_lock);
 }
-- 
1.6.5.2

