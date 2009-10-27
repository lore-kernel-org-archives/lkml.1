Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbZJ0UnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbZJ0UnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbZJ0UnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbZJ0Um7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:42:59 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 02/10] x86: Merge INAT_REXPFX into INAT_PFX_*
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 27 Oct 2009 16:42:11 -0400
Message-ID: <20091027204211.30545.58090.stgit@harusame>
In-Reply-To: <20091027204156.30545.96425.stgit@harusame>
References: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge INAT_REXPFX into INAT_PFX_* macro and rename it to INAT_PFX_REX.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/x86/include/asm/inat.h          |   36 +++++++++++++++++++---------------
 arch/x86/lib/insn.c                  |    2 +-
 arch/x86/tools/gen-insn-attr-x86.awk |    6 +++---
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 2866fdd..c2487d2 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -30,10 +30,11 @@
 #define INAT_OPCODE_TABLE_SIZE 256
 #define INAT_GROUP_TABLE_SIZE 8
 
-/* Legacy instruction prefixes */
+/* Legacy last prefixes */
 #define INAT_PFX_OPNDSZ	1	/* 0x66 */ /* LPFX1 */
 #define INAT_PFX_REPNE	2	/* 0xF2 */ /* LPFX2 */
 #define INAT_PFX_REPE	3	/* 0xF3 */ /* LPFX3 */
+/* Other Legacy prefixes */
 #define INAT_PFX_LOCK	4	/* 0xF0 */
 #define INAT_PFX_CS	5	/* 0x2E */
 #define INAT_PFX_DS	6	/* 0x3E */
@@ -42,8 +43,11 @@
 #define INAT_PFX_GS	9	/* 0x65 */
 #define INAT_PFX_SS	10	/* 0x36 */
 #define INAT_PFX_ADDRSZ	11	/* 0x67 */
+/* x86-64 REX prefix */
+#define INAT_PFX_REX	12	/* 0x4X */
 
-#define INAT_LPREFIX_MAX	3
+#define INAT_LSTPFX_MAX	3
+#define INAT_LGCPFX_MAX	11
 
 /* Immediate size */
 #define INAT_IMM_BYTE		1
@@ -75,12 +79,11 @@
 #define INAT_IMM_MASK	(((1 << INAT_IMM_BITS) - 1) << INAT_IMM_OFFS)
 /* Flags */
 #define INAT_FLAG_OFFS	(INAT_IMM_OFFS + INAT_IMM_BITS)
-#define INAT_REXPFX	(1 << INAT_FLAG_OFFS)
-#define INAT_MODRM	(1 << (INAT_FLAG_OFFS + 1))
-#define INAT_FORCE64	(1 << (INAT_FLAG_OFFS + 2))
-#define INAT_SCNDIMM	(1 << (INAT_FLAG_OFFS + 3))
-#define INAT_MOFFSET	(1 << (INAT_FLAG_OFFS + 4))
-#define INAT_VARIANT	(1 << (INAT_FLAG_OFFS + 5))
+#define INAT_MODRM	(1 << (INAT_FLAG_OFFS))
+#define INAT_FORCE64	(1 << (INAT_FLAG_OFFS + 1))
+#define INAT_SCNDIMM	(1 << (INAT_FLAG_OFFS + 2))
+#define INAT_MOFFSET	(1 << (INAT_FLAG_OFFS + 3))
+#define INAT_VARIANT	(1 << (INAT_FLAG_OFFS + 4))
 /* Attribute making macros for attribute tables */
 #define INAT_MAKE_PREFIX(pfx)	(pfx << INAT_PFX_OFFS)
 #define INAT_MAKE_ESCAPE(esc)	(esc << INAT_ESC_OFFS)
@@ -97,9 +100,10 @@ extern insn_attr_t inat_get_group_attribute(insn_byte_t modrm,
 					    insn_attr_t esc_attr);
 
 /* Attribute checking functions */
-static inline int inat_is_prefix(insn_attr_t attr)
+static inline int inat_is_legacy_prefix(insn_attr_t attr)
 {
-	return attr & INAT_PFX_MASK;
+	attr &= INAT_PFX_MASK;
+	return attr && attr <= INAT_LGCPFX_MAX;
 }
 
 static inline int inat_is_address_size_prefix(insn_attr_t attr)
@@ -112,9 +116,14 @@ static inline int inat_is_operand_size_prefix(insn_attr_t attr)
 	return (attr & INAT_PFX_MASK) == INAT_PFX_OPNDSZ;
 }
 
+static inline int inat_is_rex_prefix(insn_attr_t attr)
+{
+	return (attr & INAT_PFX_MASK) == INAT_PFX_REX;
+}
+
 static inline int inat_last_prefix_id(insn_attr_t attr)
 {
-	if ((attr & INAT_PFX_MASK) > INAT_LPREFIX_MAX)
+	if ((attr & INAT_PFX_MASK) > INAT_LSTPFX_MAX)
 		return 0;
 	else
 		return attr & INAT_PFX_MASK;
@@ -155,11 +164,6 @@ static inline int inat_immediate_size(insn_attr_t attr)
 	return (attr & INAT_IMM_MASK) >> INAT_IMM_OFFS;
 }
 
-static inline int inat_is_rex_prefix(insn_attr_t attr)
-{
-	return attr & INAT_REXPFX;
-}
-
 static inline int inat_has_modrm(insn_attr_t attr)
 {
 	return attr & INAT_MODRM;
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index dfd56a3..9f48317 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -69,7 +69,7 @@ void insn_get_prefixes(struct insn *insn)
 	lb = 0;
 	b = peek_next(insn_byte_t, insn);
 	attr = inat_get_opcode_attribute(b);
-	while (inat_is_prefix(attr)) {
+	while (inat_is_legacy_prefix(attr)) {
 		/* Skip if same prefix */
 		for (i = 0; i < nb; i++)
 			if (prefixes->bytes[i] == b)
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 19ba096..7d54929 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -278,7 +278,7 @@ function convert_operands(opnd,       i,imm,mod)
 
 		# check REX prefix
 		if (match(opcode, rex_expr))
-			flags = add_flags(flags, "INAT_REXPFX")
+			flags = add_flags(flags, "INAT_MAKE_PREFIX(INAT_PFX_REX)")
 
 		# check coprocessor escape : TODO
 		if (match(opcode, fpu_expr))
@@ -316,7 +316,7 @@ END {
 	# print escape opcode map's array
 	print "/* Escape opcode map array */"
 	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \
-	      "[INAT_LPREFIX_MAX + 1] = {"
+	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < geid; i++)
 		for (j = 0; j < max_lprefix; j++)
 			if (etable[i,j])
@@ -325,7 +325,7 @@ END {
 	# print group opcode map's array
 	print "/* Group opcode map array */"
 	print "const insn_attr_t const *inat_group_tables[INAT_GRP_MAX + 1]"\
-	      "[INAT_LPREFIX_MAX + 1] = {"
+	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < ggid; i++)
 		for (j = 0; j < max_lprefix; j++)
 			if (gtable[i,j])


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
