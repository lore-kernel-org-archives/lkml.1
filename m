Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbXEUTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbXEUTCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXEUTCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:02:13 -0400
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:32770 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbXEUTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:02:12 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 15:01:51 EDT
Date: Mon, 21 May 2007 20:39:37 +0200 (CEST)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Hugh Dickins <hugh@veritas.com>
cc: Carsten Otte <cotte.de@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <Pine.LNX.4.64.0703132009570.11129@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0705211925080.12555@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
 <5c77e7070703080617r63cbccfevd2c6d678f16c2b03@mail.gmail.com>
 <Pine.LNX.4.64.0703082143370.25365@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703090103020.25365@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703090227490.27568@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703132009570.11129@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Hugh Dickins wrote:

> On Fri, 9 Mar 2007, Martin Drab wrote:
> > On Fri, 9 Mar 2007, Martin Drab wrote:
> > > On Thu, 8 Mar 2007, Martin Drab wrote:
> > > > On Thu, 8 Mar 2007, Carsten Otte wrote:
> > > > > On 3/8/07, Martin Drab <drab@kepler.fjfi.cvut.cz> wrote:
> > > > > > 
> > > > > > The thing is that I'd like to prevent kernel to swap these pages out,
> > > > > > because then I may loose some data when they are not available in time
> > > > > > for the next round.
> > > > > 
> > > > > One think you could do is grab a reference to the pages upfront.
> > > > 
> > > > I'm not really sure what exactly do you mean by "grab a reference 
> > > > upfront"?
> > > 
> > > I seem to get it now. So instead of setting PG_reserved upon allocation of 
> > > the buffer pages, I should increase the referrence of the pages by calling 
> > > get_page() on them and that would prevent the pages to get on the lru list 
> > > and thus preventing them to be swapped out. Is that it?
> > 
> > Well, so I tried it. Truth is that the "Bad page" messages upon munmap(2) 
> > are gone. But whether the pages are really prevented from being swapped 
> > out? I don't know. I don't know how to find out.
> 
> Hi Martin, sorry for joining so late.

Hi, Hugh, this time I'm sorry for responding sooo late.

> Most of your anxieties are unfounded: the pages your driver allocates
> with __get_free_pages are not put on any LRU (until they're freed),
> kernel pages are never swapped out, and making them visible to user-
> space does not put them in any more danger of being swapped out;
> but yes, if the refcounting goes wrong, that will cause premature
> freeing, "Bad page" messages, trouble.

Good, I needed to know that.

> (Of course, filesystem pagecache pages are liable to be swapped
> out, and anonymous userspace pages: but you'd have to take special
> steps to go down those paths, which I'm confident you're not taking:
> this code used to work, you say.)

Well it wasn't this code in particular, but another driver I was putting 
together some while ago and which used the same technique for mmap().
This what I'm putting together now is a new driver, but in this doing 
simillar thing.

> Please disregard the suggestion to look at Infiniband, it will only
> confuse you further: Infiniband core/uverbs_mem.c does provide a very
> good example of how to handle the much more complex opposite of what
> you're trying to do.  You have a driver making its pages visible to
> userspace, Infiniband shows how a driver should deal with userspace
> buffers made available to it (which does involve worrying about
> those issues which were concerning you).

Well, yes, in this case I'm solving the direction when kernel acquires 
data into kernel-allocated pages and provides them to user-space. However 
the second part of the driver (that I don't yet have finished, but will 
write in the future) will do the opposite. I.e. the application will 
generate data, that would have to be sent to the device. And of course I'd 
be glad if you help me choose the best way to do that.

Would in that case be better to do the same as I do for the first part, 
i.e. mmap() kernel pages to user-space, let the app fill them, and then 
send (queue for sending) them when munmap()ped? Or would it be better to 
use the infiniband approach to mmap() the user-space pages and send them 
directly? (The pages would have to be transferrable by the USB DMA, 
possibly without too much overhead.) Perhaps in this case the latter case 
would be better? Or maybe use some completely different approach?

...
> My guess is that you're using __get_free_pages with non-0 order?
> But mapping individual PAGE_SIZE pages from that into userspace
> by a nopage method?  That is liable to be a problem, yes, because
> the refcount for the whole is kept in the first struct page, the
> later struct pages showing refcount 0: the whole is supposed to
> be dealt with all together, but userspace page accounting on exit
> will treat each PAGE_SIZE separately.  PageReserved used to
> override the refcount, but it no longer does so.
> 
> There's a number of different solutions to that, and fiddling with
> the reference counts of the constituent pages is certainly one of
> them; though better is to use split_page() (see mm/page_alloc.c),
> then free the constituent pages separately at the end; (and better
> is to avoid >0-order allocations since they're harder to guarantee,
> but presumably you don't want to reorganize your driver right now;)
> but the simplest change is to __get_free_pages with the __GFP_COMP
> flag set, which marks all the constituent pages as constituents of
> a compound page, and thereby keeps the refcounting right - that's
> the solution we used in sound/core/memalloc.c when this problem
> first came up (but it won't work pre-2.6.15).

Yes I'm using non-0 order pages. The size of the transfer buffers is 
configurable depending on the preselected size of the transfer block. 
Currently default value is 32 KB (8 pages), but can be possibly even 
bigger (because the smaller the transfer buffers, the more overhead for 
the system is required).

However, meanwhile things have changed a little. I found out, that using 
the vma_nopage() for mapping the individual pages is highly inefficient, 
since it means a user-space to kernel-space switch and back for every page 
and that seems to slow the system down dramatically. Another severe 
slowdown was caused by processing (getting info about the buffer to be 
mmapped to the user-space, mmapping and processing the buffer data) the 
data of only one buffer at a time by the application.

So I had to rethink the strategy completely. The processing had to be done 
not one buffer at a time, but all (filled) buffers available at a time 
(with certain application-defined maximum, of course), so multiple buffers 
of page order 3 (=32KB, by default) have to be mmapped sequentially one 
after another in a predefined order to mmap() everything to the 
user-space as a continuous block of data. Another thing is that on each 
mmap() call I know exactly how much memory has to be mmapped, so I can 
allow to force-mmap all the memory in advance during the mmap() call.

And so I thought I'd allocate each individual buffer by the 
__get_free_pages() with the __GFP_COMP set, to make the entire buffer 
behave as one compound page and then during the mmap() call do a 
vm_insert_page() on each compount page representing each buffer I want to 
mmap in that call.

The comment in mm/memory.c by the vm_insert_page() says:

 * If you allocate a compound page, you need to have marked it as
 * such (__GFP_COMP), or manually just split the page up yourself
 * (see split_page()).

So I did and thought it would work. But it doesn't seem to. The 
vm_insert_page() call passes allright, but it still seems to mmap only the 
first page of each of the compount page, since when the application is 
accessing the data the nopage() method is still called for all other pages 
but the first one of each of the compound pages. Does that mean, that I 
still need to insert each individual page from within the compound page by 
the vm_insert_page() or what? (If that's so, perhaps it would be nice to 
comment it in the vm_insert_page() function.)

And about the reorganization of the driver to not make the >0 order page 
allocations. Well, I would do it, if you know about any other solution 
that would allow to do a USB URB transfer into a buffer (perhaps 
consisting of individually allocated 0-order pages as you suggest) that 
however definitelly needs to be bigger than one page. Perhaps something 
like a scatter-gather would do, but I don't know about any such mechanism 
for USB URBs.

The transfers need to be bigger than a page because the overhead 
of doing the transfer only by one page at a time would be unbearable.
It's an isochronous transfer doing exactly 3072 B each 125 microseconds.
Anything less than doing 8 of such transfers at one usb_submit_urb() call 
seems to posses too much overhead. If there is any other solution, I'd 
gladly change the driver, but unfortunatelly I don't know of any.

Thanks,
Martin
