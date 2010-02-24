Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0BXSAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:00:50 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:8098 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab0BXR7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:44 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXZ4-02-PJX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/11] KVM: SVM: Handle nested selective_cr0 intercept correctly
Date: Wed, 24 Feb 2010 18:59:18 +0100
Message-ID: <1267034360-5907-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0683 (UTC) FILETIME=[18E64730:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have the following situation with nested svm:

1. Host KVM intercepts cr0 writes
2. Guest hypervisor intercepts only selective cr0 writes

Then we get an cr0 write intercept which is handled on the
host. But that intercepts may actually be a selective cr0
intercept for the guest. This patch checks for this
condition and injects a selective cr0 intercept if needed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2450a7c..22654de 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1037,6 +1037,27 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_nested(svm)) {
+		/*
+		 * We are here because we run in nested mode, the host kvm
+		 * intercepts cr0 writes but the l1 hypervisor does not.
+		 * But the L1 hypervisor may intercept selective cr0 writes.
+		 * This needs to be checked here.
+		 */
+		unsigned long old, new;
+
+		/* Remove bits that would trigger a real cr0 write intercept */
+		old = vcpu->arch.cr0 & SVM_CR0_SELECTIVE_MASK;
+		new = cr0 & SVM_CR0_SELECTIVE_MASK;
+
+		if (old == new) {
+			/* cr0 write with ts and mp unchanged */
+			svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+			if (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE)
+				return;
+		}
+	}
+
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
-- 
1.7.0


