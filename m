Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbXEXABe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbXEXABe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXEXAB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:01:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbXEXABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:01:25 -0400
Message-Id: <200705240001.l4O01L8D015594@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 23 May 2007 16:59:27 -0700
Subject: [PATCH] [i386] boot documentation: clarifications
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Textual clarifications (and fix an off-by-one error) based on feedback
mostly from Jeremy Fitzhardinge.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/i386/boot.txt |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index 66fa67f..35985b3 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2007-05-16
+			Last update 2007-05-23
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -202,6 +202,8 @@ All general purpose boot loaders should write the fields marked
 nonstandard address should fill in the fields marked (reloc); other
 boot loaders can ignore those fields.
 
+The byte order of all fields is littleendian (this is x86, after all.)
+
 Field name:	setup_secs
 Type:		read
 Offset/size:	0x1f1/1
@@ -280,14 +282,16 @@ Type:		read
 Offset/size:	0x206/2
 Protocol:	2.00+
 
-  Contains the boot protocol version, e.g. 0x0204 for version 2.04.
+  Contains the boot protocol version, in (major << 8)+minor format,
+  e.g. 0x0204 for version 2.04, and 0x0a11 for a hypothetical version
+  10.17.
 
 Field name:	readmode_swtch
 Type:		modify (optional)
 Offset/size:	0x208/4
 Protocol:	2.00+
 
-  Boot loader hook (see separate chapter.)
+  Boot loader hook (see ADVANCED BOOT LOADER HOOKS below.)
 
 Field name:	start_sys
 Type:		read
@@ -304,10 +308,17 @@ Protocol:	2.00+
   If set to a nonzero value, contains a pointer to a NUL-terminated
   human-readable kernel version number string, less 0x200.  This can
   be used to display the kernel version to the user.  This value
-  should be less than (0x200*setup_sects).  For example, if this value
-  is set to 0x1c00, the kernel version number string can be found at
-  offset 0x1e00 in the kernel file.  This is a valid value if and only
-  if the "setup_sects" field contains the value 14 or higher.
+  should be less than (0x200*setup_sects).
+
+  For example, if this value is set to 0x1c00, the kernel version
+  number string can be found at offset 0x1e00 in the kernel file.
+  This is a valid value if and only if the "setup_sects" field
+  contains the value 15 or higher, as:
+
+	0x1c00  < 15*0x200 (= 0x1e00) but
+	0x1c00 >= 14*0x200 (= 0x1c00)
+
+	0x1c00 >> 9 = 14, so the minimum value for setup_secs is 15.
 
 Field name:	type_of_loader
 Type:		write (obligatory)
@@ -377,7 +388,7 @@ Protocol:	2.00+
 
   This field can be modified for two purposes:
 
-  1. as a boot loader hook (see separate chapter.)
+  1. as a boot loader hook (see ADVANCED BOOT LOADER HOOKS below.)
 
   2. if a bootloader which does not install a hook loads a
      relocatable kernel at a nonstandard address it will have to modify
@@ -715,7 +726,7 @@ switched off, especially if the loaded kernel has the floppy driver as
 a demand-loaded module!
 
 
-**** ADVANCED BOOT TIME HOOKS
+**** ADVANCED BOOT LOADER HOOKS
 
 If the boot loader runs in a particularly hostile environment (such as
 LOADLIN, which runs under DOS) it may be impossible to follow the
@@ -740,4 +751,5 @@ IMPORTANT: All the hooks are required to preserve %esp, %ebp, %esi and
 	set them up to BOOT_DS (0x18) yourself.
 
 	After completing your hook, you should jump to the address
-	that was in this field before your boot loader overwrote it.
+	that was in this field before your boot loader overwrote it
+	(relocated, if appropriate.)
-- 
1.5.2

