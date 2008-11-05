Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYKEUmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYKEUmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbYKEUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:42:18 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:54643 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbYKEUmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:42:17 -0500
Date: Wed, 5 Nov 2008 14:40:05 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: peterz@infradead.org, rientjes@google.com, npiggin@suse.de,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <20081105123150.d6628805.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811051434300.31450@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
 <20081104124753.fb1dde5a.akpm@linux-foundation.org> <1225831988.7803.1939.camel@twins>
 <20081104131637.68fbe055.akpm@linux-foundation.org> <1225833710.7803.1993.camel@twins>
 <20081104135004.f1717fcf.akpm@linux-foundation.org> <Pine.LNX.4.64.0811041601100.5077@quilx.com>
 <20081104143534.b5c16147.akpm@linux-foundation.org> <Pine.LNX.4.64.0811041648350.6254@quilx.com>
 <20081104153610.bbfd5ed8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0811042036000.31167@quilx.com> <20081104190505.769b93ec.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0811050747040.11867@quilx.com> <20081105104145.abd6fc91.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0811051415360.31450@quilx.com> <20081105123150.d6628805.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Andrew Morton wrote:

> > That means running reclaim. But we are only interested in getting rid of
> > dirty pages. Plus the filesystem guys have repeatedly pointed out that
> > page sized I/O to random places in a file is not a good thing to do. There
> > was actually talk of stopping kswapd from writing out pages!
>
> They don't have to be reclaimed.

Well the LRU is used for reclaim. If you step over it then its using the
existing reclaim logic in vmscan.c right?

> > > There would probably be performance benefits in doing
> > > address_space-ordered writeback, so the dirty-memory throttling could
> > > pick a dirty page off the LRU, go find its inode and then feed that
> > > into __sync_single_inode().
> >
> > We cannot call into the writeback functions for an inode from a reclaim
> > context. We can write back single pages but not a range of pages from an
> > inode due to various locking issues (see discussion on slab defrag
> > patchset).
>
> We're not in a reclaim context.  We're in sys_write() context.

Dirtying a page can occur from a variety of kernel contexts.

> > > But _are_ people hitting this problem?  I haven't seen any real-looking
> > > reports in ages.  Is there some workaround?  If so, what is it?  How
> > > serious is this problem now?
> >
> > Are there people who are actually having memcg based solutions deployed?
> > No enterprise release includes it yet so I guess that there is not much of
> > a use yet.
>
> If you know the answer then please provide it.  If you don't, please
> say "I don't know".

I thought we were talking about memcg related reports. I have dealt with
scores of the cpuset related ones in my prior job.

Workarounds are:

1. Reduce the global dirty ratios so that the number of dirty pages in a
cpuset cannot become too high.

2. Do not create small cpusets where the system can dirty all pages.

3. Find other ways to limit the dirty pages (run sync once in a while or
so).
