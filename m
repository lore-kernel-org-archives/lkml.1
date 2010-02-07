Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab0BGUIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 15:08:21 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:53907 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0BGUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 15:08:20 -0500
Date: Sun, 07 Feb 2010 15:08:14 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: x86 - cpu_relax - why nop vs. pause?
In-reply-to: <1265566470.6280.10.camel@marge.simson.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Message-id: <4B6F1DAE.6020407@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B6EF853.9090704@majjas.com>
 <1265566470.6280.10.camel@marge.simson.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/2010 1:14 PM, Mike Galbraith wrote:
> On Sun, 2010-02-07 at 12:28 -0500, Michael Breuer wrote:
>    
>> I did search and noticed some old discussions. Looking at both Intel and
>> AMD documentation, it would seem that PAUSE is the preferred instruction
>> within a spin lock. Further, both Intel and AMD specifications state
>> that the instruction is backward compatible with older x86 processors.
>>
>> For fun, I changed nop to pause on my core i7 920 (smt enabled) and I'm
>> seeing about a 5-10% performance improvement on 2.6.33 rc7. Perf top
>> shows time spent in spin_lock under load drops from an average of around
>> 35% to about 25%.
>>
>> Thoughts?
>>      
> /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
>
> 00000000004004fc<rep_nop>:
>    4004fc:       55                      push   %rbp
>    4004fd:       48 89 e5                mov    %rsp,%rbp
>    400500:       f3 90                   pause
>    400502:       c9                      leaveq
>    400503:       c3                      retq
>
> 0000000000400504<pause>:
>    400504:       55                      push   %rbp
>    400505:       48 89 e5                mov    %rsp,%rbp
>    400508:       f3 90                   pause
>    40050a:       c9                      leaveq
>    40050b:       c3                      retq
>
> foo.c
>
> static inline void rep_nop(void)
> {
>          asm volatile("rep; nop" ::: "memory");
> }
>
> static inline void pause(void)
> {
>          asm volatile("pause" ::: "memory");
> }
>
> void main(void)
> {
> 	rep_nop();
> 	pause();
> }
>
>    
Interesting, and this got me thinking... and testing... I think there's 
an optimization issue with gcc:

First of all - a bit of background on how I got here:

After reading the Intel documentation, I tried replacing rep:nop with 
pause (in theory exactly what's shown above). The system hung on booting.
I then tried replacing nop with pause (rep:pause) and the system booted. 
Using the above example, the opcode becomes f3 f3 90 vs f3 90 (rep nop).

Given the above compiler test case, this seemed odd, to say the least. 
So I played a bit more with gcc. Seems that the optimizer (-O3) is 
handling the *three*cases differently (objdump output)

Base code for all three cases (only change is the asm volitile line as 
shown for each case):

static inline void pause(void)
{
         asm volatile("pause" ::: "memory");
}

void main(void)
{
     pause();
}

Case1 - asm volatile("pause" ::: "memory");
0000000000400480 <main>:
   400480:    f3 90                    pause
   400482:    c3                       retq
   400483:    90                       nop

Case2 - asm volitile("rep;nop" ::: "memory") Note: this didn't inline!

0000000000400474 <pause>:
   400474:    55                       push   %rbp
   400475:    48 89 e5                 mov    %rsp,%rbp
   400478:    f3 90                    pause
   40047a:    c9                       leaveq
   40047b:    c3                       retq

000000000040047c <main>:
   40047c:    55                       push   %rbp
   40047d:    48 89 e5                 mov    %rsp,%rbp
   400480:    e8 ef ff ff ff           callq  400474 <pause>
   400485:    c9                       leaveq
   400486:    c3                       retq
   400487:    90                       nop
   400488:    90                       nop
   400489:    90                       nop
   40048a:    90                       nop
   40048b:    90                       nop
   40048c:    90                       nop
   40048d:    90                       nop
   40048e:    90                       nop
   40048f:    90                       nop

Case3 - asm volitile("rep;pause" ::: "memory")
0000000000400480 <main>:
   400480:    f3 f3 90                 pause
   400483:    c3                       retq
   400484:    90                       nop
_______
Note the difference between opcodes case 1 and case 3, and the mess made 
by the compiler in case 2.

As to benchmarks  - I've checked a few things, no formal or lasting 
stuff... but striking at first glance:

1) At idle, perf top shows time spent in _raw_spin_lock dropping from 
~35% to ~25%.
2) Running a media transcode (single core - handbrakecli): frame rate 
increased by about 5-10%.
3) During file-intensive operations (#2, above, or copying large files - 
ext4 on software raid6) - latencytop shows a decerase on writing a page 
to disc from about 120ms to about 90ms.
