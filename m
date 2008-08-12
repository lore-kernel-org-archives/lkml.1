Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYHLJgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYHLJgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYHLJgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:36:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:60942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYHLJgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:36:01 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 12 Aug 2008 19:35:50 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18593.22902.998611.967202@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 05/30] mm: slb: add knowledge of reserve pages
In-Reply-To: message from Peter Zijlstra on Tuesday August 12
References: <20080724140042.408642539@chello.nl>
	<20080724141529.635920366@chello.nl>
	<18593.8466.965002.476705@notabene.brown>
	<1218525750.10800.156.camel@twins>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday August 12, a.p.zijlstra@chello.nl wrote:
> On Tue, 2008-08-12 at 15:35 +1000, Neil Brown wrote:
> > On Thursday July 24, a.p.zijlstra@chello.nl wrote:
> > > Restrict objects from reserve slabs (ALLOC_NO_WATERMARKS) to allocation
> > > contexts that are entitled to it. This is done to ensure reserve pages don't
> > > leak out and get consumed.
> > 
> > This looks good (we are still missing slob though, aren't we :-( )
> 
> I actually have that now, just needs some testing..

Cool!

> 
> > > @@ -1526,7 +1540,7 @@ load_freelist:
> > >  	object = c->page->freelist;
> > >  	if (unlikely(!object))
> > >  		goto another_slab;
> > > -	if (unlikely(SLABDEBUG && PageSlubDebug(c->page)))
> > > +	if (unlikely(PageSlubDebug(c->page) || c->reserve))
> > >  		goto debug;
> > 
> > This looks suspiciously like debugging code that you have left in.
> > Is it??
> 
> Its not, we need to force slub into the debug slow path when we have a
> reserve page, otherwise we cannot do the permission check on each
> allocation.

I see.... a little.  I'm trying to avoid understanding slub too
deeply, I don't want to use up valuable brain cell :-)
Would we be justified in changing the label from 'debug:' to
'slow_path:'  or something?  And if it is just c->reserve, should
we avoid the call to alloc_debug_processing?


Thanks,
NeilBrown

> 
> > > @@ -265,7 +267,8 @@ struct array_cache {
> > >  	unsigned int avail;
> > >  	unsigned int limit;
> > >  	unsigned int batchcount;
> > > -	unsigned int touched;
> > > +	unsigned int touched:1,
> > > +		     reserve:1;
> > 
> > This sort of thing always worries me.
> > It is a per-cpu data structure so you won't get SMP races corrupting
> > fields.  But you do get read-modify-write in place of simple updates.
> > I guess it's not a problem..  But it worries me :-)
> 
> Right,.. do people prefer I just add another int?
