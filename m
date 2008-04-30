Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYD3OEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYD3OEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYD3OEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:04:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbYD3OEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:04:14 -0400
Date: Wed, 30 Apr 2008 09:54:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Alasdair Graeme Kergon <agk@redhat.com>
Subject: Re: [PATCH] Optimize lock in queue unplugging
In-Reply-To: <20080430071415.GM12774@kernel.dk>
Message-ID: <Pine.LNX.4.64.0804300944440.23408@engineering.redhat.com>
References: <Pine.LNX.4.64.0804291459030.17110@engineering.redhat.com>
 <20080429192556.GB12774@kernel.dk> <20080429202928.GB10641@linux.vnet.ibm.com>
 <20080430071415.GM12774@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Jens Axboe wrote:

> On Tue, Apr 29 2008, Mike Anderson wrote:
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>> On Tue, Apr 29 2008, Mikulas Patocka wrote:
>>>> Hi
>>>>
>>>> Mike Anderson was doing an OLTP benchmark on a computer with 48 physical
>>>> disks mapped to one logical device via device mapper.
>>>>
>>>> He found that there was a slowdown on request_queue->lock in function
>>>> generic_unplug_device. The slowdown is caused by the fact that when some
>>>> code calls unplug on the device mapper, device mapper calls unplug on all
>>>> physical disks. These unplug calls take the lock, find that the queue is
>>>> already unplugged, release the lock and exit.
>>>>
>>>> With the below patch, performance of the benchmark was increased by 18%
>>>> (the whole OLTP application, not just block layer microbenchmarks).
>>>>
>>>> So I'm submitting this patch for upstream. I think the patch is correct,
>>>> because when more threads call simultaneously plug and unplug, it is
>>>> unspecified, if the queue is or isn't plugged (so the patch can't make
>>>> this worse). And the caller that plugged the queue should unplug it
>>>> anyway. (if it doesn't, there's 3ms timeout).
>>>
>>> Where were these unplug calls coming from? The block layer will
>>> generally only unplug when it is already unplugged, so if you are seeing
>>> so many unplug calls that the patch redues overhead by as much
>>> described, perhaps the callsite is buggy?
>>
>> I do not have direct access the the benchmark setup, but here is the data
>> I have received.
>>
>> The oprofile data was showing ll_rw_blk::generic_unplug_device() as a top
>> routine at 13% of the samples. Annotation of the samples shows hits on
>> spin_lock_irq(q->queue_lock).
>>
>> Here are some sample call traces:
>>
>> Call trace #1
>>
>> kernel:  [<ffffffff80058c6c>] generic_unplug_device+0x5d/0xc6
>> kernel:  [<ffffffff8820ea3e>] :dm_mod:dm_table_unplug_all+0x33/0x41
>> kernel:  [<ffffffff8820cc85>] :dm_mod:dm_unplug_all+0x1d/0x28
>> kernel:  [<ffffffff8005a78a>] blk_backing_dev_unplug+0x56/0x5b
>> kernel:  [<ffffffff80014cdc>] sync_buffer+0x36/0x3f
>> kernel:  [<ffffffff800629a4>] __wait_on_bit+0x40/0x6f
>> kernel:  [<ffffffff80014ca6>] sync_buffer+0x0/0x3f
>> kernel:  [<ffffffff80062a3f>] out_of_line_wait_on_bit+0x6c/0x78
>> kernel:  [<ffffffff8009c474>] wake_bit_function+0x0/0x23
>> kernel:  [<ffffffff88034c85>] :jbd:journal_commit_transaction+0x91f/0x1086
>> kernel:  [<ffffffff8003d038>] lock_timer_base+0x1b/0x3c
>> kernel:  [<ffffffff8803840e>] :jbd:kjournald+0xc1/0x213
>> kernel:  [<ffffffff8009c446>] autoremove_wake_function+0x0/0x2e
>> kernel:  [<ffffffff8009c283>] keventd_create_kthread+0x0/0x61
>> kernel:  [<ffffffff8803834d>] :jbd:kjournald+0x0/0x213
>> kernel:  [<ffffffff8009c283>] keventd_create_kthread+0x0/0x61
>> kernel:  [<ffffffff800321d5>] kthread+0xfe/0x132
>> kernel:  [<ffffffff8005cfb1>] child_rip+0xa/0x11
>> kernel:  [<ffffffff8009c283>] keventd_create_kthread+0x0/0x61
>> kernel:  [<ffffffff800320d7>] kthread+0x0/0x132
>> kernel:  [<ffffffff8005cfa7>] child_rip+0x0/0x11
>>
>> Call trace #2
>> kernel:  [<ffffffff80058c6c>] generic_unplug_device+0x5d/0xc6
>> kernel:  [<ffffffff8820ea3e>] :dm_mod:dm_table_unplug_all+0x33/0x41
>> kernel:  [<ffffffff8820cc85>] :dm_mod:dm_unplug_all+0x1d/0x28
>> kernel:  [<ffffffff8005a78a>] blk_backing_dev_unplug+0x56/0x5b
>> kernel:  [<ffffffff800e8bfe>] __blockdev_direct_IO+0x889/0xaa2
>> kernel:  [<ffffffff88050800>] :ext3:ext3_direct_IO+0xf3/0x18b
>> kernel:  [<ffffffff8804ec84>] :ext3:ext3_get_block+0x0/0xe3
>> kernel:  [<ffffffff800be6bb>] generic_file_direct_IO+0xbd/0xfb
>> kernel:  [<ffffffff8001e637>] generic_file_direct_write+0x60/0xf2
>> kernel:  [<ffffffff80015cfd>] __generic_file_aio_write_nolock+0x2b7/0x3b8
>> kernel:  [<ffffffff8002134f>] generic_file_aio_write+0x65/0xc1
>> kernel:  [<ffffffff8804c192>] :ext3:ext3_file_write+0x16/0x91
>> kernel:  [<ffffffff80017944>] do_sync_write+0xc7/0x104
>> kernel:  [<ffffffff8009c446>] autoremove_wake_function+0x0/0x2e
>> kernel:  [<ffffffff80111400>] free_msg+0x22/0x3c
>> kernel:  [<ffffffff800161c4>] vfs_write+0xce/0x174
>> kernel:  [<ffffffff8004194c>] sys_pwrite64+0x50/0x70
>> kernel:  [<ffffffff8005cde9>] error_exit+0x0/0x84
>> kernel:  [<ffffffff8005c116>] system_call+0x7e/0x83
>
> So it's basically dm calling into blk_unplug() all the time, which
> doesn't check if the queue is plugged. The reason why I didn't like the
> initial patch is that ->unplug_fn() really should not be called unless
> the queue IS plugged. So how about this instead:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=c44993018887e82abd49023e92e8d8b6000e03ed
>
> That's a lot more appropriate, imho.
>
> -- 
> Jens Axboe

This doesn't seem correct to me. The difference between blk_unplug and 
generic_unplug_device is that blk_unplug is called on every type of device 
and generic_unplug_device (pointed to by q->unplug_fn) is a method that is 
called on low-level disk devices.

dm and md redefine q->unplug_fn to point to their own method. On dm and 
md, blk_unplug is called, but generic_unplug_device is not.

So if you have this setup
dm-linear(unplugged) -> disk(plugged)

then, with your patch, a call to blk_unplug(dm-linear) will not unplug the 
disk. With my patch, a call to blk_unplug(dm-linear) will unplug the disk 
--- it calls q->unplug_fn that points to dm_unplug_all, that calls 
blk_unplug again on the disk and that calls generic_unplug_device on disk 
queue.

Mikulas
