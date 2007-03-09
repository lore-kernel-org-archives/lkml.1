Return-Path: <linux-kernel-owner+w=401wt.eu-S2992838AbXCIPMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992838AbXCIPMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992839AbXCIPMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:12:36 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:37442 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992838AbXCIPMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:12:34 -0500
X-BigFish: VP
X-FB-SS: 00
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Fri, 9 Mar 2007 16:11:27 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4 TRY#3] i386: extend alternative instructions
 framework
Message-ID: <20070309151127.GB13481@amd.com>
References: <20070309150825.GA13481@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070309150825.GA13481@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Mar 2007 15:12:16.0776 (UTC)
 FILETIME=[53067080:01C7625D]
X-WSS-ID: 69EFA6D92EG2386078-01-01
Content-Type: multipart/mixed;
 boundary=7JfCtLOvnd9MIVvH
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch extends the alternative instructions framework to support 2
alternative instructions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--7JfCtLOvnd9MIVvH
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=two-alternatives-i386.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
index 9eca21b..59f1770 100644
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -153,14 +153,23 @@ extern u8 __smp_alt_begin[], __smp_alt_end[];
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 	struct alt_instr *a;
-	u8 *instr;
+	u8 *instr, *replacement;
+	u8 replacementlen;
 	int diff;
 
 	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
 	for (a = start; a < end; a++) {
-		BUG_ON(a->replacementlen > a->instrlen);
-		if (!boot_cpu_has(a->cpuid))
+		if (boot_cpu_has(a->cpuid)) {
+			replacement = a->replacement;
+			replacementlen = a->replacementlen;
+		} else if ((a->replacementlen2 > 0) &&
+			   (boot_cpu_has(a->cpuid2))) {
+			replacement = a->replacement2;
+			replacementlen = a->replacementlen2;
+		} else
 			continue;
+
+		BUG_ON(replacementlen > a->instrlen);
 		instr = a->instr;
 #ifdef CONFIG_X86_64
 		/* vsyscall code is not mapped yet. resolve it manually. */
@@ -170,9 +179,9 @@ void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
-		memcpy(instr, a->replacement, a->replacementlen);
-		diff = a->instrlen - a->replacementlen;
-		nop_out(instr + a->replacementlen, diff);
+		memcpy(instr, replacement, replacementlen);
+		diff = a->instrlen - replacementlen;
+		nop_out(instr + replacementlen, diff);
 	}
 }
 
diff --git a/include/asm-i386/alternative.h b/include/asm-i386/alternative.h
index b8fa955..4a77e93 100644
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -10,11 +10,14 @@
 struct alt_instr {
 	u8 *instr; 		/* original instruction */
 	u8 *replacement;
+	u8 *replacement2;
 	u8  cpuid;		/* cpuid bit set for replacement */
+	u8  cpuid2;		/* cpuid bit set for replacement2 */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen; 	/* length of new instruction, <= instrlen */
-	u8  pad;
-};
+	u8  replacementlen2;
+	u8  pad[3];
+}  __attribute__ ((packed));
 
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
@@ -36,6 +39,12 @@ static inline void alternatives_smp_switch(int smp) {}
 #endif
 
 /*
+ * use this macro(s) if you need more than one output parameter
+ * in alternative_io_*
+ */
+#define ASM_OUTPUT2(a, b) a, b
+
+/*
  * Alternative instructions for different CPU types or capabilities.
  *
  * This allows to use optimized instructions even on generic binary
@@ -53,9 +62,12 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "  .align 4\n"					\
 		      "  .long 661b\n"            /* label */		\
 		      "  .long 663f\n"		  /* new instruction */	\
+		      "  .long 0x00\n"					\
 		      "  .byte %c0\n"             /* feature bit */	\
+		      "  .byte 0x00\n"					\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      "  .byte 0x00\n"					\
 		      ".previous\n"					\
 		      ".section .altinstr_replacement,\"ax\"\n"		\
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
@@ -77,14 +89,38 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "  .align 4\n"					\
 		      "  .long 661b\n"            /* label */		\
 		      "  .long 663f\n"		  /* new instruction */ \
+		      "  .long 0x00\n"					\
 		      "  .byte %c0\n"             /* feature bit */	\
+		      "  .byte 0x00\n"					\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */ 	\
+		      "  .byte 0x00\n"					\
 		      ".previous\n"					\
 		      ".section .altinstr_replacement,\"ax\"\n"		\
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
 		      ".previous" :: "i" (feature), ##input)
 
+/* Like alternative_io, but supports 2 possible alternatives */
+#define alternative_io_two(oldinstr, newinstr, feat, newinstr2, feat2,\
+		output, input...) \
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"                    \
+		      ".section .altinstructions,\"a\"\n"               \
+		      "  .align 4\n"                                    \
+		      "  .long 661b\n"            /* label */           \
+		      "  .long 663f\n"            /* new instruction */ \
+		      "  .long 665f\n"            /* new instruction 2 */\
+		      "  .byte %c[f]\n"        /* feature bit */        \
+		      "  .byte %c[f2]\n"          /* feature bit 2*/    \
+		      "  .byte 662b-661b\n"       /* sourcelen */       \
+		      "  .byte 664f-663f\n"       /* replacementlen */  \
+		      "  .byte 666f-665f\n"       /* replacementlen 2 */\
+		      ".previous\n"                                     \
+		      ".section .altinstr_replacement,\"ax\"\n"         \
+		      "663:\n\t" newinstr "\n664:\n"  /* replacement */ \
+		      "665:\n\t" newinstr2 "\n666:\n" /* replacement2 */ \
+		      ".previous" : output : [f] "i" (feat), \
+		      [f2] "i" (feat2),##input)
+
 /*
  * Alternative inline assembly for SMP.
  *

--7JfCtLOvnd9MIVvH--


