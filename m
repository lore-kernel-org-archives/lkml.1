Return-Path: <linux-kernel-owner+w=401wt.eu-S1423293AbXBIWJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423293AbXBIWJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423323AbXBIWJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:09:41 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:51962 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423293AbXBIWJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:09:40 -0500
Date: Fri, 9 Feb 2007 23:05:36 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.61.0702091509360.8711@chaos.analogic.com>
Message-ID: <Pine.LNX.4.61.0702092247430.31955@yvahk01.tjqt.qr>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702090755530.7642@chaos.analogic.com>
 <Pine.LNX.4.61.0702091842450.31955@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702091509360.8711@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9 2007 15:29, linux-os (Dick Johnson) wrote:
>>
>> I was referring to "absolute memory", not the offset magic that assembler
>> allows. After all, (reg+relativeOffset) will yield an absolute address.
>> What I was out at: for machines that have more than 2 GB of memory, you
>> don't call the address that is given by 0x80000000U actually "byte
>> -2147483648", but "byte 2147483648".
>
>Don't make any large bets on that!
>
>char foo()
>{
>    volatile char *p = (char *)0x80000000;
>    return *p;
>}
>Optimized....
> 	.file	"zzz.c"
> 	.text
> 	.p2align 2,,3
>.globl foo
> 	.type	foo, @function
>foo:
> 	pushl	%ebp
> 	movb	-2147483648, %al
> 	movl	%esp, %ebp
> 	movsbl	%al,%eax
> 	leave
> 	ret
> 	.size	foo, .-foo
> 	.section	.note.GNU-stack,"",@progbits
> 	.ident	"GCC: (GNU) 3.3.3 20040412 (Red Hat Linux 3.3.3-7)"

00000000 <foo>:
   0:   55                      push   %ebp
   1:   0f b6 05 00 00 00 80    movzbl 0x80000000,%eax
   8:   89 e5                   mov    %esp,%ebp
   a:   5d                      pop    %ebp
   b:   0f be c0                movsbl %al,%eax
   e:   c3                      ret    

You do know that there is a bijection between the set of signed [32bit] 
integers and unsigned [32bit] integers, don't you?
For the CPU, it's just bits. Being signed or unsigned is not important 
when just accessing memory. It will, when a comparison is involved, but 
that was not the point here. void* comparisons are unsigned. Period.
Because a compiler doing signed comparisons will "map" the memory [from 
2 GB to 4 GB] as part of the signed comparison before the memory [from 0 
GB to 2 GB], which collides with - let's call it - "the world view".


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
