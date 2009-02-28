Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZB1BoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZB1BoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZB1BmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/30] KVM: s390: Fix problem state check for b2 intercepts
Date: Sat, 28 Feb 2009 03:41:24 +0200
Message-Id: <1235785309-12835-6-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The kernel handles some priviledged instruction exits. While I was
unable to trigger such an exit from guest userspace, the code should
check for supervisor state before emulating a priviledged instruction.

I also renamed kvm_s390_handle_priv to kvm_s390_handle_b2. After all
there are non priviledged b2 instructions like stck (store clock).

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/intercept.c |    2 +-
 arch/s390/kvm/kvm-s390.h  |    2 +-
 arch/s390/kvm/priv.c      |   18 +++++++++++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 6123610..9d19803 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -103,7 +103,7 @@ static int handle_lctl(struct kvm_vcpu *vcpu)
 static intercept_handler_t instruction_handlers[256] = {
 	[0x83] = kvm_s390_handle_diag,
 	[0xae] = kvm_s390_handle_sigp,
-	[0xb2] = kvm_s390_handle_priv,
+	[0xb2] = kvm_s390_handle_b2,
 	[0xb7] = handle_lctl,
 	[0xeb] = handle_lctlg,
 };
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 3893cf1..00bbe69 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -50,7 +50,7 @@ int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
 int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code);
 
 /* implemented in priv.c */
-int kvm_s390_handle_priv(struct kvm_vcpu *vcpu);
+int kvm_s390_handle_b2(struct kvm_vcpu *vcpu);
 
 /* implemented in sigp.c */
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 3605df4..4b88834 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -304,12 +304,24 @@ static intercept_handler_t priv_handlers[256] = {
 	[0xb1] = handle_stfl,
 };
 
-int kvm_s390_handle_priv(struct kvm_vcpu *vcpu)
+int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
 {
 	intercept_handler_t handler;
 
+	/*
+	 * a lot of B2 instructions are priviledged. We first check for
+	 * the priviledges ones, that we can handle in the kernel. If the
+	 * kernel can handle this instruction, we check for the problem
+	 * state bit and (a) handle the instruction or (b) send a code 2
+	 * program check.
+	 * Anything else goes to userspace.*/
 	handler = priv_handlers[vcpu->arch.sie_block->ipa & 0x00ff];
-	if (handler)
-		return handler(vcpu);
+	if (handler) {
+		if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+			return kvm_s390_inject_program_int(vcpu,
+						   PGM_PRIVILEGED_OPERATION);
+		else
+			return handler(vcpu);
+	}
 	return -ENOTSUPP;
 }
-- 
1.6.0.6

