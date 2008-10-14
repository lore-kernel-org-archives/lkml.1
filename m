Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbYJNAUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbYJNAUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbYJNATD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:19:03 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:52895 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612AbYJNAS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:18:56 -0400
Date: Tue, 14 Oct 2008 02:18:50 +0200
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200810140018.m9E0Iokx002430@hitchhiker.org.lu>
Subject: [PATCH 3/5] init: bzip2 or lzma -compressed kernels and initrds
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

This version applies to "tip" kernel 2.6.27

This part contains:
- support for new bzip2 and lzma kernel compression for x86

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -urNp generic/arch/x86/boot/compressed/Makefile x86/arch/x86/boot/compressed/Makefile
--- generic/arch/x86/boot/compressed/Makefile	2008-10-11 14:11:55.000000000 +0200
+++ x86/arch/x86/boot/compressed/Makefile	2008-10-13 23:42:24.000000000 +0200
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz head_$(BITS).o misc.o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -47,18 +47,34 @@ ifeq ($(CONFIG_X86_32),y)
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
--- generic/arch/x86/boot/compressed/misc.c	2008-10-11 14:11:55.000000000 +0200
+++ x86/arch/x86/boot/compressed/misc.c	2008-10-14 01:50:47.000000000 +0200
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
 
-/* Input buffer: */
-static unsigned char	*inbuf;
-
-/* Sliding window buffer (and final output buffer): */
-static unsigned char	*window;
-
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
@@ -189,11 +131,6 @@ static void error(char *m);
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 static int quiet;
 
-extern unsigned char input_data[];
-extern int input_len;
-
-static long bytes_out;
-
 static void *memset(void *s, int c, unsigned n);
 static void *memcpy(void *dest, const void *src, unsigned n);
 
@@ -213,7 +150,19 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
+#define NEW_CODE
+
+#ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/inflate.c"
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
@@ -293,38 +242,6 @@ static void *memcpy(void *dest, const vo
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
@@ -407,12 +324,8 @@ asmlinkage void decompress_kernel(void *
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
@@ -430,10 +343,9 @@ asmlinkage void decompress_kernel(void *
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
diff -urNp generic/include/asm-x86/boot.h x86/include/asm-x86/boot.h
--- generic/include/asm-x86/boot.h	2008-10-11 14:12:09.000000000 +0200
+++ x86/include/asm-x86/boot.h	2008-10-13 23:42:24.000000000 +0200
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
 
