Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYDUKhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYDUKhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYDUKa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:28 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37971
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbYDUKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:09 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 24/31] KVM: SVM: sync TPR value to V_TPR field in the VMCB
Date: Mon, 21 Apr 2008 13:29:50 +0300
Message-Id: <1208773797-7829-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds syncing of the lapic.tpr field to the V_TPR field of the VMCB.
With this change we can safely remove the CR8 read intercept.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3379e13..f8ce36e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -486,8 +486,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	control->intercept_cr_read = 	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
-					INTERCEPT_CR4_MASK |
-					INTERCEPT_CR8_MASK;
+					INTERCEPT_CR4_MASK;
 
 	control->intercept_cr_write = 	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
@@ -1621,6 +1620,19 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 }
 
+static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 cr8;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return;
+
+	cr8 = kvm_get_cr8(vcpu);
+	svm->vmcb->control.int_ctl &= ~V_TPR_MASK;
+	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
+}
+
 static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1630,6 +1642,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	pre_svm_run(svm);
 
+	sync_lapic_to_cr8(vcpu);
+
 	save_host_msrs(vcpu);
 	fs_selector = read_fs();
 	gs_selector = read_gs();
-- 
1.5.5

