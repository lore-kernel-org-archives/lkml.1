Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbXIQIto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbXIQIto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXIQIdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:45251 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Qing He <qing.he@intel.com>
Subject: [PATCH 079/104] KVM: deliver PIC interrupt only to vcpu0
Date: Mon, 17 Sep 2007 10:32:01 +0200
Message-Id: <11900179493098-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing He <qing.he@intel.com>

This patch changes the PIC interrupts delivery. Now it is only delivered
to vcpu0 when either condition is met (on vcpu0):
  1. local APIC is hardware disabled
  2. LVT0 is unmasked and configured to delivery mode ExtInt

It fixes the 2x faster wall clock on x86_64 and SMP i386 Linux guests

Signed-off-by: Eddie (Yaozu) Dong <eddie.dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.c   |   15 ++++++++++-----
 drivers/kvm/irq.h   |    1 +
 drivers/kvm/lapic.c |   17 +++++++++++++++++
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
index b88e501..7628c7f 100644
--- a/drivers/kvm/irq.c
+++ b/drivers/kvm/irq.c
@@ -33,8 +33,11 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	struct kvm_pic *s;
 
 	if (kvm_apic_has_interrupt(v) == -1) {	/* LAPIC */
-		s = pic_irqchip(v->kvm);	/* PIC */
-		return s->output;
+		if (kvm_apic_accept_pic_intr(v)) {
+			s = pic_irqchip(v->kvm);	/* PIC */
+			return s->output;
+		} else
+			return 0;
 	}
 	return 1;
 }
@@ -50,9 +53,11 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 
 	vector = kvm_get_apic_interrupt(v);	/* APIC */
 	if (vector == -1) {
-		s = pic_irqchip(v->kvm);
-		s->output = 0;		/* PIC */
-		vector = kvm_pic_read_irq(s);
+		if (kvm_apic_accept_pic_intr(v)) {
+			s = pic_irqchip(v->kvm);
+			s->output = 0;		/* PIC */
+			vector = kvm_pic_read_irq(s);
+		}
 	}
 	return vector;
 }
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index f324cfb..ec46a09 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -135,6 +135,7 @@ do {									\
 
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
+int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_free_apic(struct kvm_lapic *apic);
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 2706ec3..01e7696 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -788,6 +788,8 @@ static void lapic_reset(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < APIC_LVT_NUM; i++)
 		apic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
+	apic_set_reg(apic, APIC_LVT0,
+		     SET_APIC_DELIVERY_MODE(0, APIC_MODE_EXTINT));
 
 	apic_set_reg(apic, APIC_DFR, 0xffffffffU);
 	apic_set_reg(apic, APIC_SPIV, 0xff);
@@ -932,6 +934,21 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return highest_irr;
 }
 
+int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
+{
+	u32 lvt0 = apic_get_reg(vcpu->apic, APIC_LVT0);
+	int r = 0;
+
+	if (vcpu->vcpu_id == 0) {
+		if (!apic_hw_enabled(vcpu->apic))
+			r = 1;
+		if ((lvt0 & APIC_LVT_MASKED) == 0 &&
+		    GET_APIC_DELIVERY_MODE(lvt0) == APIC_MODE_EXTINT)
+			r = 1;
+	}
+	return r;
+}
+
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->apic;
-- 
1.5.3

