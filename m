Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbZFJVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbZFJVL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZFJVLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:11:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZFJVLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:11:18 -0400
Date: Wed, 10 Jun 2009 23:11:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm for v2.6.31
Message-ID: <20090610211109.GA30172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus

 Thanks,

	Ingo

------------------>
Alexey Dobriyan (2):
      x86, 32-bit: ifdef out struct thread_struct::fs
      x86, 64-bit: ifdef out struct thread_struct::ip

Mathieu Desnoyers (1):
      x86: clean up alternative.h


 arch/x86/include/asm/alternative.h |   59 ++++++++++++++----------------------
 arch/x86/include/asm/processor.h   |    5 ++-
 arch/x86/kernel/kgdb.c             |    2 +-
 3 files changed, 28 insertions(+), 38 deletions(-)

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
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..a9ba743 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -427,8 +427,12 @@ struct thread_struct {
 	unsigned short		fsindex;
 	unsigned short		gsindex;
 #endif
+#ifdef CONFIG_X86_32
 	unsigned long		ip;
+#endif
+#ifdef CONFIG_X86_64
 	unsigned long		fs;
+#endif
 	unsigned long		gs;
 	/* Hardware debugging registers: */
 	unsigned long		debugreg0;
@@ -874,7 +878,6 @@ static inline void spin_lock_prefetch(const void *x)
 	.vm86_info		= NULL,					  \
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
-	.fs			= __KERNEL_PERCPU,			  \
 }
 
 /*
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index eedfaeb..d07706f 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -141,7 +141,7 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	gdb_regs32[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
 	gdb_regs32[GDB_CS]	= __KERNEL_CS;
 	gdb_regs32[GDB_SS]	= __KERNEL_DS;
-	gdb_regs[GDB_PC]	= p->thread.ip;
+	gdb_regs[GDB_PC]	= 0;
 	gdb_regs[GDB_R8]	= 0;
 	gdb_regs[GDB_R9]	= 0;
 	gdb_regs[GDB_R10]	= 0;
