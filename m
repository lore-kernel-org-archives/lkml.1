Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbYAFOm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbYAFOm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbYAFOjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:46617 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 11/33] KVM: Portability: move vpic and vioapic to kvm_arch
Date: Sun,  6 Jan 2008 16:39:17 +0200
Message-Id: <1199630379-28638-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patches moves two fields vpid and vioapic to kvm_arch

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c |    4 ++--
 drivers/kvm/irq.h    |    4 ++--
 drivers/kvm/kvm.h    |    2 --
 drivers/kvm/x86.c    |   14 +++++++-------
 drivers/kvm/x86.h    |    2 ++
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index 0491036..f823677 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -271,7 +271,7 @@ static int get_eoi_gsi(struct kvm_ioapic *ioapic, int vector)
 
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
 {
-	struct kvm_ioapic *ioapic = kvm->vioapic;
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
 	union ioapic_redir_entry *ent;
 	int gsi;
 
@@ -390,7 +390,7 @@ int kvm_ioapic_init(struct kvm *kvm)
 	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
 	if (!ioapic)
 		return -ENOMEM;
-	kvm->vioapic = ioapic;
+	kvm->arch.vioapic = ioapic;
 	kvm_ioapic_reset(ioapic);
 	ioapic->dev.read = ioapic_mmio_read;
 	ioapic->dev.write = ioapic_mmio_write;
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index a688c51..6e023dc 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -148,12 +148,12 @@ do {									\
 
 static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
 {
-	return kvm->vpic;
+	return kvm->arch.vpic;
 }
 
 static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
 {
-	return kvm->vioapic;
+	return kvm->arch.vioapic;
 }
 
 static inline int irqchip_in_kernel(struct kvm *kvm)
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 65de5e4..d9ce916 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -124,8 +124,6 @@ struct kvm {
 	struct file *filp;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
-	struct kvm_pic *vpic;
-	struct kvm_ioapic *vioapic;
 	int round_robin_prev_vcpu;
 	unsigned int tss_addr;
 	struct page *apic_access_page;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index c0e95fb..b37c009 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1386,12 +1386,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 	case KVM_CREATE_IRQCHIP:
 		r = -ENOMEM;
-		kvm->vpic = kvm_create_pic(kvm);
-		if (kvm->vpic) {
+		kvm->arch.vpic = kvm_create_pic(kvm);
+		if (kvm->arch.vpic) {
 			r = kvm_ioapic_init(kvm);
 			if (r) {
-				kfree(kvm->vpic);
-				kvm->vpic = NULL;
+				kfree(kvm->arch.vpic);
+				kvm->arch.vpic = NULL;
 				goto out;
 			}
 		} else
@@ -1409,7 +1409,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 				kvm_pic_set_irq(pic_irqchip(kvm),
 					irq_event.irq,
 					irq_event.level);
-			kvm_ioapic_set_irq(kvm->vioapic,
+			kvm_ioapic_set_irq(kvm->arch.vioapic,
 					irq_event.irq,
 					irq_event.level);
 			mutex_unlock(&kvm->lock);
@@ -3084,8 +3084,8 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	kfree(kvm->vpic);
-	kfree(kvm->vioapic);
+	kfree(kvm->arch.vpic);
+	kfree(kvm->arch.vioapic);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	kfree(kvm);
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 5cdc366..ef23a30 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -275,6 +275,8 @@ struct kvm_arch{
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct kvm_pic *vpic;
+	struct kvm_ioapic *vioapic;
 };
 
 struct kvm_vcpu_stat {
-- 
1.5.3.7

