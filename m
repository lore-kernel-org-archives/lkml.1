Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbYE3K20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbYE3K20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYE3K1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:27:54 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:45208
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYE3K1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:27:52 -0400
From: Amit Shah <amit.shah@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, benami@il.ibm.com,
       allen.m.kay@intel.com, chrisw@redhat.com,
       Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 2/3] KVM: Introduce kvm_set_irq to inject interrupts in guests
Date: Fri, 30 May 2008 13:27:49 +0300
Message-Id: <1212143270-18333-2-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212143270-18333-1-git-send-email-amit.shah@qumranet.com>
References: <1212143270-18333-1-git-send-email-amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function injects an interrupt into the guest given the kvm struct,
the (guest) irq number and the interrupt level.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
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
index 2a15be2..ba4e3bf 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -80,6 +80,8 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 
 void kvm_pic_reset(struct kvm_kpic_state *s);
 
+void kvm_set_irq(struct kvm *kvm, int irq, int level);
+
 void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
-- 
1.5.5.1

