Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZADVrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZADVrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZADVq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:46:27 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:33064 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZADVqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:46:24 -0500
Date: Sun, 4 Jan 2009 22:46:17 +0100
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200901042146.n04LkHr2005855@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
Subject: update8 [PATCH 4/5] init: bzip2 or lzma -compressed kernels and initrds
To: <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, <alain@knaff.lu>
X-Mailer: mail (GNU Mailutils 1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth part of the bzip2/lzma patch

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
- support for new bzip2 and lzma kernel compression for ARM

N.B. If there is already a version of this in the officieal ARM tree,
please disregard the version in this mail.

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -urNp x86/arch/arm/boot/compressed/Makefile arm/arch/arm/boot/compressed/Makefile
--- x86/arch/arm/boot/compressed/Makefile	2009-01-04 22:29:52.000000000 +0100
+++ arm/arch/arm/boot/compressed/Makefile	2009-01-04 22:13:36.000000000 +0100
@@ -63,8 +63,15 @@ endif
 
 SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
 
-targets       := vmlinux vmlinux.lds piggy.gz piggy.o font.o font.c \
-		 head.o misc.o $(OBJS)
+suffix_$(CONFIG_KERNEL_GZIP)  = gz
+suffix_$(CONFIG_KERNEL_BZIP2) = bz2
+suffix_$(CONFIG_KERNEL_LZMA)  = lzma
+
+targets       := vmlinux vmlinux.lds \
+		 piggy.gz piggy.gz.o \
+		 piggy.bz2 piggy.bz2.o \
+		 piggy.lzma piggy.lzma.o \
+		 font.o font.c head.o misc.o $(OBJS)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
@@ -91,7 +98,7 @@ LDFLAGS_vmlinux += -p --no-undefined -X 
 # would otherwise mess up our GOT table
 CFLAGS_misc.o := -Dstatic=
 
-$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
 	 	$(addprefix $(obj)/, $(OBJS)) FORCE
 	$(call if_changed,ld)
 	@:
@@ -99,7 +106,17 @@ $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj
 $(obj)/piggy.gz: $(obj)/../Image FORCE
 	$(call if_changed,gzip)
 
-$(obj)/piggy.o:  $(obj)/piggy.gz FORCE
+$(obj)/piggy.bz2: $(obj)/../Image FORCE
+	$(call if_changed,bzip2)
+
+$(obj)/piggy.lzma: $(obj)/../Image FORCE
+	$(call if_changed,lzma)
+
+$(obj)/piggy.gz.o:  $(obj)/piggy.gz FORCE
+
+$(obj)/piggy.bz2.o:  $(obj)/piggy.bz2 FORCE
+
+$(obj)/piggy.lzma.o:  $(obj)/piggy.lzma FORCE
 
 CFLAGS_font.o := -Dstatic=
 
diff -urNp x86/arch/arm/boot/compressed/misc.c arm/arch/arm/boot/compressed/misc.c
--- x86/arch/arm/boot/compressed/misc.c	2009-01-04 22:29:52.000000000 +0100
+++ arm/arch/arm/boot/compressed/misc.c	2009-01-04 22:13:36.000000000 +0100
@@ -18,6 +18,9 @@
 
 unsigned int __machine_arch_type;
 
+/* ARM has no support for division or modulo in its pre-boot environment */
+#define NO_DIVISION
+
 #include <linux/string.h>
 
 #ifdef STANDALONE_DEBUG
@@ -171,116 +174,31 @@ static inline __ptr_t memcpy(__ptr_t __d
 /*
  * gzip delarations
  */
-#define OF(args)  args
 #define STATIC static
 
-typedef unsigned char  uch;
-typedef unsigned short ush;
-typedef unsigned long  ulg;
-
-#define WSIZE 0x8000		/* Window size must be at least 32k, */
-				/* and a power of two */
-
-static uch *inbuf;		/* input buffer */
-static uch window[WSIZE];	/* Sliding window buffer */
-
-static unsigned insize;		/* valid bytes in inbuf */
-static unsigned inptr;		/* index of next byte to be processed in inbuf */
-static unsigned outcnt;		/* bytes in output buffer */
-
-/* gzip flag byte */
-#define ASCII_FLAG   0x01 /* bit 0 set: file probably ascii text */
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
-
 extern char input_data[];
 extern char input_data_end[];
 
-static uch *output_data;
-static ulg output_ptr;
-static ulg bytes_out;
-
 static void error(char *m);
 
-static void putstr(const char *);
-
-extern int end;
-static ulg free_mem_ptr;
-static ulg free_mem_end_ptr;
-
-#ifdef STANDALONE_DEBUG
-#define NO_INFLATE_MALLOC
-#endif
+static unsigned long free_mem_ptr;
+static unsigned long free_mem_end_ptr;
 
 #define ARCH_HAS_DECOMP_WDOG
 
-#include "../../../../lib/inflate.c"
+#ifdef CONFIG_KERNEL_GZIP
+#include "../../../../lib/decompress_inflate.c"
+#endif
 
-/* ===========================================================================
- * Fill the input buffer. This is called only when the buffer is empty
- * and at least one byte is really needed.
- */
-int fill_inbuf(void)
-{
-	if (insize != 0)
-		error("ran out of input data");
+#ifdef CONFIG_KERNEL_BZIP2
+#include "../../../../lib/decompress_bunzip2.c"
+#endif
 
-	inbuf = input_data;
-	insize = &input_data_end[0] - &input_data[0];
+#ifdef CONFIG_KERNEL_LZMA
+#include "../../../../lib/decompress_unlzma.c"
+#endif
 
-	inptr = 1;
-	return inbuf[0];
-}
 
-/* ===========================================================================
- * Write the output window window[0..outcnt-1] and update crc and bytes_out.
- * (Used for the decompressed data only.)
- */
-void flush_window(void)
-{
-	ulg c = crc;
-	unsigned n;
-	uch *in, *out, ch;
-
-	in = window;
-	out = &output_data[output_ptr];
-	for (n = 0; n < outcnt; n++) {
-		ch = *out++ = *in++;
-		c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
-	}
-	crc = c;
-	bytes_out += (ulg)outcnt;
-	output_ptr += (ulg)outcnt;
-	outcnt = 0;
-	putstr(".");
-}
 
 #ifndef arch_error
 #define arch_error(x)
@@ -299,20 +217,30 @@ static void error(char *x)
 
 #ifndef STANDALONE_DEBUG
 
-ulg
-decompress_kernel(ulg output_start, ulg free_mem_ptr_p, ulg free_mem_ptr_end_p,
+unsigned long
+decompress_kernel(unsigned long output_start,
+		  unsigned long free_mem_ptr_p,
+		  unsigned long free_mem_ptr_end_p,
 		  int arch_id)
 {
-	output_data		= (uch *)output_start;	/* Points to kernel start */
-	free_mem_ptr		= free_mem_ptr_p;
-	free_mem_end_ptr	= free_mem_ptr_end_p;
+	unsigned long output_ptr;
+	unsigned long *ptr;
+	size_t input_len	= input_data_end - input_data;
+	size_t pos		= 0;
+
 	__machine_arch_type	= arch_id;
 
 	arch_decomp_setup();
 
-	makecrc();
-	putstr("Uncompressing Linux...");
-	gunzip();
+	ptr = (unsigned long *) (((long)input_data_end) - 4);
+	output_ptr = output_start +  *ptr;
+
+	free_mem_ptr		= output_ptr;
+	free_mem_end_ptr	= output_ptr + 0x4000000;
+
+	putstr("Decompressing Linux...");
+	decompress(input_data, input_len,
+		   NULL, NULL, (unsigned char *) output_start, &pos, error);
 	putstr(" done, booting the kernel.\n");
 	return output_ptr;
 }
@@ -322,11 +250,8 @@ char output_buffer[1500*1024];
 
 int main()
 {
-	output_data = output_buffer;
-
-	makecrc();
 	putstr("Uncompressing Linux...");
-	gunzip();
+	decompress(input_data, input_len, NULL, output_buffer, NULL);
 	putstr("done.\n");
 	return 0;
 }
diff -urNp x86/arch/arm/boot/compressed/piggy.bz2.S arm/arch/arm/boot/compressed/piggy.bz2.S
--- x86/arch/arm/boot/compressed/piggy.bz2.S	1970-01-01 01:00:00.000000000 +0100
+++ arm/arch/arm/boot/compressed/piggy.bz2.S	2009-01-04 22:13:36.000000000 +0100
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.bz2"
+	.globl	input_data_end
+input_data_end:
diff -urNp x86/arch/arm/boot/compressed/piggy.gz.S arm/arch/arm/boot/compressed/piggy.gz.S
--- x86/arch/arm/boot/compressed/piggy.gz.S	1970-01-01 01:00:00.000000000 +0100
+++ arm/arch/arm/boot/compressed/piggy.gz.S	2009-01-04 22:13:36.000000000 +0100
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.gz"
+	.globl	input_data_end
+input_data_end:
diff -urNp x86/arch/arm/boot/compressed/piggy.lzma.S arm/arch/arm/boot/compressed/piggy.lzma.S
--- x86/arch/arm/boot/compressed/piggy.lzma.S	1970-01-01 01:00:00.000000000 +0100
+++ arm/arch/arm/boot/compressed/piggy.lzma.S	2009-01-04 22:13:36.000000000 +0100
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lzma"
+	.globl	input_data_end
+input_data_end:
diff -urNp x86/arch/arm/boot/compressed/piggy.S arm/arch/arm/boot/compressed/piggy.S
--- x86/arch/arm/boot/compressed/piggy.S	2009-01-04 22:29:52.000000000 +0100
+++ arm/arch/arm/boot/compressed/piggy.S	1970-01-01 01:00:00.000000000 +0100
@@ -1,6 +0,0 @@
-	.section .piggydata,#alloc
-	.globl	input_data
-input_data:
-	.incbin	"arch/arm/boot/compressed/piggy.gz"
-	.globl	input_data_end
-input_data_end:
diff -urNp x86/include/linux/zutil.h arm/include/linux/zutil.h
--- x86/include/linux/zutil.h	2009-01-04 22:29:52.000000000 +0100
+++ arm/include/linux/zutil.h	2009-01-04 22:13:36.000000000 +0100
@@ -60,6 +60,19 @@ typedef uLong (*check_func) (uLong check
 #define DO8(buf,i)  DO4(buf,i); DO4(buf,i+4);
 #define DO16(buf)   DO8(buf,0); DO8(buf,8);
 
+#ifdef NO_DIVISION
+static inline unsigned long mod65521(unsigned long s)
+{
+	while (1) {
+		if (s < BASE)
+			return s;
+		if (s < 0x10000)
+			return s-BASE;
+		s = (s & 0xffff) + 15 * (s >> 16);
+	}
+}
+#endif
+
 /* ========================================================================= */
 /*
      Update a running Adler-32 checksum with the bytes buf[0..len-1] and
@@ -97,8 +110,13 @@ static inline uLong zlib_adler32(uLong a
             s1 += *buf++;
 	    s2 += s1;
         } while (--k);
+#ifdef NO_DIVISION
+	s1 = mod65521(s1);
+	s2 = mod65521(s2);
+#else
         s1 %= BASE;
         s2 %= BASE;
+#endif
     }
     return (s2 << 16) | s1;
 }
diff -urNp x86/lib/zlib_inflate/inflate.c arm/lib/zlib_inflate/inflate.c
--- x86/lib/zlib_inflate/inflate.c	2009-01-04 22:29:52.000000000 +0100
+++ arm/lib/zlib_inflate/inflate.c	2009-01-04 22:13:36.000000000 +0100
@@ -247,6 +247,23 @@ static int zlib_inflateSyncPacket(z_stre
     ((((q) >> 24) & 0xff) + (((q) >> 8) & 0xff00) + \
      (((q) & 0xff00) << 8) + (((q) & 0xff) << 24))
 
+#ifdef NO_DIVISION
+/*
+  modulo 15 routine for those architectures that don't have division
+*/
+static inline unsigned long mod31(unsigned long s)
+{
+	while (1) {
+		if (s < 31)
+			return s;
+		if (s < 32)
+			return 0;
+		s = (s >> 5) + (s & 31);
+	}
+}
+#endif
+
+
 /*
    inflate() uses a state machine to process as much input data and generate as
    much output data as possible before returning.  The state machine is
@@ -370,7 +387,12 @@ int zlib_inflate(z_streamp strm, int flu
             }
             NEEDBITS(16);
             if (
-                ((BITS(8) << 8) + (hold >> 8)) % 31) {
+#ifdef NO_DIVISION
+		mod31((BITS(8) << 8) + (hold >> 8))
+#else
+		((BITS(8) << 8) + (hold >> 8)) % 31
+#endif
+		) {
                 strm->msg = (char *)"incorrect header check";
                 state->mode = BAD;
                 break;
