Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZF1Kpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZF1Kpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 06:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZF1Kpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 06:45:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45101 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZF1Kpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 06:45:30 -0400
Date: Sun, 28 Jun 2009 12:16:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090628101654.GB8673@ucw.cz>
References: <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi> <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 12:46:02, Linus Torvalds wrote:
> 
> 
> On Wed, 24 Jun 2009, Andrew Morton wrote:
> 
> > On Wed, 24 Jun 2009 12:16:20 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > Lookie here. This is 2.6.0:mm/page_alloc.c:
> > > 
> > >         do_retry = 0;
> > >         if (!(gfp_mask & __GFP_NORETRY)) {
> > >                 if ((order <= 3) || (gfp_mask & __GFP_REPEAT))
> > >                         do_retry = 1;
> > >                 if (gfp_mask & __GFP_NOFAIL)
> > >                         do_retry = 1;
> > >         }
> > >         if (do_retry) {
> > >                 blk_congestion_wait(WRITE, HZ/50);
> > >                 goto rebalance;
> > >         }
> > 
> > rebalance:
> > 	if ((p->flags & (PF_MEMALLOC | PF_MEMDIE)) && !in_interrupt()) {
> > 		/* go through the zonelist yet again, ignoring mins */
> > 		for (i = 0; zones[i] != NULL; i++) {
> > 			struct zone *z = zones[i];
> > 
> > 			page = buffered_rmqueue(z, order, cold);
> > 			if (page)
> > 				goto got_pg;
> > 		}
> > 		goto nopage;
> > 	}
> 
> Your point?
> 
> That's the recursive allocation or oom case. Not the normal case at all.
> 
> The _normal_ case is to do the whole "try_to_free_pages()" case and try 
> and try again. Forever.
> 
> IOW, we have traditionally never failed small kernel allocations. It makes 
> perfect sense that people _depend_ on that.

Ok, so we should re-add that 4MB buffer to suspend, so that
allocations work even during that, right?

...and... if you do enough of small allocations, they *will* have to
fail at some point. Maybe linux is now mature enough and running on
small enough devices that it makes sense to start handling that?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
