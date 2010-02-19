Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0BSPaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:30:12 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:29236
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750879Ab0BSPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:30:08 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEQ-02-7NF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 06/11] KVM: SVM: Fix nested msr intercept handling
Date: Fri, 19 Feb 2010 16:23:05 +0100
Message-ID: <1266592990-8911-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0886 (UTC) FILETIME=[73676160:01CAB177]
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
 arch/x86/kvm/svm.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4becefd..f22ced1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1456,19 +1456,13 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
 	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	struct page *page;
 	bool ret = false;
 	u32 t0, t1;
-	u8 *msrpm;
+	u8 val;
 
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return false;
 
-	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
-
-	if (!msrpm)
-		goto out;
-
 	switch (msr) {
 	case 0 ... 0x1fff:
 		t0 = (msr * 2) % 8;
@@ -1489,11 +1483,10 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 		goto out;
 	}
 
-	ret = msrpm[t1] & ((1 << param) << t0);
+	if (!kvm_read_guest(svm->vcpu.kvm, svm->nested.vmcb_msrpm + t1, &val, 1))
+		ret = val & ((1 << param) << t0);
 
 out:
-	nested_svm_unmap(page);
-
 	return ret;
 }
 
-- 
1.6.6


