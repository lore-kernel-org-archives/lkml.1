Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab0BQNs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:48:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934106Ab0BQNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] KVM: x86 emulator: Check IOPL level during io instruction emulation
Date: Wed, 17 Feb 2010 15:45:24 +0200
Message-Id: <1266414330-27444-15-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Make emulator check that vcpu is allowed to execute IN, INS, OUT,
OUTS, CLI, STI.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/emulate.c          |   89 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |   10 ++---
 3 files changed, 87 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c07c16f..f9a2f66 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -678,6 +678,7 @@ void kvm_disable_tdp(void);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
+bool kvm_check_iopl(struct kvm_vcpu *vcpu);
 
 struct kvm_memory_slot *gfn_to_memslot_unaliased(struct kvm *kvm, gfn_t gfn);
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c44b460..296e851 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1698,6 +1698,57 @@ emulate_sysexit(struct x86_emulate_ctxt *ctxt)
 	return 0;
 }
 
+static bool emulator_bad_iopl(struct x86_emulate_ctxt *ctxt)
+{
+	int iopl;
+	if (ctxt->mode == X86EMUL_MODE_REAL)
+		return false;
+	if (ctxt->mode == X86EMUL_MODE_VM86)
+		return true;
+	iopl = (ctxt->eflags & X86_EFLAGS_IOPL) >> IOPL_SHIFT;
+	return kvm_x86_ops->get_cpl(ctxt->vcpu) > iopl;
+}
+
+static bool emulator_io_port_access_allowed(struct x86_emulate_ctxt *ctxt,
+					    struct x86_emulate_ops *ops,
+					    u16 port, u16 len)
+{
+	struct kvm_segment tr_seg;
+	int r;
+	u16 io_bitmap_ptr;
+	u8 perm, bit_idx = port & 0x7;
+	unsigned mask = (1 << len) - 1;
+
+	kvm_get_segment(ctxt->vcpu, &tr_seg, VCPU_SREG_TR);
+	if (tr_seg.unusable)
+		return false;
+	if (tr_seg.limit < 103)
+		return false;
+	r = ops->read_std(tr_seg.base + 102, &io_bitmap_ptr, 2, ctxt->vcpu,
+			  NULL);
+	if (r != X86EMUL_CONTINUE)
+		return false;
+	if (io_bitmap_ptr + port/8 > tr_seg.limit)
+		return false;
+	r = ops->read_std(tr_seg.base + io_bitmap_ptr + port/8, &perm, 1,
+			  ctxt->vcpu, NULL);
+	if (r != X86EMUL_CONTINUE)
+		return false;
+	if ((perm >> bit_idx) & mask)
+		return false;
+	return true;
+}
+
+static bool emulator_io_permited(struct x86_emulate_ctxt *ctxt,
+				 struct x86_emulate_ops *ops,
+				 u16 port, u16 len)
+{
+	if (emulator_bad_iopl(ctxt))
+		if (!emulator_io_port_access_allowed(ctxt, ops, port, len))
+			return false;
+	return true;
+}
+
 int
 x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
@@ -1889,7 +1940,12 @@ special_insn:
 		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
-		 if (kvm_emulate_pio_string(ctxt->vcpu,
+		if (!emulator_io_permited(ctxt, ops, c->regs[VCPU_REGS_RDX],
+					  (c->d & ByteOp) ? 1 : c->op_bytes)) {
+			kvm_inject_gp(ctxt->vcpu, 0);
+			goto done;
+		}
+		if (kvm_emulate_pio_string(ctxt->vcpu,
 				1,
 				(c->d & ByteOp) ? 1 : c->op_bytes,
 				c->rep_prefix ?
@@ -1905,6 +1961,11 @@ special_insn:
 		return 0;
 	case 0x6e:		/* outsb */
 	case 0x6f:		/* outsw/outsd */
+		if (!emulator_io_permited(ctxt, ops, c->regs[VCPU_REGS_RDX],
+					  (c->d & ByteOp) ? 1 : c->op_bytes)) {
+			kvm_inject_gp(ctxt->vcpu, 0);
+			goto done;
+		}
 		if (kvm_emulate_pio_string(ctxt->vcpu,
 				0,
 				(c->d & ByteOp) ? 1 : c->op_bytes,
@@ -2202,7 +2263,13 @@ special_insn:
 	case 0xef: /* out (e/r)ax,dx */
 		port = c->regs[VCPU_REGS_RDX];
 		io_dir_in = 0;
-	do_io:	if (kvm_emulate_pio(ctxt->vcpu, io_dir_in,
+	do_io:
+		if (!emulator_io_permited(ctxt, ops, port,
+					  (c->d & ByteOp) ? 1 : c->op_bytes)) {
+			kvm_inject_gp(ctxt->vcpu, 0);
+			goto done;
+		}
+		if (kvm_emulate_pio(ctxt->vcpu, io_dir_in,
 				   (c->d & ByteOp) ? 1 : c->op_bytes,
 				   port) != 0) {
 			c->eip = saved_eip;
@@ -2227,13 +2294,21 @@ special_insn:
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
 	case 0xfa: /* cli */
-		ctxt->eflags &= ~X86_EFLAGS_IF;
-		c->dst.type = OP_NONE;	/* Disable writeback. */
+		if (emulator_bad_iopl(ctxt))
+			kvm_inject_gp(ctxt->vcpu, 0);
+		else {
+			ctxt->eflags &= ~X86_EFLAGS_IF;
+			c->dst.type = OP_NONE;	/* Disable writeback. */
+		}
 		break;
 	case 0xfb: /* sti */
-		toggle_interruptibility(ctxt, X86_SHADOW_INT_STI);
-		ctxt->eflags |= X86_EFLAGS_IF;
-		c->dst.type = OP_NONE;	/* Disable writeback. */
+		if (emulator_bad_iopl(ctxt))
+			kvm_inject_gp(ctxt->vcpu, 0);
+		else {
+			toggle_interruptibility(ctxt, X86_SHADOW_INT_STI);
+			ctxt->eflags |= X86_EFLAGS_IF;
+			c->dst.type = OP_NONE;	/* Disable writeback. */
+		}
 		break;
 	case 0xfc: /* cld */
 		ctxt->eflags &= ~EFLG_DF;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea3a8af..86b739f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3599,6 +3599,8 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, int in, int size, unsigned port)
 {
 	unsigned long val;
 
+	trace_kvm_pio(!in, port, size, 1);
+
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = vcpu->arch.pio.size = size;
@@ -3610,9 +3612,6 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, int in, int size, unsigned port)
 	vcpu->arch.pio.down = 0;
 	vcpu->arch.pio.rep = 0;
 
-	trace_kvm_pio(vcpu->run->io.direction == KVM_EXIT_IO_OUT, port,
-		      size, 1);
-
 	if (!vcpu->arch.pio.in) {
 		val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 		memcpy(vcpu->arch.pio_data, &val, 4);
@@ -3633,6 +3632,8 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, int in,
 	unsigned now, in_page;
 	int ret = 0;
 
+	trace_kvm_pio(!in, port, size, count);
+
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = vcpu->arch.pio.size = size;
@@ -3644,9 +3645,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, int in,
 	vcpu->arch.pio.down = down;
 	vcpu->arch.pio.rep = rep;
 
-	trace_kvm_pio(vcpu->run->io.direction == KVM_EXIT_IO_OUT, port,
-		      size, count);
-
 	if (!count) {
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
 		return 1;
-- 
1.6.5.3

