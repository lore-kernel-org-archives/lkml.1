Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0BSPXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:23:30 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:46916 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0BSPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:25 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMab9bhzz1202hzzz32i87h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEN-02-7N8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 01/11] KVM: SVM: Don't use kmap_atomic in nested_svm_map
Date: Fri, 19 Feb 2010 16:23:00 +0100
Message-ID: <1266592990-8911-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0652 (UTC) FILETIME=[7343ACC0:01CAB177]
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
 arch/x86/kvm/svm.c |   47 ++++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2e1e8d6..63ecd4d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1417,7 +1417,7 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 	return 0;
 }
 
-static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
+static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
 {
 	struct page *page;
 
@@ -1425,7 +1425,9 @@ static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
 	if (is_error_page(page))
 		goto error;
 
-	return kmap_atomic(page, idx);
+	*_page = page;
+
+	return kmap(page);
 
 error:
 	kvm_release_page_clean(page);
@@ -1434,16 +1436,9 @@ error:
 	return NULL;
 }
 
-static void nested_svm_unmap(void *addr, enum km_type idx)
+static void nested_svm_unmap(struct page *page)
 {
-	struct page *page;
-
-	if (!addr)
-		return;
-
-	page = kmap_atomic_to_page(addr);
-
-	kunmap_atomic(addr, idx);
+	kunmap(page);
 	kvm_release_page_dirty(page);
 }
 
@@ -1451,6 +1446,7 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
 	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	struct page *page;
 	bool ret = false;
 	u32 t0, t1;
 	u8 *msrpm;
@@ -1458,7 +1454,7 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return false;
 
-	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
 
 	if (!msrpm)
 		goto out;
@@ -1486,7 +1482,7 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	ret = msrpm[t1] & ((1 << param) << t0);
 
 out:
-	nested_svm_unmap(msrpm, KM_USER0);
+	nested_svm_unmap(page);
 
 	return ret;
 }
@@ -1609,6 +1605,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
+	struct page *page;
 
 	trace_kvm_nested_vmexit_inject(vmcb->control.exit_code,
 				       vmcb->control.exit_info_1,
@@ -1616,7 +1613,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb->control.exit_int_info,
 				       vmcb->control.exit_int_info_err);
 
-	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, &page);
 	if (!nested_vmcb)
 		return 1;
 
@@ -1706,7 +1703,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Exit nested SVM mode */
 	svm->nested.vmcb = 0;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
@@ -1717,9 +1714,10 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
 	u32 *nested_msrpm;
+	struct page *page;
 	int i;
 
-	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
 	if (!nested_msrpm)
 		return false;
 
@@ -1728,7 +1726,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
-	nested_svm_unmap(nested_msrpm, KM_USER0);
+	nested_svm_unmap(page);
 
 	return true;
 }
@@ -1738,8 +1736,9 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
+	struct page *page;
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, &page);
 	if (!nested_vmcb)
 		return false;
 
@@ -1851,7 +1850,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	enable_gif(svm);
 
@@ -1877,6 +1876,7 @@ static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
 static int vmload_interception(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
+	struct page *page;
 
 	if (nested_svm_check_permissions(svm))
 		return 1;
@@ -1884,12 +1884,12 @@ static int vmload_interception(struct vcpu_svm *svm)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, &page);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	return 1;
 }
@@ -1897,6 +1897,7 @@ static int vmload_interception(struct vcpu_svm *svm)
 static int vmsave_interception(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
+	struct page *page;
 
 	if (nested_svm_check_permissions(svm))
 		return 1;
@@ -1904,12 +1905,12 @@ static int vmsave_interception(struct vcpu_svm *svm)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, &page);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	return 1;
 }
-- 
1.6.6


