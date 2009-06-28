Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZF1OR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZF1OR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbZF1OQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:16:19 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:49139 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054AbZF1OQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:16:04 -0400
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jun 2009 10:16:02 EDT
Message-ID: <4A4776DD.50105@knaff.lu>
Date: Sun, 28 Jun 2009 15:57:49 +0200
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
References: <4A428AFF.20307@free-electrons.com> <4A433BCD.2030506@compulab.co.il> <200906251104.02830.florian@openwrt.org> <4A4396CB.9000703@free-electrons.com>
In-Reply-To: <4A4396CB.9000703@free-electrons.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000904020400040004070305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000904020400040004070305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached is a version of the ARM patch for 2.6.30

There seems to be some issues with the include files (which did not pose
any problems in 2.6.28...), but hopefully somebody more experienced with
the ARM architecture (and with its recent development) than I can help
out there.

Regards,

Alain


--------------000904020400040004070305
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
+++ linux-2.6.30.arm/arch/arm/boot/compressed/misc.c	2009-06-28 15:06:43.000000000 +0200
@@ -18,6 +18,9 @@
 
 unsigned int __machine_arch_type;
 
+/* ARM has no support for division or modulo in its pre-boot environment */
+#define NO_DIVISION
+
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
@@ -189,116 +192,31 @@ static inline __ptr_t memcpy(__ptr_t __d
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
@@ -317,20 +235,30 @@ static void error(char *x)
 
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
@@ -340,11 +268,8 @@ char output_buffer[1500*1024];
 
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
diff -purN linux-2.6.30/arch/arm/Kconfig~ linux-2.6.30.arm/arch/arm/Kconfig~
--- linux-2.6.30/arch/arm/Kconfig~	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30.arm/arch/arm/Kconfig~	2009-06-10 05:05:27.000000000 +0200
@@ -0,0 +1,1436 @@
+#
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+#
+
+mainmenu "Linux Kernel Configuration"
+
+config ARM
+	bool
+	default y
+	select HAVE_AOUT
+	select HAVE_IDE
+	select RTC_LIB
+	select SYS_SUPPORTS_APM_EMULATION
+	select HAVE_OPROFILE
+	select HAVE_ARCH_KGDB
+	select HAVE_KPROBES if (!XIP_KERNEL)
+	select HAVE_KRETPROBES if (HAVE_KPROBES)
+	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_GENERIC_DMA_COHERENT
+	help
+	  The ARM series is a line of low-power-consumption RISC chip designs
+	  licensed by ARM Ltd and targeted at embedded applications and
+	  handhelds such as the Compaq IPAQ.  ARM-based PCs are no longer
+	  manufactured, but legacy ARM-based PC hardware remains popular in
+	  Europe.  There is an ARM Linux project with a web page at
+	  <http://www.arm.linux.org.uk/>.
+
+config HAVE_PWM
+	bool
+
+config SYS_SUPPORTS_APM_EMULATION
+	bool
+
+config GENERIC_GPIO
+	bool
+	default n
+
+config GENERIC_TIME
+	bool
+	default n
+
+config GENERIC_CLOCKEVENTS
+	bool
+	default n
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	depends on GENERIC_CLOCKEVENTS
+	default y if SMP && !LOCAL_TIMERS
+
+config MMU
+	bool
+	default y
+
+config NO_IOPORT
+	bool
+	default n
+
+config EISA
+	bool
+	---help---
+	  The Extended Industry Standard Architecture (EISA) bus was
+	  developed as an open alternative to the IBM MicroChannel bus.
+
+	  The EISA bus provided some of the features of the IBM MicroChannel
+	  bus while maintaining backward compatibility with cards made for
+	  the older ISA bus.  The EISA bus saw limited use between 1988 and
+	  1995 when it was made obsolete by the PCI bus.
+
+	  Say Y here if you are building a kernel for an EISA-based machine.
+
+	  Otherwise, say N.
+
+config SBUS
+	bool
+
+config MCA
+	bool
+	help
+	  MicroChannel Architecture is found in some IBM PS/2 machines and
+	  laptops.  It is a bus system similar to PCI or ISA. See
+	  <file:Documentation/mca.txt> (and especially the web page given
+	  there) before attempting to build an MCA bus kernel.
+
+config GENERIC_HARDIRQS
+	bool
+	default y
+
+config STACKTRACE_SUPPORT
+	bool
+	default y
+
+config HAVE_LATENCYTOP_SUPPORT
+	bool
+	depends on !SMP
+	default y
+
+config LOCKDEP_SUPPORT
+	bool
+	default y
+
+config TRACE_IRQFLAGS_SUPPORT
+	bool
+	default y
+
+config HARDIRQS_SW_RESEND
+	bool
+	default y
+
+config GENERIC_IRQ_PROBE
+	bool
+	default y
+
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
+config RWSEM_GENERIC_SPINLOCK
+	bool
+	default y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
+config GENERIC_HWEIGHT
+	bool
+	default y
+
+config GENERIC_CALIBRATE_DELAY
+	bool
+	default y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+
+config ZONE_DMA
+	bool
+
+config GENERIC_ISA_DMA
+	bool
+
+config FIQ
+	bool
+
+config ARCH_MTD_XIP
+	bool
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
+if OPROFILE
+
+config OPROFILE_ARMV6
+	def_bool y
+	depends on CPU_V6 && !SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	def_bool y
+	depends on CPU_V6 && SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
+config OPROFILE_ARMV7
+	def_bool y
+	depends on CPU_V7 && !SMP
+	bool
+
+endif
+
+config VECTORS_BASE
+	hex
+	default 0xffff0000 if MMU || CPU_HIGH_VECTOR
+	default DRAM_BASE if REMAP_VECTORS_TO_RAM
+	default 0x00000000
+	help
+	  The base address of exception vectors.
+
+source "init/Kconfig"
+
+source "kernel/Kconfig.freezer"
+
+menu "System Type"
+
+choice
+	prompt "ARM system type"
+	default ARCH_VERSATILE
+
+config ARCH_AAEC2000
+	bool "Agilent AAEC-2000 based"
+	select CPU_ARM920T
+	select ARM_AMBA
+	select HAVE_CLK
+	help
+	  This enables support for systems based on the Agilent AAEC-2000
+
+config ARCH_INTEGRATOR
+	bool "ARM Ltd. Integrator family"
+	select ARM_AMBA
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select ICST525
+	help
+	  Support for ARM's Integrator platform.
+
+config ARCH_REALVIEW
+	bool "ARM Ltd. RealView family"
+	select ARM_AMBA
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select ICST307
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	help
+	  This enables support for ARM Ltd RealView boards.
+
+config ARCH_VERSATILE
+	bool "ARM Ltd. Versatile family"
+	select ARM_AMBA
+	select ARM_VIC
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select ICST307
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	help
+	  This enables support for ARM Ltd Versatile board.
+
+config ARCH_AT91
+	bool "Atmel AT91"
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_CLK
+	help
+	  This enables support for systems based on the Atmel AT91RM9200,
+	  AT91SAM9 and AT91CAP9 processors.
+
+config ARCH_CLPS711X
+	bool "Cirrus Logic CLPS711x/EP721x-based"
+	select CPU_ARM720T
+	help
+	  Support for Cirrus Logic 711x/721x based boards.
+
+config ARCH_EBSA110
+	bool "EBSA-110"
+	select CPU_SA110
+	select ISA
+	select NO_IOPORT
+	help
+	  This is an evaluation board for the StrongARM processor available
+	  from Digital. It has limited hardware on-board, including an
+	  Ethernet interface, two PCMCIA sockets, two serial ports and a
+	  parallel port.
+
+config ARCH_EP93XX
+	bool "EP93xx-based"
+	select CPU_ARM920T
+	select ARM_AMBA
+	select ARM_VIC
+	select GENERIC_GPIO
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_HAS_HOLES_MEMORYMODEL
+	help
+	  This enables support for the Cirrus EP93xx series of CPUs.
+
+config ARCH_GEMINI
+	bool "Cortina Systems Gemini"
+	select CPU_FA526
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	help
+	  Support for the Cortina Systems Gemini family SoCs
+
+config ARCH_FOOTBRIDGE
+	bool "FootBridge"
+	select CPU_SA110
+	select FOOTBRIDGE
+	help
+	  Support for systems based on the DC21285 companion chip
+	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
+
+config ARCH_NETX
+	bool "Hilscher NetX based"
+	select CPU_ARM926T
+	select ARM_VIC
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_TIME
+	help
+	  This enables support for systems based on the Hilscher NetX Soc
+
+config ARCH_H720X
+	bool "Hynix HMS720x-based"
+	select CPU_ARM720T
+	select ISA_DMA_API
+	help
+	  This enables support for systems based on the Hynix HMS720x
+
+config ARCH_IMX
+	bool "IMX"
+	select CPU_ARM920T
+	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	help
+	  Support for Motorola's i.MX family of processors (MX1, MXL).
+
+config ARCH_IOP13XX
+	bool "IOP13xx-based"
+	depends on MMU
+	select CPU_XSC3
+	select PLAT_IOP
+	select PCI
+	select ARCH_SUPPORTS_MSI
+	select VMSPLIT_1G
+	help
+	  Support for Intel's IOP13XX (XScale) family of processors.
+
+config ARCH_IOP32X
+	bool "IOP32x-based"
+	depends on MMU
+	select CPU_XSCALE
+	select PLAT_IOP
+	select PCI
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	help
+	  Support for Intel's 80219 and IOP32X (XScale) family of
+	  processors.
+
+config ARCH_IOP33X
+	bool "IOP33x-based"
+	depends on MMU
+	select CPU_XSCALE
+	select PLAT_IOP
+	select PCI
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	help
+	  Support for Intel's IOP33X (XScale) family of processors.
+
+config ARCH_IXP23XX
+ 	bool "IXP23XX-based"
+	depends on MMU
+	select CPU_XSC3
+ 	select PCI
+	help
+	  Support for Intel's IXP23xx (XScale) family of processors.
+
+config ARCH_IXP2000
+	bool "IXP2400/2800-based"
+	depends on MMU
+	select CPU_XSCALE
+	select PCI
+	help
+	  Support for Intel's IXP2400/2800 (XScale) family of processors.
+
+config ARCH_IXP4XX
+	bool "IXP4xx-based"
+	depends on MMU
+	select CPU_XSCALE
+	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select DMABOUNCE if PCI
+	help
+	  Support for Intel's IXP4XX (XScale) family of processors.
+
+config ARCH_L7200
+	bool "LinkUp-L7200"
+	select CPU_ARM720T
+	select FIQ
+	help
+	  Say Y here if you intend to run this kernel on a LinkUp Systems
+	  L7200 Software Development Board which uses an ARM720T processor.
+	  Information on this board can be obtained at:
+
+	  <http://www.linkupsys.com/>
+
+	  If you have any questions or comments about the Linux kernel port
+	  to this board, send e-mail to <sjhill@cotw.com>.
+
+config ARCH_KIRKWOOD
+	bool "Marvell Kirkwood"
+	select CPU_FEROCEON
+	select PCI
+	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select PLAT_ORION
+	help
+	  Support for the following Marvell Kirkwood series SoCs:
+	  88F6180, 88F6192 and 88F6281.
+
+config ARCH_KS8695
+	bool "Micrel/Kendin KS8695"
+	select CPU_ARM922T
+	select GENERIC_GPIO
+        select ARCH_REQUIRE_GPIOLIB
+	help
+	  Support for Micrel/Kendin KS8695 "Centaur" (ARM922T) based
+	  System-on-Chip devices.
+
+config ARCH_NS9XXX
+	bool "NetSilicon NS9xxx"
+	select CPU_ARM926T
+	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
+	help
+	  Say Y here if you intend to run this kernel on a NetSilicon NS9xxx
+	  System.
+
+	  <http://www.digi.com/products/microprocessors/index.jsp>
+
+config ARCH_LOKI
+	bool "Marvell Loki (88RC8480)"
+	select CPU_FEROCEON
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select PLAT_ORION
+	help
+	  Support for the Marvell Loki (88RC8480) SoC.
+
+config ARCH_MV78XX0
+	bool "Marvell MV78xx0"
+	select CPU_FEROCEON
+	select PCI
+	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select PLAT_ORION
+	help
+	  Support for the following Marvell MV78xx0 series SoCs:
+	  MV781x0, MV782x0.
+
+config ARCH_MXC
+	bool "Freescale MXC/iMX-based"
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select ARCH_MTD_XIP
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_CLK
+	help
+	  Support for Freescale MXC/iMX-based family of processors
+
+config ARCH_ORION5X
+	bool "Marvell Orion"
+	depends on MMU
+	select CPU_FEROCEON
+	select PCI
+	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select PLAT_ORION
+	help
+	  Support for the following Marvell Orion 5x series SoCs:
+	  Orion-1 (5181), Orion-VoIP (5181L), Orion-NAS (5182),
+	  Orion-2 (5281), Orion-1-90 (6183).
+
+config ARCH_PNX4008
+	bool "Philips Nexperia PNX4008 Mobile"
+	select CPU_ARM926T
+	select HAVE_CLK
+	help
+	  This enables support for Philips PNX4008 mobile platform.
+
+config ARCH_PXA
+	bool "PXA2xx/PXA3xx-based"
+	depends on MMU
+	select ARCH_MTD_XIP
+	select GENERIC_GPIO
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select ARCH_REQUIRE_GPIOLIB
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select TICK_ONESHOT
+	select PLAT_PXA
+	help
+	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
+
+config ARCH_MMP
+	bool "Marvell PXA168/910"
+	depends on MMU
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select TICK_ONESHOT
+	select PLAT_PXA
+	help
+	  Support for Marvell's PXA168/910 processor line.
+
+config ARCH_RPC
+	bool "RiscPC"
+	select ARCH_ACORN
+	select FIQ
+	select TIMER_ACORN
+	select ARCH_MAY_HAVE_PC_FDC
+	select HAVE_PATA_PLATFORM
+	select ISA_DMA_API
+	select NO_IOPORT
+	select ARCH_SPARSEMEM_ENABLE
+	help
+	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
+	  CD-ROM interface, serial and parallel port, and the floppy drive.
+
+config ARCH_SA1100
+	bool "SA1100-based"
+	select CPU_SA1100
+	select ISA
+	select ARCH_SPARSEMEM_ENABLE
+	select ARCH_MTD_XIP
+	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
+	select TICK_ONESHOT
+	select ARCH_REQUIRE_GPIOLIB
+	help
+	  Support for StrongARM 11x0 based boards.
+
+config ARCH_S3C2410
+	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
+	select GENERIC_GPIO
+	select HAVE_CLK
+	help
+	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
+	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
+	  the Samsung SMDK2410 development board (and derivatives).
+
+config ARCH_S3C64XX
+	bool "Samsung S3C64XX"
+	select GENERIC_GPIO
+	select HAVE_CLK
+	help
+	  Samsung S3C64XX series based systems
+
+config ARCH_SHARK
+	bool "Shark"
+	select CPU_SA110
+	select ISA
+	select ISA_DMA
+	select ZONE_DMA
+	select PCI
+	help
+	  Support for the StrongARM based Digital DNARD machine, also known
+	  as "Shark" (<http://www.shark-linux.de/shark.html>).
+
+config ARCH_LH7A40X
+	bool "Sharp LH7A40X"
+	select CPU_ARM922T
+	select ARCH_DISCONTIGMEM_ENABLE if !LH7A40X_CONTIGMEM
+	select ARCH_SPARSEMEM_ENABLE if !LH7A40X_CONTIGMEM
+	help
+	  Say Y here for systems based on one of the Sharp LH7A40X
+	  System on a Chip processors.  These CPUs include an ARM922T
+	  core with a wide array of integrated devices for
+	  hand-held and low-power applications.
+
+config ARCH_DAVINCI
+	bool "TI DaVinci"
+	select CPU_ARM926T
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_CLK
+	select ZONE_DMA
+	select HAVE_IDE
+	select COMMON_CLKDEV
+	help
+	  Support for TI's DaVinci platform.
+
+config ARCH_OMAP
+	bool "TI OMAP"
+	select GENERIC_GPIO
+	select HAVE_CLK
+	select ARCH_REQUIRE_GPIOLIB
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	help
+	  Support for TI's OMAP platform (OMAP1 and OMAP2).
+
+config ARCH_MSM
+	bool "Qualcomm MSM"
+	select CPU_V6
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	help
+	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
+	  apps processor of the MSM7K and depends on a shared memory
+	  interface to the ARM9 modem processor which runs the baseband stack
+	  and controls some vital subsystems (clock and power control, etc).
+
+config ARCH_W90X900
+	bool "Nuvoton W90X900 CPU"
+	select CPU_ARM926T
+	help
+		Support for Nuvoton (Winbond logic dept.) ARM9 processor,You
+		can login www.mcuos.com or www.nuvoton.com to know more.
+
+endchoice
+
+source "arch/arm/mach-clps711x/Kconfig"
+
+source "arch/arm/mach-ep93xx/Kconfig"
+
+source "arch/arm/mach-footbridge/Kconfig"
+
+source "arch/arm/mach-gemini/Kconfig"
+
+source "arch/arm/mach-integrator/Kconfig"
+
+source "arch/arm/mach-iop32x/Kconfig"
+
+source "arch/arm/mach-iop33x/Kconfig"
+
+source "arch/arm/mach-iop13xx/Kconfig"
+
+source "arch/arm/mach-ixp4xx/Kconfig"
+
+source "arch/arm/mach-ixp2000/Kconfig"
+
+source "arch/arm/mach-ixp23xx/Kconfig"
+
+source "arch/arm/mach-loki/Kconfig"
+
+source "arch/arm/mach-mv78xx0/Kconfig"
+
+source "arch/arm/mach-pxa/Kconfig"
+source "arch/arm/plat-pxa/Kconfig"
+
+source "arch/arm/mach-mmp/Kconfig"
+
+source "arch/arm/mach-sa1100/Kconfig"
+
+source "arch/arm/plat-omap/Kconfig"
+
+source "arch/arm/mach-omap1/Kconfig"
+
+source "arch/arm/mach-omap2/Kconfig"
+
+source "arch/arm/mach-orion5x/Kconfig"
+
+source "arch/arm/mach-kirkwood/Kconfig"
+
+source "arch/arm/plat-s3c24xx/Kconfig"
+source "arch/arm/plat-s3c64xx/Kconfig"
+source "arch/arm/plat-s3c/Kconfig"
+
+if ARCH_S3C2410
+source "arch/arm/mach-s3c2400/Kconfig"
+source "arch/arm/mach-s3c2410/Kconfig"
+source "arch/arm/mach-s3c2412/Kconfig"
+source "arch/arm/mach-s3c2440/Kconfig"
+source "arch/arm/mach-s3c2442/Kconfig"
+source "arch/arm/mach-s3c2443/Kconfig"
+endif
+
+if ARCH_S3C64XX
+source "arch/arm/mach-s3c6400/Kconfig"
+source "arch/arm/mach-s3c6410/Kconfig"
+endif
+
+source "arch/arm/mach-lh7a40x/Kconfig"
+
+source "arch/arm/mach-imx/Kconfig"
+
+source "arch/arm/mach-h720x/Kconfig"
+
+source "arch/arm/mach-versatile/Kconfig"
+
+source "arch/arm/mach-aaec2000/Kconfig"
+
+source "arch/arm/mach-realview/Kconfig"
+
+source "arch/arm/mach-at91/Kconfig"
+
+source "arch/arm/plat-mxc/Kconfig"
+
+source "arch/arm/mach-netx/Kconfig"
+
+source "arch/arm/mach-ns9xxx/Kconfig"
+
+source "arch/arm/mach-davinci/Kconfig"
+
+source "arch/arm/mach-ks8695/Kconfig"
+
+source "arch/arm/mach-msm/Kconfig"
+
+source "arch/arm/mach-w90x900/Kconfig"
+
+# Definitions to make life easier
+config ARCH_ACORN
+	bool
+
+config PLAT_IOP
+	bool
+
+config PLAT_ORION
+	bool
+
+config PLAT_PXA
+	bool
+
+source arch/arm/mm/Kconfig
+
+config IWMMXT
+	bool "Enable iWMMXt support"
+	depends on CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK
+	default y if PXA27x || PXA3xx || ARCH_MMP
+	help
+	  Enable support for iWMMXt context switching at run time if
+	  running on a CPU that supports it.
+
+#  bool 'Use XScale PMU as timer source' CONFIG_XSCALE_PMU_TIMER
+config XSCALE_PMU
+	bool
+	depends on CPU_XSCALE && !XSCALE_PMU_TIMER
+	default y
+
+if !MMU
+source "arch/arm/Kconfig-nommu"
+endif
+
+config ARM_ERRATA_411920
+	bool "ARM errata: Invalidation of the Instruction Cache operation can fail"
+	depends on CPU_V6 && !SMP
+	help
+	  Invalidation of the Instruction Cache operation can
+	  fail. This erratum is present in 1136 (before r1p4), 1156 and 1176.
+	  It does not affect the MPCore. This option enables the ARM Ltd.
+	  recommended workaround.
+
+config ARM_ERRATA_430973
+	bool "ARM errata: Stale prediction on replaced interworking branch"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the 430973 Cortex-A8
+	  (r1p0..r1p2) erratum. If a code sequence containing an ARM/Thumb
+	  interworking branch is replaced with another code sequence at the
+	  same virtual address, whether due to self-modifying code or virtual
+	  to physical address re-mapping, Cortex-A8 does not recover from the
+	  stale interworking branch prediction. This results in Cortex-A8
+	  executing the new code sequence in the incorrect ARM or Thumb state.
+	  The workaround enables the BTB/BTAC operations by setting ACTLR.IBE
+	  and also flushes the branch target cache at every context switch.
+	  Note that setting specific bits in the ACTLR register may not be
+	  available in non-secure mode.
+
+config ARM_ERRATA_458693
+	bool "ARM errata: Processor deadlock when a false hazard is created"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the 458693 Cortex-A8 (r2p0)
+	  erratum. For very specific sequences of memory operations, it is
+	  possible for a hazard condition intended for a cache line to instead
+	  be incorrectly associated with a different cache line. This false
+	  hazard might then cause a processor deadlock. The workaround enables
+	  the L1 caching of the NEON accesses and disables the PLD instruction
+	  in the ACTLR register. Note that setting specific bits in the ACTLR
+	  register may not be available in non-secure mode.
+
+config ARM_ERRATA_460075
+	bool "ARM errata: Data written to the L2 cache can be overwritten with stale data"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the 460075 Cortex-A8 (r2p0)
+	  erratum. Any asynchronous access to the L2 cache may encounter a
+	  situation in which recent store transactions to the L2 cache are lost
+	  and overwritten with stale memory contents from external memory. The
+	  workaround disables the write-allocate mode for the L2 cache via the
+	  ACTLR register. Note that setting specific bits in the ACTLR register
+	  may not be available in non-secure mode.
+
+endmenu
+
+source "arch/arm/common/Kconfig"
+
+config FORCE_MAX_ZONEORDER
+	int
+	depends on SA1111
+	default "9"
+
+menu "Bus support"
+
+config ARM_AMBA
+	bool
+
+config ISA
+	bool
+	help
+	  Find out whether you have ISA slots on your motherboard.  ISA is the
+	  name of a bus system, i.e. the way the CPU talks to the other stuff
+	  inside your box.  Other bus systems are PCI, EISA, MicroChannel
+	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
+	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
+
+# Select ISA DMA controller support
+config ISA_DMA
+	bool
+	select ISA_DMA_API
+
+# Select ISA DMA interface
+config ISA_DMA_API
+	bool
+
+config PCI
+	bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE
+	help
+	  Find out whether you have a PCI motherboard. PCI is the name of a
+	  bus system, i.e. the way the CPU talks to the other stuff inside
+	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
+	  VESA. If you have PCI, say Y, otherwise N.
+
+config PCI_SYSCALL
+	def_bool PCI
+
+# Select the host bridge type
+config PCI_HOST_VIA82C505
+	bool
+	depends on PCI && ARCH_SHARK
+	default y
+
+config PCI_HOST_ITE8152
+	bool
+	depends on PCI && MACH_ARMCORE
+	default y
+	select DMABOUNCE
+
+source "drivers/pci/Kconfig"
+
+source "drivers/pcmcia/Kconfig"
+
+endmenu
+
+menu "Kernel Features"
+
+source "kernel/time/Kconfig"
+
+config SMP
+	bool "Symmetric Multi-Processing (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP)
+	select USE_GENERIC_SMP_HELPERS
+	help
+	  This enables support for systems with more than one CPU. If you have
+	  a system with only one CPU, like most personal computers, say N. If
+	  you have a system with more than one CPU, say Y.
+
+	  If you say N here, the kernel will run on single and multiprocessor
+	  machines, but will use only one CPU of a multiprocessor machine. If
+	  you say Y here, the kernel will run on many, but not all, single
+	  processor machines. On a single processor machine, the kernel will
+	  run faster if you say N here.
+
+	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
+	  <http://www.linuxdoc.org/docs.html#howto>.
+
+	  If you don't know what to do here, say N.
+
+choice
+	prompt "Memory split"
+	default VMSPLIT_3G
+	help
+	  Select the desired split between kernel and user memory.
+
+	  If you are not absolutely sure what you are doing, leave this
+	  option alone!
+
+	config VMSPLIT_3G
+		bool "3G/1G user/kernel split"
+	config VMSPLIT_2G
+		bool "2G/2G user/kernel split"
+	config VMSPLIT_1G
+		bool "1G/3G user/kernel split"
+endchoice
+
+config PAGE_OFFSET
+	hex
+	default 0x40000000 if VMSPLIT_1G
+	default 0x80000000 if VMSPLIT_2G
+	default 0xC0000000
+
+config NR_CPUS
+	int "Maximum number of CPUs (2-32)"
+	range 2 32
+	depends on SMP
+	default "4"
+
+config HOTPLUG_CPU
+	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
+	depends on SMP && HOTPLUG && EXPERIMENTAL
+	help
+	  Say Y here to experiment with turning CPUs off and on.  CPUs
+	  can be controlled through /sys/devices/system/cpu.
+
+config LOCAL_TIMERS
+	bool "Use local timer interrupts"
+	depends on SMP && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || REALVIEW_EB_A9MP)
+	default y
+	help
+	  Enable support for local timers on SMP platforms, rather then the
+	  legacy IPI broadcast method.  Local timers allows the system
+	  accounting to be spread across the timer interval, preventing a
+	  "thundering herd" at every timer tick.
+
+config PREEMPT
+	bool "Preemptible Kernel (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  This option reduces the latency of the kernel when reacting to
+	  real-time or interactive events by allowing a low priority process to
+	  be preempted even if it is in kernel mode executing a system call.
+	  This allows applications to run more reliably even when the system is
+	  under load.
+
+	  Say Y here if you are building a kernel for a desktop, embedded
+	  or real-time system.  Say N if you are unsure.
+
+config HZ
+	int
+	default 128 if ARCH_L7200
+	default 200 if ARCH_EBSA110 || ARCH_S3C2410
+	default OMAP_32K_TIMER_HZ if ARCH_OMAP && OMAP_32K_TIMER
+	default AT91_TIMER_HZ if ARCH_AT91
+	default 100
+
+config AEABI
+	bool "Use the ARM EABI to compile the kernel"
+	help
+	  This option allows for the kernel to be compiled using the latest
+	  ARM ABI (aka EABI).  This is only useful if you are using a user
+	  space environment that is also compiled with EABI.
+
+	  Since there are major incompatibilities between the legacy ABI and
+	  EABI, especially with regard to structure member alignment, this
+	  option also changes the kernel syscall calling convention to
+	  disambiguate both ABIs and allow for backward compatibility support
+	  (selected with CONFIG_OABI_COMPAT).
+
+	  To use this you need GCC version 4.0.0 or later.
+
+config OABI_COMPAT
+	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
+	depends on AEABI && EXPERIMENTAL
+	default y
+	help
+	  This option preserves the old syscall interface along with the
+	  new (ARM EABI) one. It also provides a compatibility layer to
+	  intercept syscalls that have structure arguments which layout
+	  in memory differs between the legacy ABI and the new ARM EABI
+	  (only for non "thumb" binaries). This option adds a tiny
+	  overhead to all syscalls and produces a slightly larger kernel.
+	  If you know you'll be using only pure EABI user space then you
+	  can say N here. If this option is not selected and you attempt
+	  to execute a legacy ABI binary then the result will be
+	  UNPREDICTABLE (in fact it can be predicted that it won't work
+	  at all). If in doubt say Y.
+
+config ARCH_HAS_HOLES_MEMORYMODEL
+	bool
+	default n
+
+# Discontigmem is deprecated
+config ARCH_DISCONTIGMEM_ENABLE
+	bool
+
+config ARCH_SPARSEMEM_ENABLE
+	bool
+
+config ARCH_SPARSEMEM_DEFAULT
+	def_bool ARCH_SPARSEMEM_ENABLE
+
+config ARCH_SELECT_MEMORY_MODEL
+	def_bool ARCH_DISCONTIGMEM_ENABLE && ARCH_SPARSEMEM_ENABLE
+
+config NODES_SHIFT
+	int
+	default "4" if ARCH_LH7A40X
+	default "2"
+	depends on NEED_MULTIPLE_NODES
+
+config HIGHMEM
+	bool "High Memory Support (EXPERIMENTAL)"
+	depends on MMU && EXPERIMENTAL
+	help
+	  The address space of ARM processors is only 4 Gigabytes large
+	  and it has to accommodate user address space, kernel address
+	  space as well as some memory mapped IO. That means that, if you
+	  have a large amount of physical memory and/or IO, not all of the
+	  memory can be "permanently mapped" by the kernel. The physical
+	  memory that is not permanently mapped is called "high memory".
+
+	  Depending on the selected kernel/user memory split, minimum
+	  vmalloc space and actual amount of RAM, you may not need this
+	  option which should result in a slightly faster kernel.
+
+	  If unsure, say n.
+
+source "mm/Kconfig"
+
+config LEDS
+	bool "Timer and CPU usage LEDs"
+	depends on ARCH_CDB89712 || ARCH_EBSA110 || \
+		   ARCH_EBSA285 || ARCH_IMX || ARCH_INTEGRATOR || \
+		   ARCH_LUBBOCK || MACH_MAINSTONE || ARCH_NETWINDER || \
+		   ARCH_OMAP || ARCH_P720T || ARCH_PXA_IDP || \
+		   ARCH_SA1100 || ARCH_SHARK || ARCH_VERSATILE || \
+		   ARCH_AT91 || ARCH_DAVINCI || \
+		   ARCH_KS8695 || MACH_RD88F5182
+	help
+	  If you say Y here, the LEDs on your machine will be used
+	  to provide useful information about your current system status.
+
+	  If you are compiling a kernel for a NetWinder or EBSA-285, you will
+	  be able to select which LEDs are active using the options below. If
+	  you are compiling a kernel for the EBSA-110 or the LART however, the
+	  red LED will simply flash regularly to indicate that the system is
+	  still functional. It is safe to say Y here if you have a CATS
+	  system, but the driver will do nothing.
+
+config LEDS_TIMER
+	bool "Timer LED" if (!ARCH_CDB89712 && !ARCH_OMAP) || \
+			    OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
+			    || MACH_OMAP_PERSEUS2
+	depends on LEDS
+	depends on !GENERIC_CLOCKEVENTS
+	default y if ARCH_EBSA110
+	help
+	  If you say Y here, one of the system LEDs (the green one on the
+	  NetWinder, the amber one on the EBSA285, or the red one on the LART)
+	  will flash regularly to indicate that the system is still
+	  operational. This is mainly useful to kernel hackers who are
+	  debugging unstable kernels.
+
+	  The LART uses the same LED for both Timer LED and CPU usage LED
+	  functions. You may choose to use both, but the Timer LED function
+	  will overrule the CPU usage LED.
+
+config LEDS_CPU
+	bool "CPU usage LED" if (!ARCH_CDB89712 && !ARCH_EBSA110 && \
+			!ARCH_OMAP) \
+			|| OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
+			|| MACH_OMAP_PERSEUS2
+	depends on LEDS
+	help
+	  If you say Y here, the red LED will be used to give a good real
+	  time indication of CPU usage, by lighting whenever the idle task
+	  is not currently executing.
+
+	  The LART uses the same LED for both Timer LED and CPU usage LED
+	  functions. You may choose to use both, but the Timer LED function
+	  will overrule the CPU usage LED.
+
+config ALIGNMENT_TRAP
+	bool
+	depends on CPU_CP15_MMU
+	default y if !ARCH_EBSA110
+	help
+	  ARM processors cannot fetch/store information which is not
+	  naturally aligned on the bus, i.e., a 4 byte fetch must start at an
+	  address divisible by 4. On 32-bit ARM processors, these non-aligned
+	  fetch/store instructions will be emulated in software if you say
+	  here, which has a severe performance impact. This is necessary for
+	  correct operation of some network protocols. With an IP-only
+	  configuration it is safe to say N, otherwise say Y.
+
+endmenu
+
+menu "Boot options"
+
+# Compressed boot loader in ROM.  Yes, we really want to ask about
+# TEXT and BSS so we preserve their values in the config files.
+config ZBOOT_ROM_TEXT
+	hex "Compressed ROM boot loader base address"
+	default "0"
+	help
+	  The physical address at which the ROM-able zImage is to be
+	  placed in the target.  Platforms which normally make use of
+	  ROM-able zImage formats normally set this to a suitable
+	  value in their defconfig file.
+
+	  If ZBOOT_ROM is not enabled, this has no effect.
+
+config ZBOOT_ROM_BSS
+	hex "Compressed ROM boot loader BSS address"
+	default "0"
+	help
+	  The base address of an area of read/write memory in the target
+	  for the ROM-able zImage which must be available while the
+	  decompressor is running. It must be large enough to hold the
+	  entire decompressed kernel plus an additional 128 KiB.
+	  Platforms which normally make use of ROM-able zImage formats
+	  normally set this to a suitable value in their defconfig file.
+
+	  If ZBOOT_ROM is not enabled, this has no effect.
+
+config ZBOOT_ROM
+	bool "Compressed boot loader in ROM/flash"
+	depends on ZBOOT_ROM_TEXT != ZBOOT_ROM_BSS
+	help
+	  Say Y here if you intend to execute your compressed kernel image
+	  (zImage) directly from ROM or flash.  If unsure, say N.
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+	help
+	  On some architectures (EBSA110 and CATS), there is currently no way
+	  for the boot loader to pass arguments to the kernel. For these
+	  architectures, you should supply some command-line options at build
+	  time by entering them here. As a minimum, you should specify the
+	  memory size and the root device (e.g., mem=64M root=/dev/nfs).
+
+config XIP_KERNEL
+	bool "Kernel Execute-In-Place from ROM"
+	depends on !ZBOOT_ROM
+	help
+	  Execute-In-Place allows the kernel to run from non-volatile storage
+	  directly addressable by the CPU, such as NOR flash. This saves RAM
+	  space since the text section of the kernel is not loaded from flash
+	  to RAM.  Read-write sections, such as the data section and stack,
+	  are still copied to RAM.  The XIP kernel is not compressed since
+	  it has to run directly from flash, so it will take more space to
+	  store it.  The flash address used to link the kernel object files,
+	  and for storing it, is configuration dependent. Therefore, if you
+	  say Y here, you must know the proper physical address where to
+	  store the kernel image depending on your own flash memory usage.
+
+	  Also note that the make target becomes "make xipImage" rather than
+	  "make zImage" or "make Image".  The final kernel binary to put in
+	  ROM memory will be arch/arm/boot/xipImage.
+
+	  If unsure, say N.
+
+config XIP_PHYS_ADDR
+	hex "XIP Kernel Physical Location"
+	depends on XIP_KERNEL
+	default "0x00080000"
+	help
+	  This is the physical address in your flash memory the kernel will
+	  be linked for and stored to.  This address is dependent on your
+	  own flash usage.
+
+config KEXEC
+	bool "Kexec system call (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  kexec is a system call that implements the ability to shutdown your
+	  current kernel, and to start another kernel.  It is like a reboot
+	  but it is independent of the system firmware.   And like a reboot
+	  you can start any kernel with it, not just Linux.
+
+	  It is an ongoing process to be certain the hardware in a machine
+	  is properly shutdown, so do not be surprised if this code does not
+	  initially work for you.  It may help to enable device hotplugging
+	  support.
+
+config ATAGS_PROC
+	bool "Export atags in procfs"
+	depends on KEXEC
+	default y
+	help
+	  Should the atags used to boot the kernel be exported in an "atags"
+	  file in procfs. Useful with kexec.
+
+endmenu
+
+menu "CPU Power Management"
+
+if (ARCH_SA1100 || ARCH_INTEGRATOR || ARCH_OMAP || ARCH_IMX || ARCH_PXA)
+
+source "drivers/cpufreq/Kconfig"
+
+config CPU_FREQ_SA1100
+	bool
+	depends on CPU_FREQ && (SA1100_H3100 || SA1100_H3600 || SA1100_LART || SA1100_PLEB || SA1100_BADGE4 || SA1100_HACKKIT)
+	default y
+
+config CPU_FREQ_SA1110
+	bool
+	depends on CPU_FREQ && (SA1100_ASSABET || SA1100_CERF || SA1100_PT_SYSTEM3)
+	default y
+
+config CPU_FREQ_INTEGRATOR
+	tristate "CPUfreq driver for ARM Integrator CPUs"
+	depends on ARCH_INTEGRATOR && CPU_FREQ
+	default y
+	help
+	  This enables the CPUfreq driver for ARM Integrator CPUs.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say Y.
+
+config CPU_FREQ_IMX
+	tristate "CPUfreq driver for i.MX CPUs"
+	depends on ARCH_IMX && CPU_FREQ
+	default n
+	help
+	  This enables the CPUfreq driver for i.MX CPUs.
+
+	  If in doubt, say N.
+
+endif
+
+source "drivers/cpuidle/Kconfig"
+
+endmenu
+
+menu "Floating point emulation"
+
+comment "At least one emulation must be selected"
+
+config FPE_NWFPE
+	bool "NWFPE math emulation"
+	depends on !AEABI || OABI_COMPAT
+	---help---
+	  Say Y to include the NWFPE floating point emulator in the kernel.
+	  This is necessary to run most binaries. Linux does not currently
+	  support floating point hardware so you need to say Y here even if
+	  your machine has an FPA or floating point co-processor podule.
+
+	  You may say N here if you are going to load the Acorn FPEmulator
+	  early in the bootup.
+
+config FPE_NWFPE_XP
+	bool "Support extended precision"
+	depends on FPE_NWFPE
+	help
+	  Say Y to include 80-bit support in the kernel floating-point
+	  emulator.  Otherwise, only 32 and 64-bit support is compiled in.
+	  Note that gcc does not generate 80-bit operations by default,
+	  so in most cases this option only enlarges the size of the
+	  floating point emulator without any good reason.
+
+	  You almost surely want to say N here.
+
+config FPE_FASTFPE
+	bool "FastFPE math emulation (EXPERIMENTAL)"
+	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3 && EXPERIMENTAL
+	---help---
+	  Say Y here to include the FAST floating point emulator in the kernel.
+	  This is an experimental much faster emulator which now also has full
+	  precision for the mantissa.  It does not support any exceptions.
+	  It is very simple, and approximately 3-6 times faster than NWFPE.
+
+	  It should be sufficient for most programs.  It may be not suitable
+	  for scientific calculations, but you have to check this for yourself.
+	  If you do not feel you need a faster FP emulation you should better
+	  choose NWFPE.
+
+config VFP
+	bool "VFP-format floating point maths"
+	depends on CPU_V6 || CPU_ARM926T || CPU_V7 || CPU_FEROCEON
+	help
+	  Say Y to include VFP support code in the kernel. This is needed
+	  if your hardware includes a VFP unit.
+
+	  Please see <file:Documentation/arm/VFP/release-notes.txt> for
+	  release notes and additional status information.
+
+	  Say N if your target does not have VFP hardware.
+
+config VFPv3
+	bool
+	depends on VFP
+	default y if CPU_V7
+
+config NEON
+	bool "Advanced SIMD (NEON) Extension support"
+	depends on VFPv3 && CPU_V7
+	help
+	  Say Y to include support code for NEON, the ARMv7 Advanced SIMD
+	  Extension.
+
+endmenu
+
+menu "Userspace binary formats"
+
+source "fs/Kconfig.binfmt"
+
+config ARTHUR
+	tristate "RISC OS personality"
+	depends on !AEABI
+	help
+	  Say Y here to include the kernel code necessary if you want to run
+	  Acorn RISC OS/Arthur binaries under Linux. This code is still very
+	  experimental; if this sounds frightening, say N and sleep in peace.
+	  You can also say M here to compile this support as a module (which
+	  will be called arthur).
+
+endmenu
+
+menu "Power management options"
+
+source "kernel/power/Kconfig"
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+
+endmenu
+
+source "net/Kconfig"
+
+menu "Device Drivers"
+
+source "drivers/base/Kconfig"
+
+source "drivers/connector/Kconfig"
+
+if ALIGNMENT_TRAP || !CPU_CP15_MMU
+source "drivers/mtd/Kconfig"
+endif
+
+source "drivers/parport/Kconfig"
+
+source "drivers/pnp/Kconfig"
+
+source "drivers/block/Kconfig"
+
+# misc before ide - BLK_DEV_SGIIOC4 depends on SGI_IOC4
+
+source "drivers/misc/Kconfig"
+
+source "drivers/ide/Kconfig"
+
+source "drivers/scsi/Kconfig"
+
+source "drivers/ata/Kconfig"
+
+source "drivers/md/Kconfig"
+
+source "drivers/message/fusion/Kconfig"
+
+source "drivers/ieee1394/Kconfig"
+
+source "drivers/message/i2o/Kconfig"
+
+source "drivers/net/Kconfig"
+
+source "drivers/isdn/Kconfig"
+
+# input before char - char/joystick depends on it. As does USB.
+
+source "drivers/input/Kconfig"
+
+source "drivers/char/Kconfig"
+
+source "drivers/i2c/Kconfig"
+
+source "drivers/spi/Kconfig"
+
+source "drivers/gpio/Kconfig"
+
+source "drivers/w1/Kconfig"
+
+source "drivers/power/Kconfig"
+
+source "drivers/hwmon/Kconfig"
+
+source "drivers/thermal/Kconfig"
+
+source "drivers/watchdog/Kconfig"
+
+source "drivers/ssb/Kconfig"
+
+#source "drivers/l3/Kconfig"
+
+source "drivers/mfd/Kconfig"
+
+source "drivers/media/Kconfig"
+
+source "drivers/video/Kconfig"
+
+source "sound/Kconfig"
+
+source "drivers/hid/Kconfig"
+
+source "drivers/usb/Kconfig"
+
+source "drivers/uwb/Kconfig"
+
+source "drivers/mmc/Kconfig"
+
+source "drivers/memstick/Kconfig"
+
+source "drivers/accessibility/Kconfig"
+
+source "drivers/leds/Kconfig"
+
+source "drivers/rtc/Kconfig"
+
+source "drivers/dma/Kconfig"
+
+source "drivers/dca/Kconfig"
+
+source "drivers/auxdisplay/Kconfig"
+
+source "drivers/regulator/Kconfig"
+
+source "drivers/uio/Kconfig"
+
+source "drivers/staging/Kconfig"
+
+endmenu
+
+source "fs/Kconfig"
+
+source "arch/arm/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
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

--------------000904020400040004070305--
