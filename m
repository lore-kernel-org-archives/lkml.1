Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbYBOL3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbYBOL3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYBOL2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:28:51 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:2339 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYBOL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:28:50 -0500
Date: Fri, 15 Feb 2008 12:28:15 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mpm@selenic.com
Cc: michael@free-electrons.com
Subject: [PATCH] inflate: refactor inflate malloc code
Message-ID: <20080215122815.7f1cb265@crazy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pBx6MoWpJwWicSqz0ZqyFAy";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pBx6MoWpJwWicSqz0ZqyFAy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Inflate requires some dynamic memory allocation very early in the boot
process and this is provided with a set of four functions:
malloc/free/gzip_mark/gzip_release.

The old inflate code used a mark/release strategy rather than
implement free. This new version instead keeps a count on the number
of outstanding allocations and when it hits zero, it resets the malloc
arena.

This allows removing all the mark and release implementations and
unifying all the malloc/free implementations.

It applies on top of the previously sent patch entitled "Use directly
kmalloc() and kfree() in init/initramfs.c".

Work initially done by Matt Mackall <mpm@selenic.com>, updated to a
recent version of the kernel by me.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 arch/alpha/boot/misc.c                    |   35 -------------------
 arch/arm/boot/compressed/misc.c           |   53 ++-----------------------=
-----
 arch/cris/arch-v10/boot/compressed/misc.c |   34 -------------------
 arch/cris/arch-v32/boot/compressed/misc.c |   34 -------------------
 arch/h8300/boot/compressed/misc.c         |   38 ---------------------
 arch/m32r/boot/compressed/misc.c          |   37 --------------------
 arch/mn10300/boot/compressed/misc.c       |   37 --------------------
 arch/sh/boot/compressed/misc_32.c         |   38 ---------------------
 arch/sh/boot/compressed/misc_64.c         |   40 ----------------------
 arch/x86/boot/compressed/misc.c           |   37 --------------------
 init/do_mounts_rd.c                       |   25 +-------------
 init/initramfs.c                          |   22 +-----------
 lib/inflate.c                             |   49 +++++++++++++++++++++++--=
--
 13 files changed, 50 insertions(+), 429 deletions(-)

Index: linux/arch/alpha/boot/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/alpha/boot/misc.c
+++ linux/arch/alpha/boot/misc.c
@@ -78,8 +78,6 @@
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 static char *input_data;
 static int  input_data_size;
@@ -88,8 +86,6 @@
 static ulg output_ptr;
 static ulg bytes_out;
=20
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
 static void gzip_mark(void **);
 static void gzip_release(void **);
@@ -102,37 +98,6 @@
=20
 #include "../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr <=3D 0) error("Memory error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_ptr_end)
-		error("Out of memory");
-	return p;
-}
-
-static void free(void *where)
-{ /* gzip_mark & gzip_release do the free */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (long) *ptr;
-}
-
 /* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
  * Fill the input buffer. This is called only when the buffer is empty
  * and at least one byte is really needed.
Index: linux/arch/arm/boot/compressed/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/arm/boot/compressed/misc.c
+++ linux/arch/arm/boot/compressed/misc.c
@@ -217,8 +217,6 @@
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 extern char input_data[];
 extern char input_data_end[];
@@ -227,11 +225,7 @@
 static ulg output_ptr;
 static ulg bytes_out;
=20
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 static void putstr(const char *);
=20
@@ -241,51 +235,12 @@
=20
 #define HEAP_SIZE 0x3000
=20
-#include "../../../../lib/inflate.c"
-
-#ifndef STANDALONE_DEBUG
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr <=3D 0) error("Memory error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_ptr_end)
-		error("Out of memory");
-	return p;
-}
-
-static void free(void *where)
-{ /* gzip_mark & gzip_release do the free */
-}
-
-static void gzip_mark(void **ptr)
-{
-	arch_decomp_wdog();
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	arch_decomp_wdog();
-	free_mem_ptr =3D (long) *ptr;
-}
-#else
-static void gzip_mark(void **ptr)
-{
-}
-
-static void gzip_release(void **ptr)
-{
-}
+#ifdef STANDALONE_DEBUG
+#define NO_INFLATE_MALLOC
 #endif
=20
+#include "../../../../lib/inflate.c"
+
 /* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
  * Fill the input buffer. This is called only when the buffer is empty
  * and at least one byte is really needed.
Index: linux/arch/cris/arch-v10/boot/compressed/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/cris/arch-v10/boot/compressed/misc.c
+++ linux/arch/cris/arch-v10/boot/compressed/misc.c
@@ -84,8 +84,6 @@
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 extern char *input_data;  /* lives in head.S */
=20
@@ -93,11 +91,7 @@
 static uch *output_data;
 static unsigned long output_ptr =3D 0;
 =20
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 =20
 static void puts(const char *);
=20
@@ -108,34 +102,6 @@
 =20
 #include "../../../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (long) *ptr;
-}
-
 /* decompressor info and error messages to serial console */
=20
 static void
Index: linux/arch/cris/arch-v32/boot/compressed/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/cris/arch-v32/boot/compressed/misc.c
+++ linux/arch/cris/arch-v32/boot/compressed/misc.c
@@ -89,8 +89,6 @@
=20
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 extern char *input_data;  /* lives in head.S */
=20
@@ -98,11 +96,7 @@
 static uch *output_data;
 static unsigned long output_ptr =3D 0;
=20
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 static void puts(const char *);
=20
@@ -113,34 +107,6 @@
=20
 #include "../../../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (long) *ptr;
-}
-
 /* decompressor info and error messages to serial console */
=20
 static inline void
Index: linux/arch/h8300/boot/compressed/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/h8300/boot/compressed/misc.c
+++ linux/arch/h8300/boot/compressed/misc.c
@@ -67,8 +67,6 @@
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 extern char input_data[];
 extern int input_len;
@@ -77,11 +75,7 @@
 static uch *output_data;
 static unsigned long output_ptr =3D 0;
=20
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 int puts(const char *);
=20
@@ -98,38 +92,6 @@
 #define TDR *((volatile unsigned char *)0xffff8b)
 #define SSR *((volatile unsigned char *)0xffff8c)
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr =3D=3D 0) error("Memory error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (long) *ptr;
-}
-
 int puts(const char *s)
 {
 	return 0;
Index: linux/arch/m32r/boot/compressed/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/m32r/boot/compressed/misc.c
+++ linux/arch/m32r/boot/compressed/misc.c
@@ -70,8 +70,6 @@
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 static unsigned char *input_data;
 static int input_len;
@@ -82,9 +80,6 @@
=20
 #include "m32r_sio.c"
=20
-static void *malloc(int size);
-static void free(void *where);
-
 static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
=20
@@ -92,38 +87,6 @@
=20
 #include "../../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr =3D=3D 0) error("Memory error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (long) *ptr;
-}
-
 void* memset(void* s, int c, size_t n)
 {
 	int i;
Index: linux/arch/mn10300/boot/compressed/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/mn10300/boot/compressed/misc.c
+++ linux/arch/mn10300/boot/compressed/misc.c
@@ -153,26 +153,9 @@
 static unsigned long output_ptr;
=20
=20
-static void *malloc(int size);
-
-static inline void free(void *where)
-{	/* Don't care */
-}
-
 static unsigned long free_mem_ptr =3D (unsigned long) &end;
 static unsigned long free_mem_end_ptr =3D (unsigned long) &end + 0x90000;
=20
-static inline void gzip_mark(void **ptr)
-{
-	kputs(".");
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static inline void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (unsigned long) *ptr;
-}
-
 #define INPLACE_MOVE_ROUTINE	0x1000
 #define LOW_BUFFER_START	0x2000
 #define LOW_BUFFER_END		0x90000
@@ -186,26 +169,6 @@
=20
 #include "../../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size < 0)
-		error("Malloc error\n");
-	if (!free_mem_ptr)
-		error("Memory error\n");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *) free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_end_ptr)
-		error("\nOut of memory\n");
-
-	return p;
-}
-
 static inline void scroll(void)
 {
 	int i;
Index: linux/arch/sh/boot/compressed/misc_32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/sh/boot/compressed/misc_32.c
+++ linux/arch/sh/boot/compressed/misc_32.c
@@ -74,8 +74,6 @@
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 extern char input_data[];
 extern int input_len;
@@ -84,11 +82,7 @@
 static uch *output_data;
 static unsigned long output_ptr =3D 0;
=20
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 int puts(const char *);
=20
@@ -101,38 +95,6 @@
=20
 #include "../../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr =3D=3D 0) error("Memory error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (long) *ptr;
-}
-
 #ifdef CONFIG_SH_STANDARD_BIOS
 size_t strlen(const char *s)
 {
Index: linux/arch/sh/boot/compressed/misc_64.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/sh/boot/compressed/misc_64.c
+++ linux/arch/sh/boot/compressed/misc_64.c
@@ -72,8 +72,6 @@
 static int fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 extern char input_data[];
 extern int input_len;
@@ -82,11 +80,7 @@
 static uch *output_data;
 static unsigned long output_ptr =3D 0;
=20
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
=20
 static void puts(const char *);
=20
@@ -99,40 +93,6 @@
=20
 #include "../../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size < 0)
-		error("Malloc error\n");
-	if (free_mem_ptr =3D=3D 0)
-		error("Memory error\n");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *) free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_end_ptr)
-		error("\nOut of memory\n");
-
-	return p;
-}
-
-static void free(void *where)
-{				/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (long) *ptr;
-}
-
 void puts(const char *s)
 {
 }
Index: linux/arch/x86/boot/compressed/misc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/boot/compressed/misc.c
+++ linux/arch/x86/boot/compressed/misc.c
@@ -168,8 +168,6 @@
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
  =20
 /*
  * This is set up by the setup-routine at boot-time
@@ -187,9 +185,6 @@
=20
 static long bytes_out =3D 0;
=20
-static void *malloc(int size);
-static void free(void *where);
-
 static void *memset(void *s, int c, unsigned n);
 static void *memcpy(void *dest, const void *src, unsigned n);
=20
@@ -220,38 +215,6 @@
=20
 #include "../../../../lib/inflate.c"
=20
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr <=3D 0) error("Memory error");
-
-	free_mem_ptr =3D (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p =3D (void *)free_mem_ptr;
-	free_mem_ptr +=3D size;
-
-	if (free_mem_ptr >=3D free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr =3D (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr =3D (memptr) *ptr;
-}
-=20
 static void scroll(void)
 {
 	int i;
Index: linux/init/do_mounts_rd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/init/do_mounts_rd.c
+++ linux/init/do_mounts_rd.c
@@ -313,32 +313,11 @@
=20
 static int  __init fill_inbuf(void);
 static void __init flush_window(void);
-static void __init *malloc(size_t size);
-static void __init free(void *where);
 static void __init error(char *m);
-static void __init gzip_mark(void **);
-static void __init gzip_release(void **);
=20
-#include "../lib/inflate.c"
-
-static void __init *malloc(size_t size)
-{
-	return kmalloc(size, GFP_KERNEL);
-}
-
-static void __init free(void *where)
-{
-	kfree(where);
-}
-
-static void __init gzip_mark(void **ptr)
-{
-}
-
-static void __init gzip_release(void **ptr)
-{
-}
+#define NO_INFLATE_MALLOC
=20
+#include "../lib/inflate.c"
=20
 /* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
  * Fill the input buffer. This is called only when the buffer is empty
Index: linux/init/initramfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/init/initramfs.c
+++ linux/init/initramfs.c
@@ -14,16 +14,6 @@
 		message =3D x;
 }
=20
-static void __init *malloc(size_t size)
-{
-	return kmalloc(size, GFP_KERNEL);
-}
-
-static void __init free(void *where)
-{
-	kfree(where);
-}
-
 /* link hash */
=20
 #define N_ALIGN(len) ((((len) + 1) & ~3) + 2)
@@ -407,18 +397,10 @@
=20
 static void __init flush_window(void);
 static void __init error(char *m);
-static void __init gzip_mark(void **);
-static void __init gzip_release(void **);
=20
-#include "../lib/inflate.c"
+#define NO_INFLATE_MALLOC
=20
-static void __init gzip_mark(void **ptr)
-{
-}
-
-static void __init gzip_release(void **ptr)
-{
-}
+#include "../lib/inflate.c"
=20
 /* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
  * Write the output window window[0..outcnt-1] and update crc and bytes_ou=
t.
Index: linux/lib/inflate.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/lib/inflate.c
+++ linux/lib/inflate.c
@@ -230,6 +230,45 @@
 #define NEEDBITS(n) {while(k<(n)){b|=3D((ulg)NEXTBYTE())<<k;k+=3D8;}}
 #define DUMPBITS(n) {b>>=3D(n);k-=3D(n);}
=20
+#ifndef NO_INFLATE_MALLOC
+/* A trivial malloc implementation, adapted from
+ *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
+ */
+
+static unsigned long malloc_ptr;
+static int malloc_count;
+
+static void *malloc(int size)
+{
+       void *p;
+
+       if (size <0)
+               error("Malloc error");
+       if (!malloc_ptr)
+               malloc_ptr =3D free_mem_ptr;
+
+       malloc_ptr =3D (malloc_ptr + 3) & ~3;     /* Align */
+
+       p =3D (void *)malloc_ptr;
+       malloc_ptr +=3D size;
+
+       if (malloc_ptr >=3D free_mem_end_ptr)
+               error("Out of memory");
+
+       malloc_count++;
+       return p;
+}
+
+static void free(void *where)
+{
+       malloc_count--;
+       if (!malloc_count)
+               malloc_ptr =3D free_mem_ptr;
+}
+#else
+#define malloc(a) kmalloc(a, GFP_KERNEL)
+#define free(a) kfree(a)
+#endif
=20
 /*
    Huffman code decoding is performed using a multi-level table lookup.
@@ -1042,7 +1081,6 @@
   int e;                /* last block flag */
   int r;                /* result code */
   unsigned h;           /* maximum struct huft's malloc'ed */
-  void *ptr;
=20
   /* initialize window, bit buffer */
   wp =3D 0;
@@ -1054,12 +1092,9 @@
   h =3D 0;
   do {
     hufts =3D 0;
-    gzip_mark(&ptr);
-    if ((r =3D inflate_block(&e)) !=3D 0) {
-      gzip_release(&ptr);	   =20
-      return r;
-    }
-    gzip_release(&ptr);
+    r =3D inflate_block(&e);
+    if (r)
+	    return r;
     if (hufts > h)
       h =3D hufts;
   } while (!e);


--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/pBx6MoWpJwWicSqz0ZqyFAy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtXdP9lPLMJjT96cRAt+cAJ9CZxcrnu6UiiFfVjzRJIyYMC6ShgCdGVvd
NUCmTlMxiItvYXmh94wUWgo=
=SanN
-----END PGP SIGNATURE-----

--Sig_/pBx6MoWpJwWicSqz0ZqyFAy--
