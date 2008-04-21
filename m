Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbYDUKb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbYDUKb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYDUKaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:10 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37872
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYDUKaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:01 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/31] KVM: SVM: add intercept for machine check exception
Date: Mon, 21 Apr 2008 13:29:31 +0300
Message-Id: <1208773797-7829-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

To properly forward a MCE occured while the guest is running to the host, we
have to intercept this exception and call the host handler by hand. This is
implemented by this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |   17 ++++++++++++++++-
 include/asm-x86/kvm_host.h |    1 +
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8af463b..da3ddef 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -507,7 +507,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 					INTERCEPT_DR7_MASK;
 
 	control->intercept_exceptions = (1 << PF_VECTOR) |
-					(1 << UD_VECTOR);
+					(1 << UD_VECTOR) |
+					(1 << MC_VECTOR);
 
 
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
@@ -1044,6 +1045,19 @@ static int nm_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int mc_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	/*
+	 * On an #MC intercept the MCE handler is not called automatically in
+	 * the host. So do it by hand here.
+	 */
+	asm volatile (
+		"int $0x12\n");
+	/* not sure if we ever come back to this point */
+
+	return 1;
+}
+
 static int shutdown_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	/*
@@ -1367,6 +1381,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_EXCP_BASE + UD_VECTOR]	= ud_interception,
 	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
 	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
+	[SVM_EXIT_EXCP_BASE + MC_VECTOR] 	= mc_interception,
 	[SVM_EXIT_INTR] 			= nop_on_interception,
 	[SVM_EXIT_NMI]				= nop_on_interception,
 	[SVM_EXIT_SMI]				= nop_on_interception,
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index de3eccf..2861178 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -62,6 +62,7 @@
 #define SS_VECTOR 12
 #define GP_VECTOR 13
 #define PF_VECTOR 14
+#define MC_VECTOR 18
 
 #define SELECTOR_TI_MASK (1 << 2)
 #define SELECTOR_RPL_MASK 0x03
-- 
1.5.5

