Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYARFDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYARFDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYARFDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:03:39 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:56325 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYARFDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:03:37 -0500
Date: Fri, 18 Jan 2008 00:03:36 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH] x86: merge asm-x86/alternative.h
Message-ID: <20080118050336.GC974@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straightforward merge. Kind of a pity that gas doesn't really have the
concept of a "long" (long is 4-bytes for some reason.) Nor is it able to
pad to a non-power of two boundary (for struct alignment) to get rid
of the struct alt_instr padding.

Build tested on i386, i386 with lguest & xen paravirt enabled, and
x86_64. Boot tested on x86_64.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---

 include/asm-x86/alternative.h    |  169 +++++++++++++++++++++++++++++++++++++-
 include/asm-x86/alternative_32.h |  154 ----------------------------------
 include/asm-x86/alternative_64.h |  159 -----------------------------------
 3 files changed, 166 insertions(+), 316 deletions(-)
 delete mode 100644 include/asm-x86/alternative_32.h
 delete mode 100644 include/asm-x86/alternative_64.h

diff --git a/include/asm-x86/alternative.h b/include/asm-x86/alternative.h
index 9eef6a3..7047a0f 100644
--- a/include/asm-x86/alternative.h
+++ b/include/asm-x86/alternative.h
@@ -1,5 +1,168 @@
-#ifdef CONFIG_X86_32
-# include "alternative_32.h"
+#ifndef _X86_ALTERNATIVE_H
+#define _X86_ALTERNATIVE_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+
+#ifdef CONFIG_X86_64
+# define ALT_ASMPTR	".quad"
+# define ALT_ALIGN	"8"
+# define ALT_INSTR_PAD	5
 #else
-# include "alternative_64.h"
+# define ALT_ASMPTR	".long"
+# define ALT_ALIGN	"4"
+# define ALT_INSTR_PAD	1
 #endif
+
+struct alt_instr {
+	u8 *instr; 		/* original instruction */
+	u8 *replacement;
+	u8  cpuid;		/* cpuid bit set for replacement */
+	u8  instrlen;		/* length of original instruction */
+	u8  replacementlen; 	/* length of new instruction, <= instrlen */
+	u8  _pad[ALT_INSTR_PAD];
+};
+
+/*
+ * Alternative inline assembly for SMP.
+ *
+ * The LOCK_PREFIX macro defined here replaces the LOCK and
+ * LOCK_PREFIX macros used everywhere in the source tree.
+ *
+ * SMP alternatives use the same data structures as the other
+ * alternatives and the X86_FEATURE_UP flag to indicate the case of a
+ * UP system running a SMP kernel.  The existing apply_alternatives()
+ * works fine for patching a SMP kernel for UP.
+ *
+ * The SMP alternative tables can be kept after boot and contain both
+ * UP and SMP versions of the instructions to allow switching back to
+ * SMP at runtime, when hotplugging in a new CPU, which is especially
+ * useful in virtualized environments.
+ *
+ * The very common lock prefix is handled as special case in a
+ * separate table which is a pure address list without replacement ptr
+ * and size information.  That keeps the table sizes small.
+ */
+
+#ifdef CONFIG_SMP
+#define LOCK_PREFIX \
+		".section .smp_locks,\"a\"\n"		\
+		"  .align " ALT_ALIGN "\n"		\
+		"  " ALT_ASMPTR " 661f\n" /* address */	\
+		".previous\n"				\
+	       	"661:\n\tlock; "
+#else /* ! CONFIG_SMP */
+#define LOCK_PREFIX ""
+#endif
+
+/* This must be included *after* the definition of LOCK_PREFIX */
+#include <asm/cpufeature.h>
+
+extern void alternative_instructions(void);
+extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
+
+struct module;
+
+#ifdef CONFIG_SMP
+extern void alternatives_smp_module_add(struct module *mod, char *name,
+					void *locks, void *locks_end,
+					void *text, void *text_end);
+extern void alternatives_smp_module_del(struct module *mod);
+extern void alternatives_smp_switch(int smp);
+#else
+static inline void alternatives_smp_module_add(struct module *mod, char *name,
+					void *locks, void *locks_end,
+					void *text, void *text_end) {}
+static inline void alternatives_smp_module_del(struct module *mod) {}
+static inline void alternatives_smp_switch(int smp) {}
+#endif
+
+#endif
+
+/*
+ * Alternative instructions for different CPU types or capabilities.
+ *
+ * This allows to use optimized instructions even on generic binary
+ * kernels.
+ *
+ * length of oldinstr must be longer or equal the length of newinstr
+ * It can be padded with nops as needed.
+ *
+ * For non barrier like inlines please define new variants
+ * without volatile and memory clobber.
+ */
+#define alternative(oldinstr, newinstr, feature) 	\
+	asm volatile ("661:\n\t" oldinstr "\n662:\n" 		     \
+		      ".section .altinstructions,\"a\"\n"     	     \
+		      "  .align " ALT_ALIGN " \n"		      \
+		      "  " ALT_ASMPTR " 661b\n" /* label */          \
+		      "  " ALT_ASMPTR " 663f\n"	/* new instruction */ \
+		      "  .byte %c0\n"             /* feature bit */    \
+		      "  .byte 662b-661b\n"       /* sourcelen */      \
+		      "  .byte 664f-663f\n"       /* replacementlen */ \
+		      ".previous\n"					\
+		      ".section .altinstr_replacement,\"ax\"\n"		\
+		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
+		      ".previous" :: "i" (feature) : "memory")
+
+/*
+ * Alternative inline assembly with input.
+ *
+ * Pecularities:
+ * No memory clobber here.
+ * Argument numbers start with 1.
+ * Best is to use constraints that are fixed size (like (%1) ... "r")
+ * If you use variable sized constraints like "m" or "g" in the
+ * replacement make sure to pad to the worst case length.
+ */
+#define alternative_input(oldinstr, newinstr, feature, input...)	\
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
+		      ".section .altinstructions,\"a\"\n"		\
+		      "  .align " ALT_ALIGN " \n"			\
+		      "  " ALT_ASMPTR " 661b\n"   /* label */		\
+		      "  " ALT_ASMPTR " 663f\n"	  /* new instruction */	\
+		      "  .byte %c0\n"             /* feature bit */	\
+		      "  .byte 662b-661b\n"       /* sourcelen */	\
+		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      ".previous\n"					\
+		      ".section .altinstr_replacement,\"ax\"\n"		\
+		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
+		      ".previous" :: "i" (feature), ##input)
+
+/* Like alternative_input, but with a single output argument */
+#define alternative_io(oldinstr, newinstr, feature, output, input...) \
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
+		      ".section .altinstructions,\"a\"\n"		\
+		      "  .align " ALT_ALIGN " \n"			\
+		      "  " ALT_ASMPTR " 661b\n"   /* label */		\
+		      "  " ALT_ASMPTR " 663f\n"	  /* new instruction */	\
+		      "  .byte %c[feat]\n"        /* feature bit */	\
+		      "  .byte 662b-661b\n"       /* sourcelen */	\
+		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      ".previous\n"					\
+		      ".section .altinstr_replacement,\"ax\"\n"		\
+		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
+		      ".previous" : output : [feat] "i" (feature), ##input)
+
+/*
+ * use this macro(s) if you need more than one output parameter
+ * in alternative_io
+ */
+#define ASM_OUTPUT2(a, b) a, b
+
+struct paravirt_patch_site;
+#ifdef CONFIG_PARAVIRT
+void apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end);
+#else
+static inline void
+apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end)
+{}
+#define __parainstructions NULL
+#define __parainstructions_end NULL
+#endif
+
+extern void text_poke(void *addr, unsigned char *opcode, int len);
+
+#endif /* _X86_ALTERNATIVE_H */
diff --git a/include/asm-x86/alternative_32.h b/include/asm-x86/alternative_32.h
deleted file mode 100644
index bda6c81..0000000
--- a/include/asm-x86/alternative_32.h
+++ /dev/null
@@ -1,154 +0,0 @@
-#ifndef _I386_ALTERNATIVE_H
-#define _I386_ALTERNATIVE_H
-
-#include <asm/types.h>
-#include <linux/stddef.h>
-#include <linux/types.h>
-
-struct alt_instr {
-	u8 *instr; 		/* original instruction */
-	u8 *replacement;
-	u8  cpuid;		/* cpuid bit set for replacement */
-	u8  instrlen;		/* length of original instruction */
-	u8  replacementlen; 	/* length of new instruction, <= instrlen */
-	u8  pad;
-};
-
-extern void alternative_instructions(void);
-extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
-
-struct module;
-#ifdef CONFIG_SMP
-extern void alternatives_smp_module_add(struct module *mod, char *name,
-					void *locks, void *locks_end,
-					void *text, void *text_end);
-extern void alternatives_smp_module_del(struct module *mod);
-extern void alternatives_smp_switch(int smp);
-#else
-static inline void alternatives_smp_module_add(struct module *mod, char *name,
-					void *locks, void *locks_end,
-					void *text, void *text_end) {}
-static inline void alternatives_smp_module_del(struct module *mod) {}
-static inline void alternatives_smp_switch(int smp) {}
-#endif	/* CONFIG_SMP */
-
-/*
- * Alternative instructions for different CPU types or capabilities.
- *
- * This allows to use optimized instructions even on generic binary
- * kernels.
- *
- * length of oldinstr must be longer or equal the length of newinstr
- * It can be padded with nops as needed.
- *
- * For non barrier like inlines please define new variants
- * without volatile and memory clobber.
- */
-#define alternative(oldinstr, newinstr, feature)			\
-	asm volatile ("661:\n\t" oldinstr "\n662:\n" 			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      "  .align 4\n"					\
-		      "  .long 661b\n"            /* label */		\
-		      "  .long 663f\n"		  /* new instruction */	\
-		      "  .byte %c0\n"             /* feature bit */	\
-		      "  .byte 662b-661b\n"       /* sourcelen */	\
-		      "  .byte 664f-663f\n"       /* replacementlen */	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
-		      ".previous" :: "i" (feature) : "memory")
-
-/*
- * Alternative inline assembly with input.
- *
- * Pecularities:
- * No memory clobber here.
- * Argument numbers start with 1.
- * Best is to use constraints that are fixed size (like (%1) ... "r")
- * If you use variable sized constraints like "m" or "g" in the
- * replacement maake sure to pad to the worst case length.
- */
-#define alternative_input(oldinstr, newinstr, feature, input...)	\
-	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      "  .align 4\n"					\
-		      "  .long 661b\n"            /* label */		\
-		      "  .long 663f\n"		  /* new instruction */ \
-		      "  .byte %c0\n"             /* feature bit */	\
-		      "  .byte 662b-661b\n"       /* sourcelen */	\
-		      "  .byte 664f-663f\n"       /* replacementlen */ 	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
-		      ".previous" :: "i" (feature), ##input)
-
-/* Like alternative_input, but with a single output argument */
-#define alternative_io(oldinstr, newinstr, feature, output, input...) \
-	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      "  .align 4\n"					\
-		      "  .long 661b\n"            /* label */		\
-		      "  .long 663f\n"		  /* new instruction */	\
-		      "  .byte %c[feat]\n"        /* feature bit */	\
-		      "  .byte 662b-661b\n"       /* sourcelen */	\
-		      "  .byte 664f-663f\n"       /* replacementlen */	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
-		      ".previous" : output : [feat] "i" (feature), ##input)
-
-/*
- * use this macro(s) if you need more than one output parameter
- * in alternative_io
- */
-#define ASM_OUTPUT2(a, b) a, b
-
-/*
- * Alternative inline assembly for SMP.
- *
- * The LOCK_PREFIX macro defined here replaces the LOCK and
- * LOCK_PREFIX macros used everywhere in the source tree.
- *
- * SMP alternatives use the same data structures as the other
- * alternatives and the X86_FEATURE_UP flag to indicate the case of a
- * UP system running a SMP kernel.  The existing apply_alternatives()
- * works fine for patching a SMP kernel for UP.
- *
- * The SMP alternative tables can be kept after boot and contain both
- * UP and SMP versions of the instructions to allow switching back to
- * SMP at runtime, when hotplugging in a new CPU, which is especially
- * useful in virtualized environments.
- *
- * The very common lock prefix is handled as special case in a
- * separate table which is a pure address list without replacement ptr
- * and size information.  That keeps the table sizes small.
- */
-
-#ifdef CONFIG_SMP
-#define LOCK_PREFIX \
-		".section .smp_locks,\"a\"\n"	\
-		"  .align 4\n"			\
-		"  .long 661f\n" /* address */	\
-		".previous\n"			\
-	       	"661:\n\tlock; "
-
-#else /* ! CONFIG_SMP */
-#define LOCK_PREFIX ""
-#endif
-
-struct paravirt_patch_site;
-#ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch_site *start,
-		    struct paravirt_patch_site *end);
-#else
-static inline void
-apply_paravirt(struct paravirt_patch_site *start,
-	       struct paravirt_patch_site *end)
-{}
-#define __parainstructions	NULL
-#define __parainstructions_end	NULL
-#endif
-
-extern void text_poke(void *addr, unsigned char *opcode, int len);
-
-#endif /* _I386_ALTERNATIVE_H */
diff --git a/include/asm-x86/alternative_64.h b/include/asm-x86/alternative_64.h
deleted file mode 100644
index ab161e8..0000000
--- a/include/asm-x86/alternative_64.h
+++ /dev/null
@@ -1,159 +0,0 @@
-#ifndef _X86_64_ALTERNATIVE_H
-#define _X86_64_ALTERNATIVE_H
-
-#ifdef __KERNEL__
-
-#include <linux/types.h>
-#include <linux/stddef.h>
-
-/*
- * Alternative inline assembly for SMP.
- *
- * The LOCK_PREFIX macro defined here replaces the LOCK and
- * LOCK_PREFIX macros used everywhere in the source tree.
- *
- * SMP alternatives use the same data structures as the other
- * alternatives and the X86_FEATURE_UP flag to indicate the case of a
- * UP system running a SMP kernel.  The existing apply_alternatives()
- * works fine for patching a SMP kernel for UP.
- *
- * The SMP alternative tables can be kept after boot and contain both
- * UP and SMP versions of the instructions to allow switching back to
- * SMP at runtime, when hotplugging in a new CPU, which is especially
- * useful in virtualized environments.
- *
- * The very common lock prefix is handled as special case in a
- * separate table which is a pure address list without replacement ptr
- * and size information.  That keeps the table sizes small.
- */
-
-#ifdef CONFIG_SMP
-#define LOCK_PREFIX \
-		".section .smp_locks,\"a\"\n"	\
-		"  .align 8\n"			\
-		"  .quad 661f\n" /* address */	\
-		".previous\n"			\
-	       	"661:\n\tlock; "
-
-#else /* ! CONFIG_SMP */
-#define LOCK_PREFIX ""
-#endif
-
-/* This must be included *after* the definition of LOCK_PREFIX */
-#include <asm/cpufeature.h>
-
-struct alt_instr {
-	u8 *instr; 		/* original instruction */
-	u8 *replacement;
-	u8  cpuid;		/* cpuid bit set for replacement */
-	u8  instrlen;		/* length of original instruction */
-	u8  replacementlen; 	/* length of new instruction, <= instrlen */
-	u8  pad[5];
-};
-
-extern void alternative_instructions(void);
-extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
-
-struct module;
-
-#ifdef CONFIG_SMP
-extern void alternatives_smp_module_add(struct module *mod, char *name,
-					void *locks, void *locks_end,
-					void *text, void *text_end);
-extern void alternatives_smp_module_del(struct module *mod);
-extern void alternatives_smp_switch(int smp);
-#else
-static inline void alternatives_smp_module_add(struct module *mod, char *name,
-					void *locks, void *locks_end,
-					void *text, void *text_end) {}
-static inline void alternatives_smp_module_del(struct module *mod) {}
-static inline void alternatives_smp_switch(int smp) {}
-#endif
-
-#endif
-
-/*
- * Alternative instructions for different CPU types or capabilities.
- *
- * This allows to use optimized instructions even on generic binary
- * kernels.
- *
- * length of oldinstr must be longer or equal the length of newinstr
- * It can be padded with nops as needed.
- *
- * For non barrier like inlines please define new variants
- * without volatile and memory clobber.
- */
-#define alternative(oldinstr, newinstr, feature) 	\
-	asm volatile ("661:\n\t" oldinstr "\n662:\n" 		     \
-		      ".section .altinstructions,\"a\"\n"     	     \
-		      "  .align 8\n"				       \
-		      "  .quad 661b\n"            /* label */          \
-		      "  .quad 663f\n"		  /* new instruction */ \
-		      "  .byte %c0\n"             /* feature bit */    \
-		      "  .byte 662b-661b\n"       /* sourcelen */      \
-		      "  .byte 664f-663f\n"       /* replacementlen */ \
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
-		      ".previous" :: "i" (feature) : "memory")
-
-/*
- * Alternative inline assembly with input.
- *
- * Pecularities:
- * No memory clobber here.
- * Argument numbers start with 1.
- * Best is to use constraints that are fixed size (like (%1) ... "r")
- * If you use variable sized constraints like "m" or "g" in the
- * replacement make sure to pad to the worst case length.
- */
-#define alternative_input(oldinstr, newinstr, feature, input...)	\
-	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      "  .align 8\n"					\
-		      "  .quad 661b\n"            /* label */		\
-		      "  .quad 663f\n"		  /* new instruction */	\
-		      "  .byte %c0\n"             /* feature bit */	\
-		      "  .byte 662b-661b\n"       /* sourcelen */	\
-		      "  .byte 664f-663f\n"       /* replacementlen */	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
-		      ".previous" :: "i" (feature), ##input)
-
-/* Like alternative_input, but with a single output argument */
-#define alternative_io(oldinstr, newinstr, feature, output, input...) \
-	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
-		      ".section .altinstructions,\"a\"\n"		\
-		      "  .align 8\n"					\
-		      "  .quad 661b\n"            /* label */		\
-		      "  .quad 663f\n"		  /* new instruction */	\
-		      "  .byte %c[feat]\n"        /* feature bit */	\
-		      "  .byte 662b-661b\n"       /* sourcelen */	\
-		      "  .byte 664f-663f\n"       /* replacementlen */	\
-		      ".previous\n"					\
-		      ".section .altinstr_replacement,\"ax\"\n"		\
-		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
-		      ".previous" : output : [feat] "i" (feature), ##input)
-
-/*
- * use this macro(s) if you need more than one output parameter
- * in alternative_io
- */
-#define ASM_OUTPUT2(a, b) a, b
-
-struct paravirt_patch;
-#ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
-#else
-static inline void
-apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
-{}
-#define __parainstructions NULL
-#define __parainstructions_end NULL
-#endif
-
-extern void text_poke(void *addr, unsigned char *opcode, int len);
-
-#endif /* _X86_64_ALTERNATIVE_H */
-- 
1.5.3.7

