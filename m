Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0BSPXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:23:37 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8983 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab0BSPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:32 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEU-02-7NJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/11] KVM: SVM: Make lazy FPU switching work with nested svm
Date: Fri, 19 Feb 2010 16:23:08 +0100
Message-ID: <1266592990-8911-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0933 (UTC) FILETIME=[736E8D50:01CAB177]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new lazy fpu switching code may disable cr0 intercepts
when running nested. This is a bug because the nested
hypervisor may still want to intercept cr0 which will break
in this situation. This patch fixes this issue and makes
lazy fpu switching working with nested svm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4e8d42b..8119355 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -973,6 +973,7 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = svm->vmcb;
 	ulong gcr0 = svm->vcpu.arch.cr0;
 	u64 *hcr0 = &svm->vmcb->save.cr0;
 
@@ -984,11 +985,25 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 
 
 	if (gcr0 == *hcr0 && svm->vcpu.fpu_active) {
-		svm->vmcb->control.intercept_cr_read &= ~INTERCEPT_CR0_MASK;
-		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR0_MASK;
+		vmcb->control.intercept_cr_read &= ~INTERCEPT_CR0_MASK;
+		vmcb->control.intercept_cr_write &= ~INTERCEPT_CR0_MASK;
+		if (is_nested(svm)) {
+			struct vmcb *hsave = svm->nested.hsave;
+
+			hsave->control.intercept_cr_read  &= ~INTERCEPT_CR0_MASK;
+			hsave->control.intercept_cr_write &= ~INTERCEPT_CR0_MASK;
+			vmcb->control.intercept_cr_read  |= svm->nested.intercept_cr_read;
+			vmcb->control.intercept_cr_write |= svm->nested.intercept_cr_write;
+		}
 	} else {
 		svm->vmcb->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
 		svm->vmcb->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
+		if (is_nested(svm)) {
+			struct vmcb *hsave = svm->nested.hsave;
+
+			hsave->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
+			hsave->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
+		}
 	}
 }
 
@@ -1263,7 +1278,22 @@ static int ud_interception(struct vcpu_svm *svm)
 static void svm_fpu_activate(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
+	u32 excp;
+
+	if (is_nested(svm)) {
+		u32 h_excp, n_excp;
+
+		h_excp  = svm->nested.hsave->control.intercept_exceptions;
+		n_excp  = svm->nested.intercept_exceptions;
+		h_excp &= ~(1 << NM_VECTOR);
+		excp    = h_excp | n_excp;
+	} else {
+		excp  = svm->vmcb->control.intercept_exceptions;
+	        excp &= ~(1 << NM_VECTOR);
+	}
+
+	svm->vmcb->control.intercept_exceptions = excp;
+
 	svm->vcpu.fpu_active = 1;
 	update_cr0_intercept(svm);
 }
@@ -1508,6 +1538,9 @@ static int nested_svm_exit_special(struct vcpu_svm *svm)
 		if (!npt_enabled)
 			return NESTED_EXIT_HOST;
 		break;
+	case SVM_EXIT_EXCP_BASE + NM_VECTOR:
+		nm_interception(svm);
+		break;
 	default:
 		break;
 	}
@@ -2973,8 +3006,10 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	update_cr0_intercept(svm);
 	svm->vmcb->control.intercept_exceptions |= 1 << NM_VECTOR;
+	if (is_nested(svm))
+		svm->nested.hsave->control.intercept_exceptions |= 1 << NM_VECTOR;
+	update_cr0_intercept(svm);
 }
 
 static struct kvm_x86_ops svm_x86_ops = {
-- 
1.6.6


