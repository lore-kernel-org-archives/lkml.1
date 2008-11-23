Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYKWR26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYKWR26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYKWR2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:28:50 -0500
Received: from qb-out-0506.google.com ([72.14.204.236]:15864 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYKWR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=resent-from:resent-date:resent-message-id:resent-to:date:from:to:cc
         :subject:message-id:mime-version:content-type:content-disposition
         :user-agent;
        b=cJJtROHc43CfQWLwsWRbVe34g0hKXIJLEXNCUOJhBrvKfpE5aYQXPTScUm4pUT1bT2
         fyt7zvy4YMamFvM2FNd+JHhpxaP302j2/bCvqV69aSpSVv3OaDN63+IXQdkPIAUWD2b9
         kd5/WXWYQYLNFVwnsiZEk6tzkhxoZ5+ilBu44=
Date: Sun, 23 Nov 2008 20:21:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC -tip] x86: introduce ENTRY(KPROBE_ENTRY)_X86  assembly
	helpers to catch unbalanced declaration v3
Message-ID: <20081123172139.GC12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: improvements

It's usefull to catch unbalanced or messed or mixed declarations of ENTRY and
KPROBES. These macros would help a bit.

For example the following code would compile without problems

        ENTRY_X86(mcount)
                retq
        END_X86(mcount)

But if you forget and mess the following form

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
+	__macro_err_x86;	\
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
 
