Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYJOSGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYJOSGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJOSGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:06:24 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:37232 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751434AbYJOSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:06:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Gu+Mm3qClTj3yAAP9+xNN19gUyHlc9Rem9LoCXn+NLXYAC2fZ/HJWWzDyvTdDe434hSXhd3u1w/wZ+q4r+2a/NWOZIXEk5n2KtLV9E0TJNu5M/5vDy/5jfczd3vuYX+USL/daJmY79GGjRvMrSz9H8rDg1GbkuoSPFDhONEZxKk=  ;
X-YMail-OSG: cDfzTcgVM1le2uRLxiQgXhU704mIh7Us41UZVJkzhVFuGcrFlOIQ4Z_O0ZpYVJ.8og_XLSQfj..eRZdWmiY7EyH.vlF95UNa9l1DXI6JocMjkitgK.DwUdlXuItm614CC12EgNICEctwlqSShABGnwRlycbFmAFcRQOnwTGm
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 05:06:14 +1100
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au> <1224089658.3316.218.camel@calx> <200810160410.49894.nickpiggin@yahoo.com.au>
In-Reply-To: <200810160410.49894.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160506.14261.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 04:10, Nick Piggin wrote:
> On Thursday 16 October 2008 03:54, Matt Mackall wrote:
> > On Thu, 2008-10-16 at 03:34 +1100, Nick Piggin wrote:
> > > I think I see a possible memory ordering problem with SLOB:
> > > In slab caches with constructors, the constructor is run
> > > before returning the object to caller, with no memory barrier
> > > afterwards.
> > >
> > > Now there is nothing that indicates the _exact_ behaviour
> > > required here. Is it at all reasonable to expect ->ctor() to
> > > be visible to all CPUs and not just the allocating CPU?
> >
> > Do you have a failure scenario in mind?
> >
> > First, it's a categorical mistake for another CPU to be looking at the
> > contents of an object unless it knows that it's in an allocated state.
> >
> > For another CPU to receive that knowledge (by reading a causally-valid
> > pointer to it in memory), a memory barrier has to occur, no?
>
> No.
>
> For (slightly bad) example. Some architectures have a ctor for their
> page table page slabs. Not a bad thing to do.
>
> Now they allocate these guys, take a lock, then insert them into the
> page tables. The lock is only an acquire barrier, so it can leak past
> stores.
>
> The read side is all lockless and in some cases even done by hardware.
>
> Now in _practice_, this is not a problem because some architectures
> don't have ctors, and I spotted the issue and put proper barriers in
> there. But it was a known fact that ctors were always used, and if I
> had assumed ctors were barriers so didn't need the wmb, then there
> would be a bug.
>
> Especially the fact that a lock doesn't order the stores makes me
> worried that a lockless read-side algorithm might have a bug here.
> Fortunately, most of them use RCU and probably use rcu_assign_pointer
> even if they do have ctors. But I can't be sure...

OK, now I have something that'll blow your fuckin mind.

anon_vma_cachep.

P0
do_anonymous_page()
 anon_vma_prepare()
  ctor(anon_vma)
  [sets vma->anon_vma = anon_vma]

P1
do_anonymous_page()
 anon_vma_prepare()
  [sees P0 already allocated it]
 lru_cache_add(page)
  [flushes page to lru]
 page_add_anon_rmap (increments mapcount)
  page_set_anon_rmap
   [sets page->anon_vma = anon_vma]

P2
find page from lru
page_referenced()
 page_referenced_anon()
  page_lock_anon_vma()
   [loads anon_vma from page->anon_vma]
   spin_lock(&anon_vma->lock)


Who was it that said memory ordering was self-evident?

For everyone else:

P1 sees P0's store to vma->anon_vma, then P2 sees P1's store
to page->anon_vma (among others), but P2 does not see P0's ctor
store to initialise anon_vma->lock.

And there seems like another bug there too, but just a plain control
race rather than strictly[*] a data race, P0 is executing list_add_tail
of vma to anon_vma->head at some point here too, so even assuming
we're running on a machine with transitive store ordering, then the
above race can't hit, then P2 subsequently wants to run a
list_for_each_entry over anon_vma->head while P0 is in the process of
modifying it.

Am I the one who's bamboozled, or can anyone confirm?
