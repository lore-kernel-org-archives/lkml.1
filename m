Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZCRPfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZCRPfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZCRPfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:35:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60585 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZCRPfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:35:11 -0400
Date: Wed, 18 Mar 2009 15:35:08 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 24/27] Convert gfp_zone() to use a table of
	precalculated values
Message-ID: <20090318153508.GA24462@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie> <1237226020-14057-25-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161500280.20024@qirst.com> <20090318135222.GA4629@csn.ul.ie> <alpine.DEB.1.10.0903181011210.7901@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903181011210.7901@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 10:15:26AM -0400, Christoph Lameter wrote:
> On Wed, 18 Mar 2009, Mel Gorman wrote:
> 
> > On Mon, Mar 16, 2009 at 03:12:50PM -0400, Christoph Lameter wrote:
> > > On Mon, 16 Mar 2009, Mel Gorman wrote:
> > >
> > > > +int gfp_zone_table[GFP_ZONEMASK] __read_mostly;
> > >
> > > The gfp_zone_table is compile time determinable. There is no need to
> > > calculate it.
> > >
> >
> > The cost of calculating it is negligible and the code is then freed later
> > in boot. Does having a const table make any difference?
> 
> Should it not enable the compiler to determine the value at
> compile time and therefore make things like gfp_zone(constant) a
> constant?
> 

Yeah, you're right. I didn't think it would but a test program showed
that code accessing const fields like this are calculated at compile
time.

> > > const int gfp_zone_table[GFP_ZONEMASK] = {
> > > 	ZONE_NORMAL,		/* 00 No flags set */
> > > 	ZONE_DMA,		/* 01 Only GFP_DMA set */
> > > 	ZONE_HIGHMEM,		/* 02 Only GFP_HIGHMEM set */
> > > 	ZONE_DMA,		/* 03 GFP_HIGHMEM and GFP_DMA set */
> > > 	ZONE_DMA32,		/* 04 Only GFP_DMA32 set */
> > > 	ZONE_DMA,		/* 05 GFP_DMA and GFP_DMA32 set */
> > > 	ZONE_DMA32,		/* 06 GFP_DMA32 and GFP_HIGHMEM set */
> > > 	ZONE_DMA,		/* 07 GFP_DMA, GFP_DMA32 and GFP_DMA32 set */
> > > 	ZONE_MOVABLE,		/* 08 Only ZONE_MOVABLE set */
> > > 	ZONE_DMA,		/* 09 MOVABLE + DMA */
> > > 	ZONE_MOVABLE,		/* 0A MOVABLE + HIGHMEM */
> > > 	ZONE_DMA,		/* 0B MOVABLE + DMA + HIGHMEM */
> > > 	ZONE_DMA32,		/* 0C MOVABLE + DMA32 */
> > > 	ZONE_DMA,		/* 0D MOVABLE + DMA + DMA32 */
> > > 	ZONE_DMA32,		/* 0E MOVABLE + DMA32 + HIGHMEM */
> > > 	ZONE_DMA		/* 0F MOVABLE + DMA32 + HIGHMEM + DMA
> > > };
> > >
> > > Hmmmm... Guess one would need to add some #ifdeffery here to setup
> > > ZONE_NORMAL in cases there is no DMA, DMA32 and HIGHMEM.
> > >
> >
> > Indeed, as I said, this is somewhat error prone which is why the patch
> > calculates the table at run-time instead of compile-time trickery.
> 
> One would need to define some macros to make it simpler I guess
> 
> Write something like
> 
> #ifdef CONFIG_ZONE_DMA
> #define TZONE_DMA ZONE_DMA
> #else
> #define TZONE_DMA ZONE_NORMAL
> #endif
> 
> for each configurable item. Then just add the T to the above table.
> 

If you don't mind, I'd like to postpone writing such a patch until a second
or third pass at improving the allocator. I don't think I'll have the time
in the short-term to put together a const-initialised-table patch that will
definitily be correct.

Alternatively, I can drop this patch entirely from the set.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
