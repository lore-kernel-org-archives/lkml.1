Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbZEXP4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbZEXP4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZEXPxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:53:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41847 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 30/45] KVM: s390: Fix memory slot versus run - v3
Date: Sun, 24 May 2009 18:50:15 +0300
Message-Id: <1243180230-2480-31-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch fixes an incorrectness in the kvm backend for s390.
In case virtual cpus are being created before the corresponding
memory slot is being registered, we need to update the sie
control blocks for the virtual cpus.

*updates in v3*
In consideration of the s390 memslot constraints locking was changed
to trylock. These locks should never be held, as vcpu's can't run without
the single memslot we just assign when running this code. To ensure this
never deadlocks in case other code changes the code uses trylocks and bail
out if it can't get all locks.

Additionally most of the discussed special conditions for s390 like
only one memslot and no user_alloc are now checked for validity in
kvm_arch_set_memory_region.

Reported-by: Mijo Safradin <mijo@linux.vnet.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/kvm-s390.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f4d56e9..86567e1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -657,6 +657,8 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot old,
 				int user_alloc)
 {
+	int i;
+
 	/* A few sanity checks. We can have exactly one memory slot which has
 	   to start at guest virtual zero and which has to be located at a
 	   page boundary in userland and which has to end at a page boundary.
@@ -664,7 +666,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	   vmas. It is okay to mmap() and munmap() stuff in this slot after
 	   doing this call at any time */
 
-	if (mem->slot)
+	if (mem->slot || kvm->arch.guest_memsize)
 		return -EINVAL;
 
 	if (mem->guest_phys_addr)
@@ -676,15 +678,39 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	if (mem->memory_size & (PAGE_SIZE - 1))
 		return -EINVAL;
 
+	if (!user_alloc)
+		return -EINVAL;
+
+	/* lock all vcpus */
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (!kvm->vcpus[i])
+			continue;
+		if (!mutex_trylock(&kvm->vcpus[i]->mutex))
+			goto fail_out;
+	}
+
 	kvm->arch.guest_origin = mem->userspace_addr;
 	kvm->arch.guest_memsize = mem->memory_size;
 
-	/* FIXME: we do want to interrupt running CPUs and update their memory
-	   configuration now to avoid race conditions. But hey, changing the
-	   memory layout while virtual CPUs are running is usually bad
-	   programming practice. */
+	/* update sie control blocks, and unlock all vcpus */
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm->vcpus[i]->arch.sie_block->gmsor =
+				kvm->arch.guest_origin;
+			kvm->vcpus[i]->arch.sie_block->gmslm =
+				kvm->arch.guest_memsize +
+				kvm->arch.guest_origin +
+				VIRTIODESCSPACE - 1ul;
+			mutex_unlock(&kvm->vcpus[i]->mutex);
+		}
+	}
 
 	return 0;
+
+fail_out:
+	for (; i >= 0; i--)
+		mutex_unlock(&kvm->vcpus[i]->mutex);
+	return -EINVAL;
 }
 
 void kvm_arch_flush_shadow(struct kvm *kvm)
-- 
1.6.0.6

