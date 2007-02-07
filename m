Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXBGICf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXBGICf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965675AbXBGICf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:02:35 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:51134 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965573AbXBGICf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:02:35 -0500
Date: Wed, 7 Feb 2007 00:02:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nate Diller <nate.diller@gmail.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <5c49b0ed0702061405u1c5e58a6n4e214f65987ab8d3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702062356130.2188@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> 
 <20070203005316.eb0b4042.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com> 
 <1170525860.3073.1054.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com> 
 <20070203172242.e5bf2534.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com> 
 <1170576977.3073.1100.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0702042236250.6748@schroedinger.engr.sgi.com>
 <5c49b0ed0702061405u1c5e58a6n4e214f65987ab8d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Nate Diller wrote:

> > The dirty ratio with the ZVCS would be
> > 
> > NR_DIRTY + NR_UNSTABLE_NFS
> >         /
> > NR_FREE_PAGES + NR_INACTIVE + NR_ACTIVE + NR_MLOCK
> 
> I don't understand why you want to account mlocked pages in
> dirty_ratio.  of course mlocked pages *can* be dirty, but they have no
> relevance in the write throttling code.  the point of dirty ratio is

mlocked pages can be counted as dirty pages. So if we do not include
NR_MLOCK in the number of total pages that could be dirty then we may in 
some cases have >100% dirty pages.

> to guarantee that there are some number of non-dirty, non-pinned,
> non-mlocked pages on the LRU, to (try to) avoid deadlocks where the
> writeback path needs to allocate pages, which many filesystems like to
> do.  if an mlocked page is clean, there's still no way to free it up,
> so it should not be treated as being on the LRU at all, for write
> throttling.  the ideal (IMO) dirty ratio would be

Hmmm... I think write throttling is different from reclaim. In write 
throttling the major objective is to decouple the applications from
the physical I/O. So the dirty ratio specifies how much "buffer" space
can be used for I/O. There is an issue that too many dirty pages will
cause difficulty for reclaim because pages can only be reclaimed after
writeback is complete.

And yes this is not true for mlocked pages.

> 
> NR_DIRTY - NR_DIRTY_MLOCKED + NR_UNSTABLE_NFS
>        /
> NR_FREE_PAGES + NR_INACTIVE + NR_ACTIVE
> 
> obviously it's kinda useless to keep an NR_DIRTY_MLOCKED counter, any
> of these mlock accounting schemes could easily be modified to update
> the NR_DIRTY counter so that it only reflects dirty unpinned pages,
> and not mlocked ones.

So you would be okay with dirty_ratio possibly be >100% of mlocked pages 
are dirty?

> is that the only place you wanted to have an accurate mocked page count?

Rik had some other ideas on what to do with it. I also think we may end up 
checking for excessive high mlock counts in various tight VM situations.

