Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbYDUKhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbYDUKhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYDUKa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:27 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37974
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbYDUKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:09 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 26/31] KVM: SVM: sync V_TPR with LAPIC.TPR if CR8 write intercept is disabled
Date: Mon, 21 Apr 2008 13:29:52 +0300
Message-Id: <1208773797-7829-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

If the CR8 write intercept is disabled the V_TPR field of the VMCB needs to be
synced with the TPR field in the local apic.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ce36e..ee2ee83 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1620,6 +1620,16 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 }
 
+static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR8_MASK)) {
+		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
+		kvm_lapic_set_tpr(vcpu, cr8);
+	}
+}
+
 static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1791,6 +1801,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	stgi();
 
+	sync_cr8_to_lapic(vcpu);
+
 	svm->next_rip = 0;
 }
 
-- 
1.5.5

