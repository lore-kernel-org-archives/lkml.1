Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab0BQNth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:49:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936Ab0BQNpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:36 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] KVM: x86 emulator: Add Virtual-8086 mode of emulation
Date: Wed, 17 Feb 2010 15:45:22 +0200
Message-Id: <1266414330-27444-13-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

For some instructions CPU behaves differently for real-mode and
virtual 8086. Let emulator know which mode cpu is in, so it will
not poke into vcpu state directly.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 +
 arch/x86/kvm/emulate.c             |   12 +++++++-----
 arch/x86/kvm/x86.c                 |    3 ++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 9b697c2..784d7c5 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -168,6 +168,7 @@ struct x86_emulate_ctxt {
 
 /* Execution mode, passed to the emulator. */
 #define X86EMUL_MODE_REAL     0	/* Real mode.             */
+#define X86EMUL_MODE_VM86     1	/* Virtual 8086 mode.     */
 #define X86EMUL_MODE_PROT16   2	/* 16-bit protected mode. */
 #define X86EMUL_MODE_PROT32   4	/* 32-bit protected mode. */
 #define X86EMUL_MODE_PROT64   8	/* 64-bit (long) mode.    */
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 45a4f7c..e4e2df3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -899,6 +899,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
+	case X86EMUL_MODE_VM86:
 	case X86EMUL_MODE_PROT16:
 		def_op_bytes = def_ad_bytes = 2;
 		break;
@@ -1525,7 +1526,7 @@ emulate_syscall(struct x86_emulate_ctxt *ctxt)
 
 	/* syscall is not available in real mode */
 	if (c->lock_prefix || ctxt->mode == X86EMUL_MODE_REAL
-	    || !is_protmode(ctxt->vcpu))
+	    || ctxt->mode == X86EMUL_MODE_VM86)
 		return -1;
 
 	setup_syscalls_segments(ctxt, &cs, &ss);
@@ -1577,8 +1578,8 @@ emulate_sysenter(struct x86_emulate_ctxt *ctxt)
 	if (c->lock_prefix)
 		return -1;
 
-	/* inject #GP if in real mode or paging is disabled */
-	if (ctxt->mode == X86EMUL_MODE_REAL || !is_protmode(ctxt->vcpu)) {
+	/* inject #GP if in real mode */
+	if (ctxt->mode == X86EMUL_MODE_REAL) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
@@ -1642,8 +1643,9 @@ emulate_sysexit(struct x86_emulate_ctxt *ctxt)
 	if (c->lock_prefix)
 		return -1;
 
-	/* inject #GP if in real mode or paging is disabled */
-	if (ctxt->mode == X86EMUL_MODE_REAL || !is_protmode(ctxt->vcpu)) {
+	/* inject #GP if in real mode or Virtual 8086 mode */
+	if (ctxt->mode == X86EMUL_MODE_REAL ||
+	    ctxt->mode == X86EMUL_MODE_VM86) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2f91b9..a283795 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3348,8 +3348,9 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		vcpu->arch.emulate_ctxt.vcpu = vcpu;
 		vcpu->arch.emulate_ctxt.eflags = kvm_get_rflags(vcpu);
 		vcpu->arch.emulate_ctxt.mode =
+			(!is_protmode(vcpu)) ? X86EMUL_MODE_REAL :
 			(vcpu->arch.emulate_ctxt.eflags & X86_EFLAGS_VM)
-			? X86EMUL_MODE_REAL : cs_l
+			? X86EMUL_MODE_VM86 : cs_l
 			? X86EMUL_MODE_PROT64 :	cs_db
 			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
 
-- 
1.6.5.3

