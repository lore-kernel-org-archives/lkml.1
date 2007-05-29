Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXE2R6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXE2R6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXE2R62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:58:28 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34934 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXE2R61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:58:27 -0400
Date: Tue, 29 May 2007 18:58:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Martin Drab <drab@kepler.fjfi.cvut.cz>
cc: Carsten Otte <cotte.de@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <Pine.LNX.4.64.0705211925080.12555@kepler.fjfi.cvut.cz>
Message-ID: <Pine.LNX.4.64.0705291800300.28641@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
 <5c77e7070703080617r63cbccfevd2c6d678f16c2b03@mail.gmail.com>
 <Pine.LNX.4.64.0703082143370.25365@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703090103020.25365@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703090227490.27568@kepler.fjfi.cvut.cz>
 <Pine.LNX.4.64.0703132009570.11129@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211925080.12555@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZHJhYkBrZXBsZXIuZmpmaS5jdnV0LmN6AGNvdHRlLmRlQGdtYWlsLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Martin Drab wrote:
> On Tue, 13 Mar 2007, Hugh Dickins wrote:
> > On Fri, 9 Mar 2007, Martin Drab wrote:
> > 
> > Hi Martin, sorry for joining so late.
> 
> Hi, Hugh, this time I'm sorry for responding sooo late.

Ditto.

And preface: I'm a lousy person to be advising on driver writing, it
often turns out that I'm making a fool of myself one way or another.
If you're very lucky, not this time!

> Well, yes, in this case I'm solving the direction when kernel acquires 
> data into kernel-allocated pages and provides them to user-space. However 
> the second part of the driver (that I don't yet have finished, but will 
> write in the future) will do the opposite. I.e. the application will 
> generate data, that would have to be sent to the device. And of course I'd 
> be glad if you help me choose the best way to do that.
> 
> Would in that case be better to do the same as I do for the first part, 
> i.e. mmap() kernel pages to user-space, let the app fill them, and then 
> send (queue for sending) them when munmap()ped? Or would it be better to 
> use the infiniband approach to mmap() the user-space pages and send them 
> directly? (The pages would have to be transferrable by the USB DMA, 
> possibly without too much overhead.) Perhaps in this case the latter case 
> would be better? Or maybe use some completely different approach?

I'd strongly recommend that do as you are already doing, not switch
over to the Infiniband method.  The Infiniband drivers have to satisfy
standards that demand that userspace define the buffers, and that adds
a great deal of complexity and scope for error.  Unless you have to
satisfy an external standard of that kind, let your driver define
the buffers as it already does.  (From what you say later about 32kB
extents, I can't see how you could let userspace define them anyway.)

> Yes I'm using non-0 order pages. The size of the transfer buffers is 
> configurable depending on the preselected size of the transfer block. 
> Currently default value is 32 KB (8 pages), but can be possibly even 
> bigger (because the smaller the transfer buffers, the more overhead for 
> the system is required).

32kB, order 3.  Okay, __alloc_pages will retry for those, so there's
a reasonable chance you'll be able to get them.  But be aware that
asking for non-0 order pages will always place some strain on the
memory management system, no matter what anti-fragmentation measures
are taken now or in future.  I take it you have a hardware constraint
that makes the smaller buffers significantly less efficient; if it's
just a software issue, then better to redesign to use 0-order pages.

> However, meanwhile things have changed a little. I found out, that using 
> the vma_nopage() for mapping the individual pages is highly inefficient, 
> since it means a user-space to kernel-space switch and back for every page 
> and that seems to slow the system down dramatically. Another severe 
> slowdown was caused by processing (getting info about the buffer to be 
> mmapped to the user-space, mmapping and processing the buffer data) the 
> data of only one buffer at a time by the application.

Most drivers would use the same set of pages over and over again,
not have to fault each page each time it's used.

> So I had to rethink the strategy completely. The processing had to be done 
> not one buffer at a time, but all (filled) buffers available at a time 
> (with certain application-defined maximum, of course), so multiple buffers 
> of page order 3 (=32KB, by default) have to be mmapped sequentially one 
> after another in a predefined order to mmap() everything to the 
> user-space as a continuous block of data. Another thing is that on each 
> mmap() call I know exactly how much memory has to be mmapped, so I can 
> allow to force-mmap all the memory in advance during the mmap() call.

But yes, that's fine, many drivers do it like that.

> And so I thought I'd allocate each individual buffer by the 
> __get_free_pages() with the __GFP_COMP set, to make the entire buffer 
> behave as one compound page and then during the mmap() call do a 
> vm_insert_page() on each compount page representing each buffer I want to 
> mmap in that call.
> 
> The comment in mm/memory.c by the vm_insert_page() says:
> 
>  * If you allocate a compound page, you need to have marked it as
>  * such (__GFP_COMP), or manually just split the page up yourself
>  * (see split_page()).
> 
> So I did and thought it would work. But it doesn't seem to. The 
> vm_insert_page() call passes allright, but it still seems to mmap only the 
> first page of each of the compount page, since when the application is 
> accessing the data the nopage() method is still called for all other pages 
> but the first one of each of the compound pages. Does that mean, that I 
> still need to insert each individual page from within the compound page by 
> the vm_insert_page() or what? (If that's so, perhaps it would be nice to 
> comment it in the vm_insert_page() function.)

That's right, vm_insert_page inserts just a single pte.  We're rather
schizophrenic when we say "page", sometimes we're thinking about "a
compound page" or a "high-order page", and sometimes we're thinking
about all the component "struct page"s that make that up: confusing.
I've made a note to add such a comment there.

> And about the reorganization of the driver to not make the >0 order page 
> allocations. Well, I would do it, if you know about any other solution 
> that would allow to do a USB URB transfer into a buffer (perhaps 
> consisting of individually allocated 0-order pages as you suggest) that 
> however definitelly needs to be bigger than one page. Perhaps something 
> like a scatter-gather would do, but I don't know about any such mechanism 
> for USB URBs.

Oh, I've been repeating myself, have I?  Scatter-gather is indeed
what we prefer to use, instead of demanding >0-order pages.   But
no way can I advise you on USB URBs.

Hugh

> The transfers need to be bigger than a page because the overhead 
> of doing the transfer only by one page at a time would be unbearable.
> It's an isochronous transfer doing exactly 3072 B each 125 microseconds.
> Anything less than doing 8 of such transfers at one usb_submit_urb() call 
> seems to posses too much overhead. If there is any other solution, I'd 
> gladly change the driver, but unfortunatelly I don't know of any.
