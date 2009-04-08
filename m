Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZDHXsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZDHXsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZDHXsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:48:10 -0400
Received: from mail001.aei.ca ([206.123.6.130]:34824 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbZDHXsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:48:08 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Chris Mason <chris.mason@oracle.com>
Subject: [2.6.30-rc1] gpf in btrfs during shutdown
Date: Wed, 8 Apr 2009 19:48:02 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.30-rc1-crc-00001-geed681d; KDE/4.2.1; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1238787179.24082.7.camel@think.oraclecorp.com>
In-Reply-To: <1238787179.24082.7.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081948.02742.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 15:32:58 Chris Mason wrote:
> Hello everyone,
> 
> This is the second batch of btrfs updates for the merge window, which
> includes an assortment of optimizations, fixes, cleanups and small
> features.
> 
> >From a performance point of view, synchronous writes get a big boost by
> making sure we unplug instead of letting kblockd do it for us, and Josef
> got rid of two more mutexes from the allocator.
> 
> mount -o ssd is much faster in multi-process workloads, and it does a
> better job of preventing free space fragmentation as well.
> 
> Linus, you'll find these changes in the master branch of:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
> 
> Amit Gud (1):
>       Btrfs: fix race in worker_loop
> 
> Chris Mason (5):
>       Btrfs: keep processing bios for a given bdev if our proc is batching
>       Btrfs: unplug in the async bio submission threads
>       Btrfs: break up btrfs_search_slot into smaller pieces
>       Btrfs: Optimize locking in btrfs_next_leaf()
>       Btrfs: rework allocation clustering
> 
> Dan Carpenter (2):
>       Btrfs: remove dead code
>       Btrfs: remove dead code
> 
> Eric Paris (1):
>       Btrfs: introduce btrfs_show_options
> 
> Heiko Carstens (1):
>       Btrfs: fix __ucmpdi2 compile bug on 32 bit builds
> 
> Jim Owens (1):
>       Btrfs: remove unused ftrace include
> 
> Josef Bacik (4):
>       Btrfs: free space cache cleanups
>       Btrfs: clean up find_free_extent
>       Btrfs: kill the block group alloc mutex
>       Btrfs: kill the pinned_mutex
> 
> Sage Weil (2):
>       Btrfs: notreelog mount option
>       Btrfs: add flushoncommit mount option
> 
> Shen Feng (1):
>       Btrfs: free inode struct when btrfs_new_inode fails
> 
> Stoyan Gaydarov (1):
>       Btrfs: BUG to BUG_ON changes
> 
> Wu Fengguang (1):
>       Btrfs: fix typos in comments
> 
>  fs/btrfs/async-thread.c     |    7
>  fs/btrfs/ctree.c            |  312 ++++++++++++++++---------
>  fs/btrfs/ctree.h            |   84 ++++--
>  fs/btrfs/delayed-ref.c      |    1
>  fs/btrfs/disk-io.c          |    8
>  fs/btrfs/extent-tree.c      |  398 ++++++++++++++++-----------------
>  fs/btrfs/extent_io.c        |   16 -
>  fs/btrfs/extent_map.c       |    1
>  fs/btrfs/free-space-cache.c |  530 +++++++++++++++++++++++++++++++-------------
>  fs/btrfs/free-space-cache.h |   44 +++
>  fs/btrfs/inode.c            |    5
>  fs/btrfs/locking.c          |    4
>  fs/btrfs/super.c            |   54 ++++
>  fs/btrfs/transaction.c      |    7
>  fs/btrfs/tree-log.c         |   12
>  fs/btrfs/volumes.c          |   41 +++
>  fs/btrfs/volumes.h          |    2
>  17 files changed, 982 insertions(+), 544 deletions(-)

Chris,

Just go the following gpf during shutdown runing 2.6.30-rc1 on amd64 on a kernel built with gcc 4.3.3

* Unmounting filesystems ...[75813.573941] EXT4-fs: mballoc: 313285 blocks 3098 reqs (2001 success)
[75813.593628] EXT4-fs: mballoc: 1312 extents scanned, 438 goal hits, 1063 2^N hits, 0 breaks, 0 lost
[75813.621386] EXT4-fs: mballoc: 1551 generated and it took 21437865
[75813.640246] EXT4-fs: mballoc: 364104 preallocated, 204441 discarded
[75813.685443] general protection fault: 0000 [#1] PREEMPT SMP
[75813.698277] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/enable
[75813.698277] CPU 1
[75813.698277] Modules linked in: btrfs/etc/init.d/halt zlib_deflate zlib_inflate crc32c libcrc32c radeon drm bridge stp llc bnep rf]
.sh: line 90:  6[75813.698277] Pid: 6768, comm: umount Not tainted 2.6.30-rc1-crc #1 System Product Name
768 Segmentation[75813.698277] RIP: 0010:[<ffffffff8030e3a7>]  [<ffffffff8030e3a7>] kmem_cache_alloc+0x77/0x210
 fault      umou[75813.698277] RSP: 0018:ffff8801466514a8  EFLAGS: 00010046
nt "${x}" >&/dev[75813.698277] RAX: 0000000000000000 RBX: ffff880028066b40 RCX: ffff88015f3444a0
/null
[75813.698277] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff80847330
[75813.698277] RBP: ffff8801466514e8 R08: 00000035c2309000 R09: 0000000000000002
[75813.698277] R10: 0000000000001000 R11: 0000000000000001 R12: ff880153891480ff
[75813.698277] R13: 0000000000000246 R14: ffffffff8088ca58 R15: 0000000000000080
[75813.698277] FS:  00007f6dd9cc0740(0000) GS:ffff880028059000(0000) knlGS:0000000000000000
[75813.698277] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[75813.698277] CR2: 00007f6dd964e000 CR3: 00000001425fd000 CR4: 00000000000006e0
[75813.698277] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[75813.698277] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[75813.698277] Process umount (pid: 6768, threadinfo ffff880146650000, task ffff88015f3444a0)
[75813.698277] Stack:
[75813.698277]  0000005000e7f0b0 0000000000e7f0b0 0000000000e7f0b0 0000000000000000
[75813.698277]  0000000000000060 0000000000000051 ffff88013cd073c0 ffff88013cd078a0
[75813.698277]  ffff8801466515a8 ffffffffa04e1365 000000000000be2d 0000000000000000
[75813.698277] Call Trace:
[75813.698277]  [<ffffffffa04e1365>] btrfs_update_delayed_ref+0x245/0x490 [btrfs]
[75813.698277]  [<ffffffff8043a8e0>] ? sort+0x160/0x250
[75813.698277]  [<ffffffffa048befc>] __btrfs_update_extent_ref+0x6c/0xb0 [btrfs]
[75813.698277]  [<ffffffff80610f94>] ? _cond_resched+0x44/0xa0
[75813.698277]  [<ffffffffa0491ab3>] btrfs_inc_ref+0x6c3/0x7d0 [btrfs][75813.698277]  [<ffffffffa048e7bc>] ? btrfs_init_new_buffer+0x11c/0x180 [btrfs]
[75813.698277]  [<ffffffffa04c7b84>] ? write_extent_buffer+0x114/0x330 [btrfs]
[75813.698277]  [<ffffffffa048be90>] ? __btrfs_update_extent_ref+0x0/0xb0 [btrfs]
[75813.698277]  [<ffffffff80618129>] ? sub_preempt_count+0x69/0x70
[75813.698277]  [<ffffffffa04815fa>] __btrfs_cow_block+0x58a/0xbc0 [btrfs]
[75813.698277]  [<ffffffffa0481d39>] btrfs_cow_block+0x109/0x270 [btrfs]
[75813.698277]  [<ffffffffa04877f2>] btrfs_search_slot+0x202/0x880 [btrfs]
[75813.698277]  [<ffffffffa048a458>] lookup_extent_backref+0x68/0x160 [btrfs]
[75813.698277]  [<ffffffff80618129>] ? sub_preempt_count+0x69/0x70
[75813.698277]  [<ffffffffa048c91d>] __btrfs_free_extent+0x18d/0x950 [btrfs]
[75813.698277]  [<ffffffff80618129>] ? sub_preempt_count+0x69/0x70
[75813.698277]  [<ffffffff80618191>] ? add_preempt_count+0x61/0x70
[75813.698277]  [<ffffffffa048d35d>] run_one_delayed_ref+0x27d/0x2c0 [btrfs]
[75813.698277]  [<ffffffffa048e8f6>] run_clustered_refs+0xd6/0x250 [btrfs]
[75813.698277]  [<ffffffffa048eb46>] btrfs_run_delayed_refs+0xd6/0x2b0 [btrfs]
[75813.698277]  [<ffffffffa04a4244>] btrfs_commit_tree_roots+0xb4/0x2f0 [btrfs]
[75813.698277]  [<ffffffffa04a4e0b>] btrfs_commit_transaction+0x5cb/0xa00 [btrfs]
[75813.698277]  [<ffffffff802724d0>] ? autoremove_wake_function+0x0/0x70
[75813.698277]  [<ffffffffa04a3315>] ? start_transaction+0x125/0x170 [btrfs]
[75813.698277]  [<ffffffffa047cd66>] btrfs_sync_fs+0x66/0xb0 [btrfs]
[75813.698277]  [<ffffffff803177a6>] __fsync_super+0x66/0xa0
[75813.698277]  [<ffffffff80317805>] fsync_super+0x25/0x50
[75813.698277]  [<ffffffff80317a7e>] generic_shutdown_super+0x3e/0x170
[75813.698277]  [<ffffffff80317c55>] kill_anon_super+0x25/0x70
[75813.698277]  [<ffffffff80318189>] deactivate_super+0x69/0xa0
[75813.698277]  [<ffffffff8033502c>] mntput_no_expire+0x1ac/0x1e0
[75813.698277]  [<ffffffff80335466>] sys_umount+0x76/0x3e0
[75813.698277]  [<ffffffff8020bf9b>] system_call_fastpath+0x16/0x1b
[75813.698277] Code: 8b 9c c6 e8 00 00 00 48 83 3b 00 44 8b 7b 18 0f 84 77 01 00 00 31 d2 31 f6 48 c7 c7 30 73 84 80 e8 ff 2d fb ff
[75813.698277] RIP  [<ffffffff8030e3a7>] kmem_cache_alloc+0x77/0x210
[75813.698277]  RSP <ffff8801466514a8>
[75813.698277] ---[ end trace a92f79fb0023c3c1 ]---

Followed by many more...

Hope this helps,
Ed Tomlinson


