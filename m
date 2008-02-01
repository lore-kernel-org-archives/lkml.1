Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYBAIlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYBAIlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYBAIl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:41:26 -0500
Received: from brick.kernel.dk ([87.55.233.238]:25895 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbYBAIk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:40:59 -0500
Date: Fri, 1 Feb 2008 09:40:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
Message-ID: <20080201084056.GH15220@kernel.dk>
References: <20080131221436.GA3760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131221436.GA3760@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31 2008, Ingo Molnar wrote:
> 
> 
> Jens,
> 
> AS still has some locking issues - see the lockdep warning below that 
> the x86 test-rig just triggered. Config attached. Never saw this one 
> before. Can send more info if needed.
> 
> 	Ingo
> 
> ---------->
> udev: renamed network interface eth0_rename to eth1
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.24 #183
> ---------------------------------------------
> vol_id/1769 is trying to acquire lock:
>  (&ret->lock#2){.+..}, at: [<ffffffff8047afee>] as_merged_requests+0xa7/0x110
> 
> but task is already holding lock:
>  (&ret->lock#2){.+..}, at: [<ffffffff8047afe6>] as_merged_requests+0x9f/0x110
> 
> other info that might help us debug this:
> 2 locks held by vol_id/1769:
>  #0:  (&q->__queue_lock){.+..}, at: [<ffffffff80473ffb>] __make_request+0x5f/0x3fd
>  #1:  (&ret->lock#2){.+..}, at: [<ffffffff8047afe6>] as_merged_requests+0x9f/0x110
> 
> stack backtrace:
> Pid: 1769, comm: vol_id Not tainted 2.6.24 #183
> 
> Call Trace:
>  [<ffffffff8024f2b9>] print_deadlock_bug+0xcb/0xd6
>  [<ffffffff8024f314>] check_deadlock+0x50/0x60
>  [<ffffffff80250c41>] validate_chain+0x1ed/0x289
>  [<ffffffff80251224>] __lock_acquire+0x547/0x608
>  [<ffffffff8047afee>] ? as_merged_requests+0xa7/0x110
>  [<ffffffff8025137e>] lock_acquire+0x99/0xc6
>  [<ffffffff8047afee>] ? as_merged_requests+0xa7/0x110
>  [<ffffffff8090004e>] _spin_lock+0x34/0x41
>  [<ffffffff8047afee>] as_merged_requests+0xa7/0x110
>  [<ffffffff80471184>] elv_merge_requests+0x28/0x51
>  [<ffffffff80476c1b>] attempt_merge+0xf5/0x14b
>  [<ffffffff80476cc4>] attempt_back_merge+0x27/0x30
>  [<ffffffff8047411c>] __make_request+0x180/0x3fd
>  [<ffffffff80472fb0>] generic_make_request+0x355/0x390
>  [<ffffffff802ac5ed>] ? create_empty_buffers+0xa0/0xa9
>  [<ffffffff804744ff>] submit_bio+0xfe/0x107
>  [<ffffffff802abfc4>] submit_bh+0xe7/0x10b
>  [<ffffffff802aefcd>] block_read_full_page+0x289/0x2a5
>  [<ffffffff802b1d7f>] ? blkdev_get_block+0x0/0x4c
>  [<ffffffff80268422>] ? add_to_page_cache+0xa1/0xd3
>  [<ffffffff802b0ef7>] blkdev_readpage+0x13/0x15
>  [<ffffffff8026f3fb>] read_pages+0x81/0xa1
>  [<ffffffff8026f5b0>] __do_page_cache_readahead+0x195/0x1b8
>  [<ffffffff80267fda>] ? find_get_page+0x58/0x64
>  [<ffffffff8026f7f4>] ondemand_readahead+0xa1/0x155
>  [<ffffffff8026f93b>] page_cache_sync_readahead+0x17/0x19
>  [<ffffffff80268c3f>] do_generic_mapping_read+0xa8/0x372
>  [<ffffffff80267d32>] ? file_read_actor+0x0/0x1ac
>  [<ffffffff80269f94>] generic_file_aio_read+0x125/0x164
>  [<ffffffff8028b9cc>] do_sync_read+0xeb/0x132
>  [<ffffffff80250416>] ? mark_held_locks+0x59/0x75
>  [<ffffffff8024549f>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff802515f9>] ? __lock_release+0x5b/0x64
>  [<ffffffff808fee67>] ? mutex_unlock+0x9/0xb
>  [<ffffffff808fee33>] ? __mutex_unlock_slowpath+0x10e/0x139
>  [<ffffffff802505d7>] ? trace_hardirqs_on+0xfe/0x128
>  [<ffffffff8028c0c4>] vfs_read+0xa4/0xe3
>  [<ffffffff8028c440>] sys_read+0x47/0x6f
>  [<ffffffff8020c10a>] system_call_after_swapgs+0x8a/0x8f

Are you sure this triggered with the as fixup in place? It looks like
the same bug.

-- 
Jens Axboe

