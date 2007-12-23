Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXLWPJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXLWPJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbXLWOwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:36 -0500
Received: from il.qumranet.com ([82.166.9.18]:35901 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbXLWOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 40/50] KVM: Move apic timer interrupt backlog processing to common code
Date: Sun, 23 Dec 2007 16:51:25 +0200
Message-Id: <1198421495-31481-41-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beside the obvious goodness of making code more common, this prevents
a livelock with the next patch which moves interrupt injection out of the
critical section.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 ++
 drivers/kvm/svm.c      |    1 -
 drivers/kvm/vmx.c      |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 03d6069..c94d4df 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2144,6 +2144,8 @@ again:
 	if (unlikely(r))
 		goto out;
 
+	kvm_inject_pending_timer_irqs(vcpu);
+
 	preempt_disable();
 
 	kvm_x86_ops->prepare_guest_switch(vcpu);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 746a377..4ff2922 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1355,7 +1355,6 @@ static void svm_intr_assist(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	int intr_vector = -1;
 
-	kvm_inject_pending_timer_irqs(vcpu);
 	if ((vmcb->control.exit_int_info & SVM_EVTINJ_VALID) &&
 	    ((vmcb->control.exit_int_info & SVM_EVTINJ_TYPE_MASK) == 0)) {
 		intr_vector = vmcb->control.exit_int_info &
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 1336174..be6846d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2191,7 +2191,6 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 	int has_ext_irq, interrupt_window_open;
 	int vector;
 
-	kvm_inject_pending_timer_irqs(vcpu);
 	update_tpr_threshold(vcpu);
 
 	has_ext_irq = kvm_cpu_has_interrupt(vcpu);
-- 
1.5.3.7

