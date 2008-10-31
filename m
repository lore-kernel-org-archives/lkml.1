Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbYJaKVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbYJaKVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 06:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYJaKVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 06:21:44 -0400
Received: from nebensachen.de ([195.34.83.29]:37870 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYJaKVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 06:21:41 -0400
X-Hashcash: 1:20:081031:tytso@mit.edu::IIh6bY1w1FQFPwev:000035tc
X-Hashcash: 1:20:081031:linux-kernel@vger.kernel.org::6h5MEeSbPocAq7pI:00000000000000000000000000000000010JQ
X-Hashcash: 1:20:081031:tglx@linutronix.de::ejBzGEOyynF0TQun:00000000000000000000000000000000000000000002FsY
X-Hashcash: 1:20:081031:mingo@elte.hu::Ulcoz9hVNVu/eY8k:00004XIn
From: Elias Oltmanns <eo@nebensachen.de>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [REGRESSION 2.6.28-rc2-git3] lots of extra timer interrupts costing 2W
References: <E1KvN6w-0002QE-E3@closure.thunk.org>
	<20081031031516.GA9781@mit.edu>
Date: Fri, 31 Oct 2008 11:21:34 +0100
In-Reply-To: <20081031031516.GA9781@mit.edu> (Theodore Tso's message of "Thu,
	30 Oct 2008 23:15:16 -0400")
Message-ID: <87mygl2hg1.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Oct 29, 2008 at 10:18:10PM -0400, Theodore Ts'o wrote:
>> I've noticed that sometime between 2.6.27-git7 and 2.6.28-rc2-git3,
>
>> powertop is reporting a huge number of excess timer interrupts on my
>> x61s laptop:
>> 
>> Wakeups-from-idle per second : 617.8    interval: 3.1s
>> no ACPI power usage estimate available
>> 
>> Top causes for wakeups:
>>   71.3% (543.7)       <interrupt> : extra timer interrupt 
>>   13.5% (103.0)     <kernel core> : hrtimer_start_expires (tick_sched_timer) 
>>    7.2% ( 55.0)      <kernel IPI> : Rescheduling interrupts 
>>    1.7% ( 13.0)    gnome-terminal : hrtimer_start_expires (hrtimer_wakeup) 
>>    1.4% ( 10.3)       <interrupt> : PS/2 keyboard/mouse/touchpad 
>>    1.1% (  8.3)       <interrupt> : ahci
>>    0.4% (  3.3)   multiload-apple : hrtimer_start_expires (hrtimer_wakeup)
>>    0.3% (  2.7)              Xorg : hrtimer_start (it_real_fn)
>> 
>> 
>> This is costing me an extra 2 Watts or so.   Does this ring a bell with
>> anyone, before I start trying to bisect this problem?
>
> I found the problem via bisection.  It's commit fb02fbc1, "NOHZ:
> restart tick device from irq_enter()".
>
> After bisecting the problem, I compiled v2.6.28-rc2 (with the attached
> .config file), verified that I saw the extra 500 or so timer
> interrupts, and then reverted the commit, and the extra timer
> interrupts went away.  A more careful measurement of the power drain
> difference makes it appear to be more like 0.8 watts.

Strange, I can't reproduce this problem here (tested next-20081029 and
2.6.27.4 + some commits including the one in question). However, I'm
wondering whether this is simply due to a certain config option since
extra timer interrupts doesn't even show up in my powertop output. This
is with NO_HZ=y and HIGH_RES_TIMERS=y/n. Could SMP possibly make any
difference here? It's disabled in my config.

>
> This is on an Lenovo X61s laptop. I'm not sure that simply reverting
> the commit is the right fix, but it does seem to make the extra timer
> interrupts (and the resulting decrease in average C3 residency time)
> go away.

Well, I'd be rather unhappy, for obvious reasons, if this commit was
simply reverted. But, of course, something has got to be done about it.

Regards,

Elias
