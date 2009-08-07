Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZHGJuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZHGJuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZHGJu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:28 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:57452
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755894AbZHGJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:07 -0400
X-SpamScore: 10
X-BigFish: VPS10(za62pz10d1Izz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KO03BA-04-L8F-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/21] kvm/svm: get rid of nested_svm_vmexit_real
Date: Fri, 7 Aug 2009 11:49:38 +0200
Message-ID: <1249638588-10982-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0155 (UTC) FILETIME=[687A7030:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the starting point of removing nested_svm_do from the
nested svm code. The nested_svm_do function basically maps two guest
physical pages to host virtual addresses and calls a passed function
on it. This function pointer code flow is hard to read and not the
best technical solution here.
As a side effect this patch indroduces the nested_svm_[un]map helper
functions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   52 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a85b0a2..1753a64 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1393,6 +1393,39 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 	return 0;
 }
 
+static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
+{
+	struct page *page;
+
+	down_read(&current->mm->mmap_sem);
+	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
+	up_read(&current->mm->mmap_sem);
+
+	if (is_error_page(page))
+		goto error;
+
+	return kmap_atomic(page, idx);
+
+error:
+	kvm_release_page_clean(page);
+	kvm_inject_gp(&svm->vcpu, 0);
+
+	return NULL;
+}
+
+static void nested_svm_unmap(void *addr, enum km_type idx)
+{
+	struct page *page;
+
+	if (!addr)
+		return;
+
+	page = kmap_atomic_to_page(addr);
+
+	kunmap_atomic(addr, idx);
+	kvm_release_page_dirty(page);
+}
+
 static struct page *nested_svm_get_page(struct vcpu_svm *svm, u64 gpa)
 {
 	struct page *page;
@@ -1600,13 +1633,16 @@ static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *fr
 	dst->lbr_ctl              = from->lbr_ctl;
 }
 
-static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
-				  void *arg2, void *opaque)
+static int nested_svm_vmexit(struct vcpu_svm *svm)
 {
-	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
+	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
+	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
+	if (!nested_vmcb)
+		return 1;
+
 	/* Give the current vmcb to the guest */
 	disable_gif(svm);
 
@@ -1681,15 +1717,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	/* Exit nested SVM mode */
 	svm->nested.vmcb = 0;
 
-	return 0;
-}
-
-static int nested_svm_vmexit(struct vcpu_svm *svm)
-{
-	nsvm_printk("VMexit\n");
-	if (nested_svm_do(svm, svm->nested.vmcb, 0,
-			  NULL, nested_svm_vmexit_real))
-		return 1;
+	nested_svm_unmap(nested_vmcb, KM_USER0);
 
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
-- 
1.6.3.3


