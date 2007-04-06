Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXDFGhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXDFGhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 02:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXDFGhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 02:37:34 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:43605 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753528AbXDFGhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 02:37:33 -0400
Subject: Re: [PATCH 10/12] mm: page_alloc_wait
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: root@programming.kicks-ass.net, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com
In-Reply-To: <20070405155743.91380f00.akpm@linux-foundation.org>
References: <20070405174209.498059336@programming.kicks-ass.net>
	 <20070405174320.129577639@programming.kicks-ass.net>
	 <20070405155743.91380f00.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 08:37:28 +0200
Message-Id: <1175841448.6483.117.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 15:57 -0700, Andrew Morton wrote:
> On Thu, 05 Apr 2007 19:42:19 +0200
> root@programming.kicks-ass.net wrote:
> 
> > Introduce a mechanism to wait on free memory.
> > 
> > Currently congestion_wait() is abused to do this.
> 
> Such a very small explanation for such a terrifying change.

Yes, I suck at writing changelogs, bad me. Normally I would take a day
to write them, but I just wanted to get this code out there. Perhaps a
bad decision.

> > ...
> >
> > --- linux-2.6-mm.orig/mm/vmscan.c	2007-04-05 16:29:46.000000000 +0200
> > +++ linux-2.6-mm/mm/vmscan.c	2007-04-05 16:29:49.000000000 +0200
> > @@ -1436,6 +1436,7 @@ static int kswapd(void *p)
> >  		finish_wait(&pgdat->kswapd_wait, &wait);
> >  
> >  		balance_pgdat(pgdat, order);
> > +		page_alloc_ok();
> >  	}
> >  	return 0;
> >  }
> 
> For a start, we don't know that kswapd freed pages which are in a suitable
> zone.  And we don't know that kswapd freed pages which are in a suitable
> cpuset.
> 
> congestion_wait() is similarly ignorant of the suitability of the pages,
> but the whole idea behind congestion_wait is that it will throttle page
> allocators to some speed which is proportional to the speed at which the IO
> systems can retire writes - view it as a variable-speed polling operation,
> in which the polling frequency goes up when the IO system gets faster. 
> This patch changes that philosophy fundamentally.  That's worth more than a
> 2-line changelog.
> 
> Also, there might be situations in which kswapd gets stuck in some dark
> corner.  Perhaps the process which is waiting in the page allocator holds
> filesystem locks which kswapd is blocked on.  Or kswapd might be blocked on
> a particular request queue, or a dead NFS server or something.  The timeout
> will save us, but things will be slow.
> 
> There could be other problems too, dunno - this stuff is tricky.  Why are
> you changing it, what problems are being solved, etc?

Lets start with the why, because of 12/12; I wanted to introduce per BDI
congestion feedback, and hence needed a BDI context for
congestion_wait(). These specific callers weren't in the context of a
BDI but of a more global idea.

Perhaps I could call page_alloc_ok() from bdi_congestion_end()
irrespective of the actual BDI uncongested? That would more or less give
the old semantics.

