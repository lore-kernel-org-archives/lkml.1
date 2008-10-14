Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYJNTqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYJNTqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYJNToj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:44:39 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:49906 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYJNToj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:44:39 -0400
Date: Tue, 14 Oct 2008 21:44:28 +0200
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200810141944.m9EJiSq8011717@hitchhiker>
Subject: update7 [PATCH 5/5] init: bzip2 or lzma -compressed kernels and initrds
To: <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, <alain@knaff.lu>
X-Mailer: mail (GNU Mailutils 1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth part of the bzip2/lzma patch

The bzip patch is based on an idea by Christian Ludwig, includes support for
compressing the kernel with bzip2 or lzma rather than gzip. Both
compressors give smaller sizes than gzip.  Lzma's decompresses faster
than bzip2.

It also supports ramdisks and initramfs' compressed using these two
compressors.

The functionality has been successfully used for a couple of years by
the udpcast project

This version applies to "tip" kernel 2.6.27

This part contains:
- cleanup of NEW_CODE ifdefs

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -urNp arm/arch/arm/boot/compressed/misc.c final/arch/arm/boot/compressed/misc.c
--- arm/arch/arm/boot/compressed/misc.c	2008-10-14 02:14:38.000000000 +0200
+++ final/arch/arm/boot/compressed/misc.c	2008-10-14 02:14:58.000000000 +0200
@@ -182,7 +182,6 @@ static ulg free_mem_ptr;
 static ulg free_mem_end_ptr;
 
 #define ARCH_HAS_DECOMP_WDOG
-#define NEW_CODE
 
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/inflate.c"
diff -urNp arm/arch/x86/boot/compressed/misc.c final/arch/x86/boot/compressed/misc.c
--- arm/arch/x86/boot/compressed/misc.c	2008-10-14 01:50:59.000000000 +0200
+++ final/arch/x86/boot/compressed/misc.c	2008-10-14 01:51:22.000000000 +0200
@@ -150,8 +150,6 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
-#define NEW_CODE
-
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/inflate.c"
 #endif
diff -urNp arm/include/linux/decompress/mm.h final/include/linux/decompress/mm.h
--- arm/include/linux/decompress/mm.h	2008-10-14 01:57:39.000000000 +0200
+++ final/include/linux/decompress/mm.h	2008-10-14 01:37:39.000000000 +0200
@@ -77,7 +77,6 @@ static void free(void *where)
 
 static void(*error)(char *m);
 #define set_error_fn(x) error = x;
-#define NEW_CODE
 
 #define INIT __init
 #define STATIC
diff -urNp arm/lib/inflate.c final/lib/inflate.c
--- arm/lib/inflate.c	2008-10-14 01:20:26.000000000 +0200
+++ final/lib/inflate.c	2008-10-14 01:35:45.000000000 +0200
@@ -116,7 +116,6 @@ static char rcsid[] = "#Id: inflate.c,v 
 
 #include <linux/string.h>
 
-#ifdef NEW_CODE
 static int(*flush_cb)(void*, unsigned int);
 static int(*fill_cb)(void*, unsigned int);
 
@@ -179,7 +178,6 @@ static int INIT fill_inbuf(void)
 
 static void flush_window(void);
 /* End stuff copied from initramfs */
-#endif
 
 #define slide window
 
@@ -680,19 +678,16 @@ STATIC int INIT inflate_codes(
 
       /* do the copy */
       do {
-#ifdef NEW_CODE
 	if (flush_cb) {
-#endif
 		/* Sliding window emulated using circular buffer:
 		 * manage wrap-around */
 		e = WSIZE - ((d &= WSIZE-1) > w ? d : w);
 		if (e > n)
 			e = n;
-#ifdef NEW_CODE
 	} else {
 		e = n;
 	}
-#endif
+
 	n -= e;
 
 #if !defined(NOMEMCPY) && !defined(DEBUG)
@@ -1218,7 +1213,6 @@ makecrc(void)
 #define ENCRYPTED    0x20 /* bit 5 set: file is encrypted */
 #define RESERVED     0xC0 /* bit 6,7:   reserved */
 
-#ifdef NEW_CODE
 /* ===========================================================================
  * Write the output window window[0..outcnt-1] and update crc and bytes_out.
  * (Used for the decompressed data only.)
@@ -1247,23 +1241,18 @@ static int empty_fill(void *buf, unsigne
 {
 	return 0;
 }
-#endif
+
 
 
 /*
  * Do the uncompression!
  */
-STATIC int INIT gunzip(
-#ifdef NEW_CODE
-		       unsigned char *buf, int len,
+STATIC int INIT gunzip(unsigned char *buf, int len,
 		       int(*fill)(void*, unsigned int),
 		       int(*flush)(void*, unsigned int),
 		       unsigned char *output,
 		       int *posp,
 		       void(*error_fn)(char *x)
-#else
-		       void
-#endif
   )
 {
     uint8_t flags;
@@ -1273,7 +1262,6 @@ STATIC int INIT gunzip(
     uint32_t orig_len = 0;       /* original uncompressed length */
     int res;
 
-#ifdef NEW_CODE
     set_error_fn(error_fn);
     if (fill == NULL)
 	    fill_cb = empty_fill;
@@ -1293,8 +1281,6 @@ STATIC int INIT gunzip(
 	    inbuf = buf;
     else
 	    inbuf = malloc(INBUFSIZ);
-#endif
-
     inptr = 0;
     outcnt = 0;		/* bytes in output buffer */
     bytes_out = 0;
@@ -1401,20 +1387,16 @@ STATIC int INIT gunzip(
 	    error("length error");
 	    return -1;
     }
-#ifdef NEW_CODE
     if (!output)
 	    free(window);
     if (posp)
 	    *posp = inptr;
-#endif
     return 0;
 
  underrun:			/* NEXTBYTE() goto's here if needed */
     free(window);
-#ifdef NEW_CODE
     if (!buf)
 	    free(inbuf);
-#endif
     error("out of input data");
     return -1;
 }
