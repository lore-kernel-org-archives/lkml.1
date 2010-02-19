Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0BSR1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:27:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42315 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab0BSR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:27:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BNxd/Qj55GgW2SlWN1iAaomlp09jPNbWGLwIE7YrabnGG9SuzddhHFvzLL+2oQTps6
         NAe5AncL0N+FRpCjIqu72SMrfX5No2yEohZBxIm9fTRgG+HArm2bb58TL9M/ExEbSw3k
         DXc1m6TewCNu7tOl1kuqUQHeWizEvKq5EHEqo=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 1/5] x86: add support for relative CALL and JMP in alternatives (v2)
Date: Fri, 19 Feb 2010 18:26:40 +0100
Message-Id: <1266600404-16402-2-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
- Don't use instruction parser: use the method described below instead

Currently CALL and JMP cannot be used in alternatives because the
relative offset would be wrong.

This patch adds a new type of alternative, denoted by replacementlen = 0xff.
This alternative causes the kernel to generate a CALL rel32 to the
address provided in the alternative sequence address field.

This can be generated with ALTERNATIVE_CALL

This approach has the advantage of not requiring the instruction parser,
not requiring ad-hoc compile time relocation logic, and minimizing the
size of the alternative data.

Alternatives more complex than a single CALL could still be supported
with multiple successive alternative patches, but this is currently not
required.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/alternative.h |   14 ++++++++++++++
 arch/x86/kernel/alternative.c      |   24 ++++++++++++++++++++----
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 69b74a7..77f78e2 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -90,6 +90,20 @@ static inline void alternatives_smp_switch(int smp) {}
       "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\
       ".previous"
 
+#define ALTERNATIVE_CALL(oldinstr, func, feature)		       \
+									\
+      "661:\n\t" oldinstr "\n662:\n"				    \
+      ".section .altinstructions,\"a\"\n"			       \
+      _ASM_ALIGN "\n"						   \
+      _ASM_PTR "661b\n"			 /* label	   */   \
+      _ASM_PTR func "\n"			/* new instruction */   \
+      "  .byte " __stringify(feature) "\n"      /* feature bit     */   \
+      "  .byte 662b-661b\n"		     /* sourcelen       */   \
+      "  .byte 0xff\n"			  /* replacementlen  */   \
+      "  .byte 0\n"			     /* pad */	       \
+      ".previous\n"						     \
+
+
 /*
  * Alternative instructions for different CPU types or capabilities.
  *
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index de7353c..77eba91 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -210,7 +210,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
 	for (a = start; a < end; a++) {
 		u8 *instr = a->instr;
-		BUG_ON(a->replacementlen > a->instrlen);
+		size_t len;
 		BUG_ON(a->instrlen > sizeof(insnbuf));
 		if (!boot_cpu_has(a->cpuid))
 			continue;
@@ -222,9 +222,25 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 				__func__, a->instr, instr);
 		}
 #endif
-		memcpy(insnbuf, a->replacement, a->replacementlen);
-		add_nops(insnbuf + a->replacementlen,
-			 a->instrlen - a->replacementlen);
+		if (a->replacementlen == 0xff) {
+			/* emit a CALL rel32 */
+			long v = a->replacement - (instr + 5);
+			int v32 = (int)v;
+			BUG_ON(5 > a->instrlen);
+#ifdef CONFIG_X86_64
+			if (WARN_ON((long)v32 != v))
+				continue;
+#endif
+			len = 5;
+			insnbuf[0] = 0xe8;
+			memcpy(insnbuf + 1, &v32, 4);
+		} else {
+			BUG_ON(a->replacementlen > a->instrlen);
+			len = a->replacementlen;
+			memcpy(insnbuf, a->replacement, len);
+		}
+		add_nops(insnbuf + len,
+			a->instrlen - len);
 		text_poke_early(instr, insnbuf, a->instrlen);
 	}
 }
-- 
1.6.6.1.476.g01ddb

