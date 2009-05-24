Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZEXPvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZEXPvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZEXPuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:50:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41823 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 07/45] KVM: Fix userspace IRQ chip migration
Date: Sun, 24 May 2009 18:49:52 +0300
Message-Id: <1243180230-2480-8-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Re-put pending IRQ vector into interrupt_bitmap before migration.
Otherwise it will be lost if migration happens in the wrong time.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b3ecaf8..cf315e8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3562,17 +3562,17 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->efer = vcpu->arch.shadow_efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
-	if (irqchip_in_kernel(vcpu->kvm)) {
+	if (irqchip_in_kernel(vcpu->kvm))
 		memset(sregs->interrupt_bitmap, 0,
 		       sizeof sregs->interrupt_bitmap);
-		pending_vec = kvm_x86_ops->get_irq(vcpu);
-		if (pending_vec >= 0)
-			set_bit(pending_vec,
-				(unsigned long *)sregs->interrupt_bitmap);
-	} else
+	else
 		memcpy(sregs->interrupt_bitmap, vcpu->arch.irq_pending,
 		       sizeof sregs->interrupt_bitmap);
 
+	pending_vec = kvm_x86_ops->get_irq(vcpu);
+	if (pending_vec >= 0)
+		set_bit(pending_vec, (unsigned long *)sregs->interrupt_bitmap);
+
 	vcpu_put(vcpu);
 
 	return 0;
-- 
1.6.0.6

