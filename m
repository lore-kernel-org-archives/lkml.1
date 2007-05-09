Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbXEIO2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbXEIO2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbXEIO2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:28:49 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:14257 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbXEIO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:28:48 -0400
Date: Wed, 9 May 2007 15:28:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
In-Reply-To: <4641BFCE.6090200@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705091522110.15345@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com>
 <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com>
 <4641BFCE.6090200@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 09 May 2007 14:28:46.0617 (UTC) FILETIME=[5A728890:01C79246]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGFuZHJlYUBzdXNlLmRlAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBsaW51eC1tbUBrdmFjay5vcmcAaGNoQGluZnJhZGVhZC5vcmcAbmlja3BpZ2dpbkB5YWhvby5jb20uYXUA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Nick Piggin wrote:
> Hugh Dickins wrote:
> > On Wed, 2 May 2007, Nick Piggin wrote:
> 
> > > >But I'm pretty sure (to use your words!) regular truncate was not racy
> > > >before: I believe Andrea's sequence count was handling that case fine,
> > > >without a second unmap_mapping_range.
> > >
> > >OK, I think you're right. I _think_ it should also be OK with the
> > >lock_page version as well: we should not be able to have any pages
> > >after the first unmap_mapping_range call, because of the i_size
> > >write. So if we have no pages, there is nothing to 'cow' from.
> > 
> > I'd be delighted if you can remove those later unmap_mapping_ranges.
> > As I recall, the important thing for the copy pages is to be holding
> > the page lock (or whatever other serialization) on the copied page
> > still while the copy page is inserted into pagetable: that looks
> > to be so in your __do_fault.
> 
> Hmm, on second thoughts, I think I was right the first time, and do
> need the unmap after the pages are truncated. With the lock_page code,
> after the first unmap, we can get new ptes mapping pages, and
> subsequently they can be COWed and then the original pte zapped before
> the truncate loop checks it.

The filesystem (or page cache) allows pages beyond i_size to come
in there?  That wasn't a problem before, was it?  But now it is?

> 
> However, I wonder if we can't test mapping_mapped before the spinlock,
> which would make most truncates cheaper?

Slightly cheaper, yes, though I doubt it'd be much in comparison with
actually doing any work in unmap_mapping_range or truncate_inode_pages.
Suspect you'd need a barrier of some kind between the i_size_write and
the mapping_mapped test?  But that's a change we could have made at
any time if we'd bothered, it's not really the issue here.

Hugh
