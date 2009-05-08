Return-Path: <linux-kernel-owner+w=401wt.eu-S1763715AbZEHAmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763715AbZEHAmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763413AbZEHATQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:19:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763470AbZEHATO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:19:14 -0400
Date: Fri, 8 May 2009 00:18:49 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <49823683.6060201@zytor.com>
References: <49823683.6060201@zytor.com>
Subject: [tip:x86/kbuild-phys] x86: add extension fields for bootloader type and version
Message-ID: <tip-3d280bb6fc862ea3a376841a529dfc683715ca05@git.kernel.org>
Git-Commit-ID: 3d280bb6fc862ea3a376841a529dfc683715ca05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 00:18:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d280bb6fc862ea3a376841a529dfc683715ca05
Gitweb:     http://git.kernel.org/tip/3d280bb6fc862ea3a376841a529dfc683715ca05
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 7 May 2009 16:54:11 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 May 2009 16:54:11 -0700

x86: add extension fields for bootloader type and version

A long ago, in days of yore, it all began with a god named Thor.
There were vikings and boats and some plans for a Linux kernel
header.  Unfortunately, a single 8-bit field was used for bootloader
type and version.  This has generally worked without *too* much pain,
but we're getting close to flat running out of ID fields.

Add extension fields for both type and version.  The type will be
extended if it the old field is 0xE; the version is a simple MSB
extension.

Keep /proc/sys/kernel/bootloader_type containing
(type << 4) + (ver & 0xf) for backwards compatiblity, but also add
/proc/sys/kernel/bootloader_version which contains the full version
number.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <49823683.6060201@zytor.com>


---
 Documentation/x86/boot.txt       |   57 ++++++++++++++++++++++++++++++++++---
 arch/x86/boot/header.S           |    6 +++-
 arch/x86/include/asm/bootparam.h |    3 +-
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/setup.c          |   10 +++++-
 kernel/sysctl.c                  |    8 +++++
 6 files changed, 76 insertions(+), 9 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 093f838..01b5542 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -52,7 +52,8 @@ Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
 
 Protocol 2.10:	(Kernel 2.6.31) Added the runtime_start and
 		runtime_size fields for the post-decompression address
-		and memory requirements of the kernel.
+		and memory requirements of the kernel.  The previous "pad1"
+		field reclaimed as extended boot loader ID.
 
 **** MEMORY LAYOUT
 
@@ -172,7 +173,8 @@ Offset	Proto	Name		Meaning
 021C/4	2.00+	ramdisk_size	initrd size (set by boot loader)
 0220/4	2.00+	bootsect_kludge	DO NOT USE - for bootsect.S use only
 0224/2	2.01+	heap_end_ptr	Free memory after setup end
-0226/2	N/A	pad1		Unused
+0226/1	2.02+(3 ext_loader_ver	Extended boot loader version
+0227/1	2.02+(3	ext_loader_type	Extended boot loader ID
 0228/4	2.02+	cmd_line_ptr	32-bit pointer to the kernel command line
 022C/4	2.03+	ramdisk_max	Highest legal initrd address
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
@@ -196,6 +198,8 @@ Offset	Proto	Name		Meaning
     field are unusable, which means the size of a bzImage kernel
     cannot be determined.
 
+(3) Ignored, but safe to set, for boot protocols 2.02-2.09.
+
 If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
 the boot protocol version is "old".  Loading an old kernel, the
 following parameters should be assumed:
@@ -349,18 +353,32 @@ Protocol:	2.00+
   0xTV here, where T is an identifier for the boot loader and V is
   a version number.  Otherwise, enter 0xFF here.
 
+  For boot loader IDs above T = 0xD, write T = 0xE to this field and
+  write the extended ID minus 0x10 to the ext_loader_type field.
+  Similarly, the ext_loader_ver field can be used to provide more than
+  four bits for the bootloader version.
+
+  For example, for T = 0x15, V = 0x234, write:
+
+  type_of_loader  <- 0xE4
+  ext_loader_type <- 0x05
+  ext_loader_ver  <- 0x23
+
   Assigned boot loader ids:
 	0  LILO			(0x00 reserved for pre-2.00 bootloader)
 	1  Loadlin
 	2  bootsect-loader	(0x20, all other values reserved)
-	3  SYSLINUX
-	4  EtherBoot
+	3  Syslinux
+	4  Etherboot/gPXE
 	5  ELILO
 	7  GRUB
-	8  U-BOOT
+	8  U-Boot
 	9  Xen
 	A  Gujin
 	B  Qemu
+	C  Arcturus Networks uCbootloader
+	E  Extended		(see ext_loader_type)
+	F  Special		(0xFF = undefined)
 
   Please contact <hpa@zytor.com> if you need a bootloader ID
   value assigned.
@@ -459,6 +477,35 @@ Protocol:	2.01+
   Set this field to the offset (from the beginning of the real-mode
   code) of the end of the setup stack/heap, minus 0x0200.
 
+Field name:	ext_loader_ver
+Type:		write (optional)
+Offset/size:	0x226/1
+Protocol:	2.02+
+
+  This field is used as an extension of the version number in the
+  type_of_loader field.  The total version number is considered to be
+  (type_of_loader & 0x0f) + (ext_loader_ver << 4).
+
+  The use of this field is boot loader specific.  If not written, it
+  is zero.
+
+  Kernels prior to 2.6.31 did not recognize this field, but it is safe
+  to write for protocol version 2.02 or higher.
+
+Field name:	ext_loader_type
+Type:		write (obligatory if (type_of_loader & 0xf0) == 0xe0)
+Offset/size:	0x227/1
+Protocol:	2.02+
+
+  This field is used as an extension of the type number in
+  type_of_loader field.  If the type in type_of_loader is 0xE, then
+  the actual type is (ext_loader_type + 0x10).
+
+  This field is ignored if the type in type_of_loader is not 0xE.
+
+  Kernels prior to 2.6.31 did not recognize this field, but it is safe
+  to write for protocol version 2.02 or higher.
+
 Field name:	cmd_line_ptr
 Type:		write (obligatory)
 Offset/size:	0x228/4
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 0491fc4..5e96bb2 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -169,7 +169,11 @@ heap_end_ptr:	.word	_end+STACK_SIZE-512
 					# end of setup code can be used by setup
 					# for local heap purposes.
 
-pad1:		.word	0
+ext_loader_ver:
+		.byte	0		# Extended boot loader version
+ext_loader_type:
+		.byte	0		# Extended boot loader type
+
 cmd_line_ptr:	.long	0		# (Header version 0x0202 or later)
 					# If nonzero, a 32-bit pointer
 					# to the kernel command line.
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index dd924b5..5b02f05 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -50,7 +50,8 @@ struct setup_header {
 	__u32	ramdisk_size;
 	__u32	bootsect_kludge;
 	__u16	heap_end_ptr;
-	__u16	_pad1;
+	__u8	ext_loader_ver;
+	__u8	ext_loader_type;
 	__u32	cmd_line_ptr;
 	__u32	initrd_addr_max;
 	__u32	kernel_alignment;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fcf4d92..6384d25 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -814,6 +814,7 @@ extern unsigned int		BIOS_revision;
 
 /* Boot loader type from the setup header: */
 extern int			bootloader_type;
+extern int			bootloader_version;
 
 extern char			ignore_fpu_irq;
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..2b09345 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -214,8 +214,8 @@ unsigned long mmu_cr4_features;
 unsigned long mmu_cr4_features = X86_CR4_PAE;
 #endif
 
-/* Boot loader ID as an integer, for the benefit of proc_dointvec */
-int bootloader_type;
+/* Boot loader ID and version as integers, for the benefit of proc_dointvec */
+int bootloader_type, bootloader_version;
 
 /*
  * Setup options
@@ -706,6 +706,12 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	saved_video_mode = boot_params.hdr.vid_mode;
 	bootloader_type = boot_params.hdr.type_of_loader;
+	if ((bootloader_type >> 4) == 0xe) {
+		bootloader_type &= 0xf;
+		bootloader_type |= (boot_params.hdr.ext_loader_type+0x10) << 4;
+	}
+	bootloader_version  = bootloader_type & 0xf;
+	bootloader_version |= boot_params.hdr.ext_loader_ver << 4;
 
 #ifdef CONFIG_BLK_DEV_RAM
 	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e3d2c7d..cf91c93 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -729,6 +729,14 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "bootloader_version",
+		.data		= &bootloader_version,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "kstack_depth_to_print",
 		.data		= &kstack_depth_to_print,
 		.maxlen		= sizeof(int),
