Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0CCLuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:50:19 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50042 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab0CCLuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:50:18 -0500
Date: Wed, 3 Mar 2010 12:50:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: John Hughes <john@Calva.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++
	on different filesystems seems to deadlock in sync
Message-ID: <20100303115015.GN5768@kernel.dk>
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8E517E.3010702@Calva.COM>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03 2010, John Hughes wrote:
> Andrew Morton wrote:
>> When the system is stuck, please run
>>
>> 	echo w > /proc/sysrq-trigger
>>   
> Ok, we have:

Is IO still going on, or does it appear to be stuck? From the traces
below, we have various procs caught in waiting for a request. So if
things are totally stuck, it could be some race in there.


>
> [ 1128.964403] kjournald     D 0000000000000000     0  2196      2 0x00000000
> [ 1128.964407]  ffffffff8144b1f0 0000000000000046 0000000000000000 ffffffff811837bb
> [ 1128.964409]  ffff88063d1762e0 ffff880340002c80 000000000000f8a0 ffff88063c6e9fd8
> [ 1128.964412]  00000000000155c0 00000000000155c0 ffff88063d1762e0 ffff88063d1765d8
> [ 1128.964415] Call Trace:
> [ 1128.964423]  [<ffffffff811837bb>] ? cfq_set_request+0x2af/0x319
> [ 1128.964427]  [<ffffffff811780d7>] ? get_request+0x7e/0x2ba
> [ 1128.964431]  [<ffffffff812edf36>] ? io_schedule+0x73/0xb7
> [ 1128.964433]  [<ffffffff81178403>] ? get_request_wait+0xf0/0x188
> [ 1128.964437]  [<ffffffff81064a56>] ? autoremove_wake_function+0x0/0x2e
> [ 1128.964441]  [<ffffffff8117b28d>] ? blk_recount_segments+0x17/0x27
> [ 1128.964443]  [<ffffffff81178792>] ? __make_request+0x2f7/0x428
> [ 1128.964447]  [<ffffffff81176f6f>] ? generic_make_request+0x299/0x2f9
> [ 1128.964450]  [<ffffffff811770a5>] ? submit_bio+0xd6/0xf2
> [ 1128.964455]  [<ffffffff8110b50b>] ? submit_bh+0xf5/0x115
> [ 1128.964463]  [<ffffffffa017f5a2>] ? journal_commit_transaction+0x8d9/0xe2b [jbd]
> [ 1128.964467]  [<ffffffffa01823fb>] ? kjournald+0xdf/0x226 [jbd]
> [ 1128.964469]  [<ffffffff81064a56>] ? autoremove_wake_function+0x0/0x2e
> [ 1128.964472]  [<ffffffffa018231c>] ? kjournald+0x0/0x226 [jbd]
> [ 1128.964474]  [<ffffffff81064789>] ? kthread+0x79/0x81
> [ 1128.964479]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
> [ 1128.964481]  [<ffffffff81064710>] ? kthread+0x0/0x81
> [ 1128.964483]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
>
> And three of (flush-8:32, flush-8:48 and flush-8:64):
>
> [ 1128.964485] flush-8:32    D 0000000000000000     0  2221      2 0x00000000
> [ 1128.964488]  ffff88033e44b880 0000000000000046 0000000000000000 ffffffff811837bb
> [ 1128.964490]  ffff88063d177100 0000001000022c80 000000000000f8a0 ffff88063b66dfd8
> [ 1128.964493]  00000000000155c0 00000000000155c0 ffff88063d177100 ffff88063d1773f8
> [ 1128.964495] Call Trace:
> [ 1128.964497]  [<ffffffff811837bb>] ? cfq_set_request+0x2af/0x319
> [ 1128.964500]  [<ffffffff811780d7>] ? get_request+0x7e/0x2ba
> [ 1128.964502]  [<ffffffff812edf36>] ? io_schedule+0x73/0xb7
> [ 1128.964504]  [<ffffffff81178403>] ? get_request_wait+0xf0/0x188
> [ 1128.964506]  [<ffffffff81064a56>] ? autoremove_wake_function+0x0/0x2e
> [ 1128.964508]  [<ffffffff81178792>] ? __make_request+0x2f7/0x428
> [ 1128.964511]  [<ffffffff81176f6f>] ? generic_make_request+0x299/0x2f9
> [ 1128.964514]  [<ffffffff810114ce>] ? common_interrupt+0xe/0x13
> [ 1128.964516]  [<ffffffff811770a5>] ? submit_bio+0xd6/0xf2
> [ 1128.964518]  [<ffffffff8110b50b>] ? submit_bh+0xf5/0x115
> [ 1128.964522]  [<ffffffff8110da7c>] ? __block_write_full_page+0x1d6/0x2ac
> [ 1128.964525]  [<ffffffff8110c801>] ? end_buffer_async_write+0x0/0x13b
> [ 1128.964528]  [<ffffffff8110fabc>] ? blkdev_get_block+0x0/0x57
> [ 1128.964532]  [<ffffffff810b9572>] ? __writepage+0xa/0x25
> [ 1128.964534]  [<ffffffff810b9bf9>] ? write_cache_pages+0x20b/0x327
> [ 1128.964536]  [<ffffffff810b9568>] ? __writepage+0x0/0x25
> [ 1128.964541]  [<ffffffff8110642e>] ? writeback_single_inode+0xe7/0x2da
> [ 1128.964543]  [<ffffffff81107107>] ? writeback_inodes_wb+0x423/0x4fe
> [ 1128.964546]  [<ffffffff8110730e>] ? wb_writeback+0x12c/0x1ab
> [ 1128.964549]  [<ffffffff81107574>] ? wb_do_writeback+0x145/0x15b
> [ 1128.964551]  [<ffffffff811075bb>] ? bdi_writeback_task+0x31/0x9d
> [ 1128.964556]  [<ffffffff810c7cc6>] ? bdi_start_fn+0x0/0xca
> [ 1128.964558]  [<ffffffff810c7d36>] ? bdi_start_fn+0x70/0xca
> [ 1128.964560]  [<ffffffff810c7cc6>] ? bdi_start_fn+0x0/0xca
> [ 1128.964562]  [<ffffffff81064789>] ? kthread+0x79/0x81
> [ 1128.964564]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
> [ 1128.964566]  [<ffffffff81064710>] ? kthread+0x0/0x81
> [ 1128.964568]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
>
>
> And a few copies of bonnie (14 in total):
>
> Two like this:
>
> [ 1128.964735] bonnie        D 0000000000000000     0  2240   2236 0x00000000
> [ 1128.964737]  ffff88033e44b880 0000000000000086 0000000000000000 00000000000009ef
> [ 1128.964740]  ffff8802bac52000 0000000000430bf5 000000000000f8a0 ffff88033d031fd8
> [ 1128.964743]  00000000000155c0 00000000000155c0 ffff88033d811c40 ffff88033d811f38
> [ 1128.964745] Call Trace:
> [ 1128.964747]  [<ffffffff8110c637>] ? sync_buffer+0x0/0x40
> [ 1128.964749]  [<ffffffff812edf36>] ? io_schedule+0x73/0xb7
> [ 1128.964752]  [<ffffffff8110c672>] ? sync_buffer+0x3b/0x40
> [ 1128.964754]  [<ffffffff812ee339>] ? __wait_on_bit_lock+0x3f/0x84
> [ 1128.964756]  [<ffffffff8110c637>] ? sync_buffer+0x0/0x40
> [ 1128.964758]  [<ffffffff812ee3e9>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
> [ 1128.964760]  [<ffffffff81064a84>] ? wake_bit_function+0x0/0x23
> [ 1128.964764]  [<ffffffffa017e068>] ? do_get_write_access+0x82/0x441 [jbd]
> [ 1128.964766]  [<ffffffff8110bbed>] ? __getblk+0x26/0x29a
> [ 1128.964769]  [<ffffffffa017e449>] ? journal_get_write_access+0x22/0x33 [jbd]
> [ 1128.964774]  [<ffffffffa01a040f>] ? __ext3_journal_get_write_access+0x1e/0x47 [ext3]
> [ 1128.964778]  [<ffffffffa019418e>] ? ext3_reserve_inode_write+0x3e/0x75 [ext3]
> [ 1128.964782]  [<ffffffffa0199d86>] ? ext3_orphan_add+0x94/0x15b [ext3]
> [ 1128.964786]  [<ffffffffa01941f8>] ? ext3_mark_inode_dirty+0x33/0x3c [ext3]
> [ 1128.964790]  [<ffffffffa019a6cb>] ? ext3_unlink+0x166/0x1b4 [ext3]
> [ 1128.964793]  [<ffffffff810f645d>] ? vfs_unlink+0x72/0xa6
> [ 1128.964795]  [<ffffffff810f7cb5>] ? do_unlinkat+0xad/0x134
> [ 1128.964797]  [<ffffffff810f9b11>] ? vfs_readdir+0x92/0xa7
> [ 1128.964800]  [<ffffffff810f9c9d>] ? sys_getdents+0xb9/0xc7
> [ 1128.964803]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
>
> One like this:
>
> [ 1128.964804] bonnie        D 0000000000000000     0  2241   2236 0x00000000
> [ 1128.964807]  ffff88033e44b880 0000000000000082 0000000000000000 ffffffff810b90a9
> [ 1128.964809]  ffff880000022c80 0000000000000000 000000000000f8a0 ffff88033c3abfd8
> [ 1128.964812]  00000000000155c0 00000000000155c0 ffff88033d813f90 ffff88033d814288
> [ 1128.964814] Call Trace:
> [ 1128.964816]  [<ffffffff810b90a9>] ? __alloc_pages_nodemask+0x10f/0x5ce
> [ 1128.964819]  [<ffffffff81064977>] ? bit_waitqueue+0x10/0xa0
> [ 1128.964822]  [<ffffffffa017e212>] ? do_get_write_access+0x22c/0x441 [jbd]
> [ 1128.964824]  [<ffffffff81064a84>] ? wake_bit_function+0x0/0x23
> [ 1128.964826]  [<ffffffff8110bbed>] ? __getblk+0x26/0x29a
> [ 1128.964829]  [<ffffffff810170cd>] ? read_tsc+0xa/0x20
> [ 1128.964832]  [<ffffffffa017e449>] ? journal_get_write_access+0x22/0x33 [jbd]
> [ 1128.964836]  [<ffffffffa01a040f>] ? __ext3_journal_get_write_access+0x1e/0x47 [ext3]
> [ 1128.964840]  [<ffffffffa019418e>] ? ext3_reserve_inode_write+0x3e/0x75 [ext3]
> [ 1128.964844]  [<ffffffffa01941e6>] ? ext3_mark_inode_dirty+0x21/0x3c [ext3]
> [ 1128.964847]  [<ffffffffa019a6b4>] ? ext3_unlink+0x14f/0x1b4 [ext3]
> [ 1128.964850]  [<ffffffff810f645d>] ? vfs_unlink+0x72/0xa6
> [ 1128.964852]  [<ffffffff810f7cb5>] ? do_unlinkat+0xad/0x134
> [ 1128.964854]  [<ffffffff810f9b11>] ? vfs_readdir+0x92/0xa7
> [ 1128.964856]  [<ffffffff810f9c9d>] ? sys_getdents+0xb9/0xc7
> [ 1128.964859]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
>
>
> One like this:
>
> [ 1128.964955] bonnie        D 0000000000000000     0  2244   2236 0x00000000
> [ 1128.964958]  ffffffff8144b1f0 0000000000000082 0000000000000000 ffffffff811837bb
> [ 1128.964960]  ffff88033d813170 00000010a00fc7ab 000000000000f8a0 ffff88033ceadfd8
> [ 1128.964963]  00000000000155c0 00000000000155c0 ffff88033d813170 ffff88033d813468
> [ 1128.964965] Call Trace:
> [ 1128.964967]  [<ffffffff811837bb>] ? cfq_set_request+0x2af/0x319
> [ 1128.964969]  [<ffffffff811780d7>] ? get_request+0x7e/0x2ba
> [ 1128.964971]  [<ffffffff812edf36>] ? io_schedule+0x73/0xb7
> [ 1128.964973]  [<ffffffff81178403>] ? get_request_wait+0xf0/0x188
> [ 1128.964976]  [<ffffffff81064a56>] ? autoremove_wake_function+0x0/0x2e
> [ 1128.964978]  [<ffffffff81178792>] ? __make_request+0x2f7/0x428
> [ 1128.964980]  [<ffffffff81176f6f>] ? generic_make_request+0x299/0x2f9
> [ 1128.964983]  [<ffffffff811770a5>] ? submit_bio+0xd6/0xf2
> [ 1128.964985]  [<ffffffff8110b50b>] ? submit_bh+0xf5/0x115
> [ 1128.964987]  [<ffffffff8110da7c>] ? __block_write_full_page+0x1d6/0x2ac
> [ 1128.964990]  [<ffffffff8110c801>] ? end_buffer_async_write+0x0/0x13b
> [ 1128.964992]  [<ffffffff8110fabc>] ? blkdev_get_block+0x0/0x57
> [ 1128.964994]  [<ffffffff810b9572>] ? __writepage+0xa/0x25
> [ 1128.964997]  [<ffffffff810b9bf9>] ? write_cache_pages+0x20b/0x327
> [ 1128.964999]  [<ffffffff810b9568>] ? __writepage+0x0/0x25
> [ 1128.965003]  [<ffffffff810b3cda>] ? __filemap_fdatawrite_range+0x4b/0x54
> [ 1128.965007]  [<ffffffffa019b5bb>] ? ext3_sync_fs+0x42/0x4b [ext3]
> [ 1128.965009]  [<ffffffff810b4998>] ? filemap_write_and_wait+0x17/0x32
> [ 1128.965013]  [<ffffffff8112d015>] ? sync_quota_sb+0x5d/0xf6
> [ 1128.965015]  [<ffffffff8110a38d>] ? __sync_filesystem+0x43/0x70
> [ 1128.965017]  [<ffffffff8110a454>] ? sync_filesystems+0x9a/0xe3
> [ 1128.965019]  [<ffffffff8110a4e2>] ? sys_sync+0x1c/0x2e
> [ 1128.965021]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
>
> Seven bonnies like this:
>
> [ 1128.965231] bonnie        D 0000000000000000     0  2253   2236 0x00000000
> [ 1128.965233]  ffffffff8144b1f0 0000000000000082 0000000000000000 ffff88034ac155c0
> [ 1128.965236]  ffff88033ce7f700 ffffffff81047f43 000000000000f8a0 ffff88033c249fd8
> [ 1128.965239]  00000000000155c0 00000000000155c0 ffff88033d814db0 ffff88033d8150a8
> [ 1128.965241] Call Trace:
> [ 1128.965243]  [<ffffffff81047f43>] ? finish_task_switch+0x3a/0xa7
> [ 1128.965246]  [<ffffffff812ee653>] ? __mutex_lock_common+0x10b/0x17b
> [ 1128.965248]  [<ffffffff812ee77b>] ? mutex_lock+0x1a/0x31
> [ 1128.965250]  [<ffffffff8110a3cd>] ? sync_filesystems+0x13/0xe3
> [ 1128.965252]  [<ffffffff8110a4d8>] ? sys_sync+0x12/0x2e
> [ 1128.965255]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
>
> And three bonnies like this:
>
> [ 1128.965023] bonnie        D 0000000000000000     0  2245   2236 0x00000000
> [ 1128.965026]  ffff88033e44b880 0000000000000082 0000000000000000 00000000000155c0
> [ 1128.965028]  0000000000000005 00000000000155c0 000000000000f8a0 ffff88033cfc3fd8
> [ 1128.965031]  00000000000155c0 00000000000155c0 ffff88033d817100 ffff88033d8173f8
> [ 1128.965033] Call Trace:
> [ 1128.965035]  [<ffffffff812ee653>] ? __mutex_lock_common+0x10b/0x17b
> [ 1128.965038]  [<ffffffff8104a196>] ? try_to_wake_up+0x249/0x259
> [ 1128.965040]  [<ffffffff812ee77b>] ? mutex_lock+0x1a/0x31
> [ 1128.965042]  [<ffffffff8110a3cd>] ? sync_filesystems+0x13/0xe3
> [ 1128.965044]  [<ffffffff8110a4d8>] ? sys_sync+0x12/0x2e
> [ 1128.965047]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
>
>
>

-- 
Jens Axboe

