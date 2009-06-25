Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZFYTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZFYTzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZFYTzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:55:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40357 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZFYTzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:55:35 -0400
Date: Thu, 25 Jun 2009 21:55:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090625195538.GC31415@kernel.dk>
References: <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624150714.c7264768.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24 2009, Andrew Morton wrote:
> On Wed, 24 Jun 2009 13:40:11 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Wed, 24 Jun 2009, Linus Torvalds wrote:
> > > On Wed, 24 Jun 2009, Andrew Morton wrote:
> > > > 
> > > > If the caller gets oom-killed, the allocation attempt fails.  Callers need
> > > > to handle that.
> > > 
> > > I actually disagree. I think we should just admit that we can always free 
> > > up enough space to get a few pages, in order to then oom-kill things.
> > 
> > Btw, if you want to change the WARN_ON() to warn when you're in the 
> > "allocate in order to free memory" recursive case, then I'd have no issues 
> > with that.
> > 
> > In fact, in that case it probably shouldn't even be conditional on the 
> > order. 
> > 
> > So a
> > 
> > 	WARN_ON_ONCE((p->flags & PF_MEMALLOC) && (gfpmask & __GFP_NOFAIL));
> > 
> > actually makes tons of sense. 
> 
> I suspect that warning will trigger.
> 
> alloc_pages
> -> ...
>   -> pageout
>     -> ...
>       -> get_request
>         -> blk_alloc_request
>           -> elv_set_request
>             -> cfq_set_request
>               -> cfq_get_queue
>                 -> cfq_find_alloc_queue
>                   -> kmem_cache_alloc_node(__GFP_NOFAIL)
>                     -> Jens
> 
> How much this can happen in practice I don't know, but it looks bad.

Yeah it sucks, but I don't think it's that bad to fixup.

The request allocation can fail, if we just return NULL in
cfq_find_alloc_queue() and let that error propagate back up to
get_request_wait(), it would simply io_schedule() and wait for a request
to be freed. The only issue here is that if we have no requests going
for this queue already, we would be stuck since there's noone to wake us
up eventually. So if we did this, we'd have to make the io_schedule()
dependent on whether there are allocations out already. Use global
congestion wait in that case, or just io_schedule_timeout() for
retrying.

The other option is to retry in cfq_find_alloc_queue() without the
NOFAIL and do the congestion wait logic in there.

Yet another option would be to have a dummy queue that is allocated when
the queue io scheduler is initialized. If cfq_find_alloc_queue() fails,
just punt the IO to that dummy queue. That would allow progress even
under extreme failure conditions.

With all that said, the likely hood of ever hitting this path is about
0%. Those failures are the ones that really suck when it's hit in the
field eventually, though :-)

-- 
Jens Axboe

