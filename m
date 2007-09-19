Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbXISDMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbXISDMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXISDMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:12:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:48201 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbXISDMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:12:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,271,1186383600"; 
   d="scan'208";a="298164467"
Subject: [PATCH -mm -v2 2/2] i386/x86_64 boot: document for 32 bit boot
	protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2007 11:10:28 +0800
Message-Id: <1190171428.12429.63.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 19 Sep 2007 03:08:31.0636 (UTC) FILETIME=[5BC36D40:01C7FA6A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines a 32-bit boot protocol and adds corresponding
document. It is based on the proposal of Peter Anvin.


Known issues:

- The hd0_info and hd1_info are deleted from the zero page. Additional
  work should be done for this? Or this is unnecessary (because no new
  fields will be added to zero page)?

- The fields in zero page are fairly complex (such as struct
  edd_info). Is it necessary to document every field inside the first
  level fields, until the primary data type? Or is it sufficient to
  provide the C struct name only?


ChangeLog:

-- v2 --

- Revise zero page description according to the source code and move
  them to zero-page.txt.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 boot.txt      |   70 +++++++++++++++++++++++++++++++
 zero-page.txt |  127 ++++++++++++----------------------------------------------
 2 files changed, 97 insertions(+), 100 deletions(-)

Index: linux-2.6.23-rc6/Documentation/i386/boot.txt
===================================================================
--- linux-2.6.23-rc6.orig/Documentation/i386/boot.txt	2007-09-11 10:50:29.000000000 +0800
+++ linux-2.6.23-rc6/Documentation/i386/boot.txt	2007-09-19 10:00:18.000000000 +0800
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2007-05-23
+			Last update 2007-09-18
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -42,6 +42,9 @@
 Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
 		the boot command line
 
+Protocol 2.07:	(kernel 2.6.23) Added a field of 64-bit physical
+		pointer to single linked list of struct	setup_data.
+		Added 32-bit boot protocol.
 
 **** MEMORY LAYOUT
 
@@ -168,6 +171,9 @@
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/3	N/A	pad2		Unused
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
+023c/4	N/A	pad3		Unused
+0240/8	2.07+	setup_data	64-bit physical pointer to linked list
+				of struct setup_data
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -480,6 +486,36 @@
   cmdline_size characters. With protocol version 2.05 and earlier, the
   maximum size was 255.
 
+Field name:	setup_data
+Type:		write (obligatory)
+Offset/size:	0x240/8
+Protocol:	2.07+
+
+  The 64-bit physical pointer to NULL terminated single linked list of
+  struct setup_data. This is used to define a more extensible boot
+  parameters passing mechanism. The definition of struct setup_data is
+  as follow:
+
+  struct setup_data {
+	  u64 next;
+	  u32 type;
+	  u32 len;
+	  u8  data[0];
+  } __attribute__((packed));
+
+  Where, the next is a 64-bit physical pointer to the next node of
+  linked list, the next field of the last node is 0; the type is used
+  to identify the contents of data; the len is the length of data
+  field; the data holds the real payload.
+
+  With this field, to add a new boot parameter written by bootloader,
+  it is not needed to add a new field to real mode header, just add a
+  new setup_data type is sufficient. But to add a new boot parameter
+  read by bootloader, it is still needed to add a new field.
+
+  TODO: Where is the safe place to place the linked list of struct
+  	setup_data?
+
 
 **** THE KERNEL COMMAND LINE
 
@@ -753,3 +789,35 @@
 	After completing your hook, you should jump to the address
 	that was in this field before your boot loader overwrote it
 	(relocated, if appropriate.)
+
+
+**** SETUP DATA TYPES
+
+
+**** 32-bit BOOT PROTOCOL
+
+For machine with some new BIOS other than legacy BIOS, such as EFI,
+LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
+based on legacy BIOS can not be used, so a 32-bit boot protocol need
+to be defined.
+
+In 32-bit boot protocol, the first step in loading a Linux kernel
+should still be to load the real-mode code and then examine the kernel
+header at offset 0x01f1. But, it is not necessary to load all
+real-mode code, just first 4K bytes traditionally known as "zero page"
+is needed.
+
+In addition to read/modify/write kernel header of the zero page as
+that of 16-bit boot protocol, the boot loader should also fill the
+additional fields of the zero page as that described in zero-page.txt.
+
+After loading and setuping the zero page, the boot loader can load the
+32/64-bit kernel in the same way as that of 16-bit boot protocol.
+
+In 32-bit boot protocol, the kernel is started by jumping to the
+32-bit kernel entry point, which is the start address of loaded
+32/64-bit kernel.
+
+At entry, the CPU must be in 32-bit protected mode with paging
+disabled; the CS and DS must be 4G flat segments; %esi holds the base
+address of the "zero page"; %esp, %ebp, %edi should be zero.
Index: linux-2.6.23-rc6/Documentation/i386/zero-page.txt
===================================================================
--- linux-2.6.23-rc6.orig/Documentation/i386/zero-page.txt	2007-09-11 10:50:29.000000000 +0800
+++ linux-2.6.23-rc6/Documentation/i386/zero-page.txt	2007-09-19 10:00:18.000000000 +0800
@@ -1,99 +1,28 @@
----------------------------------------------------------------------------
-!!!!!!!!!!!!!!!WARNING!!!!!!!!
-The zero page is a kernel internal data structure, not a stable ABI.  It might change
-without warning and the kernel has no way to detect old version of it.
-If you're writing some external code like a boot loader you should only use
-the stable versioned real mode boot protocol described in boot.txt. Otherwise the kernel
-might break you at any time.
-!!!!!!!!!!!!!WARNING!!!!!!!!!!!
-----------------------------------------------------------------------------
-
-Summary of boot_params layout (kernel point of view)
-     ( collected by Hans Lermen and Martin Mares )
- 
-The contents of boot_params are used to pass parameters from the
-16-bit realmode code of the kernel to the 32-bit part. References/settings
-to it mainly are in:
-
-  arch/i386/boot/setup.S
-  arch/i386/boot/video.S
-  arch/i386/kernel/head.S
-  arch/i386/kernel/setup.c
- 
-
-Offset	Type		Description
-------  ----		-----------
-    0	32 bytes	struct screen_info, SCREEN_INFO
-			ATTENTION, overlaps the following !!!
-    2	unsigned short	EXT_MEM_K, extended memory size in Kb (from int 0x15)
- 0x20	unsigned short	CL_MAGIC, commandline magic number (=0xA33F)
- 0x22	unsigned short	CL_OFFSET, commandline offset
-			Address of commandline is calculated:
-			  0x90000 + contents of CL_OFFSET
-			(only taken, when CL_MAGIC = 0xA33F)
- 0x40	20 bytes	struct apm_bios_info, APM_BIOS_INFO
- 0x60	16 bytes	Intel SpeedStep (IST) BIOS support information
- 0x80	16 bytes	hd0-disk-parameter from intvector 0x41
- 0x90	16 bytes	hd1-disk-parameter from intvector 0x46
-
- 0xa0	16 bytes	System description table truncated to 16 bytes.
-			( struct sys_desc_table_struct )
- 0xb0 - 0x13f		Free. Add more parameters here if you really need them.
- 0x140- 0x1be		EDID_INFO Video mode setup
-
-0x1c4	unsigned long	EFI system table pointer
-0x1c8	unsigned long	EFI memory descriptor size
-0x1cc	unsigned long	EFI memory descriptor version
-0x1d0	unsigned long	EFI memory descriptor map pointer
-0x1d4	unsigned long	EFI memory descriptor map size
-0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
-0x1e4	unsigned long	Scratch field for the kernel setup code
-0x1e8	char		number of entries in E820MAP (below)
-0x1e9	unsigned char	number of entries in EDDBUF (below)
-0x1ea	unsigned char	number of entries in EDD_MBR_SIG_BUFFER (below)
-0x1f1	char		size of setup.S, number of sectors
-0x1f2	unsigned short	MOUNT_ROOT_RDONLY (if !=0)
-0x1f4	unsigned short	size of compressed kernel-part in the
-			(b)zImage-file (in 16 byte units, rounded up)
-0x1f6	unsigned short	swap_dev (unused AFAIK)
-0x1f8	unsigned short	RAMDISK_FLAGS
-0x1fa	unsigned short	VGA-Mode (old one)
-0x1fc	unsigned short	ORIG_ROOT_DEV (high=Major, low=minor)
-0x1ff	char		AUX_DEVICE_INFO
-
-0x200	short jump to start of setup code aka "reserved" field.
-0x202	4 bytes		Signature for SETUP-header, ="HdrS"
-0x206	unsigned short	Version number of header format
-			Current version is 0x0201...
-0x208	8 bytes		(used by setup.S for communication with boot loaders,
-			 look there)
-0x210	char		LOADER_TYPE, = 0, old one
-			else it is set by the loader:
-			0xTV: T=0 for LILO
-				1 for Loadlin
-				2 for bootsect-loader
-				3 for SYSLINUX
-				4 for ETHERBOOT
-				5 for ELILO
-				7 for GRuB
-				8 for U-BOOT
-				9 for Xen
-				V = version
-0x211	char		loadflags:
-			bit0 = 1: kernel is loaded high (bzImage)
-			bit7 = 1: Heap and pointer (see below) set by boot
-				  loader.
-0x212	unsigned short	(setup.S)
-0x214	unsigned long	KERNEL_START, where the loader started the kernel
-0x218	unsigned long	INITRD_START, address of loaded ramdisk image
-0x21c	unsigned long	INITRD_SIZE, size in bytes of ramdisk image
-0x220	4 bytes		(setup.S)
-0x224	unsigned short	setup.S heap end pointer
-0x226   unsigned short	zero_pad
-0x228   unsigned long	cmd_line_ptr
-0x22c   unsigned long	ramdisk_max
-0x230   16 bytes 	trampoline
-0x290 - 0x2cf		EDD_MBR_SIG_BUFFER (edd.S)
-0x2d0 - 0xd00		E820MAP
-0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
-0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
+The additional fields in zero page as a part of 32-bit boot protocol
+of kernel. These should be filled by bootloader or 16-bit real-mode
+code of the kernel. References/settings to it mainly are in:
+
+  include/asm-i386/bootparam.h
+
+
+Offset	Proto	Name		Meaning
+/Size
+
+000/040	2.07+	screen_info	Text mode or frame buffer information
+				(struct screen_info)
+040/014	2.07+	apm_bios_info	APM BIOS information (struct apm_bios_info)
+060/010	2.07+	ist_info	Intel SpeedStep (IST) BIOS support information
+				(struct ist_info)
+0A0/010	2.07+	sys_desc_table	System description table (struct sys_desc_table)
+140/080	2.07+	edid_info	Video mode setup (struct edid_info)
+1C0/020	2.07+	efi_info	EFI 32 information (struct efi_info)
+1E0/004	2.07+	alk_mem_k	Alternative mem check, in KB
+1E4/004	2.07+	scratch		Scratch field for the kernel setup code
+1E8/001	2.07+	e820_entries	Number of entries in e820_map (below)
+1E9/001	2.07+	eddbuf_entries	Number of entries in eddbuf (below)
+1EA/001	2.07+	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
+				(below)
+290/040	2.07+	edd_mbr_sig_buffer EDD MBR signatures
+2D0/A00	2.07+	e820_map	E820 memory map table
+				(array of struct e820entry)
+D00/1EC	2.07+	eddbuf		EDD data (array of struct edd_info)
