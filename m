Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbYBNWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbYBNWgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYBNWgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:36:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbYBNWgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:36:40 -0500
Date: Thu, 14 Feb 2008 17:35:53 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Sam Ravnborg <sam@ravnborg.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Message-ID: <20080214223553.GW24887@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080214190050.GA32258@elte.hu> <47B4AAB8.106.FEA5232@pageexec.freemail.hu> <20080214202535.GA25316@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214202535.GA25316@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 09:25:35PM +0100, Ingo Molnar wrote:
> The per function call overhead from stackprotector is already pretty 
> serious IMO, but at least that's something that GCC _could_ be doing 
> (much) smarter (why doesnt it jne forward out to __check_stk_failure, 
> instead of generating 4 instructions, one of them a default-mispredicted 
> branch instruction??), so that overhead could in theory be something 
> like 4 fall-through instructions per function, instead of the current 6.

Where do you see a mispredicted branch?
int foo (void)
{
  char buf[64];
  bar (buf);
  return 6;
}

-O2 -fstack-protector -m64:
        subq    $88, %rsp
        movq    %fs:40, %rax
        movq    %rax, 72(%rsp)
        xorl    %eax, %eax
        movq    %rsp, %rdi
        call    bar
        movq    72(%rsp), %rdx
        xorq    %fs:40, %rdx
        movl    $6, %eax
        jne     .L5
        addq    $88, %rsp
        ret
.L5:
        .p2align 4,,6
        .p2align 3
        call    __stack_chk_fail
-O2 -fstack-protector -m32:
        pushl   %ebp
        movl    %esp, %ebp
        subl    $88, %esp
        movl    %gs:20, %eax
        movl    %eax, -4(%ebp)
        xorl    %eax, %eax
        leal    -68(%ebp), %eax
        movl    %eax, (%esp)
        call    bar
        movl    $6, %eax
        movl    -4(%ebp), %edx
        xorl    %gs:20, %edx
        jne     .L5
        leave
        ret
.L5:
        .p2align 4,,7
        .p2align 3
        call    __stack_chk_fail
-O2 -fstack-protector -m64 -mcmodel=kernel:
        subq    $88, %rsp
        movq    %gs:40, %rax
        movq    %rax, 72(%rsp)
        xorl    %eax, %eax
        movq    %rsp, %rdi
        call    bar
        movq    72(%rsp), %rdx
        xorq    %gs:40, %rdx
        movl    $6, %eax
        jne     .L5
        addq    $88, %rsp
        ret
.L5:
        .p2align 4,,6
        .p2align 3
        call    __stack_chk_fail

both with gcc 4.1.x and 4.3.0.
BTW, you can use -fstack-protector --param=ssp-buffer-size=4
etc. to tweak the size of buffers to trigger stack protection, the
default is 8, but e.g. whole Fedora is compiled with 4.

	Jakub
