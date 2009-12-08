Return-Path: <linux-kernel-owner+w=401wt.eu-S965726AbZLHR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965726AbZLHR7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965709AbZLHR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:59:11 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:41453 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965707AbZLHR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:59:09 -0500
Message-ID: <4B1E93EE.60602@linux.vnet.ibm.com>
Date: Tue, 08 Dec 2009 18:59:10 +0100
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
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B1D13B5.9020802@linux.vnet.ibm.com> <20091207150906.GC14743@csn.ul.ie>
In-Reply-To: <20091207150906.GC14743@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Mon, Dec 07, 2009 at 03:39:49PM +0100, Christian Ehrhardt wrote:
>   
> [...]
>
> I don't know what controller is in use there but does it
> opportunistically merge requests if they are on physically contiguous
> pages? If so, can it be disabled?
>   
As far as i could clarify it our controllers don't support such a 
opportunistic merging.
>> The regression appears as up to 76% loss in throughput at 16 processes  
>> (processes are scaled from 1 to 64, performance is bad everywhere - 16  
>> is just the peak - avg loss is about 40% throughput).
>> I already know that giving the system just a bit (~64m+) more memory  
>> solves the issue almost completely, probably because there is almost no  
>> "memory pressure" left in that cases.
>> I also know that using direct-I/O instead of I/O through page cache  
>> doesn't have the problem at all.
>>     
>
> This makes sense because it's a sequentual read load, so readahead is a
> factor and that is why __GFP_COLD is used - the data is not for
> immediate use so doesn't need to be cache hot.
>   
In the meanwhile I was able to verify that this also applies to random 
reads which are still reads but have zero read ahead requests.
I attached more regression data in the post scriptum at the end of the mail.
>   
>> Comparing sysstat data taken while running with the kernels just with &  
>> without the bisected patch shows nothing obvious except that I/O seems  
>> to take much longer (lower interrupt ratio etc).
>>
>>     
>
> Maybe the controller is spending an age trying to merge requests because
> it should be able to but takes a long time figuring it out?
>   
I thought that too, but now comes the funny part.
I gathered HW statistics from our I/O controllers and latency statistics 
clearly state that your patch is working as intended - the latency from 
entering the controller until the interrupt to linux device driver is 
~30% lower!.
Remember as I stated above that they don't support that opportunistic 
merging so I will have some fun finding out why it is faster in HW now :-)

>> The patch alone looks very reasonable, so I'd prefer understanding and  
>> fixing the real issue instead of getting it eventually reverted due to  
>> this regression being larger than the one it was intended to fix.
>> In the patch it is clear that hot pages (cold==0) freed in rmqueue_bulk  
>> should behave like before. So maybe the question is "are our pages cold  
>> while they shouldn't be"?
>> Well I don't really have a clue yet to explain how patch e084b exactly  
>> causes that big regression, ideas welcome :-)
>>
>>     
>
> Only theory I have at the moment is that the controller notices it can
> merge requests and either spends a long time figuring out how to do the
> merging or performs worse with merged IO requests.
>
> If the problem is in the driver, oprofile might show where the problem lies
With the effective throughput dropping by such a large amount while 
hardware latency improves by 30% I agree and suggest the issue is in the 
driver.
I'll do some research in breaking down where in our drivers time is lost 
and reply here for advises and comments in regard to what general memory 
management could/should/might do.

Kind regards,
Christian

p.s.
FYI a bit more regression data, now I had the patch identified I made a 
full regression test scaling from 1 to 64 processes.
Comparing just without / with the commit e084b
I wondered, but obviously random read is also suffering from that patch.

Sequential Read
Procs Deviation in %
1              -4.9
2               5.2
4             -82.6
8             -65.6
16            -44.2
32            -30.0
64            -37.7

Random Read
Procs Deviation in %
1             -48.3
2             -45.7
4             -50.5
8             -59.0
16            -61.8
32            -48.3
64            -21.0

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

