Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759899AbYLQJTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbYLQJTt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbYLQJT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:19:27 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:25283 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbYLQJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:19:25 -0500
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH last/many] x86: checking framework for correct use of ENTRY/PROC
Date: Wed, 17 Dec 2008 10:17:55 +0100
Message-Id: <1229505475-10219-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
 <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 17 Dec 2008 10:18:32 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.45; VDF: 7.1.0.243; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ DO NOT APPLY (yet...) At this point this patch will
just cause the build to abort due to annotation errors
found. ]

Introduce a checking framework to check correct pairing
of ENTRY/END and PROC/ENDPROC. It also checks that the
annotations are not nested. I have used the ideas and
most of the implementation from Cyrill Gorcunov who
introduced the framework to check for mismatching
KPROBE_ENTRY annotations, which was however soon made
obsolete by the removal of KPROBE_ENTRY/KPROBE_END.

Checks performed:
 o  END must terminate an ENTRY annotation
 o  ENDPROC must terminate a PROC annotation
 o  ENTRY or PROC cannot be nested inside
	another ENTRY or PROC section.

Finally the macro ENTRY_PROC_FINAL is introduced to
enable checking correct closing of PROC and ENTRY
sections at the end of assembly files.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/include/asm/linkage.h |   96 ++++++++++++++++++++++++----------------
 1 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 5d98d0b..299cdf2 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -58,64 +58,84 @@
 #endif
 
 /*
- * to check ENTRY_X86/END_X86 and
- * KPROBE_ENTRY_X86/KPROBE_END_X86
+ * to check ENTRY/END and PROC/ENDPROC
  * unbalanced-missed-mixed appearance
  */
-#define __set_entry_x86		.set ENTRY_X86_IN, 0
-#define __unset_entry_x86	.set ENTRY_X86_IN, 1
-#define __set_kprobe_x86	.set KPROBE_X86_IN, 0
-#define __unset_kprobe_x86	.set KPROBE_X86_IN, 1
-
-#define __macro_err_x86 .error "ENTRY_X86/KPROBE_X86 unbalanced,missed,mixed"
-
-#define __check_entry_x86	\
-	.ifdef ENTRY_X86_IN;	\
-	.ifeq ENTRY_X86_IN;	\
-	__macro_err_x86;	\
-	.abort;			\
+#ifdef __ASSEMBLER__
+#define __set_entry		.set ENTRY_IN, 0
+#define __unset_entry		.set ENTRY_IN, 1
+#define __set_proc		.set PROC_IN, 0
+#define __unset_proc		.set PROC_IN, 1
+
+#define __macro_err \
+	.error "ENTRY/PROC unbalanced,missed,mixed"; \
+	.abort
+
+#define __check_entry		\
+	.ifdef ENTRY_IN;	\
+	.ifeq ENTRY_IN;		\
+	__macro_err;		\
 	.endif;			\
 	.endif
 
-#define __check_kprobe_x86	\
-	.ifdef KPROBE_X86_IN;	\
-	.ifeq KPROBE_X86_IN;	\
-	__macro_err_x86;	\
-	.abort;			\
+#define __check_in_entry	\
+	.ifndef ENTRY_IN;	\
+	__macro_err;		\
+	.else;			\
+	.ifeq !ENTRY_IN;	\
+	__macro_err;		\
 	.endif;			\
 	.endif
 
-#define __check_entry_kprobe_x86	\
-	__check_entry_x86;		\
-	__check_kprobe_x86
+#define __check_proc		\
+	.ifdef PROC_IN;		\
+	.ifeq PROC_IN;		\
+	__macro_err;		\
+	.endif;			\
+	.endif
 
-#define ENTRY_KPROBE_FINAL_X86 __check_entry_kprobe_x86
+#define __check_in_proc		\
+	.ifndef PROC_IN;	\
+	__macro_err;		\
+	.else;			\
+	.ifeq !PROC_IN;		\
+	__macro_err;		\
+	.endif;			\
+	.endif
 
-#define ENTRY_X86(name)			\
-	__check_entry_kprobe_x86;	\
-	__set_entry_x86;		\
+#define __check_entry_proc	\
+	__check_entry;		\
+	__check_proc
+
+#define ENTRY_PROC_FINAL __check_entry_proc
+
+#define ENTRY(name)			\
+	__check_entry_proc;		\
+	__set_entry;			\
 	.globl name;			\
 	__ALIGN;			\
 	name:
 
-#define END_X86(name)			\
-	__unset_entry_x86;		\
-	__check_entry_kprobe_x86;	\
+#define END(name)			\
+	__check_in_entry;		\
+	__unset_entry;			\
+	__check_entry_proc;		\
 	.size name, .-name
 
-#define KPROBE_ENTRY_X86(name)		\
-	__check_entry_kprobe_x86;	\
-	__set_kprobe_x86;		\
-	.pushsection .kprobes.text, "ax"; \
+#define PROC(name)			\
+	__check_entry_proc;		\
+	__set_proc;			\
 	.globl name;			\
 	__ALIGN;			\
 	name:
 
-#define KPROBE_END_X86(name)		\
-	__unset_kprobe_x86;		\
-	__check_entry_kprobe_x86;	\
-	.size name, .-name;		\
-	.popsection
+#define ENDPROC(name)			\
+	__check_in_proc;		\
+	__unset_proc;			\
+	__check_entry_proc;		\
+	.type name, @function;		\
+	.size name, .-name
+#endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_X86_LINKAGE_H */
 
-- 
1.5.4.3

