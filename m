Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZGGIBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZGGIBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZGGIBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:01:13 -0400
Received: from lucidpixels.com ([75.144.35.66]:40257 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbZGGIBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:01:12 -0400
Date: Tue, 7 Jul 2009 04:01:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: David Rientjes <rientjes@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13648] nfsd: page allocation failure
In-Reply-To: <alpine.DEB.2.00.0907062046060.29086@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0907070400370.26479@p34.internal.lan>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.BkG.-_oUKB@chimera> <alpine.DEB.2.00.0907062046060.29086@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Jul 2009, David Rientjes wrote:

> On Tue, 7 Jul 2009, Rafael J. Wysocki wrote:
>
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.29 and 2.6.30.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
>> Subject		: nfsd: page allocation failure
>> Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
>> Date		: 2009-06-22 12:08 (15 days old)
>> References	: http://lkml.org/lkml/2009/6/22/309
>>
>
> Here's the last page allocation failure in the bug report:
>
> [415964.311165] nfsd: page allocation failure. order:0, mode:0x20
> [415964.311168] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
> [415964.311170] Call Trace:
> [415964.311171]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
> [415964.311179]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
> [415964.311182]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
> [415964.311185]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
> [415964.311188]  [<ffffffff805ea846>] ? tcp_send_ack+0x26/0x120
> [415964.311191]  [<ffffffff805e867d>] ? tcp_rcv_established+0x7bd/0x940
> [415964.311193]  [<ffffffff805efb1d>] ? tcp_v4_do_rcv+0xdd/0x210
> [415964.311195]  [<ffffffff805f02d6>] ? tcp_v4_rcv+0x686/0x750
> ...
> [415964.311319] Active_anon:154810 active_file:131162 inactive_anon:33447
> [415964.311320]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
> [415964.311321]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
> [415964.311325] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
> [415964.311328] lowmem_reserve[]: 0 3246 7980 7980
> [415964.311333] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
> [415964.311336] lowmem_reserve[]: 0 0 4734 4734
> [415964.311341] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
> [415964.311344] lowmem_reserve[]: 0 0 0 0
> ...
>
> There's simply no memory available in ZONE_NORMAL to satisfy the atomic
> allocation; you've been able to allocate beyond the 9708K minimum
> watermark because it's GFP_ATOMIC (and then only to 3641K because of
> ALLOC_HIGH and ALLOC_HARDER).
>
> 112116 pages, or 438M of memory, is dirty.
>
> [415964.311369] 827035 total pagecache pages
> [415964.311371] 4728 pages in swap cache
> [415964.311373] Swap cache stats: add 12746, delete 8018, find 16878/17480
> [415964.311374] Free swap  = 16756356kB
> [415964.311375] Total swap = 16787768kB
> [415964.312141] 2277376 pages RAM
> [415964.312141] 252254 pages reserved
> [415964.312141] 546309 pages shared
> [415964.312141] 1520221 pages non-shared
>
> And since you have an 8G machine, that value is only about half of the
> default dirty_background_ratio setting of 10 to start pdflush from writing
> it out.
>
> What is suspect is almost half of your system's memory is consumed by
> slab.  Have you been able to collect slabtop -o when these failures happen
> to determine whether this is a duplicate of
> http://bugzilla.kernel.org/show_bug.cgi?id=13518 ?
>

As of yet, the problem has not recurred, when it does, will pull slabtop 
-o output.

Justin.
