Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYGJRUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYGJRUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYGJRUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:20:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42380 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbYGJRUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:20:39 -0400
Date: Thu, 10 Jul 2008 12:20:36 -0500
From: Jack Steiner <steiner@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Hellwig <hch@infradead.org>,
       cl@linux-foundation.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       linux-mm@kvack.org
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Message-ID: <20080710172036.GB5972@sgi.com>
References: <20080703213348.489120321@attica.americas.sgi.com> <200807110021.29392.nickpiggin@yahoo.com.au> <20080710163329.GB1860@sgi.com> <200807110252.00887.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807110252.00887.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 02:52:00AM +1000, Nick Piggin wrote:
> On Friday 11 July 2008 02:33, Jack Steiner wrote:
> > On Fri, Jul 11, 2008 at 12:21:28AM +1000, Nick Piggin wrote:
> > > On Thursday 10 July 2008 23:29, Jack Steiner wrote:
> > > > On Thu, Jul 10, 2008 at 05:31:54PM +1000, Nick Piggin wrote:
> > > > > On Thursday 10 July 2008 05:11, Jack Steiner wrote:
> > > > > > I'll post the new GRU patch in a few minutes.
> > > > >
> > > > > It looks broken to me. How does it determine whether it has a
> > > > > normal page or not?
> > > >
> > > > Right. Hugepages are not currently supported by the GRU. There is code
> > > > that I know is missing/broken in this path. I'm trying to get the core
> > > > driver accepted, then I'll get the portion dealing with hugepages
> > > > working.
> > >
> > > Oh, I meant "normal" pages as in vm_normal_page(), or is there some
> > > other reason this codepath is exempt from them?
> >
> > Maybe...
> >
> > The GRU deals with cacheable memory only (the check is currently missing).
> > What is the proper way to catch a reference to a PTE that maps something
> > other than normal cacheable memory. Note that we support XPMEM. Some
> > cacheable memory that is valid for GRU references will be memory located on
> > other partitions. No page struct entries will exist nor will the physical
> > address ranges be known to the kernel. (Not in efi/e820 tables).
> >
> > One idea that I had was to use the attributes of the PTE. Is there
> > better way. vm_flags? ???
> >
> > Ideas???
> 
> lockless gup checks for struct page by checking a bit in the pte.
> This should be enough to guarantee  it is cacheable memory (unless
> another driver has done something tricky like set the the page's
> cache attributes to UC or WC -- I don't know if there is a way to
> completely avoid all corner cases).
> 

The GRU itself has no need to reference the page struct.
However, it WILL reference valid ptes that represent pages imported from
other SSIs via xpmem. These will have cacheable ptes but no page structs.

Maybe checking the pte attributes is the best way to do the check.

If we take this approach, what is a good API for the gup.c walker?
Return the pte attributes?

	int get_user_pte(struct mm_struct *mm, unsigned long address,
	        int write, unsigned long *paddr, int *pageshift, pgprot_t *prot)

The GRU would enforce the check for cacheable access.

--- jack
