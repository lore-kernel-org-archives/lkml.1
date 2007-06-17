Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbXFQJzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbXFQJzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbXFQJpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:55167 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 40/58] KVM: MMU: Make setting shadow ptes atomic on i386
Date: Sun, 17 Jun 2007 12:44:21 +0300
Message-Id: <11820734811620-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/Kconfig       |    1 +
 drivers/kvm/mmu.c         |   14 ++++++++++++--
 drivers/kvm/paging_tmpl.h |    4 ++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 2f661e5..33fa28a 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -11,6 +11,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
+	depends on X86_CMPXCHG64 || 64BIT
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 3cdbf68..f24b540 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
+#include <asm/cmpxchg.h>
 
 #include "vmx.h"
 #include "kvm.h"
@@ -204,6 +205,15 @@ static int is_rmap_pte(u64 pte)
 		== (PT_WRITABLE_MASK | PT_PRESENT_MASK);
 }
 
+static void set_shadow_pte(u64 *sptep, u64 spte)
+{
+#ifdef CONFIG_X86_64
+	set_64bit((unsigned long *)sptep, spte);
+#else
+	set_64bit((unsigned long long *)sptep, spte);
+#endif
+}
+
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 				  struct kmem_cache *base_cache, int min,
 				  gfp_t gfp_flags)
@@ -446,7 +456,7 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 		rmap_remove(vcpu, spte);
 		kvm_arch_ops->tlb_flush(vcpu);
-		*spte &= ~(u64)PT_WRITABLE_MASK;
+		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
 	}
 }
 
@@ -699,7 +709,7 @@ static void kvm_mmu_zap_page(struct kvm_vcpu *vcpu,
 		}
 		BUG_ON(!parent_pte);
 		kvm_mmu_put_page(vcpu, page, parent_pte);
-		*parent_pte = 0;
+		set_shadow_pte(parent_pte, 0);
 	}
 	kvm_mmu_page_unlink_children(vcpu, page);
 	if (!page->root_count) {
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 397a403..fabc2c9 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -234,7 +234,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		spte |= gaddr;
 		spte |= PT_SHADOW_IO_MARK;
 		spte &= ~PT_PRESENT_MASK;
-		*shadow_pte = spte;
+		set_shadow_pte(shadow_pte, spte);
 		return;
 	}
 
@@ -280,7 +280,7 @@ unshadowed:
 	if (access_bits & PT_WRITABLE_MASK)
 		mark_page_dirty(vcpu->kvm, gaddr >> PAGE_SHIFT);
 
-	*shadow_pte = spte;
+	set_shadow_pte(shadow_pte, spte);
 	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
 	if (!was_rmapped)
 		rmap_add(vcpu, shadow_pte);
-- 
1.5.0.6

