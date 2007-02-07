Return-Path: <linux-kernel-owner+w=401wt.eu-S1422646AbXBGSjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646AbXBGSjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422689AbXBGSjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:39:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:28118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422646AbXBGSjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iY8picBeryNZw38scBZCnc729kWmnF3YEnUymcHDGDi2N9EQ2s2WUyQqHoq1YXjR/B6ybZCQhAxoY8dxMLQdJ+GFjmTyL6cPGPNV8QrzrcC8lfn2o+n9+kPoDTBEBQU25nV1Y51xwm08X3Gezf2gR8+GLfAVRJJ7Y+lD8YoLvw0=
Message-ID: <5c49b0ed0702071039uf20d0e7h8604b0e914f950f1@mail.gmail.com>
Date: Wed, 7 Feb 2007 10:39:04 -0800
From: "Nate Diller" <nate.diller@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702062356130.2188@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
	 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
	 <20070203172242.e5bf2534.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
	 <1170576977.3073.1100.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702042236250.6748@schroedinger.engr.sgi.com>
	 <5c49b0ed0702061405u1c5e58a6n4e214f65987ab8d3@mail.gmail.com>
	 <Pine.LNX.4.64.0702062356130.2188@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 6 Feb 2007, Nate Diller wrote:
>
> > > The dirty ratio with the ZVCS would be
> > >
> > > NR_DIRTY + NR_UNSTABLE_NFS
> > >         /
> > > NR_FREE_PAGES + NR_INACTIVE + NR_ACTIVE + NR_MLOCK
> >
> > I don't understand why you want to account mlocked pages in
> > dirty_ratio.  of course mlocked pages *can* be dirty, but they have no
> > relevance in the write throttling code.  the point of dirty ratio is
>
> mlocked pages can be counted as dirty pages. So if we do not include
> NR_MLOCK in the number of total pages that could be dirty then we may in
> some cases have >100% dirty pages.

unless we exclude mlocked dirty pages from NR_DIRTY accounting, which
is what i suggest should be done as part of this patch

> > to guarantee that there are some number of non-dirty, non-pinned,
> > non-mlocked pages on the LRU, to (try to) avoid deadlocks where the
> > writeback path needs to allocate pages, which many filesystems like to
> > do.  if an mlocked page is clean, there's still no way to free it up,
> > so it should not be treated as being on the LRU at all, for write
> > throttling.  the ideal (IMO) dirty ratio would be
>
> Hmmm... I think write throttling is different from reclaim. In write
> throttling the major objective is to decouple the applications from
> the physical I/O. So the dirty ratio specifies how much "buffer" space
> can be used for I/O. There is an issue that too many dirty pages will
> cause difficulty for reclaim because pages can only be reclaimed after
> writeback is complete.

NR_DIRTY is only used for write throttling, right?  well, and
reporting to user-space, but again, i suggest that user space should
get to see NR_MLOCKED as well.  would people flip out if NR_DIRTY
stopped showing pages that are mlocked, as long as a seperate
NR_MLOCKED variable was present?

> And yes this is not true for mlocked pages.
>
> >
> > NR_DIRTY - NR_DIRTY_MLOCKED + NR_UNSTABLE_NFS
> >        /
> > NR_FREE_PAGES + NR_INACTIVE + NR_ACTIVE
> >
> > obviously it's kinda useless to keep an NR_DIRTY_MLOCKED counter, any
> > of these mlock accounting schemes could easily be modified to update
> > the NR_DIRTY counter so that it only reflects dirty unpinned pages,
> > and not mlocked ones.
>
> So you would be okay with dirty_ratio possibly be >100% of mlocked pages
> are dirty?
>
> > is that the only place you wanted to have an accurate mocked page count?
>
> Rik had some other ideas on what to do with it. I also think we may end up
> checking for excessive high mlock counts in various tight VM situations.

i'd be wary of a VM algorithm that treated mlocked pages any
differently than, say, unreclaimable slab pages.  but there are no
concrete suggestions yet, so i won't comment further.

all this is not to say that i dislike the idea of keeping mlocked
pages off the LRU, quite the opposite i've been looking for this for a
while and was hoping that Stone Wang's wired list patch
(http://lkml.org/lkml/2006/3/20/128) would get further than it did.
but i don't see the need to keep strict accounting if it hurts
performance in the common case.

NATE
