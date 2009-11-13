Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbZKMXiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbZKMXiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932610AbZKMXiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:38:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38542 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbZKMXiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:38:02 -0500
Date: Fri, 13 Nov 2009 23:37:34 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: d451564 breakage
Message-ID: <20091113233734.GG27752@flint.arm.linux.org.uk>
References: <20091113151119.GA27752@flint.arm.linux.org.uk> <20091113224820.GB29657@elte.hu> <20091113230223.GF27752@flint.arm.linux.org.uk> <20091113231714.GA21666@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113231714.GA21666@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 14, 2009 at 12:17:14AM +0100, Ingo Molnar wrote:
> 
> * Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > On Fri, Nov 13, 2009 at 11:48:20PM +0100, Ingo Molnar wrote:
> > > 
> > > * Russell King <rmk@arm.linux.org.uk> wrote:
> > > 
> > > > Change:
> > > > 
> > > > highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
> > > > 
> > > > Appears to break ARM:
> > > > 
> > > > mm/highmem.c: In function ???debug_kmap_atomic???:
> > > > mm/highmem.c:436: error: ???KM_NMI??? undeclared (first use in this function)
> > > 
> > > indeed - sorry.
> > > 
> > > Note that debug_kmap_atomic() will be removed in v2.6.33 so i'd suggest 
> > > to just do the easy solution and add #ifndef dummy definitions to 
> > > mm/highmem.c to cover ARM - we'll remove the whole cruft for good.
> > 
> > Actually, the following patch is probably the simplest solution.
> > 
> > > Btw., testing sidenote: i test the ARM defconfig and it didnt break 
> > > there. Perhaps highmem is off in the ARM defconfig? It would be helpful 
> > > if the ARM defconfig enabled highmem.
> > 
> > Given that highmem on ARM is experimental, I'd rather not have it enabled
> > in too many machine defconfigs as standard just yet.
> > 
> > However, enabling highmem on itself is not enough to show this breakage,
> > you also need highmem debugging enabled.
> > 
> >  arch/arm/include/asm/kmap_types.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kmap_types.h b/arch/arm/include/asm/kmap_types.h
> > index d16ec97..c019949 100644
> > --- a/arch/arm/include/asm/kmap_types.h
> > +++ b/arch/arm/include/asm/kmap_types.h
> > @@ -22,4 +22,10 @@ enum km_type {
> >  	KM_TYPE_NR
> >  };
> >  
> > +#ifdef CONFIG_DEBUG_HIGHMEM
> > +#define KM_NMI		(-1)
> > +#define KM_NMI_PTE	(-1)
> > +#define KM_IRQ_PTE	(-1)
> > +#endif
> 
> Please solve this in mm/highmem.c as Andrew suggested it - other 
> architectures could be affected as well beyond ARM.

Have you actually put any thought into that approach?  What you're
suggesting means:

- adding preprocessor definitions to all existing places where these
  symbols are defined
- adding multiple complex ifdefs to mm/highmem.c thusly:

		if (
#ifdef KM_NMI
			type != KM_NMI
#else
			1
#endif
			&&
#ifdef KM_NMI_PTE
			type != KM_NMI_PTE
#else
			1
#endif
		) {
			WARN_ON(1);
			warn_count--;
		}

and I really don't think this is a realistic solution, even for the
interim.

The other solution is to determine if KM_NMI/KM_NMI_PTE/KM_IRQ_PTE are
x86 only (which does seem to be the case).  If that is the case, moving
the new definitions in my patch into mm/highmem.c itself and ifdef out
the ones in asm-generic/km_types.h would seem like another possible
approach.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
