Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbZHMUdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbZHMUdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZHMUdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:33:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58660 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbZHMUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:33:07 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v14 04/12] kprobes: cleanup fix_riprel() using insn
	decoder on x86
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 13 Aug 2009 16:34:36 -0400
Message-ID: <20090813203436.31965.34374.stgit@localhost.localdomain>
In-Reply-To: <20090813203403.31965.20973.stgit@localhost.localdomain>
References: <20090813203403.31965.20973.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup fix_riprel() in arch/x86/kernel/kprobes.c by using x86 instruction
decoder.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
---

 arch/x86/kernel/kprobes.c |  128 ++++++++-------------------------------------
 1 files changed, 23 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 80d493f..98f48d0 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -109,50 +109,6 @@ static const u32 twobyte_is_boostable[256 / 32] = {
 	/*      -----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
 };
-static const u32 onebyte_has_modrm[256 / 32] = {
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
-	/*      -----------------------------------------------         */
-	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 00 */
-	W(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 10 */
-	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 20 */
-	W(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 30 */
-	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
-	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 50 */
-	W(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) | /* 60 */
-	W(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 70 */
-	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
-	W(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 90 */
-	W(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* a0 */
-	W(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* b0 */
-	W(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* c0 */
-	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
-	W(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* e0 */
-	W(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1)   /* f0 */
-	/*      -----------------------------------------------         */
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
-};
-static const u32 twobyte_has_modrm[256 / 32] = {
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
-	/*      -----------------------------------------------         */
-	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) | /* 0f */
-	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) , /* 1f */
-	W(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 2f */
-	W(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 3f */
-	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 4f */
-	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 5f */
-	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 6f */
-	W(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) , /* 7f */
-	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 8f */
-	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 9f */
-	W(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) | /* af */
-	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) , /* bf */
-	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* cf */
-	W(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* df */
-	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* ef */
-	W(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* ff */
-	/*      -----------------------------------------------         */
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
-};
 #undef W
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = {
@@ -345,68 +301,30 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 static void __kprobes fix_riprel(struct kprobe *p)
 {
 #ifdef CONFIG_X86_64
-	u8 *insn = p->ainsn.insn;
-	s64 disp;
-	int need_modrm;
-
-	/* Skip legacy instruction prefixes.  */
-	while (1) {
-		switch (*insn) {
-		case 0x66:
-		case 0x67:
-		case 0x2e:
-		case 0x3e:
-		case 0x26:
-		case 0x64:
-		case 0x65:
-		case 0x36:
-		case 0xf0:
-		case 0xf3:
-		case 0xf2:
-			++insn;
-			continue;
-		}
-		break;
-	}
+	struct insn insn;
+	kernel_insn_init(&insn, p->ainsn.insn);
 
-	/* Skip REX instruction prefix.  */
-	if (is_REX_prefix(insn))
-		++insn;
-
-	if (*insn == 0x0f) {
-		/* Two-byte opcode.  */
-		++insn;
-		need_modrm = test_bit(*insn,
-				      (unsigned long *)twobyte_has_modrm);
-	} else
-		/* One-byte opcode.  */
-		need_modrm = test_bit(*insn,
-				      (unsigned long *)onebyte_has_modrm);
-
-	if (need_modrm) {
-		u8 modrm = *++insn;
-		if ((modrm & 0xc7) == 0x05) {
-			/* %rip+disp32 addressing mode */
-			/* Displacement follows ModRM byte.  */
-			++insn;
-			/*
-			 * The copied instruction uses the %rip-relative
-			 * addressing mode.  Adjust the displacement for the
-			 * difference between the original location of this
-			 * instruction and the location of the copy that will
-			 * actually be run.  The tricky bit here is making sure
-			 * that the sign extension happens correctly in this
-			 * calculation, since we need a signed 32-bit result to
-			 * be sign-extended to 64 bits when it's added to the
-			 * %rip value and yield the same 64-bit result that the
-			 * sign-extension of the original signed 32-bit
-			 * displacement would have given.
-			 */
-			disp = (u8 *) p->addr + *((s32 *) insn) -
-			       (u8 *) p->ainsn.insn;
-			BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
-			*(s32 *)insn = (s32) disp;
-		}
+	if (insn_rip_relative(&insn)) {
+		s64 newdisp;
+		u8 *disp;
+		insn_get_displacement(&insn);
+		/*
+		 * The copied instruction uses the %rip-relative addressing
+		 * mode.  Adjust the displacement for the difference between
+		 * the original location of this instruction and the location
+		 * of the copy that will actually be run.  The tricky bit here
+		 * is making sure that the sign extension happens correctly in
+		 * this calculation, since we need a signed 32-bit result to
+		 * be sign-extended to 64 bits when it's added to the %rip
+		 * value and yield the same 64-bit result that the sign-
+		 * extension of the original signed 32-bit displacement would
+		 * have given.
+		 */
+		newdisp = (u8 *) p->addr + (s64) insn.displacement.value -
+			  (u8 *) p->ainsn.insn;
+		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
+		disp = (u8 *) p->ainsn.insn + insn_offset_displacement(&insn);
+		*(s32 *) disp = (s32) newdisp;
 	}
 #endif
 }


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
