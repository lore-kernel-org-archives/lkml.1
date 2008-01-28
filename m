Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbYA1Isv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbYA1Isv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYA1IrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:47:13 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:7269 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758344AbYA1IrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:47:10 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2008 08:45:49 +0000
Message-Id: <1201509949-3285-10-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201509949-3285-9-git-send-email-ijc@hellion.org.uk>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-3-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-4-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-5-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-6-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-7-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-8-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-9-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 9/9] x86: Unify arch/x86/boot/compressed/misc_??.c
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remainder of unification can occur inplace.

size reports no change in arch/x86/boot/compressed/vmlinux.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/Makefile              |    4 +-
 arch/x86/boot/compressed/{misc_32.c => misc.c} |   32 ++-
 arch/x86/boot/compressed/misc_64.c             |  381 ------------------------
 3 files changed, 30 insertions(+), 387 deletions(-)
 rename arch/x86/boot/compressed/{misc_32.c => misc.c} (94%)
 delete mode 100644 arch/x86/boot/compressed/misc_64.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index baffeaf..fe24cea 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz head_$(BITS).o misc_$(BITS).o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.gz head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -18,7 +18,7 @@ KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
-$(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc_$(BITS).o $(obj)/piggy.o FORCE
+$(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
 
diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc.c
similarity index 94%
rename from arch/x86/boot/compressed/misc_32.c
rename to arch/x86/boot/compressed/misc.c
index 2b1c22d..8182e32 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -15,6 +15,11 @@
  * we just keep it from happening
  */
 #undef CONFIG_PARAVIRT
+#ifdef CONFIG_X86_64
+#define _LINUX_STRING_H_ 1
+#define __LINUX_BITMAP_H 1
+#endif
+
 #include <linux/linkage.h>
 #include <linux/screen_info.h>
 #include <asm/io.h>
@@ -190,10 +195,20 @@ static void *memcpy(void *dest, const void *src, unsigned n);
 
 static void putstr(const char *);
 
-static unsigned long free_mem_ptr;
-static unsigned long free_mem_end_ptr;
+#ifdef CONFIG_X86_64
+#define memptr long
+#else
+#define memptr unsigned
+#endif
+
+static memptr free_mem_ptr;
+static memptr free_mem_end_ptr;
 
+#ifdef CONFIG_X86_64
+#define HEAP_SIZE             0x7000
+#else
 #define HEAP_SIZE             0x4000
+#endif
 
 static char *vidmem = (char *)0xb8000;
 static int vidport;
@@ -234,7 +249,7 @@ static void gzip_mark(void **ptr)
 
 static void gzip_release(void **ptr)
 {
-	free_mem_ptr = (unsigned long) *ptr;
+	free_mem_ptr = (memptr) *ptr;
 }
  
 static void scroll(void)
@@ -251,8 +266,10 @@ static void putstr(const char *s)
 	int x,y,pos;
 	char c;
 
+#ifdef CONFIG_X86_32
 	if (RM_SCREEN_INFO.orig_video_mode == 0 && lines == 0 && cols == 0)
 		return;
+#endif
 
 	x = RM_SCREEN_INFO.orig_x;
 	y = RM_SCREEN_INFO.orig_y;
@@ -348,7 +365,7 @@ static void error(char *x)
 		asm("hlt");
 }
 
-asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
+asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  uch *input_data, unsigned long input_len,
 				  uch *output)
 {
@@ -372,6 +389,12 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
 	insize = input_len;
 	inptr  = 0;
 
+#ifdef CONFIG_X86_64
+	if ((ulg)output & (__KERNEL_ALIGN - 1))
+		error("Destination address not 2M aligned");
+	if ((ulg)output >= 0xffffffffffUL)
+		error("Destination address too large");
+#else
 	if ((u32)output & (CONFIG_PHYSICAL_ALIGN -1))
 		error("Destination address not CONFIG_PHYSICAL_ALIGN aligned");
 	if (heap > ((-__PAGE_OFFSET-(512<<20)-1) & 0x7fffffff))
@@ -380,6 +403,7 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
 	if ((u32)output != LOAD_PHYSICAL_ADDR)
 		error("Wrong destination address");
 #endif
+#endif
 
 	makecrc();
 	putstr("\nDecompressing Linux... ");
diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
deleted file mode 100644
index ca760fb..0000000
--- a/arch/x86/boot/compressed/misc_64.c
+++ /dev/null
@@ -1,381 +0,0 @@
-/*
- * misc.c
- *
- * This is a collection of several routines from gzip-1.0.3
- * adapted for Linux.
- *
- * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
- * puts by Nick Holloway 1993, better puts by Martin Mares 1995
- * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
- */
-
-/*
- * we have to be careful, because no indirections are allowed here, and
- * paravirt_ops is a kind of one. As it will only run in baremetal anyway,
- * we just keep it from happening
- */
-#undef CONFIG_PARAVIRT
-#define _LINUX_STRING_H_ 1
-#define __LINUX_BITMAP_H 1
-
-#include <linux/linkage.h>
-#include <linux/screen_info.h>
-#include <asm/io.h>
-#include <asm/page.h>
-#include <asm/boot.h>
-
-/* WARNING!!
- * This code is compiled with -fPIC and it is relocated dynamically
- * at run time, but no relocation processing is performed.
- * This means that it is not safe to place pointers in static structures.
- */
-
-/*
- * Getting to provable safe in place decompression is hard.
- * Worst case behaviours need to be analyzed.
- * Background information:
- *
- * The file layout is:
- *    magic[2]
- *    method[1]
- *    flags[1]
- *    timestamp[4]
- *    extraflags[1]
- *    os[1]
- *    compressed data blocks[N]
- *    crc[4] orig_len[4]
- *
- * resulting in 18 bytes of non compressed data overhead.
- *
- * Files divided into blocks
- * 1 bit (last block flag)
- * 2 bits (block type)
- *
- * 1 block occurs every 32K -1 bytes or when there 50% compression has been achieved.
- * The smallest block type encoding is always used.
- *
- * stored:
- *    32 bits length in bytes.
- *
- * fixed:
- *    magic fixed tree.
- *    symbols.
- *
- * dynamic:
- *    dynamic tree encoding.
- *    symbols.
- *
- *
- * The buffer for decompression in place is the length of the
- * uncompressed data, plus a small amount extra to keep the algorithm safe.
- * The compressed data is placed at the end of the buffer.  The output
- * pointer is placed at the start of the buffer and the input pointer
- * is placed where the compressed data starts.  Problems will occur
- * when the output pointer overruns the input pointer.
- *
- * The output pointer can only overrun the input pointer if the input
- * pointer is moving faster than the output pointer.  A condition only
- * triggered by data whose compressed form is larger than the uncompressed
- * form.
- *
- * The worst case at the block level is a growth of the compressed data
- * of 5 bytes per 32767 bytes.
- *
- * The worst case internal to a compressed block is very hard to figure.
- * The worst case can at least be boundined by having one bit that represents
- * 32764 bytes and then all of the rest of the bytes representing the very
- * very last byte.
- *
- * All of which is enough to compute an amount of extra data that is required
- * to be safe.  To avoid problems at the block level allocating 5 extra bytes
- * per 32767 bytes of data is sufficient.  To avoind problems internal to a block
- * adding an extra 32767 bytes (the worst case uncompressed block size) is
- * sufficient, to ensure that in the worst case the decompressed data for
- * block will stop the byte before the compressed data for a block begins.
- * To avoid problems with the compressed data's meta information an extra 18
- * bytes are needed.  Leading to the formula:
- *
- * extra_bytes = (uncompressed_size >> 12) + 32768 + 18 + decompressor_size.
- *
- * Adding 8 bytes per 32K is a bit excessive but much easier to calculate.
- * Adding 32768 instead of 32767 just makes for round numbers.
- * Adding the decompressor_size is necessary as it musht live after all
- * of the data as well.  Last I measured the decompressor is about 14K.
- * 10K of actual data and 4K of bss.
- *
- */
-
-/*
- * gzip declarations
- */
-
-#define OF(args)  args
-#define STATIC static
-
-#undef memset
-#undef memcpy
-#define memzero(s, n)     memset ((s), 0, (n))
-
-typedef unsigned char  uch;
-typedef unsigned short ush;
-typedef unsigned long  ulg;
-
-#define WSIZE 0x80000000	/* Window size must be at least 32k,
-				 * and a power of two
-				 * We don't actually have a window just
-				 * a huge output buffer so I report
-				 * a 2G windows size, as that should
-				 * always be larger than our output buffer.
-				 */
-
-static uch *inbuf;	/* input buffer */
-static uch *window;	/* Sliding window buffer, (and final output buffer) */
-
-static unsigned insize;  /* valid bytes in inbuf */
-static unsigned inptr;   /* index of next byte to be processed in inbuf */
-static unsigned outcnt;  /* bytes in output buffer */
-
-/* gzip flag byte */
-#define ASCII_FLAG   0x01 /* bit 0 set: file probably ASCII text */
-#define CONTINUATION 0x02 /* bit 1 set: continuation of multi-part gzip file */
-#define EXTRA_FIELD  0x04 /* bit 2 set: extra field present */
-#define ORIG_NAME    0x08 /* bit 3 set: original file name present */
-#define COMMENT      0x10 /* bit 4 set: file comment present */
-#define ENCRYPTED    0x20 /* bit 5 set: file is encrypted */
-#define RESERVED     0xC0 /* bit 6,7:   reserved */
-
-#define get_byte()  (inptr < insize ? inbuf[inptr++] : fill_inbuf())
-		
-/* Diagnostic functions */
-#ifdef DEBUG
-#  define Assert(cond,msg) {if(!(cond)) error(msg);}
-#  define Trace(x) fprintf x
-#  define Tracev(x) {if (verbose) fprintf x ;}
-#  define Tracevv(x) {if (verbose>1) fprintf x ;}
-#  define Tracec(c,x) {if (verbose && (c)) fprintf x ;}
-#  define Tracecv(c,x) {if (verbose>1 && (c)) fprintf x ;}
-#else
-#  define Assert(cond,msg)
-#  define Trace(x)
-#  define Tracev(x)
-#  define Tracevv(x)
-#  define Tracec(c,x)
-#  define Tracecv(c,x)
-#endif
-
-static int  fill_inbuf(void);
-static void flush_window(void);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
-  
-/*
- * This is set up by the setup-routine at boot-time
- */
-static unsigned char *real_mode; /* Pointer to real-mode data */
-
-#define RM_EXT_MEM_K   (*(unsigned short *)(real_mode + 0x2))
-#ifndef STANDARD_MEMORY_BIOS_CALL
-#define RM_ALT_MEM_K   (*(unsigned long *)(real_mode + 0x1e0))
-#endif
-#define RM_SCREEN_INFO (*(struct screen_info *)(real_mode+0))
-
-extern unsigned char input_data[];
-extern int input_len;
-
-static long bytes_out = 0;
-
-static void *malloc(int size);
-static void free(void *where);
-
-static void *memset(void *s, int c, unsigned n);
-static void *memcpy(void *dest, const void *src, unsigned n);
-
-static void putstr(const char *);
-
-static long free_mem_ptr;
-static long free_mem_end_ptr;
-
-#define HEAP_SIZE             0x7000
-
-static char *vidmem = (char *)0xb8000;
-static int vidport;
-static int lines, cols;
-
-#include "../../../../lib/inflate.c"
-
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr <= 0) error("Memory error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_end_ptr)
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
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
- 
-static void scroll(void)
-{
-	int i;
-
-	memcpy ( vidmem, vidmem + cols * 2, ( lines - 1 ) * cols * 2 );
-	for ( i = ( lines - 1 ) * cols * 2; i < lines * cols * 2; i += 2 )
-		vidmem[i] = ' ';
-}
-
-static void putstr(const char *s)
-{
-	int x,y,pos;
-	char c;
-
-	x = RM_SCREEN_INFO.orig_x;
-	y = RM_SCREEN_INFO.orig_y;
-
-	while ( ( c = *s++ ) != '\0' ) {
-		if ( c == '\n' ) {
-			x = 0;
-			if ( ++y >= lines ) {
-				scroll();
-				y--;
-			}
-		} else {
-			vidmem [(x + cols * y) * 2] = c;
-			if ( ++x >= cols ) {
-				x = 0;
-				if ( ++y >= lines ) {
-					scroll();
-					y--;
-				}
-			}
-		}
-	}
-
-	RM_SCREEN_INFO.orig_x = x;
-	RM_SCREEN_INFO.orig_y = y;
-
-	pos = (x + cols * y) * 2;	/* Update cursor position */
-	outb(14, vidport);
-	outb(0xff & (pos >> 9), vidport+1);
-	outb(15, vidport);
-	outb(0xff & (pos >> 1), vidport+1);
-}
-
-static void* memset(void* s, int c, unsigned n)
-{
-	int i;
-	char *ss = s;
-
-	for (i=0;i<n;i++) ss[i] = c;
-	return s;
-}
-
-static void* memcpy(void* dest, const void* src, unsigned n)
-{
-	int i;
-	const char *s = src;
-	char *d = dest;
-
-	for (i=0;i<n;i++) d[i] = s[i];
-	return dest;
-}
-
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
-	ulg c = crc;         /* temporary variable */
-	unsigned n;
-	uch *in, ch;
-
-	in = window;
-	for (n = 0; n < outcnt; n++) {
-		ch = *in++;
-		c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
-	}
-	crc = c;
-	bytes_out += (ulg)outcnt;
-	outcnt = 0;
-}
-
-static void error(char *x)
-{
-	putstr("\n\n");
-	putstr(x);
-	putstr("\n\n -- System halted");
-
-	while (1)
-		asm("hlt");
-}
-
-asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
-				  uch *input_data, unsigned long input_len,
-				  uch *output)
-{
-	real_mode = rmode;
-
-	if (RM_SCREEN_INFO.orig_video_mode == 7) {
-		vidmem = (char *) 0xb0000;
-		vidport = 0x3b4;
-	} else {
-		vidmem = (char *) 0xb8000;
-		vidport = 0x3d4;
-	}
-
-	lines = RM_SCREEN_INFO.orig_video_lines;
-	cols = RM_SCREEN_INFO.orig_video_cols;
-
-	window = output;		/* Output buffer (Normally at 1M) */
-	free_mem_ptr     = heap;	/* Heap */
-	free_mem_end_ptr = heap + HEAP_SIZE;
-	inbuf  = input_data;		/* Input buffer */
-	insize = input_len;
-	inptr  = 0;
-
-	if ((ulg)output & (__KERNEL_ALIGN - 1))
-		error("Destination address not 2M aligned");
-	if ((ulg)output >= 0xffffffffffUL)
-		error("Destination address too large");
-
-	makecrc();
-	putstr("\nDecompressing Linux... ");
-	gunzip();
-	putstr("done.\nBooting the kernel.\n");
-	return;
-}
-- 
1.5.3.8

