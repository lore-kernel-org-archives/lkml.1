Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbYCCSpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbYCCSpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbYCCSpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:45:21 -0500
Received: from ns1.suse.de ([195.135.220.2]:58423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187AbYCCSpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:45:19 -0500
Date: Mon, 3 Mar 2008 19:45:17 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jack Steiner <steiner@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v8
Message-ID: <20080303184517.GA4951@wotan.suse.de>
References: <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random> <20080303032934.GA3301@wotan.suse.de> <20080303125152.GS8091@v2.random> <20080303131017.GC13138@wotan.suse.de> <20080303151859.GA19374@sgi.com> <20080303165910.GA23998@wotan.suse.de> <20080303180605.GA3552@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303180605.GA3552@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 12:06:05PM -0600, Jack Steiner wrote:
> On Mon, Mar 03, 2008 at 05:59:10PM +0100, Nick Piggin wrote:
> > > Maintaining a long-term reference on a page is a problem. The GRU does not
> > > currently maintain tables to track the pages for which dropins have been done.
> > > 
> > > The GRU has a large internal TLB and is designed to reference up to 8PB of
> > > memory. The size of the tables to track this many referenced pages would be
> > > a problem (at best).
> > 
> > Is it any worse a problem than the pagetables of the processes which have
> > their virtual memory exported to GRU? AFAIKS, no; it is on the same
> > magnitude of difficulty. So you could do it without introducing any
> > fundamental problem (memory usage might be increased by some constant
> > factor, but I think we can cope with that in order to make the core patch
> > really nice and simple).
> 
> Functionally, the GRU is very close to what I would consider to be the
> "standard TLB" model. Dropins and flushs map closely to processor dropins
> and flushes for cpus.  The internal structure of the GRU TLB is identical to
> the TLB of existing cpus.  Requiring the GRU driver to track dropins with
> long term page references seems to me a deviation from having the basic
> mmuops support a "standard TLB" model. AFAIK, no other processor requires
> this.

That is because the CPU TLBs have the mmu_gather batching APIs which
avoid the problem. It would be possible to do something similar for
GRU which would involve taking a reference for each page-to-be-invalidated
in invalidate_page, and release them when you invalidate_range. Or else
do some other scheme which makes mmu notifiers work similarly to the
mmu gather API. But not just go an invent something completely different
in the form of this invalidate_begin,clear linux pte,invalidate_end API.


> Tracking TLB dropins (and long term page references) could be done but it
> adds significant complexity and scaling issues. The size of the tables to
> track many TB (to PB) of memory can get large. If the memory is being
> referenced by highly threaded applications, then the problem becomes even
> more complex. Either tables must be replicated per-thread (and require even
> more memory), or the table structure becomes even more complex to deal with
> node locality, cacheline bouncing, etc.

I don't think it would be that significant in terms of complexity or
scaling.

For a quick solution, you could stick a radix tree in each of your mmu
notifiers registered (ie. one per mm), which is indexed on virtual address
>> PAGE_SHIFT, and returns the struct page *. Size is no different than
page tables, and locking is pretty scalable.

After that, I would really like to see whether the numbers justify
larger changes.

