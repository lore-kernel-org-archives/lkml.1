Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZEZMhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZEZMhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZEZMhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:37:34 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:48266 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZEZMhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:37:34 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Tue, 26 May 2009 07:37:30 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905251803.51478.lkml@morethan.org> <4A1B3241.3080509@zytor.com>
In-Reply-To: <4A1B3241.3080509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260737.32860.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon May 25 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > 
> > Load Effective Address does two's complement arithmetic?
> > I'll take your word for it.
> > 
> 
> LEA, and all other address calculations use 2's-complement arithmetic:
> 
> 	leal -1(%ebx),%eax
> 	leal 0xffffffff(%ebx),%eax
> 
> ... is the same instruction.
> 
> However, gcc has been known to optimize out range checks when operating
> on signed integers; it is allowed to do this by the C standard, but it
> can give surprising results if the user expected wraparound.
>

Well, it isn't a range check - - but this illustrates where my (false)
concern came from: 

Given this input file:
extern int diff_umask(int mask, int *cnt1, int *cnt2)
{ return (((mask - *cnt1) + *cnt2) & mask); }

Doing:
gcc -O2 -S -fomit-frame-pointer difftest.c

Yields (as difftest.s):
        .file   "difftest.c"
        .text
        .p2align 4,,15
.globl diff_umask
        .type   diff_umask, @function
diff_umask:
        movl    12(%esp), %eax
        movl    4(%esp), %ecx
        movl    (%eax), %edx
        leal    (%ecx,%edx), %eax
        movl    8(%esp), %edx
        subl    (%edx), %eax
        andl    %ecx, %eax
        ret
        .size   diff_umask, .-diff_umask
        .ident  "GCC: (Debian 4.3.2-1.1) 4.3.2"
        .section        .note.GNU-stack,"",@progbits

How follow that up with the commands:
gcc -O2 -c -fomit-frame-pointer difftest.s

Then examine the result with objdump:
objdump -d difftest.o

In relevant part, yields:
difftest.o:     file format elf32-i386

Disassembly of section .text:

00000000 <diff_umask>:
   0:   8b 44 24 0c             mov    0xc(%esp),%eax
   4:   8b 4c 24 04             mov    0x4(%esp),%ecx
   8:   8b 10                   mov    (%eax),%edx
   a:   8d 04 11                lea    (%ecx,%edx,1),%eax
   d:   8b 54 24 08             mov    0x8(%esp),%edx
  11:   2b 02                   sub    (%edx),%eax
  13:   21 c8                   and    %ecx,%eax
  15:   c3                      ret

= = = =

Checking the byte string 0x8d, 0x04, 0x11 against the Intel
documentation shows that the disassembly output of objdump
is incorrect - that bit string does not have an offset field.
That is the byte encoding for the gcc assembly input.

What's a person to do when the tool-chain lies?

Mike
> 	-hpa
> 


