Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbZFQWp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbZFQWp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZFQWpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:45:13 -0400
Received: from cmpxchg.org ([85.214.51.133]:59733 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbZFQWpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:45:13 -0400
Date: Thu, 18 Jun 2009 00:41:49 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.org.uk>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v3] swap: virtual swap readahead
Message-ID: <20090617224149.GA16104@cmpxchg.org>
References: <20090609190128.GA1785@cmpxchg.org> <20090611143122.108468f1.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611143122.108468f1.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 02:31:22PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 9 Jun 2009 21:01:28 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> > [resend with lists cc'd, sorry]
> > 
> > +static int swap_readahead_ptes(struct mm_struct *mm,
> > +			unsigned long addr, pmd_t *pmd,
> > +			swp_entry_t *entries,
> > +			unsigned long cluster)
> > +{
> > +	unsigned long window, min, max, limit;
> > +	spinlock_t *ptl;
> > +	pte_t *ptep;
> > +	int i, nr;
> > +
> > +	window = cluster << PAGE_SHIFT;
> > +	min = addr & ~(window - 1);
> > +	max = min + cluster;
> 
> Johannes, I wonder there is no reason to use "alignment".

I am wondering too.  I digged into the archives but the alignment
comes from a change older than what history.git documents, so I wasn't
able to find written down justification for this.

> I think we just need to read "nearby" pages. Then, this function's
> scan range should be
> 
> 	[addr - window/2, addr + window/2)
> or some.
> 
> And here, too
> > +	if (!entries)	/* XXX: shmem case */
> > +		return swapin_readahead_phys(entry, gfp_mask, vma, addr);
> > +	pmin = swp_offset(entry) & ~(cluster - 1);
> > +	pmax = pmin + cluster;
> 
> pmin = swp_offset(entry) - cluster/2.
> pmax = swp_offset(entry) + cluster/2.
> 
> I'm sorry if I miss a reason for using "alignment".

Perhas someone else knows a good reason for it, but I think it could
even be harmful.

Chances are that several processes fault around the same slots
simultaneously.  By letting them all start at the same aligned offset
we have a maximum race between them and they all allocate pages for
the same slots concurrently.

By placing the window unaligned we decrease this overlapping, so it
sounds like a good idea.

It would increase the amount of readahead done even more, though, and
Fengguang already measured degradation in IO latency with my patch, so
this probably needs more changes to work well.
