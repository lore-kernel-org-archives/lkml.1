Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbZBKBYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbZBKBYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZBKBXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:23:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44608
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756271AbZBKBXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:23:54 -0500
Date: Tue, 10 Feb 2009 17:23:47 -0800 (PST)
Message-Id: <20090210.172347.189515015.davem@davemloft.net>
To: rdreier@cisco.com
Cc: swise@opengridcomputing.com, randy.dunlap@oracle.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaeiy5ahza.fsf@cisco.com>
References: <499223F8.1010204@opengridcomputing.com>
	<20090210.170740.208470781.davem@davemloft.net>
	<adaeiy5ahza.fsf@cisco.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 10 Feb 2009 17:18:49 -0800

> > > Is this required?  Strength reduction optimization should do this
> > > automatically (and the code has been there for quite a while, so
> > > obviously it isn't causing problems)
> 
> > GCC won't optimize that modulus the way you expect, try for yourself
> > and look at the assembler if you don't believe me. :-)
> 
> Are you thinking of the case when there are signed integers involved and
> so "% modulus" might produce a different result than "& (modulus - 1)"
> (because the compiler can't know that things are never negative)?
> Because in this case the compiler seems to do what I thought it would;
> the relevant part of the i386 assembly for
> 
> 		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
> 				(1UL << (12 + page_size[i])));
> 
> is
> 
>         movl    %eax, 28(%edi,%ebx)     # <variable>.length,
>         <variable>.len
>         movzbl  28(%esp,%esi), %ecx     # page_size, tmp89
>         movl    $1, %eax        #, tmp92
>         addl    $12, %ecx       #, tmp90
>         sall    %cl, %eax       # tmp90, tmp92
>         movl    (%esp), %ecx    # wr,
>         decl    %eax    # tmp93
>         movl    12(%ecx), %edx  # <variable>.sg_list, <variable>.sg_list
>         andl    (%edx,%ebx), %eax       # <variable>.addr, tmp93
> 
> ie the compiler computes the modulus, then does decl to compute
> modulus-1 and then &s with it.
> 
> Or am I misunderstanding your point?

Must be compiler and platform specific because with gcc-4.1.3 on
sparc with -O2, for the test program:

unsigned long page_size[4];

int main(int argc)
{
        unsigned long long x = argc;

        return x % (1UL << (12 + page_size[argc]));
}

I get a call to __umoddi3:

main:
        save    %sp, -112, %sp
        sethi   %hi(page_size), %g1
        sll     %i0, 2, %g3
        or      %g1, %lo(page_size), %g1
        mov     1, %o2
        ld      [%g1+%g3], %g2
        add     %g2, 12, %g2
        sll     %o2, %g2, %o2
        mov     %i0, %o1
        mov     %o2, %o3
        sra     %i0, 31, %o0
        call    __umoddi3, 0
         mov    0, %o2
        jmp     %i7+8
         restore %g0, %o1, %o0

I get the same with gcc-4.3.0 and -O2 on 32-bit x86:

main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	movl	$1, %eax
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	subl	$20, %esp
	movl	(%ecx), %edx
	movl	page_size(,%edx,4), %ecx
	movl	$0, 12(%esp)
	movl	%edx, (%esp)
	addl	$12, %ecx
	sall	%cl, %eax
	movl	%eax, 8(%esp)
	movl	%edx, %eax
	sarl	$31, %eax
	movl	%eax, 4(%esp)
	call	__umoddi3
	addl	$20, %esp
	popl	%ecx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
