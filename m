Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbXLWOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbXLWOxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXLWOvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:44 -0500
Received: from il.qumranet.com ([82.166.9.18]:35870 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbXLWOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:39 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 04/50] KVM: x86 emulator: move all x86_emulate_memop() to a structure
Date: Sun, 23 Dec 2007 16:50:49 +0200
Message-Id: <1198421495-31481-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Move all x86_emulate_memop() common variables between decode and execute to a
structure decode_cache.  This will help in later separating decode and
emulate.

            struct decode_cache {
                u8 twobyte;
                u8 b;
                u8 lock_prefix;
                u8 rep_prefix;
                u8 op_bytes;
                u8 ad_bytes;
                struct operand src;
                struct operand dst;
                unsigned long *override_base;
                unsigned int d;
                unsigned long regs[NR_VCPU_REGS];
                unsigned long eip;
                /* modrm */
                u8 modrm;
                u8 modrm_mod;
                u8 modrm_reg;
                u8 modrm_rm;
                u8 use_modrm_ea;
                unsigned long modrm_ea;
                unsigned long modrm_val;
           };

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |  919 ++++++++++++++++++++++++---------------------
 drivers/kvm/x86_emulate.h |   34 ++
 2 files changed, 518 insertions(+), 435 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 9ea82f8..f946182 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -222,13 +222,6 @@ static u16 twobyte_table[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
-/* Type, address-of, and value of an instruction's operand. */
-struct operand {
-	enum { OP_REG, OP_MEM, OP_IMM } type;
-	unsigned int bytes;
-	unsigned long val, orig_val, *ptr;
-};
-
 /* EFLAGS bit definitions. */
 #define EFLG_OF (1<<11)
 #define EFLG_DF (1<<10)
@@ -431,24 +424,26 @@ struct operand {
 
 /* Access/update address held in a register, based on addressing mode. */
 #define address_mask(reg)						\
-	((ad_bytes == sizeof(unsigned long)) ? 				\
-		(reg) :	((reg) & ((1UL << (ad_bytes << 3)) - 1)))
+	((c->ad_bytes == sizeof(unsigned long)) ? 			\
+		(reg) :	((reg) & ((1UL << (c->ad_bytes << 3)) - 1)))
 #define register_address(base, reg)                                     \
 	((base) + address_mask(reg))
 #define register_address_increment(reg, inc)                            \
 	do {								\
 		/* signed type ensures sign extension to long */        \
 		int _inc = (inc);					\
-		if ( ad_bytes == sizeof(unsigned long) )		\
+		if (c->ad_bytes == sizeof(unsigned long))		\
 			(reg) += _inc;					\
 		else							\
-			(reg) = ((reg) & ~((1UL << (ad_bytes << 3)) - 1)) | \
-			   (((reg) + _inc) & ((1UL << (ad_bytes << 3)) - 1)); \
+			(reg) = ((reg) & 				\
+				 ~((1UL << (c->ad_bytes << 3)) - 1)) |	\
+				(((reg) + _inc) &			\
+				 ((1UL << (c->ad_bytes << 3)) - 1));	\
 	} while (0)
 
 #define JMP_REL(rel) 							\
 	do {								\
-		register_address_increment(_eip, rel);			\
+		register_address_increment(c->eip, rel);		\
 	} while (0)
 
 /*
@@ -524,39 +519,35 @@ static int test_cc(unsigned int condition, unsigned int flags)
 int
 x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
-	unsigned d;
-	u8 b, sib, twobyte = 0, rex_prefix = 0;
-	u8 modrm, modrm_mod = 0, modrm_reg = 0, modrm_rm = 0;
-	unsigned long *override_base = NULL;
-	unsigned int op_bytes, ad_bytes, lock_prefix = 0, rep_prefix = 0, i;
+	struct decode_cache *c = &ctxt->decode;
+	u8 sib, rex_prefix = 0;
+	unsigned int i;
 	int rc = 0;
-	struct operand src, dst;
 	unsigned long cr2 = ctxt->cr2;
 	int mode = ctxt->mode;
-	unsigned long modrm_ea;
-	int use_modrm_ea, index_reg = 0, base_reg = 0, scale, rip_relative = 0;
+	int index_reg = 0, base_reg = 0, scale, rip_relative = 0;
 	int no_wb = 0;
 	u64 msr_data;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
-	unsigned long _regs[NR_VCPU_REGS];
-	unsigned long _eip = ctxt->vcpu->rip, _eflags = ctxt->eflags;
-	unsigned long modrm_val = 0;
+	unsigned long _eflags = ctxt->eflags;
 
-	memcpy(_regs, ctxt->vcpu->regs, sizeof _regs);
+	memset(c, 0, sizeof(struct decode_cache));
+	c->eip = ctxt->vcpu->rip;
+	memcpy(c->regs, ctxt->vcpu->regs, sizeof c->regs);
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
 	case X86EMUL_MODE_PROT16:
-		op_bytes = ad_bytes = 2;
+		c->op_bytes = c->ad_bytes = 2;
 		break;
 	case X86EMUL_MODE_PROT32:
-		op_bytes = ad_bytes = 4;
+		c->op_bytes = c->ad_bytes = 4;
 		break;
 #ifdef CONFIG_X86_64
 	case X86EMUL_MODE_PROT64:
-		op_bytes = 4;
-		ad_bytes = 8;
+		c->op_bytes = 4;
+		c->ad_bytes = 8;
 		break;
 #endif
 	default:
@@ -565,40 +556,42 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 
 	/* Legacy prefixes. */
 	for (i = 0; i < 8; i++) {
-		switch (b = insn_fetch(u8, 1, _eip)) {
+		switch (c->b = insn_fetch(u8, 1, c->eip)) {
 		case 0x66:	/* operand-size override */
-			op_bytes ^= 6;	/* switch between 2/4 bytes */
+			c->op_bytes ^= 6;	/* switch between 2/4 bytes */
 			break;
 		case 0x67:	/* address-size override */
 			if (mode == X86EMUL_MODE_PROT64)
-				ad_bytes ^= 12;	/* switch between 4/8 bytes */
+				/* switch between 4/8 bytes */
+				c->ad_bytes ^= 12;
 			else
-				ad_bytes ^= 6;	/* switch between 2/4 bytes */
+				/* switch between 2/4 bytes */
+				c->ad_bytes ^= 6;
 			break;
 		case 0x2e:	/* CS override */
-			override_base = &ctxt->cs_base;
+			c->override_base = &ctxt->cs_base;
 			break;
 		case 0x3e:	/* DS override */
-			override_base = &ctxt->ds_base;
+			c->override_base = &ctxt->ds_base;
 			break;
 		case 0x26:	/* ES override */
-			override_base = &ctxt->es_base;
+			c->override_base = &ctxt->es_base;
 			break;
 		case 0x64:	/* FS override */
-			override_base = &ctxt->fs_base;
+			c->override_base = &ctxt->fs_base;
 			break;
 		case 0x65:	/* GS override */
-			override_base = &ctxt->gs_base;
+			c->override_base = &ctxt->gs_base;
 			break;
 		case 0x36:	/* SS override */
-			override_base = &ctxt->ss_base;
+			c->override_base = &ctxt->ss_base;
 			break;
 		case 0xf0:	/* LOCK */
-			lock_prefix = 1;
+			c->lock_prefix = 1;
 			break;
 		case 0xf2:	/* REPNE/REPNZ */
 		case 0xf3:	/* REP/REPE/REPZ */
-			rep_prefix = 1;
+			c->rep_prefix = 1;
 			break;
 		default:
 			goto done_prefixes;
@@ -608,177 +601,182 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 done_prefixes:
 
 	/* REX prefix. */
-	if ((mode == X86EMUL_MODE_PROT64) && ((b & 0xf0) == 0x40)) {
-		rex_prefix = b;
-		if (b & 8)
-			op_bytes = 8;	/* REX.W */
-		modrm_reg = (b & 4) << 1;	/* REX.R */
-		index_reg = (b & 2) << 2; /* REX.X */
-		modrm_rm = base_reg = (b & 1) << 3; /* REG.B */
-		b = insn_fetch(u8, 1, _eip);
+	if ((mode == X86EMUL_MODE_PROT64) && ((c->b & 0xf0) == 0x40)) {
+		rex_prefix = c->b;
+		if (c->b & 8)
+			c->op_bytes = 8;	/* REX.W */
+		c->modrm_reg = (c->b & 4) << 1;	/* REX.R */
+		index_reg = (c->b & 2) << 2; /* REX.X */
+		c->modrm_rm = base_reg = (c->b & 1) << 3; /* REG.B */
+		c->b = insn_fetch(u8, 1, c->eip);
 	}
 
 	/* Opcode byte(s). */
-	d = opcode_table[b];
-	if (d == 0) {
+	c->d = opcode_table[c->b];
+	if (c->d == 0) {
 		/* Two-byte opcode? */
-		if (b == 0x0f) {
-			twobyte = 1;
-			b = insn_fetch(u8, 1, _eip);
-			d = twobyte_table[b];
+		if (c->b == 0x0f) {
+			c->twobyte = 1;
+			c->b = insn_fetch(u8, 1, c->eip);
+			c->d = twobyte_table[c->b];
 		}
 
 		/* Unrecognised? */
-		if (d == 0)
+		if (c->d == 0)
 			goto cannot_emulate;
 	}
 
 	/* ModRM and SIB bytes. */
-	if (d & ModRM) {
-		modrm = insn_fetch(u8, 1, _eip);
-		modrm_mod |= (modrm & 0xc0) >> 6;
-		modrm_reg |= (modrm & 0x38) >> 3;
-		modrm_rm |= (modrm & 0x07);
-		modrm_ea = 0;
-		use_modrm_ea = 1;
-
-		if (modrm_mod == 3) {
-			modrm_val = *(unsigned long *)
-				decode_register(modrm_rm, _regs, d & ByteOp);
+	if (c->d & ModRM) {
+		c->modrm = insn_fetch(u8, 1, c->eip);
+		c->modrm_mod |= (c->modrm & 0xc0) >> 6;
+		c->modrm_reg |= (c->modrm & 0x38) >> 3;
+		c->modrm_rm |= (c->modrm & 0x07);
+		c->modrm_ea = 0;
+		c->use_modrm_ea = 1;
+
+		if (c->modrm_mod == 3) {
+			c->modrm_val = *(unsigned long *)
+			  decode_register(c->modrm_rm, c->regs, c->d & ByteOp);
 			goto modrm_done;
 		}
 
-		if (ad_bytes == 2) {
-			unsigned bx = _regs[VCPU_REGS_RBX];
-			unsigned bp = _regs[VCPU_REGS_RBP];
-			unsigned si = _regs[VCPU_REGS_RSI];
-			unsigned di = _regs[VCPU_REGS_RDI];
+		if (c->ad_bytes == 2) {
+			unsigned bx = c->regs[VCPU_REGS_RBX];
+			unsigned bp = c->regs[VCPU_REGS_RBP];
+			unsigned si = c->regs[VCPU_REGS_RSI];
+			unsigned di = c->regs[VCPU_REGS_RDI];
 
 			/* 16-bit ModR/M decode. */
-			switch (modrm_mod) {
+			switch (c->modrm_mod) {
 			case 0:
-				if (modrm_rm == 6)
-					modrm_ea += insn_fetch(u16, 2, _eip);
+				if (c->modrm_rm == 6)
+					c->modrm_ea +=
+						insn_fetch(u16, 2, c->eip);
 				break;
 			case 1:
-				modrm_ea += insn_fetch(s8, 1, _eip);
+				c->modrm_ea += insn_fetch(s8, 1, c->eip);
 				break;
 			case 2:
-				modrm_ea += insn_fetch(u16, 2, _eip);
+				c->modrm_ea += insn_fetch(u16, 2, c->eip);
 				break;
 			}
-			switch (modrm_rm) {
+			switch (c->modrm_rm) {
 			case 0:
-				modrm_ea += bx + si;
+				c->modrm_ea += bx + si;
 				break;
 			case 1:
-				modrm_ea += bx + di;
+				c->modrm_ea += bx + di;
 				break;
 			case 2:
-				modrm_ea += bp + si;
+				c->modrm_ea += bp + si;
 				break;
 			case 3:
-				modrm_ea += bp + di;
+				c->modrm_ea += bp + di;
 				break;
 			case 4:
-				modrm_ea += si;
+				c->modrm_ea += si;
 				break;
 			case 5:
-				modrm_ea += di;
+				c->modrm_ea += di;
 				break;
 			case 6:
-				if (modrm_mod != 0)
-					modrm_ea += bp;
+				if (c->modrm_mod != 0)
+					c->modrm_ea += bp;
 				break;
 			case 7:
-				modrm_ea += bx;
+				c->modrm_ea += bx;
 				break;
 			}
-			if (modrm_rm == 2 || modrm_rm == 3 ||
-			    (modrm_rm == 6 && modrm_mod != 0))
-				if (!override_base)
-					override_base = &ctxt->ss_base;
-			modrm_ea = (u16)modrm_ea;
+			if (c->modrm_rm == 2 || c->modrm_rm == 3 ||
+			    (c->modrm_rm == 6 && c->modrm_mod != 0))
+				if (!c->override_base)
+					c->override_base = &ctxt->ss_base;
+			c->modrm_ea = (u16)c->modrm_ea;
 		} else {
 			/* 32/64-bit ModR/M decode. */
-			switch (modrm_rm) {
+			switch (c->modrm_rm) {
 			case 4:
 			case 12:
-				sib = insn_fetch(u8, 1, _eip);
+				sib = insn_fetch(u8, 1, c->eip);
 				index_reg |= (sib >> 3) & 7;
 				base_reg |= sib & 7;
 				scale = sib >> 6;
 
 				switch (base_reg) {
 				case 5:
-					if (modrm_mod != 0)
-						modrm_ea += _regs[base_reg];
+					if (c->modrm_mod != 0)
+						c->modrm_ea +=
+							c->regs[base_reg];
 					else
-						modrm_ea += insn_fetch(s32, 4, _eip);
+						c->modrm_ea +=
+						    insn_fetch(s32, 4, c->eip);
 					break;
 				default:
-					modrm_ea += _regs[base_reg];
+					c->modrm_ea += c->regs[base_reg];
 				}
 				switch (index_reg) {
 				case 4:
 					break;
 				default:
-					modrm_ea += _regs[index_reg] << scale;
+					c->modrm_ea +=
+						c->regs[index_reg] << scale;
 
 				}
 				break;
 			case 5:
-				if (modrm_mod != 0)
-					modrm_ea += _regs[modrm_rm];
+				if (c->modrm_mod != 0)
+					c->modrm_ea += c->regs[c->modrm_rm];
 				else if (mode == X86EMUL_MODE_PROT64)
 					rip_relative = 1;
 				break;
 			default:
-				modrm_ea += _regs[modrm_rm];
+				c->modrm_ea += c->regs[c->modrm_rm];
 				break;
 			}
-			switch (modrm_mod) {
+			switch (c->modrm_mod) {
 			case 0:
-				if (modrm_rm == 5)
-					modrm_ea += insn_fetch(s32, 4, _eip);
+				if (c->modrm_rm == 5)
+					c->modrm_ea +=
+						insn_fetch(s32, 4, c->eip);
 				break;
 			case 1:
-				modrm_ea += insn_fetch(s8, 1, _eip);
+				c->modrm_ea += insn_fetch(s8, 1, c->eip);
 				break;
 			case 2:
-				modrm_ea += insn_fetch(s32, 4, _eip);
+				c->modrm_ea += insn_fetch(s32, 4, c->eip);
 				break;
 			}
 		}
-		if (!override_base)
-			override_base = &ctxt->ds_base;
+		if (!c->override_base)
+			c->override_base = &ctxt->ds_base;
 		if (mode == X86EMUL_MODE_PROT64 &&
-		    override_base != &ctxt->fs_base &&
-		    override_base != &ctxt->gs_base)
-			override_base = NULL;
+		    c->override_base != &ctxt->fs_base &&
+		    c->override_base != &ctxt->gs_base)
+			c->override_base = NULL;
 
-		if (override_base)
-			modrm_ea += *override_base;
+		if (c->override_base)
+			c->modrm_ea += *c->override_base;
 
 		if (rip_relative) {
-			modrm_ea += _eip;
-			switch (d & SrcMask) {
+			c->modrm_ea += c->eip;
+			switch (c->d & SrcMask) {
 			case SrcImmByte:
-				modrm_ea += 1;
+				c->modrm_ea += 1;
 				break;
 			case SrcImm:
-				if (d & ByteOp)
-					modrm_ea += 1;
+				if (c->d & ByteOp)
+					c->modrm_ea += 1;
 				else
-					if (op_bytes == 8)
-						modrm_ea += 4;
+					if (c->op_bytes == 8)
+						c->modrm_ea += 4;
 					else
-						modrm_ea += op_bytes;
+						c->modrm_ea += c->op_bytes;
 			}
 		}
-		if (ad_bytes != 8)
-			modrm_ea = (u32)modrm_ea;
-		cr2 = modrm_ea;
+		if (c->ad_bytes != 8)
+			c->modrm_ea = (u32)c->modrm_ea;
+		cr2 = c->modrm_ea;
 	modrm_done:
 		;
 	}
@@ -787,200 +785,210 @@ done_prefixes:
 	 * Decode and fetch the source operand: register, memory
 	 * or immediate.
 	 */
-	switch (d & SrcMask) {
+	switch (c->d & SrcMask) {
 	case SrcNone:
 		break;
 	case SrcReg:
-		src.type = OP_REG;
-		if (d & ByteOp) {
-			src.ptr = decode_register(modrm_reg, _regs,
+		c->src.type = OP_REG;
+		if (c->d & ByteOp) {
+			c->src.ptr =
+				decode_register(c->modrm_reg, c->regs,
 						  (rex_prefix == 0));
-			src.val = src.orig_val = *(u8 *) src.ptr;
-			src.bytes = 1;
+			c->src.val = c->src.orig_val = *(u8 *)c->src.ptr;
+			c->src.bytes = 1;
 		} else {
-			src.ptr = decode_register(modrm_reg, _regs, 0);
-			switch ((src.bytes = op_bytes)) {
+			c->src.ptr =
+			    decode_register(c->modrm_reg, c->regs, 0);
+			switch ((c->src.bytes = c->op_bytes)) {
 			case 2:
-				src.val = src.orig_val = *(u16 *) src.ptr;
+				c->src.val = c->src.orig_val =
+						       *(u16 *) c->src.ptr;
 				break;
 			case 4:
-				src.val = src.orig_val = *(u32 *) src.ptr;
+				c->src.val = c->src.orig_val =
+						       *(u32 *) c->src.ptr;
 				break;
 			case 8:
-				src.val = src.orig_val = *(u64 *) src.ptr;
+				c->src.val = c->src.orig_val =
+						       *(u64 *) c->src.ptr;
 				break;
 			}
 		}
 		break;
 	case SrcMem16:
-		src.bytes = 2;
+		c->src.bytes = 2;
 		goto srcmem_common;
 	case SrcMem32:
-		src.bytes = 4;
+		c->src.bytes = 4;
 		goto srcmem_common;
 	case SrcMem:
-		src.bytes = (d & ByteOp) ? 1 : op_bytes;
+		c->src.bytes = (c->d & ByteOp) ? 1 :
+							   c->op_bytes;
 		/* Don't fetch the address for invlpg: it could be unmapped. */
-		if (twobyte && b == 0x01 && modrm_reg == 7)
+		if (c->twobyte && c->b == 0x01
+				    && c->modrm_reg == 7)
 			break;
 	      srcmem_common:
 		/*
 		 * For instructions with a ModR/M byte, switch to register
 		 * access if Mod = 3.
 		 */
-		if ((d & ModRM) && modrm_mod == 3) {
-			src.type = OP_REG;
+		if ((c->d & ModRM) && c->modrm_mod == 3) {
+			c->src.type = OP_REG;
 			break;
 		}
-		src.type = OP_MEM;
-		src.ptr = (unsigned long *)cr2;
-		src.val = 0;
-		if ((rc = ops->read_emulated((unsigned long)src.ptr,
-					     &src.val, src.bytes, ctxt->vcpu)) != 0)
+		c->src.type = OP_MEM;
+		c->src.ptr = (unsigned long *)cr2;
+		c->src.val = 0;
+		if ((rc = ops->read_emulated((unsigned long)c->src.ptr,
+					   &c->src.val,
+					   c->src.bytes, ctxt->vcpu)) != 0)
 			goto done;
-		src.orig_val = src.val;
+		c->src.orig_val = c->src.val;
 		break;
 	case SrcImm:
-		src.type = OP_IMM;
-		src.ptr = (unsigned long *)_eip;
-		src.bytes = (d & ByteOp) ? 1 : op_bytes;
-		if (src.bytes == 8)
-			src.bytes = 4;
+		c->src.type = OP_IMM;
+		c->src.ptr = (unsigned long *)c->eip;
+		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		if (c->src.bytes == 8)
+			c->src.bytes = 4;
 		/* NB. Immediates are sign-extended as necessary. */
-		switch (src.bytes) {
+		switch (c->src.bytes) {
 		case 1:
-			src.val = insn_fetch(s8, 1, _eip);
+			c->src.val = insn_fetch(s8, 1, c->eip);
 			break;
 		case 2:
-			src.val = insn_fetch(s16, 2, _eip);
+			c->src.val = insn_fetch(s16, 2, c->eip);
 			break;
 		case 4:
-			src.val = insn_fetch(s32, 4, _eip);
+			c->src.val = insn_fetch(s32, 4, c->eip);
 			break;
 		}
 		break;
 	case SrcImmByte:
-		src.type = OP_IMM;
-		src.ptr = (unsigned long *)_eip;
-		src.bytes = 1;
-		src.val = insn_fetch(s8, 1, _eip);
+		c->src.type = OP_IMM;
+		c->src.ptr = (unsigned long *)c->eip;
+		c->src.bytes = 1;
+		c->src.val = insn_fetch(s8, 1, c->eip);
 		break;
 	}
 
 	/* Decode and fetch the destination operand: register or memory. */
-	switch (d & DstMask) {
+	switch (c->d & DstMask) {
 	case ImplicitOps:
 		/* Special instructions do their own operand decoding. */
 		goto special_insn;
 	case DstReg:
-		dst.type = OP_REG;
-		if ((d & ByteOp)
-		    && !(twobyte && (b == 0xb6 || b == 0xb7))) {
-			dst.ptr = decode_register(modrm_reg, _regs,
+		c->dst.type = OP_REG;
+		if ((c->d & ByteOp)
+		    && !(c->twobyte &&
+			(c->b == 0xb6 || c->b == 0xb7))) {
+			c->dst.ptr =
+				decode_register(c->modrm_reg, c->regs,
 						  (rex_prefix == 0));
-			dst.val = *(u8 *) dst.ptr;
-			dst.bytes = 1;
+			c->dst.val = *(u8 *) c->dst.ptr;
+			c->dst.bytes = 1;
 		} else {
-			dst.ptr = decode_register(modrm_reg, _regs, 0);
-			switch ((dst.bytes = op_bytes)) {
+			c->dst.ptr =
+			    decode_register(c->modrm_reg, c->regs, 0);
+			switch ((c->dst.bytes = c->op_bytes)) {
 			case 2:
-				dst.val = *(u16 *)dst.ptr;
+				c->dst.val = *(u16 *)c->dst.ptr;
 				break;
 			case 4:
-				dst.val = *(u32 *)dst.ptr;
+				c->dst.val = *(u32 *)c->dst.ptr;
 				break;
 			case 8:
-				dst.val = *(u64 *)dst.ptr;
+				c->dst.val = *(u64 *)c->dst.ptr;
 				break;
 			}
 		}
 		break;
 	case DstMem:
-		dst.type = OP_MEM;
-		dst.ptr = (unsigned long *)cr2;
-		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
-		dst.val = 0;
-		/*
-		 * For instructions with a ModR/M byte, switch to register
-		 * access if Mod = 3.
-		 */
-		if ((d & ModRM) && modrm_mod == 3) {
-			dst.type = OP_REG;
+		c->dst.type = OP_MEM;
+		c->dst.ptr = (unsigned long *)cr2;
+		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		c->dst.val = 0;
+		if ((c->d & ModRM) && c->modrm_mod == 3) {
+			c->dst.type = OP_REG;
 			break;
 		}
-		if (d & BitOp) {
-			unsigned long mask = ~(dst.bytes * 8 - 1);
+		if (c->d & BitOp) {
+			unsigned long mask = ~(c->dst.bytes * 8 - 1);
 
-			dst.ptr = (void *)dst.ptr + (src.val & mask) / 8;
+			c->dst.ptr = (void *)c->dst.ptr +
+						   (c->src.val & mask) / 8;
 		}
-		if (!(d & Mov) && /* optimisation - avoid slow emulated read */
-		    ((rc = ops->read_emulated((unsigned long)dst.ptr,
-					      &dst.val, dst.bytes, ctxt->vcpu)) != 0))
+		if (!(c->d & Mov) &&
+				   /* optimisation - avoid slow emulated read */
+		    ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
+					   &c->dst.val,
+					  c->dst.bytes, ctxt->vcpu)) != 0))
 			goto done;
 		break;
 	}
-	dst.orig_val = dst.val;
+	c->dst.orig_val = c->dst.val;
 
-	if (twobyte)
+	if (c->twobyte)
 		goto twobyte_insn;
 
-	switch (b) {
+	switch (c->b) {
 	case 0x00 ... 0x05:
 	      add:		/* add */
-		emulate_2op_SrcV("add", src, dst, _eflags);
+		emulate_2op_SrcV("add", c->src, c->dst, _eflags);
 		break;
 	case 0x08 ... 0x0d:
 	      or:		/* or */
-		emulate_2op_SrcV("or", src, dst, _eflags);
+		emulate_2op_SrcV("or", c->src, c->dst, _eflags);
 		break;
 	case 0x10 ... 0x15:
 	      adc:		/* adc */
-		emulate_2op_SrcV("adc", src, dst, _eflags);
+		emulate_2op_SrcV("adc", c->src, c->dst, _eflags);
 		break;
 	case 0x18 ... 0x1d:
 	      sbb:		/* sbb */
-		emulate_2op_SrcV("sbb", src, dst, _eflags);
+		emulate_2op_SrcV("sbb", c->src, c->dst, _eflags);
 		break;
 	case 0x20 ... 0x23:
 	      and:		/* and */
-		emulate_2op_SrcV("and", src, dst, _eflags);
+		emulate_2op_SrcV("and", c->src, c->dst, _eflags);
 		break;
 	case 0x24:              /* and al imm8 */
-		dst.type = OP_REG;
-		dst.ptr = &_regs[VCPU_REGS_RAX];
-		dst.val = *(u8 *)dst.ptr;
-		dst.bytes = 1;
-		dst.orig_val = dst.val;
+		c->dst.type = OP_REG;
+		c->dst.ptr = &c->regs[VCPU_REGS_RAX];
+		c->dst.val = *(u8 *)c->dst.ptr;
+		c->dst.bytes = 1;
+		c->dst.orig_val = c->dst.val;
 		goto and;
 	case 0x25:              /* and ax imm16, or eax imm32 */
-		dst.type = OP_REG;
-		dst.bytes = op_bytes;
-		dst.ptr = &_regs[VCPU_REGS_RAX];
-		if (op_bytes == 2)
-			dst.val = *(u16 *)dst.ptr;
+		c->dst.type = OP_REG;
+		c->dst.bytes = c->op_bytes;
+		c->dst.ptr = &c->regs[VCPU_REGS_RAX];
+		if (c->op_bytes == 2)
+			c->dst.val = *(u16 *)c->dst.ptr;
 		else
-			dst.val = *(u32 *)dst.ptr;
-		dst.orig_val = dst.val;
+			c->dst.val = *(u32 *)c->dst.ptr;
+		c->dst.orig_val = c->dst.val;
 		goto and;
 	case 0x28 ... 0x2d:
 	      sub:		/* sub */
-		emulate_2op_SrcV("sub", src, dst, _eflags);
+		emulate_2op_SrcV("sub", c->src, c->dst, _eflags);
 		break;
 	case 0x30 ... 0x35:
 	      xor:		/* xor */
-		emulate_2op_SrcV("xor", src, dst, _eflags);
+		emulate_2op_SrcV("xor", c->src, c->dst, _eflags);
 		break;
 	case 0x38 ... 0x3d:
 	      cmp:		/* cmp */
-		emulate_2op_SrcV("cmp", src, dst, _eflags);
+		emulate_2op_SrcV("cmp", c->src, c->dst, _eflags);
 		break;
 	case 0x63:		/* movsxd */
 		if (mode != X86EMUL_MODE_PROT64)
 			goto cannot_emulate;
-		dst.val = (s32) src.val;
+		c->dst.val = (s32) c->src.val;
 		break;
 	case 0x80 ... 0x83:	/* Grp1 */
-		switch (modrm_reg) {
+		switch (c->modrm_reg) {
 		case 0:
 			goto add;
 		case 1:
@@ -1001,155 +1009,164 @@ done_prefixes:
 		break;
 	case 0x84 ... 0x85:
 	      test:		/* test */
-		emulate_2op_SrcV("test", src, dst, _eflags);
+		emulate_2op_SrcV("test", c->src, c->dst, _eflags);
 		break;
 	case 0x86 ... 0x87:	/* xchg */
 		/* Write back the register source. */
-		switch (dst.bytes) {
+		switch (c->dst.bytes) {
 		case 1:
-			*(u8 *) src.ptr = (u8) dst.val;
+			*(u8 *) c->src.ptr = (u8) c->dst.val;
 			break;
 		case 2:
-			*(u16 *) src.ptr = (u16) dst.val;
+			*(u16 *) c->src.ptr = (u16) c->dst.val;
 			break;
 		case 4:
-			*src.ptr = (u32) dst.val;
+			*c->src.ptr = (u32) c->dst.val;
 			break;	/* 64b reg: zero-extend */
 		case 8:
-			*src.ptr = dst.val;
+			*c->src.ptr = c->dst.val;
 			break;
 		}
 		/*
 		 * Write back the memory destination with implicit LOCK
 		 * prefix.
 		 */
-		dst.val = src.val;
-		lock_prefix = 1;
+		c->dst.val = c->src.val;
+		c->lock_prefix = 1;
 		break;
 	case 0x88 ... 0x8b:	/* mov */
 		goto mov;
 	case 0x8d: /* lea r16/r32, m */
-		dst.val = modrm_val;
+		c->dst.val = c->modrm_val;
 		break;
 	case 0x8f:		/* pop (sole member of Grp1a) */
 		/* 64-bit mode: POP always pops a 64-bit operand. */
 		if (mode == X86EMUL_MODE_PROT64)
-			dst.bytes = 8;
-		if ((rc = ops->read_std(register_address(ctxt->ss_base,
-							 _regs[VCPU_REGS_RSP]),
-					&dst.val, dst.bytes, ctxt->vcpu)) != 0)
+			c->dst.bytes = 8;
+		if ((rc = ops->read_std(register_address(
+						   ctxt->ss_base,
+						   c->regs[VCPU_REGS_RSP]),
+						   &c->dst.val,
+						   c->dst.bytes,
+						   ctxt->vcpu)) != 0)
 			goto done;
-		register_address_increment(_regs[VCPU_REGS_RSP], dst.bytes);
+		register_address_increment(c->regs[VCPU_REGS_RSP],
+					   c->dst.bytes);
 		break;
 	case 0xa0 ... 0xa1:	/* mov */
-		dst.ptr = (unsigned long *)&_regs[VCPU_REGS_RAX];
-		dst.val = src.val;
-		_eip += ad_bytes;	/* skip src displacement */
+		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
+		c->dst.val = c->src.val;
+		/* skip src displacement */
+		c->eip += c->ad_bytes;
 		break;
 	case 0xa2 ... 0xa3:	/* mov */
-		dst.val = (unsigned long)_regs[VCPU_REGS_RAX];
-		_eip += ad_bytes;	/* skip dst displacement */
+		c->dst.val = (unsigned long)c->regs[VCPU_REGS_RAX];
+		/* skip c->dst displacement */
+		c->eip += c->ad_bytes;
 		break;
 	case 0xc0 ... 0xc1:
 	      grp2:		/* Grp2 */
-		switch (modrm_reg) {
+		switch (c->modrm_reg) {
 		case 0:	/* rol */
-			emulate_2op_SrcB("rol", src, dst, _eflags);
+			emulate_2op_SrcB("rol", c->src, c->dst, _eflags);
 			break;
 		case 1:	/* ror */
-			emulate_2op_SrcB("ror", src, dst, _eflags);
+			emulate_2op_SrcB("ror", c->src, c->dst, _eflags);
 			break;
 		case 2:	/* rcl */
-			emulate_2op_SrcB("rcl", src, dst, _eflags);
+			emulate_2op_SrcB("rcl", c->src, c->dst, _eflags);
 			break;
 		case 3:	/* rcr */
-			emulate_2op_SrcB("rcr", src, dst, _eflags);
+			emulate_2op_SrcB("rcr", c->src, c->dst, _eflags);
 			break;
 		case 4:	/* sal/shl */
 		case 6:	/* sal/shl */
-			emulate_2op_SrcB("sal", src, dst, _eflags);
+			emulate_2op_SrcB("sal", c->src, c->dst, _eflags);
 			break;
 		case 5:	/* shr */
-			emulate_2op_SrcB("shr", src, dst, _eflags);
+			emulate_2op_SrcB("shr", c->src, c->dst, _eflags);
 			break;
 		case 7:	/* sar */
-			emulate_2op_SrcB("sar", src, dst, _eflags);
+			emulate_2op_SrcB("sar", c->src, c->dst, _eflags);
 			break;
 		}
 		break;
 	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
 	mov:
-		dst.val = src.val;
+		c->dst.val = c->src.val;
 		break;
 	case 0xd0 ... 0xd1:	/* Grp2 */
-		src.val = 1;
+		c->src.val = 1;
 		goto grp2;
 	case 0xd2 ... 0xd3:	/* Grp2 */
-		src.val = _regs[VCPU_REGS_RCX];
+		c->src.val = c->regs[VCPU_REGS_RCX];
 		goto grp2;
 	case 0xf6 ... 0xf7:	/* Grp3 */
-		switch (modrm_reg) {
+		switch (c->modrm_reg) {
 		case 0 ... 1:	/* test */
 			/*
 			 * Special case in Grp3: test has an immediate
 			 * source operand.
 			 */
-			src.type = OP_IMM;
-			src.ptr = (unsigned long *)_eip;
-			src.bytes = (d & ByteOp) ? 1 : op_bytes;
-			if (src.bytes == 8)
-				src.bytes = 4;
-			switch (src.bytes) {
+			c->src.type = OP_IMM;
+			c->src.ptr = (unsigned long *)c->eip;
+			c->src.bytes = (c->d & ByteOp) ? 1 :
+							       c->op_bytes;
+			if (c->src.bytes == 8)
+				c->src.bytes = 4;
+			switch (c->src.bytes) {
 			case 1:
-				src.val = insn_fetch(s8, 1, _eip);
+				c->src.val = insn_fetch(s8, 1, c->eip);
 				break;
 			case 2:
-				src.val = insn_fetch(s16, 2, _eip);
+				c->src.val = insn_fetch(s16, 2, c->eip);
 				break;
 			case 4:
-				src.val = insn_fetch(s32, 4, _eip);
+				c->src.val = insn_fetch(s32, 4, c->eip);
 				break;
 			}
 			goto test;
 		case 2:	/* not */
-			dst.val = ~dst.val;
+			c->dst.val = ~c->dst.val;
 			break;
 		case 3:	/* neg */
-			emulate_1op("neg", dst, _eflags);
+			emulate_1op("neg", c->dst, _eflags);
 			break;
 		default:
 			goto cannot_emulate;
 		}
 		break;
 	case 0xfe ... 0xff:	/* Grp4/Grp5 */
-		switch (modrm_reg) {
+		switch (c->modrm_reg) {
 		case 0:	/* inc */
-			emulate_1op("inc", dst, _eflags);
+			emulate_1op("inc", c->dst, _eflags);
 			break;
 		case 1:	/* dec */
-			emulate_1op("dec", dst, _eflags);
+			emulate_1op("dec", c->dst, _eflags);
 			break;
 		case 4: /* jmp abs */
-			if (b == 0xff)
-				_eip = dst.val;
+			if (c->b == 0xff)
+				c->eip = c->dst.val;
 			else
 				goto cannot_emulate;
 			break;
 		case 6:	/* push */
 			/* 64-bit mode: PUSH always pushes a 64-bit operand. */
 			if (mode == X86EMUL_MODE_PROT64) {
-				dst.bytes = 8;
-				if ((rc = ops->read_std((unsigned long)dst.ptr,
-							&dst.val, 8,
-							ctxt->vcpu)) != 0)
+				c->dst.bytes = 8;
+				if ((rc = ops->read_std(
+						 (unsigned long)c->dst.ptr,
+						 &c->dst.val, 8,
+						 ctxt->vcpu)) != 0)
 					goto done;
 			}
-			register_address_increment(_regs[VCPU_REGS_RSP],
-						   -dst.bytes);
+			register_address_increment(c->regs[VCPU_REGS_RSP],
+						   -c->dst.bytes);
 			if ((rc = ops->write_emulated(
 				     register_address(ctxt->ss_base,
-						      _regs[VCPU_REGS_RSP]),
-				     &dst.val, dst.bytes, ctxt->vcpu)) != 0)
+					  c->regs[VCPU_REGS_RSP]),
+					  &c->dst.val,
+					   c->dst.bytes, ctxt->vcpu)) != 0)
 				goto done;
 			no_wb = 1;
 			break;
@@ -1161,34 +1178,40 @@ done_prefixes:
 
 writeback:
 	if (!no_wb) {
-		switch (dst.type) {
+		switch (c->dst.type) {
 		case OP_REG:
-			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
-			switch (dst.bytes) {
+			/* The 4-byte case *is* correct:
+			 * in 64-bit mode we zero-extend.
+			 */
+			switch (c->dst.bytes) {
 			case 1:
-				*(u8 *)dst.ptr = (u8)dst.val;
+				*(u8 *)c->dst.ptr = (u8)c->dst.val;
 				break;
 			case 2:
-				*(u16 *)dst.ptr = (u16)dst.val;
+				*(u16 *)c->dst.ptr = (u16)c->dst.val;
 				break;
 			case 4:
-				*dst.ptr = (u32)dst.val;
+				*c->dst.ptr = (u32)c->dst.val;
 				break;	/* 64b: zero-ext */
 			case 8:
-				*dst.ptr = dst.val;
+				*c->dst.ptr = c->dst.val;
 				break;
 			}
 			break;
 		case OP_MEM:
-			if (lock_prefix)
-				rc = ops->cmpxchg_emulated((unsigned long)dst.
-							   ptr, &dst.orig_val,
-							   &dst.val, dst.bytes,
-							   ctxt->vcpu);
+			if (c->lock_prefix)
+				rc = ops->cmpxchg_emulated(
+						(unsigned long)c->dst.ptr,
+						&c->dst.orig_val,
+						&c->dst.val,
+						c->dst.bytes,
+						ctxt->vcpu);
 			else
-				rc = ops->write_emulated((unsigned long)dst.ptr,
-							 &dst.val, dst.bytes,
-							 ctxt->vcpu);
+				rc = ops->write_emulated(
+						(unsigned long)c->dst.ptr,
+						&c->dst.val,
+						c->dst.bytes,
+						ctxt->vcpu);
 			if (rc != 0)
 				goto done;
 		default:
@@ -1197,173 +1220,185 @@ writeback:
 	}
 
 	/* Commit shadow register state. */
-	memcpy(ctxt->vcpu->regs, _regs, sizeof _regs);
+	memcpy(ctxt->vcpu->regs, c->regs, sizeof c->regs);
 	ctxt->eflags = _eflags;
-	ctxt->vcpu->rip = _eip;
+	ctxt->vcpu->rip = c->eip;
 
 done:
 	return (rc == X86EMUL_UNHANDLEABLE) ? -1 : 0;
 
 special_insn:
-	if (twobyte)
+	if (c->twobyte)
 		goto twobyte_special_insn;
-	switch(b) {
+	switch (c->b) {
 	case 0x50 ... 0x57:  /* push reg */
-		if (op_bytes == 2)
-			src.val = (u16) _regs[b & 0x7];
+		if (c->op_bytes == 2)
+			c->src.val = (u16) c->regs[c->b & 0x7];
 		else
-			src.val = (u32) _regs[b & 0x7];
-		dst.type  = OP_MEM;
-		dst.bytes = op_bytes;
-		dst.val = src.val;
-		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
-		dst.ptr = (void *) register_address(
-			ctxt->ss_base, _regs[VCPU_REGS_RSP]);
+			c->src.val = (u32) c->regs[c->b & 0x7];
+		c->dst.type  = OP_MEM;
+		c->dst.bytes = c->op_bytes;
+		c->dst.val = c->src.val;
+		register_address_increment(c->regs[VCPU_REGS_RSP],
+					   -c->op_bytes);
+		c->dst.ptr = (void *) register_address(
+			ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
 		break;
 	case 0x58 ... 0x5f: /* pop reg */
-		dst.ptr = (unsigned long *)&_regs[b & 0x7];
+		c->dst.ptr =
+				(unsigned long *)&c->regs[c->b & 0x7];
 	pop_instruction:
 		if ((rc = ops->read_std(register_address(ctxt->ss_base,
-			_regs[VCPU_REGS_RSP]), dst.ptr, op_bytes, ctxt->vcpu))
-			!= 0)
+			c->regs[VCPU_REGS_RSP]), c->dst.ptr,
+			c->op_bytes, ctxt->vcpu)) != 0)
 			goto done;
 
-		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
+		register_address_increment(c->regs[VCPU_REGS_RSP],
+					   c->op_bytes);
 		no_wb = 1; /* Disable writeback. */
 		break;
 	case 0x6a: /* push imm8 */
-		src.val = 0L;
-		src.val = insn_fetch(s8, 1, _eip);
-	push:
-		dst.type  = OP_MEM;
-		dst.bytes = op_bytes;
-		dst.val = src.val;
-		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
-		dst.ptr = (void *) register_address(ctxt->ss_base,
-							_regs[VCPU_REGS_RSP]);
+		c->src.val = 0L;
+		c->src.val = insn_fetch(s8, 1, c->eip);
+push:
+		c->dst.type  = OP_MEM;
+		c->dst.bytes = c->op_bytes;
+		c->dst.val = c->src.val;
+		register_address_increment(c->regs[VCPU_REGS_RSP],
+					   -c->op_bytes);
+		c->dst.ptr = (void *) register_address(ctxt->ss_base,
+						       c->regs[VCPU_REGS_RSP]);
 		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
 		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
-				1, 					/* in */
-				(d & ByteOp) ? 1 : op_bytes, 		/* size */
-				rep_prefix ?
-				address_mask(_regs[VCPU_REGS_RCX]) : 1,	/* count */
-				(_eflags & EFLG_DF),			/* down */
+				1,
+				(c->d & ByteOp) ? 1 : c->op_bytes,
+				c->rep_prefix ?
+				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				(_eflags & EFLG_DF),
 				register_address(ctxt->es_base,
-						 _regs[VCPU_REGS_RDI]),	/* address */
-				rep_prefix,
-				_regs[VCPU_REGS_RDX]			/* port */
-				) == 0)
+						 c->regs[VCPU_REGS_RDI]),
+				c->rep_prefix,
+				c->regs[VCPU_REGS_RDX]) == 0)
 			return -1;
 		return 0;
 	case 0x6e:		/* outsb */
 	case 0x6f:		/* outsw/outsd */
 		if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
-				0, 					/* in */
-				(d & ByteOp) ? 1 : op_bytes, 		/* size */
-				rep_prefix ?
-				address_mask(_regs[VCPU_REGS_RCX]) : 1,	/* count */
-				(_eflags & EFLG_DF),			/* down */
-				register_address(override_base ?
-						 *override_base : ctxt->ds_base,
-						 _regs[VCPU_REGS_RSI]),	/* address */
-				rep_prefix,
-				_regs[VCPU_REGS_RDX]			/* port */
-				) == 0)
+				0,
+				(c->d & ByteOp) ? 1 : c->op_bytes,
+				c->rep_prefix ?
+				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				(_eflags & EFLG_DF),
+				register_address(c->override_base ?
+							*c->override_base :
+							ctxt->ds_base,
+						 c->regs[VCPU_REGS_RSI]),
+				c->rep_prefix,
+				c->regs[VCPU_REGS_RDX]) == 0)
 			return -1;
 		return 0;
 	case 0x70 ... 0x7f: /* jcc (short) */ {
-		int rel = insn_fetch(s8, 1, _eip);
+		int rel = insn_fetch(s8, 1, c->eip);
 
-		if (test_cc(b, _eflags))
+		if (test_cc(c->b, _eflags))
 		JMP_REL(rel);
 		break;
 	}
 	case 0x9c: /* pushf */
-		src.val =  (unsigned long) _eflags;
+		c->src.val =  (unsigned long) _eflags;
 		goto push;
 	case 0x9d: /* popf */
-		dst.ptr = (unsigned long *) &_eflags;
+		c->dst.ptr = (unsigned long *) &_eflags;
 		goto pop_instruction;
 	case 0xc3: /* ret */
-		dst.ptr = &_eip;
+		c->dst.ptr = &c->eip;
 		goto pop_instruction;
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->halt_request = 1;
 		goto done;
 	}
-	if (rep_prefix) {
-		if (_regs[VCPU_REGS_RCX] == 0) {
-			ctxt->vcpu->rip = _eip;
+	if (c->rep_prefix) {
+		if (c->regs[VCPU_REGS_RCX] == 0) {
+			ctxt->vcpu->rip = c->eip;
 			goto done;
 		}
-		_regs[VCPU_REGS_RCX]--;
-		_eip = ctxt->vcpu->rip;
+		c->regs[VCPU_REGS_RCX]--;
+		c->eip = ctxt->vcpu->rip;
 	}
-	switch (b) {
+	switch (c->b) {
 	case 0xa4 ... 0xa5:	/* movs */
-		dst.type = OP_MEM;
-		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
-		dst.ptr = (unsigned long *)register_address(ctxt->es_base,
-							_regs[VCPU_REGS_RDI]);
+		c->dst.type = OP_MEM;
+		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		c->dst.ptr = (unsigned long *)register_address(
+						   ctxt->es_base,
+						   c->regs[VCPU_REGS_RDI]);
 		if ((rc = ops->read_emulated(register_address(
-		      override_base ? *override_base : ctxt->ds_base,
-		      _regs[VCPU_REGS_RSI]), &dst.val, dst.bytes, ctxt->vcpu)) != 0)
+		      c->override_base ? *c->override_base :
+					ctxt->ds_base,
+					c->regs[VCPU_REGS_RSI]),
+					&c->dst.val,
+					c->dst.bytes, ctxt->vcpu)) != 0)
 			goto done;
-		register_address_increment(_regs[VCPU_REGS_RSI],
-			     (_eflags & EFLG_DF) ? -dst.bytes : dst.bytes);
-		register_address_increment(_regs[VCPU_REGS_RDI],
-			     (_eflags & EFLG_DF) ? -dst.bytes : dst.bytes);
+		register_address_increment(c->regs[VCPU_REGS_RSI],
+				       (_eflags & EFLG_DF) ? -c->dst.bytes
+							   : c->dst.bytes);
+		register_address_increment(c->regs[VCPU_REGS_RDI],
+				       (_eflags & EFLG_DF) ? -c->dst.bytes
+							   : c->dst.bytes);
 		break;
 	case 0xa6 ... 0xa7:	/* cmps */
 		DPRINTF("Urk! I don't handle CMPS.\n");
 		goto cannot_emulate;
 	case 0xaa ... 0xab:	/* stos */
-		dst.type = OP_MEM;
-		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
-		dst.ptr = (unsigned long *)cr2;
-		dst.val = _regs[VCPU_REGS_RAX];
-		register_address_increment(_regs[VCPU_REGS_RDI],
-			     (_eflags & EFLG_DF) ? -dst.bytes : dst.bytes);
+		c->dst.type = OP_MEM;
+		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		c->dst.ptr = (unsigned long *)cr2;
+		c->dst.val = c->regs[VCPU_REGS_RAX];
+		register_address_increment(c->regs[VCPU_REGS_RDI],
+				       (_eflags & EFLG_DF) ? -c->dst.bytes
+							   : c->dst.bytes);
 		break;
 	case 0xac ... 0xad:	/* lods */
-		dst.type = OP_REG;
-		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
-		dst.ptr = (unsigned long *)&_regs[VCPU_REGS_RAX];
-		if ((rc = ops->read_emulated(cr2, &dst.val, dst.bytes,
+		c->dst.type = OP_REG;
+		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
+		if ((rc = ops->read_emulated(cr2, &c->dst.val,
+					     c->dst.bytes,
 					     ctxt->vcpu)) != 0)
 			goto done;
-		register_address_increment(_regs[VCPU_REGS_RSI],
-			   (_eflags & EFLG_DF) ? -dst.bytes : dst.bytes);
+		register_address_increment(c->regs[VCPU_REGS_RSI],
+				       (_eflags & EFLG_DF) ? -c->dst.bytes
+							   : c->dst.bytes);
 		break;
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
 	case 0xe8: /* call (near) */ {
 		long int rel;
-		switch (op_bytes) {
+		switch (c->op_bytes) {
 		case 2:
-			rel = insn_fetch(s16, 2, _eip);
+			rel = insn_fetch(s16, 2, c->eip);
 			break;
 		case 4:
-			rel = insn_fetch(s32, 4, _eip);
+			rel = insn_fetch(s32, 4, c->eip);
 			break;
 		case 8:
-			rel = insn_fetch(s64, 8, _eip);
+			rel = insn_fetch(s64, 8, c->eip);
 			break;
 		default:
 			DPRINTF("Call: Invalid op_bytes\n");
 			goto cannot_emulate;
 		}
-		src.val = (unsigned long) _eip;
+		c->src.val = (unsigned long) c->eip;
 		JMP_REL(rel);
-		op_bytes = ad_bytes;
+		c->op_bytes = c->ad_bytes;
 		goto push;
 	}
 	case 0xe9: /* jmp rel */
 	case 0xeb: /* jmp rel short */
-		JMP_REL(src.val);
+		JMP_REL(c->src.val);
 		no_wb = 1; /* Disable writeback. */
 		break;
 
@@ -1372,16 +1407,16 @@ special_insn:
 	goto writeback;
 
 twobyte_insn:
-	switch (b) {
+	switch (c->b) {
 	case 0x01: /* lgdt, lidt, lmsw */
 		/* Disable writeback. */
 		no_wb = 1;
-		switch (modrm_reg) {
+		switch (c->modrm_reg) {
 			u16 size;
 			unsigned long address;
 
 		case 0: /* vmcall */
-			if (modrm_mod != 3 || modrm_rm != 1)
+			if (c->modrm_mod != 3 || c->modrm_rm != 1)
 				goto cannot_emulate;
 
 			rc = kvm_fix_hypercall(ctxt->vcpu);
@@ -1391,37 +1426,37 @@ twobyte_insn:
 			kvm_emulate_hypercall(ctxt->vcpu);
 			break;
 		case 2: /* lgdt */
-			rc = read_descriptor(ctxt, ops, src.ptr,
-					     &size, &address, op_bytes);
+			rc = read_descriptor(ctxt, ops, c->src.ptr,
+					     &size, &address, c->op_bytes);
 			if (rc)
 				goto done;
 			realmode_lgdt(ctxt->vcpu, size, address);
 			break;
 		case 3: /* lidt/vmmcall */
-			if (modrm_mod == 3 && modrm_rm == 1) {
+			if (c->modrm_mod == 3 && c->modrm_rm == 1) {
 				rc = kvm_fix_hypercall(ctxt->vcpu);
 				if (rc)
 					goto done;
 				kvm_emulate_hypercall(ctxt->vcpu);
 			} else {
-				rc = read_descriptor(ctxt, ops, src.ptr,
+				rc = read_descriptor(ctxt, ops, c->src.ptr,
 						     &size, &address,
-						     op_bytes);
+						     c->op_bytes);
 				if (rc)
 					goto done;
 				realmode_lidt(ctxt->vcpu, size, address);
 			}
 			break;
 		case 4: /* smsw */
-			if (modrm_mod != 3)
+			if (c->modrm_mod != 3)
 				goto cannot_emulate;
-			*(u16 *)&_regs[modrm_rm]
+			*(u16 *)&c->regs[c->modrm_rm]
 				= realmode_get_cr(ctxt->vcpu, 0);
 			break;
 		case 6: /* lmsw */
-			if (modrm_mod != 3)
+			if (c->modrm_mod != 3)
 				goto cannot_emulate;
-			realmode_lmsw(ctxt->vcpu, (u16)modrm_val, &_eflags);
+			realmode_lmsw(ctxt->vcpu, (u16)c->modrm_val, &_eflags);
 			break;
 		case 7: /* invlpg*/
 			emulate_invlpg(ctxt->vcpu, cr2);
@@ -1432,24 +1467,26 @@ twobyte_insn:
 		break;
 	case 0x21: /* mov from dr to reg */
 		no_wb = 1;
-		if (modrm_mod != 3)
+		if (c->modrm_mod != 3)
 			goto cannot_emulate;
-		rc = emulator_get_dr(ctxt, modrm_reg, &_regs[modrm_rm]);
+		rc = emulator_get_dr(ctxt, c->modrm_reg,
+				     &c->regs[c->modrm_rm]);
 		break;
 	case 0x23: /* mov from reg to dr */
 		no_wb = 1;
-		if (modrm_mod != 3)
+		if (c->modrm_mod != 3)
 			goto cannot_emulate;
-		rc = emulator_set_dr(ctxt, modrm_reg, _regs[modrm_rm]);
+		rc = emulator_set_dr(ctxt, c->modrm_reg,
+				     c->regs[c->modrm_rm]);
 		break;
 	case 0x40 ... 0x4f:	/* cmov */
-		dst.val = dst.orig_val = src.val;
+		c->dst.val = c->dst.orig_val = c->src.val;
 		no_wb = 1;
 		/*
 		 * First, assume we're decoding an even cmov opcode
 		 * (lsb == 0).
 		 */
-		switch ((b & 15) >> 1) {
+		switch ((c->b & 15) >> 1) {
 		case 0:	/* cmovo */
 			no_wb = (_eflags & EFLG_OF) ? 0 : 1;
 			break;
@@ -1477,46 +1514,50 @@ twobyte_insn:
 			break;
 		}
 		/* Odd cmov opcodes (lsb == 1) have inverted sense. */
-		no_wb ^= b & 1;
+		no_wb ^= c->b & 1;
 		break;
 	case 0xa3:
 	      bt:		/* bt */
-		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
-		emulate_2op_SrcV_nobyte("bt", src, dst, _eflags);
+		/* only subword offset */
+		c->src.val &= (c->dst.bytes << 3) - 1;
+		emulate_2op_SrcV_nobyte("bt", c->src, c->dst, _eflags);
 		break;
 	case 0xab:
 	      bts:		/* bts */
-		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
-		emulate_2op_SrcV_nobyte("bts", src, dst, _eflags);
+		/* only subword offset */
+		c->src.val &= (c->dst.bytes << 3) - 1;
+		emulate_2op_SrcV_nobyte("bts", c->src, c->dst, _eflags);
 		break;
 	case 0xb0 ... 0xb1:	/* cmpxchg */
 		/*
 		 * Save real source value, then compare EAX against
 		 * destination.
 		 */
-		src.orig_val = src.val;
-		src.val = _regs[VCPU_REGS_RAX];
-		emulate_2op_SrcV("cmp", src, dst, _eflags);
+		c->src.orig_val = c->src.val;
+		c->src.val = c->regs[VCPU_REGS_RAX];
+		emulate_2op_SrcV("cmp", c->src, c->dst, _eflags);
 		if (_eflags & EFLG_ZF) {
 			/* Success: write back to memory. */
-			dst.val = src.orig_val;
+			c->dst.val = c->src.orig_val;
 		} else {
 			/* Failure: write the value we saw to EAX. */
-			dst.type = OP_REG;
-			dst.ptr = (unsigned long *)&_regs[VCPU_REGS_RAX];
+			c->dst.type = OP_REG;
+			c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
 		}
 		break;
 	case 0xb3:
 	      btr:		/* btr */
-		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
-		emulate_2op_SrcV_nobyte("btr", src, dst, _eflags);
+		/* only subword offset */
+		c->src.val &= (c->dst.bytes << 3) - 1;
+		emulate_2op_SrcV_nobyte("btr", c->src, c->dst, _eflags);
 		break;
 	case 0xb6 ... 0xb7:	/* movzx */
-		dst.bytes = op_bytes;
-		dst.val = (d & ByteOp) ? (u8) src.val : (u16) src.val;
+		c->dst.bytes = c->op_bytes;
+		c->dst.val = (c->d & ByteOp) ? (u8) c->src.val
+						       : (u16) c->src.val;
 		break;
 	case 0xba:		/* Grp8 */
-		switch (modrm_reg & 3) {
+		switch (c->modrm_reg & 3) {
 		case 0:
 			goto bt;
 		case 1:
@@ -1529,16 +1570,19 @@ twobyte_insn:
 		break;
 	case 0xbb:
 	      btc:		/* btc */
-		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
-		emulate_2op_SrcV_nobyte("btc", src, dst, _eflags);
+		/* only subword offset */
+		c->src.val &= (c->dst.bytes << 3) - 1;
+		emulate_2op_SrcV_nobyte("btc", c->src, c->dst, _eflags);
 		break;
 	case 0xbe ... 0xbf:	/* movsx */
-		dst.bytes = op_bytes;
-		dst.val = (d & ByteOp) ? (s8) src.val : (s16) src.val;
+		c->dst.bytes = c->op_bytes;
+		c->dst.val = (c->d & ByteOp) ? (s8) c->src.val :
+							(s16) c->src.val;
 		break;
 	case 0xc3:		/* movnti */
-		dst.bytes = op_bytes;
-		dst.val = (op_bytes == 4) ? (u32) src.val : (u64) src.val;
+		c->dst.bytes = c->op_bytes;
+		c->dst.val = (c->op_bytes == 4) ? (u32) c->src.val :
+			                                (u64) c->src.val;
 		break;
 	}
 	goto writeback;
@@ -1546,7 +1590,7 @@ twobyte_insn:
 twobyte_special_insn:
 	/* Disable writeback. */
 	no_wb = 1;
-	switch (b) {
+	switch (c->b) {
 	case 0x06:
 		emulate_clts(ctxt->vcpu);
 		break;
@@ -1558,56 +1602,59 @@ twobyte_special_insn:
 	case 0x18:		/* Grp16 (prefetch/nop) */
 		break;
 	case 0x20: /* mov cr, reg */
-		if (modrm_mod != 3)
+		if (c->modrm_mod != 3)
 			goto cannot_emulate;
-		_regs[modrm_rm] = realmode_get_cr(ctxt->vcpu, modrm_reg);
+		c->regs[c->modrm_rm] =
+				realmode_get_cr(ctxt->vcpu, c->modrm_reg);
 		break;
 	case 0x22: /* mov reg, cr */
-		if (modrm_mod != 3)
+		if (c->modrm_mod != 3)
 			goto cannot_emulate;
-		realmode_set_cr(ctxt->vcpu, modrm_reg, modrm_val, &_eflags);
+		realmode_set_cr(ctxt->vcpu,
+				c->modrm_reg, c->modrm_val, &_eflags);
 		break;
 	case 0x30:
 		/* wrmsr */
-		msr_data = (u32)_regs[VCPU_REGS_RAX]
-			| ((u64)_regs[VCPU_REGS_RDX] << 32);
-		rc = kvm_set_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], msr_data);
+		msr_data = (u32)c->regs[VCPU_REGS_RAX]
+			| ((u64)c->regs[VCPU_REGS_RDX] << 32);
+		rc = kvm_set_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], msr_data);
 		if (rc) {
 			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
-			_eip = ctxt->vcpu->rip;
+			c->eip = ctxt->vcpu->rip;
 		}
 		rc = X86EMUL_CONTINUE;
 		break;
 	case 0x32:
 		/* rdmsr */
-		rc = kvm_get_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], &msr_data);
+		rc = kvm_get_msr(ctxt->vcpu,
+				 c->regs[VCPU_REGS_RCX], &msr_data);
 		if (rc) {
 			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
-			_eip = ctxt->vcpu->rip;
+			c->eip = ctxt->vcpu->rip;
 		} else {
-			_regs[VCPU_REGS_RAX] = (u32)msr_data;
-			_regs[VCPU_REGS_RDX] = msr_data >> 32;
+			c->regs[VCPU_REGS_RAX] = (u32)msr_data;
+			c->regs[VCPU_REGS_RDX] = msr_data >> 32;
 		}
 		rc = X86EMUL_CONTINUE;
 		break;
 	case 0x80 ... 0x8f: /* jnz rel, etc*/ {
 		long int rel;
 
-		switch (op_bytes) {
+		switch (c->op_bytes) {
 		case 2:
-			rel = insn_fetch(s16, 2, _eip);
+			rel = insn_fetch(s16, 2, c->eip);
 			break;
 		case 4:
-			rel = insn_fetch(s32, 4, _eip);
+			rel = insn_fetch(s32, 4, c->eip);
 			break;
 		case 8:
-			rel = insn_fetch(s64, 8, _eip);
+			rel = insn_fetch(s64, 8, c->eip);
 			break;
 		default:
 			DPRINTF("jnz: Invalid op_bytes\n");
 			goto cannot_emulate;
 		}
-		if (test_cc(b, _eflags))
+		if (test_cc(c->b, _eflags))
 			JMP_REL(rel);
 		break;
 	}
@@ -1617,14 +1664,16 @@ twobyte_special_insn:
 			if ((rc = ops->read_emulated(cr2, &old, 8, ctxt->vcpu))
 									!= 0)
 				goto done;
-			if (((u32) (old >> 0) != (u32) _regs[VCPU_REGS_RAX]) ||
-			    ((u32) (old >> 32) != (u32) _regs[VCPU_REGS_RDX])) {
-				_regs[VCPU_REGS_RAX] = (u32) (old >> 0);
-				_regs[VCPU_REGS_RDX] = (u32) (old >> 32);
+			if (((u32) (old >> 0) !=
+					(u32) c->regs[VCPU_REGS_RAX]) ||
+			    ((u32) (old >> 32) !=
+					(u32) c->regs[VCPU_REGS_RDX])) {
+				c->regs[VCPU_REGS_RAX] = (u32) (old >> 0);
+				c->regs[VCPU_REGS_RDX] = (u32) (old >> 32);
 				_eflags &= ~EFLG_ZF;
 			} else {
-				new = ((u64)_regs[VCPU_REGS_RCX] << 32)
-					| (u32) _regs[VCPU_REGS_RBX];
+				new = ((u64)c->regs[VCPU_REGS_RCX] << 32)
+					| (u32) c->regs[VCPU_REGS_RBX];
 				if ((rc = ops->cmpxchg_emulated(cr2, &old,
 							  &new, 8, ctxt->vcpu)) != 0)
 					goto done;
@@ -1636,6 +1685,6 @@ twobyte_special_insn:
 	goto writeback;
 
 cannot_emulate:
-	DPRINTF("Cannot emulate %02x\n", b);
+	DPRINTF("Cannot emulate %02x\n", c->b);
 	return -1;
 }
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index 92c73aa..c354200 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -112,6 +112,36 @@ struct x86_emulate_ops {
 
 };
 
+/* Type, address-of, and value of an instruction's operand. */
+struct operand {
+	enum { OP_REG, OP_MEM, OP_IMM } type;
+	unsigned int bytes;
+	unsigned long val, orig_val, *ptr;
+};
+
+struct decode_cache {
+	u8 twobyte;
+	u8 b;
+	u8 lock_prefix;
+	u8 rep_prefix;
+	u8 op_bytes;
+	u8 ad_bytes;
+	struct operand src;
+	struct operand dst;
+	unsigned long *override_base;
+	unsigned int d;
+	unsigned long regs[NR_VCPU_REGS];
+	unsigned long eip;
+	/* modrm */
+	u8 modrm;
+	u8 modrm_mod;
+	u8 modrm_reg;
+	u8 modrm_rm;
+	u8 use_modrm_ea;
+	unsigned long modrm_ea;
+	unsigned long modrm_val;
+};
+
 struct x86_emulate_ctxt {
 	/* Register state before/after emulation. */
 	struct kvm_vcpu *vcpu;
@@ -129,6 +159,10 @@ struct x86_emulate_ctxt {
 	unsigned long ss_base;
 	unsigned long gs_base;
 	unsigned long fs_base;
+
+	/* decode cache */
+
+	struct decode_cache decode;
 };
 
 /* Execution mode, passed to the emulator. */
-- 
1.5.3.7

