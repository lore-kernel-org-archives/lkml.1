Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXDAOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXDAOgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXDAOgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:36:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:47550 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328AbXDAOfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 39/41] KVM: Add physical memory aliasing feature
Date: Sun,  1 Apr 2007 17:35:36 +0300
Message-Id: <11754381393962-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <117543813933-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com> <1175438139249-git-send-email-avi@qumranet.com> <11754381391161-git-send-email-avi@qumranet.com> <11754381393714-git-send-email-avi@qumranet.com> <11754381392948-git-send-email-avi@qumranet.com> <1175438139458-git-send-email-avi@qumranet.com> <117543813933-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With this, we can specify that accesses to one physical memory range will
be remapped to another.  This is useful for the vga window at 0xa0000 which
is used as a movable window into the (much larger) framebuffer.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    9 +++++
 drivers/kvm/kvm_main.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/kvm.h    |   10 +++++-
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d19985a..fceeb84 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -51,6 +51,7 @@
 #define UNMAPPED_GVA (~(gpa_t)0)
 
 #define KVM_MAX_VCPUS 1
+#define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 4
 #define KVM_NUM_MMU_PAGES 256
 #define KVM_MIN_FREE_MMU_PAGES 5
@@ -312,6 +313,12 @@ struct kvm_vcpu {
 	struct kvm_cpuid_entry cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 };
 
+struct kvm_mem_alias {
+	gfn_t base_gfn;
+	unsigned long npages;
+	gfn_t target_gfn;
+};
+
 struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
@@ -322,6 +329,8 @@ struct kvm_memory_slot {
 
 struct kvm {
 	spinlock_t lock; /* protects everything except vcpus */
+	int naliases;
+	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int nmemslots;
 	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS];
 	/*
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index aaaf306..56ddbc1 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -846,7 +846,73 @@ out:
 	return r;
 }
 
-struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
+/*
+ * Set a new alias region.  Aliases map a portion of physical memory into
+ * another portion.  This is useful for memory windows, for example the PC
+ * VGA region.
+ */
+static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
+					 struct kvm_memory_alias *alias)
+{
+	int r, n;
+	struct kvm_mem_alias *p;
+
+	r = -EINVAL;
+	/* General sanity checks */
+	if (alias->memory_size & (PAGE_SIZE - 1))
+		goto out;
+	if (alias->guest_phys_addr & (PAGE_SIZE - 1))
+		goto out;
+	if (alias->slot >= KVM_ALIAS_SLOTS)
+		goto out;
+	if (alias->guest_phys_addr + alias->memory_size
+	    < alias->guest_phys_addr)
+		goto out;
+	if (alias->target_phys_addr + alias->memory_size
+	    < alias->target_phys_addr)
+		goto out;
+
+	spin_lock(&kvm->lock);
+
+	p = &kvm->aliases[alias->slot];
+	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
+	p->npages = alias->memory_size >> PAGE_SHIFT;
+	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
+
+	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
+		if (kvm->aliases[n - 1].npages)
+			break;
+	kvm->naliases = n;
+
+	spin_unlock(&kvm->lock);
+
+	vcpu_load(&kvm->vcpus[0]);
+	spin_lock(&kvm->lock);
+	kvm_mmu_zap_all(&kvm->vcpus[0]);
+	spin_unlock(&kvm->lock);
+	vcpu_put(&kvm->vcpus[0]);
+
+	return 0;
+
+out:
+	return r;
+}
+
+static gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	int i;
+	struct kvm_mem_alias *alias;
+
+	for (i = 0; i < kvm->naliases; ++i) {
+		alias = &kvm->aliases[i];
+		if (gfn >= alias->base_gfn
+		    && gfn < alias->base_gfn + alias->npages)
+			return alias->target_gfn + gfn - alias->base_gfn;
+	}
+	return gfn;
+}
+
+static struct kvm_memory_slot *__gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
 
@@ -859,13 +925,19 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(gfn_to_memslot);
+
+struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
+{
+	gfn = unalias_gfn(kvm, gfn);
+	return __gfn_to_memslot(kvm, gfn);
+}
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
 
-	slot = gfn_to_memslot(kvm, gfn);
+	gfn = unalias_gfn(kvm, gfn);
+	slot = __gfn_to_memslot(kvm, gfn);
 	if (!slot)
 		return NULL;
 	return slot->phys_mem[gfn - slot->base_gfn];
@@ -2503,6 +2575,17 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+	case KVM_SET_MEMORY_ALIAS: {
+		struct kvm_memory_alias alias;
+
+		r = -EFAULT;
+		if (copy_from_user(&alias, argp, sizeof alias))
+			goto out;
+		r = kvm_vm_ioctl_set_memory_alias(kvm, &alias);
+		if (r)
+			goto out;
+		break;
+	}
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 728b24c..da9b23f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 9
+#define KVM_API_VERSION 10
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -33,6 +33,13 @@ struct kvm_memory_region {
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
 
+struct kvm_memory_alias {
+	__u32 slot;  /* this has a different namespace than memory slots */
+	__u32 flags;
+	__u64 guest_phys_addr;
+	__u64 memory_size;
+	__u64 target_phys_addr;
+};
 
 enum kvm_exit_reason {
 	KVM_EXIT_UNKNOWN          = 0,
@@ -261,6 +268,7 @@ struct kvm_signal_mask {
  */
 #define KVM_CREATE_VCPU           _IO(KVMIO,  0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 0x42, struct kvm_dirty_log)
+#define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO, 0x43, struct kvm_memory_alias)
 
 /*
  * ioctls for vcpu fds
-- 
1.5.0.5

