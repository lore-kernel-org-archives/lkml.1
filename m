Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab0BYRQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:16:23 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:9876 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab0BYRQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:16:11 -0500
X-SpamScore: 0
X-BigFish: VPS0(zba6lz936eMab9bhzz1202hzzz32i6bh87h43h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYEQMM-01-QHS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/5] KVM: SVM: Use svm_msrpm_offset in nested_svm_exit_handled_msr
Date: Thu, 25 Feb 2010 18:15:47 +0100
Message-ID: <1267118149-15737-4-git-send-email-joerg.roedel@amd.com>
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

There is a generic function now to calculate msrpm offsets.
Use that function in nested_svm_exit_handled_msr() remove
the duplicate logic.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   44 ++++++++++++++------------------------------
 1 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d15e0ea..bb75a44 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1605,40 +1605,24 @@ static void nested_svm_unmap(struct page *page)
 
 static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
-	u32 param = svm->vmcb->control.exit_info_1 & 1;
-	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	bool ret = false;
-	u32 t0, t1;
-	u8 val;
+	u32 offset, msr, value;
+	int write, mask;
 
-	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
-		return false;
+	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	offset = svm_msrpm_offset(msr);
+	write  = svm->vmcb->control.exit_info_1 & 1;
+	mask   = 1 << ((2 * (msr & 0xf)) + write);
 
-	switch (msr) {
-	case 0 ... 0x1fff:
-		t0 = (msr * 2) % 8;
-		t1 = msr / 8;
-		break;
-	case 0xc0000000 ... 0xc0001fff:
-		t0 = (8192 + msr - 0xc0000000) * 2;
-		t1 = (t0 / 8);
-		t0 %= 8;
-		break;
-	case 0xc0010000 ... 0xc0011fff:
-		t0 = (16384 + msr - 0xc0010000) * 2;
-		t1 = (t0 / 8);
-		t0 %= 8;
-		break;
-	default:
-		ret = true;
-		goto out;
-	}
+	if (offset == MSR_INVALID)
+		return NESTED_EXIT_DONE;
 
-	if (!kvm_read_guest(svm->vcpu.kvm, svm->nested.vmcb_msrpm + t1, &val, 1))
-		ret = val & ((1 << param) << t0);
+	/* Offset is in 32 bit units but need in 8 bit units */
+	offset = svm->nested.vmcb_msrpm + (offset * 4);
 
-out:
-	return ret;
+	if (kvm_read_guest(svm->vcpu.kvm, offset, &value, 4))
+		return NESTED_EXIT_DONE;
+
+	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
 }
 
 static int nested_svm_exit_special(struct vcpu_svm *svm)
-- 
1.7.0


