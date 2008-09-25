Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYIYL7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYIYL7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYIYLzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48556 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbYIYLzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:44 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 14/39] KVM: Use kvm_set_irq to inject interrupts
Date: Thu, 25 Sep 2008 14:54:46 +0300
Message-Id: <1222343711-12508-15-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

... instead of using the pic and ioapic variants

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c |    6 ++----
 arch/x86/kvm/x86.c   |    8 +-------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index c842060..fdaa0f0 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -596,10 +596,8 @@ void kvm_free_pit(struct kvm *kvm)
 static void __inject_pit_timer_intr(struct kvm *kvm)
 {
 	mutex_lock(&kvm->lock);
-	kvm_ioapic_set_irq(kvm->arch.vioapic, 0, 1);
-	kvm_ioapic_set_irq(kvm->arch.vioapic, 0, 0);
-	kvm_pic_set_irq(pic_irqchip(kvm), 0, 1);
-	kvm_pic_set_irq(pic_irqchip(kvm), 0, 0);
+	kvm_set_irq(kvm, 0, 1);
+	kvm_set_irq(kvm, 0, 0);
 	mutex_unlock(&kvm->lock);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fffdf4f..5b3c882 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1956,13 +1956,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 		if (irqchip_in_kernel(kvm)) {
 			mutex_lock(&kvm->lock);
-			if (irq_event.irq < 16)
-				kvm_pic_set_irq(pic_irqchip(kvm),
-					irq_event.irq,
-					irq_event.level);
-			kvm_ioapic_set_irq(kvm->arch.vioapic,
-					irq_event.irq,
-					irq_event.level);
+			kvm_set_irq(kvm, irq_event.irq, irq_event.level);
 			mutex_unlock(&kvm->lock);
 			r = 0;
 		}
-- 
1.6.0.1

