Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZGIIsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZGIIsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZGIIsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:48:25 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:59748 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750995AbZGIIsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:48:24 -0400
Subject: Re: TTM page pool allocator
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <21d7e9970907082306p68105109g3b754972fe9c53fa@mail.gmail.com>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
	 <1246024775.2371.0.camel@localhost> <4A492E22.3060307@shipmail.org>
	 <21d7e9970907082306p68105109g3b754972fe9c53fa@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Jul 2009 10:48:17 +0200
Message-Id: <1247129297.8745.945.camel@thor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 16:06 +1000, Dave Airlie wrote:
> 2009/6/30 Thomas Hellström <thomas@shipmail.org>:
> > Jerome Glisse skrev:
> >>
> >> On Fri, 2009-06-26 at 10:00 +1000, Dave Airlie wrote:
> >>
> >>>
> >>> On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org>
> >>> wrote:
> >>>
> >>>>
> >>>> Hi,
> >>>>
> >>>> Thomas i attach a reworked page pool allocator based on Dave works,
> >>>> this one should be ok with ttm cache status tracking. It definitely
> >>>> helps on AGP system, now the bottleneck is in mesa vertex's dma
> >>>> allocation.
> >>>>
> >>>>
> >>>
> >>> My original version kept a list of wb pages as well, this proved to be
> >>> quite a useful
> >>> optimisation on my test systems when I implemented it, without it I
> >>> was spending ~20%
> >>> of my CPU in getting free pages, granted I always used WB pages on
> >>> PCIE/IGP systems.
> >>>
> >>> Another optimisation I made at the time was around the populate call,
> >>> (not sure if this
> >>> is what still happens):
> >>>
> >>> Allocate a 64K local BO for DMA object.
> >>> Write into the first 5 pages from userspace - get WB pages.
> >>> Bind to GART, swap those 5 pages to WC + flush.
> >>> Then populate the rest with WC pages from the list.
> >>>
> >>> Granted I think allocating WC in the first place from the pool might
> >>> work just as well since most of the DMA buffers are write only.
> >>>
> >>> Dave.
> >>> --
> >>>
> >>
> >> Attached a new version of the patch, which integrate changes discussed.
> >>
> >> Cheers,
> >> Jerome
> >>
> >
> > Hi, Jerome!
> > Still some outstanding things:
> >
> > 1) The AGP protection fixes compilation errors when AGP is not enabled, but
> > what about architectures that need the map_page_into_agp() semantics for TTM
> > even when AGP is not enabled? At the very least TTM should be disabled on
> > those architectures. The best option would be to make those calls non-agp
> > specific.
> >
> > 2) Why is the page refcount upped with get_page() after an alloc_page()?
> >
> > 3) It seems like pages are cache-transitioned one-by-one when freed. Again,
> > this is a global TLB flush per page. Can't we free a large chunk of pages at
> > once?
> >
> 
> Jerome,
> 
> have we addressed these?
> 
> I'd really like to push this soon, as I'd like to fix up the 32 vs 36
> bit dma masks if possible
> which relies on us being able to tell the allocator to use GFP_DMA32 on some hw
> (32-bit PAE mainly with a PCI card).

FWIW, I tried this patch on my PowerBook, and it didn't go too well:

With AGP enabled, the kernel panics before there's any KMS display.

With AGP disabled, I get a KMS display, but it shows a failure to
allocate the ring buffer, and then it stops updating.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
