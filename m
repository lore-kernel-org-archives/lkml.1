Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZL3MXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZL3MXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZL3MXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:23:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:42504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZL3MXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:23:32 -0500
Date: Wed, 30 Dec 2009 12:22:21 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, npiggin@suse.de, jbeulich@novell.com,
       akpm@linux-foundation.org, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: npiggin@suse.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jbeulich@novell.com, torvalds@linux-foundation.org, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B2BB8180200007800026AE7@vpn.id2.novell.com>
References: <4B2BB8180200007800026AE7@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Modify copy_user_generic() alternatives mechanism
Message-ID: <tip-1b1d9258181bae199dc940f4bd0298126b9a73d9@git.kernel.org>
Git-Commit-ID: 1b1d9258181bae199dc940f4bd0298126b9a73d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b1d9258181bae199dc940f4bd0298126b9a73d9
Gitweb:     http://git.kernel.org/tip/1b1d9258181bae199dc940f4bd0298126b9a73d9
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 18 Dec 2009 16:12:56 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 11:57:31 +0100

x86-64: Modify copy_user_generic() alternatives mechanism

In order to avoid unnecessary chains of branches, rather than
implementing copy_user_generic() as a function consisting of
just a single (possibly patched) branch, instead properly deal
with patching call instructions in the alternative instructions
framework, and move the patching into the callers.

As a follow-on, one could also introduce something like
__EXPORT_SYMBOL_ALT() to avoid patching call sites in modules.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4B2BB8180200007800026AE7@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/alternative.h |    7 ++++++-
 arch/x86/include/asm/uaccess_64.h  |   21 ++++++++++++++++++++-
 arch/x86/kernel/alternative.c      |    4 +++-
 arch/x86/kernel/x8664_ksyms_64.c   |    3 ++-
 arch/x86/lib/copy_user_64.S        |    6 ------
 5 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 69b74a7..3b5b828 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -125,11 +125,16 @@ static inline void alternatives_smp_switch(int smp) {}
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
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 46324c6..a78c403 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
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
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index de7353c..2589ea4 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -205,7 +205,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 					 struct alt_instr *end)
 {
 	struct alt_instr *a;
-	char insnbuf[MAX_PATCH_LEN];
+	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
 	for (a = start; a < end; a++) {
@@ -223,6 +223,8 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		}
 #endif
 		memcpy(insnbuf, a->replacement, a->replacementlen);
+		if (*insnbuf == 0xe8 && a->replacementlen == 5)
+		    *(s32 *)(insnbuf + 1) += a->replacement - a->instr;
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
 		text_poke_early(instr, insnbuf, a->instrlen);
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 619f7f8..693920b 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -26,7 +26,8 @@ EXPORT_SYMBOL(__put_user_2);
 EXPORT_SYMBOL(__put_user_4);
 EXPORT_SYMBOL(__put_user_8);
 
-EXPORT_SYMBOL(copy_user_generic);
+EXPORT_SYMBOL(copy_user_generic_string);
+EXPORT_SYMBOL(copy_user_generic_unrolled);
 EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(_copy_from_user);
 EXPORT_SYMBOL(_copy_to_user);
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index cf889d4..71100c9 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
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
