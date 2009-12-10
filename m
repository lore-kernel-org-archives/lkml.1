Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZLJOgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZLJOgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZLJOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:36:07 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:58960 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZLJOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:36:05 -0500
Message-ID: <4B210754.2020601@linux.vnet.ibm.com>
Date: Thu, 10 Dec 2009 15:36:04 +0100
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
References: <4B1D13B5.9020802@linux.vnet.ibm.com> <20091207150906.GC14743@csn.ul.ie> <4B1E93EE.60602@linux.vnet.ibm.com>
In-Reply-To: <4B1E93EE.60602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping the old discussion in the mail tail, adding the new information 
up here were everyone finds them :-)

Things I was able to confirm so far summarized:
- The controller doesn't care about pfn ordering in any way (proved by 
HW statistics)
- regression appears in sequential AND random workloads -> also without 
readahead
- oprofile & co are no option atm.
  The effective consumed cpu cycles per transferred kb are almost the 
same so I would not expect sampling would give us huge insights.
  Therefore I expect that it is more a matter of lost time (latency) 
than more expensive tasks (cpu consumption)
  I don't want to preclude it completely, but sampling has to wait as 
long as we have better tracks to follow

So the question is where time is lost in Linux. I used blktrace to 
create latency summaries.
I only list the random case for discussion as the effects are more clear 
int hat data.
Abbreviations are (like the blkparse man page explains) - sorted in 
order it would appear per request:
       A -- remap For stacked devices, incoming i/o is remapped to 
device below it in the i/o stack. The remap action details what exactly 
is being remapped to what.
       G -- get request To send any type of request to a block device, a 
struct request container must be allocated first.
       I -- inserted A request is being sent to the i/o scheduler for 
addition to the internal queue and later service by the driver. The 
request is fully formed at this time.
       D -- issued A request that previously resided on the block layer 
queue or in the i/o scheduler has been sent to the driver.
       C -- complete A previously issued request has been completed.  
The output will detail the sector and size of that request, as well as 
the success or failure of it.

The following table shows the average latencies from A to G, G to I and 
so on.
C2A is special and tries to summarize how long it takes after completing 
an I/O until the next one arrives in the block device layer.

                     avg-A2G    avg-G2I    avg-I2D   avg-D2C   
avg-C2A-in-avg+-stddev    %C2A-in-avg+-stddev
deviation good->bad    -3.48%    -0.56%    -1.57%    
-1.31%                   128.69%                 97.26%

It clearly shows that all latencies once block device layer and device 
driver are involved are almost equal. Remember that the throughput of 
good vs. bad case is more than x3.
But we can also see that the value of C2A increases by a huge amount. 
That huge C2A increase let me assume that the time is actually lost 
"above" the block device layer.

I don't expect the execution speed of iozone as user process itself is 
affected by commit e084b, so the question is where the time is lost 
between the "read" issued by iozone and entering the block device layer.
Actually I expect it somewhere in the area of getting a page cache page 
for the I/O. On one hand page handling is what commit e084b changes and 
on the other hand pages are under pressure (systat vm effectiveness 
~100%, >40% scanned directly in both cases).

I'll continue hunting down the lost time - maybe with ftrace if it is 
not concealing the effect by its invasiveness -, any further 
ideas/comments welcome.

kind regards,
Christian

Christian Ehrhardt wrote:
> Mel Gorman wrote:
>> On Mon, Dec 07, 2009 at 03:39:49PM +0100, Christian Ehrhardt wrote:
>>   [...]
>>
>> I don't know what controller is in use there but does it
>> opportunistically merge requests if they are on physically contiguous
>> pages? If so, can it be disabled?
>>   
> As far as i could clarify it our controllers don't support such a 
> opportunistic merging.
>>> The regression appears as up to 76% loss in throughput at 16 
>>> processes  (processes are scaled from 1 to 64, performance is bad 
>>> everywhere - 16  is just the peak - avg loss is about 40% throughput).
>>> I already know that giving the system just a bit (~64m+) more 
>>> memory  solves the issue almost completely, probably because there 
>>> is almost no  "memory pressure" left in that cases.
>>> I also know that using direct-I/O instead of I/O through page cache  
>>> doesn't have the problem at all.
>>>     
>>
>> This makes sense because it's a sequentual read load, so readahead is a
>> factor and that is why __GFP_COLD is used - the data is not for
>> immediate use so doesn't need to be cache hot.
>>   
> In the meanwhile I was able to verify that this also applies to random 
> reads which are still reads but have zero read ahead requests.
> I attached more regression data in the post scriptum at the end of the 
> mail.
>>  
>>> Comparing sysstat data taken while running with the kernels just 
>>> with &  without the bisected patch shows nothing obvious except that 
>>> I/O seems  to take much longer (lower interrupt ratio etc).
>>>
>>>     
>>
>> Maybe the controller is spending an age trying to merge requests because
>> it should be able to but takes a long time figuring it out?
>>   
> I thought that too, but now comes the funny part.
> I gathered HW statistics from our I/O controllers and latency 
> statistics clearly state that your patch is working as intended - the 
> latency from entering the controller until the interrupt to linux 
> device driver is ~30% lower!.
> Remember as I stated above that they don't support that opportunistic 
> merging so I will have some fun finding out why it is faster in HW now 
> :-)
>
>>> The patch alone looks very reasonable, so I'd prefer understanding 
>>> and  fixing the real issue instead of getting it eventually reverted 
>>> due to  this regression being larger than the one it was intended to 
>>> fix.
>>> In the patch it is clear that hot pages (cold==0) freed in 
>>> rmqueue_bulk  should behave like before. So maybe the question is 
>>> "are our pages cold  while they shouldn't be"?
>>> Well I don't really have a clue yet to explain how patch e084b 
>>> exactly  causes that big regression, ideas welcome :-)
>>>
>>>     
>>
>> Only theory I have at the moment is that the controller notices it can
>> merge requests and either spends a long time figuring out how to do the
>> merging or performs worse with merged IO requests.
>>
>> If the problem is in the driver, oprofile might show where the 
>> problem lies
> With the effective throughput dropping by such a large amount while 
> hardware latency improves by 30% I agree and suggest the issue is in 
> the driver.
> I'll do some research in breaking down where in our drivers time is 
> lost and reply here for advises and comments in regard to what general 
> memory management could/should/might do.
>
> Kind regards,
> Christian
>
> p.s.
> FYI a bit more regression data, now I had the patch identified I made 
> a full regression test scaling from 1 to 64 processes.
> Comparing just without / with the commit e084b
> I wondered, but obviously random read is also suffering from that patch.
>
> Sequential Read
> Procs Deviation in %
> 1              -4.9
> 2               5.2
> 4             -82.6
> 8             -65.6
> 16            -44.2
> 32            -30.0
> 64            -37.7
>
> Random Read
> Procs Deviation in %
> 1             -48.3
> 2             -45.7
> 4             -50.5
> 8             -59.0
> 16            -61.8
> 32            -48.3
> 64            -21.0
>


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

