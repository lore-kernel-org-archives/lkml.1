Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbXKNTRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbXKNTRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbXKNTQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:16:59 -0500
Received: from palrel11.hp.com ([156.153.255.246]:34330 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759196AbXKNTQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:16:57 -0500
Message-ID: <473B4B53.9090507@hp.com>
Date: Wed, 14 Nov 2007 14:24:03 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, arjan@infradead.org,
       Jens Axboe <jens.axboe@oracle.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>	<20071015114738.6b5a25c7.akpm@linux-foundation.org>	<20071015161315.4fe18e07@bree.surriel.com>	<20071015141236.62b075c6.akpm@linux-foundation.org>	<473B18BA.5000709@hp.com> <20071114091451.d4b110db.akpm@linux-foundation.org>
In-Reply-To: <20071114091451.d4b110db.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc lkml restored, with permission)
>
> On Wed, 14 Nov 2007 10:48:10 -0500 "Alan D. Brunelle" <Alan.Brunelle@hp.com> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> On Mon, 15 Oct 2007 16:13:15 -0400
>>> Rik van Riel <riel@redhat.com> wrote:
>>>
>>>   
>>>       
>>>> Since you have been involved a lot with ext3 development,
>>>> which kinds of workloads do you think will show a performance
>>>> degradation with Arjan's patch?   What should I test?
>>>>     
>>>>         
>>> Gee.  Expect the unexpected ;)
>>>
>>> One problem might be when kjournald is doing its ordered-mode data
>>> writeback at the start of commit.  That writeout will now be
>>> higher-priority and might impact other tasks which are doing synchronous
>>> file overwrites (ie: no commits) or O_DIRECT reads or writes or just plain
>>> old reads.
>>>
>>> If the aggregate number of seeks over the long term is the same as before
>>> then of course the overall throughput should be the same, in which case the
>>> impact might only be upon latency.  However if for some reason the total
>>> number of seeks is increased then there will be throughput impacts as well.
>>>
>>> So as a starting point I guess one could set up a
>>> copy-a-kernel-tree-in-a-loop running in the background and then see what
>>> impact that has upon a large-linear-read, upon a
>>> read-a-different-kernel-tree and upon some database-style multithreaded
>>> O_DIRECT reader/overwriter.
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>   
>>>       
>> Hi folks -
>>
>> I noticed this thread recently (sorry, month late and a dollar short), 
>> but it was very interesting to me, and as I had some cycles yesterday I 
>> did a quick run of what Andrew suggested here (using 2.6.24-rc2 w/out 
>> and then w/ Ajran's patch). After doing the runs last night I'm not 
>> overly happy with the test setup, but before redoing that, I thought I'd 
>> ask to make sure that this patch was still being considered?
>>     
>
> I'd consider its status to be "might be a good idea, more performance
> testing needed".
>
>   
>> And, btw, the results from the first pass were rather mixed -
>>     
>
> ooh, more performance testing.  Thanks
>
>   
>>     * The overwriter task (on an 8GiB file), average over 10 runs:
>>           o 2.6.24 - 300.88226 seconds
>>           o 2.6.24 + Arjan's patch - 403.85505 seconds
>>
>>     * The read-a-different-kernel-tree task, average over 10 runs:
>>           o 2.6.24 - 46.8145945549 seconds
>>           o 2.6.24 + Arjan's patch - 39.6430601119 seconds
>>
>>     * The large-linear-read task (on an 8GiB file), average over 10 runs:
>>           o 2.6.24 - 290.32522 seconds
>>           o 2.6.24 + Arjan's patch - 386.34860 seconds
>>     
>
> These are *large* differences, making this a very signifcant patch.  Much
> care is needed now.
>
> Could you expand a bit on what you're testing here?  I think that in one
> process you're doing a continuous copy-a-kernel-tree and in the other
> process you're the above three things, yes?
>   

The test works like this:

   1. I ensure that the device under test (DUT) is set to run the CFQ
      scheduler.
         1. It is a Fibre Channel 72GiB disk
         2. Single partition...
   2. Put an Ext3 FS on the partition (mkfs.ext3 -b 4096)
   3. Mount the device, and then:
         1. Put an 8GiB file on the new FS
         2. Put 3 copies of a Linux tree (w/ objs & kernel & such) onto
            the FS in separate directories
               1. Note: I'm going to do runs with 6 copies to each
                  directory tree to get to about 4.2GiB per directory tree
   4. Then, for each of the tests:
         1. Remount the device (purge page cache by umount & then mount)
         2. Start up a copy of 1 kernel tree to another tree (you hadn't
            specified if the copy in the background should be to a new
            area or not, so I'm just re-using the same area so we don't
            have to worry about removing the old). I keep doing the copy
            as long as the tests are going
         3. Perform the test (10 times)

The tests are:

    * Linear read of a large file (8GiB)
    * Tree read (foreach file in the tree, dd it to /dev/null)
    * Overwrite of that large file: was doing 256KiB random&direct
      read/writes, will go down to 4KiB read/writes as that is more
      realistic I'd guess

I'm going to try and get the comparisons done by tomorrow, the results 
should be very different due to the changes noted above (going to 4.2GiB 
trees instead of 700MiB, going to 4K instead of 256K read/writes). This 
may cause the runs to be much longer, and then I won't get it done as 
quickly...

> I guess the other things we should look at are the impact on the
> continuously-copy-a-kernel-tree process and also the overall IO throughput.
>  These things will of course be related.  If the overall system-wide IO
> throughput increases with the patch then we probably have a no-brainer.  If
> (as I suspect) the overall IO throughput is decreased then this will be a
> difficult call.
>   

I'll add in continuous 'iostat' grabs, and present data on that too - it 
would contain both generic IO information as well as grabbing 
CPU-related stuff (in particular %system).

>   
>> This was performed on a 4-way IA64 w/ 4GiB RAM w/ a FC disk containing 
>> an Ext3 (4KiB block) FS. The reason I woke up this morning and wasn't 
>> too happy with the benchmarking harness is that a kernel source tree is 
>> less than 1GiB and size, and thus the back ground task of reading it 
>> might all fit in the page cache. To do this right, I'd use another tree 
>> that has >4GiB of data stored in it. (And likewise, I'd change the 
>> read-a-different-kernel-tree task to use a larger tree as well.)
>>     
>
> hm, yes.  Back in the days when I used to do useful things I'd do most
> testing of this sort on 256MB, 128MB or even 64MB machines.  So that data
> would get tossed out of cache quickly so that I could use smaller working
> sets so that the tests could be executed faster.
>
>   
>> But before I do that, I want to make sure that the path is still being 
>> considered.
>>     
>
> Sure, it hasn't been ruled out.  Especially as those time deltas you're
> measuring are so large.  We haven't seen changes in IO throughput like that
> in years.  We just need to work out if they're net-positive or net-negative ;)
>
> This will end up being a pretty large hunk of work I expect.
>   
I'll get results out when I have the changes made to the script 
(outlined above), and the runs done.

Alan
