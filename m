Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYERUXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYERUXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYERUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:23:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:63847 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYERUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z1q9pMIsdc8CWCqmb3XokZ7TOuIDYF0V5tg1wDJ1w+OvAQBzxgC2SzXotSe2r6Ssu0mIWAjtd716N/ofyj9KsAnPGhzXYAAUKGFj253ysGQbVl6dIBS3XH4X9gIZNIrAji7lI6qjofIymvED6C0F1YakaV1wqs7bO8e8aZgx0pc=
Message-ID: <19f34abd0805181323h551bc874x29874b58509d634d@mail.gmail.com>
Date: Sun, 18 May 2008 22:23:11 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Error in save_stack_trace() on x86_64?
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20080518115208.592375b8@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
	 <48274C9E.3020608@linux.intel.com>
	 <19f34abd0805181013g8274992uffbdb337e72bfa98@mail.gmail.com>
	 <19f34abd0805181131o43da9abfle4d9362bee900727@mail.gmail.com>
	 <20080518115208.592375b8@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 8:52 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On Sun, 18 May 2008 20:31:18 +0200
>>
>> Is the error obvious from the stack-trace I posted above? This is not
>> really my field, so I might easily miss it :-)
>
> unfortunately I don't really have time today to take a detailed look
> (social obligations), but the trick is to follow where EBP (rBP) is
> going...

That's perfectly okay, I regard all help as a bonus :-D

There seems to be something odd going on here:

ffffffff80877bc8: ffffffff80877c98 <--- this points to the frame below
ffffffff80877bd0: ffffffff8062b061
 [<ffffffff8062b061>] do_page_fault+0x31/0x70

<...>

ffffffff80877c88: 0000000000007801
ffffffff80877c90: 0000000000000001
ffffffff80877c98: 000000008020bb59 <--- but this pointer is invalid!
ffffffff80877ca0: ffffffff80628ff9
 [<ffffffff80628ff9>] error_exit+0x0/0x51

And the invalid pointer should have been ffffffff80877f48:

ffffffff80877f48: ffffffff80877f78 <---
ffffffff80877f50: ffffffff80882b35
 [<ffffffff80882b35>] ? start_kernel+0x245/0x340

which is where the page fault came from.

It seems to me error_exit() called do_page_fault(), but that
do_page_fault() did not push the %rbp, or it was overwritten later.
(But how can it then be restored correctly when the function returns?)

I think this is the relevant code (from arch/x86/kernel/entry_64.S):

        movq ORIG_RAX(%rsp),%rsi        /* get error code */
        movq $-1,ORIG_RAX(%rsp)
        call *%rax
        /* ebx: no swapgs flag (1: don't need swapgs, 0: need it) */
error_exit:
        movl %ebx,%eax
        RESTORE_REST
        DISABLE_INTERRUPTS(CLBR_NONE)
        TRACE_IRQS_OFF

where that "call *%rax" would push the (return) address of error_exit
on the stack and go into do_page_fault().

It seems that do_page_fault() is doing the right thing, however:

ffffffff8062b030 <do_page_fault>:
ffffffff8062b030:       55                      push   %rbp
ffffffff8062b031:       48 89 e5                mov    %rsp,%rbp
ffffffff8062b034:       53                      push   %rbx
ffffffff8062b035:       48 81 ec b8 00 00 00    sub    $0xb8,%rsp

so my current theory is that the entry is overwritten later.

So what is the value 000000008020bb59 (from the erronous stack entry)?
It certainly looks like the lower half of an address to me.

And indeed, looking this up gives me:
ffffffff8020bb59 <irq_return>:
ffffffff8020bb59:       48 cf                   iretq

Strange!

In any case, I think we can safely assume that the stack tracer itself
is perfectly okay, and that the error is actually in how the stack is
handled just before/after the actual call to do_page_fault(). Does
anybody actually know how this code all works? It is admittedly
probably not the most critical error in the kernel, but it would be
nice to have this sorted out. Ingo, hpa...?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
