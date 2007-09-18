Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbXIRCzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbXIRCzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 22:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXIRCy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 22:54:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:46563 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbXIRCy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 22:54:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,266,1186383600"; 
   d="scan'208";a="281162196"
Subject: Re: [RFC -mm 2/2] i386/x86_64 boot: document for 32 bit
	boot	protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46EF2E5A.3060806@zytor.com>
References: <1190017582.5866.22.camel@caritas-dev.intel.com>
	 <46EE9D66.1030705@zytor.com>
	 <1190078003.12429.8.camel@caritas-dev.intel.com>
	 <46EF2E5A.3060806@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 10:56:46 +0800
Message-Id: <1190084206.12429.20.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 18 Sep 2007 02:54:51.0264 (UTC) FILETIME=[485ED800:01C7F99F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 18:48 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> > 
> > OK, I will check the actual structure, and change the document
> > accordingly.
> > 
> 
> The best would probably be to fix zero-page.txt (and probably rename it
> something saner.)

Does the patch appended with the mail seems better?

If it is desired, I can move the zero page description into
zero-page.txt, and refer to it in 32-bit boot protocol description.

I delete the hd0_info and hd1_info from the zero page. If it is
undesired, I will move them back.

The field in zero page is fairly complex (such as struct edd_info). Do
you think it is necessary to document every field inside the first level
field, until the primary data type? Or we just provide the C struct
name?

Best Regards,
Huang Ying

---

Index: linux-2.6.23-rc4/Documentation/i386/boot.txt
===================================================================
--- linux-2.6.23-rc4.orig/Documentation/i386/boot.txt	2007-09-18 10:40:34.000000000 +0800
+++ linux-2.6.23-rc4/Documentation/i386/boot.txt	2007-09-18 10:46:13.000000000 +0800
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
 
@@ -753,3 +789,57 @@
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
