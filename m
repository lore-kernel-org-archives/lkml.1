Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYFZMfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYFZMfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYFZM3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:06 -0400
Received: from il.qumranet.com ([212.179.150.194]:32387 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYFZM2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 48/50] KVM: x86 emulator: lazily evaluate segment registers
Date: Thu, 26 Jun 2008 15:28:30 +0300
Message-Id: <1214483312-9265-49-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of prefetching all segment bases before emulation, read them at the
last moment.  Since most of them are unneeded, we save some cycles on
Intel machines where this is a bit expensive.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c                |   21 --------
 arch/x86/kvm/x86_emulate.c        |   96 ++++++++++++++++++++++---------------
 include/asm-x86/kvm_x86_emulate.h |   10 +---
 3 files changed, 60 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ccb4e1e..0fbc032 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2126,27 +2126,6 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			? X86EMUL_MODE_PROT64 :	cs_db
 			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
 
-		if (vcpu->arch.emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
-			vcpu->arch.emulate_ctxt.cs_base = 0;
-			vcpu->arch.emulate_ctxt.ds_base = 0;
-			vcpu->arch.emulate_ctxt.es_base = 0;
-			vcpu->arch.emulate_ctxt.ss_base = 0;
-		} else {
-			vcpu->arch.emulate_ctxt.cs_base =
-					get_segment_base(vcpu, VCPU_SREG_CS);
-			vcpu->arch.emulate_ctxt.ds_base =
-					get_segment_base(vcpu, VCPU_SREG_DS);
-			vcpu->arch.emulate_ctxt.es_base =
-					get_segment_base(vcpu, VCPU_SREG_ES);
-			vcpu->arch.emulate_ctxt.ss_base =
-					get_segment_base(vcpu, VCPU_SREG_SS);
-		}
-
-		vcpu->arch.emulate_ctxt.gs_base =
-					get_segment_base(vcpu, VCPU_SREG_GS);
-		vcpu->arch.emulate_ctxt.fs_base =
-					get_segment_base(vcpu, VCPU_SREG_FS);
-
 		r = x86_decode_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
 
 		/* Reject the instructions other than VMCALL/VMMCALL when
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 38926b7..18ca25c 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -522,6 +522,39 @@ static inline void jmp_rel(struct decode_cache *c, int rel)
 	register_address_increment(c, &c->eip, rel);
 }
 
+static void set_seg_override(struct decode_cache *c, int seg)
+{
+	c->has_seg_override = true;
+	c->seg_override = seg;
+}
+
+static unsigned long seg_base(struct x86_emulate_ctxt *ctxt, int seg)
+{
+	if (ctxt->mode == X86EMUL_MODE_PROT64 && seg < VCPU_SREG_FS)
+		return 0;
+
+	return kvm_x86_ops->get_segment_base(ctxt->vcpu, seg);
+}
+
+static unsigned long seg_override_base(struct x86_emulate_ctxt *ctxt,
+				       struct decode_cache *c)
+{
+	if (!c->has_seg_override)
+		return 0;
+
+	return seg_base(ctxt, c->seg_override);
+}
+
+static unsigned long es_base(struct x86_emulate_ctxt *ctxt)
+{
+	return seg_base(ctxt, VCPU_SREG_ES);
+}
+
+static unsigned long ss_base(struct x86_emulate_ctxt *ctxt)
+{
+	return seg_base(ctxt, VCPU_SREG_SS);
+}
+
 static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
 			      struct x86_emulate_ops *ops,
 			      unsigned long linear, u8 *dest)
@@ -735,8 +768,8 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		}
 		if (c->modrm_rm == 2 || c->modrm_rm == 3 ||
 		    (c->modrm_rm == 6 && c->modrm_mod != 0))
-			if (!c->override_base)
-				c->override_base = &ctxt->ss_base;
+			if (!c->has_seg_override)
+				set_seg_override(c, VCPU_SREG_SS);
 		c->modrm_ea = (u16)c->modrm_ea;
 	} else {
 		/* 32/64-bit ModR/M decode. */
@@ -807,6 +840,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 
 	memset(c, 0, sizeof(struct decode_cache));
 	c->eip = ctxt->vcpu->arch.rip;
+	ctxt->cs_base = seg_base(ctxt, VCPU_SREG_CS);
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 
 	switch (mode) {
@@ -845,23 +879,15 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 				/* switch between 2/4 bytes */
 				c->ad_bytes = def_ad_bytes ^ 6;
 			break;
+		case 0x26:	/* ES override */
 		case 0x2e:	/* CS override */
-			c->override_base = &ctxt->cs_base;
-			break;
+		case 0x36:	/* SS override */
 		case 0x3e:	/* DS override */
-			c->override_base = &ctxt->ds_base;
-			break;
-		case 0x26:	/* ES override */
-			c->override_base = &ctxt->es_base;
+			set_seg_override(c, (c->b >> 3) & 3);
 			break;
 		case 0x64:	/* FS override */
-			c->override_base = &ctxt->fs_base;
-			break;
 		case 0x65:	/* GS override */
-			c->override_base = &ctxt->gs_base;
-			break;
-		case 0x36:	/* SS override */
-			c->override_base = &ctxt->ss_base;
+			set_seg_override(c, c->b & 7);
 			break;
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)
@@ -933,15 +959,11 @@ done_prefixes:
 	if (rc)
 		goto done;
 
-	if (!c->override_base)
-		c->override_base = &ctxt->ds_base;
-	if (mode == X86EMUL_MODE_PROT64 &&
-	    c->override_base != &ctxt->fs_base &&
-	    c->override_base != &ctxt->gs_base)
-		c->override_base = NULL;
+	if (!c->has_seg_override)
+		set_seg_override(c, VCPU_SREG_DS);
 
-	if (c->override_base && !(!c->twobyte && c->b == 0x8d))
-		c->modrm_ea += *c->override_base;
+	if (!(!c->twobyte && c->b == 0x8d))
+		c->modrm_ea += seg_override_base(ctxt, c);
 
 	if (c->ad_bytes != 8)
 		c->modrm_ea = (u32)c->modrm_ea;
@@ -1043,7 +1065,7 @@ static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
 	c->dst.bytes = c->op_bytes;
 	c->dst.val = c->src.val;
 	register_address_increment(c, &c->regs[VCPU_REGS_RSP], -c->op_bytes);
-	c->dst.ptr = (void *) register_address(c, ctxt->ss_base,
+	c->dst.ptr = (void *) register_address(c, ss_base(ctxt),
 					       c->regs[VCPU_REGS_RSP]);
 }
 
@@ -1053,7 +1075,7 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
-	rc = ops->read_std(register_address(c, ctxt->ss_base,
+	rc = ops->read_std(register_address(c, ss_base(ctxt),
 					    c->regs[VCPU_REGS_RSP]),
 			   &c->dst.val, c->dst.bytes, ctxt->vcpu);
 	if (rc != 0)
@@ -1375,11 +1397,11 @@ special_insn:
 		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
 					   -c->op_bytes);
 		c->dst.ptr = (void *) register_address(
-			c, ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
+			c, ss_base(ctxt), c->regs[VCPU_REGS_RSP]);
 		break;
 	case 0x58 ... 0x5f: /* pop reg */
 	pop_instruction:
-		if ((rc = ops->read_std(register_address(c, ctxt->ss_base,
+		if ((rc = ops->read_std(register_address(c, ss_base(ctxt),
 			c->regs[VCPU_REGS_RSP]), c->dst.ptr,
 			c->op_bytes, ctxt->vcpu)) != 0)
 			goto done;
@@ -1405,7 +1427,7 @@ special_insn:
 				c->rep_prefix ?
 				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
-				register_address(c, ctxt->es_base,
+				register_address(c, es_base(ctxt),
 						 c->regs[VCPU_REGS_RDI]),
 				c->rep_prefix,
 				c->regs[VCPU_REGS_RDX]) == 0) {
@@ -1421,9 +1443,8 @@ special_insn:
 				c->rep_prefix ?
 				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
-				register_address(c, c->override_base ?
-							*c->override_base :
-							ctxt->ds_base,
+					 register_address(c,
+					  seg_override_base(ctxt, c),
 						 c->regs[VCPU_REGS_RSI]),
 				c->rep_prefix,
 				c->regs[VCPU_REGS_RDX]) == 0) {
@@ -1559,11 +1580,10 @@ special_insn:
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)register_address(c,
-						   ctxt->es_base,
+						   es_base(ctxt),
 						   c->regs[VCPU_REGS_RDI]);
 		if ((rc = ops->read_emulated(register_address(c,
-		      c->override_base ? *c->override_base :
-					ctxt->ds_base,
+					   seg_override_base(ctxt, c),
 					c->regs[VCPU_REGS_RSI]),
 					&c->dst.val,
 					c->dst.bytes, ctxt->vcpu)) != 0)
@@ -1579,8 +1599,7 @@ special_insn:
 		c->src.type = OP_NONE; /* Disable writeback. */
 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->src.ptr = (unsigned long *)register_address(c,
-				c->override_base ? *c->override_base :
-						   ctxt->ds_base,
+				       seg_override_base(ctxt, c),
 						   c->regs[VCPU_REGS_RSI]);
 		if ((rc = ops->read_emulated((unsigned long)c->src.ptr,
 						&c->src.val,
@@ -1591,7 +1610,7 @@ special_insn:
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)register_address(c,
-						   ctxt->es_base,
+						   es_base(ctxt),
 						   c->regs[VCPU_REGS_RDI]);
 		if ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
 						&c->dst.val,
@@ -1615,7 +1634,7 @@ special_insn:
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)register_address(c,
-						   ctxt->es_base,
+						   es_base(ctxt),
 						   c->regs[VCPU_REGS_RDI]);
 		c->dst.val = c->regs[VCPU_REGS_RAX];
 		register_address_increment(c, &c->regs[VCPU_REGS_RDI],
@@ -1627,8 +1646,7 @@ special_insn:
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
 		if ((rc = ops->read_emulated(register_address(c,
-				c->override_base ? *c->override_base :
-						   ctxt->ds_base,
+						 seg_override_base(ctxt, c),
 						 c->regs[VCPU_REGS_RSI]),
 						 &c->dst.val,
 						 c->dst.bytes,
diff --git a/include/asm-x86/kvm_x86_emulate.h b/include/asm-x86/kvm_x86_emulate.h
index 9fda4b3..4e8c1e4 100644
--- a/include/asm-x86/kvm_x86_emulate.h
+++ b/include/asm-x86/kvm_x86_emulate.h
@@ -124,7 +124,8 @@ struct decode_cache {
 	u8 rex_prefix;
 	struct operand src;
 	struct operand dst;
-	unsigned long *override_base;
+	bool has_seg_override;
+	u8 seg_override;
 	unsigned int d;
 	unsigned long regs[NR_VCPU_REGS];
 	unsigned long eip;
@@ -151,12 +152,7 @@ struct x86_emulate_ctxt {
 	/* Emulated execution mode, represented by an X86EMUL_MODE value. */
 	int mode;
 
-	unsigned long cs_base;
-	unsigned long ds_base;
-	unsigned long es_base;
-	unsigned long ss_base;
-	unsigned long gs_base;
-	unsigned long fs_base;
+	u32 cs_base;
 
 	/* decode cache */
 
-- 
1.5.6

