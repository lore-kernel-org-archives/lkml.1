Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZHZKlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZHZKlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbZHZKkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815AbZHZKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/47] KVM: Call ack notifiers from PIC when guest OS acks an IRQ.
Date: Wed, 26 Aug 2009 13:29:31 +0300
Message-Id: <1251282609-12835-10-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Currently they are called when irq vector is been delivered.  Calling ack
notifiers at this point is wrong.  Device assignment ack notifier enables
host interrupts, but guest not yet had a chance to clear interrupt
condition in a device.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index d27320c..3aacd33 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -41,25 +41,16 @@ static void pic_lock(struct kvm_pic *s)
 static void pic_unlock(struct kvm_pic *s)
 	__releases(&s->lock)
 {
-	struct kvm *kvm = s->kvm;
-	unsigned acks = s->pending_acks;
-	struct kvm_vcpu *vcpu;
-
-	s->pending_acks = 0;
-
 	spin_unlock(&s->lock);
-
-	while (acks) {
-		kvm_notify_acked_irq(kvm, SELECT_PIC(__ffs(acks)),
-				     __ffs(acks));
-		acks &= acks - 1;
-	}
 }
 
 static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
 {
 	s->isr &= ~(1 << irq);
 	s->isr_ack |= (1 << irq);
+	if (s != &s->pics_state->pics[0])
+		irq += 8;
+	kvm_notify_acked_irq(s->pics_state->kvm, SELECT_PIC(irq), irq);
 }
 
 void kvm_pic_clear_isr_ack(struct kvm *kvm)
@@ -240,7 +231,6 @@ int kvm_pic_read_irq(struct kvm *kvm)
 	}
 	pic_update_irq(s);
 	pic_unlock(s);
-	kvm_notify_acked_irq(kvm, SELECT_PIC(irq), irq);
 
 	return intno;
 }
@@ -260,7 +250,7 @@ void kvm_pic_reset(struct kvm_kpic_state *s)
 		if (vcpu0 && kvm_apic_accept_pic_intr(vcpu0))
 			if (s->irr & (1 << irq) || s->isr & (1 << irq)) {
 				n = irq + irqbase;
-				s->pics_state->pending_acks |= 1 << n;
+				kvm_notify_acked_irq(kvm, SELECT_PIC(n), n);
 			}
 	}
 	s->last_irr = 0;
-- 
1.6.4.1

