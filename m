Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbZEKWio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbZEKWio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbZEKWiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:38:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759101AbZEKWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:38:14 -0400
Date: Mon, 11 May 2009 15:33:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, nigel@tuxonice.net, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 1/6] mm: Introduce __GFP_NO_OOM_KILL
Message-Id: <20090511153323.518c146a.akpm@linux-foundation.org>
In-Reply-To: <200905120014.24751.rjw@sisk.pl>
References: <200905070040.08561.rjw@sisk.pl>
	<200905101550.09671.rjw@sisk.pl>
	<alpine.DEB.2.00.0905111312140.27577@chino.kir.corp.google.com>
	<200905120014.24751.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 00:14:23 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 11 May 2009, David Rientjes wrote:
> > On Sun, 10 May 2009, Rafael J. Wysocki wrote:
> > 
> > > Index: linux-2.6/mm/page_alloc.c
> > > ===================================================================
> > > --- linux-2.6.orig/mm/page_alloc.c
> > > +++ linux-2.6/mm/page_alloc.c
> > > @@ -1619,8 +1619,12 @@ nofail_alloc:
> > >  			goto got_pg;
> > >  		}
> > >  
> > > -		/* The OOM killer will not help higher order allocs so fail */
> > > -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> > > +		/*
> > > +		 * The OOM killer will not help higher order allocs so fail.
> > > +		 * Also fail if the caller doesn't want the OOM killer to run.
> > > +		 */
> > > +		if (order > PAGE_ALLOC_COSTLY_ORDER
> > > +				|| (gfp_mask & __GFP_NO_OOM_KILL)) {
> > >  			clear_zonelist_oom(zonelist, gfp_mask);
> > >  			goto nopage;
> > >  		}
> > > Index: linux-2.6/include/linux/gfp.h
> > > ===================================================================
> > > --- linux-2.6.orig/include/linux/gfp.h
> > > +++ linux-2.6/include/linux/gfp.h
> > > @@ -51,8 +51,9 @@ struct vm_area_struct;
> > >  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
> > >  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
> > >  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
> > > +#define __GFP_NO_OOM_KILL ((__force gfp_t)0x200000u)  /* Don't invoke out_of_memory() */
> > >  
> > > -#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
> > > +#define __GFP_BITS_SHIFT 22	/* Number of __GFP_FOO bits */
> > >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
> > >  
> > >  /* This equals 0, but use constants in case they ever change */
> > > 
> > 
> > Nack, unnecessary in mmotm and my patch series from 
> > http://lkml.org/lkml/2009/5/10/118.
> 
> Andrew, what's your opinion, please?

I don't understand which part of David's patch series is supposed to
address your requirement.  If it's "don't kill tasks which are in D
state" then that's a problem because right now I think that patch is
wrong.  It's still being discussed.

> I can wait with these patches until the dust settles in the mm land.

Yes, it is pretty dusty at present.  I'd suggest that finding something
else to do for a few days would be a wise step ;)

