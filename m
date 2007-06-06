Return-Path: <linux-kernel-owner+w=401wt.eu-S965996AbXFFXlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965996AbXFFXlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965822AbXFFXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:41:24 -0400
Received: from 8.sub-75-209-226.myvzw.com ([75.209.226.8]:59399 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965081AbXFFXlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:41:22 -0400
Message-Id: <20070606230922.402569816@goop.org>
References: <20070606225837.654272428@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 15:58:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 5/7] i386: clean up bzImage generation
Content-Disposition: inline; filename=i386-cleanup-image-generation.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up image generation in several ways:
 - Firstly, it removes tools/build, and uses binutils to do all the
   final construction of the bzImage.  This removes a chunk of code
   and makes the image generation more flexible, since we can compute
   various numbers rather than be forced to use fixed constants.

 - Rename compressed/vmlinux to compressed/blob, to make it a
   bit clearer that it's the compressed kernel image + decompressor
   (now all the files named "vmlinux*" are directly derived from
   the kernel vmlinux).

 - Rather than using objcopy to wrap the compressed kernel into an
   object file, simply use the assembler: payload.S does a .incbin
   of the blob.bin file, which allows us to easily place
   it into a section, and it makes the Makefile dependency a little
   clearer.

 - Similarly, use the same technique to create compressed/piggy.o,
   which cleans things up even more, since the .S file can also
   set the input and output_size symbols without further linker
   script hackery; it also removes a complete linker script.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/boot/Makefile               |   31 +-----
 arch/i386/boot/compressed/Makefile    |   13 --
 arch/i386/boot/compressed/piggy.S     |   10 +
 arch/i386/boot/compressed/vmlinux.scr |   10 -
 arch/i386/boot/header.S               |    6 -
 arch/i386/boot/payload.S              |    3 
 arch/i386/boot/setup.ld               |   39 ++++---
 arch/i386/boot/tools/.gitignore       |    1 
 arch/i386/boot/tools/build.c          |  168 ---------------------------------
 9 files changed, 56 insertions(+), 225 deletions(-)

===================================================================
--- a/arch/i386/boot/Makefile
+++ b/arch/i386/boot/Makefile
@@ -25,12 +25,13 @@ SVGA_MODE := -DSVGA_MODE=NORMAL_VGA
 
 #RAMDISK := -DRAMDISK=512
 
-targets		:= vmlinux.bin setup.bin setup.elf zImage bzImage
+targets		:= blob.bin setup.elf zImage bzImage
 subdir- 	:= compressed
 
 setup-y		+= a20.o apm.o cmdline.o copy.o cpu.o cpucheck.o edd.o
-setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
-setup-y		+= printf.o string.o tty.o video.o version.o voyager.o
+setup-y		+= header.o main.o mca.o memory.o payload.o pm.o
+setup-y		+= pmjump.o printf.o string.o tty.o video.o version.o
+setup-y		+= voyager.o
 
 # The link order of the video-*.o modules can matter.  In particular,
 # video-vga.o *must* be listed first, followed by video-vesa.o.
@@ -39,10 +40,6 @@ setup-y		+= video-vga.o
 setup-y		+= video-vga.o
 setup-y		+= video-vesa.o
 setup-y		+= video-bios.o
-
-hostprogs-y	:= tools/build
-
-HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 
 # ---------------------------------------------------------------------------
 
@@ -65,18 +62,12 @@ AFLAGS		:= $(CFLAGS) -D__ASSEMBLY__
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
 $(obj)/bzImage: EXTRA_CFLAGS := -D__BIG_KERNEL__
 $(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
-$(obj)/bzImage: BUILDFLAGS   := -b
 
-quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(BUILDFLAGS) $(obj)/setup.bin \
-	    $(obj)/vmlinux.bin $(ROOT_DEV) > $@
-
-$(obj)/zImage $(obj)/bzImage: $(obj)/setup.bin \
-			      $(obj)/vmlinux.bin $(obj)/tools/build FORCE
-	$(call if_changed,image)
+$(obj)/zImage $(obj)/bzImage: $(obj)/setup.elf FORCE
+	$(call if_changed,objcopy)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
-$(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
+$(obj)/blob.bin: $(obj)/compressed/blob FORCE
 	$(call if_changed,objcopy)
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
@@ -85,12 +76,10 @@ LDFLAGS_setup.elf	:= -T
 $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
 	$(call if_changed,ld)
 
-OBJCOPYFLAGS_setup.bin	:= -O binary
+$(obj)/payload.o:	EXTRA_AFLAGS := -Wa,-I$(obj)
+$(obj)/payload.o: $(src)/payload.S $(obj)/blob.bin
 
-$(obj)/setup.bin: $(obj)/setup.elf FORCE
-	$(call if_changed,objcopy)
-
-$(obj)/compressed/vmlinux: FORCE
+$(obj)/compressed/blob: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed IMAGE_OFFSET=$(IMAGE_OFFSET) $@
 
 # Set this if you want to pass append arguments to the zdisk/fdimage/isoimage kernel
===================================================================
--- a/arch/i386/boot/compressed/Makefile
+++ b/arch/i386/boot/compressed/Makefile
@@ -4,11 +4,10 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
+targets		:= blob vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
 			vmlinux.bin.all vmlinux.relocs
-EXTRA_AFLAGS	:= -traditional
 
-LDFLAGS_vmlinux := -T
+LDFLAGS_blob	:= -T
 hostprogs-y	:= relocs
 
 CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
@@ -17,7 +16,7 @@ CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INC
 	   $(call cc-option,-fno-stack-protector)
 LDFLAGS := -m elf_i386
 
-$(obj)/vmlinux: $(src)/vmlinux.lds $(obj)/head.o $(obj)/misc.o $(obj)/piggy.o FORCE
+$(obj)/blob: $(src)/vmlinux.lds $(obj)/head.o $(obj)/misc.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
 
@@ -44,7 +43,5 @@ else
 	$(call if_changed,gzip)
 endif
 
-LDFLAGS_piggy.o := -r --format binary --oformat elf32-i386 -T
-
-$(obj)/piggy.o: $(src)/vmlinux.scr $(obj)/vmlinux.bin.gz FORCE
-	$(call if_changed,ld)
+$(obj)/piggy.o:	EXTRA_AFLAGS := -Wa,-I$(obj)
+$(obj)/piggy.o: $(obj)/vmlinux.bin.gz
===================================================================
--- /dev/null
+++ b/arch/i386/boot/compressed/piggy.S
@@ -0,0 +1,10 @@
+.section .data.compressed,"a",@progbits
+
+.globl input_data, input_len, output_len
+
+input_len:	.long input_data_end - input_data
+
+input_data:
+.incbin "vmlinux.bin.gz"
+output_len = .-4
+input_data_end:
===================================================================
--- a/arch/i386/boot/compressed/vmlinux.scr
+++ /dev/null
@@ -1,10 +0,0 @@
-SECTIONS
-{
-  .data.compressed : {
-	input_len = .;
-	LONG(input_data_end - input_data) input_data = .; 
-	*(.data) 
-	output_len = . - 4;
-	input_data_end = .; 
-	}
-}
===================================================================
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -97,9 +97,9 @@ bugger_off_msg:
 	.section ".header", "a"
 	.globl	hdr
 hdr:
-setup_sects:	.byte SETUPSECTS
+setup_sects:	.byte _setup_sects
 root_flags:	.word ROOT_RDONLY
-syssize:	.long SYSSIZE
+syssize:	.long kernel_size_para
 ram_size:	.word RAMDISK
 vid_mode:	.word SVGA_MODE
 root_dev:	.word ROOT_DEV
@@ -148,7 +148,7 @@ CAN_USE_HEAP	= 0x80			# If set, the load
 		.byte	LOADED_HIGH
 #endif
 
-setup_move_size: .word  0x8000		# size to move, when setup is not
+setup_move_size: .word  _setup_size	# size to move, when setup is not
 					# loaded at 0x90000. We will move setup
 					# to 0x90000 then just before jumping
 					# into the kernel. However, only the
===================================================================
--- /dev/null
+++ b/arch/i386/boot/payload.S
@@ -0,0 +1,3 @@
+.section .kernel,"a",@progbits
+
+.incbin "blob.bin"
===================================================================
--- a/arch/i386/boot/setup.ld
+++ b/arch/i386/boot/setup.ld
@@ -3,18 +3,16 @@
  *
  * Linker script for the i386 setup code
  */
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_FORMAT("elf32-i386")
 OUTPUT_ARCH(i386)
 ENTRY(_start)
 
 SECTIONS
 {
-	. = 0;
-	.bstext		: { *(.bstext) }
+	.bstext 0	: { *(.bstext) }
 	.bsdata		: { *(.bsdata) }
 
-	. = 497;
-	.header		: { *(.header) }
+	.header 497	: { *(.header) }
 	.inittext	: { *(.inittext) }
 	.initdata	: { *(.initdata) }
 	.text		: { *(.text*) }
@@ -38,16 +36,29 @@ SECTIONS
 
 
 	. = ALIGN(16);
-	__bss_start = .;
-	.bss 		:
-	{
-		*(.bss)
-	}
-	. = ALIGN(16);
-	_end = .;
+	.bss ALIGN(16)	: {
+		__bss_start = .;
+		 *(.bss)
+		. = ALIGN(16);
+		_end = .;
+	 }
 
 	/DISCARD/ : { *(.note*) }
 
-	. = ASSERT(_end <= 0x8000, "Setup too big!");
-	. = ASSERT(hdr == 0x1f1, "The setup header has the wrong offset!");
+	. = ALIGN(512);		/* align to sector size */
+	_setup_size = . - _start;
+	_setup_sects = _setup_size / 512;
+
+	/* compressed kernel data */
+	.kernel	: {
+		kernel = .;
+		*(.kernel)
+		kernel_end = .;
+
+	}
+	kernel_size = kernel_end - kernel;
+	kernel_size_para = (kernel_size + 15) / 16;
 }
+
+ASSERT(_end <= 0x8000, "Setup too big!");
+ASSERT(hdr == 0x1f1, "The setup header has the wrong offset!");
===================================================================
--- a/arch/i386/boot/tools/.gitignore
+++ /dev/null
@@ -1,1 +0,0 @@
-build
===================================================================
--- a/arch/i386/boot/tools/build.c
+++ /dev/null
@@ -1,168 +0,0 @@
-/*
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *  Copyright (C) 1997 Martin Mares
- *  Copyright (C) 2007 H. Peter Anvin
- */
-
-/*
- * This file builds a disk-image from three different files:
- *
- * - setup: 8086 machine code, sets up system parm
- * - system: 80386 code for actual system
- *
- * It does some checking that all files are of the correct type, and
- * just writes the result to stdout, removing headers and padding to
- * the right amount. It also writes some system data to stderr.
- */
-
-/*
- * Changes by tytso to allow root device specification
- * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
- * Cross compiling fixes by Gertjan van Wingerde, July 1996
- * Rewritten by Martin Mares, April 1997
- * Substantially overhauled by H. Peter Anvin, April 2007
- */
-
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <stdarg.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/sysmacros.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/mman.h>
-#include <asm/boot.h>
-
-typedef unsigned char  u8;
-typedef unsigned short u16;
-typedef unsigned long  u32;
-
-#define DEFAULT_MAJOR_ROOT 0
-#define DEFAULT_MINOR_ROOT 0
-
-/* Minimal number of setup sectors */
-#define SETUP_SECT_MIN 5
-#define SETUP_SECT_MAX 64
-
-/* This must be large enough to hold the entire setup */
-u8 buf[SETUP_SECT_MAX*512];
-int is_big_kernel;
-
-static void die(const char * str, ...)
-{
-	va_list args;
-	va_start(args, str);
-	vfprintf(stderr, str, args);
-	fputc('\n', stderr);
-	exit(1);
-}
-
-static void usage(void)
-{
-	die("Usage: build [-b] setup system [rootdev] [> image]");
-}
-
-int main(int argc, char ** argv)
-{
-	unsigned int i, sz, setup_sectors;
-	int c;
-	u32 sys_size;
-	u8 major_root, minor_root;
-	struct stat sb;
-	FILE *file;
-	int fd;
-	void *kernel;
-
-	if (argc > 2 && !strcmp(argv[1], "-b"))
-	  {
-	    is_big_kernel = 1;
-	    argc--, argv++;
-	  }
-	if ((argc < 3) || (argc > 4))
-		usage();
-	if (argc > 3) {
-		if (!strcmp(argv[3], "CURRENT")) {
-			if (stat("/", &sb)) {
-				perror("/");
-				die("Couldn't stat /");
-			}
-			major_root = major(sb.st_dev);
-			minor_root = minor(sb.st_dev);
-		} else if (strcmp(argv[3], "FLOPPY")) {
-			if (stat(argv[3], &sb)) {
-				perror(argv[3]);
-				die("Couldn't stat root device.");
-			}
-			major_root = major(sb.st_rdev);
-			minor_root = minor(sb.st_rdev);
-		} else {
-			major_root = 0;
-			minor_root = 0;
-		}
-	} else {
-		major_root = DEFAULT_MAJOR_ROOT;
-		minor_root = DEFAULT_MINOR_ROOT;
-	}
-	fprintf(stderr, "Root device is (%d, %d)\n", major_root, minor_root);
-
-	/* Copy the setup code */
-	file = fopen(argv[1], "r");
-	if (!file)
-		die("Unable to open `%s': %m", argv[1]);
-	c = fread(buf, 1, sizeof(buf), file);
-	if (ferror(file))
-		die("read-error on `setup'");
-	if (c < 1024)
-		die("The setup must be at least 1024 bytes");
-	if (buf[510] != 0x55 || buf[511] != 0xaa)
-		die("Boot block hasn't got boot flag (0xAA55)");
-	fclose(file);
-
-	/* Pad unused space with zeros */
-	setup_sectors = (c + 511) / 512;
-	if (setup_sectors < SETUP_SECT_MIN)
-		setup_sectors = SETUP_SECT_MIN;
-	i = setup_sectors*512;
-	memset(buf+c, 0, i-c);
-
-	/* Set the default root device */
-	buf[508] = minor_root;
-	buf[509] = major_root;
-
-	fprintf(stderr, "Setup is %d bytes (padded to %d bytes).\n", c, i);
-
-	/* Open and stat the kernel file */
-	fd = open(argv[2], O_RDONLY);
-	if (fd < 0)
-		die("Unable to open `%s': %m", argv[2]);
-	if (fstat(fd, &sb))
-		die("Unable to stat `%s': %m", argv[2]);
-	sz = sb.st_size;
-	fprintf (stderr, "System is %d kB\n", (sz+1023)/1024);
-	kernel = mmap(NULL, sz, PROT_READ, MAP_SHARED, fd, 0);
-	if (kernel == MAP_FAILED)
-		die("Unable to mmap '%s': %m", argv[2]);
-	sys_size = (sz + 15) / 16;
-	if (!is_big_kernel && sys_size > DEF_SYSSIZE)
-		die("System is too big. Try using bzImage or modules.");
-
-	/* Patch the setup code with the appropriate size parameters */
-	buf[0x1f1] = setup_sectors-1;
-	buf[0x1f4] = sys_size;
-	buf[0x1f5] = sys_size >> 8;
-	buf[0x1f6] = sys_size >> 16;
-	buf[0x1f7] = sys_size >> 24;
-
-	if (fwrite(buf, 1, i, stdout) != i)
-		die("Writing setup failed");
-
-	/* Copy the kernel code */
-	if (fwrite(kernel, 1, sz, stdout) != sz)
-		die("Writing kernel failed");
-	close(fd);
-
-	/* Everything is OK */
-	return 0;
-}

-- 

