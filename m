Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYAFOmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYAFOmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbYAFOjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:46609 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 09/33] KVM: Portability: Move memslot aliases to new struct kvm_arch
Date: Sun,  6 Jan 2008 16:39:15 +0200
Message-Id: <1199630379-28638-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patches create kvm_arch to hold arch-specific kvm fileds
and moves fields naliases and aliases to kvm_arch.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |   10 +---------
 drivers/kvm/x86.c |   10 +++++-----
 drivers/kvm/x86.h |   13 +++++++++++++
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 9ea7149..bf5b85c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -25,7 +25,6 @@
 #include "x86.h"
 
 #define KVM_MAX_VCPUS 4
-#define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 8
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
@@ -94,12 +93,6 @@ struct kvm_vcpu {
 	struct kvm_vcpu_arch arch;
 };
 
-struct kvm_mem_alias {
-	gfn_t base_gfn;
-	unsigned long npages;
-	gfn_t target_gfn;
-};
-
 struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
@@ -123,8 +116,6 @@ struct kvm_vm_stat {
 struct kvm {
 	struct mutex lock; /* protects everything except vcpus */
 	struct mm_struct *mm; /* userspace tied to this vm */
-	int naliases;
-	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int nmemslots;
 	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
 					KVM_PRIVATE_MEM_SLOTS];
@@ -147,6 +138,7 @@ struct kvm {
 	unsigned int tss_addr;
 	struct page *apic_access_page;
 	struct kvm_vm_stat stat;
+	struct kvm_arch arch;
 };
 
 /* The guest did something we don't support. */
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 60f9722..7e1bd52 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1191,8 +1191,8 @@ gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 	int i;
 	struct kvm_mem_alias *alias;
 
-	for (i = 0; i < kvm->naliases; ++i) {
-		alias = &kvm->aliases[i];
+	for (i = 0; i < kvm->arch.naliases; ++i) {
+		alias = &kvm->arch.aliases[i];
 		if (gfn >= alias->base_gfn
 		    && gfn < alias->base_gfn + alias->npages)
 			return alias->target_gfn + gfn - alias->base_gfn;
@@ -1228,15 +1228,15 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 
 	mutex_lock(&kvm->lock);
 
-	p = &kvm->aliases[alias->slot];
+	p = &kvm->arch.aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
 	p->npages = alias->memory_size >> PAGE_SHIFT;
 	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
 
 	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
-		if (kvm->aliases[n - 1].npages)
+		if (kvm->arch.aliases[n - 1].npages)
 			break;
-	kvm->naliases = n;
+	kvm->arch.naliases = n;
 
 	kvm_mmu_zap_all(kvm);
 
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 4ca8485..be84f2b 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -54,6 +54,8 @@
 
 #define IOPL_SHIFT 12
 
+#define KVM_ALIAS_SLOTS 4
+
 #define KVM_PERMILLE_MMU_PAGES 20
 #define KVM_MIN_ALLOC_MMU_PAGES 64
 #define KVM_NUM_MMU_PAGES 1024
@@ -255,6 +257,17 @@ struct kvm_vcpu_arch {
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
+struct kvm_mem_alias {
+	gfn_t base_gfn;
+	unsigned long npages;
+	gfn_t target_gfn;
+};
+
+struct kvm_arch{
+	int naliases;
+	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
+};
+
 struct kvm_vcpu_stat {
 	u32 pf_fixed;
 	u32 pf_guest;
-- 
1.5.3.7

