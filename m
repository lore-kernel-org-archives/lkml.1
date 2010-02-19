Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0BSECQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 23:02:16 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:47953 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754372Ab0BSECP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 23:02:15 -0500
Date: Fri, 19 Feb 2010 15:02:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hung task - sync - 2.6.33-rc7  w/md6 multicore rebuild in
	process
Message-ID: <20100219040206.GE28392@discord.disaster>
References: <4B76D87E.3050107@majjas.com> <4B76EC83.5050401@majjas.com> <20100218023934.GC8897@atrey.karlin.mff.cuni.cz> <4B7D74BE.6030906@majjas.com> <20100219014349.GD28392@discord.disaster> <4B7DF80D.6090309@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7DF80D.6090309@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:31:41PM -0500, Michael Breuer wrote:
> On 2/18/2010 8:43 PM, Dave Chinner wrote:
>> On Thu, Feb 18, 2010 at 12:11:26PM -0500, Michael Breuer wrote:
>>> On 02/17/2010 09:39 PM, Jan Kara wrote:
>>>>     Hmm, it is a bug in writeback code. But as Linus pointed out, it's not really
>>>> clear why it's *so* slow. So when it happens again, could you please sample for
>>>> a while (like every second for 30 seconds) stacks of blocked tasks via
>>>> Alt-Sysrq-W? I'd like to see where flusher threads are hanging... Thanks.
>>>>
>>>>        
>>> Ok - got it. Sync is still spinning, btw... attaching log extract as
>>> well as dmesg output.
>>>      
>> Looks like barriers are playing a part in this.
>>    
>>>   [<ffffffff8104aac6>] ? try_to_wake_up+0x2d6/0x410
>>>   [<ffffffff81078920>] ? prepare_to_wait+0x60/0x90
>>>   [<ffffffff81200fbd>] jbd2_log_wait_commit+0xbd/0x130
>>>   [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
>>>   [<ffffffff811fa7bb>] jbd2_journal_stop+0x24b/0x2b0
>>>   [<ffffffff811f9915>] ? jbd2_journal_start+0xb5/0x100
>>>   [<ffffffff811fa847>] jbd2_journal_force_commit+0x27/0x30
>>>   [<ffffffff811d0587>] ext4_force_commit+0x27/0x40
>>>   [<ffffffff811c3a55>] ext4_write_inode+0x75/0x100
>>>   [<ffffffff81155104>] writeback_single_inode+0x294/0x3b0
>>>   [<ffffffff8115567a>] writeback_inodes_wb+0x31a/0x4c0
>>>   [<ffffffff8115593a>] wb_writeback+0x11a/0x1e0
>>>   [<ffffffff815379f6>] ? schedule_timeout+0x196/0x2f0
>>>   [<ffffffff81155c1f>] wb_do_writeback+0x12f/0x1a0
>>>   [<ffffffff81155ce3>] bdi_writeback_task+0x53/0xe0
>>>   [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
>>>   [<ffffffff810fea11>] bdi_start_fn+0x71/0xe0
>>>   [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
>>>   [<ffffffff81078106>] kthread+0x96/0xa0
>>>   [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
>>>   [<ffffffff81539f3d>] ? restore_args+0x0/0x30
>>>   [<ffffffff81078070>] ? kthread+0x0/0xa0
>>>   [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
>>>      
>> This is probably where the barrier IOs are coming from.  With a RAID
>> resync going on (so all IO is going to be slow to begin with) and
>> writeback is causing barriers to be issued (which are really slow on
>> software RAID5/6), having sync take so long is not out of the
>> question if you have lots of dirty inodes to write back. A kernel
>> compile will generate lots of dirty inodes.
>>
>> Even taking the barrier IOs out of the question, I've seen reports
>> of sync or unmount taking over 10 hours to complete on software
>> RAID5 because there were hundreds of thousands of dirty inodes to
>> write back and each inode being written back caused a synchronous
>> RAID5 RMW cycle to occur. Hence writeback could only clean 50
>> inodes/sec because as soon as RMW cycles RAID5/6 devices start
>> they go slower than single spindle devices.  This sounds very
>> similar to what you are seeing here,
>>
>> i.e. The reports don't indicate to me that there is a bug in the
>> writeback code, just your disk subsystem has very, very low
>> throughput in these conditions....
>
> Probably true... and the system does recover. The only thing I'd point  
> out is that the subsystem isn't (or perhaps shouldn't) be this sluggish.  
> I hypothesize that the low throughput under these condition is a result 
> of:
> 1) multicore raid support (pushing the resync at higher rates)

Possibly, though barrier support for RAID5/6 is shiny new as well.

> 2) time spent in fs cache reclaim. The sync slowdown only occurs when fs  
> cache is in heavy (10Gb) use.

Not surprising ;)

> I actually could not recreate the issue until I did a grep -R foo /usr/  
> >/dev/null to force high fs cache utilization. For what it's worth, two  
> kernel rebuilds (many dirty inodes) and then a sync with about 12Mb  
> dirty (/proc/meminfo) didn't cause an issue. The issue only happens when  
> fs cache is heavily used. I also never saw this before enabling  
> multicore raid.

"grep -R foo /usr/" will dirty every inode that touchs (atime) and
they have to be written back out. That's almost certainly creating
more dirty inodes than a kernel build - there are about 400,000
inodes under /usr on my system. That would be enough to trigger very
long sync times if inode writeback is slow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
