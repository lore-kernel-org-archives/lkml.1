Return-Path: <linux-kernel-owner+w=401wt.eu-S2992758AbXCBXyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992758AbXCBXyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992772AbXCBXyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:54:18 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:55007 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992758AbXCBXyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:54:17 -0500
Message-ID: <45E8B925.6010407@simon.arlott.org.uk>
Date: Fri, 02 Mar 2007 23:54:13 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH (update 3)] timer: Run calc_load halfway through each
 round_jiffies second
References: <45E0577C.9020409@simon.arlott.org.uk> <200703021735.55142.dada1@cosmosbay.com> <45E85FC3.801@simon.arlott.org.uk> <200703021903.56720.dada1@cosmosbay.com> <45E885A8.5060708@simon.arlott.org.uk> <45E8A5EA.3030207@cosmosbay.com>
In-Reply-To: <45E8A5EA.3030207@cosmosbay.com>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(I've removed the other CC:s for now to avoid annoying them - assuming 
removing them from the CC: list doesn't do that).

On 02/03/07 22:32, Eric Dumazet wrote:
> Simon Arlott a écrit :
>> On 02/03/07 16:35, Eric Dumazet wrote:
>>> I believe this patch is too complex/hazardous and may break exp decay 
>>> computation.
>>
>> I still don't know why you think it may change the computation of load 
>> (aside from at boot or jiffies wrapping), and it's not really complex 
>> at all. It is possible that someone will change the value of LOAD_FREQ 
>> to something other than a multiple of HZ and this won't work because 
>> it'll get rounded up to a whole second. That and the negligible extra 
>> processing time of doing round_jiffies every 5 seconds is the only 
>> problem I can see.
> 
> You apparently have no idea of the mathematic formulae used.

You're right, I've not looked at exactly how it's done. I do know that 
calling it early/late (by +/- 750ms/250ms) *once* on boot and every 7 
weeks is going to have a tiny effect that will go away quickly.

> This formulae has a meaning *only* if EXP_1, EXP_5, EXP_15 are directly 
> computed from the exact LOAD_FREQ value. If you change it 'randomly' 
> without changing the EXP_... you basically compute a wrong value...

My comment asking about why you say it's complex is about the patch, not 
the computation. After an initial sync the patch does not change how 
often the calc_load computation is run or how it works, it will still be 
run exactly the same way and every 5*HZ ticks as before (try adding a 
printk to report when the count value's been changed by the call to 
round_jiffies).

> So what ? Do you want to impress your boss with a given value ?

?

> Please dont mess it. Just ignore the avenrun values and let it die.
> You can change it to suit your needs, but it wont suit every needs.

I'm not sure you realise the problem the patch fixes, which is that since 
2.6.20 tasks can use round_jiffies to run "in around X seconds time" at a 
time when jiffies % HZ == 0 to avoid waking the CPU several times because 
of multiple timers firing at random. This affects the calc_load process 
really badly because it also tends to run at this time too. Moving calc_load 
to always run halfway between a second will solve the problem.

> Imagine for example your task is awaken for 1us periods every HZ.
> Basically your cpu load should be HZ/1000000 (machine mostly idle)
> But computed 'load' will be 1.0
> This whole avenrun[] thing is plain stupid anyway. The load should be 
> something between 0 and 1 (per cpu), to get a precise idea of cpu_power 
> used/unused. Nobody mentioned avenrun[] values on lkml in the last decade.

If you're sure no one here cares about the values then I'll submit a patch 
to remove them from /proc/loadavg (and wait it to get rejected). Until the 
whole concept of load average and how it should be better calculated and 
reported is solved the best that can be done is to not make things worse 
like round_jiffies has done.

*I* know the values are nowhere near perfect, but I made a change to a 
driver so that it uses round_jiffies to schedule status checking because 
it's appropriate and it makes the load average values sit at 1.00 even when 
idle - someone is going to complain about it and possibly take the time to 
find out why. If they bisect it, my patch will show up as the cause of the 
problem. (Assuming someone else uses this device; I sent an email to the 
accessrunner list once -rc2-mm1 was released asking for people to test it).

-- 
Simon Arlott
