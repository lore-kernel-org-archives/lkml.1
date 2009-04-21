Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbZDUSyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbZDUSyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbZDUSxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:53:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759271AbZDUSxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:53:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
Date: Tue, 21 Apr 2009 20:53:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <20090420130412.bc337673.akpm@linux-foundation.org> <20090420163734.b8e24fc9.akpm@linux-foundation.org>
In-Reply-To: <20090420163734.b8e24fc9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904212053.02224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009, Andrew Morton wrote:
> On Mon, 20 Apr 2009 13:04:12 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 20 Apr 2009 21:53:06 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > > Remind me: why can't we just allocate N pages at suspend-time?
> > > 
> > > We need half of memory free. The reason we can't "just allocate" is
> > > probably OOM killer; but my memories are quite weak :-(.
> > 
> > hm.  You'd think that with out splendid range of __GFP_foo falgs, there
> > would be some combo which would suit this requirement but I can't
> > immediately spot one.
> > 
> > We can always add another I guess.  Something like...
> > 
> > 
> > diff -puN mm/page_alloc.c~a mm/page_alloc.c
> > --- a/mm/page_alloc.c~a
> > +++ a/mm/page_alloc.c
> > @@ -1620,7 +1620,8 @@ nofail_alloc:
> >  		}
> >  
> >  		/* The OOM killer will not help higher order allocs so fail */
> > -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> > +		if (order > PAGE_ALLOC_COSTLY_ORDER ||
> > +				(gfp_mask & __GFP_NO_OOM_KILL)) {
> >  			clear_zonelist_oom(zonelist, gfp_mask);
> >  			goto nopage;
> >  		}
> > diff -puN include/linux/gfp.h~a include/linux/gfp.h
> > --- a/include/linux/gfp.h~a
> > +++ a/include/linux/gfp.h
> > @@ -51,8 +51,9 @@ struct vm_area_struct;
> >  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
> >  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
> >  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
> > +#define __GFP_NO_OOM_KILL ((__force gfp_t)0x200000u)  /* Don't invoke out_of_memory() */
> >  
> > -#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
> > +#define __GFP_BITS_SHIFT 22	/* Number of__GFP_FOO bits */
> >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
> >  
> >  /* This equals 0, but use constants in case they ever change */
> > _
> > 
> 
> Of course, this will protect the calling task from getting oom-killed. 
> But it doesn't protect other tasks from getting oom-killed due to the
> activity of _this_ task.
> 
> But I think that problem already exists, and that this proposal doesn't
> worsen anything, yes?

I think it doesn't.

> Or is it the case that all other tasks are safely stuck in the freezer
> at this time, so they won't be allocating any memory anyway?

Except for the tasks (kernel threads) that are not frozen and which can
allocate memory as well.

However, the OOM killer is not really useful during suspend/hibernation, so
perhaps we can just disable it temporarily before that?
