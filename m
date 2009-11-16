Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZKPMUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZKPMUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZKPMUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 38/42] KVM: SVM: Notify nested hypervisor of lost event injections
Date: Mon, 16 Nov 2009 14:19:39 +0200
Message-Id: <1258373983-8693-39-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

If event_inj is valid on a #vmexit the host CPU would write
the contents to exit_int_info, so the hypervisor knows that
the event wasn't injected.

We don't do this in nested SVM by now which is a bug and
fixed by this patch.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 279a2ae..e372854 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1615,6 +1615,22 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
 	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
 	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
+
+	/*
+	 * If we emulate a VMRUN/#VMEXIT in the same host #vmexit cycle we have
+	 * to make sure that we do not lose injected events. So check event_inj
+	 * here and copy it to exit_int_info if it is valid.
+	 * Exit_int_info and event_inj can't be both valid because the case
+	 * below only happens on a VMRUN instruction intercept which has
+	 * no valid exit_int_info set.
+	 */
+	if (vmcb->control.event_inj & SVM_EVTINJ_VALID) {
+		struct vmcb_control_area *nc = &nested_vmcb->control;
+
+		nc->exit_int_info     = vmcb->control.event_inj;
+		nc->exit_int_info_err = vmcb->control.event_inj_err;
+	}
+
 	nested_vmcb->control.tlb_ctl           = 0;
 	nested_vmcb->control.event_inj         = 0;
 	nested_vmcb->control.event_inj_err     = 0;
-- 
1.6.5.2

