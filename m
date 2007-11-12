Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbXKLKPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbXKLKPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbXKLKPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:15:43 -0500
Received: from il.qumranet.com ([82.166.9.18]:45776 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305AbXKLKPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:15:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: KVM fixes for 2.6.24-rc2
Date: Mon, 12 Nov 2007 12:16:12 +0200
Message-Id: <1194862572171-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the tree at

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

Containing some fairly critical fixes for 2.6.24's KVM, including hard host
hangs on AMD.


Avi Kivity (5):
      KVM: x86 emulator: fix 'push imm8' emulation
      KVM: SVM: Fix SMP with kernel apic
      KVM: SVM: Defer nmi processing until switch to host state is complete
      KVM: x86 emulator: invd instruction
      KVM: SVM: Intercept the 'invd' and 'wbinvd' instructions

 drivers/kvm/svm.c         |   18 ++++++++++++++----
 drivers/kvm/x86_emulate.c |   26 ++++++++++++++------------
 2 files changed, 28 insertions(+), 16 deletions(-)


diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 729f1cd..7a6eead 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -494,6 +494,7 @@ static void init_vmcb(struct vmcb *vmcb)
 		 */
 		/*              (1ULL << INTERCEPT_SELECTIVE_CR0) | */
 				(1ULL << INTERCEPT_CPUID) |
+				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
 				(1ULL << INTERCEPT_INVLPGA) |
 				(1ULL << INTERCEPT_IOIO_PROT) |
@@ -507,6 +508,7 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_STGI) |
 				(1ULL << INTERCEPT_CLGI) |
 				(1ULL << INTERCEPT_SKINIT) |
+				(1ULL << INTERCEPT_WBINVD) |
 				(1ULL << INTERCEPT_MONITOR) |
 				(1ULL << INTERCEPT_MWAIT);
 
@@ -561,6 +563,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	init_vmcb(svm->vmcb);
+
+	if (vcpu->vcpu_id != 0) {
+		svm->vmcb->save.rip = 0;
+		svm->vmcb->save.cs.base = svm->vcpu.sipi_vector << 12;
+		svm->vmcb->save.cs.selector = svm->vcpu.sipi_vector << 8;
+	}
 }
 
 static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
@@ -1241,6 +1249,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	/* [SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception, */
 	[SVM_EXIT_CPUID]			= cpuid_interception,
+	[SVM_EXIT_INVD]                         = emulate_on_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= emulate_on_interception,
 	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
@@ -1255,6 +1264,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_STGI]				= invalid_op_interception,
 	[SVM_EXIT_CLGI]				= invalid_op_interception,
 	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
 };
@@ -1579,10 +1589,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 		: "cc", "memory" );
 
-	local_irq_disable();
-
-	stgi();
-
 	if ((svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(svm->host_db_regs);
 
@@ -1599,6 +1605,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	reload_tss(vcpu);
 
+	local_irq_disable();
+
+	stgi();
+
 	svm->next_rip = 0;
 }
 
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index a6ace30..33b1814 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -167,7 +167,7 @@ static u8 opcode_table[256] = {
 static u16 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	0, SrcMem | ModRM | DstReg, 0, 0, 0, 0, ImplicitOps, 0,
-	0, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
+	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
@@ -980,17 +980,6 @@ done_prefixes:
 			goto cannot_emulate;
 		dst.val = (s32) src.val;
 		break;
-	case 0x6a: /* push imm8 */
-		src.val = 0L;
-		src.val = insn_fetch(s8, 1, _eip);
-push:
-		dst.type  = OP_MEM;
-		dst.bytes = op_bytes;
-		dst.val = src.val;
-		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
-		dst.ptr = (void *) register_address(ctxt->ss_base,
-							_regs[VCPU_REGS_RSP]);
-		break;
 	case 0x80 ... 0x83:	/* Grp1 */
 		switch (modrm_reg) {
 		case 0:
@@ -1243,6 +1232,17 @@ special_insn:
 		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
 		no_wb = 1; /* Disable writeback. */
 		break;
+	case 0x6a: /* push imm8 */
+		src.val = 0L;
+		src.val = insn_fetch(s8, 1, _eip);
+	push:
+		dst.type  = OP_MEM;
+		dst.bytes = op_bytes;
+		dst.val = src.val;
+		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
+		dst.ptr = (void *) register_address(ctxt->ss_base,
+							_regs[VCPU_REGS_RSP]);
+		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
 		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
@@ -1532,6 +1532,8 @@ twobyte_special_insn:
 	case 0x06:
 		emulate_clts(ctxt->vcpu);
 		break;
+	case 0x08:		/* invd */
+		break;
 	case 0x09:		/* wbinvd */
 		break;
 	case 0x0d:		/* GrpP (prefetch) */
