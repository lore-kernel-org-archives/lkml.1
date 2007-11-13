Return-Path: <linux-kernel-owner+w=401wt.eu-S1763476AbXKMWCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476AbXKMWCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761935AbXKMWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:02:35 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:38927 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763920AbXKMWCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:02:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HALisOUdMROHU/2dsb2JhbACBW45u
Date: Tue, 13 Nov 2007 17:02:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (update)
Message-ID: <20071113220227.GB9057@Krystal>
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com> <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com> <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <473A166E.3070708@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:58:17 up 10 days,  3:03,  6 users,  load average: 0.36, 0.68,
	0.99
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>> Mathieu Desnoyers wrote:
>>>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>>>> Mathieu Desnoyers wrote:
>>>>>>> - Use "=g" constraint for char immediate value inline assembly.
>>>>>>>
>>>>>>> "=g" is the same as "=rmi" which is inherently bogus.  In your actual 
>>>>>>> code you use "=r", the correct constraint is "=q".
>>>>>> q
>>>>>>     Any register accessible as rl. In 32-bit mode, a, b, c, and d; in 
>>>>>> 64-bit mode, any integer register. I am worried that "=q" might 
>>>>>> exclude the si and di registers in 32-bit mode.
>>>>>> What exactly is wrong with "=r" ?
>>>>> For "char" (8-bit) values, sp/bp/si/di are illegal in 32-bit mode.
>>>>>
>>>>> Hence "=q".
>>>>>
>>>> Ah! yep, I see, so we say:
>>>> 1 byte : "=q"
>>>> 2 bytes : "=r"
>>>> 4 bytes : "=r"
>>>> 8 bytes : "=r"
>>>> ? (si and di appear to be legal for 2 and 4 bytes in 32-bit mode)
>>> That's right.
>>>
>>> 	-hpa
>
> Something else to watch out for... in 64-bit mode the lengths most of these 
> will depend on which register is used, since whether or not a REX prefix is 
> needed will vary.
>
> As far as I can tell, you're assuming fixed length instructions, which is 
> wrong unless you manually constrain yourself to only legacy registers.
>

This is what I was pointing out in this previous message :
http://lkml.org/lkml/2007/10/20/92

"I am still trying to figure out if we must assume that gas will produce
different length opcodes for mov instructions. The choice is:
- Either I use a "r" constraint and let gcc produce the instructions,
  that I need to assume to have correct size so I can align their
  immediate values (therefore, taking the offset from the end of the
  instruction will not help). Here, if gas changes its behavior
  dramatically for a given immediate value size, it will break.

- Second choice is to stick to a particular register, choosing the one
  with the less side-effect, and encoding the instruction ourselves. I
  start to think that this second solution might be safer, even though
  we wouldn't let the compiler select the register which has the less
  impact by itself."

Andi seemed to trust gas stability and you answered:

"The comment was referring to x86-64, but I incorrectly remembered that 
applying to "movq $imm,%reg" as opposed to loading from an absolute 
address.  gas actually has a special opcode (movabs) for the 64-bit 
version of the latter variant, which is only available with %rax and its 
subregisters.

Nevermind, in other words.  It's still true, though, that the immediate 
will always be the last thing in the instruction -- that's a fixture of 
the instruction format."

So, in the end, is there a way to make x86_64 use a fixed-size opcode
for the 1, 2, 4 and 8 bytes load immediates or we will have to force the
use of a specific register ?

(and we can't take a pointer from the end of the instruction, because we
need to align the immediate value correctly)

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
