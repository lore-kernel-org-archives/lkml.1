Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZKSNlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZKSNlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZKSNjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 18/35] KVM: SVM: Reset cr0 properly on vcpu reset
Date: Thu, 19 Nov 2009 15:34:54 +0200
Message-Id: <1258637711-11674-19-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

svm_vcpu_reset() was not properly resetting the contents of the guest-visible
cr0 register, causing the following issue:
https://bugzilla.redhat.com/show_bug.cgi?id=525699

Without resetting cr0 properly, the vcpu was running the SIPI bootstrap routine
with paging enabled, making the vcpu get a pagefault exception while trying to
run it.

Instead of setting vmcb->save.cr0 directly, the new code just resets
kvm->arch.cr0 and calls kvm_set_cr0(). The bits that were set/cleared on
vmcb->save.cr0 (PG, WP, !CD, !NW) will be set properly by svm_set_cr0().

kvm_set_cr0() is used instead of calling svm_set_cr0() directly to make sure
kvm_mmu_reset_context() is called to reset the mmu to nonpaging mode.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ffa6ad2..c9ef6c0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -628,11 +628,12 @@ static void init_vmcb(struct vcpu_svm *svm)
 	save->rip = 0x0000fff0;
 	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
 
-	/*
-	 * cr0 val on cpu init should be 0x60000010, we enable cpu
-	 * cache by default. the orderly way is to enable cache in bios.
+	/* This is the guest-visible cr0 value.
+	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
 	 */
-	save->cr0 = 0x00000010 | X86_CR0_PG | X86_CR0_WP;
+	svm->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
+	kvm_set_cr0(&svm->vcpu, svm->vcpu.arch.cr0);
+
 	save->cr4 = X86_CR4_PAE;
 	/* rdx = ?? */
 
-- 
1.6.5.2

