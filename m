Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbXEKTKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbXEKTKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbXEKTJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:09:38 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:60049 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758745AbXEKTJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:09:36 -0400
Message-Id: <20070511000026.673875000@goop.org>
References: <20070510235708.155502000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 16:57:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: [patch 2/7] use elfnote.h to generate vsyscall notes.
Content-Disposition: inline; filename=vsyscall-note-use-elfnote_h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use existing elfnote.h to generate vsyscall notes, rather than doing
it locally.  Changes elfnote.h a bit to suite, since this is the first
asm user, and it wasn't quite right.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.com>

---
 arch/i386/kernel/vsyscall-note.S |   23 ++++++-----------------
 arch/x86_64/vdso/vdso-note.S     |    4 ++--
 include/linux/elfnote.h          |   18 +++++++++++++-----
 3 files changed, 21 insertions(+), 24 deletions(-)

===================================================================
--- a/arch/i386/kernel/vsyscall-note.S
+++ b/arch/i386/kernel/vsyscall-note.S
@@ -3,23 +3,12 @@
  * Here we can supply some information useful to userland.
  */
 
-#include <linux/uts.h>
 #include <linux/version.h>
+#include <linux/elfnote.h>
 
-#define ASM_ELF_NOTE_BEGIN(name, flags, vendor, type)			      \
-	.section name, flags;						      \
-	.balign 4;							      \
-	.long 1f - 0f;		/* name length */			      \
-	.long 3f - 2f;		/* data length */			      \
-	.long type;		/* note type */				      \
-0:	.asciz vendor;		/* vendor name */			      \
-1:	.balign 4;							      \
-2:
-
-#define ASM_ELF_NOTE_END						      \
-3:	.balign 4;		/* pad out section */			      \
-	.previous
-
-	ASM_ELF_NOTE_BEGIN(".note.kernel-version", "a", UTS_SYSNAME, 0)
+/* Ideally this would use UTS_NAME, but using a quoted string here
+   doesn't work. Remember to change this when changing the
+   kernel's name. */
+ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
-	ASM_ELF_NOTE_END
+ELFNOTE_END
===================================================================
--- a/arch/x86_64/vdso/vdso-note.S
+++ b/arch/x86_64/vdso/vdso-note.S
@@ -8,5 +8,5 @@
 #include <linux/elfnote.h>
 
 	/* Supply version information to coredumps */
-	ELFNOTE(kernelversion, 0, .long, LINUX_VERSION_CODE)
-	ELFNOTE(os, 0, .asciz, UTS_SYSNAME)
+	ELFNOTE(kernelversion, 0, .long LINUX_VERSION_CODE)
+	ELFNOTE(os, 0, .asciz UTS_SYSNAME)
===================================================================
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -38,17 +38,25 @@
  * e.g. ELFNOTE(XYZCo, 42, .asciz, "forty-two")
  *      ELFNOTE(XYZCo, 12, .long, 0xdeadbeef)
  */
-#define ELFNOTE(name, type, desctype, descdata)	\
-.pushsection .note.name, "",@note	;	\
+#define ELFNOTE_START(name, type, flags)	\
+.pushsection .note.name, flags,@note	;	\
   .align 4				;	\
   .long 2f - 1f		/* namesz */	;	\
-  .long 4f - 3f		/* descsz */	;	\
+  .long 4484f - 3f	/* descsz */	;	\
   .long type				;	\
 1:.asciz #name				;	\
 2:.align 4				;	\
-3:desctype descdata			;	\
-4:.align 4				;	\
+3:
+
+#define ELFNOTE_END				\
+4484:.align 4				;	\
 .popsection				;
+
+#define ELFNOTE(name, type, desc)		\
+	ELFNOTE_START(name, type, "")		\
+		desc			;	\
+	ELFNOTE_END
+
 #else	/* !__ASSEMBLER__ */
 #include <linux/elf.h>
 /*

-- 

