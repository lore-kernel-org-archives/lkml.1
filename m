Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0CCTOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:14:10 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27599 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab0CCTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:28 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01B-01-LM9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/18] KVM: SVM: Implement MMU helper functions for Nested Nested Paging
Date: Wed, 3 Mar 2010 20:12:10 +0100
Message-ID: <1267643541-451-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0657 (UTC) FILETIME=[7FC8B110:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the helper functions which will be used in
the mmu context for handling nested nested page faults.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a7a76f5..a6c08e0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -91,6 +91,9 @@ struct nested_state {
 	u32 intercept_exceptions;
 	u64 intercept;
 
+	/* Nested Paging related state */
+	u64 nested_cr3;
+
 };
 
 #define MSRPM_OFFSETS	16
@@ -1545,6 +1548,36 @@ static int vmmcall_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm->nested.nested_cr3;
+}
+
+static void nested_svm_set_tdp_cr3(struct kvm_vcpu *vcpu,
+				   unsigned long root)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.nested_cr3 = root;
+	force_new_asid(vcpu);
+}
+
+static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
+				       unsigned long addr,
+				       u32 error_code)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.exit_code = SVM_EXIT_NPF;
+	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_info_1 = error_code;
+	svm->vmcb->control.exit_info_2 = addr;
+
+	nested_svm_vmexit(svm);
+}
+
 static int nested_svm_check_permissions(struct vcpu_svm *svm)
 {
 	if (!(svm->vcpu.arch.efer & EFER_SVME)
-- 
1.7.0


