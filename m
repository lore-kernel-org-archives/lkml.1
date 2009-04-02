Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbZDBR0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbZDBR0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934141AbZDBRYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:24:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764524AbZDBRYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:24:32 -0400
Message-ID: <49D4F4E6.6060401@redhat.com>
Date: Thu, 02 Apr 2009 13:24:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip 3/6 V4] x86: instruction decorder API
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add x86 instruction decoder to arch-specific libraries. This decoder
can decode all x86 instructions into prefix, opcode, modrm, sib,
displacement and immediates. This can also show the length of
instructions.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: kvm@vger.kernel.org
---

 arch/x86/include/asm/insn.h |  130 +++++++++
 arch/x86/lib/Makefile       |    1
 arch/x86/lib/insn.c         |  627 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 758 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/insn.h
 create mode 100644 arch/x86/lib/insn.c


diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
new file mode 100644
index 0000000..488001f
--- /dev/null
+++ b/arch/x86/include/asm/insn.h
@@ -0,0 +1,130 @@
+#ifndef _ASM_X86_INSN_H
+#define _ASM_X86_INSN_H
+/*
+ * x86 instruction analysis
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ */
+
+#include <linux/types.h>
+
+/* legacy instruction prefixes */
+#define X86_PFX_OPNDSZ	0x1	/* 0x66 */
+#define X86_PFX_ADDRSZ	0x2	/* 0x67 */
+#define X86_PFX_CS	0x4	/* 0x2E */
+#define X86_PFX_DS	0x8	/* 0x3E */
+#define X86_PFX_ES	0x10	/* 0x26 */
+#define X86_PFX_FS	0x20	/* 0x64 */
+#define X86_PFX_GS	0x40	/* 0x65 */
+#define X86_PFX_SS	0x80	/* 0x36 */
+#define X86_PFX_LOCK	0x100	/* 0xF0 */
+#define X86_PFX_REPE	0x200	/* 0xF3 */
+#define X86_PFX_REPNE	0x400	/* 0xF2 */
+/* REX prefix */
+#define X86_PFX_REX	0x800	/* 0x4X */
+/* REX prefix dissected */
+#define X86_PFX_REX_BASE 0x1000
+#define X86_PFX_REXB	0x1000	/* 0x41 bit */
+#define X86_PFX_REXX	0x2000	/* 0x42 bit */
+#define X86_PFX_REXR	0x4000	/* 0x44 bit */
+#define X86_PFX_REXW	0x8000	/* 0x48 bit */
+
+struct insn_field {
+	union {
+		s32 value;
+		u8 bytes[4];
+	};
+	bool got;	/* true if we've run insn_get_xxx() for this field */
+	u8 nbytes;
+};
+
+struct insn {
+	struct insn_field prefixes;	/* prefixes.value is a bitmap */
+	struct insn_field opcode;	/*
+					 * opcode.bytes[0]: opcode1
+					 * opcode.bytes[1]: opcode2
+					 * opcode.bytes[2]: opcode3
+					 */
+	struct insn_field modrm;
+	struct insn_field sib;
+	struct insn_field displacement;
+	union {
+		struct insn_field immediate;
+		struct insn_field moffset1;	/* for 64bit MOV */
+		struct insn_field immediate1;	/* for 64bit imm or off16/32 */
+	};
+	union {
+		struct insn_field moffset2;	/* for 64bit MOV */
+		struct insn_field immediate2;	/* for 64bit imm or seg16 */
+	};
+
+	u8 opnd_bytes;
+	u8 addr_bytes;
+	u8 length;
+	bool x86_64;
+
+	const u8 *kaddr;	/* kernel address of insn (copy) to analyze */
+	const u8 *next_byte;
+};
+
+#define OPCODE1(insn) ((insn)->opcode.bytes[0])
+#define OPCODE2(insn) ((insn)->opcode.bytes[1])
+#define OPCODE3(insn) ((insn)->opcode.bytes[2])
+
+#define MODRM_MOD(insn) (((insn)->modrm.value & 0xc0) >> 6)
+#define MODRM_REG(insn) (((insn)->modrm.value & 0x38) >> 3)
+#define MODRM_RM(insn) ((insn)->modrm.value & 0x07)
+
+#define SIB_SCALE(insn) (((insn)->sib.value & 0xc0) >> 6)
+#define SIB_INDEX(insn) (((insn)->sib.value & 0x38) >> 3)
+#define SIB_BASE(insn) ((insn)->sib.value & 0x07)
+
+#define MOFFSET64(insn)	(((u64)((insn)->moffset2.value) << 32) | \
+			  (u32)((insn)->moffset1.value))
+
+#define IMMEDIATE64(insn)	(((u64)((insn)->immediate2.value) << 32) | \
+				  (u32)((insn)->immediate1.value))
+
+extern void insn_init(struct insn *insn, const u8 *kaddr, bool x86_64);
+extern void insn_get_prefixes(struct insn *insn);
+extern void insn_get_opcode(struct insn *insn);
+extern void insn_get_modrm(struct insn *insn);
+extern void insn_get_sib(struct insn *insn);
+extern void insn_get_displacement(struct insn *insn);
+extern void insn_get_immediate(struct insn *insn);
+extern void insn_get_length(struct insn *insn);
+
+#ifdef CONFIG_X86_64
+/* Init insn for kernel text */
+#define insn_init_kernel(insn, kaddr) insn_init(insn, kaddr, 1)
+extern bool insn_rip_relative(struct insn *insn);
+
+#else /* CONFIG_X86_32 */
+
+#define insn_init_kernel(insn, kaddr) insn_init(insn, kaddr, 0)
+static inline bool insn_rip_relative(struct insn *insn)
+{
+	return false;
+}
+#endif
+
+static inline bool insn_field_exists(const struct insn_field *field)
+{
+	return (field->nbytes > 0);
+}
+
+#endif /* _ASM_X86_INSN_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 55e11aa..0f81979 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -8,6 +8,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-y += insn.o

 ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
new file mode 100644
index 0000000..f5b13b0
--- /dev/null
+++ b/arch/x86/lib/insn.c
@@ -0,0 +1,627 @@
+/*
+ * x86 instruction analysis
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2002, 2004, 2009
+ */
+
+#include <linux/string.h>
+#include <linux/module.h>
+#include <asm/insn.h>
+
+#undef W
+#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+
+/**
+ * insn_init() - initialize struct insn
+ * @insn:	&struct insn to be initialized
+ * @kaddr:	address (in kernel memory) of instruction (or copy thereof)
+ * @x86_64:	true for 64-bit kernel or 64-bit app
+ */
+void insn_init(struct insn *insn, const u8 *kaddr, bool x86_64)
+{
+	memset(insn, 0, sizeof(*insn));
+	insn->kaddr = kaddr;
+	insn->next_byte = kaddr;
+	insn->x86_64 = x86_64;
+	insn->opnd_bytes = 4;
+	if (x86_64)
+		insn->addr_bytes = 8;
+	else
+		insn->addr_bytes = 4;
+}
+EXPORT_SYMBOL_GPL(insn_init);
+
+/**
+ * insn_get_prefixes - scan x86 instruction prefix bytes
+ * @insn:	&struct insn containing instruction
+ *
+ * Populates the @insn->prefixes bitmap, and updates @insn->next_byte
+ * to point to the (first) opcode.  No effect if @insn->prefixes.got
+ * is already true.
+ */
+void insn_get_prefixes(struct insn *insn)
+{
+	u32 pfx;
+	struct insn_field *prefixes = &insn->prefixes;
+	if (prefixes->got)
+		return;
+	for (;; insn->next_byte++, prefixes->nbytes++) {
+		u8 b = *(insn->next_byte);
+#ifdef CONFIG_X86_64
+		if ((b & 0xf0) == 0x40 && insn->x86_64) {
+			prefixes->value |= X86_PFX_REX;
+			prefixes->value |= (b & 0x0f) * X86_PFX_REX_BASE;
+			/* REX prefix is always last. */
+			insn->next_byte++;
+			prefixes->nbytes++;
+			break;
+		}
+#endif
+		switch (b) {
+		case 0x26:
+			pfx = X86_PFX_ES;
+			break;
+		case 0x2E:
+			pfx = X86_PFX_CS;
+			break;
+		case 0x36:
+			pfx = X86_PFX_SS;
+			break;
+		case 0x3E:
+			pfx = X86_PFX_DS;
+			break;
+		case 0x64:
+			pfx = X86_PFX_FS;
+			break;
+		case 0x65:
+			pfx = X86_PFX_GS;
+			break;
+		case 0x66:
+			pfx = X86_PFX_OPNDSZ;
+			break;
+		case 0x67:
+			pfx = X86_PFX_ADDRSZ;
+			break;
+		case 0xF0:
+			pfx = X86_PFX_LOCK;
+			break;
+		case 0xF2:
+			pfx = X86_PFX_REPNE;
+			break;
+		case 0xF3:
+			pfx = X86_PFX_REPE;
+			break;
+		default:
+			pfx = 0x0;
+			break;
+		}
+		if (!pfx)
+			break;
+		prefixes->value |= pfx;
+	}
+	if (prefixes->value & X86_PFX_OPNDSZ) {
+		/* oprand size switches 2/4 */
+		insn->opnd_bytes ^= 6;
+	}
+	if (prefixes->value & X86_PFX_ADDRSZ) {
+		/* address size switches 2/4 or 4/8 */
+#ifdef CONFIG_X86_64
+		if (insn->x86_64)
+			insn->addr_bytes ^= 12;
+		else
+#endif
+			insn->addr_bytes ^= 6;
+	}
+#ifdef CONFIG_X86_64
+	if (prefixes->value & X86_PFX_REXW)
+		insn->opnd_bytes = 8;
+#endif
+	prefixes->got = true;
+}
+EXPORT_SYMBOL_GPL(insn_get_prefixes);
+
+/**
+ * insn_get_opcode - collect opcode(s)
+ * @insn:	&struct insn containing instruction
+ *
+ * Populates @insn->opcode1 (and @insn->opcode2, if it's a 2-byte opcode)
+ * and updates @insn->next_byte to point past the opcode byte(s).
+ * If necessary, first collects any preceding (prefix) bytes.
+ * Sets @insn->opcode.value = opcode1.  No effect if @insn->opcode.got
+ * is already true.
+ */
+void insn_get_opcode(struct insn *insn)
+{
+	struct insn_field *opcode = &insn->opcode;
+	if (opcode->got)
+		return;
+	if (!insn->prefixes.got)
+		insn_get_prefixes(insn);
+	OPCODE1(insn) = *insn->next_byte++;
+	if (OPCODE1(insn) == 0x0f) {
+		OPCODE2(insn) = *insn->next_byte++;
+		if (OPCODE2(insn) == 0x38 || OPCODE2(insn) == 0x3a) {
+			OPCODE3(insn) = *insn->next_byte++;
+			opcode->nbytes = 3;
+		} else
+			opcode->nbytes = 2;
+	} else
+		opcode->nbytes = 1;
+	opcode->got = true;
+}
+EXPORT_SYMBOL_GPL(insn_get_opcode);
+
+const u32 onebyte_has_modrm[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 0f */
+	W(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 1f */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 2f */
+	W(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 3f */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 4f */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 5f */
+	W(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) | /* 6f */
+	W(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 7f */
+	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 8f */
+	W(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 9f */
+	W(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* af */
+	W(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* bf */
+	W(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* cf */
+	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) , /* df */
+	W(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* ef */
+	W(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1)   /* ff */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+
+const u32 twobyte_has_modrm[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) | /* 0f */
+	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 1f */
+	W(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 2f */
+	W(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 3f */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 4f */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 5f */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 6f */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) , /* 7f */
+	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 8f */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 9f */
+	W(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) | /* af */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) , /* bf */
+	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* cf */
+	W(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* df */
+	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* ef */
+	W(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* ff */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+
+#ifdef CONFIG_X86_64
+const u32 onebyte_force_64[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 0f */
+	W(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 1f */
+	W(0x20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 2f */
+	W(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 3f */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 4f */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 5f */
+	W(0x60, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0) | /* 6f */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 7f */
+	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1) | /* 8f */
+	W(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 9f */
+	W(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* af */
+	W(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* bf */
+	W(0xc0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0) | /* cf */
+	W(0xd0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* df */
+	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0) | /* ef */
+	W(0xf0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)   /* ff */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+
+/* force 64 or default 64 bits operand opcodes */
+static bool __operand_64(struct insn *insn)
+{
+	u8 reg = MODRM_REG(insn);
+	if (insn->opcode.nbytes == 1) {
+		if (test_bit(OPCODE1(insn),
+			     (const unsigned long *) onebyte_force_64) ||
+		    (OPCODE1(insn) == 0xff &&
+		     (reg == 2 || reg == 4 || reg == 6)))
+			return true;
+	}
+	return false;
+}
+#endif
+
+/**
+ * insn_get_modrm - collect ModRM byte, if any
+ * @insn:	&struct insn containing instruction
+ *
+ * Populates @insn->modrm and updates @insn->next_byte to point past the
+ * ModRM byte, if any.  If necessary, first collects the preceding bytes
+ * (prefixes and opcode(s)).  No effect if @insn->modrm.got is already true.
+ */
+void insn_get_modrm(struct insn *insn)
+{
+	struct insn_field *modrm = &insn->modrm;
+	if (modrm->got)
+		return;
+	if (!insn->opcode.got)
+		insn_get_opcode(insn);
+	switch (insn->opcode.nbytes) {
+	case 1:
+		modrm->nbytes = test_bit(OPCODE1(insn),
+				(const unsigned long *) onebyte_has_modrm);
+		break;
+	case 2:
+		modrm->nbytes = test_bit(OPCODE2(insn),
+				(const unsigned long *) twobyte_has_modrm);
+		break;
+	case 3:
+		/* Three bytes opcodes always have modrm */
+		modrm->nbytes = 1;
+		break;
+	}
+	if (modrm->nbytes)
+		modrm->value = *(insn->next_byte++);
+
+#ifdef CONFIG_X86_64
+	if (insn->x86_64 && __operand_64(insn))
+		insn->opnd_bytes = 8;
+#endif
+	modrm->got = true;
+}
+EXPORT_SYMBOL_GPL(insn_get_modrm);
+
+#ifdef CONFIG_X86_64
+/**
+ * insn_rip_relative() - Does instruction use RIP-relative addressing mode?
+ * @insn:	&struct insn containing instruction
+ *
+ * If necessary, first collects the instruction up to and including the
+ * ModRM byte.  No effect if @insn->x86_64 is false.
+ */
+bool insn_rip_relative(struct insn *insn)
+{
+	struct insn_field *modrm = &insn->modrm;
+
+	if (!insn->x86_64)
+		return false;
+	if (!modrm->got)
+		insn_get_modrm(insn);
+	/*
+	 * For rip-relative instructions, the mod field (top 2 bits)
+	 * is zero and the r/m field (bottom 3 bits) is 0x5.
+	 */
+	return (insn_field_exists(modrm) && (modrm->value & 0xc7) == 0x5);
+}
+EXPORT_SYMBOL_GPL(insn_rip_relative);
+#endif
+
+/**
+ *
+ * insn_get_sib() - Get the SIB byte of instruction
+ * @insn:	&struct insn containing instruction
+ *
+ * If necessary, first collects the instruction up to and including the
+ * ModRM byte.
+ */
+void insn_get_sib(struct insn *insn)
+{
+	if (insn->sib.got)
+		return;
+	if (!insn->modrm.got)
+		insn_get_modrm(insn);
+	if (insn->modrm.nbytes)
+		if (insn->addr_bytes != 2 &&
+		    MODRM_MOD(insn) != 3 && MODRM_RM(insn) == 4) {
+			insn->sib.value = *(insn->next_byte++);
+			insn->sib.nbytes = 1;
+		}
+	insn->sib.got = true;
+}
+EXPORT_SYMBOL_GPL(insn_get_sib);
+
+#define get_next(t, insn)			\
+	({t r; r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
+
+/**
+ *
+ * insn_get_displacement() - Get the displacement of instruction
+ * @insn:	&struct insn containing instruction
+ *
+ * If necessary, first collects the instruction up to and including the
+ * SIB byte.
+ * Displacement value is sign-expanded.
+ */
+void insn_get_displacement(struct insn *insn)
+{
+	u8 mod;
+	if (insn->displacement.got)
+		return;
+	if (!insn->sib.got)
+		insn_get_sib(insn);
+	if (insn->modrm.nbytes) {
+		/*
+		 * Interpreting the modrm byte:
+		 * mod = 00 - no displacement fields (exceptions below)
+		 * mod = 01 - 1-byte displacement field
+		 * mod = 10 - displacement field is 4 bytes, or 2 bytes if
+		 * 	address size = 2 (0x67 prefix in 32-bit mode)
+		 * mod = 11 - no memory operand
+		 *
+		 * If address size = 2...
+		 * mod = 00, r/m = 110 - displacement field is 2 bytes
+		 *
+		 * If address size != 2...
+		 * mod != 11, r/m = 100 - SIB byte exists
+		 * mod = 00, SIB base = 101 - displacement field is 4 bytes
+		 * mod = 00, r/m = 101 - rip-relative addressing, displacement
+		 * 	field is 4 bytes
+		 */
+		mod = MODRM_MOD(insn);
+		if (mod == 3)
+			goto out;
+		if (mod == 1) {
+			insn->displacement.value = *((s8 *)insn->next_byte++);
+			insn->displacement.nbytes = 1;
+		} else if (insn->addr_bytes == 2) {
+			if ((mod == 0 && MODRM_RM(insn) == 6) || mod == 2) {
+				insn->displacement.value = get_next(s16, insn);
+				insn->displacement.nbytes = 2;
+			}
+		} else {
+			if ((mod == 0 && MODRM_RM(insn) == 5) || mod == 2 ||
+			    (mod == 0 && SIB_BASE(insn) == 5)) {
+				insn->displacement.value = get_next(s32, insn);
+				insn->displacement.nbytes = 4;
+			}
+		}
+	}
+out:
+	insn->displacement.got = true;
+}
+EXPORT_SYMBOL_GPL(insn_get_displacement);
+
+const u32 onebyte_has_immb[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0) | /* 0f */
+	W(0x10, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0) , /* 1f */
+	W(0x20, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0) | /* 2f */
+	W(0x30, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0) , /* 3f */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 4f */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 5f */
+	W(0x60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0) | /* 6f */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 7f */
+	W(0x80, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 8f */
+	W(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 9f */
+	W(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0) | /* af */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) , /* bf */
+	W(0xc0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0) | /* cf */
+	W(0xd0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* df */
+	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0) | /* ef */
+	W(0xf0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)   /* ff */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+
+const u32 onebyte_has_imm[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0) | /* 0f */
+	W(0x10, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0) , /* 1f */
+	W(0x20, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0) | /* 2f */
+	W(0x30, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0) , /* 3f */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 4f */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 5f */
+	W(0x60, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 6f */
+	W(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 7f */
+	W(0x80, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 8f */
+	W(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 9f */
+	W(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0) | /* af */
+	W(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* bf */
+	W(0xc0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* cf */
+	W(0xd0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* df */
+	W(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* ef */
+	W(0xf0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)   /* ff */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+
+/* Decode moffset16/32/64 */
+static void __get_moffset(struct insn *insn)
+{
+	switch (insn->addr_bytes) {
+	case 2:
+		insn->moffset1.value = get_next(s16, insn);
+		insn->moffset1.nbytes = 2;
+		break;
+	case 4:
+		insn->moffset1.value = get_next(s32, insn);
+		insn->moffset1.nbytes = 4;
+		break;
+	case 8:
+		insn->moffset1.value = get_next(s32, insn);
+		insn->moffset1.nbytes = 4;
+		insn->moffset2.value = get_next(s32, insn);
+		insn->moffset2.nbytes = 4;
+		break;
+	}
+	insn->moffset1.got = insn->moffset2.got = true;
+}
+
+/* Decode imm(Iz) */
+static void __get_imm(struct insn *insn)
+{
+	switch (insn->opnd_bytes) {
+	case 2:
+		insn->immediate.value = get_next(s16, insn);
+		insn->immediate.nbytes = 2;
+		break;
+	case 4:
+	case 8:
+		insn->immediate.value = get_next(s32, insn);
+		insn->immediate.nbytes = 4;
+		break;
+	}
+}
+
+/* Decode imm64(Iv) */
+static void __get_imm64(struct insn *insn)
+{
+	switch (insn->opnd_bytes) {
+	case 2:
+		insn->immediate1.value = get_next(s16, insn);
+		insn->immediate1.nbytes = 2;
+		break;
+	case 4:
+		insn->immediate1.value = get_next(s32, insn);
+		insn->immediate1.nbytes = 4;
+		break;
+	case 8:
+		insn->immediate1.value = get_next(s32, insn);
+		insn->immediate1.nbytes = 4;
+		insn->immediate2.value = get_next(s32, insn);
+		insn->immediate2.nbytes = 4;
+		break;
+	}
+	insn->immediate1.got = insn->immediate2.got = true;
+}
+
+/* Decode ptr16:16/32(AP) */
+static void __get_immptr(struct insn *insn)
+{
+	switch (insn->opnd_bytes) {
+	case 2:
+		insn->immediate1.value = get_next(s16, insn);
+		insn->immediate1.nbytes = 2;
+		break;
+	case 4:
+		insn->immediate1.value = get_next(s32, insn);
+		insn->immediate1.nbytes = 4;
+		break;
+	case 8:
+		/* ptr16:64 is not supported (no segment) */
+		WARN_ON(1);
+		return;
+	}
+	insn->immediate2.value = get_next(u16, insn);
+	insn->immediate2.nbytes = 2;
+	insn->immediate1.got = insn->immediate2.got = true;
+}
+
+/**
+ *
+ * insn_get_immediate() - Get the immediates of instruction
+ * @insn:	&struct insn containing instruction
+ *
+ * If necessary, first collects the instruction up to and including the
+ * displacement bytes.
+ * Basically, most of immediates are sign-expanded. Unsigned-value can be
+ * get by bit masking with ((1 << (nbytes * 8)) - 1)
+ */
+void insn_get_immediate(struct insn *insn)
+{
+	u8 opcode;
+	if (insn->immediate.got)
+		return;
+	if (!insn->displacement.got)
+		insn_get_displacement(insn);
+	if (insn->opcode.nbytes == 1) {
+		opcode = OPCODE1(insn);
+		if (opcode >= 0xa0 && opcode <= 0xa3) { /* direct moffset mov */
+			__get_moffset(insn);
+		} else if (test_bit(opcode,
+				    (const unsigned long *)onebyte_has_immb) ||
+			   (opcode == 0xf6 && MODRM_REG(insn) == 0)) {
+			insn->immediate.value = get_next(s8, insn);
+			insn->immediate.nbytes = 1;
+		} else if (test_bit(opcode,
+				    (const unsigned long *)onebyte_has_imm) ||
+			   (opcode == 0xf7 && MODRM_REG(insn) == 0)) {
+			__get_imm(insn);
+		} else if (0xb8 <= opcode && opcode <= 0xbf /* mov immv */) {
+			__get_imm64(insn);
+		} else if (opcode == 0xea /* jmp far seg:offs */) {
+			__get_immptr(insn);
+		} else if (opcode == 0xc2 /* retn immw */ ||
+			   opcode == 0xca /* retf immw */) {
+			insn->immediate.value = get_next(u16, insn);
+			insn->immediate.nbytes = 2;
+		} else if (opcode == 0xc8 /* enter immw, immb */) {
+			insn->immediate1.value = get_next(u16, insn);
+			insn->immediate1.nbytes = 2;
+			insn->immediate2.value = get_next(u8, insn);
+			insn->immediate2.nbytes = 1;
+		}
+	} else if (insn->opcode.nbytes == 2) {
+		opcode = OPCODE2(insn);
+		if ((opcode & 0xf0) == 0x80 /* Jcc imm32 */) {
+			__get_imm(insn);
+		} else
+			switch (opcode) {
+			case 0x70: /* pshuf* %1, %2, immb */
+			case 0x71: /* Group12 %1, immb */
+			case 0x72: /* Group13 %1, immb */
+			case 0x73: /* Group14 %1, immb */
+			case 0xa4: /* shld %1, %2, immb */
+			case 0xac: /* shrd %1, %2, immb */
+			case 0xba: /* Group8 %1, immb */
+			case 0xc2: /* cmpps %1, %2, immb */
+			case 0xc4: /* pinsw %1, %2, immb */
+			case 0xc5: /* pextrw %1, %2, immb */
+			case 0xc6: /* shufps/d %1, %2, immb */
+				insn->immediate.value = get_next(u8, insn);
+				insn->immediate.nbytes = 1;
+			default:
+				break;
+			}
+	} else if (OPCODE3(insn) == 0x0f /* pailgnr %1, %2, immb */) {
+		insn->immediate.value = get_next(u8, insn);
+		insn->immediate.nbytes = 1;
+	}
+	insn->immediate.got = true;
+}
+EXPORT_SYMBOL_GPL(insn_get_immediate);
+
+/**
+ *
+ * insn_get_length() - Get the length of instruction
+ * @insn:	&struct insn containing instruction
+ *
+ * If necessary, first collects the instruction up to and including the
+ * immediates bytes.
+ */
+void insn_get_length(struct insn *insn)
+{
+	if (insn->length)
+		return;
+	if (!insn->immediate.got)
+		insn_get_immediate(insn);
+	insn->length = (u8)((unsigned long)insn->next_byte
+			    - (unsigned long)insn->kaddr);
+}
+EXPORT_SYMBOL_GPL(insn_get_length);
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

