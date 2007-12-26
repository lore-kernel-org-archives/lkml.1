Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXLZLJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXLZLJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXLZLGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:24 -0500
Received: from il.qumranet.com ([82.166.9.18]:50469 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXLZLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:04 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 08/55] KVM: Export memory slot allocation mechanism
Date: Wed, 26 Dec 2007 13:05:13 +0200
Message-Id: <1198667160-22953-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Remove kvm memory slot allocation mechanism from the ioctl
and put it to exported function.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   17 +++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 12de42c..f3dda08 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -513,6 +513,9 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 extern struct page *bad_page;
 
 int is_error_page(struct page *page);
+int kvm_set_memory_region(struct kvm *kvm,
+			  struct kvm_userspace_memory_region *mem,
+			  int user_alloc);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page(struct page *page);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0e8f77d..16176a2 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -643,10 +643,9 @@ EXPORT_SYMBOL_GPL(fx_init);
  *
  * Discontiguous memory is allowed, mostly for framebuffers.
  */
-static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
-					  struct
-					  kvm_userspace_memory_region *mem,
-					  int user_alloc)
+int kvm_set_memory_region(struct kvm *kvm,
+			  struct kvm_userspace_memory_region *mem,
+			  int user_alloc)
 {
 	int r;
 	gfn_t base_gfn;
@@ -789,6 +788,16 @@ out_unlock:
 	kvm_free_physmem_slot(&new, &old);
 out:
 	return r;
+
+}
+EXPORT_SYMBOL_GPL(kvm_set_memory_region);
+
+static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
+					  struct
+					  kvm_userspace_memory_region *mem,
+					  int user_alloc)
+{
+	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
 
 static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
-- 
1.5.3.7

