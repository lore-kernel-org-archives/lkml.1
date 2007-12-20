Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXLTUJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXLTUJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbXLTUJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:09:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbXLTUJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:09:08 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 05/15] change assembly definition of paravirt_patch_site
Date: Thu, 20 Dec 2007 18:04:00 -0200
Message-Id: <1198181224677-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1198181215625-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To account for differences in x86_64, we change the macros that
create raw instances of the paravirt_patch_site struct.
We need to align 64-pointers to 64-bit boundaries, so we add an alignment
directive. Also, we need to make room for a word-sized pointer,
instead of a fixed 32-bit one

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:22.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:07:25.000000000 -0800
@@ -5,6 +5,7 @@
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/page.h>
+#include <asm/asm.h>
 
 /* Bitmask of what can be clobbered: usually at least eax. */
 #define CLBR_NONE 0x0
@@ -281,7 +282,8 @@
 #define _paravirt_alt(insn_string, type, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\
 	".pushsection .parainstructions,\"a\"\n"	\
-	"  .long 771b\n"				\
+	_ASM_ALIGN "\n"					\
+	_ASM_PTR " 771b\n"				\
 	"  .byte " type "\n"				\
 	"  .byte 772b-771b\n"				\
 	"  .short " clobber "\n"			\
@@ -1159,17 +1161,25 @@
 
 #define PARA_PATCH(struct, off)	((PARAVIRT_PATCH_##struct + (off)) / 4)
 
-#define PARA_SITE(ptype, clobbers, ops)		\
+#define _PVSITE(ptype, clobbers, ops, word, algn)	\
 771:;						\
 	ops;					\
 772:;						\
 	.pushsection .parainstructions,"a";	\
-	 .long 771b;				\
+	 .align	algn;				\
+	 word 771b;				\
 	 .byte ptype;				\
 	 .byte 772b-771b;			\
 	 .short clobbers;			\
 	.popsection
 
+
+#ifdef CONFIG_X86_64
+#define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .quad, 8)
+#else
+#define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .long, 4)
+#endif
+
 #define INTERRUPT_RETURN						\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
 		  jmp *%cs:pv_cpu_ops+PV_CPU_iret)
