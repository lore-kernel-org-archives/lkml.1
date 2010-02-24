Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab0BXSAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:00:12 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:51441
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757553Ab0BXSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:00:07 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXZ4-01-2RE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/11] KVM: SVM: Optimize nested svm msrpm merging
Date: Wed, 24 Feb 2010 18:59:20 +0100
Message-ID: <1267034360-5907-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0730 (UTC) FILETIME=[18ED7320:01CAB57B]
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
 arch/x86/kvm/svm.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ae2f211..eb25fea 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -754,6 +754,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->nested.hsave = page_address(hsave_page);
 
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
+	svm_vcpu_init_msrpm(svm->nested.msrpm);
 
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
@@ -1824,20 +1825,46 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	u32 *nested_msrpm;
-	struct page *page;
+	/*
+	 * This function merges the msr permission bitmaps of kvm and the
+	 * nested vmcb. It is omptimized in that it only merges the parts where
+	 * the kvm msr permission bitmap may contain zero bits
+	 */
+	static const u32 msrpm_offsets[] = {
+		0x0000002c, /* SYSENTER_CS */
+
+		0x00000038, /* LASTBRANCHFROMIP
+			       LASTBRANCHTOIP
+			       LASTINTFROMIP
+			       LASTINTTOIP */
+
+		0x00000820, /* STAR
+			       LSTAR
+			       CSTAR
+			       SYSCALL_MASK */
+
+		0x00000840, /* FS_BASE
+			       GS_BASE
+			       KERNEL_GS_BASE */
+
+		0xffffffff, /* End of List */
+	};
 	int i;
 
-	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
-	if (!nested_msrpm)
-		return false;
+	for (i = 0; msrpm_offsets[i] != 0xffffffff; i++) {
+		u32 value, p;
+		u64 offset;
 
-	for (i = 0; i < PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER) / 4; i++)
-		svm->nested.msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
+		offset = svm->nested.vmcb_msrpm + msrpm_offsets[i];
+		p      = msrpm_offsets[i] / 4;
 
-	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
+		if (kvm_read_guest(svm->vcpu.kvm, offset, &value, 4))
+			return false;
 
-	nested_svm_unmap(page);
+		svm->nested.msrpm[p] = svm->msrpm[p] | value;
+	}
+
+	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
 	return true;
 }
-- 
1.7.0


