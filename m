Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0BJR3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:29:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/40] KVM: powerpc: Move vector to irqprio resolving to separate function
Date: Wed, 10 Feb 2010 19:22:50 +0200
Message-Id: <1265822589-11155-22-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

We're using a switch table to find the irqprio that belongs to a specific
interrupt vector. This table is part of the interrupt inject logic.

Since we'll add a new function to stop interrupts, let's move this table
out of the injection logic into a separate function.

Signed-off-by: Alexander Graf <agraf@suse.de>
Acked-by: Acked-by: Hollis Blanchard <hollis@penguinppc.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/book3s.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 3e294bd..241795b 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -125,11 +125,10 @@ void kvmppc_inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 flags)
 	vcpu->arch.mmu.reset_msr(vcpu);
 }
 
-void kvmppc_book3s_queue_irqprio(struct kvm_vcpu *vcpu, unsigned int vec)
+static int kvmppc_book3s_vec2irqprio(unsigned int vec)
 {
 	unsigned int prio;
 
-	vcpu->stat.queue_intr++;
 	switch (vec) {
 	case 0x100: prio = BOOK3S_IRQPRIO_SYSTEM_RESET;		break;
 	case 0x200: prio = BOOK3S_IRQPRIO_MACHINE_CHECK;	break;
@@ -149,7 +148,15 @@ void kvmppc_book3s_queue_irqprio(struct kvm_vcpu *vcpu, unsigned int vec)
 	default:    prio = BOOK3S_IRQPRIO_MAX;			break;
 	}
 
-	set_bit(prio, &vcpu->arch.pending_exceptions);
+	return prio;
+}
+
+void kvmppc_book3s_queue_irqprio(struct kvm_vcpu *vcpu, unsigned int vec)
+{
+	vcpu->stat.queue_intr++;
+
+	set_bit(kvmppc_book3s_vec2irqprio(vec),
+		&vcpu->arch.pending_exceptions);
 #ifdef EXIT_DEBUG
 	printk(KERN_INFO "Queueing interrupt %x\n", vec);
 #endif
-- 
1.6.5.3

