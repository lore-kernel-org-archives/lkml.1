Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZG2M5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZG2M5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZG2M5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:20 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:23006
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754682AbZG2M44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:56:56 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNJNYI-04-402-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/12] kvm/svm: simplify nested_svm_check_exception
Date: Wed, 29 Jul 2009 14:56:32 +0200
Message-ID: <1248872192-30881-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:37.0186 (UTC) FILETIME=[02135220:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 381ed38..f81de35 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1366,18 +1366,15 @@ static int nested_svm_check_permissions(struct vcpu_svm *svm)
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code)
 {
-	if (is_nested(svm)) {
-		svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
-		svm->vmcb->control.exit_code_hi = 0;
-		svm->vmcb->control.exit_info_1 = error_code;
-		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
-		if (nested_svm_exit_handled(svm, false)) {
-			nsvm_printk("VMexit -> EXCP 0x%x\n", nr);
-			return 1;
-		}
-	}
+	if (!is_nested(svm))
+		return 0;
 
-	return 0;
+	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
+	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_info_1 = error_code;
+	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
+
+	return nested_svm_exit_handled(svm, false);
 }
 
 static inline int nested_svm_intr(struct vcpu_svm *svm)
-- 
1.6.3.3


