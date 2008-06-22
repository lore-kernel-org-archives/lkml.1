Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYFVU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYFVU41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYFVU4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:56:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:26982 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYFVU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JcKP5j0qb2J7fIwIh8XPoQUk5Zwj6Lu4gkCIRkTw+JvoCmr2dNLYw3DJUvyvqn8Nby
         pJZSwKt1vnBYcAhVwpKJitkGwu8nScqysdz9izExqKvV1CgFLpwDHARTTpEutLLf2OH4
         76OXv5P8ec8OwE3FS+mDUn5KqHgHEqnpIWBO4=
Message-ID: <6278d2220806221356o4c611e43n305ec9653d6d5359@mail.gmail.com>
Date: Sun, 22 Jun 2008 21:56:17 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd hangs for a few sec)...
Cc: "Mel Gorman" <mel@csn.ul.ie>, "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, dgc@sgi.com
In-Reply-To: <20080622112100.794b1ae1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com>
	 <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com>
	 <20080622181011.GC625@csn.ul.ie>
	 <20080622112100.794b1ae1@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 7:21 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 22 Jun 2008 19:10:11 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
>
>> On (22/06/08 10:58), Daniel J Blueman didst pronounce:
>> > I'm seeing a similar issue [2] to what was recently reported [1] by
>> > Alexander, but with another workload involving XFS and memory
>> > pressure.
>> >
>>
>> Is NFS involved or is this XFS only? It looks like XFS-only but no
>> harm in being sure.
>>
>> I'm beginning to wonder if this is a problem where a lot of dirty
>> inodes are being written back in this path and we stall while that
>> happens. I'm still not getting why we are triggering this now and did
>> not before 2.6.26-rc1 or why it bisects to the zonelist
>> modifications. Diffing the reclaim and allocation paths between
>> 2.6.25 and 2.6.26-rc1 has not yielded any candidates for me yet that
>> would explain this.
>
> this sort of thing can easily be exposed with the latencytop tool...
> it will at least tell you WHAT the system is blocking on.
> (not so much the why, the tool isn't smart enough to automatically spit
> out kernel patches yet)

Good plan. I reproduced this without NFS mounted, so pure XFS. I
wasn't able to capture the same process's (ie 5480) latencytop trace,
but it may have contributed to the list.

A fair amount of debugging was turned on, hurting the latency some
(despite it being a 3.6GHz Penryn).

Daniel

--- [1]

$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
<snip>
 1  1    156  14424     12 2329672    0    0     0 110755  177 3820 57  6 36  0
 2  1    156  14736     12 2348152    0    0    24 25172  204 26018 35 21 43  1
 5  0    156  24252     12 2363800    0    0 59656    31  545 25292 35 14 28 23
 4  0    156  14696     12 2317784    0    0  3824     0   38 23083 95  6  0  0
 4  0    156  14440     12 2319304    0    0  4672     0   72 3372 93  3  3  2
 2  0    156  14428     12 2318484    0    0     0     4   27  731 52  0 49  0
 2  0    156  14480     12 2308512    0    0     0    12   32 36629 39 13 49  0
 2  0    156  14572     12 2301220    0    0  3904 12316  117 10760 58  7 26 11

--- [2]

Cause                                                Maximum     Percentage
down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags 271.1 msec          0.4 %
down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_f206.1 msec          1.3 %
down xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_tr160.4 msec          0.5 %
sync_page sync_page_killable __lock_page_killable 155.3 msec         26.1 %
down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_f101.6 msec          0.6 %
down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_f 99.1 msec          0.7 %
sync_page __lock_page find_lock_page filemap_fault 84.0 msec          1.5 %
down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_f 70.8 msec          0.4 %
sync_buffer __wait_on_buffer __block_prepare_write 66.4 msec          0.1 %
o_sync_readv_writev do_readv_writev vfs_writev

Process AutopanoPro (4697)                 Total: 4693.4 msec
down xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_tr126.2 msec
2.7 %trans_commit xfs_create xfs_vn_mknod xfs_vn_create vfs_create
do_filp_open do_sys_open
sync_page sync_page_killable __lock_page_killable  89.3 msec
15.3 %_read __xfs_file_read xfs_file_aio_read do_sync_read vfs_read
sys_read system_call_after
down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_f 88.5 msec
2.2 %fs_da_do_buf xfs_da_read_buf xfs_dir2_leaf_lookup_int
xfs_dir2_leaf_lookup xfs_dir_looku
Scheduler: waiting for cpu                         49.4 msec         77.7 %
congestion_wait __alloc_pages_internal __alloc_pag 19.8 msec
1.4 %e_fault error_exit
congestion_wait __alloc_pages_internal __alloc_pag 19.4 msec
0.4 %ead ondemand_readahead page_cache_async_readahead
generic_file_aio_read xfs_read __xfs_f
ile_read xfs_file_aio_read do_sync_read vfs_read

--- [3]

Cause                                                Maximum     Percentage
sync_page sync_page_killable __lock_page_killable 103.9 msec         36.5 %
Scheduler: waiting for cpu                         37.0 msec         49.5 %
sync_page __lock_page find_lock_page filemap_fault 28.6 msec          1.2 %
congestion_wait __alloc_pages_internal __alloc_pag 19.5 msec          1.3 %
congestion_wait __alloc_pages_internal __alloc_pag 19.2 msec          0.4 %
congestion_wait __alloc_pages_internal __alloc_pag 19.2 msec          0.4 %
do_page_fault error_exit d do_sync_read vfs_read   11.6 msec          0.5 %
sys_mmap system_call_after_swapgs                   7.8 msec          0.2 %
do_select core_sys_select sys_select system_call_a  4.9 msec          8.1 %

Process AutopanoPro (4697)                 Total: 977.5 msec
sync_page sync_page_killable __lock_page_killable  97.7 msec
76.6 %_read __xfs_file_read xfs_file_aio_read do_sync_read vfs_read
sys_read system_call_after
sync_page __lock_page find_lock_page filemap_fault 28.6 msec
5.6 %lt do_page_fault error_exit
congestion_wait __alloc_pages_internal __alloc_pag 19.5 msec
2.0 %e_fault error_exit
congestion_wait __alloc_pages_internal __alloc_pag 19.2 msec
2.0 %k_write_begin xfs_vm_write_begin generic_file_buffered_write
xfs_write __xfs_file_write
Scheduler: waiting for cpu_write vfs_write         16.5 msec          8.7 %
do_page_fault error_exit                           11.6 msec          2.3 %

--- [4]

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc7-211c #2
-------------------------------------------------------
AutopanoPro/5480 is trying to acquire lock:
 (iprune_mutex){--..}, at: [<ffffffff802d2a5d>] shrink_icache_memory+0x7d/0x280

but task is already holding lock:
 (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff803a459f>]
xfs_ilock+0xbf/0x110

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_iolock)->mr_lock){----}:
       [<ffffffff802769ad>] __lock_acquire+0xbdd/0x1020
       [<ffffffff80276e55>] lock_acquire+0x65/0x90
       [<ffffffff8026b41b>] down_write_nested+0x4b/0x90
       [<ffffffff803a45df>] xfs_ilock+0xff/0x110
       [<ffffffff803a47af>] xfs_ireclaim+0x3f/0x90
       [<ffffffff803c9169>] xfs_finish_reclaim+0x59/0x220
       [<ffffffff803cc3b5>] xfs_reclaim+0x185/0x190
       [<ffffffff803d9211>] xfs_fs_clear_inode+0xe1/0x130
       [<ffffffff802d25c7>] clear_inode+0x87/0x120
       [<ffffffff802d290a>] dispose_list+0x2a/0x100
       [<ffffffff802d2c06>] shrink_icache_memory+0x226/0x280
       [<ffffffff8029d9c5>] shrink_slab+0x125/0x180
       [<ffffffff8029dc52>] try_to_free_pages+0x232/0x360
       [<ffffffff80297f0d>] __alloc_pages_internal+0x1ed/0x4a0
       [<ffffffff802981db>] __alloc_pages+0xb/0x10
       [<ffffffff802a312a>] handle_mm_fault+0x46a/0x6d0
       [<ffffffff8060510a>] do_page_fault+0x3ca/0x830
       [<ffffffff80602add>] error_exit+0x0/0xa9
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (iprune_mutex){--..}:
       [<ffffffff80276817>] __lock_acquire+0xa47/0x1020
       [<ffffffff80276e55>] lock_acquire+0x65/0x90
       [<ffffffff8060059a>] mutex_lock_nested+0xba/0x2b0
       [<ffffffff802d2a5d>] shrink_icache_memory+0x7d/0x280
       [<ffffffff8029d9c5>] shrink_slab+0x125/0x180
       [<ffffffff8029dc52>] try_to_free_pages+0x232/0x360
       [<ffffffff80297f0d>] __alloc_pages_internal+0x1ed/0x4a0
       [<ffffffff802981db>] __alloc_pages+0xb/0x10
       [<ffffffff8029a6b6>] __do_page_cache_readahead+0x136/0x230
       [<ffffffff8029aa08>] ondemand_readahead+0x128/0x1f0
       [<ffffffff8029ab45>] page_cache_async_readahead+0x75/0xa0
       [<ffffffff80293a8a>] generic_file_aio_read+0x28a/0x610
       [<ffffffff803d78c4>] xfs_read+0x124/0x270
       [<ffffffff803d4416>] __xfs_file_read+0x46/0x50
       [<ffffffff803d4451>] xfs_file_aio_read+0x11/0x20
       [<ffffffff802bc1b1>] do_sync_read+0xf1/0x130
       [<ffffffff802bca74>] vfs_read+0xc4/0x160
       [<ffffffff802bcf10>] sys_read+0x50/0x90
       [<ffffffff8022639b>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by AutopanoPro/5480:
 #0:  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff803a459f>]
xfs_ilock+0xbf/0x110
 #1:  (shrinker_rwsem){----}, at: [<ffffffff8029d8d2>] shrink_slab+0x32/0x180

stack backtrace:
Pid: 5480, comm: AutopanoPro Not tainted 2.6.26-rc7-211c #2

Call Trace:
 [<ffffffff80274293>] print_circular_bug_tail+0x83/0x90
 [<ffffffff80276817>] __lock_acquire+0xa47/0x1020
 [<ffffffff8027588f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff80276e55>] lock_acquire+0x65/0x90
 [<ffffffff802d2a5d>] ? shrink_icache_memory+0x7d/0x280
 [<ffffffff8060059a>] mutex_lock_nested+0xba/0x2b0
 [<ffffffff802d2a5d>] ? shrink_icache_memory+0x7d/0x280
 [<ffffffff80602915>] ? _spin_unlock_irqrestore+0x55/0x60
 [<ffffffff802d2a5d>] shrink_icache_memory+0x7d/0x280
 [<ffffffff8029d8d2>] ? shrink_slab+0x32/0x180
 [<ffffffff8029d9c5>] shrink_slab+0x125/0x180
 [<ffffffff8029dc52>] try_to_free_pages+0x232/0x360
 [<ffffffff8029c570>] ? isolate_pages_global+0x0/0x40
 [<ffffffff80297f0d>] __alloc_pages_internal+0x1ed/0x4a0
 [<ffffffff802981db>] __alloc_pages+0xb/0x10
 [<ffffffff8029a6b6>] __do_page_cache_readahead+0x136/0x230
 [<ffffffff8029aa08>] ondemand_readahead+0x128/0x1f0
 [<ffffffff8029ab45>] page_cache_async_readahead+0x75/0xa0
 [<ffffffff80293a8a>] generic_file_aio_read+0x28a/0x610
 [<ffffffff803d78c4>] xfs_read+0x124/0x270
 [<ffffffff803d4416>] __xfs_file_read+0x46/0x50
 [<ffffffff803d4451>] xfs_file_aio_read+0x11/0x20
 [<ffffffff802bc1b1>] do_sync_read+0xf1/0x130
 [<ffffffff802673f0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8022ce57>] ? native_sched_clock+0x57/0x80
 [<ffffffff802bda68>] ? fget_light+0xe8/0x100
 [<ffffffff80272dea>] ? lock_release_holdtime+0x5a/0x80
 [<ffffffff802bca74>] vfs_read+0xc4/0x160
 [<ffffffff802bcf10>] sys_read+0x50/0x90
 [<ffffffff8022639b>] system_call_after_swapgs+0x7b/0x80
-- 
Daniel J Blueman
