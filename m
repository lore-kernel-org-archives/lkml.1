Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbZBZOSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbZBZOSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbZBZOPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 01/40] KVM: SVM: Clean up VINTR setting
Date: Thu, 26 Feb 2009 16:14:51 +0200
Message-Id: <1235657730-27683-2-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

The current VINTR intercept setters don't look clean to me. To make
the code easier to read and enable the possibilty to trap on a VINTR
set, this uses a helper function to set the VINTR intercept.

v2 uses two distinct functions for setting and clearing the bit

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a9e769e..33407d9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -718,6 +718,16 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	to_svm(vcpu)->vmcb->save.rflags = rflags;
 }
 
+static void svm_set_vintr(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.intercept |= 1ULL << INTERCEPT_VINTR;
+}
+
+static void svm_clear_vintr(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
+}
+
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 {
 	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
@@ -1380,7 +1390,7 @@ static int interrupt_window_interception(struct vcpu_svm *svm,
 {
 	KVMTRACE_0D(PEND_INTR, &svm->vcpu, handler);
 
-	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
+	svm_clear_vintr(svm);
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
@@ -1593,7 +1603,7 @@ static void svm_intr_assist(struct kvm_vcpu *vcpu)
 	    (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
 	    (vmcb->control.event_inj & SVM_EVTINJ_VALID)) {
 		/* unable to deliver irq, set pending irq */
-		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 		goto out;
 	}
@@ -1652,9 +1662,9 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 	 */
 	if (!svm->vcpu.arch.interrupt_window_open &&
 	    (svm->vcpu.arch.irq_summary || kvm_run->request_interrupt_window))
-		control->intercept |= 1ULL << INTERCEPT_VINTR;
-	 else
-		control->intercept &= ~(1ULL << INTERCEPT_VINTR);
+		svm_set_vintr(svm);
+	else
+		svm_clear_vintr(svm);
 }
 
 static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
-- 
1.6.0.6

