Return-Path: <linux-kernel-owner+w=401wt.eu-S967537AbXEHAfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967537AbXEHAfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967348AbXEHAfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:35:46 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:42085 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967213AbXEHAfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:35:45 -0400
Message-ID: <463FC5D8.2090502@bigpond.net.au>
Date: Tue, 08 May 2007 10:35:36 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Esben Nielsen <nielsen.esben@googlemail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <20070506082911.GA32644@elte.hu> <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org> <Pine.LNX.4.64.0705071311040.14011@frodo.shire>
In-Reply-To: <Pine.LNX.4.64.0705071311040.14011@frodo.shire>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06sl.mx.bigpond.com from [138.130.234.53] using ID pwil3058@bigpond.net.au at Tue, 8 May 2007 00:35:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Esben Nielsen wrote:
> 
> 
> On Sun, 6 May 2007, Linus Torvalds wrote:
> 
>>
>>
>> On Sun, 6 May 2007, Ingo Molnar wrote:
>>>
>>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>>> So the _only_ valid way to handle timers is to
>>>>  - either not allow wrapping at all (in which case "unsigned" is 
>>>> better,
>>>>    since it is bigger)
>>>>  - or use wrapping explicitly, and use unsigned arithmetic (which is
>>>>    well-defined in C) and do something like "(long)(a-b) > 0".
>>>
>>> hm, there is a corner-case in CFS where a fix like this is necessary.
>>>
>>> CFS uses 64-bit values for almost everything, and the majority of values
>>> are of 'relative' nature with no danger of overflow. (They are signed
>>> because they are relative values that center around zero and can be
>>> negative or positive.)
>>
>> Well, I'd like to just worry about that for a while.
>>
>> You say there is "no danger of overflow", and I mostly agree that once
>> we're talking about 64-bit values, the overflow issue simply doesn't
>> exist, and furthermore the difference between 63 and 64 bits is not 
>> really
>> relevant, so there's no major reason to actively avoid signed entries.
>>
>> So in that sense, it all sounds perfectly sane. And I'm definitely not
>> sure your "292 years after bootup" worry is really worth even 
>> considering.
>>
> 
> I would hate to tell mission control for Mankind's first mission to another
> star to reboot every 200 years because "there is no need to worry about 
> it."
> 
> As a matter of principle an OS should never need a reboot (with 
> exception for upgrading). If you say you have to reboot every 200 years, 
> why not every 100? Every 50? .... Every 45 days (you know what I am 
> referring to :-) ?

There's always going to be an upper limit on the representation of time. 
  At least until we figure out how to implement infinity properly.

> 
>> When we're really so well off that we expect the hardware and software
>> stack to be stable over a hundred years, I'd start to think about issues
>> like that, in the meantime, to me worrying about those kinds of issues
>> just means that you're worrying about the wrong things.
>>
>> BUT.
>>
>> There's a fundamental reason relative timestamps are difficult and almost
>> always have overflow issues: the "long long in the future" case as an
>> approximation of "infinite timeout" is almost always relevant.
>>
>> So rather than worry about the system staying up 292 years, I'd worry
>> about whether people pass in big numbers (like some MAX_S64 
>> approximation)
>> as an approximation for "infinite", and once you have things like that,
>> the "64 bits never overflows" argument is totally bogus.
>>
>> There's a damn good reason for using only *absolute* time. The whole
>> "signed values of relative time" may _sound_ good, but it really sucks in
>> subtle and horrible ways!
>>
> 
> I think you are wrong here. The only place you need absolute time is a 
> for the clock (CLOCK_REALTIME). You waste CPU using a 64 bit
> representation when you could have used a 32 bit. With a 32 bit 
> implementation you are forced to handle the corner cases with wrap 
> around and too big arguments up front. With a 64 bit you hide those 
> problems.

As does the other method.  A 32 bit signed offset with a 32 bit base is 
just a crude version of 64 bit absolute time.

> 
> I think CFS would be best off using a 32 bit timer counting in micro 
> seconds. That would wrap around in 72 minuttes. But as the timers are 
> relative you will never be able to specify a timer larger than 36 
> minuttes in the future. But 36 minuttes is redicolously long for a 
> scheduler and a simple test limiting time values to that value would not 
> break anything.

Except if you're measuring sleep times.  I think that you'll find lots 
of tasks sleep for more than 72 minutes.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
