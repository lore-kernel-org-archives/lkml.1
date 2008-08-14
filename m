Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYHNUrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYHNUrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYHNUrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:47:05 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:54087 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbYHNUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:47:04 -0400
From: Frans Pop <elendil@planet.nl>
To: Sven Wegener <sven.wegener@stealer.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression?] [resend] Memory zone info seems incomplete in boottime dmesg output
Date: Thu, 14 Aug 2008 22:46:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <200808142042.24606.elendil@planet.nl> <alpine.LNX.1.10.0808142057520.12259@titan.stealer.net>
In-Reply-To: <alpine.LNX.1.10.0808142057520.12259@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808142246.40370.elendil@planet.nl>
X-OriginalArrivalTime: 14 Aug 2008 20:46:59.0505 (UTC) FILETIME=[E5B8B210:01C8FE4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 August 2008, Sven Wegener wrote:
> On Thu, 14 Aug 2008, Frans Pop wrote:
> > With 2.6.26 I get:
> > On node 0 totalpages: 521751
> >   DMA zone: 56 pages used for memmap
> >   DMA zone: 1271 pages reserved
> >   DMA zone: 2672 pages, LIFO batch:0
> >   DMA32 zone: 7081 pages used for memmap
> >   DMA32 zone: 510671 pages, LIFO batch:31
> >   Normal zone: 0 pages used for memmap
> >   Movable zone: 0 pages used for memmap
> >
> > With 2.6.27-rc1 I only get pages listed for 2 zones (bottom part):
> > On node 0 totalpages: 521751
> >   DMA zone: 2072 pages, LIFO batch:0
> >   DMA32 zone: 506625 pages, LIFO batch:31
> >
> > Note that totalpages is the same and that for 2.6.26 the sum of pages
> > for all listed zones is equal to totalpages. Seems we've lost useful
> > info here.
>
> Could you make sure DEBUG_MEMORY_INIT is activated (it should, if

Yes, it is.

> you've not chosen the embedded feature) and boot with mminit_loglevel=3
> and see if you get the ouput you want.

That gives me:
On node 0 totalpages: 521751
mminit::memmap_init DMA zone: 88 pages used for memmap
mminit::memmap_init DMA zone: 1839 pages reserved
  DMA zone: 2072 pages, LIFO batch:0
mminit::memmap_init Initialising map node 0 zone 0 pfns 0 -> 4096
mminit::memmap_init DMA32 zone: 11127 pages used for memmap
  DMA32 zone: 506625 pages, LIFO batch:31
mminit::memmap_init Initialising map node 0 zone 1 pfns 4096 -> 521984
mminit::memmap_init Normal zone: 0 pages used for memmap
mminit::memmap_init Movable zone: 0 pages used for memmap

If I now add up the number of pages, I get 521751 again.

What was the rationale behind "hiding" resevered/memmapped pages behind an 
additional debug option?
I can see the point of suppressing the last 2 lines which list empty 
zones, but not the others which list actual usage of pages in active 
zones.
Listing a "total number of pages" and then not specifying all categories 
that make up the total seems like a bad choice to me. It would seem more 
logical to either hide all related info, or to show something that is 
numerically consistent.

I can now see where my "missing" pages have gone: DMA reserved up by 
almost 600 and DMA32 memmap up by 4000. Will need to check if that's 
indeed the result of the extra "kernel hacking" options I enabled.


On Thursday 14 August 2008, Andrew Morton wrote:
> > Zone PFN ranges:
> >   DMA      0x00000000 -> 0x00001000
> >   DMA32    0x00001000 -> 0x00100000
> >   Normal   0x00100000 -> 0x00100000
> > Movable zone start PFN for each node
>
> I'd have expected something to be printed here?

No idea. That last line does seem out of context and - at least to me - 
does not mean anything. mminit_loglevel=3 does not add any extra info 
there.
Looks to be related to the fact that the debug output (and the old 
output!) shows the "Movable zone" as empty (0 pages)? Maybe this line 
should be suppressed in that case?


There seems to be another (probably minor) issue in free_area_init_nodes 
in mm/page_alloc.c. It defines 'enum zone_type i', but also uses 'i' as a 
counter for MAX_NUMNODES and nr_nodemap_entries which look to be 
different data types.
My C-foo is very limited, so I may be just missing something.

Cheers,
FJP
