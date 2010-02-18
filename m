Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab0BRC5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:57:53 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44174 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755951Ab0BRC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:57:51 -0500
X-Greylist: delayed 1096 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2010 21:57:51 EST
Date: Thu, 18 Feb 2010 03:39:35 +0100
From: Jan Kara <jack@suse.cz>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hung task - sync - 2.6.33-rc7  w/md6 multicore rebuild in
	process
Message-ID: <20100218023934.GC8897@atrey.karlin.mff.cuni.cz>
References: <4B76D87E.3050107@majjas.com> <4B76EC83.5050401@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B76EC83.5050401@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2/13/2010 11:51 AM, Michael Breuer wrote:
>> Scenario:
>>
>> 1. raid6 (software - 6 1Tb sata drives) doing a resync (multi core  
>> enabled)
>> 2. rebuilding kernel (rc8)
>> 3. system became sluggish - top & vmstat showed all 12Gb ram used -  
>> albeit 10g of fs cache. It seemed as though relcaim of fs cache became  
>> really slow once there were no more "free" pages.
>> vmstat <after hung task reported - don't have from before>
>> procs -----------memory---------- ---swap-- -----io---- --system--  
>> -----cpu-----
>>    r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us  
>> sy id wa st
>>    0  1    808 112476 347592 9556952    0    0    39   388  158  189   
>> 1 18 77  4  0
>> 4. Worrying a bit about the looming instability, I typed, "sync."
>> 5. sync took a long time, and was reported by the kernel as a hung  
>> task (repeatedly) - see below.
>> 6. entering additional sync commands also hang (unsuprising, but  
>> figured I'd try as non-root).
>> 7. The running sync (pid 11975) cannot be killed.
>> 8. echo 1 > drop_caches does clear the fs cache. System behaves better  
>> after this (but sync is still hung).
>>
>> config attached.
>>
>> Running with sky2 dma patches (in rc8) and increased the audit name  
>> space to avoid the flood of name space maxed warnings.
>>
>> My current plan is to let the raid rebuild complete and then reboot  
>> (to rc8 if the bits made it to disk)... maybe with a backup of  
>> recently changed files to an external system.
>>
>> Feb 13 10:54:13 mail kernel: INFO: task sync:11975 blocked for more  
>> than 120 seconds.
>> Feb 13 10:54:13 mail kernel: "echo 0 >  
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Feb 13 10:54:13 mail kernel: sync          D 0000000000000002     0  
>> 11975   6433 0x00000000
>> Feb 13 10:54:13 mail kernel: ffff8801c45f3da8 0000000000000082  
>> ffff8800282f5948 ffff8800282f5920
>> Feb 13 10:54:13 mail kernel: ffff88032f785d78 ffff88032f785d40  
>> 000000030c37a771 0000000000000282
>> Feb 13 10:54:13 mail kernel: ffff8801c45f3fd8 000000000000f888  
>> ffff88032ca00000 ffff8801c61c9750
>> Feb 13 10:54:13 mail kernel: Call Trace:
>> Feb 13 10:54:13 mail kernel: [<ffffffff81154730>] ?  
>> bdi_sched_wait+0x0/0x20
>> Feb 13 10:54:13 mail kernel: [<ffffffff8115473e>] bdi_sched_wait+0xe/0x20
>> Feb 13 10:54:13 mail kernel: [<ffffffff81537b4f>] __wait_on_bit+0x5f/0x90
>> Feb 13 10:54:13 mail kernel: [<ffffffff81154730>] ?  
>> bdi_sched_wait+0x0/0x20
>> Feb 13 10:54:13 mail kernel: [<ffffffff81537bf8>]  
>> out_of_line_wait_on_bit+0x78/0x90
>> Feb 13 10:54:13 mail kernel: [<ffffffff81078650>] ?  
>> wake_bit_function+0x0/0x50
>> Feb 13 10:54:13 mail kernel: [<ffffffff8104ac55>] ?  
>> wake_up_process+0x15/0x20
>> Feb 13 10:54:13 mail kernel: [<ffffffff81155daf>]  
>> bdi_sync_writeback+0x6f/0x80
>> Feb 13 10:54:13 mail kernel: [<ffffffff81155de2>]  
>> sync_inodes_sb+0x22/0x100
>> Feb 13 10:54:13 mail kernel: [<ffffffff81159902>]  
>> __sync_filesystem+0x82/0x90
>> Feb 13 10:54:13 mail kernel: [<ffffffff81159a04>]  
>> sync_filesystems+0xf4/0x120
>> Feb 13 10:54:13 mail kernel: [<ffffffff81159a91>] sys_sync+0x21/0x40
>> Feb 13 10:54:13 mail kernel: [<ffffffff8100b0f2>]  
>> system_call_fastpath+0x16/0x1b
>>
>> <this repeats every 120 seconds - all the same traceback>
>>
>>
>>
>>
> Note: this cleared after about 90 minutes - sync eventually completed.  
> I'm thinking that with multicore enabled the resync is able to starve  
> out normal system activities that weren't starved w/o multicore.
  Hmm, it is a bug in writeback code. But as Linus pointed out, it's not really
clear why it's *so* slow. So when it happens again, could you please sample for
a while (like every second for 30 seconds) stacks of blocked tasks via
Alt-Sysrq-W? I'd like to see where flusher threads are hanging... Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
