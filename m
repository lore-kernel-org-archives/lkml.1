Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXEAIAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXEAIAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965662AbXEAIAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:00:24 -0400
Received: from gw.goop.org ([64.81.55.164]:60296 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965657AbXEAIAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:00:21 -0400
Message-ID: <4636F3A5.6070808@goop.org>
Date: Tue, 01 May 2007 01:00:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/30] x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu
References: <20070501557.815359000@suse.de> <20070501035805.9FA9513CAF@wotan.suse.de> <4636D6E5.8090006@goop.org> <200705010923.33771.ak@suse.de>
In-Reply-To: <200705010923.33771.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Use linux/elfnote.h?
>>     
>
> Good point. Will fix. I just copied it from i386, but it probably
> should be there fixed too.
>   

Already has been.  I posted a patch a day or so ago (reposted below).

> Actually they are not completely equivalent because the old macro
> generates the section name differently from the name in the payload
> (kernelversion, Linux). But I split that up into two notes now.
>   

Roland agreed that it doesn't matter.

> If that is done on i386 it might break gdb reading core files though?
>   

No.  The notename in the final output is the same either way.  The
linker packs .note.* into a single .note section.

Subject: use elfnote.h to generate vsyscall notes.

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

    J
