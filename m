Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYKWQPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYKWQPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbYKWQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:14:58 -0500
Received: from qb-out-0506.google.com ([72.14.204.239]:5035 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbYKWQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:14:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=II4eWyZVUWtrrYsn3MhJP8KMvPBGYudNgVAI5DYGNJWhu4UpihnwKzw2vaTCdYeqU+
         h8SXgZiPd8nUsuuef1ifRrslItS8ww2TnGxoNqq7hnkCyMWEQ6FC+2wTeq6RnsZoYxB+
         rgi1gUuu+C5BwLP7vgIqWPsTBwFASjlCc5h9U=
Date: Sun, 23 Nov 2008 19:14:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] x86: introduce X86_ assembly names macros to catch
	unbalanced declaration
Message-ID: <20081123161455.GE27396@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's usefull to catch unbalanced or messed declarations of ENTRY and
KPROBES. These macros would help a bit (at least I hope so).

For example the following code would compile without problems

	X86_ENTRY(mcount)
		retq
	X86_END(mcount)

But if you forget and mess the following form

	X86_ENTRY(mcount)
		retq
	END(mcount)

	X86_ENTRY(ftrace_caller)

The assembler will issue the following message:
Error: X86_ENTRY/KPROBE unbalanced or missed

Actually the checking is performed at every X86_ macro
so maybe it's good idea to put __x86_check_entry_kprobe
at the end of .S file to be sure you didn't miss anything.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Anyway -- it's just a RFC -- so I hope there will not be much
screams of hate :-)

 arch/x86/include/asm/linkage.h |   58 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/linkage.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/linkage.h
+++ linux-2.6.git/arch/x86/include/asm/linkage.h
@@ -57,5 +57,63 @@
 #define __ALIGN_STR ".align 16,0x90"
 #endif
 
+/*
+ * to check X86_ENTRY/X86_END and
+ * X86_KPROBE_ENTRY/X86_KPROBE_END
+ * unbalanced/messed appearance
+ */
+#define __x86_set_entry   .set _X86_ENTRY_IN, 0
+#define __x86_unset_entry .set _X86_ENTRY_IN, 1
+#define __x86_set_kprobe  .set _X86_KPROBE_IN, 0
+#define __x86_unset_kprobe .set _X86_KPROBE_IN, 1
+
+#define __x86_macro_err .error "X86_ENTRY/KPROBE unbalanced or missed"
+
+#define __x86_check_entry	\
+	.ifdef _X86_ENTRY_IN;	\
+	.ifeq _X86_ENTRY_IN;	\
+	__x86_macro_err;	\
+	.abort;			\
+	.endif;			\
+	.endif
+
+#define __x86_check_kprobe	\
+	.ifdef _X86_KPROBE_IN;	\
+	.ifeq _X86_KPROBE_IN;	\
+	__x86_macro_err;	\
+	.abort;			\
+	.endif;			\
+	.endif
+
+#define __x86_check_entry_kprobe	\
+	__x86_check_entry;		\
+	__x86_check_kprobe
+
+#define X86_ENTRY(name)			\
+	__x86_check_entry_kprobe;	\
+	__x86_set_entry;		\
+	.globl name;			\
+	__ALIGN;			\
+	name:
+
+#define X86_KPROBE_ENTRY(name)		\
+	__x86_check_entry_kprobe;	\
+	__x86_set_kprobe;		\
+	.pushsection .kprobes.text, "ax"; \
+	.globl name;			\
+	__ALIGN;			\
+	name:
+
+#define X86_KPROBE_END(name)		\
+	__x86_unset_kprobe;		\
+	__x86_check_entry_kprobe;	\
+	.size name, .-name;		\
+	.popsection
+
+#define X86_END(name)			\
+	__x86_unset_entry;		\
+	__x86_check_entry_kprobe;	\
+	.size name, .-name
+
 #endif /* _ASM_X86_LINKAGE_H */
 
