Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbXHDQhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbXHDQhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760886AbXHDQhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:37:38 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60293 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760233AbXHDQhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:37:37 -0400
Message-ID: <46B4A7E4.4030907@vmware.com>
Date: Sat, 04 Aug 2007 09:23:00 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Gabriel Barazer <gabriel@oxeva.fr>, Andi Kleen <ak@suse.de>,
       Jim Mattson <jmattson@vmware.com>
CC: linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Avi Kivity <avi@qumranet.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: 2.6.22 x86_64 : kernel initial decompression hangs on vmware
References: <46A7E606.4030001@oxeva.fr>
In-Reply-To: <46A7E606.4030001@oxeva.fr>
Content-Type: multipart/mixed;
 boundary="------------020807090006030701070301"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020807090006030701070301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Gabriel Barazer wrote:
> Hi,
>
> After upgrading kernel to 2.6.22 on a Vmware workstation guest version 
> 5.5 and 6 , the kernel decompression stage ("Decompressing Linux...") 
> is hanging for a very long time (~5 minutes) before finally  
> succeeding (displaying "done.\nBooting the kernel.\n"). During this 
> time, the VM process is eating all the CPU time during the 
> decompression, like an infinite loop.
> Between these 2 strings is the gunzip() function at 
> boot/compressed/misc.c which does the real job, and the problem seemed 
> to appear since commit 1ab60e0f72f71ec54831e525a3e1154f1c092408. 
> (2.6.22-rc1 hangs, 2.6.21.6 works). The problem occurs with or without 
> CONFIG_RELOCATABLE enabled.
>
> What are the possible solutions to confirm where the problem is coming 
> from ?

Since I was just involved in the boot decompressor for another bug, I 
took a look at this.  2.6.22 switches it to be 64-bit code.  VT is very 
picky about what state it can run in.  Not using VT on Intel 64-bit 
hardware cripples performance, running at far below normal speed, and 
taking minutes to decompress the kernel, which is nearly instantaneous 
otherwise.

To get back into VT in this case, not only do we need to load FS and GS, 
we also need to setup an initial LDT and task.  Can you try the attached 
patch and see that it does the right thing?

I've also cc'd the KVM developers, as the same problem will affect them, 
and hopefully the same patch will fix it.

Thanks, Zach

Zach

--------------020807090006030701070301
Content-Type: text/x-patch;
 name="boot-decompress-vt-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot-decompress-vt-fix.patch"

VT is very picky about when it can enter execution.
Get all segments setup and get LDT and TR into valid state to allow
VT execution under VMware and KVM (untested).

This makes the boot decompression run under VT, which makes it several
orders of magnitude faster on 64-bit Intel hardware.

Before, I was seeing times up to a minute or more to decompress a 1.3MB kernel
on a very fast box.

Signed-off-by: Zachary Amsden <zach@vmware.com>


===================================================================
--- a/arch/x86_64/boot/compressed/head.S
+++ a/arch/x86_64/boot/compressed/head.S
@@ -195,6 +195,11 @@
 	movl	%eax, %ds
 	movl	%eax, %es
 	movl	%eax, %ss
+	movl	%eax, %fs
+	movl	%eax, %gs
+	lldt	%ax
+	movl    $0x20, %eax
+	ltr	%ax
 
 	/* Compute the decompressed kernel start address.  It is where
 	 * we were loaded at aligned to a 2M boundary. %rbp contains the
@@ -295,6 +300,8 @@
 	.quad	0x0000000000000000	/* NULL descriptor */
 	.quad	0x00af9a000000ffff	/* __KERNEL_CS */
 	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
+	.quad	0x0080890000000000	/* TS descriptor */
+	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 	.bss
 /* Stack for uncompression */

--------------020807090006030701070301--
