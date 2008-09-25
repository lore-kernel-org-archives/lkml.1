Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYIYL53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYIYL53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYIYLzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbYIYLze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 06/39] KVM: fix i8259 reset irq acking
Date: Thu, 25 Sep 2008 14:54:38 +0300
Message-Id: <1222343711-12508-7-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

The irq ack during pic reset has three problems:

- Ignores slave/master PIC, using gsi 0-8 for both.
- Generates an ACK even if the APIC is in control.
- Depends upon IMR being clear, which is broken if the irq was masked
at the time it was generated.

The last one causes the BIOS to hang after the first reboot of
Windows installation, since PIT interrupts stop.

[avi: fix check whether pic interrupts are seen by cpu]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8259.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index de70499..71e3eee 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -195,13 +195,19 @@ int kvm_pic_read_irq(struct kvm *kvm)
 
 void kvm_pic_reset(struct kvm_kpic_state *s)
 {
-	int irq;
+	int irq, irqbase;
 	struct kvm *kvm = s->pics_state->irq_request_opaque;
+	struct kvm_vcpu *vcpu0 = kvm->vcpus[0];
 
-	for (irq = 0; irq < PIC_NUM_PINS; irq++) {
-		if (!(s->imr & (1 << irq)) && (s->irr & (1 << irq) ||
-		    s->isr & (1 << irq)))
-			kvm_notify_acked_irq(kvm, irq);
+	if (s == &s->pics_state->pics[0])
+		irqbase = 0;
+	else
+		irqbase = 8;
+
+	for (irq = 0; irq < PIC_NUM_PINS/2; irq++) {
+		if (vcpu0 && kvm_apic_accept_pic_intr(vcpu0))
+			if (s->irr & (1 << irq) || s->isr & (1 << irq))
+				kvm_notify_acked_irq(kvm, irq+irqbase);
 	}
 	s->last_irr = 0;
 	s->irr = 0;
-- 
1.6.0.1

