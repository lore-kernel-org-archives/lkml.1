Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbXLXD2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbXLXD2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 22:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLXD2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 22:28:33 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:13327 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXLXD2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 22:28:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aPTv9NYzcBOMPhrVeAs7GEBwKWuUGb2ld4B0q3rjnhwLAQJs8HlZb82s81RuP+sW+1uxdlzLCH8PCMLu4Cz6kHyQF7aYjwFhVcopx6kPFr18/44qTTHwjocvph+Lt60gFRfZy4/qSQTcZj8B6JZF8JCOudBWvlOlWD0mihrlIRI=
Subject: [PATCH] x86: kprobes remove fix_riprel #ifdef
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 19:28:37 -0800
Message-Id: <1198466917.6323.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move #ifdef around function definiton into the function and
unconditionally return on X86_32.  Saves an ifdef from the
one callsite.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, Masami, final leftovers from some unsent kprobes unification work.

Net reduction of one #ifdef section.

 arch/x86/kernel/kprobes.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b1804e4..1ac532e 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -263,15 +263,16 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Adjust the displacement if the instruction uses the %rip-relative
  * addressing mode.
  * If it does, Return the address of the 32-bit displacement word.
  * If not, return null.
+ * Only applicable to X86_64
  */
 static void __kprobes fix_riprel(struct kprobe *p)
 {
+#ifdef CONFIG_X86_64
 	u8 *insn = p->ainsn.insn;
 	s64 disp;
 	int need_modrm;
@@ -335,15 +336,17 @@ static void __kprobes fix_riprel(struct kprobe *p)
 			*(s32 *)insn = (s32) disp;
 		}
 	}
-}
+#else
+	return;
 #endif
+}
 
 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
 	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-#ifdef CONFIG_X86_64
+
 	fix_riprel(p);
-#endif
+
 	if (can_boost(p->addr))
 		p->ainsn.boostable = 0;
 	else
-- 
1.5.4.rc0.1143.g1a8a



