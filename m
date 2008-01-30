Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbYA3LJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbYA3LJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYA3LJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:09:43 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:5301 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYA3LJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:09:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=IdyBBga/OqkUSCmGzVgvy4df4MxqkwMrreOudIdgVHvDOchwGGoB/DuQuHJ1RTMscm1d3PBWv8VB+lRFCwaQZ+gxtofrwb4i29CuLzBxSFqygh+3wPBdefJCztLffJ9uysOZOu53S8Kr9LASUqgYs2f4BqLVy4Rbsaue8aXcoy0=
Message-ID: <15577be70801300309k4eb84047peb4bffd4b41cbaa7@mail.gmail.com>
Date: Wed, 30 Jan 2008 12:09:40 +0100
From: "Abel Bernabeu" <abelbg@m2grp.com>
Reply-To: abelbg@m2grp.com
To: linux-kernel@vger.kernel.org
Subject: Elf loader crash while zero-filling .bss
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e390919dc0e9076f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----[ The context

I am relatively new into kernel hacking and I am trying to get Linux
running on a ARM based SBC.

I already did my work adding support for the board in my working copy
of Linux 2.6.22.10. The kernel already boots and runs small assembler
programs I've written for testing (with the boot parameter
init=myprogram).

Now I am trying to execute some bigger C applications: in instance
BusyBox. I've chosen the buildroot package in order to produce a small
"distro".

Then I've tried to boot the system using init=/bin/sh but I am getting
a crash while loading this non-toy binary.

And believe me, this is not a problem of EABI/OABI compatibility (I
hope I could cope with that without messing here), seems more serious.

----[ The details

>From the perspective of the user nothing is shown at the console
(literally nothing)... but using the debugger I can see a "data abort"
exception happening at binfmt_elf.c (load_elf_binary).

The offending code is the following:

  	930		/* Calling set_brk effectively mmaps the pages that we need
 	931		 * for the bss and break sections.  We must do this before
  	932		 * mapping in the interpreter, to make sure it doesn't wind
 	933		 * up getting placed where the bss needs to go.
  	934		 */
-	935		retval = set_brk(elf_bss, elf_brk);
 -	936		if (retval) {
-	937			send_sig(SIGKILL, current, 0);
  	938			goto out_free_dentry;
 	939		}
 -	940		if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
-	941			send_sig(SIGSEGV, current, 0);
  	942			retval = -EFAULT; /* Nobody gets to see this, but.. */
 	943			goto out_free_dentry;
  	944		}


Stopping the debugger at the line 935 I can see the values passed to set_brk:
 set_brk (0x000a4ec8, 0x000a4ec8).

This allocs exactly one new physical page for the virtual address 0xa4000.

Then, stopping the debugger at line 940 (just before the crash) I see
that elf_bss is 0xa3801 and PAGE_SIZE is 4096, so padzero is going to
to zero-fill the bytes from 0xa3801 to 0xa3fff (2047 bytes).

Tracing instruction by instruction into padzero and it subsequent call
to clear_user leads to a data exception when trying to write 0 the
address 0xa3801 (the first byte!).

I know I should provide more details in order to get some help.

 The exact Linux version, gcc version and compiler are the following:

 Linux version 2.6.22.10  (abel@debian) (gcc version 4.2.1) #13 Fri
Nov 30 09:49:41 CET 2007
   CPU: XScale-PXA255 [69052d06] revision 6 (ARMv5TE)

The sections listing of the offending elf binary is relevant too (I think):

[Nr] Name                 Type         Addr     Off    Size   ES Flags Lk Inf Al
 [ 0]                      NULL         00000000 000000 000000  0
  0   0  0
[ 1] .interp              PROGBITS     000080d4 0000d4 000014  0 A      0   0  1
 [ 2] .hash                HASH         000080e8 0000e8 0009e8  4 A
  3   0  4
[ 3] .dynsym              DYNSYM       00008ad0 000ad0 001710 16 A      4   1  4
 [ 4] .dynstr              STRTAB       0000a1e0 0021e0 000b69  0 A
  0   0  1
[ 5] .rel.dyn             REL          0000ad4c 002d4c 000070  8 A      3   0  4
 [ 6] .rel.plt             REL          0000adbc 002dbc 000ac0  8 A
  3   8  4
[ 7] .init                PROGBITS     0000b87c 00387c 000018  0 AX     0   0  4
 [ 8] .plt                 PROGBITS     0000b894 003894 001034  4 AX
  0   0  4
[ 9] .text                PROGBITS     0000c8c8 0048c8 06f12c  0 AX     0   0  4
 [10] .fini                PROGBITS     0007b9f4 0739f4 000014  0 AX
  0   0  4
[11] .rodata              PROGBITS     0007ba08 073a08 01f40e  0 A      0   0  8
 [12] .eh_frame            PROGBITS     0009ae18 092e18 000004  0 A
  0   0  4
[13] .ctors               PROGBITS     000a3000 093000 000008  0 WA     0   0  4
 [14] .dtors               PROGBITS     000a3008 093008 000008  0 WA
  0   0  4
[15] .jcr                 PROGBITS     000a3010 093010 000004  0 WA     0   0  4
 [16] .dynamic             DYNAMIC      000a3014 093014 0000c0  8 WA
  4   0  4
[17] .got                 PROGBITS     000a30d4 0930d4 000574  4 WA     0   0  4
 [18] .data                PROGBITS     000a3648 093648 0001b9  0 WA
  0   0  4
[19] .bss                 NOBITS       000a3808 093801 0016c0  0 WA     0   0  8
 [20] .ARM.attributes      SHT_LOPROC+3 00000000 093801 000010  0
  0   0  1
[21] .shstrtab            STRTAB       00000000 093811 00009b  0        0   0  1

----[ Some questions

I have the following questions:

1) I don't think the assumption in the code comment is valid in my case:

 	930		/* Calling set_brk effectively mmaps the pages that we need
 	931		 * for the bss and break sections.  We must do this before

My .bss section spans from 0xa3801 0xa4ec8 but the page set_brk allocs
goes from 0xa4000 to 0xa4fff.

Then padzero writes to an unallocated area.

Is the assumption in the comment wrong?

2) May this crash have some relation with this (already solved) one?

http://marc.info/?l=linux-kernel&m=109865760703851&w=2

3) I haven't taken a look into the code generated by gcc but someone
in ARM Linux list showed a piece of badly generated code in another
context. Should I try do downgrade the compiler used for my kernel?

Which is the official gcc version for the kernel?

Yours, Abel.
