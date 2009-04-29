Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbZD2GSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbZD2GSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZD2GSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:18:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58059 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbZD2GSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:18:33 -0400
Date: Wed, 29 Apr 2009 06:17:58 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090428151346.GA31212@Krystal>
References: <20090428151346.GA31212@Krystal>
Subject: [tip:x86/asm] x86: clean up alternative.h
Message-ID: <tip-edc953fa4ebc0265ef3b1754fe116a9fd4264e15@git.kernel.org>
Git-Commit-ID: edc953fa4ebc0265ef3b1754fe116a9fd4264e15
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 06:18:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edc953fa4ebc0265ef3b1754fe116a9fd4264e15
Gitweb:     http://git.kernel.org/tip/edc953fa4ebc0265ef3b1754fe116a9fd4264e15
Author:     Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
AuthorDate: Tue, 28 Apr 2009 11:13:46 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 17:42:08 +0200

x86: clean up alternative.h

Alternative header duplicates assembly that could be merged in
one single macro.  Merging this into this macro also allows to
directly declare ALTERNATIVE() statements within assembly code.

Uses a __stringify() of the feature bits rather than passing a
"i" operand.  Leave the old %0 operand as-is (set to 0), unused
to stay compatible with API.

(v2: tab alignment fixes)

[ Impact: cleanup ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
LKML-Reference: <20090428151346.GA31212@Krystal>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/alternative.h |   59 ++++++++++++++----------------------
 1 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index f6aa18e..1a37bcd 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/stddef.h>
+#include <linux/stringify.h>
 #include <asm/asm.h>
 
 /*
@@ -74,6 +75,22 @@ static inline void alternatives_smp_switch(int smp) {}
 
 const unsigned char *const *find_nop_table(void);
 
+/* alternative assembly primitive: */
+#define ALTERNATIVE(oldinstr, newinstr, feature)			\
+									\
+      "661:\n\t" oldinstr "\n662:\n"					\
+      ".section .altinstructions,\"a\"\n"				\
+      _ASM_ALIGN "\n"							\
+      _ASM_PTR "661b\n"				/* label           */	\
+      _ASM_PTR "663f\n"				/* new instruction */	\
+      "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
+      "	 .byte 662b-661b\n"			/* sourcelen       */	\
+      "	 .byte 664f-663f\n"			/* replacementlen  */	\
+      ".previous\n"							\
+      ".section .altinstr_replacement, \"ax\"\n"			\
+      "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\
+      ".previous"
+
 /*
  * Alternative instructions for different CPU types or capabilities.
  *
@@ -87,18 +104,7 @@ const unsigned char *const *find_nop_table(void);
  * without volatile and memory clobber.
  */
 #define alternative(oldinstr, newinstr, feature)			\
-	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      _ASM_ALIGN "\n"					\
-		      _ASM_PTR "661b\n"		/* label */		\
-		      _ASM_PTR "663f\n"		/* new instruction */	\
-		      "	 .byte %c0\n"		/* feature bit */	\
-		      "	 .byte 662b-661b\n"	/* sourcelen */		\
-		      "	 .byte 664f-663f\n"	/* replacementlen */	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"  /* replacement */	\
-		      ".previous" :: "i" (feature) : "memory")
+	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature) : : : "memory")
 
 /*
  * Alternative inline assembly with input.
@@ -109,35 +115,16 @@ const unsigned char *const *find_nop_table(void);
  * Best is to use constraints that are fixed size (like (%1) ... "r")
  * If you use variable sized constraints like "m" or "g" in the
  * replacement make sure to pad to the worst case length.
+ * Leaving an unused argument 0 to keep API compatibility.
  */
 #define alternative_input(oldinstr, newinstr, feature, input...)	\
-	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      _ASM_ALIGN "\n"					\
-		      _ASM_PTR "661b\n"		/* label */		\
-		      _ASM_PTR "663f\n"		/* new instruction */	\
-		      "	 .byte %c0\n"		/* feature bit */	\
-		      "	 .byte 662b-661b\n"	/* sourcelen */		\
-		      "	 .byte 664f-663f\n"	/* replacementlen */	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"  /* replacement */	\
-		      ".previous" :: "i" (feature), ##input)
+	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
+		: : "i" (0), ## input)
 
 /* Like alternative_input, but with a single output argument */
 #define alternative_io(oldinstr, newinstr, feature, output, input...)	\
-	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      _ASM_ALIGN "\n"					\
-		      _ASM_PTR "661b\n"		/* label */		\
-		      _ASM_PTR "663f\n"		/* new instruction */	\
-		      "	 .byte %c[feat]\n"	/* feature bit */	\
-		      "	 .byte 662b-661b\n"	/* sourcelen */		\
-		      "	 .byte 664f-663f\n"	/* replacementlen */	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"  /* replacement */ \
-		      ".previous" : output : [feat] "i" (feature), ##input)
+	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
+		: output : "i" (0), ## input)
 
 /*
  * use this macro(s) if you need more than one output parameter
