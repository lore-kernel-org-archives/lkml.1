Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYJNTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYJNTp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYJNTog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:44:36 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:49900 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYJNTob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:44:31 -0400
Date: Tue, 14 Oct 2008 21:44:27 +0200
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200810141944.m9EJiRIG011709@hitchhiker>
Subject: update7 [PATCH 4/5] init: bzip2 or lzma -compressed kernels and initrds
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

This version applies to "tip" kernel 2.6.27

This part contains:
- support for new bzip2 and lzma kernel compression for ARM

N.B. If there is already a version of this in the officieal ARM tree,
please disregard the version in this mail.

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -urNp x86/arch/arm/boot/compressed/Makefile arm/arch/arm/boot/compressed/Makefile
--- x86/arch/arm/boot/compressed/Makefile	2008-10-11 14:11:44.000000000 +0200
+++ arm/arch/arm/boot/compressed/Makefile	2008-10-14 00:09:05.000000000 +0200
@@ -67,8 +67,15 @@ endif
 
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
 
 ifeq ($(CONFIG_FTRACE),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
@@ -95,7 +102,7 @@ LDFLAGS_vmlinux += -p --no-undefined -X 
 # would otherwise mess up our GOT table
 CFLAGS_misc.o := -Dstatic=
 
-$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
 	 	$(addprefix $(obj)/, $(OBJS)) FORCE
 	$(call if_changed,ld)
 	@:
@@ -103,7 +110,17 @@ $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj
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
--- x86/arch/arm/boot/compressed/misc.c	2008-10-11 14:11:44.000000000 +0200
+++ arm/arch/arm/boot/compressed/misc.c	2008-10-14 02:14:38.000000000 +0200
@@ -169,116 +169,34 @@ static inline __ptr_t memcpy(__ptr_t __d
 /*
  * gzip delarations
  */
-#define OF(args)  args
 #define STATIC static
 
-typedef unsigned char  uch;
-typedef unsigned short ush;
 typedef unsigned long  ulg;
 
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
 static ulg free_mem_ptr;
 static ulg free_mem_end_ptr;
 
-#ifdef STANDALONE_DEBUG
-#define NO_INFLATE_MALLOC
-#endif
-
 #define ARCH_HAS_DECOMP_WDOG
+#define NEW_CODE
 
+#ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/inflate.c"
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
@@ -301,16 +219,24 @@ ulg
 decompress_kernel(ulg output_start, ulg free_mem_ptr_p, ulg free_mem_ptr_end_p,
 		  int arch_id)
 {
-	output_data		= (uch *)output_start;	/* Points to kernel start */
-	free_mem_ptr		= free_mem_ptr_p;
-	free_mem_end_ptr	= free_mem_ptr_end_p;
+	ulg output_ptr;
+	ulg *ptr;
+	size_t input_len	= input_data_end - input_data;
+	size_t pos		= 0;
+
 	__machine_arch_type	= arch_id;
 
 	arch_decomp_setup();
 
-	makecrc();
-	putstr("Uncompressing Linux...");
-	gunzip();
+	ptr = (ulg *) (((long)input_data_end) - 4);
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
@@ -320,11 +246,8 @@ char output_buffer[1500*1024];
 
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
+++ arm/arch/arm/boot/compressed/piggy.bz2.S	2008-10-14 00:09:05.000000000 +0200
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.bz2"
+	.globl	input_data_end
+input_data_end:
diff -urNp x86/arch/arm/boot/compressed/piggy.gz.S arm/arch/arm/boot/compressed/piggy.gz.S
--- x86/arch/arm/boot/compressed/piggy.gz.S	1970-01-01 01:00:00.000000000 +0100
+++ arm/arch/arm/boot/compressed/piggy.gz.S	2008-10-14 00:09:05.000000000 +0200
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.gz"
+	.globl	input_data_end
+input_data_end:
diff -urNp x86/arch/arm/boot/compressed/piggy.lzma.S arm/arch/arm/boot/compressed/piggy.lzma.S
--- x86/arch/arm/boot/compressed/piggy.lzma.S	1970-01-01 01:00:00.000000000 +0100
+++ arm/arch/arm/boot/compressed/piggy.lzma.S	2008-10-14 00:09:05.000000000 +0200
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lzma"
+	.globl	input_data_end
+input_data_end:
diff -urNp x86/arch/arm/boot/compressed/piggy.S arm/arch/arm/boot/compressed/piggy.S
--- x86/arch/arm/boot/compressed/piggy.S	2008-10-11 14:11:44.000000000 +0200
+++ arm/arch/arm/boot/compressed/piggy.S	1970-01-01 01:00:00.000000000 +0100
@@ -1,6 +0,0 @@
-	.section .piggydata,#alloc
-	.globl	input_data
-input_data:
-	.incbin	"arch/arm/boot/compressed/piggy.gz"
-	.globl	input_data_end
-input_data_end:
