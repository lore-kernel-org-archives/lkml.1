Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXLWO5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXLWO5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbXLWOv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:58 -0500
Received: from il.qumranet.com ([82.166.9.18]:35901 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 23/50] KVM: Add kvm_free_lapic() to pair with kvm_create_lapic()
Date: Sun, 23 Dec 2007 16:51:08 +0200
Message-Id: <1198421495-31481-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Instead of the asymetry of kvm_free_apic, implement kvm_free_lapic().
And guess what?  I found a minor bug: we don't need to hrtimer_cancel()
from kvm_main.c, because we do that in kvm_free_apic().

Also:
1) kvm_vcpu_uninit should be the reverse order from kvm_vcpu_init.
2) Don't set apic->regs_page to zero before freeing apic.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h      |    2 +-
 drivers/kvm/kvm_main.c |    4 +---
 drivers/kvm/lapic.c    |   19 +++++++++----------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 11fc014..508280e 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -139,7 +139,7 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu);
-void kvm_free_apic(struct kvm_lapic *apic);
+void kvm_free_lapic(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d220e63..760753d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -268,10 +268,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_init);
 
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
+	kvm_free_lapic(vcpu);
 	kvm_mmu_destroy(vcpu);
-	if (vcpu->apic)
-		hrtimer_cancel(&vcpu->apic->timer.dev);
-	kvm_free_apic(vcpu->apic);
 	free_page((unsigned long)vcpu->pio_data);
 	free_page((unsigned long)vcpu->run);
 }
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 238fcad..8e8dab0 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -762,19 +762,17 @@ static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr)
 	return ret;
 }
 
-void kvm_free_apic(struct kvm_lapic *apic)
+void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
-	if (!apic)
+	if (!vcpu->apic)
 		return;
 
-	hrtimer_cancel(&apic->timer.dev);
+	hrtimer_cancel(&vcpu->apic->timer.dev);
 
-	if (apic->regs_page) {
-		__free_page(apic->regs_page);
-		apic->regs_page = 0;
-	}
+	if (vcpu->apic->regs_page)
+		__free_page(vcpu->apic->regs_page);
 
-	kfree(apic);
+	kfree(vcpu->apic);
 }
 
 /*
@@ -962,7 +960,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	if (apic->regs_page == NULL) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
-		goto nomem;
+		goto nomem_free_apic;
 	}
 	apic->regs = page_address(apic->regs_page);
 	memset(apic->regs, 0, PAGE_SIZE);
@@ -980,8 +978,9 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	apic->dev.private = apic;
 
 	return 0;
+nomem_free_apic:
+	kfree(apic);
 nomem:
-	kvm_free_apic(apic);
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(kvm_create_lapic);
-- 
1.5.3.7

