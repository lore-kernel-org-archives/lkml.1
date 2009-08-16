Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZHPJcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZHPJcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZHPJcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45370 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbZHPJaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/48] KVM: introduce irq_lock, use it to protect ioapic
Date: Sun, 16 Aug 2009 12:29:57 +0300
Message-Id: <1250415008-17175-38-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Introduce irq_lock, and use to protect ioapic data structures.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    3 ++-
 virt/kvm/ioapic.c        |    5 +++++
 virt/kvm/kvm_main.c      |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19240fe..0c71688 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -124,7 +124,6 @@ struct kvm_kernel_irq_routing_entry {
 };
 
 struct kvm {
-	struct mutex lock; /* protects the vcpus array and APIC accesses */
 	spinlock_t mmu_lock;
 	spinlock_t requests_lock;
 	struct rw_semaphore slots_lock;
@@ -134,6 +133,7 @@ struct kvm {
 					KVM_PRIVATE_MEM_SLOTS];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	struct list_head vm_list;
+	struct mutex lock;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
 #ifdef CONFIG_HAVE_KVM_EVENTFD
@@ -150,6 +150,7 @@ struct kvm {
 	struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
 #endif
 
+	struct mutex irq_lock;
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 	struct list_head irq_routing; /* of kvm_kernel_irq_routing_entry */
 	struct hlist_head mask_notifier_list;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 469b9fa..2a56671 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -243,6 +243,7 @@ static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 	ioapic_debug("addr %lx\n", (unsigned long)addr);
 	ASSERT(!(addr & 0xf));	/* check alignment */
 
+	mutex_lock(&ioapic->kvm->irq_lock);
 	addr &= 0xff;
 	switch (addr) {
 	case IOAPIC_REG_SELECT:
@@ -269,6 +270,7 @@ static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 	default:
 		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
 	}
+	mutex_unlock(&ioapic->kvm->irq_lock);
 }
 
 static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
@@ -280,6 +282,8 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
 		     (void*)addr, len, val);
 	ASSERT(!(addr & 0xf));	/* check alignment */
+
+	mutex_lock(&ioapic->kvm->irq_lock);
 	if (len == 4 || len == 8)
 		data = *(u32 *) val;
 	else {
@@ -305,6 +309,7 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	default:
 		break;
 	}
+	mutex_unlock(&ioapic->kvm->irq_lock);
 }
 
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1f9c87..d47e660 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -982,6 +982,7 @@ static struct kvm *kvm_create_vm(void)
 	kvm_io_bus_init(&kvm->pio_bus);
 	kvm_irqfd_init(kvm);
 	mutex_init(&kvm->lock);
+	mutex_init(&kvm->irq_lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	init_rwsem(&kvm->slots_lock);
 	atomic_set(&kvm->users_count, 1);
-- 
1.6.3.3

