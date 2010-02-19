Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0BSCbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 21:31:39 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:59564 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0BSCbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 21:31:38 -0500
Date: Thu, 18 Feb 2010 21:31:41 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Hung task - sync - 2.6.33-rc7  w/md6 multicore rebuild in	process
In-reply-to: <20100219014349.GD28392@discord.disaster>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4B7DF80D.6090309@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B76D87E.3050107@majjas.com> <4B76EC83.5050401@majjas.com>
 <20100218023934.GC8897@atrey.karlin.mff.cuni.cz> <4B7D74BE.6030906@majjas.com>
 <20100219014349.GD28392@discord.disaster>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/2010 8:43 PM, Dave Chinner wrote:
> On Thu, Feb 18, 2010 at 12:11:26PM -0500, Michael Breuer wrote:
>    
>> On 02/17/2010 09:39 PM, Jan Kara wrote:
>>      
>>>> On 2/13/2010 11:51 AM, Michael Breuer wrote:
>>>>
>>>>          
>>>>> Scenario:
>>>>>
>>>>> 1. raid6 (software - 6 1Tb sata drives) doing a resync (multi core
>>>>> enabled)
>>>>> 2. rebuilding kernel (rc8)
>>>>> 3. system became sluggish - top&   vmstat showed all 12Gb ram used -
>>>>> albeit 10g of fs cache. It seemed as though relcaim of fs cache became
>>>>> really slow once there were no more "free" pages.
>>>>> vmstat<after hung task reported - don't have from before>
>>>>> procs -----------memory---------- ---swap-- -----io---- --system--
>>>>> -----cpu-----
>>>>>      r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us
>>>>> sy id wa st
>>>>>      0  1    808 112476 347592 9556952    0    0    39   388  158  189
>>>>> 1 18 77  4  0
>>>>> 4. Worrying a bit about the looming instability, I typed, "sync."
>>>>> 5. sync took a long time, and was reported by the kernel as a hung
>>>>> task (repeatedly) - see below.
>>>>> 6. entering additional sync commands also hang (unsuprising, but
>>>>> figured I'd try as non-root).
>>>>> 7. The running sync (pid 11975) cannot be killed.
>>>>> 8. echo 1>   drop_caches does clear the fs cache. System behaves better
>>>>> after this (but sync is still hung).
>>>>>
>>>>> config attached.
>>>>>
>>>>> Running with sky2 dma patches (in rc8) and increased the audit name
>>>>> space to avoid the flood of name space maxed warnings.
>>>>>
>>>>> My current plan is to let the raid rebuild complete and then reboot
>>>>> (to rc8 if the bits made it to disk)... maybe with a backup of
>>>>> recently changed files to an external system.
>>>>>
>>>>> Feb 13 10:54:13 mail kernel: INFO: task sync:11975 blocked for more
>>>>> than 120 seconds.
>>>>> Feb 13 10:54:13 mail kernel: "echo 0>
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Feb 13 10:54:13 mail kernel: sync          D 0000000000000002     0
>>>>> 11975   6433 0x00000000
>>>>> Feb 13 10:54:13 mail kernel: ffff8801c45f3da8 0000000000000082
>>>>> ffff8800282f5948 ffff8800282f5920
>>>>> Feb 13 10:54:13 mail kernel: ffff88032f785d78 ffff88032f785d40
>>>>> 000000030c37a771 0000000000000282
>>>>> Feb 13 10:54:13 mail kernel: ffff8801c45f3fd8 000000000000f888
>>>>> ffff88032ca00000 ffff8801c61c9750
>>>>> Feb 13 10:54:13 mail kernel: Call Trace:
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81154730>] ?
>>>>> bdi_sched_wait+0x0/0x20
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff8115473e>] bdi_sched_wait+0xe/0x20
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81537b4f>] __wait_on_bit+0x5f/0x90
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81154730>] ?
>>>>> bdi_sched_wait+0x0/0x20
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81537bf8>]
>>>>> out_of_line_wait_on_bit+0x78/0x90
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81078650>] ?
>>>>> wake_bit_function+0x0/0x50
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff8104ac55>] ?
>>>>> wake_up_process+0x15/0x20
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81155daf>]
>>>>> bdi_sync_writeback+0x6f/0x80
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81155de2>]
>>>>> sync_inodes_sb+0x22/0x100
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81159902>]
>>>>> __sync_filesystem+0x82/0x90
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81159a04>]
>>>>> sync_filesystems+0xf4/0x120
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff81159a91>] sys_sync+0x21/0x40
>>>>> Feb 13 10:54:13 mail kernel: [<ffffffff8100b0f2>]
>>>>> system_call_fastpath+0x16/0x1b
>>>>>
>>>>> <this repeats every 120 seconds - all the same traceback>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>            
>>>> Note: this cleared after about 90 minutes - sync eventually completed.
>>>> I'm thinking that with multicore enabled the resync is able to starve
>>>> out normal system activities that weren't starved w/o multicore.
>>>>
>>>>          
>>>     Hmm, it is a bug in writeback code. But as Linus pointed out, it's not really
>>> clear why it's *so* slow. So when it happens again, could you please sample for
>>> a while (like every second for 30 seconds) stacks of blocked tasks via
>>> Alt-Sysrq-W? I'd like to see where flusher threads are hanging... Thanks.
>>>
>>>        
>> Ok - got it. Sync is still spinning, btw... attaching log extract as
>> well as dmesg output.
>>      
> Looks like barriers are playing a part in this.
>
>    
>>   [<ffffffff8104aac6>] ? try_to_wake_up+0x2d6/0x410
>>   [<ffffffff81078920>] ? prepare_to_wait+0x60/0x90
>>   [<ffffffff81200fbd>] jbd2_log_wait_commit+0xbd/0x130
>>   [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
>>   [<ffffffff811fa7bb>] jbd2_journal_stop+0x24b/0x2b0
>>   [<ffffffff811f9915>] ? jbd2_journal_start+0xb5/0x100
>>   [<ffffffff811fa847>] jbd2_journal_force_commit+0x27/0x30
>>   [<ffffffff811d0587>] ext4_force_commit+0x27/0x40
>>   [<ffffffff811c3a55>] ext4_write_inode+0x75/0x100
>>   [<ffffffff81155104>] writeback_single_inode+0x294/0x3b0
>>   [<ffffffff8115567a>] writeback_inodes_wb+0x31a/0x4c0
>>   [<ffffffff8115593a>] wb_writeback+0x11a/0x1e0
>>   [<ffffffff815379f6>] ? schedule_timeout+0x196/0x2f0
>>   [<ffffffff81155c1f>] wb_do_writeback+0x12f/0x1a0
>>   [<ffffffff81155ce3>] bdi_writeback_task+0x53/0xe0
>>   [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
>>   [<ffffffff810fea11>] bdi_start_fn+0x71/0xe0
>>   [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
>>   [<ffffffff81078106>] kthread+0x96/0xa0
>>   [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
>>   [<ffffffff81539f3d>] ? restore_args+0x0/0x30
>>   [<ffffffff81078070>] ? kthread+0x0/0xa0
>>   [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
>>      
> This is probably where the barrier IOs are coming from.  With a RAID
> resync going on (so all IO is going to be slow to begin with) and
> writeback is causing barriers to be issued (which are really slow on
> software RAID5/6), having sync take so long is not out of the
> question if you have lots of dirty inodes to write back. A kernel
> compile will generate lots of dirty inodes.
>
> Even taking the barrier IOs out of the question, I've seen reports
> of sync or unmount taking over 10 hours to complete on software
> RAID5 because there were hundreds of thousands of dirty inodes to
> write back and each inode being written back caused a synchronous
> RAID5 RMW cycle to occur. Hence writeback could only clean 50
> inodes/sec because as soon as RMW cycles RAID5/6 devices start
> they go slower than single spindle devices.  This sounds very
> similar to what you are seeing here,
>
> i.e. The reports don't indicate to me that there is a bug in the
> writeback code, just your disk subsystem has very, very low
> throughput in these conditions....
>
> Cheers,
>
> Dave.
>    
Probably true... and the system does recover. The only thing I'd point 
out is that the subsystem isn't (or perhaps shouldn't) be this sluggish. 
I hypothesize that the low throughput under these condition is a result of:
1) multicore raid support (pushing the resync at higher rates)
2) time spent in fs cache reclaim. The sync slowdown only occurs when fs 
cache is in heavy (10Gb) use.

I actually could not recreate the issue until I did a grep -R foo /usr/ 
 >/dev/null to force high fs cache utilization. For what it's worth, two 
kernel rebuilds (many dirty inodes) and then a sync with about 12Mb 
dirty (/proc/meminfo) didn't cause an issue. The issue only happens when 
fs cache is heavily used. I also never saw this before enabling 
multicore raid.


