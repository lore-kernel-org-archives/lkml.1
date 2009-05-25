Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZEYIsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZEYIsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZEYIsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:48:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40457 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZEYIsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:48:05 -0400
Date: Mon, 25 May 2009 10:48:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
Message-ID: <20090525084806.GN11363@kernel.dk>
References: <20090520092528.GP11363@kernel.dk> <20090520111910.GS11363@kernel.dk> <1242887627.2560.45.camel@ymzhang> <20090521091033.GA6987@duck.suse.cz> <1242955708.2560.52.camel@ymzhang> <20090522081539.GM11363@kernel.dk> <20090522204401.GQ11363@kernel.dk> <20090523191500.GV11363@kernel.dk> <1243238558.2560.99.camel@ymzhang> <1243241032.2560.114.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243241032.2560.114.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25 2009, Zhang, Yanmin wrote:
> On Mon, 2009-05-25 at 16:02 +0800, Zhang, Yanmin wrote:
> > On Sat, 2009-05-23 at 21:15 +0200, Jens Axboe wrote:
> > > On Fri, May 22 2009, Jens Axboe wrote:
> > > > Please try with this combined patch against what you are running now, it
> > > > should resolve the issue. It needs a bit more work, but I'm running out
> > > > of time today. I'l get it finalized, cleaned up, and integrated. Then
> > > > I'll post a new revision of the patch set.
> > > > 
> > > 
> > > This one has been tested good and has a few more tweaks. So please try
> > > that! It should be pretty close to final now, will repost the series on
> > > monday.
> > I ran the workload for 10 times and didn't trigger it yet. So the bug is
> > fixed.
> > 
> > yanmin
> Another issue of V4 is fio hangs when testing fio_sync_read_4k. It seems it hangs
> when prepareing the data (part data is ready).
> cpu idle is 100%. It happens randomly. 
> 
> INFO: task fio:6566 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> fio           D ffff8800280a9300  4976  6566   6564
>  ffff88022f8c0de0 0000000000000086 ffff8800b584fcb0 000000000000000a
>  0000000000000002 ffff88022df0c560 ffff88022df0c8e8 000000010000daea
>  ffffe200027457d8 0000000000000246 000000c10000000d 0000000000000313
> Call Trace:
>  [<ffffffff802b6897>] ? bdi_sched_wait+0x0/0xd
>  [<ffffffff807254f6>] ? schedule+0x9/0x1d
>  [<ffffffff802b68a0>] ? bdi_sched_wait+0x9/0xd
>  [<ffffffff80725aa5>] ? __wait_on_bit+0x40/0x6f
>  [<ffffffff802b6897>] ? bdi_sched_wait+0x0/0xd
>  [<ffffffff80725b40>] ? out_of_line_wait_on_bit+0x6c/0x78
>  [<ffffffff8024a42e>] ? wake_bit_function+0x0/0x23
>  [<ffffffff802b62a4>] ? bdi_queue_writeback+0x7a/0xe6
>  [<ffffffff802b6461>] ? bdi_start_writeback+0x63/0x6c
>  [<ffffffff8027a3a9>] ? balance_dirty_pages_ratelimited_nr+0x2a9/0x2b8
>  [<ffffffff80274c90>] ? generic_file_buffered_write+0x1d8/0x2b2
>  [<ffffffff80275230>] ? __generic_file_aio_write_nolock+0x33b/0x3a5
>  [<ffffffff802866ab>] ? handle_mm_fault+0x2e5/0x6f3
>  [<ffffffff80275498>] ? generic_file_aio_write+0x61/0xc1
>  [<ffffffff80315efe>] ? ext3_file_write+0x16/0x94
>  [<ffffffff8029d8c2>] ? do_sync_write+0xc9/0x10c
>  [<ffffffff8024a400>] ? autoremove_wake_function+0x0/0x2e
>  [<ffffffff8024c8f6>] ? __hrtimer_start_range_ns+0x101/0x114
>  [<ffffffff8029dfcf>] ? vfs_write+0xad/0x136
>  [<ffffffff8029e513>] ? sys_write+0x45/0x6e
>  [<ffffffff8020b9ab>] ? system_call_fastpath+0x16/0x1b
> 
> 
> I didn't run into it with the 3 new patches and am not sure if it's
> resolved.

That's the wake_up_bit() race that was fixed with one of the 3 new
patches, so v5/6 should be good here too.

-- 
Jens Axboe

