Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXFUAiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXFUAiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbXFUAhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:37:11 -0400
Received: from bay-wan-b-65.sfo.dsl.cerfnet.com ([216.148.65.65]:39547 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754533AbXFUAhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:37:09 -0400
Message-Id: <20070620231852.441958361@goop.org>
References: <20070620231726.834538992@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 16:17:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/9] update boot spec to 2.07
Content-Disposition: inline; filename=update-boot-spec.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Proposed updates for version 2.07 of the boot protocol.  This includes:

load_flags.KEEP_SEGMENTS- flag to request/inhibit segment reloads
hardware_subarch	- what subarchitecture we're booting under
hardware_subarch_data	- per-architecture data

The intention of these changes is to make booting a paravirtualized
kernel work via the normal Linux boot protocol.  The intention is that
the bzImage payload can be a properly formed ELF file, so that the
bootloader can use its ELF notes and Phdrs to get more metadata about
the kernel and its requirements.

The ELF file could be the uncompressed kernel vmlinux itself; it would
only take small buildsystem changes to implement this.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 Documentation/i386/boot.txt    |   34 +++++++++++++++++++++++++++++++++-
 arch/i386/kernel/asm-offsets.c |    7 +++++++
 include/asm-i386/bootparam.h   |    9 +++++++--
 3 files changed, 47 insertions(+), 3 deletions(-)

===================================================================
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -168,6 +168,8 @@ 0234/1	2.05+	relocatable_kernel Whether 
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/3	N/A	pad2		Unused
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
+023C/4	2.07+	hardware_subarch Hardware subarchitecture
+0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -204,7 +206,7 @@ boot loaders can ignore those fields.
 
 The byte order of all fields is littleendian (this is x86, after all.)
 
-Field name:	setup_secs
+Field name:	setup_sects
 Type:		read
 Offset/size:	0x1f1/1
 Protocol:	ALL
@@ -356,6 +358,13 @@ Protocol:	2.00+
 	- If 0, the protected-mode code is loaded at 0x10000.
 	- If 1, the protected-mode code is loaded at 0x100000.
 
+  Bit 6 (write): KEEP_SEGMENTS
+	Protocol: 2.07+
+	- if 0, reload the segment registers in the 32bit entry point.
+	- if 1, do not reload the segment registers in the 32bit entry point.
+		Assume that %cs %ds %ss %es are all set to flat segments with
+		a base of 0 (or the equivalent for their environment).
+
   Bit 7 (write): CAN_USE_HEAP
 	Set this bit to 1 to indicate that the value entered in the
 	heap_end_ptr is valid.  If this field is clear, some setup code
@@ -479,6 +488,29 @@ Protocol:	2.06+
   zero. This means that the command line can contain at most
   cmdline_size characters. With protocol version 2.05 and earlier, the
   maximum size was 255.
+
+Field name:	hardware_subarch
+Type:		write
+Offset/size:	0x23c/4
+Protocol:	2.07+
+
+  In a paravirtualized environment the hardware low level architectural
+  pieces such as interrupt handling, page table handling, and
+  accessing process control registers needs to be done differently.
+
+  This field allows the bootloader to inform the kernel we are in one
+  one of those environments.
+
+  0x00000000	The default x86/PC environment
+  0x00000001	lguest
+  0x00000002	Xen
+
+Field name:	hardware_subarch_data
+Type:		write
+Offset/size:	0x240/8
+Protocol:	2.07+
+
+  A pointer to data that is specific to hardware subarch
 
 
 **** THE KERNEL COMMAND LINE
===================================================================
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -15,6 +15,7 @@
 #include <asm/fixmap.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
+#include <asm/bootparam.h>
 #include <asm/elf.h>
 #include <xen/interface/xen.h>
 
@@ -143,4 +144,10 @@ void foo(void)
 	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
 	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
 #endif
+
+	BLANK();
+	OFFSET(BP_scratch, boot_params, scratch);
+	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
+	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
+	OFFSET(BP_version, boot_params, hdr.version);
 }
===================================================================
--- a/include/asm-i386/bootparam.h
+++ b/include/asm-i386/bootparam.h
@@ -24,8 +24,9 @@ struct setup_header {
 	u16	kernel_version;
 	u8	type_of_loader;
 	u8	loadflags;
-#define LOADED_HIGH	0x01
-#define CAN_USE_HEAP	0x80
+#define LOADED_HIGH	(1<<0)
+#define KEEP_SEGMENTS	(1<<6)
+#define CAN_USE_HEAP	(1<<7)
 	u16	setup_move_size;
 	u32	code32_start;
 	u32	ramdisk_image;
@@ -37,6 +38,10 @@ struct setup_header {
 	u32	initrd_addr_max;
 	u32	kernel_alignment;
 	u8	relocatable_kernel;
+	u8	_pad2[3];
+	u32	cmdline_size;
+	u32	hardware_subarch;
+	u64	hardware_subarch_data;
 } __attribute__((packed));
 
 struct sys_desc_table {

-- 

