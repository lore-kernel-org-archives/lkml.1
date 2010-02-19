Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0BSPXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:23:33 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:30088
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752460Ab0BSPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:26 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMab9bhzz1202hzzz32i6bh87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEP-02-7NE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 03/11] KVM: SVM: Fix schedule-while-atomic on nested exception handling
Date: Fri, 19 Feb 2010 16:23:02 +0100
Message-ID: <1266592990-8911-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0683 (UTC) FILETIME=[734867B0:01CAB177]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the actual vmexit routine out of code that runs with
irqs and preemption disabled.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f87fc98..6dc7a41 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -128,6 +128,7 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
+static int nested_svm_intercept(struct vcpu_svm *svm);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
@@ -1378,6 +1379,8 @@ static int nested_svm_check_permissions(struct vcpu_svm *svm)
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code)
 {
+	int vmexit;
+
 	if (!is_nested(svm))
 		return 0;
 
@@ -1386,7 +1389,11 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	svm->vmcb->control.exit_info_1 = error_code;
 	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 
-	return nested_svm_exit_handled(svm);
+	vmexit = nested_svm_intercept(svm);
+	if (vmexit == NESTED_EXIT_DONE)
+		svm->nested.exit_required = true;
+
+	return vmexit;
 }
 
 /* This function returns true if it is save to enable the irq window */
@@ -1516,7 +1523,7 @@ static int nested_svm_exit_special(struct vcpu_svm *svm)
 /*
  * If this function returns true, this #vmexit was already handled
  */
-static int nested_svm_exit_handled(struct vcpu_svm *svm)
+static int nested_svm_intercept(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
 	int vmexit = NESTED_EXIT_HOST;
@@ -1562,9 +1569,17 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm)
 	}
 	}
 
-	if (vmexit == NESTED_EXIT_DONE) {
+	return vmexit;
+}
+
+static int nested_svm_exit_handled(struct vcpu_svm *svm)
+{
+	int vmexit;
+
+	vmexit = nested_svm_intercept(svm);
+
+	if (vmexit == NESTED_EXIT_DONE)
 		nested_svm_vmexit(svm);
-	}
 
 	return vmexit;
 }
-- 
1.6.6


