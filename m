Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbXCJW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbXCJW1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbXCJW1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:27:22 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50826 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbXCJW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:27:20 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 17:24:45 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101723480.28938@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_CS 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete apparently unused header file include/linux/elfnote.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not sure who's responsible for this.

diff --git a/include/linux/elfnote.h b/include/linux/elfnote.h
deleted file mode 100644
index 67396db..0000000
--- a/include/linux/elfnote.h
+++ /dev/null
@@ -1,90 +0,0 @@
-#ifndef _LINUX_ELFNOTE_H
-#define _LINUX_ELFNOTE_H
-/*
- * Helper macros to generate ELF Note structures, which are put into a
- * PT_NOTE segment of the final vmlinux image.  These are useful for
- * including name-value pairs of metadata into the kernel binary (or
- * modules?) for use by external programs.
- *
- * Each note has three parts: a name, a type and a desc.  The name is
- * intended to distinguish the note's originator, so it would be a
- * company, project, subsystem, etc; it must be in a suitable form for
- * use in a section name.  The type is an integer which is used to tag
- * the data, and is considered to be within the "name" namespace (so
- * "FooCo"'s type 42 is distinct from "BarProj"'s type 42).  The
- * "desc" field is the actual data.  There are no constraints on the
- * desc field's contents, though typically they're fairly small.
- *
- * All notes from a given NAME are put into a section named
- * .note.NAME.  When the kernel image is finally linked, all the notes
- * are packed into a single .notes section, which is mapped into the
- * PT_NOTE segment.  Because notes for a given name are grouped into
- * the same section, they'll all be adjacent the output file.
- *
- * This file defines macros for both C and assembler use.  Their
- * syntax is slightly different, but they're semantically similar.
- *
- * See the ELF specification for more detail about ELF notes.
- */
-
-#ifdef __ASSEMBLER__
-/*
- * Generate a structure with the same shape as Elf{32,64}_Nhdr (which
- * turn out to be the same size and shape), followed by the name and
- * desc data with appropriate padding.  The 'desctype' argument is the
- * assembler pseudo op defining the type of the data e.g. .asciz while
- * 'descdata' is the data itself e.g.  "hello, world".
- *
- * e.g. ELFNOTE(XYZCo, 42, .asciz, "forty-two")
- *      ELFNOTE(XYZCo, 12, .long, 0xdeadbeef)
- */
-#define ELFNOTE(name, type, desctype, descdata)	\
-.pushsection .note.name			;	\
-  .align 4				;	\
-  .long 2f - 1f		/* namesz */	;	\
-  .long 4f - 3f		/* descsz */	;	\
-  .long type				;	\
-1:.asciz "name"				;	\
-2:.align 4				;	\
-3:desctype descdata			;	\
-4:.align 4				;	\
-.popsection				;
-#else	/* !__ASSEMBLER__ */
-#include <linux/elf.h>
-/*
- * Use an anonymous structure which matches the shape of
- * Elf{32,64}_Nhdr, but includes the name and desc data.  The size and
- * type of name and desc depend on the macro arguments.  "name" must
- * be a literal string, and "desc" must be passed by value.  You may
- * only define one note per line, since __LINE__ is used to generate
- * unique symbols.
- */
-#define _ELFNOTE_PASTE(a,b)	a##b
-#define _ELFNOTE(size, name, unique, type, desc)			\
-	static const struct {						\
-		struct elf##size##_note _nhdr;				\
-		unsigned char _name[sizeof(name)]			\
-		__attribute__((aligned(sizeof(Elf##size##_Word))));	\
-		typeof(desc) _desc					\
-			     __attribute__((aligned(sizeof(Elf##size##_Word)))); \
-	} _ELFNOTE_PASTE(_note_, unique)				\
-		__attribute_used__					\
-		__attribute__((section(".note." name),			\
-			       aligned(sizeof(Elf##size##_Word)),	\
-			       unused)) = {				\
-		{							\
-			sizeof(name),					\
-			sizeof(desc),					\
-			type,						\
-		},							\
-		name,							\
-		desc							\
-	}
-#define ELFNOTE(size, name, type, desc)		\
-	_ELFNOTE(size, name, __LINE__, type, desc)
-
-#define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
-#define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
-#endif	/* __ASSEMBLER__ */
-
-#endif /* _LINUX_ELFNOTE_H */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
