Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbXFTSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbXFTSFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbXFTSFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:05:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46996 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXFTSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:05:23 -0400
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in
	dma	map api calls
From: Peter Zijlstra <peterz@infradead.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
In-Reply-To: <20070620173038.GA25516@linux-os.sc.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	 <20070619213808.798646000@askeshav-devel.jf.intel.com>
	 <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com>
	 <20070620173038.GA25516@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 20:05:03 +0200
Message-Id: <1182362703.21117.79.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 10:30 -0700, Siddha, Suresh B wrote:
> On Wed, Jun 20, 2007 at 06:03:02AM -0700, Arjan van de Ven wrote:
> > Peter Zijlstra wrote:
> > >
> > >
> > >PF_MEMALLOC as is, is meant to salvage the VM from the typical VM
> > >deadlock. 
> > 
> > .. and this IS the typical VM deadlock.. it is your storage driver 
> > trying to write out a piece of memory on behalf of the VM, and calls 
> > the iommu to map it, which then needs a bit of memory....
> 
> Today PF_MEMALLOC doesn't do much in interrupt context. If PF_MEMALLOC
> is the right usage model for this, then we need to fix the behavior of
> PF_MEMALLOC in the interrupt context(for our usage model, we do most
> of the allocations in interrupt context).

Right, I have patches that add GFP_EMERGENCY to do basically that.

> I am not very familiar with PF_MEMALLOC. So experts please comment.

PF_MEMALLOC is meant to avoid the VM deadlock - that is we need memory
to free memory. The one constraint is that its use be bounded. (which is
currently violated in that there is no bound on the number of direct
reclaim contexts - which is on my to-fix list)

So a reclaim context (kswapd and direct reclaim) set PF_MEMALLOC to
ensure they themselves will not block on a memory allocation. And it is
understood that these code paths have a bounded memory footprint.

Now, this code seems to be running from interrupt context, which makes
it impossible to tell if the work is being done on behalf of a reclaim
task.  Is it possible to setup the needed data for the IRQ handler from
process context?

Blindly adding GFP_EMERGENCY to do this, has the distinct disadvantage
that there is no inherent bound on the amount of memory consumed. In my
patch set I add an emergency reserve (below the current watermarks,
because ALLOC_HIGH and ALLOC_HARDER modify the threshold in a relative
way, and thus cannot provide a guaranteed limit). I then accurately
account all allocations made from this reserve to ensure I never cross
the set limit.

Like has been said before, if possible move to blocking allocs
(GFP_NOIO), if that is not possible use mempools (for kmem_cache, or
page alloc), if that is not possible use ALLOC_NO_WATERMARKS
(PF_MEMALLOC, GFP_EMERGENCY) but put in a reserve and account its usage.

The last option basically boils down to reserved based allocation,
something which I hope to introduce some-day...

That is, failure is a OK, unless you're from a reclaim context, those
should make progress.


One thing I'm confused about, in earlier discussions it was said that
mempools are not sufficient because they deplete the GFP_ATOMIC reserve
and only then use the mempool. This would not work because some
downstream allocation would then go splat --- using
PF_MEMALLOC/GFP_EMERGENCY has exactly the same problem!



