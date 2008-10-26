Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYJZW5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYJZW5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 18:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYJZW52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 18:57:28 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:65238 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbYJZW51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 18:57:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,489,1220193000"; 
   d="scan'208";a="218592019"
Date: Mon, 27 Oct 2008 09:57:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Subject: Order 0 page allocation failure under heavy I/O load
Message-ID: <20081026225723.GO18495@disturbed>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been running a workload in a UML recently to reproduce a
problem, and I've been seeing all sorts of latency problems on
the host. The hosts is running a standard debian kernel:

$ uname -a
Linux disturbed 2.6.26-1-amd64 #1 SMP Wed Sep 10 15:31:12 UTC 2008 x86_64 GNU/Linux

Basically, the workload running in the UML is:

# fsstress -p 1024 -n 100000 -d /mnt/xfs2/fsstress.dir

Which runs 1024 fsstress processes inside the indicated directory.
Being UML, that translates to 1024 processes on the host doing I/O
to a single file in an XFS filesystem. The problem is that this
load appears to be triggering OOM on the host. The host filesystem
is XFS on a 2 disk MD raid0 stripe.

The host will hang for tens of seconds at a time with both CPU cores
pegged at 100%, and eventually I get this in dmesg:

[1304740.261506] linux: page allocation failure. order:0, mode:0x10000
[1304740.261516] Pid: 10705, comm: linux Tainted: P          2.6.26-1-amd64 #1
[1304740.261520]
[1304740.261520] Call Trace:
[1304740.261557]  [<ffffffff802768db>] __alloc_pages_internal+0x3ab/0x3c4
[1304740.261574]  [<ffffffff80295248>] kmem_getpages+0x96/0x15f
[1304740.261580]  [<ffffffff8029589d>] fallback_alloc+0x170/0x1e6
[1304740.261592]  [<ffffffff802954b5>] kmem_cache_alloc_node+0x105/0x138
[1304740.261599]  [<ffffffff802955ec>] cache_grow+0xdc/0x21d
[1304740.261609]  [<ffffffff802958da>] fallback_alloc+0x1ad/0x1e6
[1304740.261620]  [<ffffffff80295edd>] kmem_cache_alloc+0xc4/0xf6
[1304740.261625]  [<ffffffff8027310c>] mempool_alloc+0x24/0xda
[1304740.261638]  [<ffffffff802bd9a8>] bio_alloc_bioset+0x89/0xd9
[1304740.261657]  [<ffffffffa016b2b2>] :dm_mod:clone_bio+0x3a/0x79
[1304740.261674]  [<ffffffffa016c120>] :dm_mod:__split_bio+0x13a/0x374
[1304740.261697]  [<ffffffffa016c8a1>] :dm_mod:dm_request+0x105/0x127
[1304740.261705]  [<ffffffff8030c317>] generic_make_request+0x2fe/0x339
[1304740.261709]  [<ffffffff8027310c>] mempool_alloc+0x24/0xda
[1304740.261750]  [<ffffffffa01dd354>] :xfs:xfs_cluster_write+0xcd/0xf2
[1304740.261763]  [<ffffffff8030d6eb>] submit_bio+0xdb/0xe2
[1304740.261796]  [<ffffffffa01dcaf6>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
[1304740.261825]  [<ffffffffa01dcbbb>] :xfs:xfs_submit_ioend+0xa7/0xc6
[1304740.261857]  [<ffffffffa01dd9fc>] :xfs:xfs_page_state_convert+0x500/0x54f
[1304740.261868]  [<ffffffff8027bef4>] vma_prio_tree_next+0x3c/0x52
[1304740.261911]  [<ffffffffa01ddbaa>] :xfs:xfs_vm_writepage+0xb4/0xea
[1304740.261920]  [<ffffffff80276e57>] __writepage+0xa/0x23
[1304740.261924]  [<ffffffff8027731c>] write_cache_pages+0x182/0x2b1
[1304740.261928]  [<ffffffff80276e4d>] __writepage+0x0/0x23
[1304740.261952]  [<ffffffff80277487>] do_writepages+0x20/0x2d
[1304740.261957]  [<ffffffff802b62a4>] __writeback_single_inode+0x144/0x29d
[1304740.261966]  [<ffffffff8031c625>] prop_fraction_single+0x35/0x55
[1304740.261976]  [<ffffffff802b6768>] sync_sb_inodes+0x1b1/0x293
[1304740.261985]  [<ffffffff802b6b96>] writeback_inodes+0x62/0xb3
[1304740.261991]  [<ffffffff80277929>] balance_dirty_pages_ratelimited_nr+0x155/0x2e7
[1304740.262010]  [<ffffffff8027eb42>] do_wp_page+0x578/0x5b2
[1304740.262027]  [<ffffffff80281980>] handle_mm_fault+0x7dd/0x867
[1304740.262037]  [<ffffffff80246021>] autoremove_wake_function+0x0/0x2e
[1304740.262051]  [<ffffffff80221f78>] do_page_fault+0x5d8/0x9c8
[1304740.262061]  [<ffffffff80213822>] genregs_get+0x4f/0x70
[1304740.262072]  [<ffffffff80429b89>] error_exit+0x0/0x60
[1304740.262089]
[1304740.262091] Mem-info:
[1304740.262093] Node 0 DMA per-cpu:
[1304740.262096] CPU    0: hi:    0, btch:   1 usd:   0
[1304740.262099] CPU    1: hi:    0, btch:   1 usd:   0
[1304740.262101] Node 0 DMA32 per-cpu:
[1304740.262104] CPU    0: hi:  186, btch:  31 usd: 176
[1304740.262107] CPU    1: hi:  186, btch:  31 usd: 172
[1304740.262111] Active:254755 inactive:180546 dirty:13547 writeback:20016 unstable:0
[1304740.262113]  free:3059 slab:39487 mapped:141190 pagetables:16401 bounce:0
[1304740.262116] Node 0 DMA free:8032kB min:28kB low:32kB high:40kB active:1444kB inactive:112kB present:10792kB pages_scanned:64 all_unreclaimable? no
[1304740.262122] lowmem_reserve[]: 0 2004 2004 2004
[1304740.262126] Node 0 DMA32 free:4204kB min:5712kB low:7140kB high:8568kB active:1017576kB inactive:722072kB present:2052256kB pages_scanned:0 all_unreclaimable? no
[1304740.262133] lowmem_reserve[]: 0 0 0 0
[1304740.262136] Node 0 DMA: 160*4kB 82*8kB 32*16kB 11*32kB 8*64kB 4*128kB 3*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8048kB
[1304740.262146] Node 0 DMA32: 26*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 4160kB
[1304740.262155] 362921 total pagecache pages
[1304740.262158] Swap cache: add 461446, delete 411499, find 5485707/5511715
[1304740.262161] Free swap  = 3240688kB
[1304740.262163] Total swap = 4152744kB
[1304740.274260] 524272 pages of RAM
[1304740.274260] 8378 reserved pages
[1304740.274260] 650528 pages shared
[1304740.274260] 49947 pages swap cached

This allocation failure occurred when something wrote to the root filesystem,
which is LVM on a MD RAID1 mirror. It appears to be bio mempool exhaustion that
is triggering the allocation failure report. The allocation failure report
doesn't come out every time the system goes catatonic under this workload - the
failure has been reported twice out of about 10 runs. However, every single run
of the workload has caused the hang-for-tens-of-seconds problem on the host.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
