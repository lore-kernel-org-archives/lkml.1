Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZCFRTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZCFRTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZCFRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:19:12 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47483 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbZCFRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:19:11 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236358369.10626.58.camel@nimitz>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
	 <1236214452.22399.68.camel@nimitz>
	 <1236357616.3882.66.camel@pc1117.cambridge.arm.com>
	 <1236358369.10626.58.camel@nimitz>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 06 Mar 2009 17:18:08 +0000
Message-Id: <1236359888.3882.77.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 17:18:22.0639 (UTC) FILETIME=[8D5B83F0:01C99E7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 08:52 -0800, Dave Hansen wrote:
> On Fri, 2009-03-06 at 16:40 +0000, Catalin Marinas wrote:
> > It seems that node_start_pfn() isn't present on all the architectures. I
> > ended up with something like below:
> > 
> > +	/* struct page scanning for each node */
> > +	for_each_online_node(i) {
> > +		pg_data_t *pgdat = NODE_DATA(i);
> > +		unsigned long start_pfn = pgdat->node_start_pfn;
> > +		unsigned long end_pfn = start_pfn +
> > +			pgdat->node_spanned_pages - 1;
> > +		unsigned long pfn;
> > +
> > +		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
> > +			struct page *page;
> > +
> > +			if (!pfn_valid(pfn))
> > +				continue;
> > +			page = pfn_to_page(pfn);
> > +			/* only scan if page is in use */
> > +			if (page_count(page) == 0)
> > +				continue;
> > +			scan_block(page, page + 1, NULL);
> > +		}
> > +	}
> 
> What does scan_block() actually scan?  Is that second argument
> inclusive?

No, it's exclusive. In the above case, it just scans a struct page at
the given pointer.

> I think you will miss scanning the contents of the last 'struct page' if
> you do it this way because of the -1 you do to end_pfn.

Fixed.

> > Are the pgdat->node_start_pfn and pgdat->node_spanned_pages always
> > valid? Thanks.
> 
> The variables themselves?  I'm sure there's a window in early boot where
> they aren't valid, but other than that they should be OK unless you're
> int the middle of a hotplug operation.
> 
> See pgdat_resize_(un)lock() in include/linux/memory_hotplug.h.

I wouldn't hold a lock for that long. It's not really critical to scan
all the page structures at a time as there are subsequent scans as well,
so some can be missed.

-- 
Catalin

