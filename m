Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0CJN5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:57:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39069 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab0CJN5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:57:40 -0500
Date: Wed, 10 Mar 2010 13:57:22 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USBFS Memory allocation Bug
Message-ID: <20100310135722.GL4883@csn.ul.ie>
References: <d9def9db1003091309p3aa84879lb586cb0406f62693@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <d9def9db1003091309p3aa84879lb586cb0406f62693@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:09:57PM +0100, Markus Rechberger wrote:
> Hi,
> 
> I just stumbled around following issue:
> 
> <SNIP to have one full message>
>
> [275835.491094] mediasrv: page allocation failure. order:6, mode:0x40d0

This is massive. Why is usbdev_ioctl requiring an order-6 allocation?
Does it have the option to fall back to vmalloc() for example?

> [275835.491100] Pid: 14298, comm: mediasrv Not tainted 2.6.33 #7
> [275835.491102] Call Trace:
> [275835.491112]  [<ffffffff810df7a6>] __alloc_pages_nodemask+0x5b6/0x700
> [275835.491118]  [<ffffffff8110c667>] alloc_pages_current+0x87/0xd0
> [275835.491122]  [<ffffffff810dcf79>] __get_free_pages+0x9/0x50
> [275835.491127]  [<ffffffff81114f2b>] __kmalloc+0x13b/0x1f0
> [275835.491132]  [<ffffffff813a18ef>] proc_do_submiturb+0x2ff/0x9d0
> [275835.491137]  [<ffffffff813a26b9>] usbdev_do_ioctl+0x6f9/0x14a0
> [275835.491142]  [<ffffffff8111a78f>] ? try_get_mem_cgroup_from_mm+0x1f/0x70
> [275835.491147]  [<ffffffff81047dbb>] ? finish_task_switch+0x4b/0xe0
> [275835.491151]  [<ffffffff8111bb30>] ? __mem_cgroup_try_charge+0x50/0x210
> [275835.491155]  [<ffffffff8111af5f>] ? __mem_cgroup_commit_charge+0x3f/0x90
> [275835.491159]  [<ffffffff8111bec6>] ? mem_cgroup_charge_common+0x76/0x90
> [275835.491164]  [<ffffffff810e3394>] ? lru_cache_add_lru+0x14/0x30
> [275835.491168]  [<ffffffff813a3523>] usbdev_ioctl+0x43/0x80
> [275835.491173]  [<ffffffff8112da75>] vfs_ioctl+0x35/0xc0
> [275835.491177]  [<ffffffff8102e429>] ? default_spin_lock_flags+0x9/0x10
> [275835.491181]  [<ffffffff8112dfe1>] do_vfs_ioctl+0x81/0x560
> [275835.491187]  [<ffffffff8126f006>] ? __up_read+0x46/0xc0
> [275835.491192]  [<ffffffff81078329>] ? up_read+0x9/0x10
> [275835.491196]  [<ffffffff8112e542>] sys_ioctl+0x82/0xa0
> [275835.491201]  [<ffffffff81009e42>] system_call_fastpath+0x16/0x1b
> [275835.491204] Mem-Info:
> [275835.491205] Node 0 DMA per-cpu:
> [275835.491209] CPU    0: hi:    0, btch:   1 usd:   0
> [275835.491211] CPU    1: hi:    0, btch:   1 usd:   0
> [275835.491213] Node 0 DMA32 per-cpu:
> [275835.491216] CPU    0: hi:  186, btch:  31 usd:   0
> [275835.491218] CPU    1: hi:  186, btch:  31 usd:   0
> [275835.491220] Node 0 Normal per-cpu:
> [275835.491223] CPU    0: hi:  186, btch:  31 usd:   0
> [275835.491226] CPU    1: hi:  186, btch:  31 usd:   0
> [275835.491231] active_anon:104889 inactive_anon:70863 isolated_anon:0
> [275835.491232]  active_file:174421 inactive_file:174601 isolated_file:0
> [275835.491234]  unevictable:0 dirty:42 writeback:0 unstable:0
> [275835.491235]  free:158292 slab_reclaimable:274318 slab_unreclaimable:15652
> [275835.491236]  mapped:23188 shmem:40448 pagetables:6350 bounce:0
> [275835.491238] Node 0 DMA free:15832kB min:28kB low:32kB high:40kB
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15224kB
> mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
> slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
> pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:0 all_unreclaimable? no
> [275835.491249] lowmem_reserve[]: 0 2965 3975 3975
> [275835.491254] Node 0 DMA32 free:476700kB min:6004kB low:7504kB
> high:9004kB active_anon:274156kB inactive_anon:100592kB
> active_file:517364kB inactive_file:517540kB unevictable:0kB
> isolated(anon):0kB isolated(file):0kB present:3036832kB mlocked:0kB
> dirty:76kB writeback:0kB mapped:50368kB shmem:106460kB
> slab_reclaimable:1029688kB slab_unreclaimable:33336kB
> kernel_stack:448kB pagetables:6408kB unstable:0kB bounce:0kB
> writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [275835.491266] lowmem_reserve[]: 0 0 1010 1010
> [275835.491271] Node 0 Normal free:140636kB min:2044kB low:2552kB
> high:3064kB active_anon:145400kB inactive_anon:182860kB
> active_file:180320kB inactive_file:180864kB unevictable:0kB
> isolated(anon):0kB isolated(file):0kB present:1034240kB mlocked:0kB
> dirty:92kB writeback:0kB mapped:42384kB shmem:55332kB
> slab_reclaimable:67472kB slab_unreclaimable:29264kB
> kernel_stack:2224kB pagetables:18992kB unstable:0kB bounce:0kB
> writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [275835.491283] lowmem_reserve[]: 0 0 0 0
> [275835.491287] Node 0 DMA: 2*4kB 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15832kB
> [275835.491299] Node 0 DMA32: 20143*4kB 23426*8kB 10321*16kB 912*32kB 197*64kB 13*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 476828kB
> [275835.491310] Node 0 Normal: 6697*4kB 4644*8kB 2789*16kB 781*32kB 99*64kB 4*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 140660kB
> [275835.491321] 389455 total pagecache pages
> [275835.491323] 0 pages in swap cache
> [275835.491325] Swap cache stats: add 0, delete 0, find 0/0
> [275835.491327] Free swap  = 0kB
> [275835.491329] Total swap = 0kB

So, it's a high-order allocation but no swap is configured. As the
system has a big mix of both anonymous and file memory, it is likely it
was unable to find a large enough contiguous range of file-backed memory
it could discard. There is pretty much nothing the memory manager could
do here. 

FWIW, if swap was configured I'd think there was more the memory manager
could have done.

Is usb falling back to vmalloc() or order-0 pages possible?

> [275835.514050] 1048560 pages RAM
> [275835.514053] 42285 pages reserved
> [275835.514055] 361109 pages shared
> [275835.514056] 541768 pages non-shared
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
