Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYLHLql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYLHLql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYLHLiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbYLHLhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:35 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 32/45] KVM: allow emulator to adjust rip for emulated pio instructions
Date: Mon,  8 Dec 2008 13:36:43 +0200
Message-Id: <1228736216-15787-33-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

If we call the emulator we shouldn't call skip_emulated_instruction()
in the first place, since the emulator already computes the next rip
for us. Thus we move ->skip_emulated_instruction() out of
kvm_emulate_pio() and into handle_io() (and the svm equivalent). We
also replaced "return 0" by "break" in the "do_io:" case because now
the shadow register state needs to be committed. Otherwise eip will never
be updated.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c         |    1 +
 arch/x86/kvm/vmx.c         |    1 +
 arch/x86/kvm/x86.c         |    2 --
 arch/x86/kvm/x86_emulate.c |    2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 743aebd..f0ad4d4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1115,6 +1115,7 @@ static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	rep = (io_info & SVM_IOIO_REP_MASK) != 0;
 	down = (svm->vmcb->save.rflags & X86_EFLAGS_DF) != 0;
 
+	skip_emulated_instruction(&svm->vcpu);
 	return kvm_emulate_pio(&svm->vcpu, kvm_run, in, size, port);
 }
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7623eb7..816d231 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2687,6 +2687,7 @@ static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	rep = (exit_qualification & 32) != 0;
 	port = exit_qualification >> 16;
 
+	skip_emulated_instruction(vcpu);
 	return kvm_emulate_pio(vcpu, kvm_run, in, size, port);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceeac88..38f79b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2478,8 +2478,6 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	memcpy(vcpu->arch.pio_data, &val, 4);
 
-	kvm_x86_ops->skip_emulated_instruction(vcpu);
-
 	pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
 	if (pio_dev) {
 		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 57d7cc4..8f60ace 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1772,7 +1772,7 @@ special_insn:
 			c->eip = saved_eip;
 			goto cannot_emulate;
 		}
-		return 0;
+		break;
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->arch.halt_request = 1;
 		break;
-- 
1.6.0.3

