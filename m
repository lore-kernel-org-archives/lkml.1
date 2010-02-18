Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab0BRLjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:39:11 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:16507
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757957Ab0BRLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:39:00 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1CCK-01-N2R-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 06/10] KVM: SVM: Fix nested msr intercept handling
Date: Thu, 18 Feb 2010 12:38:31 +0100
Message-ID: <1266493115-28386-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0624 (UTC) FILETIME=[E91BD380:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested_svm_exit_handled_msr() function maps only one
page of the guests msr permission bitmap. This patch changes
the code to use kvm_read_guest to fix the bug.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3f59cbd..cbf798f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1457,16 +1457,11 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
 	bool ret = false;
 	u32 t0, t1;
-	u8 *msrpm;
+	u8 val;
 
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return false;
 
-	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm);
-
-	if (!msrpm)
-		goto out;
-
 	switch (msr) {
 	case 0 ... 0x1fff:
 		t0 = (msr * 2) % 8;
@@ -1487,11 +1482,10 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 		goto out;
 	}
 
-	ret = msrpm[t1] & ((1 << param) << t0);
+	if (!kvm_read_guest(svm->vcpu.kvm, svm->nested.vmcb_msrpm + t1, &val, 1))
+		ret = val & ((1 << param) << t0);
 
 out:
-	nested_svm_unmap(msrpm);
-
 	return ret;
 }
 
-- 
1.6.6


