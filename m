Return-Path: <linux-kernel-owner+w=401wt.eu-S2992805AbXBIU3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992805AbXBIU3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992806AbXBIU3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:29:06 -0500
Received: from spirit.analogic.com ([204.178.40.4]:3118 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992805AbXBIU3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:29:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
X-OriginalArrivalTime: 09 Feb 2007 20:29:02.0516 (UTC) FILETIME=[EFC33740:01C74C88]
Content-class: urn:content-classes:message
Subject: Re: somebody dropped a (warning) bomb
Date: Fri, 9 Feb 2007 15:29:01 -0500
Message-ID: <Pine.LNX.4.61.0702091509360.8711@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0702091842450.31955@yvahk01.tjqt.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: somebody dropped a (warning) bomb
Thread-Index: AcdMiO/MEl3sdQKRRPuu7GjcpcNS1g==
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702090755530.7642@chaos.analogic.com> <Pine.LNX.4.61.0702091842450.31955@yvahk01.tjqt.qr>
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
> On Feb 9 2007 08:16, linux-os (Dick Johnson) wrote:
>> On Fri, 9 Feb 2007, Jan Engelhardt wrote:
>>> On Feb 8 2007 16:42, Linus Torvalds wrote:
>>>>
>>> Further, giving again answer to the question whether they generate
>>> signed or unsigned comparisons: Have you ever seen a computer which
>>> addresses memory with negative numbers? Since the answer is most likely
>>> no, signed comparisons would
>>
>> Yes, most all do. Indexed memory operands are signed displacements. See
>> page 2-16, Intel486 Microprocessor Programmer's Reference Manual. This
>
> I was referring to "absolute memory", not the offset magic that assembler
> allows. After all, (reg+relativeOffset) will yield an absolute address.
> What I was out at: for machines that have more than 2 GB of memory, you
> don't call the address that is given by 0x80000000U actually "byte
> -2147483648", but "byte 2147483648".

Don't make any large bets on that!

char foo()
{
    volatile char *p = (char *)0x80000000;
    return *p;
}
Optimized....
 	.file	"zzz.c"
 	.text
 	.p2align 2,,3
.globl foo
 	.type	foo, @function
foo:
 	pushl	%ebp
 	movb	-2147483648, %al
 	movl	%esp, %ebp
 	movsbl	%al,%eax
 	leave
 	ret
 	.size	foo, .-foo
 	.section	.note.GNU-stack,"",@progbits
 	.ident	"GCC: (GNU) 3.3.3 20040412 (Red Hat Linux 3.3.3-7)"

Not optimized...

 	.file	"zzz.c"
 	.text
.globl foo
 	.type	foo, @function
foo:
 	pushl	%ebp
 	movl	%esp, %ebp
 	subl	$4, %esp
 	movl	$-2147483648, -4(%ebp)
 	movl	-4(%ebp), %eax
 	movb	(%eax), %al
 	movsbl	%al,%eax
 	leave
 	ret
 	.size	foo, .-foo
 	.section	.note.GNU-stack,"",@progbits
 	.ident	"GCC: (GNU) 3.3.3 20040412 (Red Hat Linux 3.3.3-7)"

... Still negative numbers!

>
>> gets hidden by higher-level languages such as 'C'. It is also non-obvious
>> when using the AT&T (GNU) assembly language. However, the Intel documentation
>> shows it clearly:
>> 			MOV	AL,  [EBX+0xFFFFFFFF]	; -1
>
> It can be debated what exactly this is... negative offset or "using
> overflow to get where we want".
>

No debate at all, and no overflow. The construction is even used in
'C' to optimize memory access while unrolling loops:


/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
/*
  *   This converts an array of integers to an array of double floats.
  */
void int2float(double *fp, int *ip, size_t len)
{
     while(len >= 0x10)
     {
         fp  += 0x10;
         ip  += 0x10;
         len -= 0x10;
         fp[-0x10] = (double) ip[-0x10];
         fp[-0x0f] = (double) ip[-0x0f];
         fp[-0x0e] = (double) ip[-0x0e];
         fp[-0x0d] = (double) ip[-0x0d];
         fp[-0x0c] = (double) ip[-0x0c];
         fp[-0x0b] = (double) ip[-0x0b];
         fp[-0x0a] = (double) ip[-0x0a];
         fp[-0x09] = (double) ip[-0x09];
         fp[-0x08] = (double) ip[-0x08];
         fp[-0x07] = (double) ip[-0x07];
         fp[-0x06] = (double) ip[-0x06];
         fp[-0x05] = (double) ip[-0x05];
         fp[-0x04] = (double) ip[-0x04];
         fp[-0x03] = (double) ip[-0x03];
         fp[-0x02] = (double) ip[-0x02];
         fp[-0x01] = (double) ip[-0x01];
     }
     while(len--)
        *fp++ = (double) *ip++;
}

This makes certain that each memory access uses the same type
and the address-calculation for the next memory access can be done
in parallel with the current fetch. This is one of the methods
used to save a few machine cycles. Doesn't mean much until you
end up with large arrays such as used in image processing. Then,
it may be the difference that makes or breaks the project!

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
