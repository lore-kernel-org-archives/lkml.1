Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXCMUtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXCMUtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbXCMUtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:49:06 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56075 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbXCMUtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:49:03 -0400
X-AuditID: d80ac287-9edd6bb000000de9-81-45f70e3f9843 
Date: Tue, 13 Mar 2007 20:49:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Martin Drab <drab@kepler.fjfi.cvut.cz>
cc: Carsten Otte <cotte.de@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <Pine.LNX.4.64.0703090227490.27568@kepler.fjfi.cvut.cz>
Message-ID: <Pine.LNX.4.64.0703132009570.11129@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
 <5c77e7070703080617r63cbccfevd2c6d678f16c2b03@mail.gmail.com>
 <Pine.LNX.4.64.0703082143370.25365@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703090103020.25365@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703090227490.27568@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 13 Mar 2007 20:49:03.0124 (UTC) FILETIME=[08997540:01C765B1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Martin Drab wrote:
> On Fri, 9 Mar 2007, Martin Drab wrote:
> > On Thu, 8 Mar 2007, Martin Drab wrote:
> > > On Thu, 8 Mar 2007, Carsten Otte wrote:
> > > > On 3/8/07, Martin Drab <drab@kepler.fjfi.cvut.cz> wrote:
> > > > > 
> > > > > The thing is that I'd like to prevent kernel to swap these pages out,
> > > > > because then I may loose some data when they are not available in time
> > > > > for the next round.
> > > > 
> > > > One think you could do is grab a reference to the pages upfront.
> > > 
> > > I'm not really sure what exactly do you mean by "grab a reference 
> > > upfront"?
> > 
> > I seem to get it now. So instead of setting PG_reserved upon allocation of 
> > the buffer pages, I should increase the referrence of the pages by calling 
> > get_page() on them and that would prevent the pages to get on the lru list 
> > and thus preventing them to be swapped out. Is that it?
> 
> Well, so I tried it. Truth is that the "Bad page" messages upon munmap(2) 
> are gone. But whether the pages are really prevented from being swapped 
> out? I don't know. I don't know how to find out.

Hi Martin, sorry for joining so late.

Most of your anxieties are unfounded: the pages your driver allocates
with __get_free_pages are not put on any LRU (until they're freed),
kernel pages are never swapped out, and making them visible to user-
space does not put them in any more danger of being swapped out;
but yes, if the refcounting goes wrong, that will cause premature
freeing, "Bad page" messages, trouble.

(Of course, filesystem pagecache pages are liable to be swapped
out, and anonymous userspace pages: but you'd have to take special
steps to go down those paths, which I'm confident you're not taking:
this code used to work, you say.)

Please disregard the suggestion to look at Infiniband, it will only
confuse you further: Infiniband core/uverbs_mem.c does provide a very
good example of how to handle the much more complex opposite of what
you're trying to do.  You have a driver making its pages visible to
userspace, Infiniband shows how a driver should deal with userspace
buffers made available to it (which does involve worrying about
those issues which were concerning you).

Your problem is that PageReserved used to work for you, and now
(post-2.6.14) it doesn't: we do now rely entirely on the refcount,
and will report "Bad page state" if a pagecount goes down to zero
while still marked as PageReserved, which is what you saw.

My guess is that you're using __get_free_pages with non-0 order?
But mapping individual PAGE_SIZE pages from that into userspace
by a nopage method?  That is liable to be a problem, yes, because
the refcount for the whole is kept in the first struct page, the
later struct pages showing refcount 0: the whole is supposed to
be dealt with all together, but userspace page accounting on exit
will treat each PAGE_SIZE separately.  PageReserved used to
override the refcount, but it no longer does so.

There's a number of different solutions to that, and fiddling with
the reference counts of the constituent pages is certainly one of
them; though better is to use split_page() (see mm/page_alloc.c),
then free the constituent pages separately at the end; (and better
is to avoid >0-order allocations since they're harder to guarantee,
but presumably you don't want to reorganize your driver right now;)
but the simplest change is to __get_free_pages with the __GFP_COMP
flag set, which marks all the constituent pages as constituents of
a compound page, and thereby keeps the refcounting right - that's
the solution we used in sound/core/memalloc.c when this problem
first came up (but it won't work pre-2.6.15).

Maybe the solution you've already adopted, with additional
get_page()s, is correct: but you need to be careful when your
module is unloaded, there's a danger of leaking the memory if
you don't put_page() the first, and there's a danger of... I
forget what exactly if you don't reset the counts properly on
the subsequent constituents.  __GFP_COMP to hold the compound
page properly together, or split_page() to split it properly
apart, are preferable.

Hugh
