Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab0CAOgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:36:14 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:30560 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0CAOfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:35:05 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLXU3-02-IRR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/7] KVM: SVM: Optimize nested svm msrpm merging
Date: Mon, 1 Mar 2010 15:34:37 +0100
Message-ID: <1267454080-2513-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
References: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 14:34:46.0246 (UTC) FILETIME=[570AD060:01CAB94C]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch optimizes the way the msrpm of the host and the
guest are merged. The old code merged the 2 msrpm pages
completly. This code needed to touch 24kb of memory for that
operation. The optimized variant this patch introduces
merges only the parts where the host msrpm may contain zero
bits. This reduces the amount of memory which is touched to
48 bytes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 18d7938..c04ce1e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -92,6 +92,9 @@ struct nested_state {
 
 };
 
+#define MSRPM_OFFSETS	16
+static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
+
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
@@ -509,6 +512,49 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 	}
 }
 
+static void add_msr_offset(u32 offset)
+{
+	int i;
+
+	for (i = 0; i < MSRPM_OFFSETS; ++i) {
+
+		/* Offset already in list? */
+		if (msrpm_offsets[i] == offset)
+			return;
+
+		/* Slot used by another offset? */
+		if (msrpm_offsets[i] != MSR_INVALID)
+			continue;
+
+		/* Add offset to list */
+		msrpm_offsets[i] = offset;
+
+		return;
+	}
+
+	/*
+	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
+	 * increase MSRPM_OFFSETS in this case.
+	 */
+	BUG();
+}
+
+static void init_msrpm_offsets(void)
+{
+	int i;
+
+	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
+
+	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
+		u32 offset;
+
+		offset = svm_msrpm_offset(direct_access_msrs[i].index);
+		BUG_ON(offset == MSR_INVALID);
+
+		add_msr_offset(offset);
+	}
+}
+
 static void svm_enable_lbrv(struct vcpu_svm *svm)
 {
 	u32 *msrpm = svm->msrpm;
@@ -547,6 +593,8 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
+	init_msrpm_offsets();
+
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
@@ -811,6 +859,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->nested.hsave = page_address(hsave_page);
 
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
+	svm_vcpu_init_msrpm(svm->nested.msrpm);
 
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
@@ -1882,20 +1931,33 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	u32 *nested_msrpm;
-	struct page *page;
+	/*
+	 * This function merges the msr permission bitmaps of kvm and the
+	 * nested vmcb. It is omptimized in that it only merges the parts where
+	 * the kvm msr permission bitmap may contain zero bits
+	 */
 	int i;
 
-	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
-	if (!nested_msrpm)
-		return false;
+	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+		return true;
 
-	for (i = 0; i < PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER) / 4; i++)
-		svm->nested.msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
+	for (i = 0; i < MSRPM_OFFSETS; i++) {
+		u32 value, p;
+		u64 offset;
 
-	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
+		if (msrpm_offsets[i] == 0xffffffff)
+			break;
 
-	nested_svm_unmap(page);
+		offset = svm->nested.vmcb_msrpm + msrpm_offsets[i];
+		p      = msrpm_offsets[i] / 4;
+
+		if (kvm_read_guest(svm->vcpu.kvm, offset, &value, 4))
+			return false;
+
+		svm->nested.msrpm[p] = svm->msrpm[p] | value;
+	}
+
+	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
 	return true;
 }
-- 
1.7.0


