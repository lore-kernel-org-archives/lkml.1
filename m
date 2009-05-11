Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbZEKSCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbZEKSCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZEKSCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:02:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZEKSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:02:20 -0400
Message-ID: <4A0866E9.90505@zytor.com>
Date: Mon, 11 May 2009 10:56:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "hbabu@us.ibm.com" <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "Huang\, Ying" <ying.huang@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "sam@ravnborg.org" <sam@ravnborg.org>
Subject: Re: RFC: x86: relocatable kernel changes (revised spec v2)
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>	<m14ovwz8ua.fsf@fess.ebiederm.org> <4A03C3BB.3070401@intel.com>	<m1tz3wgk3n.fsf@fess.ebiederm.org> <4A047E53.8040003@intel.com>	<4A07B534.8080606@zytor.com> <m1vdo7hn2i.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdo7hn2i.fsf@fess.ebiederm.org>
Content-Type: multipart/mixed;
 boundary="------------050407050100090104070304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050407050100090104070304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Does this look better?

	-hpa

--------------050407050100090104070304
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index e020366..0da827c 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -50,6 +50,11 @@ Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
 Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
 		pointer to single linked list of struct	setup_data.
 
+Protocol 2.10:	(Kernel 2.6.31?) A protocol for relaxed alignment
+	 	beyond the kernel_alignment added, new init_size and
+	 	pref_address fields.
+	 	
+
 **** MEMORY LAYOUT
 
 The traditional memory map for the kernel loader, used for Image or
@@ -173,7 +178,7 @@ Offset	Proto	Name		Meaning
 022C/4	2.03+	ramdisk_max	Highest legal initrd address
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
-0235/1	N/A	pad2		Unused
+0235/1	2.10+	min_alignment	Minimum alignment, as a power of 2
 0236/2	N/A	pad3		Unused
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
@@ -182,6 +187,8 @@ Offset	Proto	Name		Meaning
 024C/4	2.08+	payload_length	Length of kernel payload
 0250/8	2.09+	setup_data	64-bit physical pointer to linked list
 				of struct setup_data
+0258/8	2.10+	pref_address	Preferred loading address
+0260/4	2.10+	init_size	Linear memory required during initialization
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -482,11 +489,19 @@ Protocol:	2.03+
   0x37FFFFFF, you can start your ramdisk at 0x37FE0000.)
 
 Field name:	kernel_alignment
-Type:		read (reloc)
+Type:		read/modify (reloc)
 Offset/size:	0x230/4
-Protocol:	2.05+
+Protocol:	2.05+ (read), 2.10+ (modify)
 
-  Alignment unit required by the kernel (if relocatable_kernel is true.)
+  Alignment unit required by the kernel (if relocatable_kernel is
+  true.)  A relocatable kernel that is loaded at an alignment
+  incompatible with the value in this field will be realigned during
+  kernel initialization.
+
+  Starting with protocol version 2.10, this reflects the kernel
+  alignment preferred for optimal performance; it is possible for the
+  loader to modify this field to permit a lesser alignment.  See the
+  min_alignment and pref_address field below.
 
 Field name:	relocatable_kernel
 Type:		read (reloc)
@@ -498,6 +513,22 @@ Protocol:	2.05+
   After loading, the boot loader must set the code32_start field to
   point to the loaded code, or to a boot loader hook.
 
+Field name:	min_alignment
+Type:		read (reloc)
+Offset/size:	0x235/1
+Protocol:	2.10+
+
+  This field, if nonzero, indicates as a power of 2 the minimum
+  alignment required, as opposed to preferred, by the kernel to boot.
+  If a boot loader makes use of this field, it should update the
+  kernel_alignment field with the alignment unit desired; typically:
+
+	kernel_alignment = 1 << min_alignment
+
+  There may be a considerable performance cost with an excessively
+  misaligned kernel.  Therefore, a loader should typically try each
+  power-of-two alignment from kernel_alignment down to this alignment.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
@@ -582,6 +613,36 @@ Protocol:	2.09+
   sure to consider the case where the linked list already contains
   entries.
 
+Field name:	pref_address
+Type:		read (reloc)
+Offset/size:	0x258/8
+Protocol:	2.10+
+
+  This field, if nonzero, represents a preferred load address for the
+  kernel.  A relocating bootloader should attempt to load at this
+  address if possible.
+
+  A non-relocatable kernel will unconditionally move itself and to run
+  at this address.
+
+Field name:	init_size
+Type:		read
+Offset/size:	0x25c/4
+
+  This field indicates the amount of linear contiguous memory starting
+  at the kernel runtime start address that the kernel needs before it
+  is capable of examining its memory map.  This is not the same thing
+  as the total amount of memory the kernel needs to boot, but it can
+  be used by a relocating boot loader to help select a safe load
+  address for the kernel.
+
+  The kernel runtime start address is determined by the following algorithm:
+
+  if (relocatable_kernel)
+  	runtime_start = align_up(load_address, kernel_alignment)
+  else
+  	runtime_start = pref_address
+
 
 **** THE IMAGE CHECKSUM
 

--------------050407050100090104070304--
