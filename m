Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYIZM6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYIZM6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYIZM4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:56:21 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4780 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYIZM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:56:20 -0400
X-Greylist: delayed 834 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 08:56:19 EDT
Date: Fri, 26 Sep 2008 14:42:22 +0200
From: Joris van Rantwijk <jorispubl@xs4all.nl>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: Inflation of vmlinux by linker on x86_64
Message-ID: <20080926124222.GA49837@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I noticed that a lot of space in the uncompressed vmlinux image is
taken up by alignment issues, at least on x86_64. For example, the
linker decides to align the first section on a 2 MB file offset,
thereby inserting almost 2 MB of zeroes at the beginning of vmlinux.

Idx Name   Size      VMA               LMA               File off  Algn
  0 .text  001d9203  ffffffff80200000  0000000000200000  00200000  2**12
           CONTENTS, ALLOC, LOAD, READONLY, CODE

It seems this has gotten worse with recent versions of binutils;
ld 2.18 makes my vmlinux 2 MB larger than ld 2.17.

This inflation of vmlinux causes problems with certain boot loader
configurations, where decompression of the huge vmlinux may overwrite
part of an initramfs image.
See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=479101

Although alignment of memory addresses is required, alignment of
file offsets in vmlinux seems completely unnecessary. After all,
vmlinux is not a demand paged binary. I tried to avoid the alignment
by adding "-n" to the linker command line. This resulted in a 4 MB
reduction of vmlinux, and an immediate crash on boot.

The crash is caused by the ELF loader in x86/boot/compressed/misc.c:
parts of the kernel are memcpy-ed over themselves. This was previously
not an issue because the inflation of vmlinux provided so much slack
that all memcpy-s would turn out in the right direction.

After fixing the ELF loader, it now seems to work quite well.
vmlinux is 4 MB smaller, bzImage is 10 kB smaller and my problems
with LILO are solved.

Would it be appropriate to put this in the kernel?
Note that I am not at all sure that "ld -n" works on all architectures;
I only tested this on i386 and x86_64.

Greetings, Joris.

diff -urN linux-2.6.27-rc7/Makefile linux-2.6.27-rc7j/Makefile
--- linux-2.6.27-rc7/Makefile	2008-09-22 00:29:55.000000000 +0200
+++ linux-2.6.27-rc7j/Makefile	2008-09-26 12:21:34.000000000 +0200
@@ -577,7 +577,7 @@
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
 			      $(call ld-option, -Wl$(comma)--build-id,))
 LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
-LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
+LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID) -n
 
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
diff -urN linux-2.6.27-rc7/arch/x86/boot/compressed/misc.c linux-2.6.27-rc7j/arch/x86/boot/compressed/misc.c
--- linux-2.6.27-rc7/arch/x86/boot/compressed/misc.c	2008-09-22 00:29:55.000000000 +0200
+++ linux-2.6.27-rc7j/arch/x86/boot/compressed/misc.c	2008-09-26 13:20:35.000000000 +0200
@@ -281,13 +281,18 @@
 	return s;
 }
 
+/* This memcpy can handle overlapping dest and src, like memmove. */
 static void *memcpy(void *dest, const void *src, unsigned n)
 {
 	int i;
 	const char *s = src;
 	char *d = dest;
 
-	for (i = 0; i < n; i++) d[i] = s[i];
+	if (dest <= src) {
+		for (i = 0; i < n; i++) d[i] = s[i];
+	} else {
+		for (i = n - 1; i >= 0; i--) d[i] = s[i];
+	}
 	return dest;
 }
 
@@ -343,8 +348,8 @@
 	Elf32_Ehdr ehdr;
 	Elf32_Phdr *phdrs, *phdr;
 #endif
-	void *dest;
-	int i;
+	void *dest, *src;
+	int i, direction;
 
 	memcpy(&ehdr, output, sizeof(ehdr));
 	if (ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
@@ -364,7 +369,17 @@
 
 	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
 
-	for (i = 0; i < ehdr.e_phnum; i++) {
+	/* Go two times through the list of program headers;
+	 * first forward, then backward.
+	 */
+	for (i = 0, direction = 1; i >= 0; i += direction) {
+
+		if (i >= ehdr.e_phnum) {
+			/* reached the end; turn back */
+			direction = -1;
+			continue;
+		}
+
 		phdr = &phdrs[i];
 
 		switch (phdr->p_type) {
@@ -375,9 +390,17 @@
 #else
 			dest = (void *)(phdr->p_paddr);
 #endif
-			memcpy(dest,
-			       output + phdr->p_offset,
-			       phdr->p_filesz);
+			src = output + phdr->p_offset;
+
+			/* order the copying to avoid overwriting */
+			if ((direction == 1  && dest <= src) ||
+			    (direction == -1 && dest > src)) {
+				/* note: unlike standard memcpy, this one
+				 * is safe to use when dest and src overlap.
+				 */
+				memcpy(dest, src, phdr->p_filesz);
+			}
+
 			break;
 		default: /* Ignore other PT_* */ break;
 		}
