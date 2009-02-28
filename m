Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZB1Bw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZB1Bw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbZB1BnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:43:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41776 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbZB1Bl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:58 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/30] KVM: Report IRQ injection status for MSI delivered interrupts
Date: Sat, 28 Feb 2009 03:41:40 +0200
Message-Id: <1235785309-12835-22-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Return number of CPUs interrupt was successfully injected into or -1 if
none.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index be8aba7..c516d61 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -48,7 +48,7 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		       struct kvm *kvm, int level)
 {
-	int vcpu_id;
+	int vcpu_id, r = -1;
 	struct kvm_vcpu *vcpu;
 	struct kvm_ioapic *ioapic = ioapic_irqchip(kvm);
 	int dest_id = (e->msi.address_lo & MSI_ADDR_DEST_ID_MASK)
@@ -73,7 +73,7 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm, vector,
 				deliver_bitmask);
 		if (vcpu != NULL)
-			kvm_apic_set_irq(vcpu, vector, trig_mode);
+			r = kvm_apic_set_irq(vcpu, vector, trig_mode);
 		else
 			printk(KERN_INFO "kvm: null lowest priority vcpu!\n");
 		break;
@@ -83,14 +83,17 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 				continue;
 			deliver_bitmask &= ~(1 << vcpu_id);
 			vcpu = ioapic->kvm->vcpus[vcpu_id];
-			if (vcpu)
-				kvm_apic_set_irq(vcpu, vector, trig_mode);
+			if (vcpu) {
+				if (r < 0)
+					r = 0;
+				r += kvm_apic_set_irq(vcpu, vector, trig_mode);
+			}
 		}
 		break;
 	default:
 		break;
 	}
-	return 1;
+	return r;
 }
 
 /* This should be called with the kvm->lock mutex held
-- 
1.6.0.6

