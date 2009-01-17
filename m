Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZAQHFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZAQHFB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 02:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZAQHEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 02:04:52 -0500
Received: from gw2.cosmosbay.com ([86.64.20.130]:55703 "EHLO gw2.cosmosbay.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbZAQHEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 02:04:51 -0500
Message-ID: <49718304.90404@cosmosbay.com>
Date: Sat, 17 Jan 2009 08:04:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock contention
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw2.cosmosbay.com [127.0.0.1]); Sat, 17 Jan 2009 08:04:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Waychison a écrit :
> We've noticed that at times it can become very easy to have a system begin to
> livelock on dcache_lock/inode_lock (specifically in atomic_dec_and_lock()) when
> a lot of dentries are getting finalized at the same time (massive delete and
> large fdtable destructions are two paths I've seen cause problems).
> 
> This patchset is an attempt to try and reduce the locking overheads associated
> with final dput() and final iput().  This is done by batching dentries and
> inodes into per-process queues and processing them in 'parallel' to consolidate
> some of the locking.
> 
> Besides various workload testing, I threw together a load (at the end of this
> email) that causes massive fdtables (50K sockets by default) to get destroyed
> on each cpu in the system.  It also populates the dcache for procfs on those
> tasks for good measure.  Comparing lock_stat results (hardware is a Sun x4600
> M2 populated with 8 4-core 2.3GHz packages (32 CPUs) + 128GiB RAM):
> 

Hello Mike

Seems quite a large/intrusive infrastructure for a well known problem.
I even wasted some time on it.
But it seems nobody cared too much or people were too busy.

https://kerneltrap.org/mailarchive/linux-netdev/2008/12/11/4397594

(patch 6 should be discarded as followups show it was wrong
[PATH 6/7] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU)


sockets / pipes dont need dcache_lock or inode_lock at all, I am 
sure Google machines also uses sockets :)

Your test/bench program is quite biased (populating dcache for procfs, using
50k filedesc on 32 cpu, not very realistic IMHO).

I had a workload with processes using 1.000.000 file descriptors,
(mainly sockets) and got some latency problems when they had to exit().
This problem was addressed by one cond_resched() added in close_files()
(commit 944be0b224724fcbf63c3a3fe3a5478c325a6547 )


> BEFORE PATCHSET:
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
>                              dcache_lock:       5666485       10086172          11.16     2274036.47  3821690090.32       11042789       14926411           2.78       42138.28    65887138.46
>                              -----------
>                              dcache_lock        3016578          [<ffffffff810bd7e7>] d_alloc+0x190/0x1e1
>                              dcache_lock        1844569          [<ffffffff810bcdfc>] d_instantiate+0x2c/0x51
>                              dcache_lock        4223784          [<ffffffff8119bd88>] _atomic_dec_and_lock+0x3c/0x5c
>                              dcache_lock         207544          [<ffffffff810bc36a>] d_rehash+0x1b/0x43
>                              -----------
>                              dcache_lock        2305449          [<ffffffff810bcdfc>] d_instantiate+0x2c/0x51
>                              dcache_lock        1954160          [<ffffffff810bd7e7>] d_alloc+0x190/0x1e1
>                              dcache_lock        4169163          [<ffffffff8119bd88>] _atomic_dec_and_lock+0x3c/0x5c
>                              dcache_lock         866247          [<ffffffff810bc36a>] d_rehash+0x1b/0x43
> 
> ...............................................................................................................................................................................................
> 
>                               inode_lock:        202813         203064          12.91      376655.85    37696597.26        5136095        8001156           3.37       15142.77     5033144.13
>                               ----------
>                               inode_lock          20192          [<ffffffff810bfdbc>] new_inode+0x27/0x63
>                               inode_lock              1          [<ffffffff810c6f58>] sync_inode+0x19/0x39
>                               inode_lock              5          [<ffffffff810c76b5>] __mark_inode_dirty+0xe2/0x165
>                               inode_lock              2          [<ffffffff810c6e92>] __writeback_single_inode+0x1bf/0x26c
>                               ----------
>                               inode_lock          20198          [<ffffffff810bfdbc>] new_inode+0x27/0x63
>                               inode_lock              1          [<ffffffff810c76b5>] __mark_inode_dirty+0xe2/0x165
>                               inode_lock              5          [<ffffffff810c70fc>] generic_sync_sb_inodes+0x33/0x31a
>                               inode_lock         165016          [<ffffffff8119bd88>] _atomic_dec_and_lock+0x3c/0x5c
> 
> ...............................................................................................................................................................................................
> 
>                        &sbsec->isec_lock:         34428          34431          16.77       67593.54     3780131.15        1415432        3200261           4.06       13357.96     1180726.21
> 
> 
> 
> 
> 
> 
> AFTER PATCHSET [Note that inode_lock doesn't even show up anymore]:
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
>                              dcache_lock:       2732103        5254824          11.04     1314926.88  2187466928.10        5551173        9751332           2.43       78012.24    42830806.29
>                              -----------
>                              dcache_lock        3015590          [<ffffffff810bdb04>] d_alloc+0x190/0x1e1
>                              dcache_lock        1966978          [<ffffffff810bd118>] d_instantiate+0x2c/0x51
>                              dcache_lock         258657          [<ffffffff810bc3cd>] d_rehash+0x1b/0x43
>                              dcache_lock             30          [<ffffffff810b7ad4>] __link_path_walk+0x42d/0x665
>                              -----------
>                              dcache_lock        2493589          [<ffffffff810bd118>] d_instantiate+0x2c/0x51
>                              dcache_lock        1862921          [<ffffffff810bdb04>] d_alloc+0x190/0x1e1
>                              dcache_lock         882054          [<ffffffff810bc3cd>] d_rehash+0x1b/0x43
>                              dcache_lock          15504          [<ffffffff810bc5e1>] process_postponed_dentries+0x3e/0x29f
> 
> ...............................................................................................................................................................................................
> 
> 
> ChangeLog:
>   [v1] - Jan 16, 2009
>     - Initial version
> 
> Patches in series:
> 
>   1)  Deferred batching of dput()
>   2)  Parallel dput()
>   3)  Deferred batching of iput()
>   4)  Fixing iput called from put_super path
>   5)  Parallelize iput()
>   6)  hugetlbfs drop_inode update
>   7)  Make drop_caches flush pending dput()s and iput()s
>   8)  Make the sync path drain dentries and inodes
> 
> Caveats:
> 
>   * It's not clear to me how to make 'sync(2)' do what it should.  Currently we
> flush pending dputs and iputs before writing anything out, but presumably,
> there may be hidden iputs in the do_sync path that really ought to be
> synchronous.
>   * I don't like the changes in patch 4 and it should probably be changed to
> have the ->put_super callback paths call a synchronous version of iput()
> (perhaps sync_iput()?) instead of having to tag the inodes with S_SYNCIPUT.
>   * cramfs, gfs2, ocfs2 need to be updated for the new drop_inode semantics.
> ---
> 
>  fs/block_dev.c         |    2 
>  fs/dcache.c            |  374 +++++++++++++++++++++++++++++++++++++----
>  fs/drop_caches.c       |    1 
>  fs/ext2/super.c        |    2 
>  fs/gfs2/glock.c        |    2 
>  fs/gfs2/ops_fstype.c   |    2 
>  fs/hugetlbfs/inode.c   |   72 +++++---
>  fs/inode.c             |  441 +++++++++++++++++++++++++++++++++++++++++-------
>  fs/ntfs/super.c        |    2 
>  fs/smbfs/inode.c       |    2 
>  fs/super.c             |    6 -
>  fs/sync.c              |    5 +
>  include/linux/dcache.h |    1 
>  include/linux/fs.h     |   18 ++
>  14 files changed, 787 insertions(+), 143 deletions(-)
> 


