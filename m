Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZG2M52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZG2M52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZG2M51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:27 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:18767 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754798AbZG2M5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:57:11 -0400
X-SpamScore: 13
X-BigFish: VPS13(z1857rzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KNJNYG-03-5SS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/12] kvm/svm: handle #pf intercepts in nested_svm_exit_handled directly
Date: Wed, 29 Jul 2009 14:56:31 +0200
Message-ID: <1248872192-30881-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:36.0983 (UTC) FILETIME=[01F45870:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1a44e43..381ed38 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1498,6 +1498,9 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
 	return 0;
 }
 
+/*
+ * If this function returns true, this #vmexit was already handled
+ */
 static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
@@ -1515,8 +1518,27 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 			break;
 		/* When we're shadowing, trap PFs */
 		case SVM_EXIT_EXCP_BASE + PF_VECTOR:
-			if (!npt_enabled)
-				return 0;
+			if (!npt_enabled) {
+				u64 fault_address;
+				u32 error_code;
+
+				fault_address  = svm->vmcb->control.exit_info_2;
+				error_code     = svm->vmcb->control.exit_info_1;
+
+				kvm_mmu_page_fault(&svm->vcpu,
+						   fault_address,
+						   error_code);
+
+				/*
+				 * If we are still nested here the pending
+				 * irqs/exceptions must be reinjected
+				 */
+				//if (is_nested(svm))
+				//	svm_complete_interrupts(svm);
+
+				return true;
+			}
+
 			break;
 		default:
 			break;
-- 
1.6.3.3


