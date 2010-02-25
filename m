Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab0BYRQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:16:42 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:9774 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab0BYRQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:16:09 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYEQMG-02-N9R-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
Date: Thu, 25 Feb 2010 18:15:46 +0100
Message-ID: <1267118149-15737-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Feb 2010 17:15:52.0364 (UTC) FILETIME=[2ED85EC0:01CAB63E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
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
 arch/x86/kvm/svm.c |   67 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d8d4e35..d15e0ea 100644
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
@@ -436,6 +439,34 @@ err_1:
 
 }
 
+static void add_msr_offset(u32 offset)
+{
+	u32 old;
+	int i;
+
+again:
+	for (i = 0; i < MSRPM_OFFSETS; ++i) {
+		old = msrpm_offsets[i];
+
+		if (old == offset)
+			return;
+
+		if (old != MSR_INVALID)
+			continue;
+
+		if (cmpxchg(&msrpm_offsets[i], old, offset) != old)
+			goto again;
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
 static void set_msr_interception(u32 *msrpm, unsigned msr,
 				 int read, int write)
 {
@@ -454,6 +485,8 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
 	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
 
+	add_msr_offset(offset);
+
 	msrpm[offset] = tmp;
 }
 
@@ -511,6 +544,8 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
+	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
+
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
@@ -775,6 +810,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->nested.hsave = page_address(hsave_page);
 
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
+	svm_vcpu_init_msrpm(svm->nested.msrpm);
 
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
@@ -1846,20 +1882,33 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 
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
+		p      = msrpm_offsets[i];
+		offset = svm->nested.vmcb_msrpm + (p * 4);
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


