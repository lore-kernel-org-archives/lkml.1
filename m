Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXDAOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXDAOiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXDAOiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:38:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:47574 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933278AbXDAOfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 30/41] KVM: SVM: forbid guest to execute monitor/mwait
Date: Sun,  1 Apr 2007 17:35:27 +0300
Message-Id: <1175438139312-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381391119-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch forbids the guest to execute monitor/mwait instructions on
SVM. This is necessary because the guest can execute these instructions
if they are available even if the kvm cpuid doesn't report its
existence.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    6 +++++-
 drivers/kvm/svm.h |    6 ++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index ddc0505..0542d33 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -511,7 +511,9 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_VMSAVE) |
 				(1ULL << INTERCEPT_STGI) |
 				(1ULL << INTERCEPT_CLGI) |
-				(1ULL << INTERCEPT_SKINIT);
+				(1ULL << INTERCEPT_SKINIT) |
+				(1ULL << INTERCEPT_MONITOR) |
+				(1ULL << INTERCEPT_MWAIT);
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = msrpm_base;
@@ -1292,6 +1294,8 @@ static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[SVM_EXIT_STGI]				= invalid_op_interception,
 	[SVM_EXIT_CLGI]				= invalid_op_interception,
 	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_MONITOR]			= invalid_op_interception,
+	[SVM_EXIT_MWAIT]			= invalid_op_interception,
 };
 
 
diff --git a/drivers/kvm/svm.h b/drivers/kvm/svm.h
index df731c3..5e93814 100644
--- a/drivers/kvm/svm.h
+++ b/drivers/kvm/svm.h
@@ -44,6 +44,9 @@ enum {
 	INTERCEPT_RDTSCP,
 	INTERCEPT_ICEBP,
 	INTERCEPT_WBINVD,
+	INTERCEPT_MONITOR,
+	INTERCEPT_MWAIT,
+	INTERCEPT_MWAIT_COND,
 };
 
 
@@ -298,6 +301,9 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_RDTSCP		0x087
 #define SVM_EXIT_ICEBP		0x088
 #define SVM_EXIT_WBINVD		0x089
+#define SVM_EXIT_MONITOR	0x08a
+#define SVM_EXIT_MWAIT		0x08b
+#define SVM_EXIT_MWAIT_COND	0x08c
 #define SVM_EXIT_NPF  		0x400
 
 #define SVM_EXIT_ERR		-1
-- 
1.5.0.5

