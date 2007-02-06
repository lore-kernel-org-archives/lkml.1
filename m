Return-Path: <linux-kernel-owner+w=401wt.eu-S965525AbXBFWFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525AbXBFWFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965530AbXBFWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:05:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:10075 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525AbXBFWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dEHM5XuQu4hJ52kKWwnHSWty30217lAMIKIC1JioBKhEaaiCMxqTm7VQkSLjmIc/PXsZHznrKBTVbSVxv9EYdDrsXgSh4+wE1sOoC0uAGcTkSw3Iwys1c5A2uS6BReR+VbK8pI2GptE7WZ24Nuaew3uAP4nhQMK3grMXKK9HyDM=
Message-ID: <5c49b0ed0702061405u1c5e58a6n4e214f65987ab8d3@mail.gmail.com>
Date: Tue, 6 Feb 2007 14:05:44 -0800
From: "Nate Diller" <nate.diller@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702042236250.6748@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
	 <20070203005316.eb0b4042.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
	 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
	 <20070203172242.e5bf2534.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
	 <1170576977.3073.1100.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702042236250.6748@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Sun, 4 Feb 2007, Arjan van de Ven wrote:
>
> >
> > > Exclusion or inclusion of NR_MLOCK number is straightforward for the dirty
> > > ratio calcuations. global_page_state(NR_MLOCK) f.e. would get us totals on
> > > mlocked pages per zone. node_page_state(NR_MLOCK) gives a node specific
> > > number of mlocked pages. The nice thing about ZVCs is that it allows
> > > easy access to counts on different levels.
> >
> > however... mlocked pages still can be dirty, and want to be written back
> > at some point ;)
>
> Yes that is why we need to add them to the count of total pages.
>
> > I can see the point of doing dirty ratio as percentage of the LRU size,
> > but in that case you don't need to track NR_MLOCK, only the total LRU
> > size. (And yes it'll be sometimes optimistic because not all mlock'd
> > pages are moved off the lru yet, but I doubt you'll have that as a
> > problem in practice)
>
> The dirty ratio with the ZVCS would be
>
> NR_DIRTY + NR_UNSTABLE_NFS
>         /
> NR_FREE_PAGES + NR_INACTIVE + NR_ACTIVE + NR_MLOCK

I don't understand why you want to account mlocked pages in
dirty_ratio.  of course mlocked pages *can* be dirty, but they have no
relevance in the write throttling code.  the point of dirty ratio is
to guarantee that there are some number of non-dirty, non-pinned,
non-mlocked pages on the LRU, to (try to) avoid deadlocks where the
writeback path needs to allocate pages, which many filesystems like to
do.  if an mlocked page is clean, there's still no way to free it up,
so it should not be treated as being on the LRU at all, for write
throttling.  the ideal (IMO) dirty ratio would be

NR_DIRTY - NR_DIRTY_MLOCKED + NR_UNSTABLE_NFS
        /
NR_FREE_PAGES + NR_INACTIVE + NR_ACTIVE

obviously it's kinda useless to keep an NR_DIRTY_MLOCKED counter, any
of these mlock accounting schemes could easily be modified to update
the NR_DIRTY counter so that it only reflects dirty unpinned pages,
and not mlocked ones.

is that the only place you wanted to have an accurate mocked page count?

NATE
