Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab0CAOfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:35:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:23001 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0CAOfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:35:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zba6lz936eMab9bhzz1202hzzz32i6bh2a8h87h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLXU2-02-IRQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/7] KVM: SVM: Use svm_msrpm_offset in nested_svm_exit_handled_msr
Date: Mon, 1 Mar 2010 15:34:38 +0100
Message-ID: <1267454080-2513-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
References: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 14:34:46.0309 (UTC) FILETIME=[57146D50:01CAB94C]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a generic function now to calculate msrpm offsets.
Use that function in nested_svm_exit_handled_msr() remove
the duplicate logic (which had a bug anyway).

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   47 +++++++++++++++++------------------------------
 1 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c04ce1e..b705115 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1654,40 +1654,27 @@ static void nested_svm_unmap(struct page *page)
 
 static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
-	u32 param = svm->vmcb->control.exit_info_1 & 1;
-	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	u32 t0, t1;
-	int ret;
-	u8 val;
+	u32 offset, msr, value;
+	int write, mask;
 
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
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
-		ret = NESTED_EXIT_DONE;
-		goto out;
-	}
+	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	offset = svm_msrpm_offset(msr);
+	write  = svm->vmcb->control.exit_info_1 & 1;
+	mask   = 1 << ((2 * (msr & 0xf)) + write);
 
-	if (!kvm_read_guest(svm->vcpu.kvm, svm->nested.vmcb_msrpm + t1, &val, 1))
-		ret = val & ((1 << param) << t0) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
+	if (offset == MSR_INVALID)
+		return NESTED_EXIT_DONE;
 
-out:
-	return ret;
+	/* Offset is in 32 bit units but need in 8 bit units */
+	offset *= 4;
+
+	if (kvm_read_guest(svm->vcpu.kvm, svm->nested.vmcb_msrpm + offset, &value, 4))
+		return NESTED_EXIT_DONE;
+
+	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
 }
 
 static int nested_svm_exit_special(struct vcpu_svm *svm)
@@ -1948,8 +1935,8 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 		if (msrpm_offsets[i] == 0xffffffff)
 			break;
 
-		offset = svm->nested.vmcb_msrpm + msrpm_offsets[i];
-		p      = msrpm_offsets[i] / 4;
+		p      = msrpm_offsets[i];
+		offset = svm->nested.vmcb_msrpm + (p * 4);
 
 		if (kvm_read_guest(svm->vcpu.kvm, offset, &value, 4))
 			return false;
-- 
1.7.0


