Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbZFXTqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbZFXTqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762016AbZFXTqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:46:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761788AbZFXTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:46:24 -0400
Date: Wed, 24 Jun 2009 12:46:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090624123624.26c93459.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org> <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi>
 <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
 <20090624123624.26c93459.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Andrew Morton wrote:

> On Wed, 24 Jun 2009 12:16:20 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Lookie here. This is 2.6.0:mm/page_alloc.c:
> > 
> >         do_retry = 0;
> >         if (!(gfp_mask & __GFP_NORETRY)) {
> >                 if ((order <= 3) || (gfp_mask & __GFP_REPEAT))
> >                         do_retry = 1;
> >                 if (gfp_mask & __GFP_NOFAIL)
> >                         do_retry = 1;
> >         }
> >         if (do_retry) {
> >                 blk_congestion_wait(WRITE, HZ/50);
> >                 goto rebalance;
> >         }
> 
> rebalance:
> 	if ((p->flags & (PF_MEMALLOC | PF_MEMDIE)) && !in_interrupt()) {
> 		/* go through the zonelist yet again, ignoring mins */
> 		for (i = 0; zones[i] != NULL; i++) {
> 			struct zone *z = zones[i];
> 
> 			page = buffered_rmqueue(z, order, cold);
> 			if (page)
> 				goto got_pg;
> 		}
> 		goto nopage;
> 	}

Your point?

That's the recursive allocation or oom case. Not the normal case at all.

The _normal_ case is to do the whole "try_to_free_pages()" case and try 
and try again. Forever.

IOW, we have traditionally never failed small kernel allocations. It makes 
perfect sense that people _depend_ on that.

Now, we have since relaxed that (a lot). And in answer to that, people 
have added more __GFP_NOFAIL flags, I bet. It's all very natural. Claiming 
that this is some "new error" and that we should warn about NOFAIL 
allocations with big orders is just silly and simply not true.

		Linus


