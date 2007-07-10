Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXGJDuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXGJDuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbXGJDuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:50:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbXGJDt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:49:58 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 29/33] Assembly header and main routine for new x86 setup code
Date: Mon,  9 Jul 2007 19:52:08 -0700
Message-Id: <11840389834063-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840388782627-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
 <11840381413065-git-send-email-hpa@zytor.com>
 <11840382473923-git-send-email-hpa@zytor.com>
 <11840383522914-git-send-email-hpa@zytor.com>
 <1184038457733-git-send-email-hpa@zytor.com>
 <1184038562864-git-send-email-hpa@zytor.com>
 <11840386682120-git-send-email-hpa@zytor.com>
 <11840387733386-git-send-email-hpa@zytor.com>
 <11840388782627-git-send-email-hpa@zytor.com>
Message-Id: <26d4ebeefed3e0b1593d4fa2357db6912ee944cb.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

The assembly header and initialization code, and the main() routine.
main.c also contains some miscellaneous very short routines.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/header.S |  283 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/i386/boot/main.c   |  161 +++++++++++++++++++++++++++
 2 files changed, 444 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/header.S
 create mode 100644 arch/i386/boot/main.c

diff --git a/arch/i386/boot/header.S b/arch/i386/boot/header.S
new file mode 100644
index 0000000..6b9923f
--- /dev/null
+++ b/arch/i386/boot/header.S
@@ -0,0 +1,283 @@
+/*
+ *	header.S
+ *
+ *	Copyright (C) 1991, 1992 Linus Torvalds
+ *
+ *	Based on bootsect.S and setup.S
+ *	modified by more people than can be counted
+ *
+ *	Rewritten as a common file by H. Peter Anvin (Apr 2007)
+ *
+ * BIG FAT NOTE: We're in real mode using 64k segments.  Therefore segment
+ * addresses must be multiplied by 16 to obtain their respective linear
+ * addresses. To avoid confusion, linear addresses are written using leading
+ * hex while segment addresses are written as segment:offset.
+ *
+ */
+
+#include <asm/segment.h>
+#include <linux/utsrelease.h>
+#include <asm/boot.h>
+#include <asm/e820.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+#include "boot.h"
+
+SETUPSECTS	= 4			/* default nr of setup-sectors */
+BOOTSEG		= 0x07C0		/* original address of boot-sector */
+SYSSEG		= DEF_SYSSEG		/* system loaded at 0x10000 (65536) */
+SYSSIZE		= DEF_SYSSIZE		/* system size: # of 16-byte clicks */
+					/* to be loaded */
+ROOT_DEV	= 0			/* ROOT_DEV is now written by "build" */
+SWAP_DEV	= 0			/* SWAP_DEV is now written by "build" */
+
+#ifndef SVGA_MODE
+#define SVGA_MODE ASK_VGA
+#endif
+
+#ifndef RAMDISK
+#define RAMDISK 0
+#endif
+
+#ifndef ROOT_RDONLY
+#define ROOT_RDONLY 1
+#endif
+
+	.code16
+	.section ".bstext", "ax"
+
+	.global bootsect_start
+bootsect_start:
+
+	# Normalize the start address
+	ljmp	$BOOTSEG, $start2
+
+start2:
+	movw	%cs, %ax
+	movw	%ax, %ds
+	movw	%ax, %es
+	movw	%ax, %ss
+	xorw	%sp, %sp
+	sti
+	cld
+
+	movw	$bugger_off_msg, %si
+
+msg_loop:
+	lodsb
+	andb	%al, %al
+	jz	bs_die
+	movb	$0xe, %ah
+	movw	$7, %bx
+	int	$0x10
+	jmp	msg_loop
+
+bs_die:
+	# Allow the user to press a key, then reboot
+	xorw	%ax, %ax
+	int	$0x16
+	int	$0x19
+
+	# int 0x19 should never return.  In case it does anyway,
+	# invoke the BIOS reset code...
+	ljmp	$0xf000,$0xfff0
+
+	.section ".bsdata", "a"
+bugger_off_msg:
+	.ascii	"Direct booting from floppy is no longer supported.\r\n"
+	.ascii	"Please use a boot loader program instead.\r\n"
+	.ascii	"\n"
+	.ascii	"Remove disk and press any key to reboot . . .\r\n"
+	.byte	0
+
+
+	# Kernel attributes; used by setup.  This is part 1 of the
+	# header, from the old boot sector.
+
+	.section ".header", "a"
+	.globl	hdr
+hdr:
+setup_sects:	.byte SETUPSECTS
+root_flags:	.word ROOT_RDONLY
+syssize:	.long SYSSIZE
+ram_size:	.word RAMDISK
+vid_mode:	.word SVGA_MODE
+root_dev:	.word ROOT_DEV
+boot_flag:	.word 0xAA55
+
+	# offset 512, entry point
+
+	.globl	_start
+_start:
+		# Explicitly enter this as bytes, or the assembler
+		# tries to generate a 3-byte jump here, which causes
+		# everything else to push off to the wrong offset.
+		.byte	0xeb		# short (2-byte) jump
+		.byte	start_of_setup-1f
+1:
+
+	# Part 2 of the header, from the old setup.S
+
+		.ascii	"HdrS"		# header signature
+		.word	0x0206		# header version number (>= 0x0105)
+					# or else old loadlin-1.5 will fail)
+		.globl realmode_swtch
+realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
+start_sys_seg:	.word	SYSSEG
+		.word	kernel_version-512 # pointing to kernel version string
+					# above section of header is compatible
+					# with loadlin-1.5 (header v1.5). Don't
+					# change it.
+
+type_of_loader:	.byte	0		# = 0, old one (LILO, Loadlin,
+					#      Bootlin, SYSLX, bootsect...)
+					# See Documentation/i386/boot.txt for
+					# assigned ids
+
+# flags, unused bits must be zero (RFU) bit within loadflags
+loadflags:
+LOADED_HIGH	= 1			# If set, the kernel is loaded high
+CAN_USE_HEAP	= 0x80			# If set, the loader also has set
+					# heap_end_ptr to tell how much
+					# space behind setup.S can be used for
+					# heap purposes.
+					# Only the loader knows what is free
+#ifndef __BIG_KERNEL__
+		.byte	0
+#else
+		.byte	LOADED_HIGH
+#endif
+
+setup_move_size: .word  0x8000		# size to move, when setup is not
+					# loaded at 0x90000. We will move setup
+					# to 0x90000 then just before jumping
+					# into the kernel. However, only the
+					# loader knows how much data behind
+					# us also needs to be loaded.
+
+code32_start:				# here loaders can put a different
+					# start address for 32-bit code.
+#ifndef __BIG_KERNEL__
+		.long	0x1000		#   0x1000 = default for zImage
+#else
+		.long	0x100000	# 0x100000 = default for big kernel
+#endif
+
+ramdisk_image:	.long	0		# address of loaded ramdisk image
+					# Here the loader puts the 32-bit
+					# address where it loaded the image.
+					# This only will be read by the kernel.
+
+ramdisk_size:	.long	0		# its size in bytes
+
+bootsect_kludge:
+		.long	0		# obsolete
+
+heap_end_ptr:	.word	_end+1024	# (Header version 0x0201 or later)
+					# space from here (exclusive) down to
+					# end of setup code can be used by setup
+					# for local heap purposes.
+
+pad1:		.word	0
+cmd_line_ptr:	.long	0		# (Header version 0x0202 or later)
+					# If nonzero, a 32-bit pointer
+					# to the kernel command line.
+					# The command line should be
+					# located between the start of
+					# setup and the end of low
+					# memory (0xa0000), or it may
+					# get overwritten before it
+					# gets read.  If this field is
+					# used, there is no longer
+					# anything magical about the
+					# 0x90000 segment; the setup
+					# can be located anywhere in
+					# low memory 0x10000 or higher.
+
+ramdisk_max:	.long (-__PAGE_OFFSET-(512 << 20)-1) & 0x7fffffff
+					# (Header version 0x0203 or later)
+					# The highest safe address for
+					# the contents of an initrd
+
+kernel_alignment:  .long CONFIG_PHYSICAL_ALIGN	#physical addr alignment
+						#required for protected mode
+						#kernel
+#ifdef CONFIG_RELOCATABLE
+relocatable_kernel:    .byte 1
+#else
+relocatable_kernel:    .byte 0
+#endif
+pad2:			.byte 0
+pad3:			.word 0
+
+cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
+                                                #added with boot protocol
+                                                #version 2.06
+
+# End of setup header #####################################################
+
+	.section ".inittext", "ax"
+start_of_setup:
+#ifdef SAFE_RESET_DISK_CONTROLLER
+# Reset the disk controller.
+	movw	$0x0000, %ax		# Reset disk controller
+	movb	$0x80, %dl		# All disks
+	int	$0x13
+#endif
+
+# We will have entired with %cs = %ds+0x20, normalize %cs so
+# it is on par with the other segments.
+	pushw	%ds
+	pushw	$setup2
+	lretw
+
+setup2:
+# Force %es = %ds
+	movw	%ds, %ax
+	movw	%ax, %es
+	cld
+
+# Stack paranoia: align the stack and make sure it is good
+# for both 16- and 32-bit references.  In particular, if we
+# were meant to have been using the full 16-bit segment, the
+# caller might have set %sp to zero, which breaks %esp-based
+# references.
+	andw	$~3, %sp	# dword align (might as well...)
+	jnz	1f
+	movw	$0xfffc, %sp	# Make sure we're not zero
+1:	movzwl	%sp, %esp	# Clear upper half of %esp
+	sti
+
+# Check signature at end of setup
+	cmpl	$0x5a5aaa55, setup_sig
+	jne	setup_bad
+
+# Zero the bss
+	movw	$__bss_start, %di
+	movw	$_end+3, %cx
+	xorl	%eax, %eax
+	subw	%di, %cx
+	shrw	$2, %cx
+	rep; stosl
+
+# Jump to C code (should not return)
+	calll	main
+
+# Setup corrupt somehow...
+setup_bad:
+	movl	$setup_corrupt, %eax
+	calll	puts
+	# Fall through...
+
+	.globl	die
+	.type	die, @function
+die:
+	hlt
+	jmp	die
+
+	.size	die, .-due
+
+	.section ".initdata", "a"
+setup_corrupt:
+	.byte	7
+	.string	"No setup signature found..."
diff --git a/arch/i386/boot/main.c b/arch/i386/boot/main.c
new file mode 100644
index 0000000..7f01f96
--- /dev/null
+++ b/arch/i386/boot/main.c
@@ -0,0 +1,161 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/main.c
+ *
+ * Main module for the real-mode kernel code
+ */
+
+#include "boot.h"
+
+struct boot_params boot_params __attribute__((aligned(16)));
+
+char *HEAP = _end;
+char *heap_end = _end;		/* Default end of heap = no heap */
+
+/*
+ * Copy the header into the boot parameter block.  Since this
+ * screws up the old-style command line protocol, adjust by
+ * filling in the new-style command line pointer instead.
+ */
+#define OLD_CL_MAGIC	0xA33F
+#define OLD_CL_ADDRESS	0x20
+
+static void copy_boot_params(void)
+{
+	struct old_cmdline {
+		u16 cl_magic;
+		u16 cl_offset;
+	};
+	const struct old_cmdline * const oldcmd =
+		(const struct old_cmdline *)OLD_CL_ADDRESS;
+
+	BUILD_BUG_ON(sizeof boot_params != 4096);
+	memcpy(&boot_params.hdr, &hdr, sizeof hdr);
+
+	if (!boot_params.hdr.cmd_line_ptr &&
+	    oldcmd->cl_magic == OLD_CL_MAGIC) {
+		/* Old-style command line protocol. */
+		u16 cmdline_seg;
+
+		/* Figure out if the command line falls in the region
+		   of memory that an old kernel would have copied up
+		   to 0x90000... */
+		if (oldcmd->cl_offset < boot_params.hdr.setup_move_size)
+			cmdline_seg = ds();
+		else
+			cmdline_seg = 0x9000;
+
+		boot_params.hdr.cmd_line_ptr =
+			(cmdline_seg << 4) + oldcmd->cl_offset;
+	}
+}
+
+/*
+ * Set the keyboard repeat rate to maximum.  Unclear why this
+ * is done here; this might be possible to kill off as stale code.
+ */
+static void keyboard_set_repeat(void)
+{
+	u16 ax = 0x0305;
+	u16 bx = 0;
+	asm volatile("int $0x16"
+		     : "+a" (ax), "+b" (bx)
+		     : : "ecx", "edx", "esi", "edi");
+}
+
+/*
+ * Get Intel SpeedStep IST information.
+ */
+static void query_speedstep_ist(void)
+{
+	asm("int $0x15"
+	    : "=a" (boot_params.speedstep_info[0]),
+	      "=b" (boot_params.speedstep_info[1]),
+	      "=c" (boot_params.speedstep_info[2]),
+	      "=d" (boot_params.speedstep_info[3])
+	    : "a" (0x0000e980),	 /* IST Support */
+	      "d" (0x47534943)); /* Request value */
+}
+
+/*
+ * Tell the BIOS what CPU mode we intend to run in.
+ */
+static void set_bios_mode(void)
+{
+#ifdef CONFIG_X86_64
+	u32 eax, ebx;
+
+	eax = 0xec00;
+	ebx = 2;
+	asm volatile("int $0x15"
+		     : "+a" (eax), "+b" (ebx)
+		     : : "ecx", "edx", "esi", "edi");
+#endif
+}
+
+void main(void)
+{
+	/* First, copy the boot header into the "zeropage" */
+	copy_boot_params();
+
+	/* End of heap check */
+	if (boot_params.hdr.loadflags & CAN_USE_HEAP) {
+		heap_end = (char *)(boot_params.hdr.heap_end_ptr
+				    +0x200-STACK_SIZE);
+	} else {
+		/* Boot protocol 2.00 only, no heap available */
+		puts("WARNING: Ancient bootloader, some functionality "
+		     "may be limited!\n");
+	}
+
+	/* Make sure we have all the proper CPU support */
+	if (validate_cpu()) {
+		puts("Unable to boot - please use a kernel appropriate "
+		     "for your CPU.\n");
+		die();
+	}
+
+	/* Tell the BIOS what CPU mode we intend to run in. */
+	set_bios_mode();
+
+	/* Detect memory layout */
+	detect_memory();
+
+	/* Set keyboard repeat rate (why?) */
+	keyboard_set_repeat();
+
+	/* Set the video mode */
+	set_video();
+
+	/* Query MCA information */
+	query_mca();
+
+	/* Voyager */
+#ifdef CONFIG_X86_VOYAGER
+	query_voyager();
+#endif
+
+	/* Query SpeedStep IST information */
+	query_speedstep_ist();
+
+	/* Query APM information */
+#if defined(CONFIG_APM) || defined(CONFIG_APM_MODULE)
+	query_apm_bios();
+#endif
+
+	/* Query EDD information */
+#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
+	query_edd();
+#endif
+	/* Do the last things and invoke protected mode */
+	go_to_protected_mode();
+}
-- 
1.5.2.2

