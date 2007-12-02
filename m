Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXLBLTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXLBLTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXLBLSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:12 -0500
Received: from il.qumranet.com ([82.166.9.18]:41426 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbXLBLSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 04/10] KVM: SVM: Intercept the 'invd' and 'wbinvd' instructions
Date: Sun,  2 Dec 2007 13:18:41 +0200
Message-Id: <11965943273317-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'invd' can destroy host data, and 'wbinvd' allows the guest to induce
long (milliseconds) latencies.

Noted by Ben Serebrin.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index bc818cc..fae8cc5 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -506,6 +506,7 @@ static void init_vmcb(struct vmcb *vmcb)
 		 */
 		/*              (1ULL << INTERCEPT_SELECTIVE_CR0) | */
 				(1ULL << INTERCEPT_CPUID) |
+				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
 				(1ULL << INTERCEPT_INVLPGA) |
 				(1ULL << INTERCEPT_IOIO_PROT) |
@@ -519,6 +520,7 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_STGI) |
 				(1ULL << INTERCEPT_CLGI) |
 				(1ULL << INTERCEPT_SKINIT) |
+				(1ULL << INTERCEPT_WBINVD) |
 				(1ULL << INTERCEPT_MONITOR) |
 				(1ULL << INTERCEPT_MWAIT);
 
@@ -1319,6 +1321,7 @@ static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	/* [SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception, */
 	[SVM_EXIT_CPUID]			= cpuid_interception,
+	[SVM_EXIT_INVD]                         = emulate_on_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= emulate_on_interception,
 	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
@@ -1333,6 +1336,7 @@ static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[SVM_EXIT_STGI]				= invalid_op_interception,
 	[SVM_EXIT_CLGI]				= invalid_op_interception,
 	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
 };
-- 
1.5.3

