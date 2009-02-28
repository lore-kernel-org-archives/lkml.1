Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbZB1Bps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbZB1Bps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZB1BmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41772 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/30] KVM: Drop unused evaluations from string pio handlers
Date: Sat, 28 Feb 2009 03:41:30 +0200
Message-Id: <1235785309-12835-12-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Looks like neither the direction nor the rep prefix are used anymore.
Drop related evaluations from SVM's and VMX's I/O exit handlers.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    4 +---
 arch/x86/kvm/vmx.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1c4a018..22e88a4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1194,7 +1194,7 @@ static int shutdown_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	u32 io_info = svm->vmcb->control.exit_info_1; /* address size bug? */
-	int size, down, in, string, rep;
+	int size, in, string;
 	unsigned port;
 
 	++svm->vcpu.stat.io_exits;
@@ -1213,8 +1213,6 @@ static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
 	port = io_info >> 16;
 	size = (io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT;
-	rep = (io_info & SVM_IOIO_REP_MASK) != 0;
-	down = (svm->vmcb->save.rflags & X86_EFLAGS_DF) != 0;
 
 	skip_emulated_instruction(&svm->vcpu);
 	return kvm_emulate_pio(&svm->vcpu, kvm_run, in, size, port);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index df454de..509b353 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2698,7 +2698,7 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	unsigned long exit_qualification;
-	int size, down, in, string, rep;
+	int size, in, string;
 	unsigned port;
 
 	++vcpu->stat.io_exits;
@@ -2714,8 +2714,6 @@ static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	size = (exit_qualification & 7) + 1;
 	in = (exit_qualification & 8) != 0;
-	down = (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_DF) != 0;
-	rep = (exit_qualification & 32) != 0;
 	port = exit_qualification >> 16;
 
 	skip_emulated_instruction(vcpu);
-- 
1.6.0.6

