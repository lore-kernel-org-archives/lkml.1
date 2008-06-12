Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYFLBWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYFLBWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYFLBWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:22:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:53124 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYFLBWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:22:04 -0400
Date: Thu, 12 Jun 2008 03:22:01 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: vmap rewrite
Message-ID: <20080612012201.GB29611@wotan.suse.de>
References: <20080605102015.GA11366@wotan.suse.de> <484AC779.1070803@goop.org> <20080610025312.GC19404@wotan.suse.de> <48501D7C.5050600@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48501D7C.5050600@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 07:46:20PM +0100, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> >It's harder than that even, because we don't own the page flags, so then
> >clearing the PG_kalias bit would require that we make all page flags ops
> >atomic in all parts of the kernel. Obviously not going to happen.
> >
> >The other thing we could do is have vmap layer keep some p->v translations
> >around (actually it doesn't even need to go all the way to v, just a single
> >bit would suffice) So I guess this would be like another page flag, but
> >without the atomicity problem and without me getting angry at using another
> >flag ;) Still, I'd rather not do this and slow everything else down.
> >  
> 
> Yeah.  It's a bit awkward to maintain a secondary structure just to deal 
> with the confluence of two edge cases (running Xen + reusing an aliased 
> page in a pagetable).

It would be possible though. Even if it were something we make conditional
on Xen. So it is something to keep in mind.

 
> >It could be switched on at runtime if Xen is running perhaps. Or the other
> >thing Xen could do is keep a cache of unaliased page table pages. You
> >could fill it up N pages at a time, and just do a single unmap_aliases call
> >to sanitize them all; also, clean pages returned from pagetables could be
> >reused. Like the quicklists things.
> >  
> 
> Hm, that wouldn't be too bad (so long as it doesn't end up hiding 
> gigabytes of memory away from the rest of the system ;).

Well, it obviously has to be implemented properly ;) Another thing to keep
in mind. If we end up with a huge number of vmap users (which I don't
really anticipate, but maybe), then it might be more common to have aliased
pages, in which case simply detecting them quickly doesn't help if we have
to flush. So this approach would go some way to solving that situation.

 
> >Or: doesn't the host have to do its own alias check anyway? In case of an
> >AWOL guest? Why not just reuse that and trap back into the guest to fix it
> >up?
> 
> That's possible, but awkward.  In many cases these updates will be 
> batched, so it would become a matter of issuing a batch, then picking 
> through the results to see what worked and what failed.  I suppose I 
> could just do the simple flush and then if that turns out too expensive, 
> do the submit-and-retry approach.

OK. Again, this is more of the "fast detection" approach, rather than
avoiding aliasing pages. But it's good to have so many options :)

Anyway, option #4 is just to wait and see. I don't think Xen should
significantly slow down after this patch, it just may be able to go
faster with more tweaking.
