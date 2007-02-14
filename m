Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbXBNSx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbXBNSx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbXBNSx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:53:58 -0500
Received: from gw.goop.org ([64.81.55.164]:46798 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453AbXBNSx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:53:58 -0500
Message-ID: <45D35ABE.1050504@goop.org>
Date: Wed, 14 Feb 2007 10:53:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ian Campbell <Ian.Campbell@XenSource.com>
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being
 booted by Xen
References: <20070213221729.772002682@goop.org> <20070213221830.707197267@goop.org> <20070213235424.GA1908@muc.de>
In-Reply-To: <20070213235424.GA1908@muc.de>
Content-Type: multipart/mixed;
 boundary="------------060509020601070601090003"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060509020601070601090003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
>> +#ifdef CONFIG_XEN
>> +#include "../xen/xen-head.S"
>> +#endif
>>     
>
> Can this really not be linked separately? 

I did a patch to do this (attached).  In principle it should be pretty
simple, but I think I'm running into toolchain issues.  If I link
xen-head.S separately (with appropriate headers added), it compiles OK
and contains the right notes, but they don't appear in the final vmlinux
properly.  The note segment and section are there, but no tools will
parse them as notes:

: ezr:pts/1; readelf -n vmlinux 
: ezr:pts/1; ../../unstable/tools/xcutils/readnotes vmlinux 
: ezr:pts/1; readelf -l vmlinux 

Elf file type is EXEC (Executable file)
Entry point 0x2e1f70
There are 3 program headers, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0xc0100000 0x00100000 0x2a8920 0x2a8920 R E 0x1000
  LOAD           0x2aa000 0xc03a9000 0x003a9000 0x5f085 0xaf000 RWE 0x1000
  NOTE           0x26d2910 0x00239010 0x00239010 0x000e8 0x00000 R   0x4

 Section to Segment mapping:
  Segment Sections...
   00     .text .text.head __ex_table .rodata .pci_fixup __ksymtab __ksymtab_gpl __kcrctab __kcrctab_gpl __ksymtab_strings __param __bug_table 
   01     .data .paravirtprobe .data_nosave .data.page_aligned .data.cacheline_aligned .data.read_mostly .data.init_task .init.text .init.data .init.setup .initcall.init .con_initcall.init .altinstructions .altinstr_replacement .parainstructions .exit.text .init.ramfs .bss 
   02     .notes 
: ezr:pts/1; objdump -j .notes -s vmlinux 

vmlinux:     file format elf32-i386

Contents of section .notes:
 239010 04000000 06000000 06000000 58656e00  ............Xen.
 239020 6c696e75 78000000 04000000 04000000  linux...........
 239030 07000000 58656e00 322e3600 04000000  ....Xen.2.6.....
 239040 08000000 05000000 58656e00 78656e2d  ........Xen.xen-
 239050 332e3000 04000000 04000000 03000000  3.0.............
 239060 58656e00 000000c0 04000000 04000000  Xen.............
 239070 01000000 58656e00 c80710c0 04000000  ....Xen.........
 239080 04000000 02000000 58656e00 00b040c0  ........Xen...@.
 239090 04000000 2a000000 0a000000 58656e00  ....*.......Xen.
 2390a0 21777269 7461626c 655f7061 67655f74  !writable_page_t
 2390b0 61626c65 737c7061 655f7067 6469725f  ables|pae_pgdir_
 2390c0 61626f76 655f3467 62000000 04000000  above_4gb.......
 2390d0 04000000 09000000 58656e00 79657300  ........Xen.yes.
 2390e0 04000000 08000000 08000000 58656e00  ............Xen.
 2390f0 67656e65 72696300                    generic.        


I can't see what the problem is here, but it looks like a toolchain
problem to me (I'm using binutils-2.17.50.0.6-2.fc6).

Any clues?

Thanks,
    J

--------------060509020601070601090003
Content-Type: text/x-patch;
 name="xen-head.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xen-head.patch"

diff -r 4721c1690d24 arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Wed Feb 14 03:16:30 2007 -0800
+++ b/arch/i386/kernel/head.S	Wed Feb 14 04:01:58 2007 -0800
@@ -504,7 +504,7 @@ ignore_int:
 
 .section .text
 #ifdef CONFIG_PARAVIRT
-startup_paravirt:
+ENTRY(startup_paravirt)
 	cld
  	movl $(init_thread_union+THREAD_SIZE),%esp
 
@@ -535,10 +535,6 @@ unhandled_paravirt:
 	ud2
 #endif
 
-#ifdef CONFIG_XEN
-#include "../xen/xen-head.S"
-#endif
-	
 /*
  * Real beginning of normal "text" segment
  */
diff -r 4721c1690d24 arch/i386/xen/Makefile
--- a/arch/i386/xen/Makefile	Wed Feb 14 03:16:30 2007 -0800
+++ b/arch/i386/xen/Makefile	Wed Feb 14 04:01:58 2007 -0800
@@ -1,2 +1,2 @@ obj-y		:= enlighten.o setup.o events.o t
-obj-y		:= enlighten.o setup.o events.o time.o \
+obj-y		:= xen-head.o enlighten.o setup.o events.o time.o \
 			features.o mmu.o multicalls.o
diff -r 4721c1690d24 arch/i386/xen/xen-head.S
--- a/arch/i386/xen/xen-head.S	Wed Feb 14 03:16:30 2007 -0800
+++ b/arch/i386/xen/xen-head.S	Wed Feb 14 04:01:58 2007 -0800
@@ -1,8 +1,11 @@
 /* Xen-specific pieces of head.S, intended to be included in the right
 	place in head.S */
 
+.text
 #include <linux/elfnote.h>
+#include <linux/linkage.h>
 #include <asm/boot.h>
+#include <asm/page.h>
 #include <xen/interface/elfnote.h>
 
 ENTRY(startup_xen)

--------------060509020601070601090003--
