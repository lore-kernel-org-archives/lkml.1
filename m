Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZH1M5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZH1M5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZH1M5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:57:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52146 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbZH1M5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:57:16 -0400
Date: Fri, 28 Aug 2009 13:57:19 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] page-allocator: Maintain rolling count of pages to
	free from the PCP
Message-ID: <20090828125719.GE5054@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie> <1251449067-3109-3-git-send-email-mel@csn.ul.ie> <84144f020908280516y6473a531n3f11f3e86251eba4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020908280516y6473a531n3f11f3e86251eba4@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 03:16:34PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Fri, Aug 28, 2009 at 11:44 AM, Mel Gorman<mel@csn.ul.ie> wrote:
> > -               page = list_entry(list->prev, struct page, lru);
> > -               /* have to delete it as __free_one_page list manipulates */
> > -               list_del(&page->lru);
> > -               trace_mm_page_pcpu_drain(page, 0, migratetype);
> > -               __free_one_page(page, zone, 0, migratetype);
> > +               do {
> > +                       page = list_entry(list->prev, struct page, lru);
> > +                       /* must delete as __free_one_page list manipulates */
> > +                       list_del(&page->lru);
> > +                       __free_one_page(page, zone, 0, migratetype);
> > +                       trace_mm_page_pcpu_drain(page, 0, migratetype);
> 
> This calls trace_mm_page_pcpu_drain() *after* __free_one_page(). It's
> probably not a good idea as __free_one_page() can alter the struct
> page in various ways.
> 

While true, does it alter the struct page in any way that matters?

> 
> > +               } while (--count && --batch_free && !list_empty(list));
> >        }
> >        spin_unlock(&zone->lock);
> >  }
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
