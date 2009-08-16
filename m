Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZHPJcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZHPJcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZHPJca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/48] KVM: s390: streamline memslot handling
Date: Sun, 16 Aug 2009 12:29:36 +0300
Message-Id: <1250415008-17175-17-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch relocates the variables kvm-s390 uses to track guest mem addr/size.
As discussed dropping the variables at struct kvm_arch level allows to use the
common vcpu->request based mechanism to reload guest memory if e.g. changes
via set_memory_region.

The kick mechanism introduced in this series is used to ensure running vcpus
leave guest state to catch the update.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/include/asm/kvm_host.h |    4 +--
 arch/s390/kvm/gaccess.h          |   23 +++++++++--------
 arch/s390/kvm/intercept.c        |    6 ++--
 arch/s390/kvm/kvm-s390.c         |   50 ++++++++++++-------------------------
 arch/s390/kvm/kvm-s390.h         |   29 +++++++++++++++++++++-
 arch/s390/kvm/sigp.c             |    4 +-
 6 files changed, 62 insertions(+), 54 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 0a784f6..75535d4 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1,7 +1,7 @@
 /*
  * asm-s390/kvm_host.h - definition for kernel virtual machines on s390
  *
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008,2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License (version 2 only)
@@ -228,8 +228,6 @@ struct kvm_vm_stat {
 };
 
 struct kvm_arch{
-	unsigned long guest_origin;
-	unsigned long guest_memsize;
 	struct sca_block *sca;
 	debug_info_t *dbf;
 	struct kvm_s390_float_interrupt float_int;
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index ed60f3a..03c716a 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -1,7 +1,7 @@
 /*
  * gaccess.h -  access guest memory
  *
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008,2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License (version 2 only)
@@ -16,13 +16,14 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 #include <asm/uaccess.h>
+#include "kvm-s390.h"
 
 static inline void __user *__guestaddr_to_user(struct kvm_vcpu *vcpu,
 					       unsigned long guestaddr)
 {
 	unsigned long prefix  = vcpu->arch.sie_block->prefix;
-	unsigned long origin  = vcpu->kvm->arch.guest_origin;
-	unsigned long memsize = vcpu->kvm->arch.guest_memsize;
+	unsigned long origin  = vcpu->arch.sie_block->gmsor;
+	unsigned long memsize = kvm_s390_vcpu_get_memsize(vcpu);
 
 	if (guestaddr < 2 * PAGE_SIZE)
 		guestaddr += prefix;
@@ -158,8 +159,8 @@ static inline int copy_to_guest(struct kvm_vcpu *vcpu, unsigned long guestdest,
 				const void *from, unsigned long n)
 {
 	unsigned long prefix  = vcpu->arch.sie_block->prefix;
-	unsigned long origin  = vcpu->kvm->arch.guest_origin;
-	unsigned long memsize = vcpu->kvm->arch.guest_memsize;
+	unsigned long origin  = vcpu->arch.sie_block->gmsor;
+	unsigned long memsize = kvm_s390_vcpu_get_memsize(vcpu);
 
 	if ((guestdest < 2 * PAGE_SIZE) && (guestdest + n > 2 * PAGE_SIZE))
 		goto slowpath;
@@ -209,8 +210,8 @@ static inline int copy_from_guest(struct kvm_vcpu *vcpu, void *to,
 				  unsigned long guestsrc, unsigned long n)
 {
 	unsigned long prefix  = vcpu->arch.sie_block->prefix;
-	unsigned long origin  = vcpu->kvm->arch.guest_origin;
-	unsigned long memsize = vcpu->kvm->arch.guest_memsize;
+	unsigned long origin  = vcpu->arch.sie_block->gmsor;
+	unsigned long memsize = kvm_s390_vcpu_get_memsize(vcpu);
 
 	if ((guestsrc < 2 * PAGE_SIZE) && (guestsrc + n > 2 * PAGE_SIZE))
 		goto slowpath;
@@ -244,8 +245,8 @@ static inline int copy_to_guest_absolute(struct kvm_vcpu *vcpu,
 					 unsigned long guestdest,
 					 const void *from, unsigned long n)
 {
-	unsigned long origin  = vcpu->kvm->arch.guest_origin;
-	unsigned long memsize = vcpu->kvm->arch.guest_memsize;
+	unsigned long origin  = vcpu->arch.sie_block->gmsor;
+	unsigned long memsize = kvm_s390_vcpu_get_memsize(vcpu);
 
 	if (guestdest + n > memsize)
 		return -EFAULT;
@@ -262,8 +263,8 @@ static inline int copy_from_guest_absolute(struct kvm_vcpu *vcpu, void *to,
 					   unsigned long guestsrc,
 					   unsigned long n)
 {
-	unsigned long origin  = vcpu->kvm->arch.guest_origin;
-	unsigned long memsize = vcpu->kvm->arch.guest_memsize;
+	unsigned long origin  = vcpu->arch.sie_block->gmsor;
+	unsigned long memsize = kvm_s390_vcpu_get_memsize(vcpu);
 
 	if (guestsrc + n > memsize)
 		return -EFAULT;
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 0732ab4..ba9d8a7 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -1,7 +1,7 @@
 /*
  * intercept.c - in-kernel handling for sie intercepts
  *
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008,2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License (version 2 only)
@@ -164,9 +164,9 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_validity++;
 	if ((viwhy == 0x37) && (vcpu->arch.sie_block->prefix
-		<= vcpu->kvm->arch.guest_memsize - 2*PAGE_SIZE)){
+		<= kvm_s390_vcpu_get_memsize(vcpu) - 2*PAGE_SIZE)) {
 		rc = fault_in_pages_writeable((char __user *)
-			 vcpu->kvm->arch.guest_origin +
+			 vcpu->arch.sie_block->gmsor +
 			 vcpu->arch.sie_block->prefix,
 			 2*PAGE_SIZE);
 		if (rc)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5c1c302..098bfa6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1,7 +1,7 @@
 /*
  * s390host.c --  hosting zSeries kernel virtual machines
  *
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008,2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License (version 2 only)
@@ -10,6 +10,7 @@
  *    Author(s): Carsten Otte <cotte@de.ibm.com>
  *               Christian Borntraeger <borntraeger@de.ibm.com>
  *               Heiko Carstens <heiko.carstens@de.ibm.com>
+ *               Christian Ehrhardt <ehrhardt@de.ibm.com>
  */
 
 #include <linux/compiler.h>
@@ -278,16 +279,10 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gbea = 1;
 }
 
-/* The current code can have up to 256 pages for virtio */
-#define VIRTIODESCSPACE (256ul * 4096ul)
-
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH);
-	vcpu->arch.sie_block->gmslm = vcpu->kvm->arch.guest_memsize +
-				      vcpu->kvm->arch.guest_origin +
-				      VIRTIODESCSPACE - 1ul;
-	vcpu->arch.sie_block->gmsor = vcpu->kvm->arch.guest_origin;
+	set_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests);
 	vcpu->arch.sie_block->ecb   = 2;
 	vcpu->arch.sie_block->eca   = 0xC1002001U;
 	vcpu->arch.sie_block->fac   = (int) (long) facilities;
@@ -491,9 +486,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	vcpu_load(vcpu);
 
 rerun_vcpu:
+	if (vcpu->requests)
+		if (test_and_clear_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
+			kvm_s390_vcpu_set_mem(vcpu);
+
 	/* verify, that memory has been registered */
-	if (!vcpu->kvm->arch.guest_memsize) {
+	if (!vcpu->arch.sie_block->gmslm) {
 		vcpu_put(vcpu);
+		VCPU_EVENT(vcpu, 3, "%s", "no memory registered to run vcpu");
 		return -EINVAL;
 	}
 
@@ -691,7 +691,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	   vmas. It is okay to mmap() and munmap() stuff in this slot after
 	   doing this call at any time */
 
-	if (mem->slot || kvm->arch.guest_memsize)
+	if (mem->slot)
 		return -EINVAL;
 
 	if (mem->guest_phys_addr)
@@ -706,36 +706,18 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	if (!user_alloc)
 		return -EINVAL;
 
-	/* lock all vcpus */
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (!kvm->vcpus[i])
-			continue;
-		if (!mutex_trylock(&kvm->vcpus[i]->mutex))
-			goto fail_out;
-	}
-
-	kvm->arch.guest_origin = mem->userspace_addr;
-	kvm->arch.guest_memsize = mem->memory_size;
-
-	/* update sie control blocks, and unlock all vcpus */
+	/* request update of sie control block for all available vcpus */
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
-			kvm->vcpus[i]->arch.sie_block->gmsor =
-				kvm->arch.guest_origin;
-			kvm->vcpus[i]->arch.sie_block->gmslm =
-				kvm->arch.guest_memsize +
-				kvm->arch.guest_origin +
-				VIRTIODESCSPACE - 1ul;
-			mutex_unlock(&kvm->vcpus[i]->mutex);
+			if (test_and_set_bit(KVM_REQ_MMU_RELOAD,
+						&kvm->vcpus[i]->requests))
+				continue;
+			kvm_s390_inject_sigp_stop(kvm->vcpus[i],
+						  ACTION_RELOADVCPU_ON_STOP);
 		}
 	}
 
 	return 0;
-
-fail_out:
-	for (; i >= 0; i--)
-		mutex_unlock(&kvm->vcpus[i]->mutex);
-	return -EINVAL;
 }
 
 void kvm_arch_flush_shadow(struct kvm *kvm)
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 2072cd4..ec5eee7 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -1,7 +1,7 @@
 /*
  * kvm_s390.h -  definition for kvm on s390
  *
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008,2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License (version 2 only)
@@ -9,6 +9,7 @@
  *
  *    Author(s): Carsten Otte <cotte@de.ibm.com>
  *               Christian Borntraeger <borntraeger@de.ibm.com>
+ *               Christian Ehrhardt <ehrhardt@de.ibm.com>
  */
 
 #ifndef ARCH_S390_KVM_S390_H
@@ -18,6 +19,9 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+/* The current code can have up to 256 pages for virtio */
+#define VIRTIODESCSPACE (256ul * 4096ul)
+
 typedef int (*intercept_handler_t)(struct kvm_vcpu *vcpu);
 
 /* negativ values are error codes, positive values for internal conditions */
@@ -54,6 +58,29 @@ int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
 int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code);
 int kvm_s390_inject_sigp_stop(struct kvm_vcpu *vcpu, int action);
 
+static inline int kvm_s390_vcpu_get_memsize(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.sie_block->gmslm
+		- vcpu->arch.sie_block->gmsor
+		- VIRTIODESCSPACE + 1ul;
+}
+
+static inline void kvm_s390_vcpu_set_mem(struct kvm_vcpu *vcpu)
+{
+	struct kvm_memory_slot *mem;
+
+	down_read(&vcpu->kvm->slots_lock);
+	mem = &vcpu->kvm->memslots[0];
+
+	vcpu->arch.sie_block->gmsor = mem->userspace_addr;
+	vcpu->arch.sie_block->gmslm =
+		mem->userspace_addr +
+		(mem->npages << PAGE_SHIFT) +
+		VIRTIODESCSPACE - 1ul;
+
+	up_read(&vcpu->kvm->slots_lock);
+}
+
 /* implemented in priv.c */
 int kvm_s390_handle_b2(struct kvm_vcpu *vcpu);
 
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 21897b0..40c8c67 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -189,9 +189,9 @@ static int __sigp_set_prefix(struct kvm_vcpu *vcpu, u16 cpu_addr, u32 address,
 	/* make sure that the new value is valid memory */
 	address = address & 0x7fffe000u;
 	if ((copy_from_guest(vcpu, &tmp,
-		(u64) (address + vcpu->kvm->arch.guest_origin) , 1)) ||
+		(u64) (address + vcpu->arch.sie_block->gmsor) , 1)) ||
 	   (copy_from_guest(vcpu, &tmp, (u64) (address +
-			vcpu->kvm->arch.guest_origin + PAGE_SIZE), 1))) {
+			vcpu->arch.sie_block->gmsor + PAGE_SIZE), 1))) {
 		*reg |= SIGP_STAT_INVALID_PARAMETER;
 		return 1; /* invalid parameter */
 	}
-- 
1.6.3.3

