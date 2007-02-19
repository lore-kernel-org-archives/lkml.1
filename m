Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbXBSUjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbXBSUjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932609AbXBSUjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:39:09 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:54978 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932611AbXBSUjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:39:07 -0500
X-Greylist: delayed 5661 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 15:39:06 EST
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Mon, 19 Feb 2007 20:04:29 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: [PATCH 1/3] i386: extend alternative instruction framwork
Message-ID: <20070219190429.GB6083@amd.com>
References: <20070219190132.GA6083@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070219190132.GA6083@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Feb 2007 19:04:30.0374 (UTC)
 FILETIME=[C8A94460:01C75458]
X-WSS-ID: 69C72B482X0967403-01-01
Content-Type: multipart/mixed;
 boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch extends the alternative instruction framework to support an
arbitrary number of alternatives on the i386 architecture.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--HcAYCG3uE/tztfnV
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=alternative-extension-i386.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
index 9eca21b..2dedf4b 100644
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -149,19 +149,38 @@ extern u8 __smp_alt_begin[], __smp_alt_end[];
    self modifying code. This implies that assymetric systems where
    APs have less capabilities than the boot processor are not handled.
    Tough. Make sure you disable such features by hand. */
-
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 	struct alt_instr *a;
-	u8 *instr;
+	u8 *instr = NULL, *new_instr = NULL;
+	u8 instr_len = 0, new_instr_len = 0;
 	int diff;
 
 	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
 	for (a = start; a < end; a++) {
-		BUG_ON(a->replacementlen > a->instrlen);
-		if (!boot_cpu_has(a->cpuid))
+
+		if (a->used == 0) {
+			instr = a->instr;
+			instr_len = a->instrlen;
+			new_instr =
+				boot_cpu_has(a->cpuid) ? a->replacement : NULL;
+			new_instr_len =
+				boot_cpu_has(a->cpuid) ? a->replacementlen : 0;
+		} else if (a->used >= 1 && boot_cpu_has(a->instr_cpuid)) {
+			BUG_ON(instr == NULL);
+			new_instr = a->instr;
+			new_instr_len = a->instrlen;
+		} else if (a->used == 2 && boot_cpu_has(a->cpuid)) {
+			BUG_ON(instr == NULL);
+			new_instr = a->replacement;
+			new_instr_len = a->replacementlen;
+		}
+
+		if (instr == NULL || new_instr == NULL)
 			continue;
-		instr = a->instr;
+
+		BUG_ON(new_instr_len > instr_len);
+
 #ifdef CONFIG_X86_64
 		/* vsyscall code is not mapped yet. resolve it manually. */
 		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
@@ -170,9 +189,10 @@ void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
-		memcpy(instr, a->replacement, a->replacementlen);
-		diff = a->instrlen - a->replacementlen;
-		nop_out(instr + a->replacementlen, diff);
+		memcpy(instr, new_instr, new_instr_len);
+		diff = instr_len - new_instr_len;
+		nop_out(instr + new_instr_len, diff);
+		instr = new_instr = NULL;
 	}
 }
 
diff --git a/include/asm-i386/alternative.h b/include/asm-i386/alternative.h
index b8fa955..b899e61 100644
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -7,14 +7,31 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 
+/* struct alt_instr - define replacement sequences
+ *
+ * this struct is used in 2 ways:
+ *   - as the first entry for a replace sequence (used == 0)
+ *     In this case *instr points to the original instruction and
+ *     instr_cpuid is ignored
+ *   - as a following entry in a replace sequence (used == [1|2])
+ *     In this case *instr is used as a replacement pointer too
+ *     (supporting up to two replacements per struct) and
+ *     instr_cpuid is its cpuid value
+ *
+ * The first matching replacement in a sequence is used
+ */
 struct alt_instr {
 	u8 *instr; 		/* original instruction */
 	u8 *replacement;
+	u8  used;               /* count the number of replacements in
+				   this struct (only for succeeding entries) */
+	u8  instr_cpuid;        /* cpuid bit set if instr is used
+				   as replacement */
 	u8  cpuid;		/* cpuid bit set for replacement */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen; 	/* length of new instruction, <= instrlen */
-	u8  pad;
-};
+	u8  pad[3];
+} __attribute__ ((packed));
 
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
@@ -36,6 +53,12 @@ static inline void alternatives_smp_switch(int smp) {}
 #endif
 
 /*
+ * Use or extend the following macros if you need more than one
+ * output argument in the alternative_io() macro
+ */
+#define ALTERNATIVE_OUTPUT2(a,b) a,b
+
+/*
  * Alternative instructions for different CPU types or capabilities.
  *
  * This allows to use optimized instructions even on generic binary
@@ -53,6 +76,8 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "  .align 4\n"					\
 		      "  .long 661b\n"            /* label */		\
 		      "  .long 663f\n"		  /* new instruction */	\
+		      "  .byte 0x00\n"            /* used count */      \
+		      "  .byte 0x00\n"            /* instr_cpuid */     \
 		      "  .byte %c0\n"             /* feature bit */	\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */	\
@@ -77,6 +102,8 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "  .align 4\n"					\
 		      "  .long 661b\n"            /* label */		\
 		      "  .long 663f\n"		  /* new instruction */ \
+		      "  .byte 0x00\n"            /* used count */      \
+		      "  .byte 0x00\n"            /* instr_cpuid */     \
 		      "  .byte %c0\n"             /* feature bit */	\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */ 	\
@@ -85,6 +112,62 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
 		      ".previous" :: "i" (feature), ##input)
 
+/* Like alternative_input, but with a single output argument */
+#define alternative_io(oldinstr, newinstr, feature, output, input...) \
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"                    \
+		      ".section .altinstructions,\"a\"\n"               \
+		      "  .align 4\n"                                    \
+		      "  .long 661b\n"            /* label */           \
+		      "  .long 663f\n"            /* new instruction */ \
+		      "  .byte 0x00\n"            /* first entry */ \
+		      "  .byte 0x00\n"            /* zero for first entry */ \
+		      "  .byte %c[feat]\n"        /* feature bit */     \
+		      "  .byte 662b-661b\n"       /* sourcelen */       \
+		      "  .byte 664f-663f\n"       /* replacementlen */  \
+		      ".previous\n"                                     \
+		      ".section .altinstr_replacement,\"ax\"\n"         \
+		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
+		      ".previous" : output : [feat] "i" (feature), ##input)
+
+/*
+ * additional alternatives
+ *
+ * In the case where more than one alternative for an instruction exist,
+ * the two following macros could be used. They must appear immediately
+ * after the use alternative_io, alternative_input or alternative macros.
+ */
+
+#define alternative_add_one(newinstr2, feature2) \
+	asm volatile(".section .altinstructions,\"a\"\n" \
+		     "  .align 4\n" \
+		     "  .long 661f\n" \
+		     "  .long 0x00\n" \
+		     "  .byte 0x01\n" \
+		     "  .byte %c[feat2]\n" \
+		     "  .byte 0x00\n" \
+		     "  .byte 662f-661f\n" \
+		     "  .byte 0x00\n" \
+		     ".previous\n" \
+		     ".section .altinstr_replacement,\"ax\"\n" \
+		     "661:\n\t" newinstr2 "\n662:\n" \
+		     ".previous" : : [feat2] "i" (feature2) )
+
+#define alternative_add_two(newinstr2, feature2, newinstr3, feature3) \
+	asm volatile(".section .altinstructions,\"a\"\n" \
+		     "  .align 4\n" \
+		     "  .long 661f\n" \
+		     "  .long 663f\n" \
+		     "  .byte 0x02\n" \
+		     "  .byte %c[feat2]\n" \
+		     "  .byte %c[feat3]\n" \
+		     "  .byte 662f-661f\n" \
+		     "  .byte 664f-663f\n" \
+		     ".previous\n" \
+		     ".section .altinstr_replacement,\"ax\"\n" \
+		     "661:\n\t" newinstr2 "\n662:\n" \
+		     "663:\n\t" newinstr3 "\n664:\n" \
+		    ".previous" : : [feat2] "i" (feature2), [feat3] "i" (feature3))
+
 /*
  * Alternative inline assembly for SMP.
  *

--HcAYCG3uE/tztfnV--


