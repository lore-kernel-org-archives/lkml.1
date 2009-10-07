Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZJGOdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZJGOdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbZJGOdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:33:07 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42041
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759430AbZJGOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:33:03 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR5F0V-02-3PB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/10] KVM: SVM: Move nested INTR #vmexit into preemtible code
Date: Wed, 7 Oct 2009 16:31:21 +0200
Message-ID: <1254925888-13743-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0170 (UTC) FILETIME=[DF412E20:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes use of the KVM_REQ_VMEXIT to move the
emulation of #vmexit(INTR) out of non-preemptible code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b6ce1a9..7015680 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1379,8 +1379,14 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 
 	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
 
-	if (nested_svm_exit_handled(svm)) {
-		nsvm_printk("VMexit -> INTR\n");
+	if (svm->nested.intercept & 1ULL) {
+		/*
+		 * The #vmexit can't be emulated here directly because this
+		 * code path runs with irqs and preemtion disabled and a
+		 * #vmexit emulation might sleep. Only set the request bit for
+		 * the #vmexit here.
+		 */
+		set_bit(KVM_REQ_VMEXIT, &svm->vcpu.requests);
 		return 1;
 	}
 
@@ -2859,6 +2865,13 @@ static bool svm_gb_page_enable(void)
 	return true;
 }
 
+static void svm_emulate_vmexit(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	nested_svm_vmexit(svm);
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -2923,6 +2936,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.exit_reasons_str = svm_exit_reasons_str,
 	.gb_page_enable = svm_gb_page_enable,
+	.emulate_vmexit = svm_emulate_vmexit,
 };
 
 static int __init svm_init(void)
-- 
1.6.4.3


