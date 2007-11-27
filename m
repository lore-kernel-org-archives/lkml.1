Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXK0MKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXK0MKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXK0MKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:10:34 -0500
Received: from paragon.brong.net ([74.52.187.94]:46747 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbXK0MKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:10:33 -0500
Date: Tue, 27 Nov 2007 23:10:28 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rob Mueller <robm@fastmail.fm>
Subject: dirty highmem calculation sysctl name (Was: [PATCH 1/1] mm: add
	dirty_highmem option)
Message-ID: <20071127121028.GA19148@brong.net>
References: <20071115115049.GA8297@brong.net> <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org> <20071122034204.GA14079@brong.net> <20071126205428.c264ccff.akpm@linux-foundation.org> <1196141064.31920.1223402735@webmail.messagingengine.com> <20071126215315.3422eaa2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126215315.3422eaa2.akpm@linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 09:53:15PM -0800, Andrew Morton wrote:
> On Tue, 27 Nov 2007 16:24:24 +1100 "Bron Gondwana" <brong@fastmail.fm> wrote:
> 
> > On Mon, 26 Nov 2007 20:54:28 -0800, "Andrew Morton" <akpm@linux-foundation.org> said:
> > > On Thu, 22 Nov 2007 14:42:04 +1100 Bron Gondwana <brong@fastmail.fm>
> > > wrote:
> > > 
> > > >  /*
> > > > + * free highmem will not be subtracted from the total free memory
> > > > + * for calculating free ratios if vm_dirty_highmem is true
> > > > + */
> > > > +int vm_dirty_highmem;
> > > 
> > > One would expect that setting dirty_highmem to true would cause highmem
> > > to
> > > be accounted in dirty-memory calculations.  However with this change
> > > reality is in fact the inverse of that.
> > > 
> > > So how about this?
> > 
> > Actually, I'm confused now.  Maybe I chose a bad name to begin with.
> > Does it mean "I am allowed to dirty high memory" or "my high memory
> > will be dirty if this is on"?
> 
> But we're always allowed to dirty highmem - there'd be no point in having
> it otherwise.  Hence the term dirty_highmem is confusing.
> 
> umm, really you want
> /proc/sys/vm/dont-account-highmem-in-dirty-memory-calculations, only
> shorter.
> 
> Do you agree?

I still read dirty_highmem as:

/proc/sys/vm/do-account-highmem-in-dirty-memory-calculations

... so we're still talking one negative apart!
 
> If so, then it's still not a very pleasing interface - setting something to
> "true" to disable a particular piece of kernel behaviour implies a single
> negation which we don't really need.

Well, the particular piece of kernel behaviour is already a negative:

 "decrease the amount of memory allowed to get dirty so we never dirty
  more than a percentage of available lowmem"

So what this flag is saying is:

 "DON'T decrease the amount of memory allowed to get dirty down to just
  the lowmem - dirty a percentage of total available including highmem"

As Linus said - the alternative of allowing more than 100% of lowmem
to be dirty is just plain too wierd, hence this approach of allowing
an option to turn off the new restriction that appeared since 2.6.16.

> It would be simpler to have
> /proc/sys/vm/do-account-highmem-in-dirty-memory-calculations,
> defaulting to "true" - this has no negations.

No, that's not true.  The whole point is that between 2.6.16 and
2.6.20 the kernel behaviour changed.  It currently doesn't count
highmem in dirty memory calculations, which is why the memory pressure
appears to be so great when actually there's still 4Gb of unused
memory in the box.

/proc/sys/vm/do-account-highmem-in-dirty-memory-calculations would
default to "false" to get the current behaviour post-2.6.16 kernels.

Setting a flag to make it true would stop the kernel subtracting 
highmem from the available count, giving the "old" behaviour of
allowing a percentage of all the memory in the system to be dirty
before forcing writeback.

> So... how about /proc/sys/vm/, umm.
> 
> <looks at inbox, brain explodes>
> 
> OK, I give up.  Please see if you can think of something less confusing
> which involves no negations?

I've spent a while thinking about this, and looking at the code.

I think this might be slightly clearer:


/proc/sys/vm/highmem_is_dirtyable - defaults to false


Here's how it would look in the code:

static unsigned long determine_dirtyable_memory(void)
{
        unsigned long x;

        x = global_page_state(NR_FREE_PAGES)
                + global_page_state(NR_INACTIVE)
                + global_page_state(NR_ACTIVE);

        if (!vm_highmem_is_dirtyable)
                x -= highmem_dirtyable_memory(x);

        return x + 1; /* Ensure that we never return 0 */
}


I think that's very clear.

"Unless highmem is dirtyable, subtract the otherwise dirtyable
 pages from the total dirtyable memory count if they are in
 highmem"

Or without negatives:

"If highmem is dirtyable then include highmem pages in the
 total dirtyable memory count"

Unfortunately this isn't expressed without negatives in the
code because it's easier (I presume without looking at all the
different zones on a cruddy piece of old i386) to add up the 
total and remove the pages in the HIGHMEM zone than to add up
all the non-HIGHMEM zones separately.


Does that suit you?  Does my explaination make sense?

Would you like me to re-submit the patch based on this?  I'm
certainly not happy with dirty_highmem as it is now in mm
because it looks backwards and unclear to me.

Bron.
