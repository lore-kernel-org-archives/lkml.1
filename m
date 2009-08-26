Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbZHZKgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbZHZKgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932528AbZHZKdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/47] KVM: SVM: Drop tlb flush workaround in npt
Date: Wed, 26 Aug 2009 13:29:56 +0300
Message-Id: <1251282609-12835-35-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer possible to reproduce the problem any more, so presumably
it has been fixed.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index be0f6ef..7853dd3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1187,17 +1187,8 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(fault_address, error_code);
-	/*
-	 * FIXME: Tis shouldn't be necessary here, but there is a flush
-	 * missing in the MMU code. Until we find this bug, flush the
-	 * complete TLB here on an NPF
-	 */
-	if (npt_enabled)
-		svm_flush_tlb(&svm->vcpu);
-	else {
-		if (kvm_event_needs_reinjection(&svm->vcpu))
-			kvm_mmu_unprotect_page_virt(&svm->vcpu, fault_address);
-	}
+	if (!npt_enabled && kvm_event_needs_reinjection(&svm->vcpu))
+		kvm_mmu_unprotect_page_virt(&svm->vcpu, fault_address);
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 }
 
-- 
1.6.4.1

