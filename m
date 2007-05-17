Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXEQWwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXEQWwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXEQWwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:52:03 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbXEQWwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:52:00 -0400
Date: Thu, 17 May 2007 15:50:47 -0700
Message-Id: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Further update of the i386 boot documentation
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A number of items in the i386 boot documentation have been either
vague, outdated or hard to read.  This text revision adds several more
examples, including a memory map for a modern kernel load.  It also
adds a field-by-field detailed description of the setup header, and a
bootloader ID for Qemu.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index d01b7a2..5150e76 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2007-05-07
+			Last update 2007-05-16
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -52,7 +52,8 @@ zImage kernels, typically looks like:
 0A0000	+------------------------+
 	|  Reserved for BIOS	 |	Do not use.  Reserved for BIOS EBDA.
 09A000	+------------------------+
-	|  Stack/heap/cmdline	 |	For use by the kernel real-mode code.
+	|  Command line		 |
+	|  Stack/heap		 |	For use by the kernel real-mode code.
 098000	+------------------------+	
 	|  Kernel setup		 |	The kernel real-mode code.
 090200	+------------------------+
@@ -73,10 +74,9 @@ zImage kernels, typically looks like:
 When using bzImage, the protected-mode kernel was relocated to
 0x100000 ("high memory"), and the kernel real-mode block (boot sector,
 setup, and stack/heap) was made relocatable to any address between
-0x10000 and end of low memory.	Unfortunately, in protocols 2.00 and
-2.01 the command line is still required to live in the 0x9XXXX memory
-range, and that memory range is still overwritten by the early kernel.
-The 2.02 protocol resolves that problem.
+0x10000 and end of low memory. Unfortunately, in protocols 2.00 and
+2.01 the 0x90000+ memory range is still used internally by the kernel;
+the 2.02 protocol resolves that problem.
 
 It is desirable to keep the "memory ceiling" -- the highest point in
 low memory touched by the boot loader -- as low as possible, since
@@ -93,6 +93,35 @@ zImage or old bzImage kernels, which need data written into the
 0x90000 segment, the boot loader should make sure not to use memory
 above the 0x9A000 point; too many BIOSes will break above that point.
 
+For a modern bzImage kernel with boot protocol version >= 2.02, a
+memory layout like the following is suggested:
+
+	~                        ~
+        |  Protected-mode kernel |
+100000  +------------------------+
+	|  I/O memory hole	 |
+0A0000	+------------------------+
+	|  Reserved for BIOS	 |	Leave as much as possible unused
+	~                        ~
+	|  Command line		 |	(Can also be below the X+10000 mark)
+X+10000	+------------------------+
+	|  Stack/heap		 |	For use by the kernel real-mode code.
+X+08000	+------------------------+	
+	|  Kernel setup		 |	The kernel real-mode code.
+	|  Kernel boot sector	 |	The kernel legacy boot sector.
+X       +------------------------+
+	|  Boot loader		 |	<- Boot sector entry point 0000:7C00
+001000	+------------------------+
+	|  Reserved for MBR/BIOS |
+000800	+------------------------+
+	|  Typically used by MBR |
+000600	+------------------------+ 
+	|  BIOS use only	 |
+000000	+------------------------+
+
+... where the address X is as low as the design of the boot loader
+permits.
+
 
 **** THE REAL-MODE KERNEL HEADER
 
@@ -160,29 +189,136 @@ e.g. protocol version 2.01 will contain 0x0201 in this field.  When
 setting fields in the header, you must make sure only to set fields
 supported by the protocol version in use.
 
-The "kernel_version" field, if set to a nonzero value, contains a
-pointer to a null-terminated human-readable kernel version number
-string, less 0x200.  This can be used to display the kernel version to
-the user.  This value should be less than (0x200*setup_sects).  For
-example, if this value is set to 0x1c00, the kernel version number
-string can be found at offset 0x1e00 in the kernel file.  This is a
-valid value if and only if the "setup_sects" field contains the value
-14 or higher.
-
-Most boot loaders will simply load the kernel at its target address
-directly.  Such boot loaders do not need to worry about filling in
-most of the fields in the header.  The following fields should be
-filled out, however:
-
-  vid_mode:
-	Please see the section on SPECIAL COMMAND LINE OPTIONS.
-
-  type_of_loader:
-	If your boot loader has an assigned id (see table below), enter
-	0xTV here, where T is an identifier for the boot loader and V is
-	a version number.  Otherwise, enter 0xFF here.
-
-	Assigned boot loader ids:
+
+**** DETAILS OF HEADER FIELDS
+
+For each field, some are information from the kernel to the bootloader
+("read"), some are expected to be filled out by the bootloader
+("write"), and some are expected to be read and modified by the
+bootloader ("modify").
+
+All general purpose boot loaders should write the fields marked
+(obligatory).  Boot loaders who want to load the kernel at a
+nonstandard address should fill in the fields marked (reloc); other
+boot loaders can ignore those fields.
+
+Field name:	setup_secs
+Type:		read
+Offset/size:	0x1f1/1
+Protocol:	ALL
+
+  The size of the setup code in 512-byte sectors.  If this field is
+  0, the real value is 4.  The real-mode code consists of the boot
+  sector (always one 512-byte sector) plus the setup code.
+
+Field name:	 root_flags
+Type:		 modify (optional)
+Offset/size:	 0x1f2/2
+Protocol:	 ALL
+
+  If this field is nonzero, the root defaults to readonly.  The use of
+  this field is deprecated; use the "ro" or "rw" options on the
+  command line instead.
+
+Field name:	syssize
+Type:		read
+Offset/size:	0x1f4/4 (protocol 2.04+) 0x1f4/2 (protocol ALL)
+Protocol:	2.04+
+
+  The size of the protected-mode code in units of 16-byte paragraphs.
+  For protocol versions older than 2.04 this field is only two bytes
+  wide, and therefore cannot be trusted for the size of a kernel if
+  the LOAD_HIGH flag is set.
+
+Field name:	ram_size
+Type:		kernel internal
+Offset/size:	0x1f8/2
+Protocol:	ALL
+
+  This field is obsolete.
+
+Field name:	vid_mode
+Type:		modify (obligatory)
+Offset/size:	0x1fa/2
+
+  Please see the section on SPECIAL COMMAND LINE OPTIONS.
+
+Field name:	root_dev
+Type:		modify (optional)
+Offset/size:	0x1fc/2
+Protocol:	ALL
+
+  The default root device device number.  The use of this field is
+  deprecated, use the "root=" option on the command line instead.
+
+Field name:	boot_flag
+Type:		read
+Offset/size:	0x1fe/2
+Protocol:	ALL
+
+  Contains 0xAA55.  This is the closest thing old Linux kernels have
+  to a magic number.
+
+Field name:	jump
+Type:		read
+Offset/size:	0x200/2
+Protocol:	2.00+
+
+  Contains an x86 jump instruction, 0xEB followed by a signed offset
+  relative to byte 0x202.  This can be used to determine the size of
+  the header.
+
+Field name:	header
+Type:		read
+Offset/size:	0x202/4
+Protocol:	2.00+
+
+  Contains the magic number "HdrS" (0x53726448).
+
+Field name:	version
+Type:		read
+Offset/size:	0x206/2
+Protocol:	2.00+
+
+  Contains the boot protocol version, e.g. 0x0204 for version 2.04.
+
+Field name:	readmode_swtch
+Type:		modify (optional)
+Offset/size:	0x208/4
+Protocol:	2.00+
+
+  Boot loader hook (see separate chapter.)
+
+Field name:	start_sys
+Type:		read
+Offset/size:	0x20c/4
+Protocol:	2.00+
+
+  The load low segment (0x1000).  Obsolete.
+
+Field name:	kernel_version
+Type:		read
+Offset/size:	0x20e/2
+Protocol:	2.00+
+
+  If set to a nonzero value, contains a pointer to a null-terminated
+  human-readable kernel version number string, less 0x200.  This can
+  be used to display the kernel version to the user.  This value
+  should be less than (0x200*setup_sects).  For example, if this value
+  is set to 0x1c00, the kernel version number string can be found at
+  offset 0x1e00 in the kernel file.  This is a valid value if and only
+  if the "setup_sects" field contains the value 14 or higher.
+
+Field name:	type_of_loader
+Type:		write (obligatory)
+Offset/size:	0x210/1
+Protocol:	2.00+
+
+  If your boot loader has an assigned id (see table below), enter
+  0xTV here, where T is an identifier for the boot loader and V is
+  a version number.  Otherwise, enter 0xFF here.
+
+  Assigned boot loader ids:
 	0  LILO			(0x00 reserved for pre-2.00 bootloader)
 	1  Loadlin
 	2  bootsect-loader	(0x20, all other values reserved)
@@ -193,60 +329,145 @@ filled out, however:
 	8  U-BOOT
 	9  Xen
 	A  Gujin
-
-	Please contact <hpa@zytor.com> if you need a bootloader ID
-	value assigned.
-
-  loadflags, heap_end_ptr:
-	If the protocol version is 2.01 or higher, enter the
-	offset limit of the setup heap into heap_end_ptr and set the
-	0x80 bit (CAN_USE_HEAP) of loadflags.  heap_end_ptr appears to
-	be relative to the start of setup (offset 0x0200).
-
-  setup_move_size: 
-	When using protocol 2.00 or 2.01, if the real mode
-	kernel is not loaded at 0x90000, it gets moved there later in
-	the loading sequence.  Fill in this field if you want
-	additional data (such as the kernel command line) moved in
-	addition to the real-mode kernel itself.
-
-	The unit is bytes starting with the beginning of the boot
-	sector.
-
-  ramdisk_image, ramdisk_size:
-	If your boot loader has loaded an initial ramdisk (initrd),
-	set ramdisk_image to the 32-bit pointer to the ramdisk data
-	and the ramdisk_size to the size of the ramdisk data.
-
-	The initrd should typically be located as high in memory as
-	possible, as it may otherwise get overwritten by the early
-	kernel initialization sequence.	 However, it must never be
-	located above the address specified in the initrd_addr_max
-	field.	The initrd should be at least 4K page aligned.
-
-  cmd_line_ptr:
-	If the protocol version is 2.02 or higher, this is a 32-bit
-	pointer to the kernel command line.  The kernel command line
-	can be located anywhere between the end of setup and 0xA0000.
-	Fill in this field even if your boot loader does not support a
-	command line, in which case you can point this to an empty
-	string (or better yet, to the string "auto".)  If this field
-	is left at zero, the kernel will assume that your boot loader
-	does not support the 2.02+ protocol.
-
-  ramdisk_max:
-	The maximum address that may be occupied by the initrd
-	contents.  For boot protocols 2.02 or earlier, this field is
-	not present, and the maximum address is 0x37FFFFFF.  (This
-	address is defined as the address of the highest safe byte, so
-	if your ramdisk is exactly 131072 bytes long and this field is
-	0x37FFFFFF, you can start your ramdisk at 0x37FE0000.)
-
-  cmdline_size:
-	The maximum size of the command line without the terminating
-	zero. This means that the command line can contain at most
-	cmdline_size characters. With protocol version 2.05 and
-	earlier, the maximum size was 255.
+	B  Qemu
+
+  Please contact <hpa@zytor.com> if you need a bootloader ID
+  value assigned.
+
+Field name:	loadflags
+Type:		modify (obligatory)
+Offset/size:	0x211/1
+Protocol:	2.00+
+
+  This field is a bitmask.
+
+  Bit 0 (read):	LOADED_HIGH
+	- If 0, the protected-mode code is loaded at 0x10000.
+	- If 1, the protected-mode code is loaded at 0x100000.
+
+  Bit 7 (write): CAN_USE_HEAP
+	Set this bit to 1 to indicate that the value entered in the
+	heap_end_ptr is valid.  If this field is clear, some setup code
+	functionality will be disabled.
+
+Field name:	setup_move_size
+Type:		modify (obligatory)
+Offset/size:	0x212/2
+Protocol:	2.00-2.01
+
+  When using protocol 2.00 or 2.01, if the real mode kernel is not
+  loaded at 0x90000, it gets moved there later in the loading
+  sequence.  Fill in this field if you want additional data (such as
+  the kernel command line) moved in addition to the real-mode kernel
+  itself.
+
+  The unit is bytes starting with the beginning of the boot sector.
+  
+  This field is can be ignored when the protocol is 2.02 or higher, or
+  if the real-mode code is loaded at 0x90000.
+
+Field name:	code32_start
+Type:		modify (optional, reloc)
+Offset/size:	0x214/4
+Protocol:	2.00+
+
+  The address to jump to in protected mode.  This defaults to the load
+  address of the kernel, and can be used by the boot loader to
+  determine the proper load address.
+
+  This field can be modified for two purposes:
+
+  1. as a boot loader hook (see separate chapter.)
+
+  2. if a bootloader which does not install a hook loads a
+     relocatable kernel at a nonstandard address it will have to modify
+     this field to point to the load address.
+
+Field name:	ramdisk_image
+Type:		write (obligatory)
+Offset/size:	0x218/4
+Protocol:	2.00+
+
+  The 32-bit linear address of the initial ramdisk or ramfs.  Leave at
+  zero if there is no initial ramdisk/ramfs.
+
+Field name:	ramdisk_size
+Type:		write (obligatory)
+Offset/size:	0x21c/4
+Protocol:	2.00+
+
+  Size of the initial ramdisk or ramfs.  Leave at zero if there is no
+  initial ramdisk/ramfs.
+
+Field name:	bootsect_kludge
+Type:		kernel internal
+Offset/size:	0x220/4
+Protocol:	2.00+
+
+  This field is obsolete.
+
+Field name:	heap_end_ptr
+Type:		write (obligatory)
+Offset/size:	0x224/2
+Protocol:	2.01+
+
+  Set this field to the offset (from the beginning of the real-mode
+  code) of the end of the setup stack/heap, minus 0x0200.
+
+Field name:	cmd_line_ptr
+Type:		write (obligatory)
+Offset/size:	0x228/4
+Protocol:	2.02+
+
+  Set this field to the linear address of the kernel command line.
+  The kernel command line can be located anywhere between the end of
+  the setup heap and 0xA0000; it does not have to be located in the
+  same 64K segment as the real-mode code itself.
+
+  Fill in this field even if your boot loader does not support a
+  command line, in which case you can point this to an empty string
+  (or better yet, to the string "auto".)  If this field is left at
+  zero, the kernel will assume that your boot loader does not support
+  the 2.02+ protocol.
+
+Field name:	initrd_addr_max
+Type:		read
+Offset/size:	0x22c/4
+Protocol:	2.03+
+
+  The maximum address that may be occupied by the initial
+  ramdisk/ramfs contents.  For boot protocols 2.02 or earlier, this
+  field is not present, and the maximum address is 0x37FFFFFF.  (This
+  address is defined as the address of the highest safe byte, so if
+  your ramdisk is exactly 131072 bytes long and this field is
+  0x37FFFFFF, you can start your ramdisk at 0x37FE0000.)
+
+Field name:	kernel_alignment
+Type:		read (reloc)
+Offset/size:	0x230/4
+Protocol:	2.05+
+
+  Alignment unit required by the kernel (if relocatable_kernel is true.)
+
+Field name:	relocatable_kernel
+Type:		read (reloc)
+Offset/size:	0x234/1
+Protocol:	2.05+
+
+  If this field is nonzero, the protected-mode part of the kernel can
+  be loaded at any address that satisfies the kernel_alignment field.
+  After loading, the boot loader must set the code32_start field to
+  point to the loaded code, or to a boot loader hook.
+
+Field name:	cmdline_size
+Type:		read
+Offset/size:	0x238/4
+Protocol:	2.06+
+
+  The maximum size of the command line without the terminating
+  zero. This means that the command line can contain at most
+  cmdline_size characters. With protocol version 2.05 and earlier, the
+  maximum size was 255.
 
 
 **** THE KERNEL COMMAND LINE
