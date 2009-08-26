Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZHZKdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZHZKdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbZHZKdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/47] KVM: SVM: complete interrupts after handling nested exits
Date: Wed, 26 Aug 2009 13:29:38 +0300
Message-Id: <1251282609-12835-17-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The interrupt completion code must run after nested exits are handled
because not injected interrupts or exceptions may be handled by the l1
guest first.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index df795bc..825b825 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -111,6 +111,7 @@ static int nested = 0;
 module_param(nested, int, S_IRUGO);
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
+static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
@@ -2324,6 +2325,8 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		}
 	}
 
+	svm_complete_interrupts(svm);
+
 	if (npt_enabled) {
 		int mmu_reload = 0;
 		if ((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG) {
@@ -2690,8 +2693,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
 		vcpu->arch.regs_dirty &= ~(1 << VCPU_EXREG_PDPTR);
 	}
-
-	svm_complete_interrupts(svm);
 }
 
 #undef R
-- 
1.6.4.1

