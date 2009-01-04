Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZADVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZADVqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZADVqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:46:25 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:33062 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZADVqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:46:23 -0500
Date: Sun, 4 Jan 2009 22:46:17 +0100
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200901042146.n04LkHFp005847@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
Subject: update8 [PATCH 3/5] init: bzip2 or lzma -compressed kernels and initrds
To: <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, <alain@knaff.lu>
X-Mailer: mail (GNU Mailutils 1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third part of the bzip2/lzma patch

The bzip patch is based on an idea by Christian Ludwig, includes support for
compressing the kernel with bzip2 or lzma rather than gzip. Both
compressors give smaller sizes than gzip.  Lzma's decompresses faster
than bzip2.

It also supports ramdisks and initramfs' compressed using these two
compressors.

The functionality has been successfully used for a couple of years by
the udpcast project

This version applies to "tip" kernel 2.6.28

This part contains:
- support for new bzip2 and lzma kernel compression for x86

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -urNp generic/arch/x86/boot/compressed/Makefile x86/arch/x86/boot/compressed/Makefile
--- generic/arch/x86/boot/compressed/Makefile	2009-01-04 11:56:38.000000000 +0100
+++ x86/arch/x86/boot/compressed/Makefile	2009-01-04 22:05:15.000000000 +0100
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz head_$(BITS).o misc.o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -47,18 +47,35 @@ ifeq ($(CONFIG_X86_32),y)
 ifdef CONFIG_RELOCATABLE
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
 	$(call if_changed,gzip)
+$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin.all FORCE
+	$(call if_changed,bzip2)
+$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin.all FORCE
+	$(call if_changed,lzma)
 else
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
+$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,bzip2)
+$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,lzma)
 endif
 LDFLAGS_piggy.o := -r --format binary --oformat elf32-i386 -T
 
 else
+
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
+$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,bzip2)
+$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,lzma)
 
 LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
 endif
 
-$(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.gz FORCE
+suffix_$(CONFIG_KERNEL_GZIP)  = gz
+suffix_$(CONFIG_KERNEL_BZIP2) = bz2
+suffix_$(CONFIG_KERNEL_LZMA)  = lzma
+
+$(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix_y) FORCE
 	$(call if_changed,ld)
diff -urNp generic/arch/x86/boot/compressed/misc.c x86/arch/x86/boot/compressed/misc.c
--- generic/arch/x86/boot/compressed/misc.c	2009-01-04 11:56:38.000000000 +0100
+++ x86/arch/x86/boot/compressed/misc.c	2009-01-04 22:05:15.000000000 +0100
@@ -116,71 +116,13 @@
 /*
  * gzip declarations
  */
-
-#define OF(args)	args
 #define STATIC		static
 
 #undef memset
 #undef memcpy
 #define memzero(s, n)	memset((s), 0, (n))
 
-typedef unsigned char	uch;
-typedef unsigned short	ush;
-typedef unsigned long	ulg;
-
-/*
- * Window size must be at least 32k, and a power of two.
- * We don't actually have a window just a huge output buffer,
- * so we report a 2G window size, as that should always be
- * larger than our output buffer:
- */
-#define WSIZE		0x80000000
-
-/* Input buffer: */
-static unsigned char	*inbuf;
-
-/* Sliding window buffer (and final output buffer): */
-static unsigned char	*window;
 
-/* Valid bytes in inbuf: */
-static unsigned		insize;
-
-/* Index of next byte to be processed in inbuf: */
-static unsigned		inptr;
-
-/* Bytes in output buffer: */
-static unsigned		outcnt;
-
-/* gzip flag byte */
-#define ASCII_FLAG	0x01 /* bit 0 set: file probably ASCII text */
-#define CONTINUATION	0x02 /* bit 1 set: continuation of multi-part gz file */
-#define EXTRA_FIELD	0x04 /* bit 2 set: extra field present */
-#define ORIG_NAM	0x08 /* bit 3 set: original file name present */
-#define COMMENT		0x10 /* bit 4 set: file comment present */
-#define ENCRYPTED	0x20 /* bit 5 set: file is encrypted */
-#define RESERVED	0xC0 /* bit 6, 7:  reserved */
-
-#define get_byte()	(inptr < insize ? inbuf[inptr++] : fill_inbuf())
-
-/* Diagnostic functions */
-#ifdef DEBUG
-#  define Assert(cond, msg) do { if (!(cond)) error(msg); } while (0)
-#  define Trace(x)	do { fprintf x; } while (0)
-#  define Tracev(x)	do { if (verbose) fprintf x ; } while (0)
-#  define Tracevv(x)	do { if (verbose > 1) fprintf x ; } while (0)
-#  define Tracec(c, x)	do { if (verbose && (c)) fprintf x ; } while (0)
-#  define Tracecv(c, x)	do { if (verbose > 1 && (c)) fprintf x ; } while (0)
-#else
-#  define Assert(cond, msg)
-#  define Trace(x)
-#  define Tracev(x)
-#  define Tracevv(x)
-#  define Tracec(c, x)
-#  define Tracecv(c, x)
-#endif
-
-static int  fill_inbuf(void);
-static void flush_window(void);
 static void error(char *m);
 
 /*
@@ -189,13 +131,8 @@ static void error(char *m);
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 static int quiet;
 
-extern unsigned char input_data[];
-extern int input_len;
-
-static long bytes_out;
-
 static void *memset(void *s, int c, unsigned n);
-static void *memcpy(void *dest, const void *src, unsigned n);
+void *memcpy(void *dest, const void *src, unsigned n);
 
 static void __putstr(int, const char *);
 #define putstr(__x)  __putstr(0, __x)
@@ -213,7 +150,17 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
-#include "../../../../lib/inflate.c"
+#ifdef CONFIG_KERNEL_GZIP
+#include "../../../../lib/decompress_inflate.c"
+#endif
+
+#ifdef CONFIG_KERNEL_BZIP2
+#include "../../../../lib/decompress_bunzip2.c"
+#endif
+
+#ifdef CONFIG_KERNEL_LZMA
+#include "../../../../lib/decompress_unlzma.c"
+#endif
 
 static void scroll(void)
 {
@@ -282,7 +229,7 @@ static void *memset(void *s, int c, unsi
 	return s;
 }
 
-static void *memcpy(void *dest, const void *src, unsigned n)
+void *memcpy(void *dest, const void *src, unsigned n)
 {
 	int i;
 	const char *s = src;
@@ -293,38 +240,6 @@ static void *memcpy(void *dest, const vo
 	return dest;
 }
 
-/* ===========================================================================
- * Fill the input buffer. This is called only when the buffer is empty
- * and at least one byte is really needed.
- */
-static int fill_inbuf(void)
-{
-	error("ran out of input data");
-	return 0;
-}
-
-/* ===========================================================================
- * Write the output window window[0..outcnt-1] and update crc and bytes_out.
- * (Used for the decompressed data only.)
- */
-static void flush_window(void)
-{
-	/* With my window equal to my output buffer
-	 * I only need to compute the crc here.
-	 */
-	unsigned long c = crc;         /* temporary variable */
-	unsigned n;
-	unsigned char *in, ch;
-
-	in = window;
-	for (n = 0; n < outcnt; n++) {
-		ch = *in++;
-		c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
-	}
-	crc = c;
-	bytes_out += (unsigned long)outcnt;
-	outcnt = 0;
-}
 
 static void error(char *x)
 {
@@ -407,12 +322,8 @@ asmlinkage void decompress_kernel(void *
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
-	window = output;		/* Output buffer (Normally at 1M) */
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
-	inbuf  = input_data;		/* Input buffer */
-	insize = input_len;
-	inptr  = 0;
 
 #ifdef CONFIG_X86_64
 	if ((unsigned long)output & (__KERNEL_ALIGN - 1))
@@ -430,10 +341,9 @@ asmlinkage void decompress_kernel(void *
 #endif
 #endif
 
-	makecrc();
 	if (!quiet)
 		putstr("\nDecompressing Linux... ");
-	gunzip();
+	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
 	if (!quiet)
 		putstr("done.\nBooting the kernel.\n");
diff -urNp generic/arch/x86/include/asm/boot.h x86/arch/x86/include/asm/boot.h
--- generic/arch/x86/include/asm/boot.h	2009-01-04 11:56:38.000000000 +0100
+++ x86/arch/x86/include/asm/boot.h	2009-01-04 22:05:15.000000000 +0100
@@ -15,11 +15,21 @@
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
+#if (defined CONFIG_KERNEL_BZIP2)
+#define BOOT_HEAP_SIZE             0x400000
+#else
+
 #ifdef CONFIG_X86_64
 #define BOOT_HEAP_SIZE	0x7000
-#define BOOT_STACK_SIZE	0x4000
 #else
 #define BOOT_HEAP_SIZE	0x4000
+#endif
+
+#endif
+
+#ifdef CONFIG_X86_64
+#define BOOT_STACK_SIZE	0x4000
+#else
 #define BOOT_STACK_SIZE	0x1000
 #endif
 
