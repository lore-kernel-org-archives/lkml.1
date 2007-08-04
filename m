Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXHDFCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXHDFCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 01:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXHDFCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 01:02:36 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38469 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbXHDFCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 01:02:35 -0400
Message-ID: <46B40504.70208@vmware.com>
Date: Fri, 03 Aug 2007 21:48:04 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Iouri Kharon <bc-info@styx.cabel.net>, syslinux@zytor.com,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: Vmware crashes if compress/misc.c scrolls?
References: <4679BBCB.2000202@zytor.com>
In-Reply-To: <4679BBCB.2000202@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I just got the following message on the syslinux mailing list:
>
>   
>> 2. On some platforms (vmware for example :), READING from the video memory
>>    in the 32bit mode is impossible (causes an exeption). Taking in to account
>>    that the scroll function in ilinux/arch/i386/boot/compressed/misc.c
>>    works using a memcpy of the video memory, when the linux bootsector is given
>>    control and the cursor is at the end of the screen (-1-2 lines) an exception is
>>    arisen and in the presence of it's handler in the bootloader the system halts.
>>    Both lilo and grub handle this situation - the cursor is always somewhere at the
>>    middle of the screen when the control is given to the linux bootsector.
>>    When using pxelinux taking in to account that the PXE bios prints out the
>>    presence of the second initramfs which causes the screen to scroll and the bug
>>    to appear :)
>>    A very simple solution - the screen is cleared before giving control to the
>>    linux bootsector (in the patch).
>>     
>
> First of all, is this actually true?  This seems like a monumental screwup.
>
> Second, assuming it is true, what should be done about it?  The notion
> that the bootloader should erase the screen is ridiculous since we spend
> a lot of effort maintaining the screen context from 16-bit code.
>
> I see a couple of options:
>
> a. Do nothing.  It's a Vmware bug, let the users bug Vmware and get an
>    updated version.
> b. Detect Vmware versions that are affected (how?) and suppress output.
> c. Don't attempt to scroll in this code, and instead wrap around the
>    screen (presumably clearing the rest of the line.)
> d. Blindly assume hardware scrolling works, instead of doing
>    copy-to-scroll.  Although I have seen craptops on which hardware
>    scrolling is broken, it's hardly critical messages we're dealing with
>    here.  A bug for a bug...
>   

Sorry it took me so long to follow up on this.

It's not a VMware bug.  Video memory operates just fine under VMware.  
This led me to put the bug on the back-burner.

Today it came back to the front, and I did some investigation.  It's 
also not a syslinux bug, although it is triggered by syslinux.

Depending on how much information is on the screen, you can trigger a 
Linux bug caused by a compiler problem.

In the boot decompressor for the kernel in the image Iouri provided, I 
find the following code present in memory before the first kernel 
instruction executes:

Here is Linux function scroll, which calls memcpy to scroll vga memory:

0x104131 :     mov    %edx,0x4(%esp,1)
0x104135 :     mov    %ecx,(%esp,1)
0x104138 :     mov    %eax,0x8(%esp,1)
0x10413c :     call   0x1040d0

Here is Linux function memcpy:

(gdb) x/40i 0x1040d0
0x1040d0 :     push   %ebp
0x1040d1 :     test   %ecx,%ecx
0x1040d3 :     mov    %esp,%ebp
0x1040d5 :     push   %edi
0x1040d6 :     mov    %eax,%edi
0x1040d8 :     push   %esi
0x1040d9 :     mov    %edx,%esi
0x1040db :     push   %ebx
0x1040dc :     mov    %ecx,%ebx
0x1040de :     je     0x1040f4
0x1040e0 :     xor    %ecx,%ecx
0x1040e2 :     xor    %edx,%edx
0x1040e4 :     movzbl (%esi,%edx,1),%eax
0x1040e8 :     add    $0x1,%ecx
0x1040eb :     cmp    %ebx,%ecx
0x1040ed :     mov    %al,(%edi,%edx,1)
0x1040f0 :     mov    %ecx,%edx
0x1040f2 :     jne    0x1040e4
0x1040f4 :     mov    %edi,%eax
0x1040f6 :     pop    %ebx
0x1040f7 :     pop    %esi
0x1040f8 :     pop    %edi
0x1040f9 :     pop    %ebp
0x1040fa :     ret


As you can plainly see, the call to memcpy (which is redefined in 
boot/compressed/misc.c) is made using stack calling convention.  
Unfortunately, the compiler generated the memcpy function itself using 
regparm(3) convention.  I am guessing this happened because a leftover 
prototype declaring memcpy as regparm got pulled in from somewhere, but 
gcc ignored it in the callsite because the function was declared static 
in the same file.

The net result of this is the parameters to memcpy get swapped, causing 
a memcpy from 0xb80a0 to destination (in register edx, 80x24 * 2) 0xa00, 
of size 0xb8000.

This corrupts all usable memory below 640k, including the GDT which is 
currently loaded.

But since the compressed kernel is running in high memory, above 1Mb, 
the kernel is fine.  The compress loader head.S then proceeds to copy 
the move routine to address 0x11000, and executes the following instruction:

        ljmp $(__KERNEL_CS), $0x1000 # and jump to the move routine

This reloads CS descriptor from the GDT, which is now garbage, and 
contains an invalid segment.  The ljmp then generates a #GP.  Since 
there is no IDT setup to handle the GDT (and even if there were, the 
destination CS would again be reloaded, causing a fault), a double fault 
is generated.  Since the double-fault also hits the same problem, the 
machine then triple faults and proceeds to reboot.

Since the SCREEN_INFO passed to the kernel in the bad case has orig_y is 
set to 22, when we print 3 newlines:

        putstr(".\nDecompressing Linux...");
        gunzip();
        putstr("done.\nBooting the kernel.\n");

We cause the VGA to scroll, and trigger the bug.

Does anyone recall compiler problems (I noticed this VM was booting a 
64-bit kernel, but the decompressor was 32-bit code, so perhaps at some 
time the 64-bit makefile or toolchain for Linux had some kind of 
compiler bug).

Zach
