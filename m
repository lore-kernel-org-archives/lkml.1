Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZCESFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZCESFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZCESFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:05:42 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39808 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbZCESFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:05:41 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236214452.22399.68.camel@nimitz>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
	 <1236214452.22399.68.camel@nimitz>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 05 Mar 2009 18:04:34 +0000
Message-Id: <1236276274.18136.32.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2009 18:04:54.0724 (UTC) FILETIME=[E3282040:01C99DBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 16:54 -0800, Dave Hansen wrote:
> On Tue, 2009-03-03 at 15:01 +0000, Catalin Marinas wrote:
> > > +     /* mem_map scanning */
> > > +     for_each_online_node(i) {
> > > +             struct page *page, *end;
> > > +
> > > +             page = NODE_MEM_MAP(i);
> > > +             end  = page + NODE_DATA(i)->node_spanned_pages;
> > > +
> > > +             scan_block(page, end, NULL);
> > > +     }
[...]
> The above is *not* a valid code sequence.
> 
> It is valid with discontig, but isn't valid for sparsemem.  You simply
> can't expect to do math on 'struct page' pointers for any granularity
> larger than MAX_ORDER_NR_PAGES.
> 
> Also, we don't even define NODE_MEM_MAP() for all configurations so that
> code snippet won't even compile.  We would be smart to kill that macro.
> 
> One completely unoptimized thing you can do which will scan a 'struct
> page' at a time is this:
> 
> 	for_each_online_node(i) {
> 		unsigned long pfn;
> 		for (pfn = node_start_pfn(i); pfn < node_end_pfn(i); pfn++) {
> 			struct page *page;
> 			if (!pfn_valid(pfn))
> 				continue;
> 			page = pfn_to_page(pfn);
> 			scan_block(page, page+1, NULL);
> 		}
> 	}
> 		
> The way to optimize it would be to call scan_block() only once for each
> MAX_ORDER_NR_PAGES that you encounter.  The other option would be to use
> the active_regions functions to walk the memory.  
> 
> Is there a requirement to reduce the number of calls to scan_block()
> here?

I think the improvement wouldn't be that big since scan_block() is
pretty time consuming as it checks every value that looks like a pointer
against a prio_tree.

BTW, is there a way to know whether the page is in use or on the free
list? Is page_count(page) feasible?

Thanks.

-- 
Catalin

