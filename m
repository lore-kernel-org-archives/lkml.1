Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZCKSHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZCKSHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZCKSHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:07:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:37192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZCKSHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:07:00 -0400
Date: Wed, 11 Mar 2009 18:06:31 GMT
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <49B703D4.1000008@zytor.com>
References: <49B703D4.1000008@zytor.com>
Subject: [tip:x86/setup] x86: remove zImage support
Message-ID: <tip-5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef@git.kernel.org>
Git-Commit-ID: 5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 18:06:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef
Gitweb:     http://git.kernel.org/tip/5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef
Author:     "H. Peter Anvin" <hpa@zytor.com>
AuthorDate: Wed, 11 Mar 2009 10:55:33 -0700
Commit:     H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 11 Mar 2009 11:00:00 -0700

x86: remove zImage support

Impact: obsolete feature removal

The zImage kernel format has been functionally unused for a very long
time.  It is just barely possible to build a modern kernel that still
fits within the zImage size limit, but it is highly unlikely that
anyone ever uses it.  Furthermore, although it is still supported by
most bootloaders, it has been at best poorly tested (or not tested at
all); some bootloaders are even known to not support zImage at all and
not having even noticed.

Also remove some really obsolete constants that no longer have any
meaning.

LKML-Reference: <49B703D4.1000008@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/boot/Makefile      |   23 +++++++--------------
 arch/x86/boot/header.S      |   29 ++++++++-------------------
 arch/x86/boot/pm.c          |   44 -------------------------------------------
 arch/x86/boot/tools/build.c |    9 +-------
 arch/x86/include/asm/boot.h |    4 ---
 5 files changed, 18 insertions(+), 91 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index c70eff6..57a29fe 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -6,26 +6,23 @@
 # for more details.
 #
 # Copyright (C) 1994 by Linus Torvalds
+# Changed by many, many contributors over the years.
 #
 
 # ROOT_DEV specifies the default root-device when making the image.
 # This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
 # the default of FLOPPY is used by 'build'.
 
-ROOT_DEV := CURRENT
+ROOT_DEV	:= CURRENT
 
 # If you want to preset the SVGA mode, uncomment the next line and
 # set SVGA_MODE to whatever number you want.
 # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
 # The number is the same as you would ordinarily press at bootup.
 
-SVGA_MODE := -DSVGA_MODE=NORMAL_VGA
+SVGA_MODE	:= -DSVGA_MODE=NORMAL_VGA
 
-# If you want the RAM disk device, define this to be the size in blocks.
-
-#RAMDISK := -DRAMDISK=512
-
-targets		:= vmlinux.bin setup.bin setup.elf zImage bzImage
+targets		:= vmlinux.bin setup.bin setup.elf bzImage
 subdir-		:= compressed
 
 setup-y		+= a20.o cmdline.o copy.o cpu.o cpucheck.o edd.o
@@ -71,17 +68,13 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 KBUILD_CFLAGS +=   $(call cc-option,-m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
-$(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
-$(obj)/bzImage: ccflags-y := -D__BIG_KERNEL__
-$(obj)/bzImage: asflags-y := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
-$(obj)/bzImage: BUILDFLAGS   := -b
+$(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
 quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(BUILDFLAGS) $(obj)/setup.bin \
-	    $(obj)/vmlinux.bin $(ROOT_DEV) > $@
+cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
+	$(ROOT_DEV) > $@
 
-$(obj)/zImage $(obj)/bzImage: $(obj)/setup.bin \
-			      $(obj)/vmlinux.bin $(obj)/tools/build FORCE
+$(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 7ccff48..5d84d1c 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -24,12 +24,8 @@
 #include "boot.h"
 #include "offsets.h"
 
-SETUPSECTS	= 4			/* default nr of setup-sectors */
 BOOTSEG		= 0x07C0		/* original address of boot-sector */
-SYSSEG		= DEF_SYSSEG		/* system loaded at 0x10000 (65536) */
-SYSSIZE		= DEF_SYSSIZE		/* system size: # of 16-byte clicks */
-					/* to be loaded */
-ROOT_DEV	= 0			/* ROOT_DEV is now written by "build" */
+SYSSEG		= 0x1000		/* historical load address >> 4 */
 
 #ifndef SVGA_MODE
 #define SVGA_MODE ASK_VGA
@@ -97,12 +93,12 @@ bugger_off_msg:
 	.section ".header", "a"
 	.globl	hdr
 hdr:
-setup_sects:	.byte SETUPSECTS
+setup_sects:	.byte 0			/* Filled in by build.c */
 root_flags:	.word ROOT_RDONLY
-syssize:	.long SYSSIZE
-ram_size:	.word RAMDISK
+syssize:	.long 0			/* Filled in by build.c */
+ram_size:	.word 0			/* Obsolete */
 vid_mode:	.word SVGA_MODE
-root_dev:	.word ROOT_DEV
+root_dev:	.word 0			/* Filled in by build.c */
 boot_flag:	.word 0xAA55
 
 	# offset 512, entry point
@@ -123,14 +119,15 @@ _start:
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
-start_sys_seg:	.word	SYSSEG
+start_sys_seg:	.word	SYSSEG		# obsolete and meaningless, but just
+					# in case something decided to "use" it
 		.word	kernel_version-512 # pointing to kernel version string
 					# above section of header is compatible
 					# with loadlin-1.5 (header v1.5). Don't
 					# change it.
 
-type_of_loader:	.byte	0		# = 0, old one (LILO, Loadlin,
-					#      Bootlin, SYSLX, bootsect...)
+type_of_loader:	.byte	0		# 0 means ancient bootloader, newer
+					# bootloaders know to change this.
 					# See Documentation/i386/boot.txt for
 					# assigned ids
 
@@ -142,11 +139,7 @@ CAN_USE_HEAP	= 0x80			# If set, the loader also has set
 					# space behind setup.S can be used for
 					# heap purposes.
 					# Only the loader knows what is free
-#ifndef __BIG_KERNEL__
-		.byte	0
-#else
 		.byte	LOADED_HIGH
-#endif
 
 setup_move_size: .word  0x8000		# size to move, when setup is not
 					# loaded at 0x90000. We will move setup
@@ -157,11 +150,7 @@ setup_move_size: .word  0x8000		# size to move, when setup is not
 
 code32_start:				# here loaders can put a different
 					# start address for 32-bit code.
-#ifndef __BIG_KERNEL__
-		.long	0x1000		#   0x1000 = default for zImage
-#else
 		.long	0x100000	# 0x100000 = default for big kernel
-#endif
 
 ramdisk_image:	.long	0		# address of loaded ramdisk image
 					# Here the loader puts the 32-bit
diff --git a/arch/x86/boot/pm.c b/arch/x86/boot/pm.c
index 85a1cd8..8062f89 100644
--- a/arch/x86/boot/pm.c
+++ b/arch/x86/boot/pm.c
@@ -33,47 +33,6 @@ static void realmode_switch_hook(void)
 }
 
 /*
- * A zImage kernel is loaded at 0x10000 but wants to run at 0x1000.
- * A bzImage kernel is loaded and runs at 0x100000.
- */
-static void move_kernel_around(void)
-{
-	/* Note: rely on the compile-time option here rather than
-	   the LOADED_HIGH flag.  The Qemu kernel loader unconditionally
-	   sets the loadflags to zero. */
-#ifndef __BIG_KERNEL__
-	u16 dst_seg, src_seg;
-	u32 syssize;
-
-	dst_seg =  0x1000 >> 4;
-	src_seg = 0x10000 >> 4;
-	syssize = boot_params.hdr.syssize; /* Size in 16-byte paragraphs */
-
-	while (syssize) {
-		int paras  = (syssize >= 0x1000) ? 0x1000 : syssize;
-		int dwords = paras << 2;
-
-		asm volatile("pushw %%es ; "
-			     "pushw %%ds ; "
-			     "movw %1,%%es ; "
-			     "movw %2,%%ds ; "
-			     "xorw %%di,%%di ; "
-			     "xorw %%si,%%si ; "
-			     "rep;movsl ; "
-			     "popw %%ds ; "
-			     "popw %%es"
-			     : "+c" (dwords)
-			     : "r" (dst_seg), "r" (src_seg)
-			     : "esi", "edi");
-
-		syssize -= paras;
-		dst_seg += paras;
-		src_seg += paras;
-	}
-#endif
-}
-
-/*
  * Disable all interrupts at the legacy PIC.
  */
 static void mask_all_interrupts(void)
@@ -147,9 +106,6 @@ void go_to_protected_mode(void)
 	/* Hook before leaving real mode, also disables interrupts */
 	realmode_switch_hook();
 
-	/* Move the kernel/setup to their final resting places */
-	move_kernel_around();
-
 	/* Enable the A20 gate */
 	if (enable_a20()) {
 		puts("A20 gate not responding, unable to boot...\n");
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 44dc192..ee3a4ea 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -130,7 +130,7 @@ static void die(const char * str, ...)
 
 static void usage(void)
 {
-	die("Usage: build [-b] setup system [rootdev] [> image]");
+	die("Usage: build setup system [rootdev] [> image]");
 }
 
 int main(int argc, char ** argv)
@@ -145,11 +145,6 @@ int main(int argc, char ** argv)
 	void *kernel;
 	u32 crc = 0xffffffffUL;
 
-	if (argc > 2 && !strcmp(argv[1], "-b"))
-	  {
-	    is_big_kernel = 1;
-	    argc--, argv++;
-	  }
 	if ((argc < 3) || (argc > 4))
 		usage();
 	if (argc > 3) {
@@ -216,8 +211,6 @@ int main(int argc, char ** argv)
 		die("Unable to mmap '%s': %m", argv[2]);
 	/* Number of 16-byte paragraphs, including space for a 4-byte CRC */
 	sys_size = (sz + 15 + 4) / 16;
-	if (!is_big_kernel && sys_size > DEF_SYSSIZE)
-		die("System is too big. Try using bzImage or modules.");
 
 	/* Patch the setup code with the appropriate size parameters */
 	buf[0x1f1] = setup_sectors-1;
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 6526cf0..6ba23dd 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_X86_BOOT_H
 #define _ASM_X86_BOOT_H
 
-/* Don't touch these, unless you really know what you're doing. */
-#define DEF_SYSSEG	0x1000
-#define DEF_SYSSIZE	0x7F00
-
 /* Internal svga startup constants */
 #define NORMAL_VGA	0xffff		/* 80x25 mode */
 #define EXTENDED_VGA	0xfffe		/* 80x50 mode */
