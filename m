Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0BSPYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:24:50 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:36175
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754399Ab0BSPXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:30 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEP-02-7NC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 02/11] KVM: SVM: Fix wrong interrupt injection in enable_irq_windows
Date: Fri, 19 Feb 2010 16:23:01 +0100
Message-ID: <1266592990-8911-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0699 (UTC) FILETIME=[734AD8B0:01CAB177]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested_svm_intr() function does not execute the vmexit
anymore. Therefore we may still be in the nested state after
that function ran. This patch changes the nested_svm_intr()
function to return wether the irq window could be enabled.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 63ecd4d..f87fc98 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1389,16 +1389,17 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	return nested_svm_exit_handled(svm);
 }
 
-static inline int nested_svm_intr(struct vcpu_svm *svm)
+/* This function returns true if it is save to enable the irq window */
+static inline bool nested_svm_intr(struct vcpu_svm *svm)
 {
 	if (!is_nested(svm))
-		return 0;
+		return true;
 
 	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
-		return 0;
+		return true;
 
 	if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
-		return 0;
+		return false;
 
 	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
 
@@ -1411,10 +1412,10 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 		 */
 		svm->nested.exit_required = true;
 		trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
-		return 1;
+		return false;
 	}
 
-	return 0;
+	return true;
 }
 
 static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
@@ -2563,13 +2564,11 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	nested_svm_intr(svm);
-
 	/* In case GIF=0 we can't rely on the CPU to tell us when
 	 * GIF becomes 1, because that's a separate STGI/VMRUN intercept.
 	 * The next time we get that intercept, this function will be
 	 * called again though and we'll get the vintr intercept. */
-	if (gif_set(svm)) {
+	if (gif_set(svm) && nested_svm_intr(svm)) {
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}
-- 
1.6.6


