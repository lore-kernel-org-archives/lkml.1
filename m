Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXBLSup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXBLSup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965302AbXBLSup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:50:45 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:4882 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965301AbXBLSuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:50:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 12 Feb 2007 18:50:42.0023 (UTC) FILETIME=[B208AF70:01C74ED6]
Content-class: urn:content-classes:message
Subject: Re: somebody dropped a (warning) bomb
Date: Mon, 12 Feb 2007 13:50:41 -0500
Message-ID: <Pine.LNX.4.61.0702121348180.23158@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0702092247430.31955@yvahk01.tjqt.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: somebody dropped a (warning) bomb
Thread-index: AcdO1rISmOFRSKbuRGaa0gFTt+OcCw==
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702090755530.7642@chaos.analogic.com> <Pine.LNX.4.61.0702091842450.31955@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702091509360.8711@chaos.analogic.com> <Pine.LNX.4.61.0702092247430.31955@yvahk01.tjqt.qr>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Rientjes" <rientjes@google.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 9 Feb 2007, Jan Engelhardt wrote:

>
> On Feb 9 2007 15:29, linux-os (Dick Johnson) wrote:
>>>
>>> I was referring to "absolute memory", not the offset magic that assembler
>>> allows. After all, (reg+relativeOffset) will yield an absolute address.
>>> What I was out at: for machines that have more than 2 GB of memory, you
>>> don't call the address that is given by 0x80000000U actually "byte
>>> -2147483648", but "byte 2147483648".
>>
>> Don't make any large bets on that!
>>
>> char foo()
>> {
>>    volatile char *p = (char *)0x80000000;
>>    return *p;
>> }
>> Optimized....
>> 	.file	"zzz.c"
>> 	.text
>> 	.p2align 2,,3
>> .globl foo
>> 	.type	foo, @function
>> foo:
>> 	pushl	%ebp
>> 	movb	-2147483648, %al
>> 	movl	%esp, %ebp
>> 	movsbl	%al,%eax
>> 	leave
>> 	ret
>> 	.size	foo, .-foo
>> 	.section	.note.GNU-stack,"",@progbits
>> 	.ident	"GCC: (GNU) 3.3.3 20040412 (Red Hat Linux 3.3.3-7)"
>
> 00000000 <foo>:
>   0:   55                      push   %ebp
>   1:   0f b6 05 00 00 00 80    movzbl 0x80000000,%eax
>   8:   89 e5                   mov    %esp,%ebp
>   a:   5d                      pop    %ebp
>   b:   0f be c0                movsbl %al,%eax
>   e:   c3                      ret
>
> You do know that there is a bijection between the set of signed [32bit]
> integers and unsigned [32bit] integers, don't you?
> For the CPU, it's just bits. Being signed or unsigned is not important
> when just accessing memory.

I would have normally just let that comment go, but it is symptomatic
of a complete misunderstanding of how many (most) processors address
memory. This may come about because modern compilers tend to isolate
programmers from the underlying mechanisms. There isn't a 1:1
correspondence between a signed displacement and an unsigned one.
Signed displacements are mandatory with processors that provide
protection. Here is the reason: assume that you could execute code
anywhere (a flat module) and you didn't have 'C' complaining about
NULL pointers. If you were to execute code at memory location 0,
that told the processor to jump to location -1 in absolute memory, you
need to have the processor generate a bounds error trap, not to wrap
to offset 0xffffffff. The same thing is true if code is executing
at or near offset 0xffffffff. If it jumps to a location that would wrap
past 0xffffffff, one needs to generate a trap as well. Also, except for
the "FAR" jumps and FAR calls, where the segment register is part of
the operand, all programed jumps or calls are relative, i.e., based
upon the current program-counter's value. This means that the program-
counter will have a value added to, or subtracted from, its current
value to control program flow. For such addition to work either as
an addition of signed numbers or as a relative displacement, the
math must use signed (twos compliment) arithmetic.

If you look at the opcode output from the compiler, when performing
conditional jumps, you will note that the jump usually doesn't
include a 32-bit address. Instead, these are mostly short jumps, using
an 8-bit signed displacement (-128 to +127 bytes). Other conditional
jumps use 32-bit signed displacements.

The exact same addressing mechanism exists for memory read and write
accesses. They are all signed displacements.

> It will, when a comparison is involved, but
> that was not the point here. void* comparisons are unsigned. Period.
> Because a compiler doing signed comparisons will "map" the memory [from
> 2 GB to 4 GB] as part of the signed comparison before the memory [from 0
> GB to 2 GB], which collides with - let's call it - "the world view".
>
> Jan
> -- 
> ft: http://freshmeat.net/p/chaostables/
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
