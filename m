Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZCEAya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZCEAya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 19:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZCEAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 19:54:20 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53060 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZCEAyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 19:54:18 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 16:54:12 -0800
Message-Id: <1236214452.22399.68.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 15:01 +0000, Catalin Marinas wrote:
> > +     /* mem_map scanning */
> > +     for_each_online_node(i) {
> > +             struct page *page, *end;
> > +
> > +             page = NODE_MEM_MAP(i);
> > +             end  = page + NODE_DATA(i)->node_spanned_pages;
> > +
> > +             scan_block(page, end, NULL);
> > +     }
> > 
> > The alternative is to inform kmemleak about the page structures returned
> > from __alloc_pages_internal() but there would be problems with recursive
> > calls into kmemleak when it allocates its own data structures.
> > 
> > I'll look at re-adding the hunk above, maybe with some extra checks like
> > pfn_valid().
> 
> Looking again at this, the node_mem_map is always contiguous and the
> code above only scans the node_mem_map, not the memory represented by
> the node (which may not be contiguous). So I think it is a valid code
> sequence.

The above is *not* a valid code sequence.

It is valid with discontig, but isn't valid for sparsemem.  You simply
can't expect to do math on 'struct page' pointers for any granularity
larger than MAX_ORDER_NR_PAGES.

Also, we don't even define NODE_MEM_MAP() for all configurations so that
code snippet won't even compile.  We would be smart to kill that macro.

One completely unoptimized thing you can do which will scan a 'struct
page' at a time is this:

	for_each_online_node(i) {
		unsigned long pfn;
		for (pfn = node_start_pfn(i); pfn < node_end_pfn(i); pfn++) {
			struct page *page;
			if (!pfn_valid(pfn))
				continue;
			page = pfn_to_page(pfn);
			scan_block(page, page+1, NULL);
		}
	}
		
The way to optimize it would be to call scan_block() only once for each
MAX_ORDER_NR_PAGES that you encounter.  The other option would be to use
the active_regions functions to walk the memory.  

Is there a requirement to reduce the number of calls to scan_block()
here?

-- Dave

