Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZGMTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZGMTR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZGMTR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:17:56 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:40538 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbZGMTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:17:53 -0400
Date: Mon, 13 Jul 2009 21:17:47 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Alain Knaff <alain@knaff.lu>, Mike Rapoport <mike@compulab.co.il>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-embedded mailing list <linux-embedded@vger.kernel.org>
Subject: Re: Status of bzip2 and lzma kernel compression for ARM?
Message-ID: <20090713191747.GA4188@pc-ras4041.res.insa>
References: <4A428AFF.20307@free-electrons.com> <4A433BCD.2030506@compulab.co.il> <200906251104.02830.florian@openwrt.org> <4A4396CB.9000703@free-electrons.com> <4A4776DD.50105@knaff.lu> <4A478286.8020908@knaff.lu> <4A48B1D9.90306@compulab.co.il> <20090703154327.GE4278@pc-ras4041.res.insa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703154327.GE4278@pc-ras4041.res.insa>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 05:43:27PM +0200, Albin Tonnerre wrote :
>However, it now hangs right after the 'done, booting the
> kernel.'
> 

After some further work, here's an updated patch that works properly on ARM,
at least for gzip and lzma (I'm getting an 'out of memory' error with bzip2).

As a side note, my previous remarks about the LZMA header not being created
properly only apply to the git tree, as this is caused by commit
d3dd3b5a29bb9582957451531fed461628dfc834. 2.6.30 and 2.6.30.1 don't have this
issue

Regards,
Albin

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9d02cdb..5cde822 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
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
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index fbe5eef..c29a88f 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
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
@@ -91,7 +98,7 @@ LDFLAGS_vmlinux += -p --no-undefined -X \
 # would otherwise mess up our GOT table
 CFLAGS_misc.o := -Dstatic=
 
-$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
 	 	$(addprefix $(obj)/, $(OBJS)) FORCE
 	$(call if_changed,ld)
 	@:
@@ -99,7 +106,17 @@ $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
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
 
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 9e6e512..4ba7249 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
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
@@ -189,116 +195,31 @@ static inline __ptr_t memcpy(__ptr_t __dest, __const __ptr_t __src,
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
+static unsigned long free_mem_ptr;
+static unsigned long free_mem_end_ptr;
 
-extern int end;
-static ulg free_mem_ptr;
-static ulg free_mem_end_ptr;
+#define ARCH_HAS_DECOMP_WDOG
 
-#ifdef STANDALONE_DEBUG
-#define NO_INFLATE_MALLOC
+#ifdef CONFIG_KERNEL_GZIP
+#include "../../../../lib/decompress_inflate.c"
 #endif
 
-#define ARCH_HAS_DECOMP_WDOG
-
-#include "../../../../lib/inflate.c"
+#ifdef CONFIG_KERNEL_BZIP2
+#include "../../../../lib/decompress_bunzip2.c"
+#endif
 
-/* ===========================================================================
- * Fill the input buffer. This is called only when the buffer is empty
- * and at least one byte is really needed.
- */
-int fill_inbuf(void)
-{
-	if (insize != 0)
-		error("ran out of input data");
+#ifdef CONFIG_KERNEL_LZMA
+#include "../../../../lib/decompress_unlzma.c"
+#endif
 
-	inbuf = input_data;
-	insize = &input_data_end[0] - &input_data[0];
 
-	inptr = 1;
-	return inbuf[0];
-}
-
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
@@ -317,20 +238,37 @@ static void error(char *x)
 
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
+	char *ptr;
+	size_t input_len	= input_data_end - input_data;
+	size_t pos		= 0;
+
 	__machine_arch_type	= arch_id;
 
 	arch_decomp_setup();
 
-	makecrc();
-	putstr("Uncompressing Linux...");
-	gunzip();
+	ptr = (unsigned char *) (((unsigned long)input_data_end) - 4);
+
+	/* The uncompressed size is appended at the end of the compressed file, but
+ 	 * we have no guarantee that it's 2-bytes aligned. Therefore, use a char *
+ 	 * to get the size. At least on my box, trying to access a non 2-bytes
+ 	 * aligned unsigned long resulted in some weirdness
+ 	 */
+
+	output_ptr = ptr[0] | ptr[1] << 8 | ptr[2] << 16 | ptr[3] << 24;
+
+	free_mem_ptr		= free_mem_ptr_p;
+	free_mem_end_ptr	= free_mem_ptr_end_p;
+
+	putstr("Decompressing Linux...");
+	decompress(input_data, input_len,
+		   NULL, NULL, (unsigned char *) output_start, &pos, error);
 	putstr(" done, booting the kernel.\n");
 	return output_ptr;
 }
@@ -340,11 +278,8 @@ char output_buffer[1500*1024];
 
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
diff --git a/arch/arm/boot/compressed/piggy.S b/arch/arm/boot/compressed/piggy.S
deleted file mode 100644
index 54c9518..0000000
--- a/arch/arm/boot/compressed/piggy.S
+++ /dev/null
@@ -1,6 +0,0 @@
-	.section .piggydata,#alloc
-	.globl	input_data
-input_data:
-	.incbin	"arch/arm/boot/compressed/piggy.gz"
-	.globl	input_data_end
-input_data_end:
diff --git a/arch/arm/boot/compressed/piggy.bz2.S b/arch/arm/boot/compressed/piggy.bz2.S
new file mode 100644
index 0000000..c5ecbde
--- /dev/null
+++ b/arch/arm/boot/compressed/piggy.bz2.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.bz2"
+	.globl	input_data_end
+input_data_end:
diff --git a/arch/arm/boot/compressed/piggy.gz.S b/arch/arm/boot/compressed/piggy.gz.S
new file mode 100644
index 0000000..54c9518
--- /dev/null
+++ b/arch/arm/boot/compressed/piggy.gz.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.gz"
+	.globl	input_data_end
+input_data_end:
diff --git a/arch/arm/boot/compressed/piggy.lzma.S b/arch/arm/boot/compressed/piggy.lzma.S
new file mode 100644
index 0000000..d7e69cf
--- /dev/null
+++ b/arch/arm/boot/compressed/piggy.lzma.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lzma"
+	.globl	input_data_end
+input_data_end:
diff --git a/arch/arm/boot/uImage.lzma b/arch/arm/boot/uImage.lzma
new file mode 100644
index 0000000..4fb24eb
Binary files /dev/null and b/arch/arm/boot/uImage.lzma differ
diff --git a/include/linux/decompress/mm.h b/include/linux/decompress/mm.h
index 12ff8c3..8becfce 100644
--- a/include/linux/decompress/mm.h
+++ b/include/linux/decompress/mm.h
@@ -64,6 +64,8 @@ static void free(void *where)
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
+#include <linux/slab.h>
+
 /* Use defines rather than static inline in order to avoid spurious
  * warnings when not needed (indeed large_malloc / large_free are not
  * needed by inflate */
diff --git a/include/linux/zutil.h b/include/linux/zutil.h
index 6adfa9a..bedd56b 100644
--- a/include/linux/zutil.h
+++ b/include/linux/zutil.h
@@ -60,6 +60,19 @@ typedef uLong (*check_func) (uLong check, const Byte *buf,
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
@@ -97,8 +110,13 @@ static inline uLong zlib_adler32(uLong adler,
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
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 708e2a8..5d3ddb5 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -50,7 +50,6 @@
 #endif /* !STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index e36b296..839a329 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -23,7 +23,6 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define INBUF_LEN (16*1024)
 
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 32123a1..546f2f4 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -34,7 +34,6 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
diff --git a/lib/zlib_inflate/inflate.c b/lib/zlib_inflate/inflate.c
index f5ce87b..566bf1e 100644
--- a/lib/zlib_inflate/inflate.c
+++ b/lib/zlib_inflate/inflate.c
@@ -247,6 +247,23 @@ static int zlib_inflateSyncPacket(z_streamp strm)
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
@@ -370,7 +387,12 @@ int zlib_inflate(z_streamp strm, int flush)
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

-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
