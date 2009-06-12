Return-Path: <linux-kernel-owner+w=401wt.eu-S932824AbZFLICw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824AbZFLICw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZFLICg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:02:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbZFLICe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:02:34 -0400
Date: Fri, 12 Jun 2009 10:02:36 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: slab: setup allocators earlier in the boot sequence
Message-ID: <20090612080236.GB24044@wotan.suse.de>
References: <200906111959.n5BJxFj9021205@hera.kernel.org> <1244770230.7172.4.camel@pasglop> <1244779009.7172.52.camel@pasglop> <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop> <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI> <1244792079.7172.74.camel@pasglop> <1244792745.30512.13.camel@penberg-laptop> <20090612075427.GA24044@wotan.suse.de> <1244793592.30512.17.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244793592.30512.17.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:59:52AM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Fri, Jun 12, 2009 at 10:45:45AM +0300, Pekka Enberg wrote:
> > > On Fri, 2009-06-12 at 17:34 +1000, Benjamin Herrenschmidt wrote:
> > > > I really believe this should be a slab internal thing, which is what my
> > > > patch does to a certain extent. IE. All callers need to care about is
> > > > KERNEL vs. ATOMIC and in some cases, NOIO or similar for filesystems
> > > > etc... but I don't think all sorts of kernel subsystems, because they
> > > > can be called early during boot, need to suddenly use GFP_NOWAIT all the
> > > > time.
> > > > 
> > > > That's why I much prefer my approach :-) (In addition to the fact that
> > > > it provides the basis for also fixing suspend/resume).
> > > 
> > > Sure, I think we can do what you want with the patch below.
> 
> On Fri, 2009-06-12 at 09:54 +0200, Nick Piggin wrote:
> > I don't really like adding branches to slab allocator like this.
> > init code all needs to know what services are available, and
> > this includes the scheduler if it wants to do anything sleeping
> > (including sleeping slab allocations).
> > 
> > Core mm code is the last place to put in workarounds for broken
> > callers...
> 
> Yes, the initialization code can be fixed to use GFP_NOWAIT. But it's
> really the suspend case that makes me think the patch might be a good
> idea. So the patch does not attempt to be a workaround for buggy callers
> but rather a change in policy that we simply refuse to wait during
> bootup and suspend.

Fair enough, but this can be done right down in the synchronous
reclaim path in the page allocator. This will catch more cases
of code using the page allocator directly, and should be not
as hot as the slab allocator.

