Return-Path: <linux-kernel-owner+w=401wt.eu-S1751178AbZA0V0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbZA0V0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZA0VZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:25:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55865 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZA0VZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:25:51 -0500
Message-ID: <497F7BBE.4070500@zytor.com>
Date: Tue, 27 Jan 2009 13:25:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Duncan Sands <baldrick@free.fr>
CC: llvmdev@cs.uiuc.edu, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?T=F6?= =?ISO-8859-1?Q?r=F6k_Edwin?= 
	<edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller
  than input
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com> <20090124172758.GA31699@elte.hu> <200901272042.57272.baldrick@free.fr>
In-Reply-To: <200901272042.57272.baldrick@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duncan Sands wrote:
> Hi,
> 
>> If yes then this doesnt look all that bad or invasive at first sight (if 
>> the put_user() workaround can be expressed in a cleaner way), but in any 
>> case it would be nice to hear an LLVM person's opinion about roughly when 
>> this is going to be solved in LLVM itself.
> 
> one thing that seems to be clear to everyone except me is... what are the
> semantics supposed to be?  [My understanding is that what is being discussed
> is when you have an asm with a register as input and output, but with integer
> types of different width for the input and output, but I saw some mention of
> struct types in this thread...].  Presumably this is something obvious, but
> it would be good to have someone spell it out in small words that even someone
> like me can understand :)
> 

I don't know about struct types, but the situation I'm talking about is 
assembly statements of the form:

asm("foo" : "=r" (bar) : "0" (baz));

Here, "bar" and "baz" are constrained to be in the same hardware 
register (from the "0" constraint in "baz").  The types of "bar" and 
"baz" are otherwise unrelated.

I assume the difficulty here comes from how this needs to be handled 
from the point of view of the register allocator.  If both types fit 
inside a single allocatable hardware register, the issue is trivial; 
"bar" and "baz" form a single logical register for the purpose of 
register allocation.

However, things get a bit ugly in the case of different widths that 
affect individually scheduled registers, like 32- and 64-bit types on a 
32-bit machine.  Consider the case above where "bar" is a 64-bit type 
and "baz" is a 32-bit type, then you functionally have, at least on x86:

	uint64_t tmp = bar;
	asm("foo" : "+r" (tmp));
	baz = (uint32_t)tmp;

One could possibly argue that the latter case should be
"baz = (uint32_t)(tmp >> 32);" on a bigendian machine... since this is a 
gcc syntax it probably should be "whatever gcc does" in that case, as 
opposed to what might make sense.

(I'm afraid I don't have a bigendian box readily available at the 
moment, so I can't test it out to see what gcc does.  I have a powerpc 
machine, but it's at home and turned off.)

	-hpa

