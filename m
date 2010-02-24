Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0BXSCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:02:02 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:30734
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757477Ab0BXSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:01:56 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXYZ-01-2QY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/11] KVM: SVM: Check for nested intercepts on NMI injection
Date: Wed, 24 Feb 2010 18:59:12 +0100
Message-ID: <1267034360-5907-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0465 (UTC) FILETIME=[18C50390:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the NMI intercept checking for nested
svm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b821b2f..9759d9f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1480,6 +1480,20 @@ static inline bool nested_svm_intr(struct vcpu_svm *svm)
 	return true;
 }
 
+/* This function returns true if it is save to enable the nmi window */
+static inline bool nested_svm_nmi(struct vcpu_svm *svm)
+{
+	if (!is_nested(svm))
+		return true;
+
+	if (!(svm->nested.intercept & (1ULL << INTERCEPT_NMI)))
+		return true;
+
+	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
+	svm->nested.exit_required = true;
+
+	return false;
+}
 static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
 {
 	struct page *page;
@@ -2681,9 +2695,11 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 	 * Something prevents NMI from been injected. Single step over possible
 	 * problem (IRET or exception injection or interrupt shadow)
 	 */
-	svm->nmi_singlestep = true;
-	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
-	update_db_intercept(vcpu);
+	if (gif_set(svm) && nested_svm_nmi(svm)) {
+		svm->nmi_singlestep = true;
+		svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+		update_db_intercept(vcpu);
+	}
 }
 
 static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
-- 
1.7.0


