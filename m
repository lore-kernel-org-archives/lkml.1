Return-Path: <linux-kernel-owner+w=401wt.eu-S969336AbXEIDh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969336AbXEIDh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967186AbXEIDhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:37:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967098AbXEIDhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:37:11 -0400
Date: Tue, 8 May 2007 20:37:02 -0700
Message-Id: <200705090337.l493b2Hu010533@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Documentation/i386/boot.txt: update and correct
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the process of rewriting the x86 setup code, I found a number of
inaccuracies and outdated recommendations in the boot protocol
documentation.  Revamp to make it more up to date.

In particular, the common use of the heap actually requires (slightly)
more than 4K of heap plus stack, which is the recommended amount in
the document; currently the code compensates by being smaller than
specified, but we can't assume that will be true forever.  Thus,
recommend that if we have a modern bzImage kernel, that the bootloader
maximizes the available space.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/i386/boot.txt |  101 +++++++++++++++++++++++++++++++++----------
 1 files changed, 78 insertions(+), 23 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index 6498666..d01b7a2 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2007-03-06
+			Last update 2007-05-07
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -11,7 +11,7 @@ bootable image, the complicated PC memory model and due to changed
 expectations in the PC industry caused by the effective demise of
 real-mode DOS as a mainstream operating system.
 
-Currently, four versions of the Linux/i386 boot protocol exist.
+Currently, the following versions of the Linux/i386 boot protocol exist.
 
 Old kernels:	zImage/Image support only.  Some very early kernels
 		may not even support a command line.
@@ -183,9 +183,9 @@ filled out, however:
 	a version number.  Otherwise, enter 0xFF here.
 
 	Assigned boot loader ids:
-	0  LILO
+	0  LILO			(0x00 reserved for pre-2.00 bootloader)
 	1  Loadlin
-	2  bootsect-loader
+	2  bootsect-loader	(0x20, all other values reserved)
 	3  SYSLINUX
 	4  EtherBoot
 	5  ELILO
@@ -210,6 +210,9 @@ filled out, however:
 	additional data (such as the kernel command line) moved in
 	addition to the real-mode kernel itself.
 
+	The unit is bytes starting with the beginning of the boot
+	sector.
+
   ramdisk_image, ramdisk_size:
 	If your boot loader has loaded an initial ramdisk (initrd),
 	set ramdisk_image to the 32-bit pointer to the ramdisk data
@@ -278,14 +281,54 @@ command line is entered using the following protocol:
 	field.
 
 
+**** MEMORY LAYOUT OF THE REAL-MODE CODE
+
+The real-mode code requires a stack/heap to be set up, as well as
+memory allocated for the kernel command line.  This needs to be done
+in the real-mode accessible memory in bottom megabyte.
+
+It should be noted that modern machines often have a sizable Extended
+BIOS Data Area (EBDA).  As a result, it is advisable to use as little
+of the low megabyte as possible.
+
+Unfortunately, under the following circumstances the 0x90000 memory
+segment has to be used:
+
+	- When loading a zImage kernel ((loadflags & 0x01) == 0).
+	- When loading a 2.01 or earlier boot protocol kernel.
+
+	  -> For the 2.00 and 2.01 boot protocols, the real-mode code
+	     can be loaded at another address, but it is internally
+	     relocated to 0x90000.  For the "old" protocol, the
+	     real-mode code must be loaded at 0x90000.
+
+When loading at 0x90000, avoid using memory above 0x9a000.
+
+For boot protocol 2.02 or higher, the command line does not have to be
+located in the same 64K segment as the real-mode setup code; it is
+thus permitted to give the stack/heap the full 64K segment and locate
+the command line above it.
+
+The kernel command line should not be located below the real-mode
+code, nor should it be located in high memory.
+
+
 **** SAMPLE BOOT CONFIGURATION
 
 As a sample configuration, assume the following layout of the real
-mode segment (this is a typical, and recommended layout):
+mode segment:
+
+    When loading below 0x90000, use the entire segment:
+
+	0x0000-0x7fff	Real mode kernel
+	0x8000-0xdfff	Stack and heap
+	0xe000-0xffff	Kernel command line
 
-	0x0000-0x7FFF	Real mode kernel
-	0x8000-0x8FFF	Stack and heap
-	0x9000-0x90FF	Kernel command line
+    When loading at 0x90000 OR the protocol version is 2.01 or earlier:
+
+	0x0000-0x7fff	Real mode kernel
+	0x8000-0x97ff	Stack and heap
+	0x9800-0x9fff	Kernel command line
 
 Such a boot loader should enter the following fields in the header:
 
@@ -301,22 +344,33 @@ Such a boot loader should enter the following fields in the header:
 			ramdisk_image = <initrd_address>;
 			ramdisk_size = <initrd_size>;
 		}
+
+		if ( protocol >= 0x0202 && loadflags & 0x01 )
+			heap_end = 0xe000;
+		else
+			heap_end = 0x9800;
+
 		if ( protocol >= 0x0201 ) {
-			heap_end_ptr = 0x9000 - 0x200;
+			heap_end_ptr = heap_end - 0x200;
 			loadflags |= 0x80; /* CAN_USE_HEAP */
 		}
+
 		if ( protocol >= 0x0202 ) {
-			cmd_line_ptr = base_ptr + 0x9000;
+			cmd_line_ptr = base_ptr + heap_end;
+			strcpy(cmd_line_ptr, cmdline);
 		} else {
 			cmd_line_magic	= 0xA33F;
-			cmd_line_offset = 0x9000;
-			setup_move_size = 0x9100;
+			cmd_line_offset = heap_end;
+			setup_move_size = heap_end + strlen(cmdline)+1;
+			strcpy(base_ptr+cmd_line_offset, cmdline);
 		}
 	} else {
 		/* Very old kernel */
 
+		heap_end = 0x9800;
+
 		cmd_line_magic	= 0xA33F;
-		cmd_line_offset = 0x9000;
+		cmd_line_offset = heap_end;
 
 		/* A very old kernel MUST have its real-mode code
 		   loaded at 0x90000 */
@@ -324,12 +378,11 @@ Such a boot loader should enter the following fields in the header:
 		if ( base_ptr != 0x90000 ) {
 			/* Copy the real-mode kernel */
 			memcpy(0x90000, base_ptr, (setup_sects+1)*512);
-			/* Copy the command line */
-			memcpy(0x99000, base_ptr+0x9000, 256);
-
 			base_ptr = 0x90000;		 /* Relocated */
 		}
 
+		strcpy(0x90000+cmd_line_offset, cmdline);
+
 		/* It is recommended to clear memory up to the 32K mark */
 		memset(0x90000 + (setup_sects+1)*512, 0,
 		       (64-(setup_sects+1))*512);
@@ -375,10 +428,11 @@ conflict with actual kernel options now or in the future.
 	line is parsed.
 
   mem=<size>
-	<size> is an integer in C notation optionally followed by K, M
-	or G (meaning << 10, << 20 or << 30).  This specifies the end
-	of memory to the kernel. This affects the possible placement
-	of an initrd, since an initrd should be placed near end of
+	<size> is an integer in C notation optionally followed by
+	(case insensitive) K, M, G, T, P or E (meaning << 10, << 20,
+	<< 30, << 40, << 50 or << 60).  This specifies the end of
+	memory to the kernel. This affects the possible placement of
+	an initrd, since an initrd should be placed near end of
 	memory.  Note that this is an option to *both* the kernel and
 	the bootloader!
 
@@ -428,7 +482,7 @@ In our example from above, we would do:
 
 	/* Set up the real-mode kernel stack */
 	_SS = seg;
-	_SP = 0x9000;	/* Load SP immediately after loading SS! */
+	_SP = heap_end;
 
 	_DS = _ES = _FS = _GS = seg;
 	jmp_far(seg+0x20, 0);	/* Run the kernel */
@@ -460,8 +514,9 @@ IMPORTANT: All the hooks are required to preserve %esp, %ebp, %esi and
   code32_start:
 	A 32-bit flat-mode routine *jumped* to immediately after the
 	transition to protected mode, but before the kernel is
-	uncompressed.  No segments, except CS, are set up; you should
-	set them up to KERNEL_DS (0x18) yourself.
+	uncompressed.  No segments, except CS, are guaranteed to be
+	set up (current kernels do, but older ones do not); you should
+	set them up to BOOT_DS (0x18) yourself.
 
 	After completing your hook, you should jump to the address
 	that was in this field before your boot loader overwrote it.
-- 
1.5.1.3

