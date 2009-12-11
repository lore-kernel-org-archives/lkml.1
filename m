Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZLKOsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZLKOsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbZLKOsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:48:00 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:55208 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbZLKOr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:47:59 -0500
Message-ID: <4B225B9E.2020702@linux.vnet.ibm.com>
Date: Fri, 11 Dec 2009 15:47:58 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: arayananu Gopalakrishnan <narayanan.g@samsung.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B1D13B5.9020802@linux.vnet.ibm.com> <20091207150906.GC14743@csn.ul.ie> <4B1E93EE.60602@linux.vnet.ibm.com> <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie>
In-Reply-To: <20091211112009.GC30670@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Thu, Dec 10, 2009 at 03:36:04PM +0100, Christian Ehrhardt wrote:
>   
>> Keeping the old discussion in the mail tail, adding the new information  
>> up here were everyone finds them :-)
>>
>> Things I was able to confirm so far summarized:
>> - The controller doesn't care about pfn ordering in any way (proved by  
>> HW statistics)
>> - regression appears in sequential AND random workloads -> also without  
>> readahead
>> - oprofile & co are no option atm.
>>  The effective consumed cpu cycles per transferred kb are almost the  
>> same so I would not expect sampling would give us huge insights.
>>  Therefore I expect that it is more a matter of lost time (latency) than 
>> more expensive tasks (cpu consumption)
>>     
>
> But earlier, you said that latency was lower - "latency statistics clearly
> state that your patch is working as intended - the latency from entering
> the controller until the interrupt to linux device driver is ~30% lower!."
>   
Thats right, but the pure Hardware time is only lower due to the case of 
less I/O in flight.
As it has less concurrency and contention that way a single I/O in HW is 
faster.
But in HW it's so fast (both cases) that as verified in the linux layers 
it doesn't matter.
Both cases take more or less the same time from an I/O entering the 
block device layer until completion.
> Also, if the controller is doing no merging of IO requests, why is the
> interrupt rate lower?
>   
I was wondering about that when I started to work on this too, but the 
answer is simply that there are less requests coming in per second - and 
that implies a lower interrupt rate too.
>>  I don't want to preclude it completely, but sampling has to wait as  
>> long as we have better tracks to follow
>>
>> So the question is where time is lost in Linux. I used blktrace to  
>> create latency summaries.
>> I only list the random case for discussion as the effects are more clear  
>> int hat data.
>> Abbreviations are (like the blkparse man page explains) - sorted in  
>> order it would appear per request:
>>       A -- remap For stacked devices, incoming i/o is remapped to device 
>> below it in the i/o stack. The remap action details what exactly is being 
>> remapped to what.
>>       G -- get request To send any type of request to a block device, a  
>> struct request container must be allocated first.
>>       I -- inserted A request is being sent to the i/o scheduler for  
>> addition to the internal queue and later service by the driver. The  
>> request is fully formed at this time.
>>       D -- issued A request that previously resided on the block layer  
>> queue or in the i/o scheduler has been sent to the driver.
>>       C -- complete A previously issued request has been completed.  The 
>> output will detail the sector and size of that request, as well as the 
>> success or failure of it.
>>
>> The following table shows the average latencies from A to G, G to I and  
>> so on.
>> C2A is special and tries to summarize how long it takes after completing  
>> an I/O until the next one arrives in the block device layer.
>>
>>                     avg-A2G    avg-G2I    avg-I2D   avg-D2C    avg-C2A-in-avg+-stddev    %C2A-in-avg+-stddev
>> deviation good->bad    -3.48%    -0.56%    -1.57%    -1.31%         128.69%                 97.26%
>>
>> It clearly shows that all latencies once block device layer and device  
>> driver are involved are almost equal. Remember that the throughput of  
>> good vs. bad case is more than x3.
>> But we can also see that the value of C2A increases by a huge amount.  
>> That huge C2A increase let me assume that the time is actually lost  
>> "above" the block device layer.
>>
>>     
>
> To be clear. As C is "completion" and "A" is remapping new IO, it
> implies that time is being lost between when one IO completes and
> another starts, right?
>
>   
Absolutely correct
>> I don't expect the execution speed of iozone as user process itself is  
>> affected by commit e084b,
>>     
> Not by this much anyway. Lets say cache hotness is a problem, I would
> expect some performance loss but not this much.
>   
I agree, even if it is cache hotness it wouldn't be that much.
And cold caches would appear as "longer" instructions because they would 
need more cycles due to e.g. dcache misses.
But as mentioned before the cycles per transferred amount of data are 
the same so I don't expect it is due to cache hot/cold.

>> so the question is where the time is lost  
>> between the "read" issued by iozone and entering the block device layer.
>> Actually I expect it somewhere in the area of getting a page cache page  
>> for the I/O. On one hand page handling is what commit e084b changes and  
>> on the other hand pages are under pressure (systat vm effectiveness  
>> ~100%, >40% scanned directly in both cases).
>>
>> I'll continue hunting down the lost time - maybe with ftrace if it is  
>> not concealing the effect by its invasiveness -, any further  
>> ideas/comments welcome.
>>
>>     
>
> One way of finding out if cache hottness was the problem would be to profile
> for cache misses and see if there are massive differences with and without
> the patch. Is that an option?
>   
It is an option to verify things, but as mentioned above I would expect 
an increase amounts of consumed cycles per kb which I don't see.
I'll track caches anyway to be sure.

My personal current assumption is that either there is some time lost 
from the read syscall until the A event blocktrace tracks or I'm wrong 
with my assumption about user processes and iozone runs "slower".

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

