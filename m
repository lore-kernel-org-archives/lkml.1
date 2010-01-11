Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059Ab0AKC2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0AKC2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 21:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270Ab0AKC2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 21:28:47 -0500
Received: from mailout-hades.uni-duesseldorf.de ([134.99.128.34]:64873 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751203Ab0AKC2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 21:28:45 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 11 Jan 2010 03:28:43 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: "m68k: Cleanup linker scripts using new linker script macros." and
 old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre has a new
 email address)
In-reply-to: <m2wrzpk81j.fsf@igel.home>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.1001110235490.30805@zirkon.biophys.uni-duesseldorf.de>
References: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
 <alpine.DEB.1.10.1001101100540.1326@dr-wily.mit.edu>
 <alpine.DEB.2.00.1001102020420.19754@zirkon.biophys.uni-duesseldorf.de>
 <m2wrzpk81j.fsf@igel.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

> > FWIW: when stripping the new kernel, I get this warning:
> >
> > BFD: st7CwWnM: warning: allocated section `.init_end' not in segment
> 
> This is actually your problem.  The .init_end section is kind of special
> because it only contains an ALIGN.  What do you get from running
> "readelf -l vmlinux"?

Current LD script:
schmitz@xplor:/org/kernel/linux2.6-m68k-git/linux-m68k$ readelf -l 
vmlinux-newlds

Elf file type is EXEC (Executable file)
Entry point 0x2000
There are 2 program headers, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000000 0x00000000 0x00000000 0x2d3240 0x2f0d14 RWE 0x2000
  LOAD           0x2d5000 0x002f1000 0x002f1000 0x1aed0 0x1aed0 RWE 0x2000

 Section to Segment mapping:
  Segment Sections...
   00     .text __ex_table .rodata __ksymtab __ksymtab_gpl __ksymtab_strings __param .data .bss 
   01     .init.text .init.data .m68k_fixup 

Old (working) LD script:

schmitz@xplor:/org/kernel/linux2.6-m68k-git/linux-m68k$ readelf -l 
vmlinux-oldlds

Elf file type is EXEC (Executable file)
Entry point 0x2000
There are 2 program headers, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000000 0x00000000 0x00000000 0x2d0240 0x2edd14 RWE 0x2000
  LOAD           0x2d2000 0x002ee000 0x002ee000 0x20000 0x20000 RWE 0x2000

 Section to Segment mapping:
  Segment Sections...
   00     .text __ex_table .rodata __ksymtab __ksymtab_gpl __ksymtab_strings __param .data .bss 
   01     .init.text .init.data .init.setup .initcall.init .con_initcall.init .m68k_fixup .init.ramfs .data.init_task 

Looks like the size of the BSS segment is not aligned in the broken case. 

Putting this into the script:

--- arch/m68k/kernel/vmlinux-std.lds.org	2010-01-09 11:01:05.000000000 
+1300
+++ arch/m68k/kernel/vmlinux-std.lds	2010-01-11 09:40:24.000000000 +1300
@@ -51,6 +51,10 @@
 	__init_end = .;
   }
 
+  . = . + 0x1000;
+
+  . = ALIGN(8192);
+
   _end = . ;
 
   STABS_DEBUG

does place both __init_end and _end on separate aligned boundaries but leaves
the end of the actual BSS unaligned. 

Geert's kernel has this readelf output:

schmitz@xplor:/org/m68k/aranym$ readelf -l 
vmlinux-2.6.33-rc2-atari-00203-gdd8abd9

Elf file type is EXEC (Executable file)
Entry point 0x2000
There are 2 program headers, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000000 0x00000000 0x00000000 0x2de440 0x2fb450 RWE 0x2000
  LOAD           0x2e0000 0x002fc000 0x002fc000 0x1cf4c 0x1d000 RWE 0x2000

 Section to Segment mapping:
  Segment Sections...
   00     .text __ex_table .rodata __ksymtab __ksymtab_gpl __ksymtab_strings __param .data .bss 
   01     .init.text .init.data .m68k_fixup .notes .init_end 

The end of the BSS in memory is aligned here. 

What is needed in the script to force this alignment? How do I place a null byte 
right at __init_end ?? 

Thanks,

	Michael
