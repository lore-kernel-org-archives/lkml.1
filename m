Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbXKHKgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbXKHKgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbXKHKfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:35:11 -0500
Received: from il.qumranet.com ([82.166.9.18]:52473 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464AbXKHKfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:35:03 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 5/5] KVM: SVM: Intercept the 'invd' and 'wbinvd' instructions
Date: Thu,  8 Nov 2007 12:35:30 +0200
Message-Id: <11945181301496-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11945181301744-git-send-email-avi@qumranet.com>
References: <11945181301744-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

'invd' can destroy host data, and 'wbinvd' allows the guest to induce
long (milliseconds) latencies.

Noted by Ben Serebrin.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 7376805..7a6eead 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -494,6 +494,7 @@ static void init_vmcb(struct vmcb *vmcb)
 		 */
 		/*              (1ULL << INTERCEPT_SELECTIVE_CR0) | */
 				(1ULL << INTERCEPT_CPUID) |
+				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
 				(1ULL << INTERCEPT_INVLPGA) |
 				(1ULL << INTERCEPT_IOIO_PROT) |
@@ -507,6 +508,7 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_STGI) |
 				(1ULL << INTERCEPT_CLGI) |
 				(1ULL << INTERCEPT_SKINIT) |
+				(1ULL << INTERCEPT_WBINVD) |
 				(1ULL << INTERCEPT_MONITOR) |
 				(1ULL << INTERCEPT_MWAIT);
 
@@ -1247,6 +1249,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	/* [SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception, */
 	[SVM_EXIT_CPUID]			= cpuid_interception,
+	[SVM_EXIT_INVD]                         = emulate_on_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= emulate_on_interception,
 	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
@@ -1261,6 +1264,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_STGI]				= invalid_op_interception,
 	[SVM_EXIT_CLGI]				= invalid_op_interception,
 	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
 };
-- 
1.5.3

