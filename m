Return-Path: <linux-kernel-owner+w=401wt.eu-S936925AbXHHBcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936925AbXHHBcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935322AbXHHBcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:32:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933596AbXHHBce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:32:34 -0400
Message-ID: <46B91D0C.5050704@redhat.com>
Date: Tue, 07 Aug 2007 21:31:56 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Chris Friesen <cfriesen@nortel.com>, Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>	 <20070806123551.a6c3c154.wjiang@resilience.com>	 <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com>	 <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com>	 <46B8E1D3.8050501@redhat.com>  <46B8E64E.7010708@nortel.com> <1186525977.232321.43.camel@localhost>
In-Reply-To: <1186525977.232321.43.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx wrote:
> On Tue, 2007-08-07 at 15:38 -0600, Chris Friesen wrote:
>> Chris Snook wrote:
>>
>>> That's why we define atomic_read like so:
>>>
>>> #define atomic_read(v)          ((v)->counter)
>>>
>>> This avoids the aliasing problem, because the compiler must de-reference 
>>> the pointer every time, which requires a memory fetch.
>> Can you guarantee that the pointer dereference cannot be optimised away 
>> on any architecture?  Without other restrictions, a suficiently 
>> intelligent optimiser could notice that the address of v doesn't change 
>> in the loop and the destination is never written within the loop, so the 
>> read could be hoisted out of the loop.
>>
>> Even now, powerpc (as an example) defines atomic_t as:
>>
>> typedef struct { volatile int counter; } atomic_t
>>
>>
>> That volatile is there precisely to force the compiler to dereference it 
>> every single time.
> 
> I just tried this with GCC 4.2 on x86_64 because I was curious.
> 
> struct counter_t { volatile int counter; } test;
> struct counter_t *tptr = &test;
> 
> int main() {
>         int i;
> 
>         tptr->counter = 0;
>         i = 0;
>         while(tptr->counter < 100) {
>                 i++;
>         }
>         return 0;
> }
> 
> $ gcc -O3 -S t.c
> 
> a snippet of t.s:
> main:
> .LFB2:
>         movq    tptr(%rip), %rdx
>         movl    $0, (%rdx)
>         .p2align 4,,7
> .L2:
>         movl    (%rdx), %eax
>         cmpl    $99, %eax
>         jle     .L2
> 
> 
> Now with the volatile removed:
> main:
> .LFB2:
>         movq    tptr(%rip), %rax
>         movl    $0, (%rax)
> .L2:
>         jmp     .L2
> 
> If the compiler can see it clearly, it will optimize out the load
> without the volatile.

This is not a problem, since indirect references will cause the CPU to fetch the 
data from memory/cache anyway.

	-- Chris
