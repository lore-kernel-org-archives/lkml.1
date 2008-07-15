Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbYGOMRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbYGOMRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbYGOMM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:57 -0400
Received: from il.qumranet.com ([212.179.150.194]:30405 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbYGOMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 16/19] KVM: MMU: nuke shadowed pgtable pages and ptes on memslot destruction
Date: Tue, 15 Jul 2008 15:12:35 +0300
Message-Id: <1216123958-10717-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Flush the shadow mmu before removing regions to avoid stale entries.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm-ia64.c   |    3 +++
 arch/powerpc/kvm/powerpc.c |    4 ++++
 arch/s390/kvm/kvm-s390.c   |    4 ++++
 arch/x86/kvm/x86.c         |    5 +++++
 include/linux/kvm_host.h   |    1 +
 virt/kvm/kvm_main.c        |    3 +++
 6 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index a4cf4a2..608860c 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1455,6 +1455,9 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+}
 
 long kvm_arch_dev_ioctl(struct file *filp,
 		unsigned int ioctl, unsigned long arg)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index b850d24..53826a5 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -170,6 +170,10 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 399acf3..1782cbc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -675,6 +675,10 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+}
+
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 200e215..8e410ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4032,6 +4032,11 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+	kvm_mmu_zap_all(kvm);
+}
+
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d220b49..07d68a8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -168,6 +168,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
 				int user_alloc);
+void kvm_arch_flush_shadow(struct kvm *kvm);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b90da0b..c459383 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -405,6 +405,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->slot >= kvm->nmemslots)
 		kvm->nmemslots = mem->slot + 1;
 
+	if (!npages)
+		kvm_arch_flush_shadow(kvm);
+
 	*memslot = new;
 
 	r = kvm_arch_set_memory_region(kvm, mem, old, user_alloc);
-- 
1.5.6.1

