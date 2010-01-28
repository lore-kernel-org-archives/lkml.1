Return-Path: <linux-kernel-owner+w=401wt.eu-S932262Ab0A1Lik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0A1Lik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841Ab0A1Lig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:38:36 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:52076
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754767Ab0A1Lie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:34 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzab9bh936eMab78ozz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBY-01-FXS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/11] kvm: Introduce kvm_host_page_size
Date: Thu, 28 Jan 2010 12:37:56 +0100
Message-ID: <1264678682-30655-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0945 (UTC) FILETIME=[647E1010:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a generic function to find out the
host page size for a given gfn. This function is needed by
the kvm iommu code. This patch also simplifies the x86
host_mapping_level function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c       |   18 ++----------------
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ff2b2e8..226fa8e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -467,24 +467,10 @@ static int has_wrprotected_page(struct kvm *kvm,
 
 static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
 {
-	unsigned long page_size = PAGE_SIZE;
-	struct vm_area_struct *vma;
-	unsigned long addr;
+	unsigned long page_size;
 	int i, ret = 0;
 
-	addr = gfn_to_hva(kvm, gfn);
-	if (kvm_is_error_hva(addr))
-		return PT_PAGE_TABLE_LEVEL;
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, addr);
-	if (!vma)
-		goto out;
-
-	page_size = vma_kernel_pagesize(vma);
-
-out:
-	up_read(&current->mm->mmap_sem);
+	page_size = kvm_host_page_size(kvm, gfn);
 
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < (PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES); ++i) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dfde04b..a946abc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -300,6 +300,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
+unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7c5c873..87a4a77 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -45,6 +45,7 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
+#include <linux/hugetlb.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -884,6 +885,30 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
+unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn)
+{
+	struct vm_area_struct *vma;
+	unsigned long addr, size;
+
+	size = PAGE_SIZE;
+
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr))
+		return PAGE_SIZE;
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, addr);
+	if (!vma)
+		goto out;
+
+	size = vma_kernel_pagesize(vma);
+
+out:
+	up_read(&current->mm->mmap_sem);
+
+	return size;
+}
+
 int memslot_id(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-- 
1.6.6


