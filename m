Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYIZVzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYIZVzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYIZVzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:55:40 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4557 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYIZVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:55:39 -0400
Date: Fri, 26 Sep 2008 23:55:37 +0200
From: Joris van Rantwijk <jorispubl@xs4all.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Inflation of vmlinux by linker on x86_64
Message-ID: <20080926215537.GA31124@xs4all.nl>
References: <20080926124222.GA49837@xs4all.nl> <48DD2F68.6000609@zytor.com> <eb34240721c0b92818908672eccecf62@xs4all.nl> <48DD40EF.4000107@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DD40EF.4000107@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 01:07:11PM -0700, H. Peter Anvin wrote:
> In this case, I think the easiest thing to do is to provide an optimized 
> memmove and not making it a static function.  I have a reasonably 
> optimized memmove in 32-bit assembly at:
> http://git.kernel.org/?p=boot/syslinux/syslinux.git;a=blob;f=com32/lib/memmove.S;hb=HEAD

Ok.  Right now, I'd like to focus on the semantics, preferably without
bringing in new assembler code.  I renamed memcpy to memmove and
dropped "static".  We can always replace it with optimized code
as a separate patch.

There is still the question whether linking vmlinux with -n (turn off
file offset alignment) works on all architectures.  I suspect not.

Joris.

diff -urN linux-2.6.27-rc7/Makefile linux-2.6.27-rc7j/Makefile
--- linux-2.6.27-rc7/Makefile	2008-09-26 23:01:41.000000000 +0200
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
--- linux-2.6.27-rc7/arch/x86/boot/compressed/misc.c	2008-09-26 23:01:41.000000000 +0200
+++ linux-2.6.27-rc7j/arch/x86/boot/compressed/misc.c	2008-09-26 23:02:14.000000000 +0200
@@ -27,6 +27,7 @@
 #include <linux/linkage.h>
 #include <linux/screen_info.h>
 #include <linux/elf.h>
+#include <linux/types.h>
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/boot.h>
@@ -122,6 +123,7 @@
 
 #undef memset
 #undef memcpy
+#define memcpy		memmove
 #define memzero(s, n)	memset((s), 0, (n))
 
 typedef unsigned char	uch;
@@ -195,7 +197,7 @@
 static long bytes_out;
 
 static void *memset(void *s, int c, unsigned n);
-static void *memcpy(void *dest, const void *src, unsigned n);
+void *memmove(void *dest, const void *src, size_t n);
 
 static void __putstr(int, const char *);
 #define putstr(__x)  __putstr(0, __x)
@@ -281,13 +283,18 @@
 	return s;
 }
 
-static void *memcpy(void *dest, const void *src, unsigned n)
+/* memmove can not be static due to a declaration in asm-x86/string_32.h */
+void *memmove(void *dest, const void *src, size_t n)
 {
-	int i;
+	size_t i;
 	const char *s = src;
 	char *d = dest;
 
-	for (i = 0; i < n; i++) d[i] = s[i];
+	if (dest <= src) {
+		for (i = 0; i < n; i++) d[i] = s[i];
+	} else {
+		for (i = n; i > 0; i--) d[i-1] = s[i-1];
+	}
 	return dest;
 }
 
@@ -343,8 +350,8 @@
 	Elf32_Ehdr ehdr;
 	Elf32_Phdr *phdrs, *phdr;
 #endif
-	void *dest;
-	int i;
+	void *dest, *src;
+	int i, direction;
 
 	memcpy(&ehdr, output, sizeof(ehdr));
 	if (ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
@@ -364,7 +371,17 @@
 
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
@@ -375,9 +392,14 @@
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
+				memmove(dest, src, phdr->p_filesz);
+			}
+
 			break;
 		default: /* Ignore other PT_* */ break;
 		}
