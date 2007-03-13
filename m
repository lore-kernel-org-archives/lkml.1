Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbXCMKw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbXCMKw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXCMKw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:52:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbXCMKw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:52:56 -0400
Date: Tue, 13 Mar 2007 03:52:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: clameter@sgi.com, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-Id: <20070313035250.f908a50e.akpm@linux-foundation.org>
In-Reply-To: <45F65ADA.9010501@yahoo.com.au>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
	<20070313005334.853559ca.akpm@linux-foundation.org>
	<45F65ADA.9010501@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 19:03:38 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Andrew Morton wrote:
> >>On Tue, 13 Mar 2007 00:13:25 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> >>Page table pages have the characteristics that they are typically zero
> >>or in a known state when they are freed.
> > 
> > 
> > Well if they're zero then perhaps they should be released to the page allocator
> > to satisfy the next __GFP_ZERO request.  If that request is for a pagetable
> > page, we break even (except we get to remove special-case code).  If that
> > __GFP_ZERO allocation was or some application other than for a pagetable, we
> > win.
> > 
> > iow, can we just nuke 'em?
> 
> Page allocator still requires interrupts to be disabled, which this doesn't.

Bah.  How many cli/sti statements fit into a single cachemiss?

> Considering there isn't much else that frees known zeroed pages, I wonder if
> it is worthwhile.

If you want a zeroed page for pagecache and someone has just stuffed a
known-zero, cache-hot page into the pagetable quicklists, you have good
reason to be upset.

In fact, if you want a _non_-zeroed page and someone has just stuffed a
known-zero, cache-hot page into the pagetable quicklists, you still have
reason to be upset.  You *want* that cache-hot page.

Generally, all these little private lists of pages (such as the ones which
slab had/has) are a bad deal.  Cache effects preponderate and I do think
we're generally better off tossing the things into a central pool.

Plus, we can get in a situation where take a cache-cold, known-zero page
from the pte quicklist when there is a cache-hot, non-zero page sitting in
the page allocator.  I suspect that zeroing the cache-hot page would take a
similar amount of time to a single miss agains the cache-cold page.

I'm not saying that I _know_ that the quicklists are pointless, but I don't
think it's established that they are pointful.

ISTR that experiments with removing the i386 quicklists made zero
difference, but that was an awfully long time ago.  Significantly, it
predated per-cpu-pages..


> Last time the zeroidle discussion came up was IIRC not actually real performance
> gain, just cooking the 1024 CPU threaded pagefault numbers ;)

Maybe, dunno.  It was apparently a win on powerpc many years ago.  I had a
fiddle with it 5-6 years ago on x86 using a cache-disabled mapping of the
page.  But it needed too much support in core VM to bother.  Since then
we've grown per-cpu page magazines and __GFP_ZERO.  Plus I'm not aware of
anyone having tried doing it on x86 with non-temporal stores.

