Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbZF1Os0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbZF1Os0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZF1OsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:48:17 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:42890 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZF1OsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:48:14 -0400
Message-ID: <4A478286.8020908@knaff.lu>
Date: Sun, 28 Jun 2009 16:47:34 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Florian Fainelli <florian@openwrt.org>,
       Mike Rapoport <mike@compulab.co.il>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-embedded mailing list <linux-embedded@vger.kernel.org>
Subject: Re: Status of bzip2 and lzma kernel compression for ARM?
References: <4A428AFF.20307@free-electrons.com> <4A433BCD.2030506@compulab.co.il> <200906251104.02830.florian@openwrt.org> <4A4396CB.9000703@free-electrons.com> <4A4776DD.50105@knaff.lu>
In-Reply-To: <4A4776DD.50105@knaff.lu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020600000404040404020106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020600000404040404020106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alain Knaff wrote:
> Attached is a version of the ARM patch for 2.6.30
> 
> There seems to be some issues with the include files (which did not pose
> any problems in 2.6.28...), but hopefully somebody more experienced with
> the ARM architecture (and with its recent development) than I can help
> out there.
> 
> Regards,
> 
> Alain

Actually, the needed changes turned out to be easier than I initially
feared. Attached a version that compiles all right.

Regards,

Alain

--------------020600000404040404020106
Content-Type: text/x-diff;
 name="arm.2.6.30.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arm.2.6.30.diff"

diff -purN linux-2.6.30/arch/arm/boot/compressed/Makefile linux-2.6.30.arm/arch/arm/boot/compressed/Makefile
--- linux-2.6.30/arch/arm/boot/compressed/Makefile	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/arch/arm/boot/compressed/Makefile	2009-06-28 15:29:15.000000000 +0200
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
 
diff -purN linux-2.6.30/arch/arm/boot/compressed/misc.c linux-2.6.30.arm/arch/arm/boot/compressed/misc.c
--- linux-2.6.30/arch/arm/boot/compressed/misc.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/arch/arm/boot/compressed/misc.c	2009-06-28 16:42:55.000000000 +0200
@@ -18,6 +18,12 @@
 
 unsigned int __machine_arch_type;
 
+/* Prevent inclusion of string.h */
+#define _LINUX_STRING_H_
+
+/* ARM has no support for division or modulo in its pre-boot environment */
+#define NO_DIVISION
+
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
@@ -189,116 +195,31 @@ static inline __ptr_t memcpy(__ptr_t __d
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
@@ -317,20 +238,30 @@ static void error(char *x)
 
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
@@ -340,11 +271,8 @@ char output_buffer[1500*1024];
 
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
diff -purN linux-2.6.30/arch/arm/boot/compressed/piggy.bz2.S linux-2.6.30.arm/arch/arm/boot/compressed/piggy.bz2.S
--- linux-2.6.30/arch/arm/boot/compressed/piggy.bz2.S	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30.arm/arch/arm/boot/compressed/piggy.bz2.S	2009-06-28 15:04:21.000000000 +0200
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.bz2"
+	.globl	input_data_end
+input_data_end:
diff -purN linux-2.6.30/arch/arm/boot/compressed/piggy.gz.S linux-2.6.30.arm/arch/arm/boot/compressed/piggy.gz.S
--- linux-2.6.30/arch/arm/boot/compressed/piggy.gz.S	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30.arm/arch/arm/boot/compressed/piggy.gz.S	2009-06-28 15:04:21.000000000 +0200
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.gz"
+	.globl	input_data_end
+input_data_end:
diff -purN linux-2.6.30/arch/arm/boot/compressed/piggy.lzma.S linux-2.6.30.arm/arch/arm/boot/compressed/piggy.lzma.S
--- linux-2.6.30/arch/arm/boot/compressed/piggy.lzma.S	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30.arm/arch/arm/boot/compressed/piggy.lzma.S	2009-06-28 15:04:21.000000000 +0200
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lzma"
+	.globl	input_data_end
+input_data_end:
diff -purN linux-2.6.30/arch/arm/boot/compressed/piggy.S linux-2.6.30.arm/arch/arm/boot/compressed/piggy.S
--- linux-2.6.30/arch/arm/boot/compressed/piggy.S	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/arch/arm/boot/compressed/piggy.S	1970-01-01 01:00:00.000000000 +0100
@@ -1,6 +0,0 @@
-	.section .piggydata,#alloc
-	.globl	input_data
-input_data:
-	.incbin	"arch/arm/boot/compressed/piggy.gz"
-	.globl	input_data_end
-input_data_end:
diff -purN linux-2.6.30/arch/arm/Kconfig linux-2.6.30.arm/arch/arm/Kconfig
--- linux-2.6.30/arch/arm/Kconfig	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/arch/arm/Kconfig	2009-06-28 15:32:49.000000000 +0200
@@ -18,6 +18,9 @@ config ARM
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_BZIP2
+	select HAVE_KERNEL_LZMA
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -purN linux-2.6.30/include/linux/decompress/mm.h linux-2.6.30.arm/include/linux/decompress/mm.h
--- linux-2.6.30/include/linux/decompress/mm.h	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/include/linux/decompress/mm.h	2009-06-28 16:31:23.000000000 +0200
@@ -64,6 +64,8 @@ static void free(void *where)
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
+#include <linux/slab.h>
+
 /* Use defines rather than static inline in order to avoid spurious
  * warnings when not needed (indeed large_malloc / large_free are not
  * needed by inflate */
diff -purN linux-2.6.30/include/linux/zutil.h linux-2.6.30.arm/include/linux/zutil.h
--- linux-2.6.30/include/linux/zutil.h	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/include/linux/zutil.h	2009-06-28 15:04:21.000000000 +0200
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
diff -purN linux-2.6.30/lib/decompress_bunzip2.c linux-2.6.30.arm/lib/decompress_bunzip2.c
--- linux-2.6.30/lib/decompress_bunzip2.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/lib/decompress_bunzip2.c	2009-06-28 16:35:47.000000000 +0200
@@ -50,7 +50,6 @@
 #endif /* !STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
diff -purN linux-2.6.30/lib/decompress_inflate.c linux-2.6.30.arm/lib/decompress_inflate.c
--- linux-2.6.30/lib/decompress_inflate.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/lib/decompress_inflate.c	2009-06-28 16:29:49.000000000 +0200
@@ -23,7 +23,6 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define INBUF_LEN (16*1024)
 
diff -purN linux-2.6.30/lib/decompress_unlzma.c linux-2.6.30.arm/lib/decompress_unlzma.c
--- linux-2.6.30/lib/decompress_unlzma.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/lib/decompress_unlzma.c	2009-06-28 16:43:23.000000000 +0200
@@ -34,7 +34,6 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
diff -purN linux-2.6.30/lib/zlib_inflate/inflate.c linux-2.6.30.arm/lib/zlib_inflate/inflate.c
--- linux-2.6.30/lib/zlib_inflate/inflate.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.arm/lib/zlib_inflate/inflate.c	2009-06-28 15:04:21.000000000 +0200
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

--------------020600000404040404020106--
