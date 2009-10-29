Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZJ2IJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZJ2IJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZJ2II7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:08:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:53013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZJ2IIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:08:54 -0400
Date: Thu, 29 Oct 2009 08:07:47 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091027204226.30545.23451.stgit@harusame>
References: <20091027204226.30545.23451.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: AVX instruction set decoder support
Message-ID: <tip-e0e492e99b372c6990a5daca9e4683c341f1330e@git.kernel.org>
Git-Commit-ID: e0e492e99b372c6990a5daca9e4683c341f1330e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0e492e99b372c6990a5daca9e4683c341f1330e
Gitweb:     http://git.kernel.org/tip/e0e492e99b372c6990a5daca9e4683c341f1330e
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:42:27 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:46 +0100

x86: AVX instruction set decoder support

Add Intel AVX(Advanced Vector Extensions) instruction set
support to x86 instruction decoder. This adds insn.vex_prefix
field for storing VEX prefixes, and introduces some original
tags for expressing opcodes attributes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091027204226.30545.23451.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/inat.h          |   32 +++-
 arch/x86/include/asm/insn.h          |   43 ++++-
 arch/x86/lib/inat.c                  |   12 +
 arch/x86/lib/insn.c                  |   52 ++++
 arch/x86/lib/x86-opcode-map.txt      |  431 ++++++++++++++++++----------------
 arch/x86/tools/gen-insn-attr-x86.awk |   94 ++++++--
 6 files changed, 431 insertions(+), 233 deletions(-)

diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index c2487d2..205b063 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -32,8 +32,8 @@
 
 /* Legacy last prefixes */
 #define INAT_PFX_OPNDSZ	1	/* 0x66 */ /* LPFX1 */
-#define INAT_PFX_REPNE	2	/* 0xF2 */ /* LPFX2 */
-#define INAT_PFX_REPE	3	/* 0xF3 */ /* LPFX3 */
+#define INAT_PFX_REPE	2	/* 0xF3 */ /* LPFX2 */
+#define INAT_PFX_REPNE	3	/* 0xF2 */ /* LPFX3 */
 /* Other Legacy prefixes */
 #define INAT_PFX_LOCK	4	/* 0xF0 */
 #define INAT_PFX_CS	5	/* 0x2E */
@@ -45,6 +45,9 @@
 #define INAT_PFX_ADDRSZ	11	/* 0x67 */
 /* x86-64 REX prefix */
 #define INAT_PFX_REX	12	/* 0x4X */
+/* AVX VEX prefixes */
+#define INAT_PFX_VEX2	13	/* 2-bytes VEX prefix */
+#define INAT_PFX_VEX3	14	/* 3-bytes VEX prefix */
 
 #define INAT_LSTPFX_MAX	3
 #define INAT_LGCPFX_MAX	11
@@ -84,6 +87,8 @@
 #define INAT_SCNDIMM	(1 << (INAT_FLAG_OFFS + 2))
 #define INAT_MOFFSET	(1 << (INAT_FLAG_OFFS + 3))
 #define INAT_VARIANT	(1 << (INAT_FLAG_OFFS + 4))
+#define INAT_VEXOK	(1 << (INAT_FLAG_OFFS + 5))
+#define INAT_VEXONLY	(1 << (INAT_FLAG_OFFS + 6))
 /* Attribute making macros for attribute tables */
 #define INAT_MAKE_PREFIX(pfx)	(pfx << INAT_PFX_OFFS)
 #define INAT_MAKE_ESCAPE(esc)	(esc << INAT_ESC_OFFS)
@@ -98,6 +103,9 @@ extern insn_attr_t inat_get_escape_attribute(insn_byte_t opcode,
 extern insn_attr_t inat_get_group_attribute(insn_byte_t modrm,
 					    insn_byte_t last_pfx,
 					    insn_attr_t esc_attr);
+extern insn_attr_t inat_get_avx_attribute(insn_byte_t opcode,
+					  insn_byte_t vex_m,
+					  insn_byte_t vex_pp);
 
 /* Attribute checking functions */
 static inline int inat_is_legacy_prefix(insn_attr_t attr)
@@ -129,6 +137,17 @@ static inline int inat_last_prefix_id(insn_attr_t attr)
 		return attr & INAT_PFX_MASK;
 }
 
+static inline int inat_is_vex_prefix(insn_attr_t attr)
+{
+	attr &= INAT_PFX_MASK;
+	return attr == INAT_PFX_VEX2 || attr == INAT_PFX_VEX3;
+}
+
+static inline int inat_is_vex3_prefix(insn_attr_t attr)
+{
+	return (attr & INAT_PFX_MASK) == INAT_PFX_VEX3;
+}
+
 static inline int inat_is_escape(insn_attr_t attr)
 {
 	return attr & INAT_ESC_MASK;
@@ -189,4 +208,13 @@ static inline int inat_has_variant(insn_attr_t attr)
 	return attr & INAT_VARIANT;
 }
 
+static inline int inat_accept_vex(insn_attr_t attr)
+{
+	return attr & INAT_VEXOK;
+}
+
+static inline int inat_must_vex(insn_attr_t attr)
+{
+	return attr & INAT_VEXONLY;
+}
 #endif
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 12b4e37..96c2e0a 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -39,6 +39,7 @@ struct insn {
 					 * prefixes.bytes[3]: last prefix
 					 */
 	struct insn_field rex_prefix;	/* REX prefix */
+	struct insn_field vex_prefix;	/* VEX prefix */
 	struct insn_field opcode;	/*
 					 * opcode.bytes[0]: opcode1
 					 * opcode.bytes[1]: opcode2
@@ -80,6 +81,19 @@ struct insn {
 #define X86_REX_X(rex) ((rex) & 2)
 #define X86_REX_B(rex) ((rex) & 1)
 
+/* VEX bit flags  */
+#define X86_VEX_W(vex)	((vex) & 0x80)	/* VEX3 Byte2 */
+#define X86_VEX_R(vex)	((vex) & 0x80)	/* VEX2/3 Byte1 */
+#define X86_VEX_X(vex)	((vex) & 0x40)	/* VEX3 Byte1 */
+#define X86_VEX_B(vex)	((vex) & 0x20)	/* VEX3 Byte1 */
+#define X86_VEX_L(vex)	((vex) & 0x04)	/* VEX3 Byte2, VEX2 Byte1 */
+/* VEX bit fields */
+#define X86_VEX3_M(vex)	((vex) & 0x1f)		/* VEX3 Byte1 */
+#define X86_VEX2_M	1			/* VEX2.M always 1 */
+#define X86_VEX_V(vex)	(((vex) & 0x78) >> 3)	/* VEX3 Byte2, VEX2 Byte1 */
+#define X86_VEX_P(vex)	((vex) & 0x03)		/* VEX3 Byte2, VEX2 Byte1 */
+#define X86_VEX_M_MAX	0x1f			/* VEX3.M Maximum value */
+
 /* The last prefix is needed for two-byte and three-byte opcodes */
 static inline insn_byte_t insn_last_prefix(struct insn *insn)
 {
@@ -114,15 +128,42 @@ static inline void kernel_insn_init(struct insn *insn, const void *kaddr)
 #endif
 }
 
+static inline int insn_is_avx(struct insn *insn)
+{
+	if (!insn->prefixes.got)
+		insn_get_prefixes(insn);
+	return (insn->vex_prefix.value != 0);
+}
+
+static inline insn_byte_t insn_vex_m_bits(struct insn *insn)
+{
+	if (insn->vex_prefix.nbytes == 2)	/* 2 bytes VEX */
+		return X86_VEX2_M;
+	else
+		return X86_VEX3_M(insn->vex_prefix.bytes[1]);
+}
+
+static inline insn_byte_t insn_vex_p_bits(struct insn *insn)
+{
+	if (insn->vex_prefix.nbytes == 2)	/* 2 bytes VEX */
+		return X86_VEX_P(insn->vex_prefix.bytes[1]);
+	else
+		return X86_VEX_P(insn->vex_prefix.bytes[2]);
+}
+
 /* Offset of each field from kaddr */
 static inline int insn_offset_rex_prefix(struct insn *insn)
 {
 	return insn->prefixes.nbytes;
 }
-static inline int insn_offset_opcode(struct insn *insn)
+static inline int insn_offset_vex_prefix(struct insn *insn)
 {
 	return insn_offset_rex_prefix(insn) + insn->rex_prefix.nbytes;
 }
+static inline int insn_offset_opcode(struct insn *insn)
+{
+	return insn_offset_vex_prefix(insn) + insn->vex_prefix.nbytes;
+}
 static inline int insn_offset_modrm(struct insn *insn)
 {
 	return insn_offset_opcode(insn) + insn->opcode.nbytes;
diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
index 3fb5998..46fc4ee 100644
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -76,3 +76,15 @@ insn_attr_t inat_get_group_attribute(insn_byte_t modrm, insn_byte_t last_pfx,
 	       inat_group_common_attribute(grp_attr);
 }
 
+insn_attr_t inat_get_avx_attribute(insn_byte_t opcode, insn_byte_t vex_m,
+				   insn_byte_t vex_p)
+{
+	const insn_attr_t *table;
+	if (vex_m > X86_VEX_M_MAX || vex_p > INAT_LSTPFX_MAX)
+		return 0;
+	table = inat_avx_tables[vex_m][vex_p];
+	if (!table)
+		return 0;
+	return table[opcode];
+}
+
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 9f48317..9f33b98 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -28,6 +28,9 @@
 #define peek_next(t, insn)	\
 	({t r; r = *(t*)insn->next_byte; r; })
 
+#define peek_nbyte_next(t, insn, n)	\
+	({t r; r = *(t*)((insn)->next_byte + n); r; })
+
 /**
  * insn_init() - initialize struct insn
  * @insn:	&struct insn to be initialized
@@ -107,6 +110,7 @@ found:
 		insn->prefixes.bytes[3] = lb;
 	}
 
+	/* Decode REX prefix */
 	if (insn->x86_64) {
 		b = peek_next(insn_byte_t, insn);
 		attr = inat_get_opcode_attribute(b);
@@ -120,6 +124,39 @@ found:
 		}
 	}
 	insn->rex_prefix.got = 1;
+
+	/* Decode VEX prefix */
+	b = peek_next(insn_byte_t, insn);
+	attr = inat_get_opcode_attribute(b);
+	if (inat_is_vex_prefix(attr)) {
+		insn_byte_t b2 = peek_nbyte_next(insn_byte_t, insn, 1);
+		if (!insn->x86_64) {
+			/*
+			 * In 32-bits mode, if the [7:6] bits (mod bits of
+			 * ModRM) on the second byte are not 11b, it is
+			 * LDS or LES.
+			 */
+			if (X86_MODRM_MOD(b2) != 3)
+				goto vex_end;
+		}
+		insn->vex_prefix.bytes[0] = b;
+		insn->vex_prefix.bytes[1] = b2;
+		if (inat_is_vex3_prefix(attr)) {
+			b2 = peek_nbyte_next(insn_byte_t, insn, 2);
+			insn->vex_prefix.bytes[2] = b2;
+			insn->vex_prefix.nbytes = 3;
+			insn->next_byte += 3;
+			if (insn->x86_64 && X86_VEX_W(b2))
+				/* VEX.W overrides opnd_size */
+				insn->opnd_bytes = 8;
+		} else {
+			insn->vex_prefix.nbytes = 2;
+			insn->next_byte += 2;
+		}
+	}
+vex_end:
+	insn->vex_prefix.got = 1;
+
 	prefixes->got = 1;
 	return;
 }
@@ -147,6 +184,18 @@ void insn_get_opcode(struct insn *insn)
 	op = get_next(insn_byte_t, insn);
 	opcode->bytes[0] = op;
 	opcode->nbytes = 1;
+
+	/* Check if there is VEX prefix or not */
+	if (insn_is_avx(insn)) {
+		insn_byte_t m, p;
+		m = insn_vex_m_bits(insn);
+		p = insn_vex_p_bits(insn);
+		insn->attr = inat_get_avx_attribute(op, m, p);
+		if (!inat_accept_vex(insn->attr))
+			insn->attr = 0;	/* This instruction is bad */
+		goto end;	/* VEX has only 1 byte for opcode */
+	}
+
 	insn->attr = inat_get_opcode_attribute(op);
 	while (inat_is_escape(insn->attr)) {
 		/* Get escaped opcode */
@@ -155,6 +204,9 @@ void insn_get_opcode(struct insn *insn)
 		pfx = insn_last_prefix(insn);
 		insn->attr = inat_get_escape_attribute(op, pfx, insn->attr);
 	}
+	if (inat_must_vex(insn->attr))
+		insn->attr = 0;	/* This instruction is bad */
+end:
 	opcode->got = 1;
 }
 
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 1f41246..9887bfe 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -3,6 +3,7 @@
 #<Opcode maps>
 # Table: table-name
 # Referrer: escaped-name
+# AVXcode: avx-code
 # opcode: mnemonic|GrpXXX [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
 # (or)
 # opcode: escape # escaped-name
@@ -13,9 +14,16 @@
 # reg:  mnemonic [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
 # EndTable
 #
+# AVX Superscripts
+#  (VEX): this opcode can accept VEX prefix.
+#  (oVEX): this opcode requires VEX prefix.
+#  (o128): this opcode only supports 128bit VEX.
+#  (o256): this opcode only supports 256bit VEX.
+#
 
 Table: one byte opcode
 Referrer:
+AVXcode:
 # 0x00 - 0x0f
 00: ADD Eb,Gb
 01: ADD Ev,Gv
@@ -225,8 +233,8 @@ c0: Grp2 Eb,Ib (1A)
 c1: Grp2 Ev,Ib (1A)
 c2: RETN Iw (f64)
 c3: RETN
-c4: LES Gz,Mp (i64)
-c5: LDS Gz,Mp (i64)
+c4: LES Gz,Mp (i64) | 3bytes-VEX (Prefix)
+c5: LDS Gz,Mp (i64) | 2bytes-VEX (Prefix)
 c6: Grp11 Eb,Ib (1A)
 c7: Grp11 Ev,Iz (1A)
 c8: ENTER Iw,Ib
@@ -290,8 +298,9 @@ fe: Grp4 (1A)
 ff: Grp5 (1A)
 EndTable
 
-Table: 2-byte opcode # First Byte is 0x0f
+Table: 2-byte opcode (0x0f)
 Referrer: 2-byte escape
+AVXcode: 1
 # 0x0f 0x00-0x0f
 00: Grp6 (1A)
 01: Grp7 (1A)
@@ -311,14 +320,14 @@ Referrer: 2-byte escape
 # 3DNow! uses the last imm byte as opcode extension.
 0f: 3DNow! Pq,Qq,Ib
 # 0x0f 0x10-0x1f
-10: movups Vps,Wps | movss Vss,Wss (F3) | movupd Vpd,Wpd (66) | movsd Vsd,Wsd (F2)
-11: movups Wps,Vps | movss Wss,Vss (F3) | movupd Wpd,Vpd (66) | movsd Wsd,Vsd (F2)
-12: movlps Vq,Mq | movlpd Vq,Mq (66) | movhlps Vq,Uq | movddup Vq,Wq (F2) | movsldup Vq,Wq (F3)
-13: mpvlps Mq,Vq | movlpd Mq,Vq (66)
-14: unpcklps Vps,Wq | unpcklpd Vpd,Wq (66)
-15: unpckhps Vps,Wq | unpckhpd Vpd,Wq (66)
-16: movhps Vq,Mq | movhpd Vq,Mq (66) | movlsps Vq,Uq | movshdup Vq,Wq (F3)
-17: movhps Mq,Vq | movhpd Mq,Vq (66)
+10: movups Vps,Wps (VEX) | movss Vss,Wss (F3),(VEX),(o128) | movupd Vpd,Wpd (66),(VEX) | movsd Vsd,Wsd (F2),(VEX),(o128)
+11: movups Wps,Vps (VEX) | movss Wss,Vss (F3),(VEX),(o128) | movupd Wpd,Vpd (66),(VEX) | movsd Wsd,Vsd (F2),(VEX),(o128)
+12: movlps Vq,Mq (VEX),(o128) | movlpd Vq,Mq (66),(VEX),(o128) | movhlps Vq,Uq (VEX),(o128) | movddup Vq,Wq (F2),(VEX) | movsldup Vq,Wq (F3),(VEX)
+13: mpvlps Mq,Vq (VEX),(o128) | movlpd Mq,Vq (66),(VEX),(o128)
+14: unpcklps Vps,Wq (VEX) | unpcklpd Vpd,Wq (66),(VEX)
+15: unpckhps Vps,Wq (VEX) | unpckhpd Vpd,Wq (66),(VEX)
+16: movhps Vq,Mq (VEX),(o128) | movhpd Vq,Mq (66),(VEX),(o128) | movlsps Vq,Uq (VEX),(o128) | movshdup Vq,Wq (F3),(VEX)
+17: movhps Mq,Vq (VEX),(o128) | movhpd Mq,Vq (66),(VEX),(o128)
 18: Grp16 (1A)
 19:
 1a:
@@ -336,14 +345,14 @@ Referrer: 2-byte escape
 25:
 26:
 27:
-28: movaps Vps,Wps | movapd Vpd,Wpd (66)
-29: movaps Wps,Vps | movapd Wpd,Vpd (66)
-2a: cvtpi2ps Vps,Qpi | cvtsi2ss Vss,Ed/q (F3) | cvtpi2pd Vpd,Qpi (66) | cvtsi2sd Vsd,Ed/q (F2)
-2b: movntps Mps,Vps | movntpd Mpd,Vpd (66)
-2c: cvttps2pi Ppi,Wps | cvttss2si  Gd/q,Wss (F3) | cvttpd2pi Ppi,Wpd (66) | cvttsd2si Gd/q,Wsd (F2)
-2d: cvtps2pi Ppi,Wps | cvtss2si Gd/q,Wss (F3) | cvtpd2pi Qpi,Wpd (66) | cvtsd2si Gd/q,Wsd (F2)
-2e: ucomiss Vss,Wss | ucomisd  Vsd,Wsd (66)
-2f: comiss Vss,Wss | comisd  Vsd,Wsd (66)
+28: movaps Vps,Wps (VEX) | movapd Vpd,Wpd (66),(VEX)
+29: movaps Wps,Vps (VEX) | movapd Wpd,Vpd (66),(VEX)
+2a: cvtpi2ps Vps,Qpi | cvtsi2ss Vss,Ed/q (F3),(VEX),(o128) | cvtpi2pd Vpd,Qpi (66) | cvtsi2sd Vsd,Ed/q (F2),(VEX),(o128)
+2b: movntps Mps,Vps (VEX) | movntpd Mpd,Vpd (66),(VEX)
+2c: cvttps2pi Ppi,Wps | cvttss2si  Gd/q,Wss (F3),(VEX),(o128) | cvttpd2pi Ppi,Wpd (66) | cvttsd2si Gd/q,Wsd (F2),(VEX),(o128)
+2d: cvtps2pi Ppi,Wps | cvtss2si Gd/q,Wss (F3),(VEX),(o128) | cvtpd2pi Qpi,Wpd (66) | cvtsd2si Gd/q,Wsd (F2),(VEX),(o128)
+2e: ucomiss Vss,Wss (VEX),(o128) | ucomisd  Vsd,Wsd (66),(VEX),(o128)
+2f: comiss Vss,Wss (VEX),(o128) | comisd  Vsd,Wsd (66),(VEX),(o128)
 # 0x0f 0x30-0x3f
 30: WRMSR
 31: RDTSC
@@ -379,56 +388,56 @@ Referrer: 2-byte escape
 4e: CMOVLE/NG Gv,Ev
 4f: CMOVNLE/G Gv,Ev
 # 0x0f 0x50-0x5f
-50: movmskps Gd/q,Ups | movmskpd Gd/q,Upd (66)
-51: sqrtps Vps,Wps | sqrtss Vss,Wss (F3) | sqrtpd Vpd,Wpd (66) | sqrtsd Vsd,Wsd (F2)
-52: rsqrtps Vps,Wps | rsqrtss Vss,Wss (F3)
-53: rcpps Vps,Wps | rcpss Vss,Wss (F3)
-54: andps Vps,Wps | andpd Vpd,Wpd (66)
-55: andnps Vps,Wps | andnpd Vpd,Wpd (66)
-56: orps Vps,Wps | orpd Vpd,Wpd (66)
-57: xorps Vps,Wps | xorpd Vpd,Wpd (66)
-58: addps Vps,Wps | addss Vss,Wss (F3) | addpd Vpd,Wpd (66) | addsd Vsd,Wsd (F2)
-59: mulps Vps,Wps | mulss Vss,Wss (F3) | mulpd Vpd,Wpd (66) | mulsd Vsd,Wsd (F2)
-5a: cvtps2pd Vpd,Wps | cvtss2sd Vsd,Wss (F3) | cvtpd2ps Vps,Wpd (66) | cvtsd2ss Vsd,Wsd (F2)
-5b: cvtdq2ps Vps,Wdq | cvtps2dq Vdq,Wps (66) | cvttps2dq Vdq,Wps (F3)
-5c: subps Vps,Wps | subss Vss,Wss (F3) | subpd Vpd,Wpd (66) | subsd Vsd,Wsd (F2)
-5d: minps Vps,Wps | minss Vss,Wss (F3) | minpd Vpd,Wpd (66) | minsd Vsd,Wsd (F2)
-5e: divps Vps,Wps | divss Vss,Wss (F3) | divpd Vpd,Wpd (66) | divsd Vsd,Wsd (F2)
-5f: maxps Vps,Wps | maxss Vss,Wss (F3) | maxpd Vpd,Wpd (66) | maxsd Vsd,Wsd (F2)
+50: movmskps Gd/q,Ups (VEX) | movmskpd Gd/q,Upd (66),(VEX)
+51: sqrtps Vps,Wps (VEX) | sqrtss Vss,Wss (F3),(VEX),(o128) | sqrtpd Vpd,Wpd (66),(VEX) | sqrtsd Vsd,Wsd (F2),(VEX),(o128)
+52: rsqrtps Vps,Wps (VEX) | rsqrtss Vss,Wss (F3),(VEX),(o128)
+53: rcpps Vps,Wps (VEX) | rcpss Vss,Wss (F3),(VEX),(o128)
+54: andps Vps,Wps (VEX) | andpd Vpd,Wpd (66),(VEX)
+55: andnps Vps,Wps (VEX) | andnpd Vpd,Wpd (66),(VEX)
+56: orps Vps,Wps (VEX) | orpd Vpd,Wpd (66),(VEX)
+57: xorps Vps,Wps (VEX) | xorpd Vpd,Wpd (66),(VEX)
+58: addps Vps,Wps (VEX) | addss Vss,Wss (F3),(VEX),(o128) | addpd Vpd,Wpd (66),(VEX) | addsd Vsd,Wsd (F2),(VEX),(o128)
+59: mulps Vps,Wps (VEX) | mulss Vss,Wss (F3),(VEX),(o128) | mulpd Vpd,Wpd (66),(VEX) | mulsd Vsd,Wsd (F2),(VEX),(o128)
+5a: cvtps2pd Vpd,Wps (VEX) | cvtss2sd Vsd,Wss (F3),(VEX),(o128) | cvtpd2ps Vps,Wpd (66),(VEX) | cvtsd2ss Vsd,Wsd (F2),(VEX),(o128)
+5b: cvtdq2ps Vps,Wdq (VEX) | cvtps2dq Vdq,Wps (66),(VEX) | cvttps2dq Vdq,Wps (F3),(VEX)
+5c: subps Vps,Wps (VEX) | subss Vss,Wss (F3),(VEX),(o128) | subpd Vpd,Wpd (66),(VEX) | subsd Vsd,Wsd (F2),(VEX),(o128)
+5d: minps Vps,Wps (VEX) | minss Vss,Wss (F3),(VEX),(o128) | minpd Vpd,Wpd (66),(VEX) | minsd Vsd,Wsd (F2),(VEX),(o128)
+5e: divps Vps,Wps (VEX) | divss Vss,Wss (F3),(VEX),(o128) | divpd Vpd,Wpd (66),(VEX) | divsd Vsd,Wsd (F2),(VEX),(o128)
+5f: maxps Vps,Wps (VEX) | maxss Vss,Wss (F3),(VEX),(o128) | maxpd Vpd,Wpd (66),(VEX) | maxsd Vsd,Wsd (F2),(VEX),(o128)
 # 0x0f 0x60-0x6f
-60: punpcklbw Pq,Qd | punpcklbw Vdq,Wdq (66)
-61: punpcklwd Pq,Qd | punpcklwd Vdq,Wdq (66)
-62: punpckldq Pq,Qd | punpckldq Vdq,Wdq (66)
-63: packsswb Pq,Qq | packsswb Vdq,Wdq (66)
-64: pcmpgtb Pq,Qq | pcmpgtb Vdq,Wdq (66)
-65: pcmpgtw Pq,Qq | pcmpgtw Vdq,Wdq (66)
-66: pcmpgtd Pq,Qq | pcmpgtd Vdq,Wdq (66)
-67: packuswb Pq,Qq | packuswb Vdq,Wdq (66)
-68: punpckhbw Pq,Qd | punpckhbw Vdq,Wdq (66)
-69: punpckhwd Pq,Qd | punpckhwd Vdq,Wdq (66)
-6a: punpckhdq Pq,Qd | punpckhdq Vdq,Wdq (66)
-6b: packssdw Pq,Qd | packssdw Vdq,Wdq (66)
-6c: punpcklqdq Vdq,Wdq (66)
-6d: punpckhqdq Vdq,Wdq (66)
-6e: movd/q/ Pd,Ed/q | movd/q Vdq,Ed/q (66)
-6f: movq Pq,Qq | movdqa Vdq,Wdq (66) | movdqu Vdq,Wdq (F3)
+60: punpcklbw Pq,Qd | punpcklbw Vdq,Wdq (66),(VEX),(o128)
+61: punpcklwd Pq,Qd | punpcklwd Vdq,Wdq (66),(VEX),(o128)
+62: punpckldq Pq,Qd | punpckldq Vdq,Wdq (66),(VEX),(o128)
+63: packsswb Pq,Qq | packsswb Vdq,Wdq (66),(VEX),(o128)
+64: pcmpgtb Pq,Qq | pcmpgtb Vdq,Wdq (66),(VEX),(o128)
+65: pcmpgtw Pq,Qq | pcmpgtw Vdq,Wdq (66),(VEX),(o128)
+66: pcmpgtd Pq,Qq | pcmpgtd Vdq,Wdq (66),(VEX),(o128)
+67: packuswb Pq,Qq | packuswb Vdq,Wdq (66),(VEX),(o128)
+68: punpckhbw Pq,Qd | punpckhbw Vdq,Wdq (66),(VEX),(o128)
+69: punpckhwd Pq,Qd | punpckhwd Vdq,Wdq (66),(VEX),(o128)
+6a: punpckhdq Pq,Qd | punpckhdq Vdq,Wdq (66),(VEX),(o128)
+6b: packssdw Pq,Qd | packssdw Vdq,Wdq (66),(VEX),(o128)
+6c: punpcklqdq Vdq,Wdq (66),(VEX),(o128)
+6d: punpckhqdq Vdq,Wdq (66),(VEX),(o128)
+6e: movd/q/ Pd,Ed/q | movd/q Vdq,Ed/q (66),(VEX),(o128)
+6f: movq Pq,Qq | movdqa Vdq,Wdq (66),(VEX) | movdqu Vdq,Wdq (F3),(VEX)
 # 0x0f 0x70-0x7f
-70: pshufw Pq,Qq,Ib | pshufd Vdq,Wdq,Ib (66) | pshufhw Vdq,Wdq,Ib (F3) | pshuflw VdqWdq,Ib (F2)
+70: pshufw Pq,Qq,Ib | pshufd Vdq,Wdq,Ib (66),(VEX),(o128) | pshufhw Vdq,Wdq,Ib (F3),(VEX),(o128) | pshuflw VdqWdq,Ib (F2),(VEX),(o128)
 71: Grp12 (1A)
 72: Grp13 (1A)
 73: Grp14 (1A)
-74: pcmpeqb Pq,Qq | pcmpeqb Vdq,Wdq (66)
-75: pcmpeqw Pq,Qq | pcmpeqw Vdq,Wdq (66)
-76: pcmpeqd Pq,Qq | pcmpeqd Vdq,Wdq (66)
-77: emms
+74: pcmpeqb Pq,Qq | pcmpeqb Vdq,Wdq (66),(VEX),(o128)
+75: pcmpeqw Pq,Qq | pcmpeqw Vdq,Wdq (66),(VEX),(o128)
+76: pcmpeqd Pq,Qq | pcmpeqd Vdq,Wdq (66),(VEX),(o128)
+77: emms/vzeroupper/vzeroall (VEX)
 78: VMREAD Ed/q,Gd/q
 79: VMWRITE Gd/q,Ed/q
 7a:
 7b:
-7c: haddps Vps,Wps (F2) | haddpd Vpd,Wpd (66)
-7d: hsubps Vps,Wps (F2) | hsubpd Vpd,Wpd (66)
-7e: movd/q Ed/q,Pd | movd/q Ed/q,Vdq (66) | movq Vq,Wq (F3)
-7f: movq Qq,Pq | movdqa Wdq,Vdq (66) | movdqu Wdq,Vdq (F3)
+7c: haddps Vps,Wps (F2),(VEX) | haddpd Vpd,Wpd (66),(VEX)
+7d: hsubps Vps,Wps (F2),(VEX) | hsubpd Vpd,Wpd (66),(VEX)
+7e: movd/q Ed/q,Pd | movd/q Ed/q,Vdq (66),(VEX),(o128) | movq Vq,Wq (F3),(VEX),(o128)
+7f: movq Qq,Pq | movdqa Wdq,Vdq (66),(VEX) | movdqu Wdq,Vdq (F3),(VEX)
 # 0x0f 0x80-0x8f
 80: JO Jz (f64)
 81: JNO Jz (f64)
@@ -500,11 +509,11 @@ bf: MOVSX Gv,Ew
 # 0x0f 0xc0-0xcf
 c0: XADD Eb,Gb
 c1: XADD Ev,Gv
-c2: cmpps Vps,Wps,Ib | cmpss Vss,Wss,Ib (F3) | cmppd Vpd,Wpd,Ib (66) | cmpsd Vsd,Wsd,Ib (F2)
+c2: cmpps Vps,Wps,Ib (VEX) | cmpss Vss,Wss,Ib (F3),(VEX),(o128) | cmppd Vpd,Wpd,Ib (66),(VEX) | cmpsd Vsd,Wsd,Ib (F2),(VEX)
 c3: movnti Md/q,Gd/q
-c4: pinsrw Pq,Rd/q/Mw,Ib | pinsrw Vdq,Rd/q/Mw,Ib (66)
-c5: pextrw Gd,Nq,Ib | pextrw Gd,Udq,Ib (66)
-c6: shufps Vps,Wps,Ib | shufpd Vpd,Wpd,Ib (66)
+c4: pinsrw Pq,Rd/q/Mw,Ib | pinsrw Vdq,Rd/q/Mw,Ib (66),(VEX),(o128)
+c5: pextrw Gd,Nq,Ib | pextrw Gd,Udq,Ib (66),(VEX),(o128)
+c6: shufps Vps,Wps,Ib (VEX) | shufpd Vpd,Wpd,Ib (66),(VEX)
 c7: Grp9 (1A)
 c8: BSWAP RAX/EAX/R8/R8D
 c9: BSWAP RCX/ECX/R9/R9D
@@ -515,77 +524,78 @@ cd: BSWAP RBP/EBP/R13/R13D
 ce: BSWAP RSI/ESI/R14/R14D
 cf: BSWAP RDI/EDI/R15/R15D
 # 0x0f 0xd0-0xdf
-d0: addsubps Vps,Wps (F2) | addsubpd Vpd,Wpd (66)
-d1: psrlw Pq,Qq | psrlw Vdq,Wdq (66)
-d2: psrld Pq,Qq | psrld Vdq,Wdq (66)
-d3: psrlq Pq,Qq | psrlq Vdq,Wdq (66)
-d4: paddq Pq,Qq | paddq Vdq,Wdq (66)
-d5: pmullw Pq,Qq | pmullw Vdq,Wdq (66)
-d6: movq Wq,Vq (66) | movq2dq Vdq,Nq (F3) | movdq2q Pq,Uq (F2)
-d7: pmovmskb Gd,Nq | pmovmskb Gd,Udq (66)
-d8: psubusb Pq,Qq | psubusb Vdq,Wdq (66)
-d9: psubusw Pq,Qq | psubusw Vdq,Wdq (66)
-da: pminub Pq,Qq | pminub Vdq,Wdq (66)
-db: pand Pq,Qq | pand Vdq,Wdq (66)
-dc: paddusb Pq,Qq | paddusb Vdq,Wdq (66)
-dd: paddusw Pq,Qq | paddusw Vdq,Wdq (66)
-de: pmaxub Pq,Qq | pmaxub Vdq,Wdq (66)
-df: pandn Pq,Qq | pandn Vdq,Wdq (66)
+d0: addsubps Vps,Wps (F2),(VEX) | addsubpd Vpd,Wpd (66),(VEX)
+d1: psrlw Pq,Qq | psrlw Vdq,Wdq (66),(VEX),(o128)
+d2: psrld Pq,Qq | psrld Vdq,Wdq (66),(VEX),(o128)
+d3: psrlq Pq,Qq | psrlq Vdq,Wdq (66),(VEX),(o128)
+d4: paddq Pq,Qq | paddq Vdq,Wdq (66),(VEX),(o128)
+d5: pmullw Pq,Qq | pmullw Vdq,Wdq (66),(VEX),(o128)
+d6: movq Wq,Vq (66),(VEX),(o128) | movq2dq Vdq,Nq (F3) | movdq2q Pq,Uq (F2)
+d7: pmovmskb Gd,Nq | pmovmskb Gd,Udq (66),(VEX),(o128)
+d8: psubusb Pq,Qq | psubusb Vdq,Wdq (66),(VEX),(o128)
+d9: psubusw Pq,Qq | psubusw Vdq,Wdq (66),(VEX),(o128)
+da: pminub Pq,Qq | pminub Vdq,Wdq (66),(VEX),(o128)
+db: pand Pq,Qq | pand Vdq,Wdq (66),(VEX),(o128)
+dc: paddusb Pq,Qq | paddusb Vdq,Wdq (66),(VEX),(o128)
+dd: paddusw Pq,Qq | paddusw Vdq,Wdq (66),(VEX),(o128)
+de: pmaxub Pq,Qq | pmaxub Vdq,Wdq (66),(VEX),(o128)
+df: pandn Pq,Qq | pandn Vdq,Wdq (66),(VEX),(o128)
 # 0x0f 0xe0-0xef
-e0: pavgb Pq,Qq | pavgb Vdq,Wdq (66)
-e1: psraw Pq,Qq | psraw Vdq,Wdq (66)
-e2: psrad Pq,Qq | psrad Vdq,Wdq (66)
-e3: pavgw Pq,Qq | pavgw Vdq,Wdq (66)
-e4: pmulhuw Pq,Qq | pmulhuw Vdq,Wdq (66)
-e5: pmulhw Pq,Qq | pmulhw Vdq,Wdq (66)
-e6: cvtpd2dq Vdq,Wpd (F2) | cvttpd2dq Vdq,Wpd (66) | cvtdq2pd Vpd,Wdq (F3)
-e7: movntq Mq,Pq | movntdq Mdq,Vdq (66)
-e8: psubsb Pq,Qq | psubsb Vdq,Wdq (66)
-e9: psubsw Pq,Qq | psubsw Vdq,Wdq (66)
-ea: pminsw Pq,Qq | pminsw Vdq,Wdq (66)
-eb: por Pq,Qq | por Vdq,Wdq (66)
-ec: paddsb Pq,Qq | paddsb Vdq,Wdq (66)
-ed: paddsw Pq,Qq | paddsw Vdq,Wdq (66)
-ee: pmaxsw Pq,Qq | pmaxsw Vdq,Wdq (66)
-ef: pxor Pq,Qq | pxor Vdq,Wdq (66)
+e0: pavgb Pq,Qq | pavgb Vdq,Wdq (66),(VEX),(o128)
+e1: psraw Pq,Qq | psraw Vdq,Wdq (66),(VEX),(o128)
+e2: psrad Pq,Qq | psrad Vdq,Wdq (66),(VEX),(o128)
+e3: pavgw Pq,Qq | pavgw Vdq,Wdq (66),(VEX),(o128)
+e4: pmulhuw Pq,Qq | pmulhuw Vdq,Wdq (66),(VEX),(o128)
+e5: pmulhw Pq,Qq | pmulhw Vdq,Wdq (66),(VEX),(o128)
+e6: cvtpd2dq Vdq,Wpd (F2),(VEX) | cvttpd2dq Vdq,Wpd (66),(VEX) | cvtdq2pd Vpd,Wdq (F3),(VEX)
+e7: movntq Mq,Pq | movntdq Mdq,Vdq (66),(VEX)
+e8: psubsb Pq,Qq | psubsb Vdq,Wdq (66),(VEX),(o128)
+e9: psubsw Pq,Qq | psubsw Vdq,Wdq (66),(VEX),(o128)
+ea: pminsw Pq,Qq | pminsw Vdq,Wdq (66),(VEX),(o128)
+eb: por Pq,Qq | por Vdq,Wdq (66),(VEX),(o128)
+ec: paddsb Pq,Qq | paddsb Vdq,Wdq (66),(VEX),(o128)
+ed: paddsw Pq,Qq | paddsw Vdq,Wdq (66),(VEX),(o128)
+ee: pmaxsw Pq,Qq | pmaxsw Vdq,Wdq (66),(VEX),(o128)
+ef: pxor Pq,Qq | pxor Vdq,Wdq (66),(VEX),(o128)
 # 0x0f 0xf0-0xff
-f0: lddqu Vdq,Mdq (F2)
-f1: psllw Pq,Qq | psllw Vdq,Wdq (66)
-f2: pslld Pq,Qq | pslld Vdq,Wdq (66)
-f3: psllq Pq,Qq | psllq Vdq,Wdq (66)
-f4: pmuludq Pq,Qq | pmuludq Vdq,Wdq (66)
-f5: pmaddwd Pq,Qq | pmaddwd Vdq,Wdq (66)
-f6: psadbw Pq,Qq | psadbw Vdq,Wdq (66)
-f7: maskmovq Pq,Nq | maskmovdqu Vdq,Udq (66)
-f8: psubb Pq,Qq | psubb Vdq,Wdq (66)
-f9: psubw Pq,Qq | psubw Vdq,Wdq (66)
-fa: psubd Pq,Qq | psubd Vdq,Wdq (66)
-fb: psubq Pq,Qq | psubq Vdq,Wdq (66)
-fc: paddb Pq,Qq | paddb Vdq,Wdq (66)
-fd: paddw Pq,Qq | paddw Vdq,Wdq (66)
-fe: paddd Pq,Qq | paddd Vdq,Wdq (66)
+f0: lddqu Vdq,Mdq (F2),(VEX)
+f1: psllw Pq,Qq | psllw Vdq,Wdq (66),(VEX),(o128)
+f2: pslld Pq,Qq | pslld Vdq,Wdq (66),(VEX),(o128)
+f3: psllq Pq,Qq | psllq Vdq,Wdq (66),(VEX),(o128)
+f4: pmuludq Pq,Qq | pmuludq Vdq,Wdq (66),(VEX),(o128)
+f5: pmaddwd Pq,Qq | pmaddwd Vdq,Wdq (66),(VEX),(o128)
+f6: psadbw Pq,Qq | psadbw Vdq,Wdq (66),(VEX),(o128)
+f7: maskmovq Pq,Nq | maskmovdqu Vdq,Udq (66),(VEX),(o128)
+f8: psubb Pq,Qq | psubb Vdq,Wdq (66),(VEX),(o128)
+f9: psubw Pq,Qq | psubw Vdq,Wdq (66),(VEX),(o128)
+fa: psubd Pq,Qq | psubd Vdq,Wdq (66),(VEX),(o128)
+fb: psubq Pq,Qq | psubq Vdq,Wdq (66),(VEX),(o128)
+fc: paddb Pq,Qq | paddb Vdq,Wdq (66),(VEX),(o128)
+fd: paddw Pq,Qq | paddw Vdq,Wdq (66),(VEX),(o128)
+fe: paddd Pq,Qq | paddd Vdq,Wdq (66),(VEX),(o128)
 ff:
 EndTable
 
 Table: 3-byte opcode 1 (0x0f 0x38)
 Referrer: 3-byte escape 1
+AVXcode: 2
 # 0x0f 0x38 0x00-0x0f
-00: pshufb Pq,Qq | pshufb Vdq,Wdq (66)
-01: phaddw Pq,Qq | phaddw Vdq,Wdq (66)
-02: phaddd Pq,Qq | phaddd Vdq,Wdq (66)
-03: phaddsw Pq,Qq | phaddsw Vdq,Wdq (66)
-04: pmaddubsw Pq,Qq | pmaddubsw Vdq,Wdq (66)
-05: phsubw Pq,Qq | phsubw Vdq,Wdq (66)
-06: phsubd Pq,Qq | phsubd Vdq,Wdq (66)
-07: phsubsw Pq,Qq | phsubsw Vdq,Wdq (66)
-08: psignb Pq,Qq | psignb Vdq,Wdq (66)
-09: psignw Pq,Qq | psignw Vdq,Wdq (66)
-0a: psignd Pq,Qq | psignd Vdq,Wdq (66)
-0b: pmulhrsw Pq,Qq | pmulhrsw Vdq,Wdq (66)
-0c:
-0d:
-0e:
-0f:
+00: pshufb Pq,Qq | pshufb Vdq,Wdq (66),(VEX),(o128)
+01: phaddw Pq,Qq | phaddw Vdq,Wdq (66),(VEX),(o128)
+02: phaddd Pq,Qq | phaddd Vdq,Wdq (66),(VEX),(o128)
+03: phaddsw Pq,Qq | phaddsw Vdq,Wdq (66),(VEX),(o128)
+04: pmaddubsw Pq,Qq | pmaddubsw Vdq,Wdq (66),(VEX),(o128)
+05: phsubw Pq,Qq | phsubw Vdq,Wdq (66),(VEX),(o128)
+06: phsubd Pq,Qq | phsubd Vdq,Wdq (66),(VEX),(o128)
+07: phsubsw Pq,Qq | phsubsw Vdq,Wdq (66),(VEX),(o128)
+08: psignb Pq,Qq | psignb Vdq,Wdq (66),(VEX),(o128)
+09: psignw Pq,Qq | psignw Vdq,Wdq (66),(VEX),(o128)
+0a: psignd Pq,Qq | psignd Vdq,Wdq (66),(VEX),(o128)
+0b: pmulhrsw Pq,Qq | pmulhrsw Vdq,Wdq (66),(VEX),(o128)
+0c: Vpermilps /r (66),(oVEX)
+0d: Vpermilpd /r (66),(oVEX)
+0e: vtestps /r (66),(oVEX)
+0f: vtestpd /r (66),(oVEX)
 # 0x0f 0x38 0x10-0x1f
 10: pblendvb Vdq,Wdq (66)
 11:
@@ -594,90 +604,99 @@ Referrer: 3-byte escape 1
 14: blendvps Vdq,Wdq (66)
 15: blendvpd Vdq,Wdq (66)
 16:
-17: ptest Vdq,Wdq (66)
-18:
-19:
-1a:
+17: ptest Vdq,Wdq (66),(VEX)
+18: vbroadcastss /r (66),(oVEX)
+19: vbroadcastsd /r (66),(oVEX),(o256)
+1a: vbroadcastf128 /r (66),(oVEX),(o256)
 1b:
-1c: pabsb Pq,Qq | pabsb Vdq,Wdq (66)
-1d: pabsw Pq,Qq | pabsw Vdq,Wdq (66)
-1e: pabsd Pq,Qq | pabsd Vdq,Wdq (66)
+1c: pabsb Pq,Qq | pabsb Vdq,Wdq (66),(VEX),(o128)
+1d: pabsw Pq,Qq | pabsw Vdq,Wdq (66),(VEX),(o128)
+1e: pabsd Pq,Qq | pabsd Vdq,Wdq (66),(VEX),(o128)
 1f:
 # 0x0f 0x38 0x20-0x2f
-20: pmovsxbw Vdq,Udq/Mq (66)
-21: pmovsxbd Vdq,Udq/Md (66)
-22: pmovsxbq Vdq,Udq/Mw (66)
-23: pmovsxwd Vdq,Udq/Mq (66)
-24: pmovsxwq Vdq,Udq/Md (66)
-25: pmovsxdq Vdq,Udq/Mq (66)
+20: pmovsxbw Vdq,Udq/Mq (66),(VEX),(o128)
+21: pmovsxbd Vdq,Udq/Md (66),(VEX),(o128)
+22: pmovsxbq Vdq,Udq/Mw (66),(VEX),(o128)
+23: pmovsxwd Vdq,Udq/Mq (66),(VEX),(o128)
+24: pmovsxwq Vdq,Udq/Md (66),(VEX),(o128)
+25: pmovsxdq Vdq,Udq/Mq (66),(VEX),(o128)
 26:
 27:
-28: pmuldq Vdq,Wdq (66)
-29: pcmpeqq Vdq,Wdq (66)
-2a: movntdqa Vdq,Mdq (66)
-2b: packusdw Vdq,Wdq (66)
-2c:
-2d:
-2e:
-2f:
+28: pmuldq Vdq,Wdq (66),(VEX),(o128)
+29: pcmpeqq Vdq,Wdq (66),(VEX),(o128)
+2a: movntdqa Vdq,Mdq (66),(VEX),(o128)
+2b: packusdw Vdq,Wdq (66),(VEX),(o128)
+2c: vmaskmovps(ld) /r (66),(oVEX)
+2d: vmaskmovpd(ld) /r (66),(oVEX)
+2e: vmaskmovps(st) /r (66),(oVEX)
+2f: vmaskmovpd(st) /r (66),(oVEX)
 # 0x0f 0x38 0x30-0x3f
-30: pmovzxbw Vdq,Udq/Mq (66)
-31: pmovzxbd Vdq,Udq/Md (66)
-32: pmovzxbq Vdq,Udq/Mw (66)
-33: pmovzxwd Vdq,Udq/Mq (66)
-34: pmovzxwq Vdq,Udq/Md (66)
-35: pmovzxdq Vdq,Udq/Mq (66)
+30: pmovzxbw Vdq,Udq/Mq (66),(VEX),(o128)
+31: pmovzxbd Vdq,Udq/Md (66),(VEX),(o128)
+32: pmovzxbq Vdq,Udq/Mw (66),(VEX),(o128)
+33: pmovzxwd Vdq,Udq/Mq (66),(VEX),(o128)
+34: pmovzxwq Vdq,Udq/Md (66),(VEX),(o128)
+35: pmovzxdq Vdq,Udq/Mq (66),(VEX),(o128)
 36:
-37: pcmpgtq Vdq,Wdq (66)
-38: pminsb Vdq,Wdq (66)
-39: pminsd Vdq,Wdq (66)
-3a: pminuw Vdq,Wdq (66)
-3b: pminud Vdq,Wdq (66)
-3c: pmaxsb Vdq,Wdq (66)
-3d: pmaxsd Vdq,Wdq (66)
-3e: pmaxuw Vdq,Wdq (66)
-3f: pmaxud Vdq,Wdq (66)
+37: pcmpgtq Vdq,Wdq (66),(VEX),(o128)
+38: pminsb Vdq,Wdq (66),(VEX),(o128)
+39: pminsd Vdq,Wdq (66),(VEX),(o128)
+3a: pminuw Vdq,Wdq (66),(VEX),(o128)
+3b: pminud Vdq,Wdq (66),(VEX),(o128)
+3c: pmaxsb Vdq,Wdq (66),(VEX),(o128)
+3d: pmaxsd Vdq,Wdq (66),(VEX),(o128)
+3e: pmaxuw Vdq,Wdq (66),(VEX),(o128)
+3f: pmaxud Vdq,Wdq (66),(VEX),(o128)
 # 0x0f 0x38 0x4f-0xff
-40: pmulld Vdq,Wdq (66)
-41: phminposuw Vdq,Wdq (66)
+40: pmulld Vdq,Wdq (66),(VEX),(o128)
+41: phminposuw Vdq,Wdq (66),(VEX),(o128)
 80: INVEPT Gd/q,Mdq (66)
 81: INVPID Gd/q,Mdq (66)
-db: aesimc Vdq,Wdq (66)
-dc: aesenc Vdq,Wdq (66)
-dd: aesenclast Vdq,Wdq (66)
-de: aesdec Vdq,Wdq (66)
-df: aesdeclast Vdq,Wdq (66)
+db: aesimc Vdq,Wdq (66),(VEX),(o128)
+dc: aesenc Vdq,Wdq (66),(VEX),(o128)
+dd: aesenclast Vdq,Wdq (66),(VEX),(o128)
+de: aesdec Vdq,Wdq (66),(VEX),(o128)
+df: aesdeclast Vdq,Wdq (66),(VEX),(o128)
 f0: MOVBE Gv,Mv | CRC32 Gd,Eb (F2)
 f1: MOVBE Mv,Gv | CRC32 Gd,Ev (F2)
 EndTable
 
 Table: 3-byte opcode 2 (0x0f 0x3a)
 Referrer: 3-byte escape 2
+AVXcode: 3
 # 0x0f 0x3a 0x00-0xff
-08: roundps Vdq,Wdq,Ib (66)
-09: roundpd Vdq,Wdq,Ib (66)
-0a: roundss Vss,Wss,Ib (66)
-0b: roundsd Vsd,Wsd,Ib (66)
-0c: blendps Vdq,Wdq,Ib (66)
-0d: blendpd Vdq,Wdq,Ib (66)
-0e: pblendw Vdq,Wdq,Ib (66)
-0f: palignr Pq,Qq,Ib | palignr Vdq,Wdq,Ib (66)
-14: pextrb Rd/Mb,Vdq,Ib (66)
-15: pextrw Rd/Mw,Vdq,Ib (66)
-16: pextrd/pextrq Ed/q,Vdq,Ib (66)
-17: extractps Ed,Vdq,Ib (66)
-20: pinsrb Vdq,Rd/q/Mb,Ib (66)
-21: insertps Vdq,Udq/Md,Ib (66)
-22: pinsrd/pinsrq Vdq,Ed/q,Ib (66)
-40: dpps Vdq,Wdq,Ib (66)
-41: dppd Vdq,Wdq,Ib (66)
-42: mpsadbw Vdq,Wdq,Ib (66)
-44: pclmulq Vdq,Wdq,Ib (66)
-60: pcmpestrm Vdq,Wdq,Ib (66)
-61: pcmpestri Vdq,Wdq,Ib (66)
-62: pcmpistrm Vdq,Wdq,Ib (66)
-63: pcmpistri Vdq,Wdq,Ib (66)
-df: aeskeygenassist Vdq,Wdq,Ib (66)
+04: vpermilps /r,Ib (66),(oVEX)
+05: vpermilpd /r,Ib (66),(oVEX)
+06: vperm2f128 /r,Ib (66),(oVEX),(o256)
+08: roundps Vdq,Wdq,Ib (66),(VEX)
+09: roundpd Vdq,Wdq,Ib (66),(VEX)
+0a: roundss Vss,Wss,Ib (66),(VEX),(o128)
+0b: roundsd Vsd,Wsd,Ib (66),(VEX),(o128)
+0c: blendps Vdq,Wdq,Ib (66),(VEX)
+0d: blendpd Vdq,Wdq,Ib (66),(VEX)
+0e: pblendw Vdq,Wdq,Ib (66),(VEX),(o128)
+0f: palignr Pq,Qq,Ib | palignr Vdq,Wdq,Ib (66),(VEX),(o128)
+14: pextrb Rd/Mb,Vdq,Ib (66),(VEX),(o128)
+15: pextrw Rd/Mw,Vdq,Ib (66),(VEX),(o128)
+16: pextrd/pextrq Ed/q,Vdq,Ib (66),(VEX),(o128)
+17: extractps Ed,Vdq,Ib (66),(VEX),(o128)
+18: vinsertf128 /r,Ib (66),(oVEX),(o256)
+19: vextractf128 /r,Ib (66),(oVEX),(o256)
+20: pinsrb Vdq,Rd/q/Mb,Ib (66),(VEX),(o128)
+21: insertps Vdq,Udq/Md,Ib (66),(VEX),(o128)
+22: pinsrd/pinsrq Vdq,Ed/q,Ib (66),(VEX),(o128)
+40: dpps Vdq,Wdq,Ib (66),(VEX)
+41: dppd Vdq,Wdq,Ib (66),(VEX),(o128)
+42: mpsadbw Vdq,Wdq,Ib (66),(VEX),(o128)
+44: pclmulq Vdq,Wdq,Ib (66),(VEX),(o128)
+4a: vblendvps /r,Ib (66),(oVEX)
+4b: vblendvpd /r,Ib (66),(oVEX)
+4c: vpblendvb /r,Ib (66),(oVEX),(o128)
+60: pcmpestrm Vdq,Wdq,Ib (66),(VEX),(o128)
+61: pcmpestri Vdq,Wdq,Ib (66),(VEX),(o128)
+62: pcmpistrm Vdq,Wdq,Ib (66),(VEX),(o128)
+63: pcmpistri Vdq,Wdq,Ib (66),(VEX),(o128)
+df: aeskeygenassist Vdq,Wdq,Ib (66),(VEX),(o128)
 EndTable
 
 GrpTable: Grp1
@@ -785,29 +804,29 @@ GrpTable: Grp11
 EndTable
 
 GrpTable: Grp12
-2: psrlw Nq,Ib (11B) | psrlw Udq,Ib (66),(11B)
-4: psraw Nq,Ib (11B) | psraw Udq,Ib (66),(11B)
-6: psllw Nq,Ib (11B) | psllw Udq,Ib (66),(11B)
+2: psrlw Nq,Ib (11B) | psrlw Udq,Ib (66),(11B),(VEX),(o128)
+4: psraw Nq,Ib (11B) | psraw Udq,Ib (66),(11B),(VEX),(o128)
+6: psllw Nq,Ib (11B) | psllw Udq,Ib (66),(11B),(VEX),(o128)
 EndTable
 
 GrpTable: Grp13
-2: psrld Nq,Ib (11B) | psrld Udq,Ib (66),(11B)
-4: psrad Nq,Ib (11B) | psrad Udq,Ib (66),(11B)
-6: pslld Nq,Ib (11B) | pslld Udq,Ib (66),(11B)
+2: psrld Nq,Ib (11B) | psrld Udq,Ib (66),(11B),(VEX),(o128)
+4: psrad Nq,Ib (11B) | psrad Udq,Ib (66),(11B),(VEX),(o128)
+6: pslld Nq,Ib (11B) | pslld Udq,Ib (66),(11B),(VEX),(o128)
 EndTable
 
 GrpTable: Grp14
-2: psrlq Nq,Ib (11B) | psrlq Udq,Ib (66),(11B)
-3: psrldq Udq,Ib (66),(11B)
-6: psllq Nq,Ib (11B) | psllq Udq,Ib (66),(11B)
-7: pslldq Udq,Ib (66),(11B)
+2: psrlq Nq,Ib (11B) | psrlq Udq,Ib (66),(11B),(VEX),(o128)
+3: psrldq Udq,Ib (66),(11B),(VEX),(o128)
+6: psllq Nq,Ib (11B) | psllq Udq,Ib (66),(11B),(VEX),(o128)
+7: pslldq Udq,Ib (66),(11B),(VEX),(o128)
 EndTable
 
 GrpTable: Grp15
 0: fxsave
 1: fxstor
-2: ldmxcsr
-3: stmxcsr
+2: ldmxcsr (VEX)
+3: stmxcsr (VEX)
 4: XSAVE
 5: XRSTOR | lfence (11B)
 6: mfence (11B)
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 7d54929..e34e92a 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -13,6 +13,18 @@ function check_awk_implement() {
 	return ""
 }
 
+# Clear working vars
+function clear_vars() {
+	delete table
+	delete lptable2
+	delete lptable1
+	delete lptable3
+	eid = -1 # escape id
+	gid = -1 # group id
+	aid = -1 # AVX id
+	tname = ""
+}
+
 BEGIN {
 	# Implementation error checking
 	awkchecked = check_awk_implement()
@@ -24,11 +36,15 @@ BEGIN {
 
 	# Setup generating tables
 	print "/* x86 opcode map generated from x86-opcode-map.txt */"
-	print "/* Do not change this code. */"
+	print "/* Do not change this code. */\n"
 	ggid = 1
 	geid = 1
+	gaid = 0
+	delete etable
+	delete gtable
+	delete atable
 
-	opnd_expr = "^[[:alpha:]]"
+	opnd_expr = "^[[:alpha:]/]"
 	ext_expr = "^\\("
 	sep_expr = "^\\|$"
 	group_expr = "^Grp[[:alnum:]]+"
@@ -46,19 +62,19 @@ BEGIN {
 	imm_flag["Ob"] = "INAT_MOFFSET"
 	imm_flag["Ov"] = "INAT_MOFFSET"
 
-	modrm_expr = "^([CDEGMNPQRSUVW][[:lower:]]+|NTA|T[012])"
+	modrm_expr = "^([CDEGMNPQRSUVW/][[:lower:]]+|NTA|T[012])"
 	force64_expr = "\\([df]64\\)"
 	rex_expr = "^REX(\\.[XRWB]+)*"
 	fpu_expr = "^ESC" # TODO
 
 	lprefix1_expr = "\\(66\\)"
-	delete lptable1
-	lprefix2_expr = "\\(F2\\)"
-	delete lptable2
-	lprefix3_expr = "\\(F3\\)"
-	delete lptable3
+	lprefix2_expr = "\\(F3\\)"
+	lprefix3_expr = "\\(F2\\)"
 	max_lprefix = 4
 
+	vexok_expr = "\\(VEX\\)"
+	vexonly_expr = "\\(oVEX\\)"
+
 	prefix_expr = "\\(Prefix\\)"
 	prefix_num["Operand-Size"] = "INAT_PFX_OPNDSZ"
 	prefix_num["REPNE"] = "INAT_PFX_REPNE"
@@ -71,12 +87,10 @@ BEGIN {
 	prefix_num["SEG=GS"] = "INAT_PFX_GS"
 	prefix_num["SEG=SS"] = "INAT_PFX_SS"
 	prefix_num["Address-Size"] = "INAT_PFX_ADDRSZ"
+	prefix_num["2bytes-VEX"] = "INAT_PFX_VEX2"
+	prefix_num["3bytes-VEX"] = "INAT_PFX_VEX3"
 
-	delete table
-	delete etable
-	delete gtable
-	eid = -1
-	gid = -1
+	clear_vars()
 }
 
 function semantic_error(msg) {
@@ -97,14 +111,12 @@ function array_size(arr,   i,c) {
 
 /^Table:/ {
 	print "/* " $0 " */"
+	if (tname != "")
+		semantic_error("Hit Table: before EndTable:.");
 }
 
 /^Referrer:/ {
-	if (NF == 1) {
-		# primary opcode table
-		tname = "inat_primary_table"
-		eid = -1
-	} else {
+	if (NF != 1) {
 		# escape opcode table
 		ref = ""
 		for (i = 2; i <= NF; i++)
@@ -114,6 +126,19 @@ function array_size(arr,   i,c) {
 	}
 }
 
+/^AVXcode:/ {
+	if (NF != 1) {
+		# AVX/escape opcode table
+		aid = $2
+		if (gaid <= aid)
+			gaid = aid + 1
+		if (tname == "")	# AVX only opcode table
+			tname = sprintf("inat_avx_table_%d", $2)
+	}
+	if (aid == -1 && eid == -1)	# primary opcode table
+		tname = "inat_primary_table"
+}
+
 /^GrpTable:/ {
 	print "/* " $0 " */"
 	if (!($2 in group))
@@ -162,30 +187,33 @@ function print_table(tbl,name,fmt,n)
 			print_table(table, tname "[INAT_OPCODE_TABLE_SIZE]",
 				    "0x%02x", 256)
 			etable[eid,0] = tname
+			if (aid >= 0)
+				atable[aid,0] = tname
 		}
 		if (array_size(lptable1) != 0) {
 			print_table(lptable1,tname "_1[INAT_OPCODE_TABLE_SIZE]",
 				    "0x%02x", 256)
 			etable[eid,1] = tname "_1"
+			if (aid >= 0)
+				atable[aid,1] = tname "_1"
 		}
 		if (array_size(lptable2) != 0) {
 			print_table(lptable2,tname "_2[INAT_OPCODE_TABLE_SIZE]",
 				    "0x%02x", 256)
 			etable[eid,2] = tname "_2"
+			if (aid >= 0)
+				atable[aid,2] = tname "_2"
 		}
 		if (array_size(lptable3) != 0) {
 			print_table(lptable3,tname "_3[INAT_OPCODE_TABLE_SIZE]",
 				    "0x%02x", 256)
 			etable[eid,3] = tname "_3"
+			if (aid >= 0)
+				atable[aid,3] = tname "_3"
 		}
 	}
 	print ""
-	delete table
-	delete lptable1
-	delete lptable2
-	delete lptable3
-	gid = -1
-	eid = -1
+	clear_vars()
 }
 
 function add_flags(old,new) {
@@ -284,6 +312,14 @@ function convert_operands(opnd,       i,imm,mod)
 		if (match(opcode, fpu_expr))
 			flags = add_flags(flags, "INAT_MODRM")
 
+		# check VEX only code
+		if (match(ext, vexonly_expr))
+			flags = add_flags(flags, "INAT_VEXOK | INAT_VEXONLY")
+
+		# check VEX only code
+		if (match(ext, vexok_expr))
+			flags = add_flags(flags, "INAT_VEXOK")
+
 		# check prefixes
 		if (match(ext, prefix_expr)) {
 			if (!prefix_num[opcode])
@@ -330,5 +366,15 @@ END {
 		for (j = 0; j < max_lprefix; j++)
 			if (gtable[i,j])
 				print "	["i"]["j"] = "gtable[i,j]","
+	print "};\n"
+	# print AVX opcode map's array
+	print "/* AVX opcode map array */"
+	print "const insn_attr_t const *inat_avx_tables[X86_VEX_M_MAX + 1]"\
+	      "[INAT_LSTPFX_MAX + 1] = {"
+	for (i = 0; i < gaid; i++)
+		for (j = 0; j < max_lprefix; j++)
+			if (atable[i,j])
+				print "	["i"]["j"] = "atable[i,j]","
 	print "};"
 }
+
