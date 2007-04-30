Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXD3Kan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXD3Kan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXD3K3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:42 -0400
Received: from mx1.suse.de ([195.135.220.2]:51257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965528AbXD3K2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:16 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, ebiederm@xmission.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [40/40] i386: Clean up ELF note generation
Message-Id: <20070430102815.8E5D7151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Three cleanups:

1: ELF notes are never mapped, so there's no need to have any access
flags in their phdr.

2: When generating them from asm, tell the assembler to use a SHT_NOTE
section type.  There doesn't seem to be a way to do this from C.

3: Use ANSI rather than traditional cpp behaviour to stringify the
macro argument.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>

---
 arch/i386/kernel/vmlinux.lds.S    |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/elfnote.h           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux/arch/i386/kernel/vmlinux.lds.S
@@ -30,7 +30,7 @@ jiffies = jiffies_64;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(4);	/* R__ */
+	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
 {
Index: linux/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.orig/include/asm-generic/vmlinux.lds.h
+++ linux/include/asm-generic/vmlinux.lds.h
@@ -208,7 +208,7 @@
 	}
 
 #define NOTES								\
-		.notes : { *(.note.*) } :note
+	.notes : { *(.note.*) } :note
 
 #define INITCALLS							\
   	*(.initcall0.init)						\
Index: linux/include/linux/elfnote.h
===================================================================
--- linux.orig/include/linux/elfnote.h
+++ linux/include/linux/elfnote.h
@@ -39,12 +39,12 @@
  *      ELFNOTE(XYZCo, 12, .long, 0xdeadbeef)
  */
 #define ELFNOTE(name, type, desctype, descdata)	\
-.pushsection .note.name			;	\
+.pushsection .note.name, "",@note	;	\
   .align 4				;	\
   .long 2f - 1f		/* namesz */	;	\
   .long 4f - 3f		/* descsz */	;	\
   .long type				;	\
-1:.asciz "name"				;	\
+1:.asciz #name				;	\
 2:.align 4				;	\
 3:desctype descdata			;	\
 4:.align 4				;	\
