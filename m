Return-Path: <linux-kernel-owner+w=401wt.eu-S1161194AbXDWGRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161194AbXDWGRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161199AbXDWGRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:17:19 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:48575 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161194AbXDWGRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:17:16 -0400
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "'Sam Ravnborg'" <sam@ravnborg.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>
Cc: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: RE: [PATCH 2.6.20 7/14] CRIS architecture update - Boot
Date: Mon, 23 Apr 2007 08:16:32 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C668030B5AEB@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C6680485BB14@exmail1.se.axis.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch according to Sam's comments.

/Mikael

diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/compressed/decompress.ld
linux-2.6/arch/cris/arch-v32/boot/compressed/decompress.ld
--- ../linux/arch/cris/arch-v32/boot/compressed/decompress.ld	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/compressed/decompress.ld	2003-08-21
11:57:56.000000000 +0200
@@ -1,7 +1,7 @@
 /*#OUTPUT_FORMAT(elf32-us-cris) */
 OUTPUT_ARCH (crisv32)
 
-MEMORY
+MEMORY 
 	{
 	dram : ORIGIN = 0x40700000,
 	       LENGTH = 0x00100000
diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/compressed/head.S
linux-2.6/arch/cris/arch-v32/boot/compressed/head.S
--- ../linux/arch/cris/arch-v32/boot/compressed/head.S	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/compressed/head.S	2007-02-13
12:55:23.000000000 +0100
@@ -2,19 +2,18 @@
  *  Code that sets up the DRAM registers, calls the
  *  decompressor to unpack the piggybacked kernel, and jumps.
  *
- *  Copyright (C) 1999 - 2003, Axis Communications AB
+ *  Copyright (C) 1999 - 2006, Axis Communications AB
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/gio_defs_asm.h>
-#include <asm/arch/hwregs/asm/config_defs_asm.h>
-
+#include <hwregs/asm/reg_map_asm.h>
+#include <asm/arch/mach/startup.inc>
+	
 #define RAM_INIT_MAGIC 0x56902387
 #define COMMAND_LINE_MAGIC 0x87109563
 
 	;; Exported symbols
-
+	
 	.globl	input_data
 
 	.text
@@ -22,119 +21,54 @@
 	di
 
 	;; Start clocks for used blocks.
-	move.d REG_ADDR(config, regi_config, rw_clk_ctrl), $r1
-	move.d [$r1], $r0
-	or.d   REG_STATE(config, rw_clk_ctrl, cpu, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, bif, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, fix_io, yes), $r0
-	move.d $r0, [$r1]
-
-	;; If booting from NAND flash we first have to copy some
-	;; data from NAND flash to internal RAM to get the code
-	;; that initializes the SDRAM. Lets copy 20 KB. This
-	;; code executes at 0x38010000 if booting from NAND and
-	;; we are guaranted that at least 0x200 bytes are good so
-	;; lets start from there. The first 8192 bytes in the nand
-	;; flash is spliced with zeroes and is thus 16384 bytes.
-	move.d 0x38010200, $r10
-	move.d 0x14200, $r11	; Start offset in NAND flash 0x10200 + 16384
-	move.d 0x5000, $r12	; Length of copy
-
-	;; Before this code the tools add a partitiontable so the PC
-	;; has an offset from the linked address.
-offset1:
-	lapcq  ., $r13		; get PC
-	add.d	first_copy_complete-offset1, $r13
+	START_CLOCKS
 
-#include "../../lib/nand_init.S"
-
-first_copy_complete:
-	;; Initialze the DRAM registers.
+	;; Initialize the DRAM registers.
 	cmp.d	RAM_INIT_MAGIC, $r8	; Already initialized?
 	beq	dram_init_finished
 	nop
 
-#include "../../lib/dram_init.S"
-
+#include "../../mach/dram_init.S"
+	
 dram_init_finished:
-	lapcq  ., $r13		; get PC
-	add.d	second_copy_complete-dram_init_finished, $r13
-
-	move.d REG_ADDR(config, regi_config, r_bootsel), $r0
-	move.d [$r0], $r0
-	and.d  REG_MASK(config, r_bootsel, boot_mode), $r0
-	cmp.d  REG_STATE(config, r_bootsel, boot_mode, nand), $r0
-	bne second_copy_complete ; No NAND boot
-	nop
-
-	;; Copy 2MB from NAND flash to SDRAM (at 2-4MB into the SDRAM)
-	move.d 0x40204000, $r10
-	move.d 0x8000, $r11
-	move.d 0x200000, $r12
-	ba copy_nand_to_ram
-	nop
-second_copy_complete:
-
-	;; Initiate the PA port.
-	move.d	CONFIG_ETRAX_DEF_GIO_PA_OUT, $r0
-	move.d	REG_ADDR(gio, regi_gio, rw_pa_dout), $r1
-	move.d	$r0, [$r1]
-
-	move.d	CONFIG_ETRAX_DEF_GIO_PA_OE, $r0
-	move.d	REG_ADDR(gio, regi_gio, rw_pa_oe), $r1
-	move.d	$r0, [$r1]
 
+	GIO_INIT	
 	;; Setup the stack to a suitably high address.
-	;; We assume 8 MB is the minimum DRAM and put
+	;; We assume 8 MB is the minimum DRAM and put 
 	;; the SP at the top for now.
 
 	move.d	0x40800000, $sp
 
-	;; Figure out where the compressed piggyback image is
-	;; in the flash (since we wont try to copy it to DRAM
-	;; before unpacking). It is at _edata, but in flash.
+	;; Figure out where the compressed piggyback image is.
+	;; It is either in [NOR] flash (we don't want to copy it 
+	;; to DRAM before unpacking), or copied to DRAM
+	;; by the [NAND] flash boot loader.
+	;; The piggyback image is at _edata, but relative to where the
+	;; image is actually located in memory, not where it is linked 
+	;; (the decompressor is linked at 0x40700000+ and runs there).
 	;; Use (_edata - herami) as offset to the current PC.
 
-	move.d REG_ADDR(config, regi_config, r_bootsel), $r0
-	move.d [$r0], $r0
-	and.d  REG_MASK(config, r_bootsel, boot_mode), $r0
-	cmp.d  REG_STATE(config, r_bootsel, boot_mode, nand), $r0
-	beq hereami2
-	nop
-hereami:
+hereami:	
 	lapcq	., $r5		; get PC
 	and.d	0x7fffffff, $r5	; strip any non-cache bit
-	move.d	$r5, $r0	; save for later - flash address of 'herami'
+	move.d	$r5, $r0	; source address of 'herami'
 	add.d	_edata, $r5
 	sub.d	hereami, $r5	; r5 = flash address of '_edata'
 	move.d	hereami, $r1	; destination
-	ba 2f
-	nop
-hereami2:
-	lapcq	., $r5		; get PC
-	and.d	0x00ffffff, $r5	; strip any non-cache bit
-	move.d  $r5, $r6
-	or.d    0x40200000, $r6
-	move.d	$r6, $r0	; save for later - flash address of 'herami'
-	add.d	_edata, $r5
-	sub.d	hereami2, $r5	; r5 = flash address of '_edata'
-	add.d   0x40200000, $r5
-	move.d	hereami2, $r1	; destination
-2:
-	;; Copy text+data to DRAM
 
+	;; Copy text+data to DRAM
+	
 	move.d	_edata, $r2	; end destination
-1:	move.w	[$r0+], $r3
-	move.w	$r3, [$r1+]
-	cmp.d	$r2, $r1
+1:	move.w	[$r0+], $r3	; from herami+ source
+	move.w	$r3, [$r1+]	; to hereami+ destination (linked address)
+	cmp.d	$r2, $r1	; finish when destination == _edata
 	bcs	1b
 	nop
-
-	move.d	input_data, $r0 ; for the decompressor
+	move.d	input_data, $r0 ; for the decompressor	
 	move.d	$r5, [$r0]	; for the decompressor
 
 	;; Clear the decompressors BSS (between _edata and _end)
-
+	
 	moveq	0, $r0
 	move.d	_edata, $r1
 	move.d	_end, $r2
@@ -144,40 +78,47 @@
 	nop
 
 	;;  Save command line magic and address.
-	move.d	_cmd_line_magic, $r12
-	move.d  $r10, [$r12]
-	move.d	_cmd_line_addr, $r12
-	move.d  $r11, [$r12]
-
+	move.d	_cmd_line_magic, $r0
+	move.d  $r10, [$r0]
+	move.d	_cmd_line_addr, $r0
+	move.d  $r11, [$r0]
+
+	;;  Save boot source indicator
+	move.d	_boot_source, $r0
+	move.d	$r12, [$r0]
+	
 	;; Do the decompression and save compressed size in _inptr
 
 	jsr	decompress_kernel
 	nop
 
+	;; Restore boot source indicator
+	move.d	_boot_source, $r12
+	move.d	[$r12], $r12
+
 	;; Restore command line magic and address.
 	move.d  _cmd_line_magic, $r10
 	move.d  [$r10], $r10
 	move.d  _cmd_line_addr, $r11
 	move.d  [$r11], $r11
-
+	
 	;; Put start address of root partition in r9 so the kernel can use
it
 	;; when mounting from flash
 	move.d  input_data, $r0
 	move.d	[$r0], $r9		; flash address of compressed kernel
 	move.d  inptr, $r0
 	add.d	[$r0], $r9		; size of compressed kernel
-	cmp.d   0x40200000, $r9
-	blo	enter_kernel
-	nop
-	sub.d   0x40200000, $r9
-	add.d   0x4000, $r9
-
-enter_kernel:
+	cmp.d   0x40000000, $r9		; image in DRAM ?
+	blo	enter_kernel		; no, must be [NOR] flash, jump
+	nop				; delay slot
+	and.d   0x001fffff, $r9		; assume compressed kernel was < 2M
+		
+enter_kernel:		
 	;; Enter the decompressed kernel
 	move.d	RAM_INIT_MAGIC, $r8	; Tell kernel that DRAM is
initialized
 	jump	0x40004000	; kernel is linked to this address
 	nop
-
+	
 	.data
 
 input_data:
@@ -185,8 +126,8 @@
 _cmd_line_magic:
 	.dword 0
 _cmd_line_addr:
+	.dword 0	
+_boot_source:
 	.dword 0
-is_nand_boot:
-	.dword  0
-
-#include "../../lib/hw_settings.S"
+	
+#include "../../mach/hw_settings.S"
diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/compressed/Makefile
linux-2.6/arch/cris/arch-v32/boot/compressed/Makefile
--- ../linux/arch/cris/arch-v32/boot/compressed/Makefile	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/compressed/Makefile	2007-02-13
12:55:23.000000000 +0100
@@ -1,41 +1,30 @@
 #
-# lx25/arch/cris/arch-v32/boot/compressed/Makefile
+# arch/cris/arch-v32/boot/compressed/Makefile
 #
-# create a compressed vmlinux image from the original vmlinux files and
romfs
-#
-
-target = $(target_compressed_dir)
-src    = $(src_compressed_dir)
 
-CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
-CFLAGS = -O2
+CC = gcc-cris -mlinux -march=v32 -I $(srctree)/include 
+AFLAGS += -I $(srctree)/include/asm/mach/ -I $(srctree)/include/asm/arch
+CFLAGS += -O2 -I $(srctree)/include/asm/mach/ -I
$(srctree)/include/asm/arch
 LD = gcc-cris -mlinux -march=v32 -nostdlib
+LDFLAGS = -T $(obj)/decompress.ld
+obj-y = head.o misc.o
+OBJECTS = $(obj)/head.o $(obj)/misc.o
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
-OBJECTS = $(target)/head.o $(target)/misc.o
-
-# files to compress
-SYSTEM = $(objtree)/vmlinux.bin
-
-all: vmlinuz
-
-$(target)/decompress.bin: $(OBJECTS)
-	$(LD) -T $(src)/decompress.ld -o $(target)/decompress.o $(OBJECTS)
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/decompress.o
$(target)/decompress.bin
 
-$(objtree)/vmlinuz: $(target) piggy.img $(target)/decompress.bin
-	cat $(target)/decompress.bin piggy.img > $(objtree)/vmlinuz
-	rm -f piggy.img
-	cp $(objtree)/vmlinuz $(src)
+quiet_cmd_image = BUILD   $@
+cmd_image = cat $(obj)/decompress.bin $(obj)/piggy.gz > $@
 
-$(target)/head.o: $(src)/head.S
-	$(CC) -D__ASSEMBLY__ -c $< -o $@
+targets := vmlinux piggy.gz decompress.o decompress.bin
 
-# gzip the kernel image
+$(obj)/decompress.o: $(OBJECTS) FORCE
+	$(call if_changed,ld)
 
-piggy.img: $(SYSTEM)
-	cat $(SYSTEM) | gzip -f -9 > piggy.img
+$(obj)/decompress.bin: $(obj)/decompress.o FORCE
+	$(call if_changed,objcopy)
 
-clean:
-	rm -f piggy.img $(objtree)/vmlinuz vmlinuz.o decompress.o
decompress.bin $(OBJECTS)
+$(obj)/vmlinux: $(obj)/piggy.gz $(obj)/decompress.bin FORCE
+	$(call if_changed,image)
 
+$(obj)/piggy.gz: $(obj)/../Image FORCE
+	$(call if_changed,gzip)
diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/compressed/misc.c
linux-2.6/arch/cris/arch-v32/boot/compressed/misc.c
--- ../linux/arch/cris/arch-v32/boot/compressed/misc.c	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/compressed/misc.c	2007-04-12
10:30:50.000000000 +0200
@@ -1,15 +1,15 @@
 /*
  * misc.c
  *
- * $Id: misc.c,v 1.8 2005/04/24 18:34:29 starvik Exp $
- *
- * This is a collection of several routines from gzip-1.0.3
+ * $Id: misc.c,v 1.14 2007/04/12 08:30:50 ricardw Exp $
+ * 
+ * This is a collection of several routines from gzip-1.0.3 
  * adapted for Linux.
  *
  * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
  * puts by Nick Holloway 1993, better puts by Martin Mares 1995
  * adoptation for Linux/CRIS Axis Communications AB, 1999
- *
+ * 
  */
 
 /* where the piggybacked kernel image expects itself to live.
@@ -20,11 +20,11 @@
 
 #define KERNEL_LOAD_ADR 0x40004000
 
-
 #include <linux/types.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/ser_defs.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/ser_defs.h>
+#include <hwregs/pinmux_defs.h>
 
 /*
  * gzip declarations
@@ -66,8 +66,8 @@
 #define ENCRYPTED    0x20 /* bit 5 set: file is encrypted */
 #define RESERVED     0xC0 /* bit 6,7:   reserved */
 
-#define get_byte() inbuf[inptr++]
-
+#define get_byte() inbuf[inptr++]	
+	
 /* Diagnostic functions */
 #ifdef DEBUG
 #  define Assert(cond,msg) {if(!(cond)) error(msg);}
@@ -85,7 +85,6 @@
 #  define Tracecv(c,x)
 #endif
 
-static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
 static void gzip_mark(void **);
@@ -96,20 +95,20 @@
 static long bytes_out = 0;
 static uch *output_data;
 static unsigned long output_ptr = 0;
-
+ 
 static void *malloc(int size);
 static void free(void *where);
 static void error(char *m);
 static void gzip_mark(void **);
 static void gzip_release(void **);
-
+ 
 static void puts(const char *);
 
 /* the "heap" is put directly after the BSS ends, at end */
-
+  
 extern int _end;
 static long free_mem_ptr = (long)&_end;
-
+ 
 #include "../../../../../lib/inflate.c"
 
 static void *malloc(int size)
@@ -152,7 +151,7 @@
 		rs = REG_RD(ser, regi_ser, rs_stat_din);
 	}
 	while (!rs.tr_rdy);/* Wait for tranceiver. */
-
+	
 	REG_WR(ser, regi_ser, rw_dout, dout);
 }
 
@@ -186,6 +185,8 @@
 	char *ss = (char*)s;
 
 	for (i=0;i<n;i++) ss[i] = c;
+
+	return s;
 }
 
 void*
@@ -196,6 +197,8 @@
 	char *d = (char *)__dest, *s = (char *)__src;
 
 	for (i=0;i<__n;i++) d[i] = s[i];
+
+	return __dest;
 }
 
 /*
===========================================================================
@@ -209,9 +212,9 @@
     ulg c = crc;         /* temporary variable */
     unsigned n;
     uch *in, *out, ch;
-
+    
     in = window;
-    out = &output_data[output_ptr];
+    out = &output_data[output_ptr]; 
     for (n = 0; n < outcnt; n++) {
 	    ch = *out++ = *in++;
 	    c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
@@ -225,15 +228,15 @@
 static void
 error(char *x)
 {
-	puts("\n\n");
+	puts("\r\n\n");
 	puts(x);
-	puts("\n\n -- System halted\n");
+	puts("\r\n\n -- System halted\n");
 
 	while(1);	/* Halt */
 }
 
 void
-setup_normal_output_buffer()
+setup_normal_output_buffer(void)
 {
 	output_data = (char *)KERNEL_LOAD_ADR;
 }
@@ -246,13 +249,13 @@
 	reg_ser_rw_rec_ctrl rec_ctrl;
 	reg_ser_rw_tr_baud_div tr_baud;
 	reg_ser_rw_rec_baud_div rec_baud;
-
+	
 	/* Turn off XOFF. */
 	xoff = REG_RD(ser, regi_ser, rw_xoff);
-
+	
 	xoff.chr = 0;
 	xoff.automatic = regk_ser_no;
-
+	
 	REG_WR(ser, regi_ser, rw_xoff, xoff);
 
 	/* Set baudrate and stopbits. */
@@ -260,19 +263,21 @@
 	rec_ctrl = REG_RD(ser, regi_ser, rw_rec_ctrl);
 	tr_baud = REG_RD(ser, regi_ser, rw_tr_baud_div);
 	rec_baud = REG_RD(ser, regi_ser, rw_rec_baud_div);
-
+	
 	tr_ctrl.stop_bits = 1;	/* 2 stop bits. */
-
-	/*
-	 * The baudrate setup is a bit fishy, but in the end the tranceiver
is
-	 * set to 4800 and the receiver to 115200. The magic value is
-	 * 29.493 MHz.
+	tr_ctrl.en = 1; /* enable transmitter */
+	rec_ctrl.en = 1; /* enabler receiver */
+	
+	/* 
+	 * The baudrate setup used to be a bit fishy, but now transmitter
and
+	 * receiver are both set to the intended baud rate, 115200.
+	 * The magic value is 29.493 MHz.
 	 */
 	tr_ctrl.base_freq = regk_ser_f29_493;
 	rec_ctrl.base_freq = regk_ser_f29_493;
-	tr_baud.div = (29493000 / 8) / 4800;
+	tr_baud.div = (29493000 / 8) / 115200;
 	rec_baud.div = (29493000 / 8) / 115200;
-
+	
 	REG_WR(ser, regi_ser, rw_tr_ctrl, tr_ctrl);
 	REG_WR(ser, regi_ser, rw_tr_baud_div, tr_baud);
 	REG_WR(ser, regi_ser, rw_rec_ctrl, rec_ctrl);
@@ -280,25 +285,31 @@
 }
 
 void
-decompress_kernel()
+decompress_kernel(void)
 {
 	char revision;
-
+	reg_pinmux_rw_hwprot hwprot;
+	
 	/* input_data is set in head.S */
 	inbuf = input_data;
-
+	
+	hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
 #ifdef CONFIG_ETRAX_DEBUG_PORT0
 	serial_setup(regi_ser0);
 #endif
 #ifdef CONFIG_ETRAX_DEBUG_PORT1
+	hwprot.ser1 = regk_pinmux_yes;
 	serial_setup(regi_ser1);
 #endif
 #ifdef CONFIG_ETRAX_DEBUG_PORT2
+	hwprot.ser2 = regk_pinmux_yes;
 	serial_setup(regi_ser2);
 #endif
 #ifdef CONFIG_ETRAX_DEBUG_PORT3
+	hwprot.ser3 = regk_pinmux_yes;
 	serial_setup(regi_ser3);
 #endif
+	REG_WR(pinmux, regi_pinmux, rw_hwprot, hwprot);
 
 	setup_normal_output_buffer();
 
@@ -307,11 +318,11 @@
 	__asm__ volatile ("move $vr,%0" : "=rm" (revision));
 	if (revision < 32)
 	{
-		puts("You need an ETRAX FS to run Linux 2.6/crisv32.\n");
+		puts("You need an ETRAX FS to run Linux 2.6/crisv32.\r\n");
 		while(1);
 	}
 
-	puts("Uncompressing Linux...\n");
+	puts("Uncompressing Linux...\r\n");
 	gunzip();
-	puts("Done. Now booting the kernel.\n");
+	puts("Done. Now booting the kernel.\r\n");
 }
diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/compressed/README
linux-2.6/arch/cris/arch-v32/boot/compressed/README
--- ../linux/arch/cris/arch-v32/boot/compressed/README	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/compressed/README	2003-08-21
11:37:03.000000000 +0200
@@ -5,14 +5,14 @@
 This can be slightly confusing because it's a process with many steps.
 
 The kernel object built by the arch/etrax100/Makefile, vmlinux, is split
-by that makefile into text and data binary files, vmlinux.text and
+by that makefile into text and data binary files, vmlinux.text and 
 vmlinux.data.
 
 Those files together with a ROM filesystem can be catted together and
 burned into a flash or executed directly at the DRAM origin.
 
 They can also be catted together and compressed with gzip, which is what
-happens in this makefile. Together they make up piggy.img.
+happens in this makefile. Together they make up piggy.img. 
 
 The decompressor is built into the file decompress.o. It is turned into
 the binary file decompress.bin, which is catted together with piggy.img
diff -urNP --exclude='*.cvsignore' ../linux/arch/cris/arch-v32/boot/Makefile
linux-2.6/arch/cris/arch-v32/boot/Makefile
--- ../linux/arch/cris/arch-v32/boot/Makefile	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/Makefile	2006-11-29
17:05:41.000000000 +0100
@@ -1,14 +1,21 @@
 #
 # arch/cris/arch-v32/boot/Makefile
 #
-target = $(target_boot_dir)
-src    = $(src_boot_dir)
 
-zImage: compressed/vmlinuz
+OBJCOPY = objcopy-cris
+OBJCOPYFLAGS = -O binary -R .note -R .comment
 
-compressed/vmlinuz: $(objtree)/vmlinux
-	@$(MAKE) -f $(src)/compressed/Makefile $(objtree)/vmlinuz
+subdir- := compressed rescue
+targets := Image
 
-clean:
-	rm -f zImage tools/build compressed/vmlinux.out
-	@$(MAKE) -f $(src)/compressed/Makefile clean
+$(obj)/Image: vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo '  Kernel: $@ is ready'
+
+$(obj)/compressed/vmlinux: $(obj)/Image FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
+	$(Q)$(MAKE) $(build)=$(obj)/rescue $(obj)/rescue/rescue.bin
+
+$(obj)/zImage:  $(obj)/compressed/vmlinux
+	@cp $< $@
+	@echo '  Kernel: $@ is ready'
diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/rescue/head.S
linux-2.6/arch/cris/arch-v32/boot/rescue/head.S
--- ../linux/arch/cris/arch-v32/boot/rescue/head.S	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/rescue/head.S	2007-04-12
10:17:58.000000000 +0200
@@ -1,38 +1,23 @@
-/* $Id: head.S,v 1.4 2004/11/01 16:10:28 starvik Exp $
+/* $Id: head.S,v 1.20 2007/04/12 08:17:58 ricardw Exp $
+ * 
+ * Just get started by jumping to CONFIG_ETRAX_PTABLE_SECTOR to start
+ * kernel decompressor.
  *
- * This used to be the rescue code but now that is handled by the
- * RedBoot based RFL instead. Nothing to see here, move along.
+ * In practice, this only works for NOR flash (or some convoluted RAM boot)
+ * and hence is not really useful for Artpec-3, so it's Etrax FS / NOR
only.
+ * 
  */
 
-#include <asm/arch/hwregs/reg_map_asm.h>
-#include <asm/arch/hwregs/config_defs_asm.h>
+#include <mach/startup.inc>
+	
+;; Code
 
 	.text
+start:
 
 	;; Start clocks for used blocks.
-	move.d REG_ADDR(config, regi_config, rw_clk_ctrl), $r1
-	move.d [$r1], $r0
-	or.d   REG_STATE(config, rw_clk_ctrl, cpu, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, bif, yes) | \
-	       REG_STATE(config, rw_clk_ctrl, fix_io, yes), $r0
-	move.d $r0, [$r1]
+	START_CLOCKS
 
-	;; Copy 68KB NAND flash to Internal RAM (if NAND boot)
-	move.d 0x38004000, $r10
-	move.d 0x8000, $r11
-	move.d 0x11000, $r12
-	move.d copy_complete, $r13
-	and.d  0x000fffff, $r13
-	or.d   0x38000000, $r13
-
-#include "../../lib/nand_init.S"
-
-	;; No NAND found
 	move.d	CONFIG_ETRAX_PTABLE_SECTOR, $r10
-	jump	$r10 ; Jump to decompresser
-	nop
-
-copy_complete:
-	move.d	0x38000000 + CONFIG_ETRAX_PTABLE_SECTOR, $r10
-	jump	$r10 ; Jump to decompresser
+	jump	$r10 			; Jump to decompresser 
 	nop
diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/rescue/Makefile
linux-2.6/arch/cris/arch-v32/boot/rescue/Makefile
--- ../linux/arch/cris/arch-v32/boot/rescue/Makefile	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/rescue/Makefile	2007-04-12
10:17:58.000000000 +0200
@@ -1,36 +1,27 @@
 #
-# Makefile for rescue code
+# Makefile for rescue (bootstrap) code
 #
-target = $(target_rescue_dir)
-src    = $(src_rescue_dir)
 
 CC = gcc-cris -mlinux -march=v32 $(LINUXINCLUDE)
 CFLAGS = -O2
-LD = gcc-cris -mlinux -march=v32 -nostdlib
+AFLAGS += -I $(TOPDIR)/include/asm/arch/mach/ -I $(TOPDIR)/include/asm/arch
+CFLAGS += -I $(TOPDIR)/include/asm/arch/mach/ -I $(TOPDIR)/include/asm/arch
+LD = gcc-cris -mlinux -march=v32 -nostdlib 
+LDFLAGS = -T $(obj)/rescue.ld
+LDPOSTFLAGS = -lgcc
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
+obj-y = head.o
+OBJECTS = $(obj)/head.o
 
-all: $(target)/rescue.bin
+targets := rescue.o rescue.bin
 
-rescue: rescue.bin
-	# do nothing
+quiet_cmd_ldlibgcc = LD      $@
+cmd_ldlibgcc = $(LD) $(LDFLAGS) $(filter-out FORCE,$^) $(LDPOSTFLAGS) -o $@
 
-$(target)/rescue.bin: $(target) $(target)/head.o
-	$(LD) -T $(src)/rescue.ld -o $(target)/rescue.o $(target)/head.o
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/rescue.o $(target)/rescue.bin
-	cp -p $(target)/rescue.bin $(objtree)
+$(obj)/rescue.o: $(OBJECTS) FORCE
+	$(call if_changed,ldlibgcc)
 
-$(target):
-	mkdir -p $(target)
-
-$(target)/head.o: $(src)/head.S
-	$(CC) -D__ASSEMBLY__ -c $< -o $*.o
-
-clean:
-	rm -f $(target)/*.o $(target)/*.bin
-
-fastdep:
-
-modules:
-
-modules-install:
+$(obj)/rescue.bin: $(obj)/rescue.o FORCE
+	$(call if_changed,objcopy)
+	cp -p $(obj)/rescue.bin $(objtree)
diff -urNP --exclude='*.cvsignore'
../linux/arch/cris/arch-v32/boot/rescue/rescue.ld
linux-2.6/arch/cris/arch-v32/boot/rescue/rescue.ld
--- ../linux/arch/cris/arch-v32/boot/rescue/rescue.ld	2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/rescue/rescue.ld	2007-04-12
10:17:58.000000000 +0200
@@ -1,20 +1,43 @@
-MEMORY
+/*#OUTPUT_FORMAT(elf32-us-cris) */
+OUTPUT_ARCH (crisv32)
+/* Now that NAND support has been stripped, this file could be simplified,
+ * but it doesn't do any harm on the other hand so why bother. */
+
+MEMORY 
 	{
-	flash : ORIGIN = 0x00000000,
-	        LENGTH = 0x00100000
+	bootblk : ORIGIN = 0x38000000,
+	          LENGTH = 0x00004000
+	intmem  : ORIGIN = 0x38004000,
+		  LENGTH = 0x00005000
 	}
 
 SECTIONS
 {
 	.text :
 	{
-		stext = . ;
+		_stext = . ;
 		*(.text)
-		etext = . ;
-	} > flash
+		*(.init.text)
+		*(.rodata)
+		*(.rodata.*)
+		_etext = . ;
+	} > bootblk
 	.data :
 	{
 		*(.data)
-		edata = . ;
-	} > flash
+		_edata = . ;
+	} > bootblk
+	.bss :
+	{
+		_bss = . ;
+		*(.bss)
+		_end = ALIGN( 0x10 ) ;
+	} > intmem
+
+	/* Get rid of stuff from EXPORT_SYMBOL(foo). */
+	/DISCARD/ :
+	{
+	        *(__ksymtab_strings)
+	        *(__ksymtab)
+	}
 }

-----Original Message-----
From: Sam Ravnborg [mailto:sam@ravnborg.org] 
Sent: Sunday, April 22, 2007 9:45 PM
To: Mikael Starvik
Cc: linux-kernel@vger.kernel.org; akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.20 7/14] CRIS architecture update - Boot


On Sun, Apr 22, 2007 at 09:25:23PM +0200, Mikael Starvik wrote:
> The attached patch relates to CRIS kernel booting (decompresser etc)

--- ../linux/arch/cris/arch-v32/boot/compressed/Makefile        2007-02-04
19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/compressed/Makefile       2007-02-13
12:55:23.000000000 +0100
@@ -1,41 +1,30 @@
 #
-# lx25/arch/cris/arch-v32/boot/compressed/Makefile
+# arch/cris/arch-v32/boot/compressed/Makefile
 #
-# create a compressed vmlinux image from the original vmlinux files and
romfs
-#
-
-target = $(target_compressed_dir)
-src    = $(src_compressed_dir)

-CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
-CFLAGS = -O2
+CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
+AFLAGS += -I $(TOPDIR)/include/asm/mach/ -I $(TOPDIR)/include/asm/arch
+CFLAGS += -O2 -I $(TOPDIR)/include/asm/mach/ -I $(TOPDIR)/include/asm/arch
 LD = gcc-cris -mlinux -march=v32 -nostdlib

Use of $(TOPDIR) is deprecated.
Please replace with $(srctree).

There was lots of other Makefile changes but they looked OK in general.
When the patch-set I would like to give to full set a review - please ping
me.

	Sam

