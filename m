Return-Path: <linux-kernel-owner+w=401wt.eu-S2992668AbXCBRdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992668AbXCBRdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992666AbXCBRdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:33:39 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:58874 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992668AbXCBRdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:33:38 -0500
Message-ID: <45E85FC3.801@simon.arlott.org.uk>
Date: Fri, 02 Mar 2007 17:32:51 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: akpm@linux-foundation.org, Bill Irwin <bill.irwin@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@linux.intel.com
Subject: Re: [PATCH (update 3)] timer: Run calc_load halfway through each
 round_jiffies second
References: <45E0577C.9020409@simon.arlott.org.uk> <45E7F92E.7090407@simon.arlott.org.uk> <45E83F7A.9030307@simon.arlott.org.uk> <200703021735.55142.dada1@cosmosbay.com>
In-Reply-To: <200703021735.55142.dada1@cosmosbay.com>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/07 16:35, Eric Dumazet wrote:
> On Friday 02 March 2007 16:15, Simon Arlott wrote:
>> Whenever jiffies is started at a multiple of 5*HZ or wraps, calc_load is
>> run exactly on the second which is when tasks using round_jiffies will
>> be scheduled to run. This has a bad effect on the load average, making
>> it tend towards 1.00 if a task happens to run every time the load is
>> being calculated.
>>
>> This changes calc_load so that it updates load half a second after any
>> tasks scheduled using round_jiffies.
> 
> I believe this patch is too complex/hazardous and may break exp decay 
> computation.

Only for a single calculation whenever it has to adjust, which should only 
happen every 49.7 days (on 32-bit archs). (Or 5 minutes after booting... 
I always wondered why that happened and now I see it's initialised so it 
always wraps early). Whilst it is in sync with jiffies it will not affect 
the process - count is just set to the current value every time. Even with 
NO_HZ because jiffies will be correct when calc_load is called.

> (Even if nobody care about avenrun[] those days :), do you ? )
> 
> You could just change LOAD_FREQ from (5*HZ) to (5*HZ+1)
> You can see that 5.01 instead of 5.00 second gives the same EXP_xx values.
> 
> So (5*HZ + 1) is safe. (because HZ >= 100)

On HZ=1000, this would cause the load average to be pushed towards +1.00 
for up to 2 minutes every ~83 minutes with no obvious cause. (If a task 
takes ~10-20ms to run, so 20 runs are needed at HZ=1000 before it passes 
it again).

On HZ=100 it would happen every ~8 minutes for up to 10 seconds and never 
be noticed.

Using 5*HZ+2 would move this to ~167 and ~17 minutes which would mitigate 
the effect further still without changing the exp values.

1884.25 -> 1883.62
2014.15 -> 2014.02
2036.65 -> 2036.61

Will anyone notice if the load is adjusted slightly less frequently?


If this is considered preferable to adjusting calc_load to avoid almost all 
round_jiffies scheduled tasks (some of which may take longer than ~15ms to 
run), then I have no problems with it - I just needed something to stop my 
driver changes doing odd things to the load average for other people. I'll 
continue to run with this version, is it possible to add a Kconfig option 
for it somewhere?

-- 
Simon Arlott
