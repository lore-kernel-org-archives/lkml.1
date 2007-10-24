Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXJXIJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXJXIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXJXIJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:09:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43818 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbXJXIJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:09:41 -0400
Date: Wed, 24 Oct 2007 09:09:38 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
Message-ID: <20071024080937.GA10785@skynet.ie>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com> <471E5021.8090300@cs.helsinki.fi> <Pine.LNX.4.64.0710231250130.19904@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710231250130.19904@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/10/07 12:57), Christoph Lameter didst pronounce:
> On Tue, 23 Oct 2007, Pekka Enberg wrote:
> 
> > > > cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
> > 
> > Christoph Lameter wrote:
> > > Regular Order 0 alloc .... but why is there no memory available , reclaimed?
> > 
> > I am too wondering where all that memory is going. Logging /proc/meminfo and
> > slabinfo -S (see Documentation/vm/slabinfo.c) every few minutes or so probably
> > might help answering that question
> 
> __GFP_HARDWALL and __GFP_MOVABLE is set. I guess we have no cpusets on the 
> box? Wonder what the antifrag status is? Can we get /proc/pagetypeinfo?
> 

I do not believe the anti-frag status will make a difference as this is
a order-0 failure. Looking at the OOM messages;

Failure 1
> Active:386969 inactive:66065 dirty:0 writeback:0 unstable:0 free:3431 slab:11685 mapped:243 pagetables:14621 bounce:0
> DMA free:8036kB min:32kB low:40kB high:48kB active:2008kB inactive:1172kB present:12744kB pages_scanned:6852 all_unreclaimable? yes
> lowmem_reserve[]: 0 2003 2003 2003
> DMA32 free:5688kB min:5708kB low:7132kB high:8560kB active:1548100kB inactive:261040kB present:2051880kB pages_scanned:12798 112 all_unreclaimable? yes
> lowmem_reserve[]: 0 0 0 0
> DMA: 13*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8036kB
> DMA32: 518*4kB 6*8kB 19*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5688kB
> Swap cache: add 4908248, delete 4908248, find 699858/1120395, race 92+89
> Free swap  = 0kB
> Total swap = 987956kB
> Free swap:            0kB

No reclaimable memory, no free swap and free memory is below the min free
watermark on the DMA32 zone being allocated from. That system is genuinely
out of memory although I am surprised it didn't fallback to ZONE_DMA but
the likely explanation is the lowmem reserves.

Failure 2
> Active:306488 inactive:146569 dirty:0 writeback:0 unstable:0 free:3415 slab:11631 mapped:2 pagetables:14611 bounce:0
> DMA free:8044kB min:32kB low:40kB high:48kB active:1596kB
> inactive:1576kB present:12744kB pages_scanned:14865 all_unreclaimable?  yes
> lowmem_reserve[]: 0 2003 2003 2003
> DMA32 free:5616kB min:5708kB low:7132kB high:8560kB active:1226588kB inactive:582396kB present:2051880kB pages_scanned:13650148 all_unreclaimable? yes
> lowmem_reserve[]: 0 0 0 0
> DMA: 15*4kB 86*8kB 60*16kB 26*32kB 6*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8044kB
> DMA32: 498*4kB 5*8kB 20*16kB 12*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 5616kB
> Swap cache: add 4908570, delete 4908570, find 699873/1120438, race 92+89
> Free swap  = 0kB
> Total swap = 987956kB
> Free swap:            0kB

Same again - really OOM.

It seems to be the same all the way through.

I am somewhat at a loss to explain why SLUB would fail in this case when
SLAB wouldn't. One possibility is that SLAB is artifically holding up
processes in allocation so that fewer are running at the same time allowing
the overall job to complete. For a compile-time benchmark, it might not be
very noticable as the processes are already pretty short-lived. It would be
interesting to add more swap so that SLUB doesn't fail and see if there is
a difference in time-to-completion.

If SLUB is faster, it might imply that it is letting more compile-jobs
running at the same time. Output of vmstat during both runs (preferably with
an indication on the SLUB failure where the OOM occured) may tell us. If the
"running" and "blocked" column for SLUB are significantly higher than the
averages for SLAB, would it support that theory Christoph?

Another possibility is that SLUBs runtime overhead is higher although I find
that one harder to believe.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
