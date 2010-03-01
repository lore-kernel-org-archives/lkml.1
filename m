Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab0CAOfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:35:10 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:20916 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0CAOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:35:00 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLXU0-01-AWC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/7] KVM: SVM: Return correct values in nested_svm_exit_handled_msr
Date: Mon, 1 Mar 2010 15:34:34 +0100
Message-ID: <1267454080-2513-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
References: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 14:34:46.0090 (UTC) FILETIME=[56F302A0:01CAB94C]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested_svm_exit_handled_msr() returned an bool which is
a bug. I worked by accident because the exected integer
return values match with the true and false values. This
patch changes the return value to int and let the function
return the correct values.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1397877..9dfbbae 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1546,16 +1546,16 @@ static void nested_svm_unmap(struct page *page)
 	kvm_release_page_dirty(page);
 }
 
-static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
+static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
 	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	bool ret = false;
 	u32 t0, t1;
+	int ret;
 	u8 val;
 
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
-		return false;
+		return NESTED_EXIT_HOST;
 
 	switch (msr) {
 	case 0 ... 0x1fff:
@@ -1573,12 +1573,12 @@ static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 		t0 %= 8;
 		break;
 	default:
-		ret = true;
+		ret = NESTED_EXIT_DONE;
 		goto out;
 	}
 
 	if (!kvm_read_guest(svm->vcpu.kvm, svm->nested.vmcb_msrpm + t1, &val, 1))
-		ret = val & ((1 << param) << t0);
+		ret = val & ((1 << param) << t0) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
 
 out:
 	return ret;
-- 
1.7.0


