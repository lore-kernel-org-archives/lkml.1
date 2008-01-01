Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYAAPvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYAAPvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbYAAPhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:04 -0500
Received: from il.qumranet.com ([82.166.9.18]:33787 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbYAAPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 52/54] KVM: SVM: Exit to userspace if write to cr8 and not using in-kernel apic
Date: Tue,  1 Jan 2008 17:36:18 +0200
Message-Id: <1199201780-14001-53-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

With this patch KVM on SVM will exit to userspace if the guest writes to CR8
and the in-kernel APIC is disabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 677b525..9f8564a 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1048,6 +1048,15 @@ static int emulate_on_interception(struct vcpu_svm *svm,
 	return 1;
 }
 
+static int cr8_write_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	emulate_instruction(&svm->vcpu, NULL, 0, 0, 0);
+	if (irqchip_in_kernel(svm->vcpu.kvm))
+		return 1;
+	kvm_run->exit_reason = KVM_EXIT_SET_TPR;
+	return 0;
+}
+
 static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1202,7 +1211,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_WRITE_CR0]          		= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR3]          		= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR4]          		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR8]          		= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR8]          		= cr8_write_interception,
 	[SVM_EXIT_READ_DR0] 			= emulate_on_interception,
 	[SVM_EXIT_READ_DR1]			= emulate_on_interception,
 	[SVM_EXIT_READ_DR2]			= emulate_on_interception,
-- 
1.5.3.7

