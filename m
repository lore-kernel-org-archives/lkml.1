Return-Path: <linux-kernel-owner+w=401wt.eu-S1030653AbXCBWdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653AbXCBWdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030654AbXCBWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:33:14 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:37389 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030653AbXCBWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:33:13 -0500
Message-ID: <45E8A5EA.3030207@cosmosbay.com>
Date: Fri, 02 Mar 2007 23:32:10 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: akpm@linux-foundation.org, Bill Irwin <bill.irwin@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@linux.intel.com
Subject: Re: [PATCH (update 3)] timer: Run calc_load halfway through each
 round_jiffies second
References: <45E0577C.9020409@simon.arlott.org.uk> <200703021735.55142.dada1@cosmosbay.com> <45E85FC3.801@simon.arlott.org.uk> <200703021903.56720.dada1@cosmosbay.com> <45E885A8.5060708@simon.arlott.org.uk>
In-Reply-To: <45E885A8.5060708@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 02 Mar 2007 23:32:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott a écrit :
> On 02/03/07 18:03, Eric Dumazet wrote:
>> On Friday 02 March 2007 18:32, Simon Arlott wrote:
>>> On 02/03/07 16:35, Eric Dumazet wrote:
>>
>>>> You could just change LOAD_FREQ from (5*HZ) to (5*HZ+1)
>>>> You can see that 5.01 instead of 5.00 second gives the same EXP_xx
>>>> values.
>>>>
>>>> So (5*HZ + 1) is safe. (because HZ >= 100)
>>> On HZ=1000, this would cause the load average to be pushed towards +1.00
>>> for up to 2 minutes every ~83 minutes with no obvious cause. (If a task
>>> takes ~10-20ms to run, so 20 runs are needed at HZ=1000 before it passes
>>> it again).
>>
>> Nope, you dont quite understand how load (avenrun[]) is computed.
>> Not exactly 1.0 as you think !
>> Then in the next intervals (if active count is 0), it will decrease 
>> 'slowly' : 0.0735627
>> 0.0676809
>> 0.0622695
>> 0.0572907
>>
>> In average, your load factor close to reality.
> 
> I knew that; but the task runs for more than 1 tick and it takes until 
> the next calc_load run before it moves on even 1 tick.
> 
>> Just try my suggestion, it should work. I even proved it in my 
>> previous mail :)
> 
> With HZ=1000, the active count will be 1 up to 20 times in a row before 
> it becomes out of sync with when the task is run again. This is ample 
> time for the load value itself to get closer to 1:
> $ uptime; (yes>/dev/null &); sleep 100; uptime
> 20:00:29 up  4:35,  7 users,  load average: 0.33, 0.51, 0.78
> 20:02:09 up  4:37,  7 users,  load average: 0.97, 0.67, 0.81
> (not very useful results since the load isn't at 0.00 very often)
> 
> 
> On 02/03/07 16:35, Eric Dumazet wrote:
>> I believe this patch is too complex/hazardous and may break exp decay 
>> computation.
> 
> I still don't know why you think it may change the computation of load 
> (aside from at boot or jiffies wrapping), and it's not really complex at 
> all. It is possible that someone will change the value of LOAD_FREQ to 
> something other than a multiple of HZ and this won't work because it'll 
> get rounded up to a whole second. That and the negligible extra 
> processing time of doing round_jiffies every 5 seconds is the only 
> problem I can see.

You apparently have no idea of the mathematic formulae used.

This formulae has a meaning *only* if EXP_1, EXP_5, EXP_15 are directly 
computed from the exact LOAD_FREQ value. If you change it 'randomly' without 
changing the EXP_... you basically compute a wrong value... So what ? Do you 
want to impress your boss with a given value ?

Please dont mess it. Just ignore the avenrun values and let it die.

You can change it to suit your needs, but it wont suit every needs.

Imagine for example your task is awaken for 1us periods every HZ.
Basically your cpu load should be HZ/1000000 (machine mostly idle)

But computed 'load' will be 1.0

This whole avenrun[] thing is plain stupid anyway. The load should be 
something between 0 and 1 (per cpu), to get a precise idea of cpu_power 
used/unused. Nobody mentioned avenrun[] values on lkml in the last decade.

