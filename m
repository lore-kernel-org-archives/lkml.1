Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZLANVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZLANVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZLANVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:21:35 -0500
Received: from [83.170.124.135] ([83.170.124.135]:58338 "EHLO
	pluto.daelnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZLANVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:21:34 -0500
Message-ID: <4B151862.9020201@cybus.co.uk>
Date: Tue, 01 Dec 2009 13:21:38 +0000
From: Jonathan Miles <jon@cybus.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOM kernel behaviour
References: <4B1402FC.80307@cybus.co.uk> <alpine.DEB.2.00.0911301253410.18682@router.home> <4B14E8A2.4020500@cybus.co.uk>
In-Reply-To: <4B14E8A2.4020500@cybus.co.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------040308000208070205060903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040308000208070205060903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 01/12/09 09:57 Jonathan Miles said the following:

> I've attached a good example which shows Xorg invoking the OOM killer
> when the page-cache is using ~1.3GB out of 2GB. My understanding from
> reading linux-mm.org is that the kernel actually prefers to swap than
> reclaim from the page-cache... is this accurate? However, what if there
> is no swap, or it's configured not to use it? Should the kernel then try
> to reclaim instead?

And here's another (attached), with a slightly different initial code
path, where hald has caused the OOM killer to be invoked even though
(again) there was ~1.3GB out of 2GB used by the page-cache.

[66568.252937] Call Trace:
[66568.252963]  [<c01b5a0f>] oom_kill_process+0x9f/0x250
[66568.252981]  [<c01b601e>] ? select_bad_process+0xbe/0xf0
[66568.252989]  [<c01b60a1>] __out_of_memory+0x51/0xa0
[66568.252997]  [<c01b6143>] out_of_memory+0x53/0xb0
[66568.253045]  [<c01b83fe>] __alloc_pages_slowpath+0x42e/0x480
[66568.253055]  [<c01b855f>] __alloc_pages_nodemask+0x10f/0x120
[66568.253077]  [<c01ca076>] do_anonymous_page+0x66/0x200
...

Hopefully I'll get some time to RTFS, but at the moment I'm trying to
understand whether or not this is *intended* behaviour. When there's no
swap available, should the kernel be calling the OOM killer instead of
trying to reclaim memory from buffers/cache?

Thanks,

-- 
Jonathan Miles <jon@cybus.co.uk>
http://www.linkedin.com/in/jonmiles


--------------040308000208070205060903
Content-Type: text/plain;
 name="OOM2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="OOM2.txt"

[66568.252903] hald invoked oom-killer: gfp_mask=0x280da, order=0, oomkilladj=0
[66568.252924] hald cpuset=/ mems_allowed=0
[66568.252931] Pid: 844, comm: hald Not tainted 2.6.31-14-generic #48-Ubuntu
[66568.252937] Call Trace:
[66568.252963]  [<c01b5a0f>] oom_kill_process+0x9f/0x250
[66568.252981]  [<c01b601e>] ? select_bad_process+0xbe/0xf0
[66568.252989]  [<c01b60a1>] __out_of_memory+0x51/0xa0
[66568.252997]  [<c01b6143>] out_of_memory+0x53/0xb0
[66568.253045]  [<c01b83fe>] __alloc_pages_slowpath+0x42e/0x480
[66568.253055]  [<c01b855f>] __alloc_pages_nodemask+0x10f/0x120
[66568.253077]  [<c01ca076>] do_anonymous_page+0x66/0x200
[66568.253086]  [<c012d3cd>] ? kmap_atomic_prot+0xcd/0xf0
[66568.253093]  [<c01cc460>] handle_mm_fault+0x330/0x380
[66568.253116]  [<c0317c58>] ? vsnprintf+0xc8/0x400
[66568.253128]  [<c0572cf8>] do_page_fault+0x148/0x380
[66568.253150]  [<c0572bb0>] ? do_page_fault+0x0/0x380
[66568.253160]  [<c0570be3>] error_code+0x73/0x80
[66568.253181]  [<c0318f06>] ? copy_to_user+0x116/0x120
[66568.253194]  [<c02025e7>] simple_read_from_buffer+0x67/0xb0
[66568.253217]  [<c023940f>] sysfs_read_file+0x4f/0x80
[66568.253239]  [<c01e78b7>] vfs_read+0x97/0x190
[66568.253249]  [<c02393c0>] ? sysfs_read_file+0x0/0x80
[66568.253270]  [<c01e7ecd>] sys_read+0x3d/0x70
[66568.253281]  [<c010336c>] syscall_call+0x7/0xb
[66568.253289] Mem-Info:
[66568.253305] DMA per-cpu:
[66568.253311] CPU    0: hi:    0, btch:   1 usd:   0
[66568.253319] CPU    1: hi:    0, btch:   1 usd:   0
[66568.253336] Normal per-cpu:
[66568.253343] CPU    0: hi:  186, btch:  31 usd: 181
[66568.253351] CPU    1: hi:  186, btch:  31 usd:  80
[66568.253367] HighMem per-cpu:
[66568.253373] CPU    0: hi:  186, btch:  31 usd:  35
[66568.253380] CPU    1: hi:  186, btch:  31 usd: 133
[66568.253402] Active_anon:174534 active_file:116377 inactive_anon:63691
[66568.253408]  inactive_file:118428 unevictable:0 dirty:0 writeback:0 unstable:0
[66568.253413]  free:12183 slab:8778 mapped:71864 pagetables:2711 bounce:0
[66568.253437] DMA free:8076kB min:64kB low:80kB high:96kB active_anon:236kB inactive_anon:256kB active_file:0kB inactive_file:56kB unevictable:0kB present:15852kB pages_scanned:504 all_unreclaimable? no
[66568.253463] lowmem_reserve[]: 0 865 2007 2007
[66568.253493] Normal free:40184kB min:3728kB low:4660kB high:5592kB active_anon:196728kB inactive_anon:60324kB active_file:248012kB inactive_file:248492kB unevictable:0kB present:885944kB pages_scanned:1232480 all_unreclaimable? no
[66568.253510] lowmem_reserve[]: 0 0 9134 9134
[66568.253538] HighMem free:472kB min:512kB low:1740kB high:2972kB active_anon:501172kB inactive_anon:194184kB active_file:217496kB inactive_file:225164kB unevictable:0kB present:1169244kB pages_scanned:1912736 all_unreclaimable? yes
[66568.253565] lowmem_reserve[]: 0 0 0 0
[66568.253588] DMA: 3*4kB 4*8kB 2*16kB 2*32kB 4*64kB 2*128kB 3*256kB 1*512kB 2*1024kB 0*2048kB 1*4096kB = 8076kB
[66568.253631] Normal: 9050*4kB 0*8kB 1*16kB 2*32kB 3*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 40184kB
[66568.253671] HighMem: 2*4kB 54*8kB 2*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 472kB
[66568.253721] 340269 total pagecache pages
[66568.253727] 0 pages in swap cache
[66568.253734] Swap cache stats: add 0, delete 0, find 0/0
[66568.253752] Free swap  = 0kB
[66568.253757] Total swap = 0kB
[66568.277410] 521939 pages RAM
[66568.277413] 294613 pages HighMem
[66568.277414] 8809 pages reserved
[66568.277416] 378515 pages shared
[66568.277418] 259136 pages non-shared
[66568.277431] Out of memory: kill process 7811 (run-mozilla.sh) score 169511 or a child
[66568.277508] Killed process 7815 (thunderbird-bin)

--------------040308000208070205060903--
