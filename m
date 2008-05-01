Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbYEAWiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbYEAWiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYEAWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:37:51 -0400
Received: from simmts6-qfe0.srvr.bell.ca ([206.47.199.164]:47793 "EHLO
	simmts6-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760978AbYEAWhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:37:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmoBAHjiGUicIvqD/2dsb2JhbAAIimyiCQ
Message-ID: <481A4636.8050209@gmail.com>
Date: Thu, 01 May 2008 19:37:42 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <4819078C.9080405@gmail.com>	<48190844.5080804@linux.intel.com>	<48190DBB.9020102@gmail.com> <20080430002727.00db8e63@linux.intel.com>
In-Reply-To: <20080430002727.00db8e63@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 30 Apr 2008 21:24:27 -0300
> Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
>> Arjan van de Ven wrote:
>>> Kevin Winchester wrote:
>>>> Hi Arjan,
>>>>
>>>> There doesn't seem to be an entry in MAINTAINERS for stack
>>>> protector, but your signoff was on the last stack protector
>>>> related commit I could find, so it's probably a good bet.
>>>>
>>>> I get the following in my dmesg after testing linux-next with the
>>>> stack protector turned on.  This is an x86-64 UP box if that
>>>> helps.  It appears to be related to the test for the feature (or
>>>> perhaps that is supposed to happen when the feature is tested, I'm
>>>> not sure...).  Config below.
>>>>
>>> the important question is: exactly what gcc are you using? (and if
>>> you use a distro gcc, which distro)
>>>
>>> second question would be, what does the following command give?
>>>
>>> echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0
>>> -mcmodel=kernel -fstack-protector - -o -
>>>
>>> (this is the command from scripts/gcc-x86_64-has-stack-protector.sh
>>> that the kernel uses to test at compiletime if you have stack
>>> protector support)
>> Ubuntu Hardy Heron
>>
>> kevin@alekhine:~$ gcc --version
>> gcc (GCC) 4.2.3 (Ubuntu 4.2.3-2ubuntu7)
>> Copyright (C) 2007 Free Software Foundation, Inc.
>> This is free software; see the source for copying conditions.  There
>> is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
>> PARTICULAR PURPOSE.
>>
>>
>> kevin@alekhine:~$ echo "int foo(void) { char X[200]; return 3; }" |
>> $1 -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o - bash: -S:
>> command not found
>>
>> I assume that $1 was supposed to be gcc, so how about:
> 
> eh woops yes
> 
>> kevin@alekhine:~/linux/linux-2.6/scripts$ sh
>> gcc-x86_64-has-stack-protector.sh gcc something something
>>
>> So I would assume that means I pass...
> 
> 
> I would rather really like to see the assembly output this thing spits; to see if your compiler behaves sanely.
> (Some distros tend to badly patch their gcc unfortunately and this may break the stack protector feature)

Sure, here we go:

kevin@alekhine:~$ echo "int foo(void) { char X[200]; return 3; }" | gcc -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o -
        .file   ""
        .text
.globl foo
        .type   foo, @function
foo:
.LFB2:
        pushq   %rbp
.LCFI0:
        movq    %rsp, %rbp
.LCFI1:
        subq    $208, %rsp
.LCFI2:
        movq    %gs:40, %rax
        movq    %rax, -8(%rbp)
        xorl    %eax, %eax
        movl    $3, %eax
        movq    -8(%rbp), %rdx
        xorq    %gs:40, %rdx
        je      .L3
        call    __stack_chk_fail
.L3:
        leave
        ret
.LFE2:
        .size   foo, .-foo
        .section        .eh_frame,"a",@progbits
.Lframe1:
        .long   .LECIE1-.LSCIE1
.LSCIE1:
        .long   0x0
        .byte   0x1
        .string ""
        .uleb128 0x1
        .sleb128 -8
        .byte   0x10
        .byte   0xc
        .uleb128 0x7
        .uleb128 0x8
        .byte   0x90
        .uleb128 0x1
        .align 8
.LECIE1:
.LSFDE1:
        .long   .LEFDE1-.LASFDE1
.LASFDE1:
        .long   .LASFDE1-.Lframe1
        .quad   .LFB2
        .quad   .LFE2-.LFB2
        .byte   0x4
        .long   .LCFI0-.LFB2
        .byte   0xe
        .uleb128 0x10
        .byte   0x86
        .uleb128 0x2
        .byte   0x4
        .long   .LCFI1-.LCFI0
        .byte   0xd
        .uleb128 0x6
        .align 8
.LEFDE1:
        .ident  "GCC: (GNU) 4.2.3 (Ubuntu 4.2.3-2ubuntu7)"
        .section        .note.GNU-stack,"",@progbits

Does that help?

-- 
Kevin Winchester
