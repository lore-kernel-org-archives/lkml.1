Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbZIKDVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbZIKDVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZIKDVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:21:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:39535 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZIKDVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,368,1249282800"; 
   d="scan'208";a="186443749"
Date: Fri, 11 Sep 2009 11:21:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ARM9] OOM with plenty of free swap space?
Message-ID: <20090911032147.GH6267@localhost>
References: <194f62550909050551n3ac70080u528ae8a9322d4a5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194f62550909050551n3ac70080u528ae8a9322d4a5a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

On Sat, Sep 05, 2009 at 08:51:24AM -0400, Clemens Eisserer wrote:
> Hi,
> 
> I am using a Nokia-770 internet tablet (ARM9) running a 2.6.16.27

2.6.16 is a pretty old kernel.

> (precompiled wlan driver) kernel as a small buissness server
> (postgres, tor, samba, lighttp).
> 
> It works quite well, however I recently discovered that postgres was
> killed by the oom killer (log below),
> although plenty of free swap was available. Its a really small
> database so it should easily fit in the 64mb main memory.
> 
> Any idea what could the reason for this OOM?
> 
> Thank you in advance, Clemens
> 
> 
> [17676.783874] oom-killer: gfp_mask=0x201d2, order=0

It's combination of HIGHMEM,WAIT,IO,FS,COLD, which is not easy to
fail.

> [17676.797241] [<c0026890>] (dump_stack+0x0/0x14) from [<c0071850>]
> (out_of_memory+0x40/0x1d8)
> [17676.797393] [<c0071810>] (out_of_memory+0x0/0x1d8) from
> [<c0072d50>] (__alloc_pages+0x240/0x2c4)
> [17676.797515] [<c0072b10>] (__alloc_pages+0x0/0x2c4) from
> [<c0075648>] (__do_page_cache_readahead+0x150/0x324)
> [17676.797637] [<c00754f8>] (__do_page_cache_readahead+0x0/0x324) from
> [<c0075914>] (do_page_cache_readahead+0x64/0x70)
> [17676.797760] [<c00758b0>] (do_page_cache_readahead+0x0/0x70) from
> [<c006eba0>] (filemap_nopage+0x190/0x3ec)
> [17676.797943]  r7 = 00000000  r6 = 00219560  r5 = 00000000  r4 =
> C25E0000
> [17676.798004] [<c006ea10>] (filemap_nopage+0x0/0x3ec) from

This is a mmap read-around, its ra size would be <= 128KB.

> [<c007cc04>] (__handle_mm_fault+0x2fc/0x96c)
> [17676.798126] [<c007c908>] (__handle_mm_fault+0x0/0x96c) from
> [<c0029364>] (do_page_fault+0xe4/0x214)
> [17676.798248] [<c0029280>] (do_page_fault+0x0/0x214) from
> [<c00295e0>] (do_DataAbort+0x3c/0xa4)
> [17676.798339] [<c00295a4>] (do_DataAbort+0x0/0xa4) from [<c0020da8>]
> (ret_from_exception+0x0/0x10)
> [17676.798461]  r8 = 00000000  r7 = 40639540  r6 = 40639560  r5 =
> 00000001
> [17676.798553]  r4 = FFFFFFFF
> [17676.798583] Mem-info:
> [17676.798614] DMA per-cpu:
> [17676.798675] cpu 0 hot: high 18, batch 3 used:2
> [17676.798706] cpu 0 cold: high 6, batch 1 used:0
> [17676.798767] DMA32 per-cpu: empty
> [17676.798797] Normal per-cpu: empty
> [17676.798828] HighMem per-cpu: empty
> [17676.798950] Free pages:        1172kB (0kB HighMem)
> [17676.799011] Active:5576 inactive:6815 dirty:0 writeback:231
> unstable:0 free:293 slab:1257 mapped:12129 pagetables:374

Most LRU pages are mapped:

  active+inactive-writeback=6815+5576-231=12160 ~= 12129=mapped

> [17676.799133] DMA free:1172kB min:1024kB low:1280kB high:1536kB
> active:22304kB inactive:27260kB present:65536kB pages_scanned:91
> all_unreclaimable? no
> [17676.799224] lowmem_reserve[]: 0 0 0 0
> [17676.799285] DMA32 free:0kB min:0kB low:0kB high:0kB active:0kB
> inactive:0kB present:0kB pages_scanned:0 all_unreclaimable? no
> [17676.799377] lowmem_reserve[]: 0 0 0 0
> [17676.799468] Normal free:0kB min:0kB low:0kB high:0kB active:0kB
> inactive:0kB present:0kB pages_scanned:0 all_unreclaimable? no
> [17676.799530] lowmem_reserve[]: 0 0 0 0
> [17676.799621] HighMem free:0kB min:128kB low:128kB high:128kB
> active:0kB inactive:0kB present:0kB pages_scanned:0 all_unreclaimable?
> no
> [17676.799682] lowmem_reserve[]: 0 0 0 0
> [17676.799743] DMA: 33*4kB 4*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB
> 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1172kB
> [17676.799896] DMA32: empty
> [17676.799926] Normal: empty
> [17676.799957] HighMem: empty
> [17676.800018] Swap cache: add 12847, delete 11756, find 42323/43010, race 0+0
> [17676.800079] Free swap  = 167716kB
> [17676.800109] Total swap = 198272kB
> [17676.800170] Free swap:       167716kB
> [17676.804534] 16384 pages of RAM
> [17676.804565] 638 free pages
> [17676.804595] 1096 reserved pages
> [17676.804626] 1257 slab pages
> [17676.804656] 19580 pages shared
> [17676.804718] 1091 pages swap cached

There are ~30MB pages swapped, and another ~4MB in page cache.

So the system is moderately stressed. It may be a vmscan bug,
I'd recommend to try a recent kernel and see if things improved.

Thanks,
Fengguang

> [17676.805267] Out of Memory: Kill process 1535 (postgres) score 11478
> and children.
> [17676.805358] Out of memory: Killed process 1537 (postgres).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
