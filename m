Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZFXUCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZFXUCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZFXUCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:02:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbZFXUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:02:03 -0400
Date: Wed, 24 Jun 2009 13:01:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090624130121.99321cca.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org>
	<20090624094622.d0b0fd82.akpm@linux-foundation.org>
	<84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	<20090624105517.904f93da.akpm@linux-foundation.org>
	<4A426825.80905@cs.helsinki.fi>
	<20090624113037.7d72ed59.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
	<20090624120617.1e6799b5.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
	<20090624123624.26c93459.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 12:46:02 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

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

That allocation attempts of any order can fail.

> That's the recursive allocation or oom case. Not the normal case at all.
> 
> The _normal_ case is to do the whole "try_to_free_pages()" case and try 
> and try again. Forever.

If the caller gets oom-killed, the allocation attempt fails.  Callers need
to handle that.

> IOW, we have traditionally never failed small kernel allocations. It makes 
> perfect sense that people _depend_ on that.
> 
> Now, we have since relaxed that (a lot). And in answer to that, people 
> have added more __GFP_NOFAIL flags, I bet. It's all very natural. Claiming 
> that this is some "new error" and that we should warn about NOFAIL 
> allocations with big orders is just silly and simply not true.
> 

There are situations in which the allocation attempt simply will not
succeed, so a __GFP_NOFAIL attempt will lock up.  Hence callers should
stop using __GFP_NOFAIL and should handle the allocation error like
99.9999% of the rest of the kernel does.

The chances of the allocation attempt failing increase with
higher-order allocations, hence the combination of __GFP_NOFAIL with
order>0 should be avoided more strenuously than __GFP_NOFAIL &&
order==0.


<Note that the TIF_MEMDIE handling has changed post-2.6.30.  I still
need to get my head around the end result of what we did there.  Did we
break the __alloc_pages-fails-if-TFI_MEMDIE logic?>



