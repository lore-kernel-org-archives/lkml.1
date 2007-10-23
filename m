Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbXJWSQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbXJWSQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXJWSQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:16:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:61955 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXJWSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=sn2LmqqA4W0ki+rSCv5/CVLs905uuF+wpedS3cVn0PfvQx0ti1VUDo8kutbwEhgYc8kPIcuMHxdeMV1MOGR0KI9KcH+sytFgukaM9T2zMOG5LDPOXXBks9bI8uulIH2vxDLgWlJhWeWs2d8QNjOgQH7n9BrPuDVWBbIvWIP7JjA=
Date: Tue, 23 Oct 2007 22:16:15 +0400
To: clameter@sgi.com, penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
Message-ID: <20071023181615.GA10377@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract:

Nasty OOM killings appear during massive parallel kernel builds with
SLUB, but not with SLAB. By nasty I mean, cc1 processes are killed --
object files in .ccache and tree are corrupted which makes me to
blow up them entirely.


Setup:

92G ext2 partition mounted with noatime. .ccache, master tree, object
trees, build logs residing on it. 2G of RAM, 1G of swap partition.
CFQ scheduler. Core 2 Duo E6400. x86_64 arch.


Workload:

build ~250 configs some fat, some not, in parallel from one source
using O= and save logs to separate dir. This is what I do regularly here.


Observations:

With SLAB this workload never went to OOM killer.
With SLUB and pretty much all debugging enabled, it finishes to the end
(albeit slowly).
With SLUB and no debugging, OOM killer kicks in.

After I notice it at evening, e.g ssh to box doesn't work -- new OOM killings
appear.


Below is dmesg from fresh boot,  OOM messages and .config. Please, give me a
clue on how to proceed from there. If needed I can prepare cut-down scripts
for reproducing and more precise description of setup.

================================================================================
[this is the first OOM]
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 142   Cold: hi:   62, btch:  15 usd:  53
CPU    1: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  54
Active:386969 inactive:66065 dirty:0 writeback:0 unstable:0
 free:3431 slab:11685 mapped:243 pagetables:14621 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:2008kB inactive:1172kB present:12744kB pages_scanned:6852 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5688kB min:5708kB low:7132kB high:8560kB active:1548100kB inactive:261040kB present:2051880kB pages_scanned:12798112 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 13*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 518*4kB 6*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5688kB
Swap cache: add 4908248, delete 4908248, find 699858/1120395, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
17925 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 188662 or a child
Killed process 25288 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 146   Cold: hi:   62, btch:  15 usd:  61
CPU    1: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:  58
Active:306488 inactive:146569 dirty:0 writeback:0 unstable:0
 free:3415 slab:11631 mapped:2 pagetables:14611 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1596kB inactive:1576kB present:12744kB pages_scanned:14865 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5616kB min:5708kB low:7132kB high:8560kB active:1226588kB inactive:582396kB present:2051880kB pages_scanned:13650148 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 498*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5616kB
Swap cache: add 4908570, delete 4908570, find 699873/1120438, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9622 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 187901 or a child
Killed process 25289 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 147   Cold: hi:   62, btch:  15 usd:  56
CPU    1: Hot: hi:  186, btch:  31 usd: 179   Cold: hi:   62, btch:  15 usd:  27
Active:423015 inactive:30323 dirty:0 writeback:0 unstable:0
 free:3429 slab:11630 mapped:2 pagetables:14605 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1600kB inactive:1572kB present:12744kB pages_scanned:14993 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5672kB min:5708kB low:7132kB high:8560kB active:1690460kB inactive:119720kB present:2051880kB pages_scanned:27640275 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 500*4kB 11*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5672kB
Swap cache: add 4908633, delete 4908633, find 699873/1120439, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9326 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 187140 or a child
Killed process 25291 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  39
CPU    1: Hot: hi:  186, btch:  31 usd: 179   Cold: hi:   62, btch:  15 usd:  57
Active:325742 inactive:127034 dirty:0 writeback:0 unstable:0
 free:3444 slab:11630 mapped:2 pagetables:14599 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1600kB inactive:1572kB present:12744kB pages_scanned:14993 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5732kB min:5708kB low:7132kB high:8560kB active:1301244kB inactive:506676kB present:2051880kB pages_scanned:3441512 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 509*4kB 14*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5732kB
Swap cache: add 4908693, delete 4908693, find 699873/1120439, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9818 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 186379 or a child
Killed process 25292 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  29
CPU    1: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:  61
Active:11064 inactive:441279 dirty:0 writeback:0 unstable:0
 free:3445 slab:11629 mapped:2 pagetables:14593 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1600kB inactive:1572kB present:12744kB pages_scanned:15057 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5736kB min:5708kB low:7132kB high:8560kB active:42656kB inactive:1763544kB present:2051880kB pages_scanned:4028526 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 520*4kB 9*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5736kB
Swap cache: add 4908753, delete 4908753, find 699873/1120439, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10207 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 185618 or a child
Killed process 25293 (akmk)
as invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025c43c>] remove_vma+0x4c/0x60
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 151   Cold: hi:   62, btch:  15 usd:  57
CPU    1: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  47
Active:363161 inactive:89780 dirty:0 writeback:0 unstable:0
 free:3430 slab:11629 mapped:2 pagetables:14587 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1604kB inactive:1568kB present:12744kB pages_scanned:15185 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5676kB min:5708kB low:7132kB high:8560kB active:1453272kB inactive:355248kB present:2051880kB pages_scanned:37350819 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 511*4kB 6*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5676kB
Swap cache: add 4908822, delete 4908822, find 699873/1120439, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9525 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 184857 or a child
Killed process 25297 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd:  21
CPU    1: Hot: hi:  186, btch:  31 usd: 180   Cold: hi:   62, btch:  15 usd:  57
Active:256272 inactive:196720 dirty:0 writeback:0 unstable:0
 free:3430 slab:11627 mapped:2 pagetables:14581 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1604kB inactive:1568kB present:12744kB pages_scanned:15249 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5676kB min:5708kB low:7132kB high:8560kB active:1023484kB inactive:785312kB present:2051880kB pages_scanned:4581896 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 513*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5676kB
Swap cache: add 4908882, delete 4908882, find 699873/1120439, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9399 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 184096 or a child
Killed process 25302 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  44
CPU    1: Hot: hi:  186, btch:  31 usd: 188   Cold: hi:   62, btch:  15 usd:  57
Active:304839 inactive:148090 dirty:0 writeback:0 unstable:0
 free:3429 slab:11627 mapped:2 pagetables:14575 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1588kB inactive:1568kB present:12744kB pages_scanned:15441 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5672kB min:5708kB low:7132kB high:8560kB active:1215336kB inactive:593352kB present:2051880kB pages_scanned:13164262 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 512*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5672kB
Swap cache: add 4908968, delete 4908968, find 699873/1120441, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9331 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 183335 or a child
Killed process 25304 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff80282712>] dput+0xb2/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  30
CPU    1: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  53
Active:169953 inactive:282282 dirty:0 writeback:0 unstable:0
 free:3418 slab:11628 mapped:2 pagetables:14569 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:1604kB inactive:1568kB present:12744kB pages_scanned:15505 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5628kB min:5708kB low:7132kB high:8560kB active:678208kB inactive:1127560kB present:2051880kB pages_scanned:4001527 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 498*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5616kB
Swap cache: add 4909029, delete 4909029, find 699873/1120441, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10125 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 182574 or a child
Killed process 25305 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 180   Cold: hi:   62, btch:  15 usd:  53
CPU    1: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  59
Active:11285 inactive:440793 dirty:0 writeback:0 unstable:0
 free:3429 slab:11626 mapped:1 pagetables:14563 bounce:0
DMA free:8040kB min:32kB low:40kB high:48kB active:1724kB inactive:1428kB present:12744kB pages_scanned:7123 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5676kB min:5708kB low:7132kB high:8560kB active:45772kB inactive:1759440kB present:2051880kB pages_scanned:4827940 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 14*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8040kB
DMA32: 513*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5676kB
Swap cache: add 4909091, delete 4909091, find 699873/1120441, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10098 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 181813 or a child
Killed process 25307 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:  49
CPU    1: Hot: hi:  186, btch:  31 usd: 160   Cold: hi:   62, btch:  15 usd:  61
Active:140594 inactive:311525 dirty:0 writeback:0 unstable:0
 free:3430 slab:11625 mapped:1 pagetables:14558 bounce:0
DMA free:8040kB min:32kB low:40kB high:48kB active:1724kB inactive:1428kB present:12744kB pages_scanned:7315 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5680kB min:5708kB low:7132kB high:8560kB active:560652kB inactive:1244672kB present:2051880kB pages_scanned:21209367 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 14*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8040kB
DMA32: 514*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5680kB
Swap cache: add 4909153, delete 4909153, find 699873/1120441, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10009 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 181052 or a child
Killed process 25308 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  60
CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  59
Active:163601 inactive:288519 dirty:0 writeback:0 unstable:0
 free:3445 slab:11625 mapped:2 pagetables:14553 bounce:0
DMA free:8040kB min:32kB low:40kB high:48kB active:1724kB inactive:1428kB present:12744kB pages_scanned:7379 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5740kB min:5708kB low:7132kB high:8560kB active:652680kB inactive:1152648kB present:2051880kB pages_scanned:3581883 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 14*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8040kB
DMA32: 529*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5740kB
Swap cache: add 4909215, delete 4909215, find 699873/1120441, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9926 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 180291 or a child
Killed process 25309 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 115   Cold: hi:   62, btch:  15 usd:  42
CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  59
Active:8992 inactive:444596 dirty:0 writeback:0 unstable:0
 free:3422 slab:11588 mapped:1 pagetables:14545 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1556kB inactive:1248kB present:12744kB pages_scanned:14668 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5656kB min:5708kB low:7132kB high:8560kB active:34412kB inactive:1777136kB present:2051880kB pages_scanned:8923551 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 514*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5656kB
Swap cache: add 4931119, delete 4931119, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9791 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 179530 or a child
Killed process 25313 (akmk)
fixdep invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802e0c03>] prio_tree_insert+0x23/0x270
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8026b0f5>] __slab_free+0x1e5/0x330
 [<ffffffff8025c43c>] remove_vma+0x4c/0x60
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff80282712>] dput+0xb2/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  14
CPU    1: Hot: hi:  186, btch:  31 usd:  72   Cold: hi:   62, btch:  15 usd:  30
Active:29737 inactive:423544 dirty:0 writeback:0 unstable:0
 free:3433 slab:11586 mapped:1 pagetables:14539 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1696kB inactive:1396kB present:12744kB pages_scanned:14830 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:117252kB inactive:1692780kB present:2051880kB pages_scanned:3553979 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 516*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931180, delete 4931180, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10157 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 178769 or a child
Killed process 25318 (akmk)
bash invoked oom-killer: gfp_mask=0x1280d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802593a5>] handle_mm_fault+0x485/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8026b0f5>] __slab_free+0x1e5/0x330
 [<ffffffff8025c43c>] remove_vma+0x4c/0x60
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  52
CPU    1: Hot: hi:  186, btch:  31 usd:  84   Cold: hi:   62, btch:  15 usd:  48
Active:190765 inactive:262200 dirty:0 writeback:0 unstable:0
 free:3424 slab:11586 mapped:2 pagetables:14533 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1696kB inactive:1396kB present:12744kB pages_scanned:15022 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5664kB min:5708kB low:7132kB high:8560kB active:759060kB inactive:1049708kB present:2051880kB pages_scanned:7773323 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 516*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931241, delete 4931241, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10263 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 178008 or a child
Killed process 25321 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  35
CPU    1: Hot: hi:  186, btch:  31 usd:  94   Cold: hi:   62, btch:  15 usd:  50
Active:161540 inactive:291160 dirty:0 writeback:0 unstable:0
 free:3424 slab:11587 mapped:1 pagetables:14527 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1696kB inactive:1396kB present:12744kB pages_scanned:15086 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5664kB min:5708kB low:7132kB high:8560kB active:644464kB inactive:1163132kB present:2051880kB pages_scanned:35575277 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 514*4kB 3*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931301, delete 4931301, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10530 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 177247 or a child
Killed process 25326 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  55
CPU    1: Hot: hi:  186, btch:  31 usd: 107   Cold: hi:   62, btch:  15 usd:  14
Active:40327 inactive:412498 dirty:0 writeback:0 unstable:0
 free:3433 slab:11587 mapped:1 pagetables:14521 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1684kB inactive:1392kB present:12744kB pages_scanned:15214 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:157320kB inactive:1650776kB present:2051880kB pages_scanned:3954392 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 516*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931361, delete 4931361, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10400 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 176486 or a child
Killed process 25331 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd:  47
CPU    1: Hot: hi:  186, btch:  31 usd: 119   Cold: hi:   62, btch:  15 usd:  49
Active:363535 inactive:88985 dirty:0 writeback:0 unstable:0
 free:3484 slab:11587 mapped:1 pagetables:14516 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1700kB inactive:1392kB present:12744kB pages_scanned:15214 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5904kB min:5708kB low:7132kB high:8560kB active:1452440kB inactive:354548kB present:2051880kB pages_scanned:4327701 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 566*4kB 7*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5904kB
Swap cache: add 4931422, delete 4931422, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10564 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 175725 or a child
Killed process 25339 (akmk)
fixdep invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802e0c03>] prio_tree_insert+0x23/0x270
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff802735be>] sys_newfstat+0x2e/0x50
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 114   Cold: hi:   62, btch:  15 usd:  50
CPU    1: Hot: hi:  186, btch:  31 usd: 129   Cold: hi:   62, btch:  15 usd:  43
Active:15013 inactive:437762 dirty:0 writeback:0 unstable:0
 free:3424 slab:11586 mapped:1 pagetables:14510 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1700kB inactive:1392kB present:12744kB pages_scanned:15278 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5664kB min:5708kB low:7132kB high:8560kB active:58352kB inactive:1749656kB present:2051880kB pages_scanned:21495882 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 516*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931482, delete 4931482, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10239 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 174964 or a child
Killed process 25347 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff80282705>] dput+0xa5/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:   62, btch:  15 usd:  60
CPU    1: Hot: hi:  186, btch:  31 usd: 142   Cold: hi:   62, btch:  15 usd:  58
Active:156024 inactive:296851 dirty:0 writeback:0 unstable:0
 free:3424 slab:11585 mapped:1 pagetables:14504 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1704kB inactive:1388kB present:12744kB pages_scanned:15470 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5664kB min:5708kB low:7132kB high:8560kB active:624500kB inactive:1183968kB present:2051880kB pages_scanned:32711791 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 516*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931542, delete 4931542, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10070 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 174203 or a child
Killed process 25354 (akmk)
rm invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8026b0f5>] __slab_free+0x1e5/0x330
 [<ffffffff8025c43c>] remove_vma+0x4c/0x60
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 108   Cold: hi:   62, btch:  15 usd:  48
CPU    1: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  58
Active:382351 inactive:70856 dirty:0 writeback:0 unstable:0
 free:3424 slab:11584 mapped:1 pagetables:14499 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1704kB inactive:1388kB present:12744kB pages_scanned:15534 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5664kB min:5708kB low:7132kB high:8560kB active:1527700kB inactive:282036kB present:2051880kB pages_scanned:6581042 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 504*4kB 8*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931603, delete 4931603, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9703 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 173442 or a child
Killed process 25369 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025c43c>] remove_vma+0x4c/0x60
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 118   Cold: hi:   62, btch:  15 usd:  60
CPU    1: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  20
Active:256144 inactive:196747 dirty:0 writeback:0 unstable:0
 free:3424 slab:11585 mapped:1 pagetables:14493 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1704kB inactive:1408kB present:12744kB pages_scanned:15598 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5664kB min:5708kB low:7132kB high:8560kB active:1020568kB inactive:788012kB present:2051880kB pages_scanned:5734170 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 506*4kB 7*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5664kB
Swap cache: add 4931664, delete 4931664, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9917 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 172681 or a child
Killed process 25379 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff802735be>] sys_newfstat+0x2e/0x50
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 118   Cold: hi:   62, btch:  15 usd:  25
CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  46
Active:423920 inactive:28829 dirty:0 writeback:0 unstable:0
 free:3418 slab:11584 mapped:6 pagetables:14487 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1704kB inactive:1436kB present:12744kB pages_scanned:15726 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5640kB min:5708kB low:7132kB high:8560kB active:1693976kB inactive:113880kB present:2051880kB pages_scanned:4012861 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 501*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5604kB
Swap cache: add 4931725, delete 4931725, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10104 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 171920 or a child
Killed process 25388 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 117   Cold: hi:   62, btch:  15 usd:  56
CPU    1: Hot: hi:  186, btch:  31 usd: 181   Cold: hi:   62, btch:  15 usd:  36
Active:433664 inactive:18732 dirty:0 writeback:0 unstable:0
 free:3439 slab:11583 mapped:3 pagetables:14483 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1708kB inactive:1432kB present:12744kB pages_scanned:15726 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5724kB min:5708kB low:7132kB high:8560kB active:1732948kB inactive:73496kB present:2051880kB pages_scanned:5885606 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 513*4kB 11*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5724kB
Swap cache: add 4931785, delete 4931785, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10317 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 171159 or a child
Killed process 25395 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  58
CPU    1: Hot: hi:  186, btch:  31 usd: 160   Cold: hi:   62, btch:  15 usd:  44
Active:191270 inactive:261290 dirty:0 writeback:0 unstable:0
 free:3425 slab:11584 mapped:3 pagetables:14477 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1708kB inactive:1432kB present:12744kB pages_scanned:15918 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5668kB min:5708kB low:7132kB high:8560kB active:763372kB inactive:1043728kB present:2051880kB pages_scanned:31767483 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 517*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5668kB
Swap cache: add 4931845, delete 4931845, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10106 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 170398 or a child
Killed process 25397 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 135   Cold: hi:   62, btch:  15 usd:  15
CPU    1: Hot: hi:  186, btch:  31 usd: 171   Cold: hi:   62, btch:  15 usd:  44
Active:162477 inactive:289899 dirty:0 writeback:0 unstable:0
 free:3419 slab:11584 mapped:4 pagetables:14471 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1708kB inactive:1432kB present:12744kB pages_scanned:15982 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5644kB min:5708kB low:7132kB high:8560kB active:648200kB inactive:1158164kB present:2051880kB pages_scanned:3195902 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 502*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5608kB
Swap cache: add 4931906, delete 4931906, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10326 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 169637 or a child
Killed process 25401 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff80282712>] dput+0xb2/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:  57
CPU    1: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  57
Active:166888 inactive:285231 dirty:0 writeback:0 unstable:0
 free:3440 slab:11584 mapped:4 pagetables:14465 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1708kB inactive:1432kB present:12744kB pages_scanned:16046 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5728kB min:5708kB low:7132kB high:8560kB active:665844kB inactive:1139492kB present:2051880kB pages_scanned:3455232 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 532*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5728kB
Swap cache: add 4931966, delete 4931966, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10416 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 168876 or a child
Killed process 25407 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  17
CPU    1: Hot: hi:  186, btch:  31 usd: 182   Cold: hi:   62, btch:  15 usd:  48
Active:8518 inactive:443658 dirty:0 writeback:0 unstable:0
 free:3425 slab:11584 mapped:4 pagetables:14459 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1708kB inactive:1432kB present:12744kB pages_scanned:16110 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5668kB min:5708kB low:7132kB high:8560kB active:34348kB inactive:1771152kB present:2051880kB pages_scanned:18797855 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 511*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5668kB
Swap cache: add 4932027, delete 4932027, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10343 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 168115 or a child
Killed process 25409 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025e7bc>] do_mmap_pgoff+0x2fc/0x360
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  57
CPU    1: Hot: hi:  186, btch:  31 usd: 184   Cold: hi:   62, btch:  15 usd:  47
Active:168463 inactive:283970 dirty:0 writeback:0 unstable:0
 free:3426 slab:11581 mapped:4 pagetables:14453 bounce:0
DMA free:8032kB min:32kB low:40kB high:48kB active:1712kB inactive:1428kB present:12744kB pages_scanned:16238 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5672kB min:5708kB low:7132kB high:8560kB active:672140kB inactive:1134452kB present:2051880kB pages_scanned:10945764 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 6*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
DMA32: 518*4kB 2*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5672kB
Swap cache: add 4932088, delete 4932088, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9997 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 167354 or a child
Killed process 25418 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025d4d1>] vma_merge+0x161/0x1f0
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 154   Cold: hi:   62, btch:  15 usd:  47
CPU    1: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:  47
Active:336342 inactive:115515 dirty:0 writeback:0 unstable:0
 free:3445 slab:11581 mapped:1 pagetables:14447 bounce:0
DMA free:8044kB min:32kB low:40kB high:48kB active:2096kB inactive:996kB present:12744kB pages_scanned:9433 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5736kB min:5708kB low:7132kB high:8560kB active:1343272kB inactive:461064kB present:2051880kB pages_scanned:3723650 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 9*4kB 89*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
DMA32: 524*4kB 7*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5736kB
Swap cache: add 4932148, delete 4932148, find 700368/1123222, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10461 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 166593 or a child
Killed process 25428 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 167   Cold: hi:   62, btch:  15 usd:  54
CPU    1: Hot: hi:  186, btch:  31 usd: 123   Cold: hi:   62, btch:  15 usd:  52
Active:2906 inactive:450980 dirty:0 writeback:0 unstable:0
 free:3419 slab:11579 mapped:16 pagetables:14474 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1752kB inactive:1396kB present:12744kB pages_scanned:11565 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5640kB min:5708kB low:7132kB high:8560kB active:9872kB inactive:1802524kB present:2051880kB pages_scanned:17405264 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 514*4kB 2*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5640kB
Swap cache: add 4936171, delete 4936171, find 700451/1123735, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9649 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 165832 or a child
Killed process 25438 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  42
CPU    1: Hot: hi:  186, btch:  31 usd: 136   Cold: hi:   62, btch:  15 usd:  54
Active:448616 inactive:4562 dirty:0 writeback:0 unstable:0
 free:3421 slab:11578 mapped:16 pagetables:14468 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1752kB inactive:1396kB present:12744kB pages_scanned:11565 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5648kB min:5708kB low:7132kB high:8560kB active:1792712kB inactive:16852kB present:2051880kB pages_scanned:10911644 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 512*4kB 4*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5648kB
Swap cache: add 4936231, delete 4936231, find 700451/1123735, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10298 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 165071 or a child
Killed process 25448 (akmk)
make invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8024bda6>] read_cache_page+0x6/0x40
 [<ffffffff8027cb6e>] filldir+0xae/0xf0
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8021e8ca>] __wake_up_sync+0x4a/0x80
 [<ffffffff802762a8>] pipe_release+0x58/0xc0
 [<ffffffff80282705>] dput+0xa5/0x140
 [<ffffffff8022ed6e>] recalc_sigpending+0xe/0x30
 [<ffffffff8022ee37>] sigprocmask+0x67/0xf0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  54
CPU    1: Hot: hi:  186, btch:  31 usd: 147   Cold: hi:   62, btch:  15 usd:  15
Active:4623 inactive:448756 dirty:0 writeback:0 unstable:0
 free:3451 slab:11580 mapped:16 pagetables:14462 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1752kB inactive:1396kB present:12744kB pages_scanned:11629 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5768kB min:5708kB low:7132kB high:8560kB active:18848kB inactive:1791452kB present:2051880kB pages_scanned:9077611 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 550*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5768kB
Swap cache: add 4936291, delete 4936291, find 700451/1123735, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10102 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 164310 or a child
Killed process 25465 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff80282712>] dput+0xb2/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  48
CPU    1: Hot: hi:  186, btch:  31 usd: 145   Cold: hi:   62, btch:  15 usd:  38
Active:124740 inactive:328306 dirty:0 writeback:0 unstable:0
 free:3434 slab:11581 mapped:16 pagetables:14456 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1736kB inactive:1396kB present:12744kB pages_scanned:11757 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:494664kB inactive:1314388kB present:2051880kB pages_scanned:20846696 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 531*4kB 1*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5700kB
Swap cache: add 4936353, delete 4936353, find 700451/1123735, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10305 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 163549 or a child
Killed process 25474 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025d4d1>] vma_merge+0x161/0x1f0
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 176   Cold: hi:   62, btch:  15 usd:  51
CPU    1: Hot: hi:  186, btch:  31 usd: 158   Cold: hi:   62, btch:  15 usd:  18
Active:227125 inactive:225745 dirty:0 writeback:0 unstable:0
 free:3434 slab:11579 mapped:16 pagetables:14450 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1752kB inactive:1396kB present:12744kB pages_scanned:11821 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:906748kB inactive:901584kB present:2051880kB pages_scanned:9477646 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 525*4kB 4*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5700kB
Swap cache: add 4936413, delete 4936413, find 700451/1123735, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10422 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 162788 or a child
Killed process 25520 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 176   Cold: hi:   62, btch:  15 usd:  46
CPU    1: Hot: hi:  186, btch:  31 usd: 169   Cold: hi:   62, btch:  15 usd:  53
Active:192981 inactive:260376 dirty:0 writeback:0 unstable:0
 free:3434 slab:11580 mapped:16 pagetables:14444 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1752kB inactive:1396kB present:12744kB pages_scanned:11885 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:770296kB inactive:1039996kB present:2051880kB pages_scanned:14468241 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 527*4kB 3*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5700kB
Swap cache: add 4936473, delete 4936473, find 700451/1123735, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9903 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 162027 or a child
Killed process 25521 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025d4d1>] vma_merge+0x161/0x1f0
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 175   Cold: hi:   62, btch:  15 usd:  45
CPU    1: Hot: hi:  186, btch:  31 usd: 185   Cold: hi:   62, btch:  15 usd:  55
Active:144219 inactive:308764 dirty:0 writeback:0 unstable:0
 free:3434 slab:11575 mapped:1 pagetables:14438 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1764kB inactive:1196kB present:12744kB pages_scanned:76102 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:575112kB inactive:1233748kB present:2051880kB pages_scanned:35804643 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 525*4kB 4*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5700kB
Swap cache: add 4936534, delete 4936534, find 700451/1123735, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10106 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 161266 or a child
Killed process 25526 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025d4d1>] vma_merge+0x161/0x1f0
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  20
CPU    1: Hot: hi:  186, btch:  31 usd: 184   Cold: hi:   62, btch:  15 usd:  54
Active:332097 inactive:121133 dirty:0 writeback:0 unstable:0
 free:3450 slab:11575 mapped:62 pagetables:14432 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1912kB inactive:1160kB present:12744kB pages_scanned:76189 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5764kB min:5708kB low:7132kB high:8560kB active:1326476kB inactive:483372kB present:2051880kB pages_scanned:2112 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 549*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5764kB
Swap cache: add 4936603, delete 4936603, find 700451/1123736, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9944 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 160505 or a child
Killed process 25542 (akmk)
cron invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8022f180>] do_sigaction+0x90/0x1b0
 [<ffffffff8022f379>] sys_rt_sigaction+0x99/0xd0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:   62, btch:  15 usd:  44
CPU    1: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  55
Active:58995 inactive:393811 dirty:0 writeback:0 unstable:0
 free:3436 slab:11574 mapped:1 pagetables:14426 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1928kB inactive:1160kB present:12744kB pages_scanned:76317 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5708kB min:5708kB low:7132kB high:8560kB active:236160kB inactive:1571908kB present:2051880kB pages_scanned:14107701 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 535*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5708kB
Swap cache: add 4936672, delete 4936672, find 700451/1123737, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10160 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 159744 or a child
Killed process 25719 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 130   Cold: hi:   62, btch:  15 usd:  59
CPU    1: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  61
Active:135048 inactive:317433 dirty:0 writeback:0 unstable:0
 free:3436 slab:11574 mapped:1 pagetables:14420 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1928kB inactive:1160kB present:12744kB pages_scanned:76381 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5708kB min:5708kB low:7132kB high:8560kB active:535832kB inactive:1271004kB present:2051880kB pages_scanned:21688955 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 523*4kB 6*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5708kB
Swap cache: add 4936733, delete 4936733, find 700451/1123737, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10384 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 158983 or a child
Killed process 25764 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 129   Cold: hi:   62, btch:  15 usd:  60
CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  45
Active:142210 inactive:310656 dirty:0 writeback:0 unstable:0
 free:3416 slab:11575 mapped:1 pagetables:14414 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1928kB inactive:1160kB present:12744kB pages_scanned:76381 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5628kB min:5708kB low:7132kB high:8560kB active:568896kB inactive:1239288kB present:2051880kB pages_scanned:4144069 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 506*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5592kB
Swap cache: add 4936795, delete 4936795, find 700451/1123737, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10131 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 158222 or a child
Killed process 25768 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff80282712>] dput+0xb2/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 111   Cold: hi:   62, btch:  15 usd:  52
CPU    1: Hot: hi:  186, btch:  31 usd: 140   Cold: hi:   62, btch:  15 usd:  57
Active:406593 inactive:46196 dirty:0 writeback:0 unstable:0
 free:3422 slab:11572 mapped:1 pagetables:14410 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1928kB inactive:1160kB present:12744kB pages_scanned:76637 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5652kB min:5708kB low:7132kB high:8560kB active:1626552kB inactive:181576kB present:2051880kB pages_scanned:29550878 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 521*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5652kB
Swap cache: add 4936865, delete 4936865, find 700451/1123738, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9963 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 157461 or a child
Killed process 25774 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff80282712>] dput+0xb2/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 103   Cold: hi:   62, btch:  15 usd:  50
CPU    1: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  60
Active:245331 inactive:207700 dirty:0 writeback:0 unstable:0
 free:3422 slab:11572 mapped:1 pagetables:14404 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1928kB inactive:1160kB present:12744kB pages_scanned:76893 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5652kB min:5708kB low:7132kB high:8560kB active:979396kB inactive:829640kB present:2051880kB pages_scanned:31298335 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 519*4kB 1*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5652kB
Swap cache: add 4936925, delete 4936925, find 700451/1123738, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9683 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 156700 or a child
Killed process 25777 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  95   Cold: hi:   62, btch:  15 usd:  50
CPU    1: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  49
Active:244490 inactive:207880 dirty:0 writeback:0 unstable:0
 free:3453 slab:11572 mapped:2 pagetables:14398 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1928kB inactive:1160kB present:12744kB pages_scanned:77021 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5776kB min:5708kB low:7132kB high:8560kB active:976032kB inactive:830360kB present:2051880kB pages_scanned:3029907 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 538*4kB 7*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5776kB
Swap cache: add 4936985, delete 4936985, find 700451/1123738, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10296 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 155939 or a child
Killed process 25816 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff80239930>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  95   Cold: hi:   62, btch:  15 usd:  61
CPU    1: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  54
Active:229501 inactive:223055 dirty:0 writeback:0 unstable:0
 free:3423 slab:11570 mapped:1 pagetables:14392 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1928kB inactive:1160kB present:12744kB pages_scanned:77149 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5656kB min:5708kB low:7132kB high:8560kB active:916076kB inactive:891172kB present:2051880kB pages_scanned:4123304 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 522*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5656kB
Swap cache: add 4937046, delete 4937046, find 700451/1123738, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10055 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 155178 or a child
Killed process 25822 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  85   Cold: hi:   62, btch:  15 usd:  47
CPU    1: Hot: hi:  186, btch:  31 usd: 171   Cold: hi:   62, btch:  15 usd:  16
Active:222092 inactive:230428 dirty:0 writeback:0 unstable:0
 free:3423 slab:11572 mapped:1 pagetables:14386 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1932kB inactive:1196kB present:12744kB pages_scanned:77405 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5656kB min:5708kB low:7132kB high:8560kB active:886436kB inactive:920516kB present:2051880kB pages_scanned:37952251 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 522*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5656kB
Swap cache: add 4937123, delete 4937123, find 700451/1123740, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10025 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 154417 or a child
Killed process 25825 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  79   Cold: hi:   62, btch:  15 usd:  49
CPU    1: Hot: hi:  186, btch:  31 usd: 184   Cold: hi:   62, btch:  15 usd:  50
Active:43813 inactive:408398 dirty:0 writeback:0 unstable:0
 free:3423 slab:11571 mapped:1 pagetables:14380 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1932kB inactive:1196kB present:12744kB pages_scanned:77597 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5656kB min:5708kB low:7132kB high:8560kB active:171016kB inactive:1634700kB present:2051880kB pages_scanned:21288516 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 522*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5656kB
Swap cache: add 4937184, delete 4937184, find 700451/1123740, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10247 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 153656 or a child
Killed process 25830 (akmk)
mips-unknown-li invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8026b0f5>] __slab_free+0x1e5/0x330
 [<ffffffff8025c43c>] remove_vma+0x4c/0x60
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  60
CPU    1: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  15
Active:205842 inactive:246412 dirty:0 writeback:0 unstable:0
 free:3421 slab:11572 mapped:2 pagetables:14375 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1932kB inactive:1196kB present:12744kB pages_scanned:77597 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5648kB min:5708kB low:7132kB high:8560kB active:821656kB inactive:984212kB present:2051880kB pages_scanned:2989881 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 508*4kB 0*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5600kB
Swap cache: add 4937245, delete 4937245, find 700451/1123740, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10215 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 152895 or a child
Killed process 25868 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  83   Cold: hi:   62, btch:  15 usd:  57
CPU    1: Hot: hi:  186, btch:  31 usd: 176   Cold: hi:   62, btch:  15 usd:  60
Active:261918 inactive:190031 dirty:0 writeback:0 unstable:0
 free:3424 slab:11573 mapped:3 pagetables:14369 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1932kB inactive:1196kB present:12744kB pages_scanned:77661 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5660kB min:5708kB low:7132kB high:8560kB active:1045740kB inactive:758928kB present:2051880kB pages_scanned:9313873 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 519*4kB 2*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5660kB
Swap cache: add 4937306, delete 4937306, find 700451/1123740, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10408 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 152134 or a child
Killed process 25877 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff802de57e>] _atomic_dec_and_lock+0x4e/0x70
 [<ffffffff80282712>] dput+0xb2/0x140
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  54
CPU    1: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:  17
Active:216397 inactive:236001 dirty:0 writeback:0 unstable:0
 free:3424 slab:11573 mapped:1 pagetables:14365 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1932kB inactive:1196kB present:12744kB pages_scanned:77725 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5660kB min:5708kB low:7132kB high:8560kB active:863656kB inactive:942808kB present:2051880kB pages_scanned:2789619 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 517*4kB 3*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5660kB
Swap cache: add 4937366, delete 4937366, find 700451/1123740, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9910 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 151373 or a child
Killed process 25883 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  58
CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  14
Active:292998 inactive:159173 dirty:0 writeback:0 unstable:0
 free:3418 slab:11572 mapped:5 pagetables:14359 bounce:0
DMA free:8036kB min:32kB low:40kB high:48kB active:1936kB inactive:1192kB present:12744kB pages_scanned:77789 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5636kB min:5708kB low:7132kB high:8560kB active:1170056kB inactive:635612kB present:2051880kB pages_scanned:2765158 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 90*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
DMA32: 504*4kB 2*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5600kB
Swap cache: add 4937427, delete 4937427, find 700451/1123740, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10153 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 150612 or a child
Killed process 25889 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025c43c>] remove_vma+0x4c/0x60
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff802e29d1>] __up_write+0x21/0x130
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  58
CPU    1: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:  38
Active:257823 inactive:196433 dirty:0 writeback:0 unstable:0
 free:3427 slab:11583 mapped:2 pagetables:14345 bounce:0
DMA free:8028kB min:32kB low:40kB high:48kB active:1732kB inactive:1272kB present:12744kB pages_scanned:7256 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5680kB min:5708kB low:7132kB high:8560kB active:1029560kB inactive:784460kB present:2051880kB pages_scanned:15873083 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 91*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8028kB
DMA32: 530*4kB 1*8kB 18*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5680kB
Swap cache: add 4941921, delete 4941921, find 700476/1124255, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9988 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 149851 or a child
Killed process 25905 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff8025d4d1>] vma_merge+0x161/0x1f0
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  10
CPU    1: Hot: hi:  186, btch:  31 usd: 172   Cold: hi:   62, btch:  15 usd:  17
Active:6576 inactive:448414 dirty:0 writeback:0 unstable:0
 free:3421 slab:11582 mapped:4 pagetables:14339 bounce:0
DMA free:8028kB min:32kB low:40kB high:48kB active:1732kB inactive:1272kB present:12744kB pages_scanned:7256 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5656kB min:5708kB low:7132kB high:8560kB active:24572kB inactive:1792384kB present:2051880kB pages_scanned:6507504 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 91*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8028kB
DMA32: 515*4kB 1*8kB 18*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5620kB
Swap cache: add 4941981, delete 4941981, find 700476/1124255, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
9337 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 149090 or a child
Killed process 25924 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 180   Cold: hi:   62, btch:  15 usd:  52
CPU    1: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  51
Active:2045 inactive:451969 dirty:0 writeback:0 unstable:0
 free:3427 slab:11582 mapped:2 pagetables:14335 bounce:0
DMA free:8028kB min:32kB low:40kB high:48kB active:1732kB inactive:1272kB present:12744kB pages_scanned:7320 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5680kB min:5708kB low:7132kB high:8560kB active:8556kB inactive:1804556kB present:2051880kB pages_scanned:10503383 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 91*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8028kB
DMA32: 530*4kB 1*8kB 18*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5680kB
Swap cache: add 4942041, delete 4942041, find 700476/1124255, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10080 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 148329 or a child
Killed process 25927 (akmk)
cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff8024cfe6>] oom_kill_process+0xf6/0x110
 [<ffffffff8024d49d>] out_of_memory+0x1ad/0x1f0
 [<ffffffff8024f79e>] __alloc_pages+0x28e/0x3a0
 [<ffffffff802518d1>] __do_page_cache_readahead+0x101/0x270
 [<ffffffff8024c43a>] filemap_fault+0x28a/0x3c0
 [<ffffffff8025742c>] __do_fault+0x6c/0x430
 [<ffffffff802592db>] handle_mm_fault+0x3bb/0x700
 [<ffffffff8021c09f>] do_page_fault+0x1bf/0x830
 [<ffffffff803d1583>] thread_return+0x3d/0x53a
 [<ffffffff8025d296>] do_munmap+0x296/0x2f0
 [<ffffffff803d3679>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 167   Cold: hi:   62, btch:  15 usd:  60
CPU    1: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 usd:  31
Active:115924 inactive:338027 dirty:0 writeback:0 unstable:0
 free:3428 slab:11580 mapped:4 pagetables:14330 bounce:0
DMA free:8028kB min:32kB low:40kB high:48kB active:1732kB inactive:1292kB present:12744kB pages_scanned:7384 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5684kB min:5708kB low:7132kB high:8560kB active:461840kB inactive:1350816kB present:2051880kB pages_scanned:5104608 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 91*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8028kB
DMA32: 529*4kB 2*8kB 18*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5684kB
Swap cache: add 4942111, delete 4942111, find 700476/1124255, race 92+89
Free swap  = 0kB
Total swap = 987956kB
Free swap:            0kB
524176 pages of RAM
8772 reserved pages
10143 pages shared
0 pages swap cached
Out of memory: kill process 25286 (build-all) score 147568 or a child
Killed process 25934 (akmk)


================================================================================
Linux version 2.6.23-0b776eb5426752d4e53354ac89e3710d857e09a7 (ad@core2) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #2 SMP Tue Oct 23 21:41:03 MSD 2007
Command line: root=/dev/sda2 netconsole=@10.10.0.42/eth0,9353@10.10.0.1/00:80:48:45:EC:73 ignore_loglevel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
ACPI: XSDT 7FF90100, 0054 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   2000707 MSFT       97)
ACPI: DSDT 7FF905C0, 8FA9 (r1  A0637 A0637000        0 INTL 20060113)
ACPI: FACS 7FF9E000, 0040
ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   2000707 MSFT       97)
ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   2000707 MSFT       97)
ACPI: SLIC 7FF90440, 0176 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   2000707 MSFT       97)
ACPI: HPET 7FF99570, 0038 (r1 MSTEST OEMHPET   2000707 MSFT       97)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524176
On node 0 totalpages: 524079
  DMA zone: 56 pages used for memmap
  DMA zone: 757 pages reserved
  DMA zone: 3186 pages, LIFO batch:0
  DMA32 zone: 7110 pages used for memmap
  DMA32 zone: 512970 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
PERCPU: Allocating 22896 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516156
Kernel command line: root=/dev/sda2 netconsole=@10.10.0.42/eth0,9353@10.10.0.1/00:80:48:45:EC:73 ignore_loglevel
debug: ignoring loglevel setting.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
hpet clockevent registered
TSC calibrated against HPET
time.c: Detected 2135.039 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Memory: 2061224k/2096704k available (1873k kernel code, 34912k reserved, 651k data, 192k init)
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 4272.48 BogoMIPS (lpj=21362443)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
Freeing SMP alternatives: 18k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 16679990
Detected 16.679 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4270.10 BogoMIPS (lpj=21350544)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  08, should be FB [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:08: ioport range 0x290-0x297 has been reserved
system 00:09: iomem range 0xffafe000-0xffb0cbff could not be reserved
system 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0xc0000-0xcffff has been reserved
system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
system 00:0f: iomem range 0x100000-0x7fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: f8800000-fe8fffff
  PREFETCH window: bfe00000-dfdfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: fea00000-feafffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: b000-bfff
  MEM window: fe900000-fe9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
Real Time Clock Driver v1.12ac
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:03:00.0 to 64
atl1 0000:03:00.0: version 2.0.7
netconsole: local port 6665
netconsole: local IP 10.10.0.42
netconsole: interface eth0
netconsole: remote port 9353
netconsole: remote IP 10.10.0.1
netconsole: remote ethernet address 00:80:48:45:ec:73
netconsole: device eth0 not up yet, forcing it
atl1 0000:03:00.0: eth0 link is up 100 Mbps full duplex
console [netcon0] enabled
netconsole: network logging started
ahci 0000:02:00.0: version 3.0
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:02:00.0 to 64
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe100 irq 16
ata2: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe180 irq 16
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
ata4: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
ata3.00: ATA-7: ST3250620AS, 3.AAE, max UDMA/133
ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 2:0:0:0: [sda] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 3:0:0:0: [sdb] Attached SCSI disk
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 19
ata6: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 19
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.1 to 64
scsi6 : pata_jmicron
scsi7 : pata_jmicron
ata7: PATA max UDMA/100 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 17
ata8: PATA max UDMA/100 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 17
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
w83627ehf: Found W83627DHG chip at 0x290
TCP cubic registered
NET: Registered protocol family 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 192k freed
EXT3 FS on sda2, internal journal
Adding 987956k swap on /dev/sda1.  Priority:-1 extents:1 across:987956k
================================================================================
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23
# Tue Oct 23 21:39:10 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_ZONE_DMA32=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_DMI=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
# CONFIG_CGROUPS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_X86_PC=y
# CONFIG_X86_VSMP is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_X86_HT=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_NR_CPUS=2
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y
CONFIG_GENERIC_PENDING_IRQ=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
# CONFIG_X86_PM_TIMER is not set
# CONFIG_ACPI_CONTAINER is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FW_LOADER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_IP1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SAMPLES is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
