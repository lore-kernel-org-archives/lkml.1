Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZHGJuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZHGJuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbZHGJur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:47 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:6227 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755933AbZHGJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:11 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KO03B8-04-L8A-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/21] kvm/svm: remove nested_svm_do and helper functions
Date: Fri, 7 Aug 2009 11:49:42 +0200
Message-ID: <1249638588-10982-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0124 (UTC) FILETIME=[6875B540:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is not longer required. So remove it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   60 ----------------------------------------------------
 1 files changed, 0 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c1e3f46..63d2f63 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1424,66 +1424,6 @@ static void nested_svm_unmap(void *addr, enum km_type idx)
 	kvm_release_page_dirty(page);
 }
 
-static struct page *nested_svm_get_page(struct vcpu_svm *svm, u64 gpa)
-{
-	struct page *page;
-
-	down_read(&current->mm->mmap_sem);
-	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
-	up_read(&current->mm->mmap_sem);
-
-	if (is_error_page(page)) {
-		printk(KERN_INFO "%s: could not find page at 0x%llx\n",
-		       __func__, gpa);
-		kvm_release_page_clean(page);
-		kvm_inject_gp(&svm->vcpu, 0);
-		return NULL;
-	}
-	return page;
-}
-
-static int nested_svm_do(struct vcpu_svm *svm,
-			 u64 arg1_gpa, u64 arg2_gpa, void *opaque,
-			 int (*handler)(struct vcpu_svm *svm,
-					void *arg1,
-					void *arg2,
-					void *opaque))
-{
-	struct page *arg1_page;
-	struct page *arg2_page = NULL;
-	void *arg1;
-	void *arg2 = NULL;
-	int retval;
-
-	arg1_page = nested_svm_get_page(svm, arg1_gpa);
-	if(arg1_page == NULL)
-		return 1;
-
-	if (arg2_gpa) {
-		arg2_page = nested_svm_get_page(svm, arg2_gpa);
-		if(arg2_page == NULL) {
-			kvm_release_page_clean(arg1_page);
-			return 1;
-		}
-	}
-
-	arg1 = kmap_atomic(arg1_page, KM_USER0);
-	if (arg2_gpa)
-		arg2 = kmap_atomic(arg2_page, KM_USER1);
-
-	retval = handler(svm, arg1, arg2, opaque);
-
-	kunmap_atomic(arg1, KM_USER0);
-	if (arg2_gpa)
-		kunmap_atomic(arg2, KM_USER1);
-
-	kvm_release_page_dirty(arg1_page);
-	if (arg2_gpa)
-		kvm_release_page_dirty(arg2_page);
-
-	return retval;
-}
-
 static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
-- 
1.6.3.3


