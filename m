Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbXLNWLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbXLNWLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbXLNWLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:11:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:50946 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbXLNWLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:11:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m5TlARJeopgGxsEnazOa6FWhesspVn4Vb3Cf9gW8qoK+a++KqZxNH2wBmsb37emaZubEnmAHsM0jnSBuSuh4NzukDRd6ojUAme9cV85zbjYHmYYrrck8R4OMpMi95elQlNauGh91HCPTB+iO+iKz+1BYsR52h6gxFp0klPDyiXA=
Subject: [PATCH] x86: Reduce diff between kprobes_{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 14:11:37 -0800
Message-Id: <1197670298.898.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put a copy of instructions tables in both files to reduce the
diff size and drastically cut checkpatch warnings.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |  140 ++++++++++++++++++++++++++++---------
 arch/x86/kernel/kprobes_64.c |  158 ++++++++++++++++++++++++++++--------------
 2 files changed, 214 insertions(+), 84 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 615f24a..3e45b51 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -48,6 +48,113 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
+#define W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)  \
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (r % sizeof(unsigned long)))
+
+#define R1(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#define R3(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#define R4(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
+#define RF(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)
+
+#ifdef CONFIG_X86_32
+#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
+#else
+#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#endif
+
+/*
+ * Undefined/reserved opcodes, conditional jump, Opcode Extension
+ * Groups, and some special opcodes can not be boost.
+ */
+static const unsigned long
+twobyte_is_boostable[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) /* 00 */
+	R2(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 10 */
+	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 20 */
+	R4(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 30 */
+	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 40 */
+	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
+	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) /* 60 */
+	R4(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* 70 */
+	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 80 */
+	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 90 */
+	R3(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* a0 */
+	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* b0 */
+	R1(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* c0 */
+	R2(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* d0 */
+	R3(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* e0 */
+	RF(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0) /* f0 */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+static const unsigned long
+onebyte_has_modrm[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 00 */
+	R2(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 10 */
+	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 20 */
+	R4(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 30 */
+	R1(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 40 */
+	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
+	R3(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) /* 60 */
+	R4(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 70 */
+	R1(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 80 */
+	R2(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 90 */
+	R3(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* a0 */
+	R4(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* b0 */
+	R1(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* c0 */
+	R2(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* d0 */
+	R3(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* e0 */
+	RF(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* f0 */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+static const unsigned long
+twobyte_has_modrm[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) /* 0f */
+	R2(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) /* 1f */
+	R3(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* 2f */
+	R4(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 3f */
+	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 4f */
+	R2(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 5f */
+	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 6f */
+	R4(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) /* 7f */
+	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 8f */
+	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 9f */
+	R3(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* af */
+	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) /* bf */
+	R1(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* cf */
+	R2(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* df */
+	R3(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* ef */
+	RF(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0) /* ff */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+#undef W
+#undef R1
+#undef R2
+#undef R3
+#undef R4
+#undef RF
+
 /* insert a jmp code */
 static __always_inline void set_jmp_op(void *from, void *to)
 {
@@ -65,39 +172,6 @@ static __always_inline void set_jmp_op(void *from, void *to)
  */
 static __always_inline int can_boost(kprobe_opcode_t *opcodes)
 {
-#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 32))
-	/*
-	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
-	 * Groups, and some special opcodes can not be boost.
-	 */
-	static const unsigned long twobyte_is_boostable[256 / 32] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 0,0,1,1,0,0,1,0,1,1,0,0,0,0,0,0)| /* 00 */
-		W(0x10, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 10 */
-		W(0x20, 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0)| /* 20 */
-		W(0x30, 0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 30 */
-		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 40 */
-		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 50 */
-		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1)| /* 60 */
-		W(0x70, 0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1), /* 70 */
-		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 80 */
-		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1), /* 90 */
-		W(0xa0, 1,1,0,1,1,1,0,0,1,1,0,1,1,1,0,1)| /* a0 */
-		W(0xb0, 1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1), /* b0 */
-		W(0xc0, 1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1)| /* c0 */
-		W(0xd0, 0,1,1,1,0,1,0,0,1,1,0,1,1,1,0,1), /* d0 */
-		W(0xe0, 0,1,1,0,0,1,0,0,1,1,0,1,1,1,0,1)| /* e0 */
-		W(0xf0, 0,1,1,1,0,1,0,0,1,1,1,0,1,1,1,0)  /* f0 */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-#undef W
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
 retry:
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 3d1f1fa..54b2279 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -55,6 +55,113 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
+#define W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)  \
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (r % sizeof(unsigned long)))
+
+#define R1(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#define R3(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#define R4(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
+#define RF(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)
+
+#ifdef CONFIG_X86_32
+#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
+#else
+#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#endif
+
+/*
+ * Undefined/reserved opcodes, conditional jump, Opcode Extension
+ * Groups, and some special opcodes can not be boost.
+ */
+static const unsigned long
+twobyte_is_boostable[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) /* 00 */
+	R2(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 10 */
+	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 20 */
+	R4(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 30 */
+	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 40 */
+	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
+	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) /* 60 */
+	R4(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* 70 */
+	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 80 */
+	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 90 */
+	R3(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* a0 */
+	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* b0 */
+	R1(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* c0 */
+	R2(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* d0 */
+	R3(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* e0 */
+	RF(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0) /* f0 */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+static const unsigned long
+onebyte_has_modrm[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 00 */
+	R2(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 10 */
+	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 20 */
+	R4(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 30 */
+	R1(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 40 */
+	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
+	R3(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) /* 60 */
+	R4(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 70 */
+	R1(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 80 */
+	R2(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 90 */
+	R3(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* a0 */
+	R4(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* b0 */
+	R1(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* c0 */
+	R2(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* d0 */
+	R3(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* e0 */
+	RF(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* f0 */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+static const unsigned long
+twobyte_has_modrm[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) /* 0f */
+	R2(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) /* 1f */
+	R3(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* 2f */
+	R4(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 3f */
+	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 4f */
+	R2(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 5f */
+	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 6f */
+	R4(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) /* 7f */
+	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 8f */
+	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 9f */
+	R3(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* af */
+	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) /* bf */
+	R1(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* cf */
+	R2(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* df */
+	R3(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* ef */
+	RF(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0) /* ff */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+#undef W
+#undef R1
+#undef R2
+#undef R3
+#undef R4
+#undef RF
+
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
@@ -91,57 +198,6 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
  */
 static s32 __kprobes *is_riprel(u8 *insn)
 {
-#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 64))
-	static const u64 onebyte_has_modrm[256 / 64] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 00 */
-		W(0x10, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 10 */
-		W(0x20, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 20 */
-		W(0x30, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0), /* 30 */
-		W(0x40, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 40 */
-		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 50 */
-		W(0x60, 0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0)| /* 60 */
-		W(0x70, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 70 */
-		W(0x80, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 80 */
-		W(0x90, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 90 */
-		W(0xa0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* a0 */
-		W(0xb0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* b0 */
-		W(0xc0, 1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0)| /* c0 */
-		W(0xd0, 1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1)| /* d0 */
-		W(0xe0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* e0 */
-		W(0xf0, 0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1)  /* f0 */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-	static const u64 twobyte_has_modrm[256 / 64] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1)| /* 0f */
-		W(0x10, 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0)| /* 1f */
-		W(0x20, 1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,1)| /* 2f */
-		W(0x30, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 3f */
-		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 4f */
-		W(0x50, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 5f */
-		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 6f */
-		W(0x70, 1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1), /* 7f */
-		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 8f */
-		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 9f */
-		W(0xa0, 0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1)| /* af */
-		W(0xb0, 1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1), /* bf */
-		W(0xc0, 1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0)| /* cf */
-		W(0xd0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* df */
-		W(0xe0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* ef */
-		W(0xf0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0)  /* ff */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-#undef	W
 	int need_modrm;
 
 	/* Skip legacy instruction prefixes.  */
-- 
1.5.4.rc0.1083.gf568



