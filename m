Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZKPM3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZKPM3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZKPM3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:29:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZKPMTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:40 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 08/42] KVM: Call pic_clear_isr() on pic reset to reuse logic there
Date: Mon, 16 Nov 2009 14:19:09 +0200
Message-Id: <1258373983-8693-9-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Also move call of ack notifiers after pic state change.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 01f1516..ccc941a 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -225,22 +225,11 @@ int kvm_pic_read_irq(struct kvm *kvm)
 
 void kvm_pic_reset(struct kvm_kpic_state *s)
 {
-	int irq, irqbase, n;
+	int irq;
 	struct kvm *kvm = s->pics_state->irq_request_opaque;
 	struct kvm_vcpu *vcpu0 = kvm->bsp_vcpu;
+	u8 irr = s->irr, isr = s->imr;
 
-	if (s == &s->pics_state->pics[0])
-		irqbase = 0;
-	else
-		irqbase = 8;
-
-	for (irq = 0; irq < PIC_NUM_PINS/2; irq++) {
-		if (vcpu0 && kvm_apic_accept_pic_intr(vcpu0))
-			if (s->irr & (1 << irq) || s->isr & (1 << irq)) {
-				n = irq + irqbase;
-				kvm_notify_acked_irq(kvm, SELECT_PIC(n), n);
-			}
-	}
 	s->last_irr = 0;
 	s->irr = 0;
 	s->imr = 0;
@@ -256,6 +245,13 @@ void kvm_pic_reset(struct kvm_kpic_state *s)
 	s->rotate_on_auto_eoi = 0;
 	s->special_fully_nested_mode = 0;
 	s->init4 = 0;
+
+	for (irq = 0; irq < PIC_NUM_PINS/2; irq++) {
+		if (vcpu0 && kvm_apic_accept_pic_intr(vcpu0))
+			if (irr & (1 << irq) || isr & (1 << irq)) {
+				pic_clear_isr(s, irq);
+			}
+	}
 }
 
 static void pic_ioport_write(void *opaque, u32 addr, u32 val)
-- 
1.6.5.2

