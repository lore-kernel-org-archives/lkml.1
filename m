Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZD1PPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZD1PPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762294AbZD1PNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:13:54 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:58614 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762309AbZD1PNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:13:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEABu29klMQW1W/2dsb2JhbACBUM12g3MF
Date: Tue, 28 Apr 2009 11:13:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86: cleanup alternative.h (v2)
Message-ID: <20090428151346.GA31212@Krystal>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.673946867@polymtl.ca> <20090428130501.GC26600@Krystal> <20090428145839.GA26546@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090428145839.GA26546@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:11:29 up 59 days, 11:37,  1 user,  load average: 0.30, 0.34,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alternative header duplicates assembly that could be merged in one single macro.
Merging this into this macro also allows to directly declare ALTERNATIVE()
statements within assembly code.

Uses a __stringify() of the feature bits rather than passing a "i" operand.
Leave the old %0 operand as-is (set to 0), unused to stay compatible with API.

(update : tab alignment fixes)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/include/asm/alternative.h |   59 ++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

Index: linux-2.6-lttng/arch/x86/include/asm/alternative.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/alternative.h	2009-04-28 10:45:10.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/alternative.h	2009-04-28 10:47:50.000000000 -0400
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/stddef.h>
+#include <linux/stringify.h>
 #include <asm/asm.h>
 
 /*
@@ -74,6 +75,22 @@ static inline void alternatives_smp_swit
 
 const unsigned char *const *find_nop_table(void);
 
+/* alternative assembly primitive */
+#define ALTERNATIVE(oldinstr, newinstr, feature) 			\
+									\
+      "661:\n\t" oldinstr "\n662:\n"					\
+      ".section .altinstructions,\"a\"\n"				\
+      _ASM_ALIGN "\n"							\
+      _ASM_PTR "661b\n"				/* label */		\
+      _ASM_PTR "663f\n"				/* new instruction */	\
+      "	 .byte " __stringify(feature) "\n"	/* feature bit */	\
+      "	 .byte 662b-661b\n"			/* sourcelen */		\
+      "	 .byte 664f-663f\n"			/* replacementlen */	\
+      ".previous\n"							\
+      ".section .altinstr_replacement,\"ax\"\n"				\
+      "663:\n\t" newinstr "\n664:\n"		/* replacement */	\
+      ".previous"
+
 /*
  * Alternative instructions for different CPU types or capabilities.
  *
@@ -87,18 +104,7 @@ const unsigned char *const *find_nop_tab
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
@@ -109,35 +115,16 @@ const unsigned char *const *find_nop_tab
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
