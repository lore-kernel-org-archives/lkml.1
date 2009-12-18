Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZLRQML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZLRQML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZLRQMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:12:09 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:40342 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZLRQME convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 18 Dec 2009 11:12:04 -0500
Message-Id: <4B2BB8180200007800026AE7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Dec 2009 16:12:56 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: modify copy_user_generic() alternatives
	 mechanism
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid unnecessary chains of branches, rather than
implementing copy_user_generic() as a function consisting of just a
single (possibly patched) branch, instead properly deal with patching
call instructions in the alternative instructions framework, and
move the patching into the callers.

As a follow-on, one could also introduce something like
__EXPORT_SYMBOL_ALT() to avoid patching call sites in modules.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 arch/x86/include/asm/alternative.h |    7 ++++++-
 arch/x86/include/asm/uaccess_64.h  |   21 ++++++++++++++++++++-
 arch/x86/kernel/alternative.c      |    4 +++-
 arch/x86/kernel/x8664_ksyms_64.c   |    3 ++-
 arch/x86/lib/copy_user_64.S        |    6 ------
 5 files changed, 31 insertions(+), 10 deletions(-)

--- linux-2.6.33-rc1/arch/x86/include/asm/alternative.h	2009-12-18 16:16:12.000000000 +0100
+++ 2.6.33-rc1-x86_64-copy_user_generic-alternative/arch/x86/include/asm/alternative.h	2009-12-04 12:19:20.000000000 +0100
@@ -125,11 +125,16 @@ static inline void alternatives_smp_swit
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
 		: output : "i" (0), ## input)
 
+/* Like alternative_io, but for replacing a direct call with another one. */
+#define alternative_call(oldfunc, newfunc, feature, output, input...)	\
+	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
+		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
+
 /*
  * use this macro(s) if you need more than one output parameter
  * in alternative_io
  */
-#define ASM_OUTPUT2(a, b) a, b
+#define ASM_OUTPUT2(a...) a
 
 struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
--- linux-2.6.33-rc1/arch/x86/include/asm/uaccess_64.h	2009-12-18 16:16:12.000000000 +0100
+++ 2.6.33-rc1-x86_64-copy_user_generic-alternative/arch/x86/include/asm/uaccess_64.h	2009-12-04 12:19:20.000000000 +0100
@@ -8,6 +8,8 @@
 #include <linux/errno.h>
 #include <linux/prefetch.h>
 #include <linux/lockdep.h>
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
 #include <asm/page.h>
 
 /*
@@ -16,7 +18,24 @@
 
 /* Handles exceptions in both to and from, but doesn't do access_ok */
 __must_check unsigned long
-copy_user_generic(void *to, const void *from, unsigned len);
+copy_user_generic_string(void *to, const void *from, unsigned len);
+__must_check unsigned long
+copy_user_generic_unrolled(void *to, const void *from, unsigned len);
+
+static __always_inline __must_check unsigned long
+copy_user_generic(void *to, const void *from, unsigned len)
+{
+	unsigned ret;
+
+	alternative_call(copy_user_generic_unrolled,
+			 copy_user_generic_string,
+			 X86_FEATURE_REP_GOOD,
+			 ASM_OUTPUT2("=a" (ret), "=D" (to), "=S" (from),
+				     "=d" (len)),
+			 "1" (to), "2" (from), "3" (len)
+			 : "memory", "rcx", "r8", "r9", "r10", "r11");
+	return ret;
+}
 
 __must_check unsigned long
 _copy_to_user(void __user *to, const void *from, unsigned len);
--- linux-2.6.33-rc1/arch/x86/kernel/alternative.c	2009-12-03 04:51:21.000000000 +0100
+++ 2.6.33-rc1-x86_64-copy_user_generic-alternative/arch/x86/kernel/alternative.c	2009-12-04 12:19:20.000000000 +0100
@@ -205,7 +205,7 @@ void __init_or_module apply_alternatives
 					 struct alt_instr *end)
 {
 	struct alt_instr *a;
-	char insnbuf[MAX_PATCH_LEN];
+	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
 	for (a = start; a < end; a++) {
@@ -223,6 +223,8 @@ void __init_or_module apply_alternatives
 		}
 #endif
 		memcpy(insnbuf, a->replacement, a->replacementlen);
+		if (*insnbuf == 0xe8 && a->replacementlen == 5)
+		    *(s32 *)(insnbuf + 1) += a->replacement - a->instr;
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
 		text_poke_early(instr, insnbuf, a->instrlen);
--- linux-2.6.33-rc1/arch/x86/kernel/x8664_ksyms_64.c	2009-12-18 16:16:13.000000000 +0100
+++ 2.6.33-rc1-x86_64-copy_user_generic-alternative/arch/x86/kernel/x8664_ksyms_64.c	2009-12-04 12:19:20.000000000 +0100
@@ -26,7 +26,8 @@ EXPORT_SYMBOL(__put_user_2);
 EXPORT_SYMBOL(__put_user_4);
 EXPORT_SYMBOL(__put_user_8);
 
-EXPORT_SYMBOL(copy_user_generic);
+EXPORT_SYMBOL(copy_user_generic_string);
+EXPORT_SYMBOL(copy_user_generic_unrolled);
 EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(_copy_from_user);
 EXPORT_SYMBOL(_copy_to_user);
--- linux-2.6.33-rc1/arch/x86/lib/copy_user_64.S	2009-12-18 16:16:13.000000000 +0100
+++ 2.6.33-rc1-x86_64-copy_user_generic-alternative/arch/x86/lib/copy_user_64.S	2009-12-04 12:19:20.000000000 +0100
@@ -90,12 +90,6 @@ ENTRY(_copy_from_user)
 	CFI_ENDPROC
 ENDPROC(_copy_from_user)
 
-ENTRY(copy_user_generic)
-	CFI_STARTPROC
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
-	CFI_ENDPROC
-ENDPROC(copy_user_generic)
-
 	.section .fixup,"ax"
 	/* must zero dest */
 ENTRY(bad_from_user)


