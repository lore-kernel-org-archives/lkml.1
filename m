Return-Path: <linux-kernel-owner+w=401wt.eu-S1422827AbXCOGGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422827AbXCOGGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422829AbXCOGGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:06:42 -0400
Received: from gw.goop.org ([64.81.55.164]:56875 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422827AbXCOGGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:06:42 -0400
Message-ID: <45F8E272.2030903@goop.org>
Date: Wed, 14 Mar 2007 23:06:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Clean up ELF note generation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Three cleanups:

1: ELF notes are never mapped, so there's no need to have any access
flags in their phdr.

2: When generating them from asm, tell the assembler to use a SHT_NOTE
section type.  There doesn't seem to be a way to do this from C.

3: Use ANSI rather than traditional cpp behaviour to stringify the
macro argument.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>

---
 arch/i386/kernel/vmlinux.lds.S    |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/elfnote.h           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -34,7 +34,7 @@ PHDRS {
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(4);	/* R__ */
+	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
 {
===================================================================
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -208,7 +208,7 @@
 	}
 
 #define NOTES								\
-		.notes : { *(.note.*) } :note
+	.notes : { *(.note.*) } :note
 
 #define INITCALLS							\
   	*(.initcall0.init)						\
===================================================================
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
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


