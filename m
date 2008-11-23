Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYKWQ5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYKWQ5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYKWQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:57:14 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:12728 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYKWQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:57:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=A/tJYZa5iDxPKo+F4ahlhvffqBERet17ZBk+JvYQjZNzwB1alo5jYTRGcco8+eVU4m
         n5XSvrlMNIr5MqFYV0ZFJbXrOG70e+GjBdh0OVZW4sHLltCe+vX2SGazz0FqhtCeW2e4
         tj8qd5kK84ABaL12sFcxqYxaC0lp9agw8u7Os=
Date: Sun, 23 Nov 2008 19:57:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers to
	catch unbalanced declaration
Message-ID: <20081123165711.GA12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's usefull to catch unbalanced, missed or mixed declarations of ENTRY and
KPROBES. These macros would help a bit (at least I hope so).

For example the following code would compile without problems

        ENTRY_X86(mcount)
                retq
        END_X86(mcount)

But if you forget and mix the following form

        ENTRY_X86(mcount)
                retq
        END(mcount)

        ENTRY_X86(ftrace_caller)

The assembler will issue the following message:
Error: ENTRY_X86/KPROBE_X86 unbalanced,missed,mixed

Actually the checking is performed at every _X86 macro
so maybe it's good idea to put ENTRY_KPROBE_FINAL_X86
at the end of .S file to be sure you didn't miss anything.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/include/asm/linkage.h |   60 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/linkage.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/linkage.h
+++ linux-2.6.git/arch/x86/include/asm/linkage.h
@@ -57,5 +57,65 @@
 #define __ALIGN_STR ".align 16,0x90"
 #endif
 
+/*
+ * to check ENTRY_X86/END_X86 and
+ * KPROBE_ENTRY_X86/KPROBE_END_X86
+ * unbalanced-missed-mixed appearance
+ */
+#define __set_entry_x86		.set ENTRY_X86_IN, 0
+#define __unset_entry_x86	.set ENTRY_X86_IN, 1
+#define __set_kprobe_x86	.set KPROBE_X86_IN, 0
+#define __unset_kprobe_x86	.set KPROBE_X86_IN, 1
+
+#define __macro_err_x86 .error "ENTRY_X86/KPROBE_X86 unbalanced,missed,mixed"
+
+#define __check_entry_x86	\
+	.ifdef ENTRY_X86_IN;	\
+	.ifeq ENTRY_X86_IN;	\
+	__macro_err_x86;	\
+	.abort;			\
+	.endif;			\
+	.endif
+
+#define __check_kprobe_x86	\
+	.ifdef KPROBE_X86_IN;	\
+	.ifeq KPROBE_X86_IN;	\
+	__x86_macro_err;	\
+	.abort;			\
+	.endif;			\
+	.endif
+
+#define __check_entry_kprobe_x86	\
+	__check_entry_x86;		\
+	__check_kprobe_x86
+
+#define ENTRY_KPROBE_FINAL_X86 __check_entry_kprobe_x86
+
+#define ENTRY_X86(name)			\
+	__check_entry_kprobe_x86;	\
+	__set_entry_x86;		\
+	.globl name;			\
+	__ALIGN;			\
+	name:
+
+#define END_X86(name)			\
+	__unset_entry_x86;		\
+	__check_entry_kprobe_x86;	\
+	.size name, .-name
+
+#define KPROBE_ENTRY_X86(name)		\
+	__check_entry_kprobe_x86;	\
+	__set_kprobe_x86;		\
+	.pushsection .kprobes.text, "ax"; \
+	.globl name;			\
+	__ALIGN;			\
+	name:
+
+#define KPROBE_END_X86(name)		\
+	__unset_kprobe_x86;		\
+	__check_entry_kprobe_x86;	\
+	.size name, .-name;		\
+	.popsection
+
 #endif /* _ASM_X86_LINKAGE_H */
 
