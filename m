Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZIIJFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZIIJFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZIIJFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:05:22 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:50207 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbZIIJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:05:21 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-13.arcor-online.net E02D42BB00F
Message-ID: <4AA76FD2.1050103@arcor.de>
Date: Wed, 09 Sep 2009 12:05:22 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu>	 <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>	 <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net>
In-Reply-To: <1252486344.28645.18.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 11:52 AM, Mike Galbraith wrote:
> On Wed, 2009-09-09 at 08:13 +0200, Ingo Molnar wrote:
>> * Jens Axboe<jens.axboe@oracle.com>  wrote:
>>
>>> On Tue, Sep 08 2009, Peter Zijlstra wrote:
>>>> On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
>>>>> And here's a newer version.
>>>>
>>>> I tinkered a bit with your proglet and finally found the
>>>> problem.
>>>>
>>>> You used a single pipe per child, this means the loop in
>>>> run_child() would consume what it just wrote out until it got
>>>> force preempted by the parent which would also get woken.
>>>>
>>>> This results in the child spinning a while (its full quota) and
>>>> only reporting the last timestamp to the parent.
>>>
>>> Oh doh, that's not well thought out. Well it was a quick hack :-)
>>> Thanks for the fixup, now it's at least usable to some degree.
>>
>> What kind of latencies does it report on your box?
>>
>> Our vanilla scheduler default latency targets are:
>>
>>    single-core: 20 msecs
>>      dual-core: 40 msecs
>>      quad-core: 60 msecs
>>      opto-core: 80 msecs
>>
>> You can enable CONFIG_SCHED_DEBUG=y and set it directly as well via
>> /proc/sys/kernel/sched_latency_ns:
>>
>>     echo 10000000>  /proc/sys/kernel/sched_latency_ns
>
> He would also need to lower min_granularity, otherwise, it'd be larger
> than the whole latency target.

Thank you for mentioning min_granularity.  After:

   echo 10000000 > /proc/sys/kernel/sched_latency_ns
   echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns

I can clearly see an improvement: animations that are supposed to be 
fluid "skip" much less now, and in one occasion (simply moving the video 
window around) have been eliminated completely.  However, there seems to 
be a side effect from having CONFIG_SCHED_DEBUG enabled; things seem to 
be generally a tad more "jerky" with that option enabled, even when not 
even touching the latency and granularity defaults.

I'll try the patch you posted and see if this further improves things.
