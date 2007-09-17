Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXIQIYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXIQIYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXIQIYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:24:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:38684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbXIQIYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,263,1186383600"; 
   d="scan'208";a="310209812"
Subject: [RFC -mm 2/2] i386/x86_64 boot: document for 32 bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Sep 2007 16:26:22 +0800
Message-Id: <1190017582.5866.22.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 17 Sep 2007 08:24:28.0028 (UTC) FILETIME=[29D3CBC0:01C7F904]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines a 32-bit boot protocol and adds corresponding
document.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 boot.txt |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc4/Documentation/i386/boot.txt
===================================================================
--- linux-2.6.23-rc4.orig/Documentation/i386/boot.txt	2007-09-17 11:22:32.000000000 +0800
+++ linux-2.6.23-rc4/Documentation/i386/boot.txt	2007-09-17 11:34:10.000000000 +0800
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2007-05-23
+			Last update 2007-09-14
 
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
 
@@ -753,3 +789,70 @@
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
+that of 16-bit boot protocol, the boot loader should fill the
+following additional fields of the zero page too.
+
+Offset	Type		Description
+------  ----		-----------
+    0	32 bytes	struct screen_info, SCREEN_INFO
+			ATTENTION, overlaps the following !!!
+    2	unsigned short	EXT_MEM_K, extended memory size in Kb (from int 0x15)
+ 0x20	unsigned short	CL_MAGIC, commandline magic number (=0xA33F)
+ 0x22	unsigned short	CL_OFFSET, commandline offset
+			Address of commandline is calculated:
+			  0x90000 + contents of CL_OFFSET
+			(only taken, when CL_MAGIC = 0xA33F)
+ 0x40	20 bytes	struct apm_bios_info, APM_BIOS_INFO
+ 0x60	16 bytes	Intel SpeedStep (IST) BIOS support information
+ 0x80	16 bytes	hd0-disk-parameter from intvector 0x41
+ 0x90	16 bytes	hd1-disk-parameter from intvector 0x46
+
+ 0xa0	16 bytes	System description table truncated to 16 bytes.
+			( struct sys_desc_table_struct )
+ 0xb0 - 0x13f		Free. Add more parameters here if you really need them.
+ 0x140- 0x1be		EDID_INFO Video mode setup
+
+0x1c4	unsigned long	EFI system table pointer
+0x1c8	unsigned long	EFI memory descriptor size
+0x1cc	unsigned long	EFI memory descriptor version
+0x1d0	unsigned long	EFI memory descriptor map pointer
+0x1d4	unsigned long	EFI memory descriptor map size
+0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
+0x1e4	unsigned long	Scratch field for the kernel setup code
+0x1e8	char		number of entries in E820MAP (below)
+0x1e9	unsigned char	number of entries in EDDBUF (below)
+0x1ea	unsigned char	number of entries in EDD_MBR_SIG_BUFFER (below)
+0x290 - 0x2cf		EDD_MBR_SIG_BUFFER (edd.S)
+0x2d0 - 0xd00		E820MAP
+0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
+0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
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
