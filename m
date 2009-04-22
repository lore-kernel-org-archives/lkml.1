Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZDVUsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZDVUsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZDVUrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:47:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51959 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbZDVUrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:47:40 -0400
Message-Id: <20090422202453.673946867@polymtl.ca>
References: <20090422201852.092307236@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 22 Apr 2009 16:18:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: [patch 1/2] x86: cleanup alternative.h
Content-Disposition: inline; filename=x86-cleanup-alternative.h.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 22 Apr 2009 20:46:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alternative header duplicates assembly that could be merged in one single macro.
Merging this into this macro also allows to directly declare ALTERNATIVE()
statements within assembly code.

Uses a __stringify() of the feature bits rather than passing a "i" operand.
Leave the old %0 operand as-is (set to 0), unused to stay compatible with API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/include/asm/alternative.h |   58 ++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 36 deletions(-)

Index: linux-2.6-lttng/arch/x86/include/asm/alternative.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/alternative.h	2009-04-22 16:14:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/alternative.h	2009-04-22 16:17:48.000000000 -0400
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/stddef.h>
+#include <linux/stringify.h>
 #include <asm/asm.h>
 
 /*
@@ -74,6 +75,21 @@ static inline void alternatives_smp_swit
 
 const unsigned char *const *find_nop_table(void);
 
+/* alternative assembly primitive */
+#define ALTERNATIVE(oldinstr, newinstr, feature) \
+	      "661:\n\t" oldinstr "\n662:\n"			\
+	      ".section .altinstructions,\"a\"\n"		\
+	      _ASM_ALIGN "\n"					\
+	      _ASM_PTR "661b\n"		/* label */		\
+	      _ASM_PTR "663f\n"		/* new instruction */	\
+	      "	 .byte " __stringify(feature) "\n"	/* feature bit */ \
+	      "	 .byte 662b-661b\n"	/* sourcelen */		\
+	      "	 .byte 664f-663f\n"	/* replacementlen */	\
+	      ".previous\n"					\
+	      ".section .altinstr_replacement,\"ax\"\n"		\
+	      "663:\n\t" newinstr "\n664:\n"  /* replacement */	\
+	      ".previous"
+
 /*
  * Alternative instructions for different CPU types or capabilities.
  *
@@ -87,18 +103,7 @@ const unsigned char *const *find_nop_tab
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
@@ -109,35 +114,16 @@ const unsigned char *const *find_nop_tab
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

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
