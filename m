Return-Path: <linux-kernel-owner+w=401wt.eu-S1763718AbZFLJay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763718AbZFLJay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbZFLJap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:30:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959AbZFLJap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:30:45 -0400
Date: Fri, 12 Jun 2009 11:30:46 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: slab: setup allocators earlier in the boot sequence
Message-ID: <20090612093046.GG24044@wotan.suse.de>
References: <1244792079.7172.74.camel@pasglop> <1244792745.30512.13.camel@penberg-laptop> <20090612075427.GA24044@wotan.suse.de> <1244793592.30512.17.camel@penberg-laptop> <20090612080236.GB24044@wotan.suse.de> <1244793879.30512.19.camel@penberg-laptop> <1244796291.7172.87.camel@pasglop> <84144f020906120149k6cbe5177vef1944d9d216e8b2@mail.gmail.com> <20090612091304.GE24044@wotan.suse.de> <1244798660.7172.102.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244798660.7172.102.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 07:24:20PM +1000, Benjamin Herrenschmidt wrote:
> 
> > It's OK. I'd make it gfp_notsmellybits, and avoid the ~.
> > And read_mostly.
> 
> read_mostly is fine. gfp_notsmellybits isn't a nice name :-) Make it
> gfp_allowedbits then. I did it backward on purpose though as the risk of
> "missing" bits here (as we may add new ones) is higher and it seemed to
> me generally simpler to just explicit spell out the ones to forbid
> (also, on powerpc,  &~ is one instruction :-)

But just do the ~ in the assignment. No missing bits :)

  
> > Probably would be better to hide it in mm/ and then just
> > allow it to be modified with a couple of calls. OTOH if
> > it is only modified in a couple of places then maybe that's
> > overkill.
> 
> It might indeed be nicer to hide it behind an accessor.
> 
> > The whole problem comes about because we don't just restore
> > our previously saved flags here... I guess it probably adds
> > even more overhead to do that and make everything just work :(
> 
> Well... that's part of the equation. My solution has the advantage to
> also providing ground to forbid GFP_IO during suspend/resume etc...

Yeah but it doesn't do it in the page allocator so it isn't
really useful as a general allocator flags tweak. ATM it only
helps this case of slab allocator hackery.

In my slab allocator I'm going to actually look at what it
costs to keep track of flags properly. That would be far cleaner...
OTOH, SLUB is apparently much more sensitive about page allocator
performance so maybe the hack is worthwhile there.

