Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYLBKjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYLBKjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYLBKjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:39:35 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36346 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYLBKjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:39:33 -0500
Date: Tue, 2 Dec 2008 10:39:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Russ Anderson <rja@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] badpage: simplify page_alloc flag check+clear
In-Reply-To: <Pine.LNX.4.64.0812012014150.30344@quilx.com>
Message-ID: <Pine.LNX.4.64.0812020947440.5306@blonde.anvils>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
 <Pine.LNX.4.64.0812010038220.11401@blonde.site> <Pine.LNX.4.64.0812010843230.15331@quilx.com>
 <Pine.LNX.4.64.0812012349330.18893@blonde.anvils> <Pine.LNX.4.64.0812012014150.30344@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Christoph Lameter wrote:
> On Mon, 1 Dec 2008, Hugh Dickins wrote:
> > > > PAGE_FLAGS_CHECK_AT_FREE
> 
> > > Rename this to PAGE_FLAGS_CLEAR_WHEN_FREE?
> >
> > No, that's a list of just the ones it's checking at free;
> > it then (with this patch) goes on to clear all of them.
> 
> But they are always clear on free. The checking is irrelevant.

How about CHECK_PAGE_FLAGS_CLEAR_AT_FREE?

> 
> > One of the problems with PREP is that it's not obvious that it
> > means ALLOC: yes, I'd be happier with PAGE_FLAGS_CLEAR_AT_FREE.
> 
> Ok.

If you like the suggestion above, then for this one
how about CHECK_PAGE_FLAGS_CLEAR_AT_ALLOC?

I just haven't changed those names in the patch, continued to
use the names from before: they're probably not the names I'd
have chosen, but it is hard to write a paragraph in a name.

The one I really disliked was "PAGE_FLAGS" for an obscure
subset of page flags, and have got rid of that.

> > > This is equal to
> > >
> > > page->flags &=~PAGE_FLAGS_CHECK_AT_PREP;
> > >
> > > You can drop the if...
> >
> > I was intentionally following the existing style of
> > 	if (PageDirty(page))
> > 		__ClearPageDirty(page);
> > 	if (PageSwapBacked(page))
> > 		__ClearPageSwapBacked(page);
> > which is going out of its way to avoid dirtying a cacheline.
> >
> > In all the obvious cases, I think the cacheline will already
> > be dirty; but I guess there's an important case (high order
> > but not compound?) which has a lot of clean cachelines.
> 
> Free or alloc dirties the cacheline of the page struct regardless since
> the LRU field is always modified.
> 
> Well, ok. The not compound high order case may be an exception.
> 
> But then lets at least make a single check
> 
> If (page->flags & (all the flags including dirty and SwapBacked))
> 	zap-em.

That's exactly what I did, isn't it?

Hugh
