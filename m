Return-Path: <linux-kernel-owner+w=401wt.eu-S1761743AbXFAQFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761743AbXFAQFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbXFAQFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:05:30 -0400
Received: from mail.tmr.com ([64.65.253.246]:36003 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbXFAQF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:05:28 -0400
Message-ID: <466043A2.5040002@tmr.com>
Date: Fri, 01 Jun 2007 12:04:50 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: David Chinner <dgc@sgi.com>, david@lang.hm,
       Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
  and dm/md.
References: <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <20070531070656.GK32105@kernel.dk> <465ECDDB.9030304@tmr.com> <20070531133649.GY32105@kernel.dk>
In-Reply-To: <20070531133649.GY32105@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, May 31 2007, Bill Davidsen wrote:
>   
>> Jens Axboe wrote:
>>     
>>> On Thu, May 31 2007, David Chinner wrote:
>>>  
>>>       
>>>> On Thu, May 31, 2007 at 08:26:45AM +0200, Jens Axboe wrote:
>>>>    
>>>>         
>>>>> On Thu, May 31 2007, David Chinner wrote:
>>>>>      
>>>>>           
>>>>>> IOWs, there are two parts to the problem:
>>>>>>
>>>>>> 	1 - guaranteeing I/O ordering
>>>>>> 	2 - guaranteeing blocks are on persistent storage.
>>>>>>
>>>>>> Right now, a single barrier I/O is used to provide both of these
>>>>>> guarantees. In most cases, all we really need to provide is 1); the
>>>>>> need for 2) is a much rarer condition but still needs to be
>>>>>> provided.
>>>>>>
>>>>>>        
>>>>>>             
>>>>>>> if I am understanding it correctly, the big win for barriers is that 
>>>>>>> you do NOT have to stop and wait until the data is on persistant media 
>>>>>>> before you can continue.
>>>>>>>          
>>>>>>>               
>>>>>> Yes, if we define a barrier to only guarantee 1), then yes this
>>>>>> would be a big win (esp. for XFS). But that requires all filesystems
>>>>>> to handle sync writes differently, and sync_blockdev() needs to
>>>>>> call blkdev_issue_flush() as well....
>>>>>>
>>>>>> So, what do we do here? Do we define a barrier I/O to only provide
>>>>>> ordering, or do we define it to also provide persistent storage
>>>>>> writeback? Whatever we decide, it needs to be documented....
>>>>>>        
>>>>>>             
>>>>> The block layer already has a notion of the two types of barriers, with
>>>>> a very small amount of tweaking we could expose that. There's absolutely
>>>>> zero reason we can't easily support both types of barriers.
>>>>>      
>>>>>           
>>>> That sounds like a good idea - we can leave the existing
>>>> WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
>>>> behaviour that only guarantees ordering. The filesystem can then
>>>> choose which to use where appropriate....
>>>>    
>>>>         
>>> Precisely. The current definition of barriers are what Chris and I came
>>> up with many years ago, when solving the problem for reiserfs
>>> originally. It is by no means the only feasible approach.
>>>
>>> I'll add a WRITE_ORDERED command to the #barrier branch, it already
>>> contains the empty-bio barrier support I posted yesterday (well a
>>> slightly modified and cleaned up version).
>>>
>>>  
>>>       
>> Wait. Do filesystems expect (depend on) anything but ordering now? Does 
>> md? Having users of barriers as they currently behave suddenly getting 
>> SYNC behavior where they expect ORDERED is likely to have a negative 
>> effect on performance. Or do I misread what is actually guaranteed by 
>> WRITE_BARRIER now, and a flush is currently happening in all cases?
>>     
>
> See the above stuff you quote, it's answered there. It's not a change,
> this is how the Linux barrier write has always worked since I first
> implemented it. What David and I are talking about is adding a more
> relaxed version as well, that just implies ordering.
>   

I was reading the documentation in block/biodoc.txt, which seems to just 
say ordered:

    1.2.1 I/O Barriers

    There is a way to enforce strict ordering for i/os through barriers.
    All requests before a barrier point must be serviced before the barrier
    request and any other requests arriving after the barrier will not be
    serviced until after the barrier has completed. This is useful for
    higher
    level control on write ordering, e.g flushing a log of committed updates
    to disk before the corresponding updates themselves.

    A flag in the bio structure, BIO_BARRIER is used to identify a
    barrier i/o.
    The generic i/o scheduler would make sure that it places the barrier
    request and
    all other requests coming after it after all the previous requests
    in the
    queue. Barriers may be implemented in different ways depending on the
    driver. A SCSI driver for example could make use of ordered tags to
    preserve the necessary ordering with a lower impact on throughput.
    For IDE
    this might be two sync cache flush: a pre and post flush when
    encountering
    a barrier write.

The "flush" comment is associated with IDE, so it wasn't clear that the 
device cache is always cleared to force the data to the platter.

>> And will this also be available to user space f/s, since I just proposed 
>> a project which uses one? :-(
>>     
>
> I see several uses for that, so I'd hope so.
>
>   
>> I think the goal is good, more choice is almost always better choice, I 
>> just want to be sure there won't be big disk performance regressions.
>>     
>
> We can't get more heavy weight than the current barrier, it's about as
> conservative as you can get.
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

