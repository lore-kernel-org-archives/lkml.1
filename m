Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbYKRBF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbYKRBF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYKRBFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:05:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60680 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYKRBFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:05:11 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com
Subject: [PATCH] Check for ambiguities in create alias ioctl.
Date: Tue, 18 Nov 2008 01:01:18 -0200
Message-Id: <1226977278-5523-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current alias ioctl allows for the creation of
an alias covering a gpa that already exists. It is invalid,
because the gpa space needs to be uniquely mapped. So, if
there's a memory slot covering gpa range 0x123000 to 0x124000,
and we create an alias from any gpa within that range to a different
target, we create an essential ambiguity that brings no value at
the cost of a lot of confusion. Right now this confusion
manifests itself as a BUG() triggered in the rmaps code path.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c   |    6 ++++++
 arch/powerpc/kvm/powerpc.c |    5 +++++
 arch/s390/kvm/kvm-s390.c   |    6 ++++++
 arch/x86/kvm/x86.c         |   23 +++++++++++++++++++++--
 include/linux/kvm_host.h   |    4 ++++
 virt/kvm/kvm_main.c        |   31 ++++++++++++++++++++-----------
 6 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index af1464f..7e9d796 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1695,6 +1695,12 @@ void kvm_arch_hardware_unsetup(void)
 {
 }
 
+int kvm_arch_check_overlap(struct kvm *kvm, gfn_t base_gfn,
+			   unsigned long npages, void *me)
+{
+	return 0;
+}
+
 static void vcpu_kick_intr(void *info)
 {
 #ifdef DEBUG
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 90a6fc4..a0c164e 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -45,6 +45,11 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 	return !(v->arch.msr & MSR_WE);
 }
 
+int kvm_arch_check_overlap(struct kvm *kvm, gfn_t base_gfn,
+			   unsigned long npages, void *me)
+{
+	return 0;
+}
 
 int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8b00eb2..780f33e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -101,6 +101,12 @@ void kvm_arch_exit(void)
 {
 }
 
+int kvm_arch_check_overlap(struct kvm *kvm, gfn_t base_gfn,
+			   unsigned long npages, void *me)
+{
+	return 0;
+}
+
 /* Section: device related */
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1f8ff2..324af5e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1506,6 +1506,22 @@ gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 	return gfn;
 }
 
+int kvm_arch_check_overlap(struct kvm *kvm, gfn_t base_gfn,
+			 unsigned long npages, void *me)
+{
+	int i;
+	for (i = 0; i <	kvm->arch.naliases ; i++) {
+		struct kvm_mem_alias *p = &kvm->arch.aliases[i];
+		if (p == me)
+			continue;
+
+		if (!((base_gfn + npages < p->base_gfn) ||
+                      (base_gfn > p->base_gfn + p->npages)))
+			return -EEXIST;
+	}
+	return 0;
+}
+
 /*
  * Set a new alias region.  Aliases map a portion of physical memory into
  * another portion.  This is useful for memory windows, for example the PC
@@ -1540,18 +1556,21 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	p->npages = alias->memory_size >> PAGE_SHIFT;
 	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
 
+	r = kvm_check_overlap(kvm, p->base_gfn, p->npages, p);
+	if (r)
+		goto out_locked;
+
 	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
 		if (kvm->arch.aliases[n - 1].npages)
 			break;
 	kvm->arch.naliases = n;
 
+out_locked:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_mmu_zap_all(kvm);
 
 	up_write(&kvm->slots_lock);
 
-	return 0;
-
 out:
 	return r;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bb92be2..79f34ab 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -178,6 +178,10 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
 				int user_alloc);
+int kvm_check_overlap(struct kvm *kvm, gfn_t base_gfn,
+			  unsigned long pages, void *me);
+int kvm_arch_check_overlap(struct kvm *kvm, gfn_t base_gfn,
+			  unsigned long pages, void *me);
 void kvm_arch_flush_shadow(struct kvm *kvm);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd265b2..18af322 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -685,6 +685,23 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+int kvm_check_overlap(struct kvm *kvm, gfn_t base_gfn,
+		      unsigned long npages, void *me)
+{
+	int i;
+	
+	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
+		struct kvm_memory_slot *s = &kvm->memslots[i];
+
+		if (s == me)
+			continue;
+		if (!((base_gfn + npages <= s->base_gfn) ||
+		      (base_gfn >= s->base_gfn + s->npages)))
+			return -EEXIST;
+	}
+	return kvm_arch_check_overlap(kvm, base_gfn, npages, me);
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -700,7 +717,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages;
-	unsigned long i;
 	struct kvm_memory_slot *memslot;
 	struct kvm_memory_slot old, new;
 
@@ -733,17 +749,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (npages && old.npages && npages != old.npages)
 		goto out_free;
 
-	/* Check for overlaps */
-	r = -EEXIST;
-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *s = &kvm->memslots[i];
+	r = kvm_check_overlap(kvm, base_gfn, npages, memslot);
+	if (r)
+		goto out_free;
 
-		if (s == memslot)
-			continue;
-		if (!((base_gfn + npages <= s->base_gfn) ||
-		      (base_gfn >= s->base_gfn + s->npages)))
-			goto out_free;
-	}
 
 	/* Free page dirty bitmap if unneeded */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
-- 
1.5.6.5

