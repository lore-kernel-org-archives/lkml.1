Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYIWNsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYIWNsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYIWNrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52344 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbYIWNrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:05 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 04/40] KVM: Introduce kvm_set_irq to inject interrupts in guests
Date: Tue, 23 Sep 2008 16:46:18 +0300
Message-Id: <1222177614-26669-5-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

This function injects an interrupt into the guest given the kvm struct,
the (guest) irq number and the interrupt level.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/irq.c |   11 +++++++++++
 arch/x86/kvm/irq.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 76d736b..0d9e552 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -100,3 +100,14 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
 }
+
+/* This should be called with the kvm->lock mutex held */
+void kvm_set_irq(struct kvm *kvm, int irq, int level)
+{
+	/* Not possible to detect if the guest uses the PIC or the
+	 * IOAPIC.  So set the bit in both. The guest will ignore
+	 * writes to the unused one.
+	 */
+	kvm_ioapic_set_irq(kvm->arch.vioapic, irq, level);
+	kvm_pic_set_irq(pic_irqchip(kvm), irq, level);
+}
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 7ca47cb..07ff2ae 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -82,6 +82,8 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 
 void kvm_pic_reset(struct kvm_kpic_state *s);
 
+void kvm_set_irq(struct kvm *kvm, int irq, int level);
+
 void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
-- 
1.6.0.1

