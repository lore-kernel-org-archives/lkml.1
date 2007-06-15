Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbXFOOvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbXFOOvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXFOOtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:49:15 -0400
Received: from gw.goop.org ([64.81.55.164]:34391 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbXFOOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:49:08 -0400
Message-Id: <20070615005013.299061098@goop.org>
References: <20070615004818.424726597@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 17:48:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: [PATCH 07/10] always allocate space for notes
Content-Disposition: inline; filename=elfnote-alloc.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes .note segments always allocated; that is, they are
loaded as part of the binary and appear in the :data segment.  This is
not always necessary, but certain users - such as vsyscalls and notes
in boot images - require the notes to be allocated.  Rather than
having two ways of creating notes, just have one which suits
everyone.  The only downside is that the notes will actually consume
space at runtime.  This isn't a big deal, since a typical kernel
doesn't have very many, if any.

Also, make the ELFNOTE() macro do the right thing in 32/64 bit
environments.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/vmlinux.lds.S    |    9 ++++-----
 arch/i386/kernel/vsyscall-note.S  |    4 +---
 include/asm-generic/vmlinux.lds.h |    7 ++++++-
 include/linux/elfnote.h           |   21 ++++++++++++++-------
 4 files changed, 25 insertions(+), 16 deletions(-)

===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -28,10 +28,9 @@ jiffies = jiffies_64;
 jiffies = jiffies_64;
 
 PHDRS {
-	text PT_LOAD FLAGS(5);	/* R_E */
-	data PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(0);	/* ___ */
+	STD_PHDRS
 }
+
 SECTIONS
 {
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
@@ -72,6 +71,8 @@ SECTIONS
   _sdata = .;			/* End of text section */
 
   RODATA
+
+  NOTES
 
   /* writeable */
   . = ALIGN(4096);
@@ -210,6 +211,4 @@ SECTIONS
   STABS_DEBUG
 
   DWARF_DEBUG
-
-  NOTES
 }
===================================================================
--- a/arch/i386/kernel/vsyscall-note.S
+++ b/arch/i386/kernel/vsyscall-note.S
@@ -9,9 +9,7 @@
 /* Ideally this would use UTS_NAME, but using a quoted string here
    doesn't work. Remember to change this when changing the
    kernel's name. */
-ELFNOTE_START(Linux, 0, "a")
-	.long LINUX_VERSION_CODE
-ELFNOTE_END
+ELFNOTE(Linux, 0, .long LINUX_VERSION_CODE)
 
 #ifdef CONFIG_XEN
 
===================================================================
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -245,8 +245,13 @@
 		__stop___bug_table = .;					\
 	}
 
+#define STD_PHDRS							\
+	text PT_LOAD FILEHDR PHDRS FLAGS(5);	/* R_E */		\
+	data PT_LOAD FLAGS(7);			/* RWE */		\
+	note PT_NOTE FLAGS(0);			/* ___ */
+
 #define NOTES								\
-	.notes : { *(.note.*) } :note
+	.notes : { *(.note.*) } :data :note
 
 #define INITCALLS							\
   	*(.initcall0.init)						\
===================================================================
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -53,7 +53,7 @@ 4484:.balign 4				;	\
 .popsection				;
 
 #define ELFNOTE(name, type, desc)		\
-	ELFNOTE_START(name, type, "")		\
+	ELFNOTE_START(name, type, "a")		\
 		desc			;	\
 	ELFNOTE_END
 
@@ -67,8 +67,8 @@ 4484:.balign 4				;	\
  * only define one note per line, since __LINE__ is used to generate
  * unique symbols.
  */
-#define _ELFNOTE_PASTE(a,b)	a##b
-#define _ELFNOTE(size, name, unique, type, desc)			\
+#define __ELFNOTE_PASTE(a,b)	a##b
+#define __ELFNOTE(size, name, unique, type, desc)			\
 	static const struct {						\
 		struct elf##size##_note _nhdr;				\
 		unsigned char _name[sizeof(name)]			\
@@ -88,11 +88,18 @@ 4484:.balign 4				;	\
 		name,							\
 		desc							\
 	}
-#define ELFNOTE(size, name, type, desc)		\
-	_ELFNOTE(size, name, __LINE__, type, desc)
 
-#define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
-#define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
+#define ELFNOTE32(name, type, desc) __ELFNOTE(32, name, __LINE__, type, desc)
+#define ELFNOTE64(name, type, desc) __ELFNOTE(64, name, __LINE__, type, desc)
+
+#ifdef BITS_PER_LONG == 32
+#define ELFNOTE(name, type, desc)	ELFNOTE32(name, type, desc)
+#elif BITS_PER_LONG == 64
+#define ELFNOTE(name, type, desc)	ELFNOTE64(name, type, desc)
+#else
+#error Define ELFNOTE for this BITS_PER_LONG
+#endif
+
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _LINUX_ELFNOTE_H */

-- 

