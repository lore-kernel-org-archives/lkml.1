Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZH0Cci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZH0Cci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbZH0Cce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:32:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:53185 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbZH0Cc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=olRfhkVmLJiPJYIy32LK8jLtaYv4EycIra+8i2FLInvTiRdDvgLojD3k2XM5l80Xqd
         sPF3AygHiL4wLzrs8yUWsgF5UM6PhwnMT4by5hjPeEePBBv89WaT/mHZMZ5l23jO9YaW
         8u3TmvFDO/HfnUPL63Woxg0/8eAiY7BkN4wdU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/18] kprobes: Cleanup fix_riprel() using insn decoder on x86
Date: Thu, 27 Aug 2009 04:32:03 +0200
Message-Id: <1251340337-5640-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Cleanup fix_riprel() in arch/x86/kernel/kprobes.c by using the new x86
instruction decoder instead of using comparisons with raw ad hoc numeric
opcodes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
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
LKML-Reference: <20090813203436.31965.34374.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/kprobes.c |  128 ++++++++-------------------------------------
 1 files changed, 23 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index aa15f3e..16ae961 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -108,50 +108,6 @@ static const u32 twobyte_is_boostable[256 / 32] = {
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
@@ -348,68 +304,30 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
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
1.6.2.3

