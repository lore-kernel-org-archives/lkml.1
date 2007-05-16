Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbXEPPrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbXEPPrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbXEPPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:47:25 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39748 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbXEPPrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:47:23 -0400
Message-ID: <464B2762.7040508@zytor.com>
Date: Wed, 16 May 2007 08:46:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: boot failure under qemu
References: <464ABF7C.1000307@goop.org>
In-Reply-To: <464ABF7C.1000307@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> rax 000000004050ffff rbx 0000000000009000 rcx 0000000000000000 rdx 0000000000007b00
> rsi 000000000001fc05 rdi 0000000000040000 rsp 0000000000008f9a rbp 0000000000008100
> r8  0000000000000000 r9  0000000000000000 r10 0000000000000000 r11 0000000000000000
> r12 0000000000000000 r13 0000000000000000 r14 0000000000000000 r15 0000000000000000
> rip 0000000000001062 rflags 00033046
> cs 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> ds 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> es 8100 (00081000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> ss 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> fs 9900 (00099000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> gs 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)

> 
>         else
>                 while (num != 0)
>                         tmp[i++] = digits[do_div(num, base)];
>     1050:       66 89 f0                mov    %esi,%eax
>     1053:       66 31 d2                xor    %edx,%edx
>     1056:       66 f7 f5                div    %ebp
>     1059:       66 89 c6                mov    %eax,%esi
>     105c:       67 66 8b 44 24 28       addr32 mov 0x28(%esp),%eax
>     1062:       67 8a 14 10             addr32 mov (%eax,%edx,1),%dl
>     1066:       67 66 8b 44 24 2c       addr32 mov 0x2c(%esp),%eax
>     106c:       67 88 54 04 3e          addr32 mov %dl,0x3e(%esp,%eax,1)
> 
> 
> 0x1062 is in number (/home/jeremy/hg/xen/paravirt/linux/arch/i386/boot/printf.c:109).
> 104             i = 0;
> 105             if (num == 0)
> 106                     tmp[i++] = '0';
> 107             else
> 108                     while (num != 0)
> 109                             tmp[i++] = digits[do_div(num, base)];
> 110             if (i > precision)
> 111                     precision = i;
> 112             size -= precision;
> 113             if (!(type & (ZEROPAD + LEFT)))
> 
> 
> I haven't tried booting on real hardware, but this is a definite
> regression from the old setup code.
> 

Hmmm...

There are a number of highly odd things about your dump, in particular,
%es == 0x8100 at this point, which means the constraint %cs == %ds ==
%es == %ss has been violated in this code; this should only happen
locally inside an assembly routine or asm() statement.  Another bizarre
thing is that %ebp, which apparently is supposed to contain the base at
this point, is *also* set to 0x8100.

Finally, the total zincher is the flags -- VM RF IOPL=3.  In real mode.
 That's nuttier than Dick Cheney.

I have been using Qemu (as well as Bochs) to develop and test the code,
so obviously it Works For Me[TM].  Please describe the entry conditions
in more detail; in particular, what did you use to load the kernel?

Also, could you send me your .config and simulation image?

	-hpa
