Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXJYJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXJYJJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXJYJJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:09:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbXJYJI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:08:59 -0400
Message-ID: <47205D21.8080802@zytor.com>
Date: Thu, 25 Oct 2007 02:08:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joseph Parmelee <jparmele@wildbear.com>, linux-kernel@vger.kernel.org
Subject: Re: Old version of lilo fails to boot 2.6.23
References: <Pine.LNX.4.64.0710151600090.15578@bruno> <20071025014746.96e5e776.akpm@linux-foundation.org>
In-Reply-To: <20071025014746.96e5e776.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
>> Parts of the 16-bit real mode loader code are now being compiled as C code
>> with gcc in 32 bit mode passing the .code16gcc directive to the assembler to
>> correct the stack frames to 16 bit.  This kludge won't work unless all the
>> 16-bit segment registers are set to the same value.  Gcc only manipulates
>> the offset of the address and doesn't know anything about segment registers
>> or segment override prefixes.  My lilo was setting SS=0x8000, DS=0x9000, and
>> SP=0xB000 before entering the kernel loader.  This makes stack automatics
>> unreachable from the data segment without segment override prefixes.
>>
>> I was tempted to patch the kernel code, but instead decided to try
>> "upgrading" lilo to grub-0.97 and found that grub works just fine.  This
>> also has the significant advantage that we won't need those nasty as86 and
>> ld86 things any more since lilo was the last package on our systems that
>> used them.
>>
>> However, it would probably be a good idea to modify the kernel loader to
>> lock out interrupts and explicitly set up the stack in its assembly startup
>> code to insure that the stack is located correctly above the code in the
>> same segment, rather than relying on the boot loader to do the right thing. 
>> The existing setup code already insures that the other segment registers are
>> equal but omits the stack segment register.  Also, because lilo (and
>> others?) loads the data/code segment at 0X90000, the stack pointer would
>> have to be set no higher than 0XA000 to avoid potential overwrites of the
>> EBDA.  But I believe from my look at the code that the data/code sits below
>> 0X8000 in the segment, so this should be fine.
>>
>> If others think this is a good thing, I will test and submit a patch.
> 
> I think this is a good thing ;)
> 

Not quite so fast.  The entry value of SS:SP is actually part of the 
protocol (an upper memory boundary), although for 2.01+ one could argue 
it is redundant with the heap_end field in the header.

I'm rather confused which particular LILO this would possibly be, 
especially given the oddball version number.  The boot protocol was 
pretty much formalized by Werner Amsberger (sp?), the original LILO 
author, with contributions from Hans Lermen and myself.  It hasn't 
changed in this area.

If this was a LILO that someone "cleverly broke" I'd like to understand 
the nature of it, so we can work around it properly.  I see a couple of 
options:

- If protocol >= 2.01, force (e)sp to match the heap_end field of the 
setup structure.  For < 2.01, what to do?
- Pray and hope the value of SP is sane to start out with in the correct SS.
- Declare the "cleverly broken" version of LILO not so cleverly broken.

For what it's worth, the old code, for protocol < 2.02, the boot code 
would simply overwrite %ss, leaving %sp unchanged (alternative #2.)  So 
this configuration was always buggy.  There is a comment in the old code 
(setup.S, line 655) that "after this the stack should not be used", but 
we then go right into the A20 code which does a bunch of subroutine calls.

I think at this point that if protocol >= 2.01 and CAN_USE_HEAP, we 
should set %ss:%sp to that, otherwise fall back to simply setting %ss 
and hope that %sp is set to something sane.  I don't like it, but I 
don't see any better alternative.

	-hpa


	-hpa

