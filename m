Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbXEMGxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbXEMGxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbXEMGxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:53:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:35771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbXEMGxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:53:01 -0400
Date: Sun, 13 May 2007 08:52:47 +0200
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
Message-ID: <20070513065246.GA15071@wotan.suse.de>
References: <1178659827.14928.85.camel@localhost.localdomain> <20070508224124.GD20174@wotan.suse.de> <20070508225012.GF20174@wotan.suse.de> <Pine.LNX.4.64.0705091950080.2909@blonde.wat.veritas.com> <20070510033736.GA19196@wotan.suse.de> <Pine.LNX.4.64.0705101935590.18496@blonde.wat.veritas.com> <20070511085424.GA15352@wotan.suse.de> <Pine.LNX.4.64.0705111357120.3350@blonde.wat.veritas.com> <20070513033210.GA3667@wotan.suse.de> <Pine.LNX.4.64.0705130535410.3015@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705130535410.3015@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 05:39:03AM +0100, Hugh Dickins wrote:
> On Sun, 13 May 2007, Nick Piggin wrote:
> > On Fri, May 11, 2007 at 02:15:03PM +0100, Hugh Dickins wrote:
> > 
> > > Hmm, well, I think that's fairly horrid, and would it even be
> > > guaranteed to work on all architectures?  Playing with one char
> > > of an unsigned long in one way, while playing with the whole of
> > > the unsigned long in another way (bitops) sounds very dodgy to me.
> > 
> > Of course not, but they can just use a regular atomic word sized
> > bitop. The problem with i386 is that its atomic ops also imply
> > memory barriers that you obviously don't need on unlock.
> 
> But is it even a valid procedure on i386?

Well I think so, but not completely sure. OTOH, I admit this is one
of the more contentious speedups ;) It is likely to be vary a lot by
the arch (I think the P4 is infamous for expensive locked ops, others
may prefer not to mix the byte sized ops with word length ones).

But that aside, I'd still like to do the lock page in nopage and get
this bug fixed. Now it is possible to fix some other way, eg we could
use another page flag (I'd say it would be better to use that flag for
PG_waiters and speed up all PG_locked users), however I think it is fine
to lock the page over fault. It gets rid of some complexity of memory
ordering there, and we already have to do the wait_on_page_locked thing
to prevent the page_mkclean data loss thingy.

I haven't seen a non-microbenchmark where it hurts.

