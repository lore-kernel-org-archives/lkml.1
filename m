Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbZHZKim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbZHZKim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932445AbZHZKih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:38:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041AbZHZKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/47] KVM: Call kvm_vcpu_kick() inside pic spinlock
Date: Wed, 26 Aug 2009 13:29:30 +0300
Message-Id: <1251282609-12835-9-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

d5ecfdd25 moved it out because back than it was impossible to
call it inside spinlock. This restriction no longer exists.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c |   10 +---------
 arch/x86/kvm/irq.h   |    1 -
 2 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index daf4606..d27320c 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -43,11 +43,9 @@ static void pic_unlock(struct kvm_pic *s)
 {
 	struct kvm *kvm = s->kvm;
 	unsigned acks = s->pending_acks;
-	bool wakeup = s->wakeup_needed;
 	struct kvm_vcpu *vcpu;
 
 	s->pending_acks = 0;
-	s->wakeup_needed = false;
 
 	spin_unlock(&s->lock);
 
@@ -56,12 +54,6 @@ static void pic_unlock(struct kvm_pic *s)
 				     __ffs(acks));
 		acks &= acks - 1;
 	}
-
-	if (wakeup) {
-		vcpu = s->kvm->bsp_vcpu;
-		if (vcpu)
-			kvm_vcpu_kick(vcpu);
-	}
 }
 
 static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
@@ -527,7 +519,7 @@ static void pic_irq_request(void *opaque, int level)
 	s->output = level;
 	if (vcpu && level && (s->pics[0].isr_ack & (1 << irq))) {
 		s->pics[0].isr_ack &= ~(1 << irq);
-		s->wakeup_needed = true;
+		kvm_vcpu_kick(vcpu);
 	}
 }
 
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 9f59318..7d6058a 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -63,7 +63,6 @@ struct kvm_kpic_state {
 
 struct kvm_pic {
 	spinlock_t lock;
-	bool wakeup_needed;
 	unsigned pending_acks;
 	struct kvm *kvm;
 	struct kvm_kpic_state pics[2]; /* 0 is master pic, 1 is slave pic */
-- 
1.6.4.1

