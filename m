Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab0BRLkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:40:47 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:16284
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757846Ab0BRLi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:38:56 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMab9bhzz1202hzzz32i6bh87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1CCF-01-N2M-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 01/10] KVM: SVM: Don't use kmap_atomic in nested_svm_map
Date: Thu, 18 Feb 2010 12:38:26 +0100
Message-ID: <1266493115-28386-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0358 (UTC) FILETIME=[E8F33CE0:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of kmap_atomic disables preemption but if we run in
shadow-shadow mode the vmrun emulation executes kvm_set_cr3
which might sleep or fault. So use kmap instead for
nested_svm_map.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 52f78dd..041ef6f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1417,7 +1417,7 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 	return 0;
 }
 
-static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
+static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa)
 {
 	struct page *page;
 
@@ -1425,7 +1425,7 @@ static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
 	if (is_error_page(page))
 		goto error;
 
-	return kmap_atomic(page, idx);
+	return kmap(page);
 
 error:
 	kvm_release_page_clean(page);
@@ -1434,7 +1434,7 @@ error:
 	return NULL;
 }
 
-static void nested_svm_unmap(void *addr, enum km_type idx)
+static void nested_svm_unmap(void *addr)
 {
 	struct page *page;
 
@@ -1443,7 +1443,7 @@ static void nested_svm_unmap(void *addr, enum km_type idx)
 
 	page = kmap_atomic_to_page(addr);
 
-	kunmap_atomic(addr, idx);
+	kunmap(addr);
 	kvm_release_page_dirty(page);
 }
 
@@ -1458,7 +1458,7 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return false;
 
-	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm);
 
 	if (!msrpm)
 		goto out;
@@ -1486,7 +1486,7 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	ret = msrpm[t1] & ((1 << param) << t0);
 
 out:
-	nested_svm_unmap(msrpm, KM_USER0);
+	nested_svm_unmap(msrpm);
 
 	return ret;
 }
@@ -1616,7 +1616,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb->control.exit_int_info,
 				       vmcb->control.exit_int_info_err);
 
-	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb);
 	if (!nested_vmcb)
 		return 1;
 
@@ -1706,7 +1706,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Exit nested SVM mode */
 	svm->nested.vmcb = 0;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
@@ -1719,7 +1719,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	u32 *nested_msrpm;
 	int i;
 
-	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm);
 	if (!nested_msrpm)
 		return false;
 
@@ -1728,7 +1728,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
-	nested_svm_unmap(nested_msrpm, KM_USER0);
+	nested_svm_unmap(nested_msrpm);
 
 	return true;
 }
@@ -1739,7 +1739,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax);
 	if (!nested_vmcb)
 		return false;
 
@@ -1851,7 +1851,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	enable_gif(svm);
 
@@ -1884,12 +1884,12 @@ static int vmload_interception(struct vcpu_svm *svm)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	return 1;
 }
@@ -1904,12 +1904,12 @@ static int vmsave_interception(struct vcpu_svm *svm)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(nested_vmcb);
 
 	return 1;
 }
-- 
1.6.6


