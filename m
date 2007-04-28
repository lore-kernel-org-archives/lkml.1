Return-Path: <linux-kernel-owner+w=401wt.eu-S1030935AbXD1CVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030935AbXD1CVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030936AbXD1CVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:21:54 -0400
Received: from gw.goop.org ([64.81.55.164]:49714 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030935AbXD1CVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:21:50 -0400
Message-ID: <4632AFBF.8020602@goop.org>
Date: Fri, 27 Apr 2007 19:21:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] use elfnote.h to generate vsyscall notes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use existing elfnote.h to generate vsyscall notes, rather than doing
it locally.  Changes elfnote.h a bit to suite, since this is the first
asm user, and it wasn't quite right.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>

---
 arch/i386/kernel/vsyscall-note.S |   23 ++++++-----------------
 include/linux/elfnote.h          |   18 +++++++++++++-----
 2 files changed, 19 insertions(+), 22 deletions(-)

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


