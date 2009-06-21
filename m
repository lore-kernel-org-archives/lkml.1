Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZFUJcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZFUJcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZFUJcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 05:32:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:45354 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZFUJcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 05:32:02 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20090621061847.GB1474@ucw.cz>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090619145913.GA1389@ucw.cz> <1245450449.16880.10.camel@pasglop>
	 <20090619232336.GA2442@elf.ucw.cz> <1245455409.16880.15.camel@pasglop>
	 <20090620002817.GA2524@elf.ucw.cz> <1245463809.16880.18.camel@pasglop>
	 <20090621061847.GB1474@ucw.cz>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 19:31:05 +1000
Message-Id: <1245576665.16880.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Right, that might be something to look into, though we haven't yet
> > applied the technique for suspend & resume. My main issue with it at the
> > moment is how do I synchronize with allocations that are already
> > sleeping when changing the gfp flag mask without bloating the normal
> 
> Well, but the problem already exists, no? If someone is already
> sleeping due to __GFP_WAIT, he'll probably sleep till the resume.

Yes. In fact, without the masking, a driver that hasn't been suspended
yet could well start sleeping in GFP_KERNEL after the disk driver has
suspended. It may do so while holding a mutex or similar, which might
deadlock its own suspend() callback. It's not something that drivers can
trivially address by having a pre-suspend hook, and avoid allocations,
since allocations may be done by subsystems on behalf of the driver or
such. It's a can of worms, which is why I believe the only sane approach
is to stop allocators from doing IOs once we start suspend.

So yes, just applying the mask would help, but wouldn't completely fix
it unless we also find a way to synchronize.

> ...well, if he's sleeping in the disk driver, I suspect driver will
> finish outstanding requests as part of .suspend().
> 
> > I also suspect that we might want to try to make -some- amount of free
> > space before starting suspend, though of course not nearly as
> > aggressively as with std.
> 
> We free 4MB in 2.6.30, but Rafael is removing that for 2.6.31 :-(.

Well... we are taking a chance of making the above scenario more likely
to hit then.

Cheers,
Ben.


