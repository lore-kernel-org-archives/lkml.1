Return-Path: <linux-kernel-owner+w=401wt.eu-S1030748AbXCHWF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030748AbXCHWF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030749AbXCHWFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:05:55 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:56664 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030748AbXCHWFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:05:54 -0500
Date: Thu, 8 Mar 2007 23:01:57 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: dmitry.torokhov@gmail.com, Christoph Hellwig <hch@infradead.org>,
       Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris 11_snv
In-Reply-To: <20070308212512.GA10584@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.61.0703082242020.521@yvahk01.tjqt.qr>
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org>
 <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr> <20070308083543.GA5213@infradead.org>
 <Pine.LNX.4.61.0703082142240.521@yvahk01.tjqt.qr> <20070308212512.GA10584@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 8 2007 22:25, Sam Ravnborg wrote:
>Subject: Re: [PATCH] Fix building kernel under Solaris

Since Solaris seems to be on the run, I did myself try compile it. 
However, unlike the original poster who said he did so on SunOS 4.8, I 
did it on 5.11_snv39, yielding a bigger changeset. I thought I just 
share the diff that piled up so far. It needs a lot of hacks on the 
Solaris side - prioritizing GNU names, then, second, gnu ld has a 
glitch, then, gcc has a missing file... it's fun fun fun!

Well, I will iterate the key problem with the missing file:

  *  include/linux/kernel.h (and many others) include <stdarg.h>
     BUT - since we are using -nostdinc, /usr/include/stdarg.h is not
     considered. And gcc's stdarg.h (which lives at
     /usr/lib/gcc/i586-suse-linux/4.1.2/include/stdarg.h in Linux land)
     is missing in Solaris' GCC (which is version 3.4.3).

Hack #1:
	ln -s \
	/usr/sfw/lib/gcc/i386-pc-solaris2.11/3.4.3/install-tools/include/stdarg.h \
	/usr/sfw/lib/gcc/i386-pc-solaris2.11/3.4.3/include/stdarg.h

Hack #2: GNU programs...

	mkdir -p ~/gnulink;
	for i in addr2line ar as egrep grep ld make nm objcopy objdump \
	  ranlib readelf size string strip tar; do
		ln -s "/usr/sfw/bin/$i" "~/gnulink/$i";
	done;

	for i in cat chgrp chmod chown chroot cksum cmp cp cut date \
	  dd df diff du echo env expand expr false fgrep find fold \
	  getopt groups head hostid install join ln locate ls mkdir \
	  mkfifo mknod mv nice nohup od pwd rm rmdir sed seq shred \
	  sleep sort split stty tac tail tee touch tr true uname \
	  uniq uptime wc who whoami xargs yes gawk; do
		ln -s "/opt/csw/bin/$i" "~/gnulink/$i";
	done;

Hack #3: Diff file...

Hack #4: GNU ld glitch workaround (GNU ld looks in the current dir...)

	cd linux-2.6.21-rc3
	ln -s /usr/sfw/i386-sun-solaris2.11/lib/ldscripts ldscripts

Fun #1:

	export PATH="$HOME/gnulink:$PATH";
	make ARCH=i386

Oddity #1:

	ARCH=i386 required because the Makefiles seem to use `uname -m`
	(which returns "i86pc") rather than `uname -p`. I think we are
	at odds here though...

		uname -m	uname -p
	SOL	i86pc		i386
	LINUX	i686		athlon


Expect compiler failures, especially with assembler code.


Jan

<<< PATCH BELOW <<<

Index: linux-2.6.21-rc3/include/linux/input.h
===================================================================
--- linux-2.6.21-rc3.orig/include/linux/input.h	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/include/linux/input.h	2007-03-07 23:40:39.417339000 +0100
@@ -16,7 +16,9 @@
 #include <sys/time.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
-#include <asm/types.h>
+#ifndef __sun__
+#	include <asm/types.h>
+#endif
 #endif
 
 /*
Index: linux-2.6.21-rc3/scripts/genksyms/genksyms.c
===================================================================
--- linux-2.6.21-rc3.orig/scripts/genksyms/genksyms.c	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/scripts/genksyms/genksyms.c	2007-03-07 23:28:35.659555000 +0100
@@ -21,6 +21,7 @@
    along with this program; if not, write to the Free Software Foundation,
    Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
 
+#include <alloca.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
Index: linux-2.6.21-rc3/scripts/kallsyms.c
===================================================================
--- linux-2.6.21-rc3.orig/scripts/kallsyms.c	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/scripts/kallsyms.c	2007-03-07 23:46:46.249005000 +0100
@@ -378,6 +378,40 @@
 	table_cnt = pos;
 }
 
+#ifdef __sun__
+/* Return the first occurrence of NEEDLE in HAYSTACK.  */
+void *
+memmem (haystack, haystack_len, needle, needle_len)
+     const void *haystack;
+     size_t haystack_len;
+     const void *needle;
+     size_t needle_len;
+{
+  const char *begin;
+  const char *const last_possible
+    = (const char *) haystack + haystack_len - needle_len;
+
+  if (needle_len == 0)
+    /* The first occurrence of the empty string is deemed to occur at
+       the beginning of the string.  */
+    return (void *) haystack;
+
+  /* Sanity check, otherwise the loop might search through the whole
+     memory.  */
+  if (__builtin_expect (haystack_len < needle_len, 0))
+    return NULL;
+
+  for (begin = (const char *) haystack; begin <= last_possible; ++begin)
+    if (begin[0] == ((const char *) needle)[0] &&
+        !memcmp ((const void *) &begin[1],
+                 (const void *) ((const char *) needle + 1),
+                 needle_len - 1))
+      return (void *) begin;
+
+  return NULL;
+}
+#endif
+
 /* replace a given token in all the valid symbols. Use the sampled symbols
  * to update the counts */
 static void compress_symbols(unsigned char *str, int idx)
Index: linux-2.6.21-rc3/scripts/kconfig/Makefile
===================================================================
--- linux-2.6.21-rc3.orig/scripts/kconfig/Makefile	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/scripts/kconfig/Makefile	2007-03-07 23:21:19.730679000 +0100
@@ -88,7 +88,7 @@
 HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
 HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
-HOST_EXTRACFLAGS += -DLOCALE
+HOST_EXTRACFLAGS += -DLOCALE -std=c99 -D__EXTENSIONS__
 
 PHONY += $(obj)/dochecklxdialog
 $(obj)/dochecklxdialog:
Index: linux-2.6.21-rc3/scripts/kconfig/lxdialog/dialog.h
===================================================================
--- linux-2.6.21-rc3.orig/scripts/kconfig/lxdialog/dialog.h	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/scripts/kconfig/lxdialog/dialog.h	2007-03-07 23:14:48.462956000 +0100
@@ -222,3 +222,7 @@
  *   -- uppercase chars are used to invoke the button (M_EVENT + 'O')
  */
 #define M_EVENT (KEY_MAX+1)
+
+#ifndef KEY_RESIZE
+#	define KEY_RESIZE 0632
+#endif
Index: linux-2.6.21-rc3/scripts/mod/file2alias.c
===================================================================
--- linux-2.6.21-rc3.orig/scripts/mod/file2alias.c	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/scripts/mod/file2alias.c	2007-03-07 23:41:23.772026000 +0100
@@ -32,6 +32,8 @@
 typedef uint32_t	__u32;
 typedef uint16_t	__u16;
 typedef unsigned char	__u8;
+typedef int32_t		__s32;
+typedef int16_t		__s16;
 
 /* Big exception to the "don't include kernel headers into userspace, which
  * even potentially has different endianness and word sizes, since
Index: linux-2.6.21-rc3/scripts/mod/modpost.h
===================================================================
--- linux-2.6.21-rc3.orig/scripts/mod/modpost.h	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/scripts/mod/modpost.h	2007-03-07 23:37:01.315290000 +0100
@@ -41,6 +41,11 @@
 #define ELF_R_TYPE  ELF64_R_TYPE
 #endif
 
+#ifdef __sun__
+typedef uint16_t Elf32_Section;
+typedef uint16_t Elf64_Section;
+#endif
+
 /* The 64-bit MIPS ELF ABI uses an unusual reloc format. */
 typedef struct
 {
Index: linux-2.6.21-rc3/scripts/mod/sumversion.c
===================================================================
--- linux-2.6.21-rc3.orig/scripts/mod/sumversion.c	2007-03-07 05:41:20.000000000 +0100
+++ linux-2.6.21-rc3/scripts/mod/sumversion.c	2007-03-07 23:43:55.668334000 +0100
@@ -6,6 +6,7 @@
 #endif
 #include <ctype.h>
 #include <errno.h>
+#include <limits.h>
 #include <string.h>
 #include "modpost.h"
 
@@ -417,7 +418,8 @@
 	*end = '\0';
 
 	md4_init(&md);
-	while ((fname = strsep(&sources, " ")) != NULL) {
+	for(fname = strtok(sources, " "); fname != NULL;
+	  fname = strtok(NULL, " ")) {
 		if (!*fname)
 			continue;
 		if (!parse_source_files(fname, &md))
#<EOF>
