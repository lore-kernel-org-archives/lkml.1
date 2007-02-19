Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXBSUqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXBSUqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932629AbXBSUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:46:24 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:29233 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932638AbXBSUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:46:23 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Mon, 19 Feb 2007 20:07:09 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: [PATCH 1/3] x86_64: additions to the i386 alternative
 extensions to support x86_64 architecture
Message-ID: <20070219190709.GC6083@amd.com>
References: <20070219190132.GA6083@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070219190132.GA6083@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Feb 2007 19:07:10.0315 (UTC)
 FILETIME=[27FE53B0:01C75459]
X-WSS-ID: 69C72AEB2EG983534-01-01
Content-Type: multipart/mixed;
 boundary=98e8jtXdkpgskNou
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds the necessary changes to extend the i386 alternative
instruction framework extension on the x86_64 architecture.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--98e8jtXdkpgskNou
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=alternative-extension-x86_84.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86_64/lib/clear_page.S b/arch/x86_64/lib/clear_page.S
index 9a10a78..4e34c12 100644
--- a/arch/x86_64/lib/clear_page.S
+++ b/arch/x86_64/lib/clear_page.S
@@ -53,6 +53,8 @@ ENDPROC(clear_page)
 	.align 8
 	.quad clear_page
 	.quad 1b
+	.byte 0x00
+	.byte 0x00
 	.byte X86_FEATURE_REP_GOOD
 	.byte .Lclear_page_end - clear_page
 	.byte 2b - 1b
diff --git a/arch/x86_64/lib/copy_page.S b/arch/x86_64/lib/copy_page.S
index 727a5d4..2aa51c2 100644
--- a/arch/x86_64/lib/copy_page.S
+++ b/arch/x86_64/lib/copy_page.S
@@ -113,6 +113,8 @@ ENDPROC(copy_page)
 	.align 8
 	.quad copy_page
 	.quad 1b
+	.byte 0x00
+	.byte 0x00
 	.byte X86_FEATURE_REP_GOOD
 	.byte .Lcopy_page_end - copy_page
 	.byte 2b - 1b
diff --git a/arch/x86_64/lib/copy_user.S b/arch/x86_64/lib/copy_user.S
index 70bebd3..2dd39d1 100644
--- a/arch/x86_64/lib/copy_user.S
+++ b/arch/x86_64/lib/copy_user.S
@@ -27,6 +27,8 @@
 	.align 8
 	.quad  0b
 	.quad  2b
+	.byte  0x00
+	.byte  0x00
 	.byte  \feature		     /* when feature is set */
 	.byte  5
 	.byte  5
diff --git a/arch/x86_64/lib/memcpy.S b/arch/x86_64/lib/memcpy.S
index 0ea0ddc..ee42a08 100644
--- a/arch/x86_64/lib/memcpy.S
+++ b/arch/x86_64/lib/memcpy.S
@@ -123,6 +123,8 @@ ENDPROC(__memcpy)
 	.align 8
 	.quad memcpy
 	.quad 1b
+	.byte 0x00
+	.byte 0x00
 	.byte X86_FEATURE_REP_GOOD
 	.byte .Lfinal - memcpy
 	.byte 2b - 1b
diff --git a/arch/x86_64/lib/memset.S b/arch/x86_64/lib/memset.S
index 2c59481..814e091 100644
--- a/arch/x86_64/lib/memset.S
+++ b/arch/x86_64/lib/memset.S
@@ -127,6 +127,8 @@ ENDPROC(__memset)
 	.align 8
 	.quad memset
 	.quad 1b
+	.byte 0x00
+	.byte 0x00
 	.byte X86_FEATURE_REP_GOOD
 	.byte .Lfinal - memset
 	.byte 2b - 1b
--- a/include/asm-x86_64/alternative.h
+++ b/include/asm-x86_64/alternative.h
@@ -7,14 +7,31 @@
 #include <linux/stddef.h>
 #include <asm/cpufeature.h>
 
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
+	                           this struct (only for succeeding entries) */
+	u8  instr_cpuid;        /* cpuid bit set if instr is used
+				   as replacement */
 	u8  cpuid;		/* cpuid bit set for replacement */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen; 	/* length of new instruction, <= instrlen */
-	u8  pad[5];
-};
+	u8  pad[3];
+} __attribute__ ((packed));
 
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
@@ -36,6 +53,13 @@ static inline void alternatives_smp_switch(int smp) {}
 
 #endif
 
+
+/*
+ * Use or extend the following macros if you need more than one
+ * output argument in the alternative_io() macro
+ */
+#define ALTERNATIVE_OUTPUT2(a,b) a,b
+
 /*
  * Alternative instructions for different CPU types or capabilities.
  *
@@ -54,6 +78,8 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "  .align 8\n"				       \
 		      "  .quad 661b\n"            /* label */          \
 		      "  .quad 663f\n"		  /* new instruction */ \
+		      "  .byte 0x00\n"            /* first entry */ \
+		      "  .byte 0x00\n"            /* zero for first entry */ \
 		      "  .byte %c0\n"             /* feature bit */    \
 		      "  .byte 662b-661b\n"       /* sourcelen */      \
 		      "  .byte 664f-663f\n"       /* replacementlen */ \
@@ -78,6 +104,8 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "  .align 8\n"					\
 		      "  .quad 661b\n"            /* label */		\
 		      "  .quad 663f\n"		  /* new instruction */	\
+		      "  .byte 0x00\n"            /* first entry */ \
+		      "  .byte 0x00\n"            /* zero for first entry */ \
 		      "  .byte %c0\n"             /* feature bit */	\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */	\
@@ -93,6 +121,8 @@ static inline void alternatives_smp_switch(int smp) {}
 		      "  .align 8\n"					\
 		      "  .quad 661b\n"            /* label */		\
 		      "  .quad 663f\n"		  /* new instruction */	\
+		      "  .byte 0x00\n"            /* first entry */ \
+		      "  .byte 0x00\n"            /* zero for first entry */ \
 		      "  .byte %c[feat]\n"        /* feature bit */	\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */	\
@@ -102,6 +132,45 @@ static inline void alternatives_smp_switch(int smp) {}
 		      ".previous" : output : [feat] "i" (feature), ##input)
 
 /*
+ * additional alternatives
+ *
+ * In the case where more than one alternative for an instruction exist,
+ * the two following macros could be used. They must appear immediately
+ * after the use alternative_io, alternative_input or alternative macros.
+ */
+
+#define alternative_add_one(newinstr2, feature2) \
+	asm volatile(".section .altinstructions,\"a\"\n" \
+		     "  .align 8\n" \
+		     "  .quad 661f\n" \
+		     "  .quad 0x00\n" \
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
+		     "  .align 8\n" \
+		     "  .quad 661f\n" \
+		     "  .quad 663f\n" \
+		     "  .byte 0x02\n" \
+		     "  .byte %c[feat2]\n" \
+		     "  .byte %c[feat3]\n" \
+		     "  .byte 662f-661f\n" \
+		     "  .byte 664f-663f\n" \
+		     ".previous\n" \
+		     ".section .altinstr_replacement,\"ax\"\n" \
+		     "661:\n\t" newinstr2 "\n662:\n" \
+		     "663:\n\t" newinstr3 "\n664:\n" \
+		     ".previous" : : [feat2] "i" (feature2), [feat3] "i" (feature3) )
+
+/*
  * Alternative inline assembly for SMP.
  *
  * The LOCK_PREFIX macro defined here replaces the LOCK and

--98e8jtXdkpgskNou--


