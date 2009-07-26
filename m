Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZGZCoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZGZCoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 22:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZGZCoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 22:44:06 -0400
Received: from mail-yx0-f198.google.com ([209.85.210.198]:55029 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbZGZCoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 22:44:05 -0400
Message-ID: <4A6BC2FC.7020700@billgatliff.com>
Date: Sat, 25 Jul 2009 21:44:12 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Peter Zijlstra <peterz@infradead.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
References: <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com> <1248442415.6987.56.camel@twins> <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org> <1248451279.6987.138.camel@twins> <20090724233057.GO27755@shareable.org> <4A6A96AB.7030609@billgatliff.com> <20090725224848.GA15260@shareable.org>
In-Reply-To: <20090725224848.GA15260@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Bill Gatliff wrote:
>   
>> Jamie Lokier wrote:
>>     
>>> For simple things like "try to keep the buffer to my DVD writer full"
>>> (no I don't know how much CPU that requires - it's a kind of "best
>>> effort but try very hard!"), it would be quite useful to have
>>> something like RT-bandwidth which grants a certain percentage of time
>>> as an RT task, and effectively downgrades it to SCHED_OTHER when that
>>> time is exceeded to permit some fairness with the rest of the system.
>>>  
>>>       
>> Useful perhaps, but an application design that explicitly communicates 
>> your desires to the scheduler will be more robust, even if it does seem 
>> more complex at the outset.
>>     
>
> I agree with communicting the desire explicitly to the scheduler.
>
> In the above example, the exact desire is "give me as much CPU as I
> ask for, because my hardware servicing will be adversely but
> non-fatally affected if you don't, and the amount of CPU needed to
> service the hardware cannot be determined in advance, but prevent me
> from blocking progress in the rest of the system by limiting my
> exclusive ownership of the CPU".
>
> How do you propose to communicate that to the scheduler, if not by
> something rather like RT-bandwidth with downgrading to SCHED_OTHER
> when a policy limit is exceeded?
>   

This is a great real-world problem.  And there's no one-size-fits-all 
answer, unfortunately.

RT-bandwidth will give you the system behavior you are after, but it's a 
pretty blunt instrument.

I'd consider putting some throttling in your interrupt handler that 
prevents it from running more than a certain amount of calculation per 
interrupt event.  And perhaps it's looking at execution timestamps to 
determine how often it's running, and can therefore do a rough 
calculation of how much CPU it's eating.  At least until threaded 
interrupt scheduling is widespread, a runaway interrupt handler is 
definitely an opportunity to hang up a system.

Tasklets are nice for this, because the scheduler won't re-queue one if 
it's already running.  So if your interrupt handler's job is just to 
launch the tasklet, and you know how much time the tasklet takes to run, 
then if you get a burst of interrupts you don't end up launching an 
equivalent burst of scheduled work: eventually the interrupt handler 
overtakes the tasklet, and the additional interrupt events get dropped.  
That's often a decent way to deal with system overload, especially if it 
leaves the system functional enough to take some sort of "evasive 
action" like reverting to polled i/o, issuing a diagnostic message, or 
doing an orderly transition to a safe mode.

A flood ping, lots of paging, and driver bugs are just a few ways you 
can encounter an unexpected burst of interrupt activity that might, if 
not dealt with on some level, cause the system to suddenly destabilize.

Point is, keep a mentality that you want to fall back onto RT-bandwidth 
(or any other type of watchdog timer expiration) only after you've 
exhausted all other options.  Pretend it isn't there--- but definitely 
know what will happen if it ever steps in.  A system coded that way is 
much more resistant to breakage, in my experience anyway.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

