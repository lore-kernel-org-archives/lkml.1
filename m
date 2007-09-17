Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXIQIyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXIQIyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbXIQIde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:34 -0400
Received: from il.qumranet.com ([82.166.9.18]:45250 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbXIQIch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:37 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 097/104] KVM: x86 emulator: sort opcodes into ascending order
Date: Mon, 17 Sep 2007 10:32:19 +0200
Message-Id: <11900179492229-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   99 ++++++++++++++++++++++-----------------------
 1 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 18c2b2c..e4ce34c 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -978,19 +978,8 @@ push:
 		dst.val = src.val;
 		lock_prefix = 1;
 		break;
-	case 0xa0 ... 0xa1:	/* mov */
-		dst.ptr = (unsigned long *)&_regs[VCPU_REGS_RAX];
-		dst.val = src.val;
-		_eip += ad_bytes;	/* skip src displacement */
-		break;
-	case 0xa2 ... 0xa3:	/* mov */
-		dst.val = (unsigned long)_regs[VCPU_REGS_RAX];
-		_eip += ad_bytes;	/* skip dst displacement */
-		break;
 	case 0x88 ... 0x8b:	/* mov */
-	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
-		dst.val = src.val;
-		break;
+		goto mov;
 	case 0x8f:		/* pop (sole member of Grp1a) */
 		/* 64-bit mode: POP always pops a 64-bit operand. */
 		if (mode == X86EMUL_MODE_PROT64)
@@ -1001,6 +990,15 @@ push:
 			goto done;
 		register_address_increment(_regs[VCPU_REGS_RSP], dst.bytes);
 		break;
+	case 0xa0 ... 0xa1:	/* mov */
+		dst.ptr = (unsigned long *)&_regs[VCPU_REGS_RAX];
+		dst.val = src.val;
+		_eip += ad_bytes;	/* skip src displacement */
+		break;
+	case 0xa2 ... 0xa3:	/* mov */
+		dst.val = (unsigned long)_regs[VCPU_REGS_RAX];
+		_eip += ad_bytes;	/* skip dst displacement */
+		break;
 	case 0xc0 ... 0xc1:
 	      grp2:		/* Grp2 */
 		switch (modrm_reg) {
@@ -1028,6 +1026,10 @@ push:
 			break;
 		}
 		break;
+	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
+	mov:
+		dst.val = src.val;
+		break;
 	case 0xd0 ... 0xd1:	/* Grp2 */
 		src.val = 1;
 		goto grp2;
@@ -1186,6 +1188,17 @@ special_insn:
 		dst.ptr = (void *) register_address(
 			ctxt->ss_base, _regs[VCPU_REGS_RSP]);
 		break;
+	case 0x58 ... 0x5f: /* pop reg */
+		dst.ptr = (unsigned long *)&_regs[b & 0x7];
+	pop_instruction:
+		if ((rc = ops->read_std(register_address(ctxt->ss_base,
+			_regs[VCPU_REGS_RSP]), dst.ptr, op_bytes, ctxt->vcpu))
+			!= 0)
+			goto done;
+
+		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
+		no_wb = 1; /* Disable writeback. */
+		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
 		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
@@ -1217,12 +1230,15 @@ special_insn:
 				) == 0)
 			return -1;
 		return 0;
-
 	case 0x9c: /* pushf */
 		src.val =  (unsigned long) _eflags;
 		goto push;
-		break;
-
+	case 0xc3: /* ret */
+		dst.ptr = &_eip;
+		goto pop_instruction;
+	case 0xf4:              /* hlt */
+		ctxt->vcpu->halt_request = 1;
+		goto done;
 	}
 	if (rep_prefix) {
 		if (_regs[VCPU_REGS_RCX] == 0) {
@@ -1271,24 +1287,7 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
-	case 0xf4:              /* hlt */
-		ctxt->vcpu->halt_request = 1;
-		goto done;
-	case 0xc3: /* ret */
-		dst.ptr = &_eip;
-		goto pop_instruction;
-	case 0x58 ... 0x5f: /* pop reg */
-		dst.ptr = (unsigned long *)&_regs[b & 0x7];
-
-pop_instruction:
-		if ((rc = ops->read_std(register_address(ctxt->ss_base,
-			_regs[VCPU_REGS_RSP]), dst.ptr, op_bytes, ctxt->vcpu))
-			!= 0)
-			goto done;
 
-		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
-		no_wb = 1; /* Disable writeback. */
-		break;
 	}
 	goto writeback;
 
@@ -1382,6 +1381,16 @@ twobyte_insn:
 		/* Odd cmov opcodes (lsb == 1) have inverted sense. */
 		no_wb ^= b & 1;
 		break;
+	case 0xa3:
+	      bt:		/* bt */
+		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
+		emulate_2op_SrcV_nobyte("bt", src, dst, _eflags);
+		break;
+	case 0xab:
+	      bts:		/* bts */
+		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
+		emulate_2op_SrcV_nobyte("bts", src, dst, _eflags);
+		break;
 	case 0xb0 ... 0xb1:	/* cmpxchg */
 		/*
 		 * Save real source value, then compare EAX against
@@ -1399,30 +1408,15 @@ twobyte_insn:
 			dst.ptr = (unsigned long *)&_regs[VCPU_REGS_RAX];
 		}
 		break;
-	case 0xa3:
-	      bt:		/* bt */
-		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
-		emulate_2op_SrcV_nobyte("bt", src, dst, _eflags);
-		break;
 	case 0xb3:
 	      btr:		/* btr */
 		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
 		emulate_2op_SrcV_nobyte("btr", src, dst, _eflags);
 		break;
-	case 0xab:
-	      bts:		/* bts */
-		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
-		emulate_2op_SrcV_nobyte("bts", src, dst, _eflags);
-		break;
 	case 0xb6 ... 0xb7:	/* movzx */
 		dst.bytes = op_bytes;
 		dst.val = (d & ByteOp) ? (u8) src.val : (u16) src.val;
 		break;
-	case 0xbb:
-	      btc:		/* btc */
-		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
-		emulate_2op_SrcV_nobyte("btc", src, dst, _eflags);
-		break;
 	case 0xba:		/* Grp8 */
 		switch (modrm_reg & 3) {
 		case 0:
@@ -1435,6 +1429,11 @@ twobyte_insn:
 			goto btc;
 		}
 		break;
+	case 0xbb:
+	      btc:		/* btc */
+		src.val &= (dst.bytes << 3) - 1; /* only subword offset */
+		emulate_2op_SrcV_nobyte("btc", src, dst, _eflags);
+		break;
 	case 0xbe ... 0xbf:	/* movsx */
 		dst.bytes = op_bytes;
 		dst.val = (d & ByteOp) ? (s8) src.val : (s16) src.val;
@@ -1446,14 +1445,14 @@ twobyte_special_insn:
 	/* Disable writeback. */
 	no_wb = 1;
 	switch (b) {
+	case 0x06:
+		emulate_clts(ctxt->vcpu);
+		break;
 	case 0x09:		/* wbinvd */
 		break;
 	case 0x0d:		/* GrpP (prefetch) */
 	case 0x18:		/* Grp16 (prefetch/nop) */
 		break;
-	case 0x06:
-		emulate_clts(ctxt->vcpu);
-		break;
 	case 0x20: /* mov cr, reg */
 		if (modrm_mod != 3)
 			goto cannot_emulate;
-- 
1.5.3

