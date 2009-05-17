Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZEQMzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZEQMzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZEQMzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:55:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZEQMze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:55:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 6/6] PM/Hibernate: Do not try to allocate too much memory too hard
Date: Sun, 17 May 2009 14:55:05 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <200905070040.08561.rjw@sisk.pl> <200905131042.18137.rjw@sisk.pl> <20090517120613.GB3254@localhost>
In-Reply-To: <20090517120613.GB3254@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171455.06120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Wu Fengguang wrote:
> Hi Rafael,

Hi,

> Sorry for being late.

No big deal.

> On Wed, May 13, 2009 at 04:42:17PM +0800, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > We want to avoid attempting to free too much memory too hard during
> > hibernation, so estimate the minimum size of the image to use as the
> > lower limit for preallocating memory.
> > 
> > The approach here is based on the (experimental) observation that we
> > can't free more page frames than the sum of:
> > 
> > * global_page_state(NR_SLAB_RECLAIMABLE)
> > * global_page_state(NR_ACTIVE_ANON)
> > * global_page_state(NR_INACTIVE_ANON)
> > * global_page_state(NR_ACTIVE_FILE)
> > * global_page_state(NR_INACTIVE_FILE)
> 
> It's a very good idea to count the numbers in a reverse way.
> 
> > and even that is usually impossible to free in practice, because some
> > of the pages reported as global_page_state(NR_SLAB_RECLAIMABLE) can't
> > in fact be freed.  It turns out, however, that if the sum of the
> > above numbers is subtracted from the number of saveable pages in the
> > system and the result is multiplied by 1.25, we get a suitable
> > estimate of the minimum size of the image.
> 
> However, the "*1.25" looks like a hack.

It's just an experimental value.

> We should really apply more constraints to the individual components.
> 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  kernel/power/snapshot.c |   56 ++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 52 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6/kernel/power/snapshot.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/snapshot.c
> > +++ linux-2.6/kernel/power/snapshot.c
> > @@ -1213,6 +1213,49 @@ static void free_unnecessary_pages(void)
> >  }
> >  
> >  /**
> > + * minimum_image_size - Estimate the minimum acceptable size of an image
> > + * @saveable: The total number of saveable pages in the system.
> > + *
> > + * We want to avoid attempting to free too much memory too hard, so estimate the
> > + * minimum acceptable size of a hibernation image to use as the lower limit for
> > + * preallocating memory.
> > + *
> > + * The minimum size of the image is computed as
> > + *
> > + * ([number of saveable pages] - [number of pages we can free]) * 1.25
> > + *
> > + * where the second term is the sum of reclaimable slab, anonymouns pages and
> > + * active/inactive file pages.
> > + *
> > + * NOTE: It usually turns out that we can't really free all pages reported as
> > + * reclaimable slab, so the number resulting from the subtraction alone is too
> > + * low.  Still, it seems reasonable to assume that this number is proportional
> > + * to the total number of pages that cannot be freed, which leads to the
> > + * formula above.  The coefficient of proportinality in this formula, 1.25, has
> > + * been determined experimentally.
> > + */
> > +static unsigned long minimum_image_size(unsigned long saveable)
> > +{
> > +	unsigned long size;
> > +
> > +	/* Compute the number of saveable pages we can free. */
> > +	size = global_page_state(NR_SLAB_RECLAIMABLE)
> > +		+ global_page_state(NR_ACTIVE_ANON)
> > +		+ global_page_state(NR_INACTIVE_ANON)
> > +		+ global_page_state(NR_ACTIVE_FILE)
> > +		+ global_page_state(NR_INACTIVE_FILE);
> 
> For example, we could drop the 1.25 ratio and calculate the above
> reclaimable size with more meaningful constraints:
> 
>         /* slabs are not easy to reclaim */
> 	size = global_page_state(NR_SLAB_RECLAIMABLE) / 2;

Why 1/2?
 
>         /* keep NR_ACTIVE_ANON */
> 	size += global_page_state(NR_INACTIVE_ANON);

Why exactly did you omit ACTIVE_ANON?
 	
>         /* keep mapped files */
> 	size += global_page_state(NR_ACTIVE_FILE);
> 	size += global_page_state(NR_INACTIVE_FILE);
>         size -= global_page_state(NR_FILE_MAPPED);
> 
> That restores the hard core working set logic in the reverse way ;)

I think the 1/2 factor for NR_SLAB_RECLAIMABLE may be too high in some cases,
but I'm going to check that.

Thanks,
Rafael
