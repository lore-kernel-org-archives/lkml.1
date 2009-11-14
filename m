Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbZKNAVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbZKNAVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZKNAVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:21:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57560 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630AbZKNAVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:21:42 -0500
Date: Sat, 14 Nov 2009 01:21:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: d451564 breakage
Message-ID: <20091114002138.GA9421@elte.hu>
References: <20091113151119.GA27752@flint.arm.linux.org.uk>
 <20091113224820.GB29657@elte.hu>
 <20091113230223.GF27752@flint.arm.linux.org.uk>
 <20091113231714.GA21666@elte.hu>
 <20091113233734.GG27752@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113233734.GG27752@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Sat, Nov 14, 2009 at 12:17:14AM +0100, Ingo Molnar wrote:
> > 
> > * Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > 
> > > On Fri, Nov 13, 2009 at 11:48:20PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Russell King <rmk@arm.linux.org.uk> wrote:
> > > > 
> > > > > Change:
> > > > > 
> > > > > highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
> > > > > 
> > > > > Appears to break ARM:
> > > > > 
> > > > > mm/highmem.c: In function ???debug_kmap_atomic???:
> > > > > mm/highmem.c:436: error: ???KM_NMI??? undeclared (first use in this function)
> > > > 
> > > > indeed - sorry.
> > > > 
> > > > Note that debug_kmap_atomic() will be removed in v2.6.33 so i'd suggest 
> > > > to just do the easy solution and add #ifndef dummy definitions to 
> > > > mm/highmem.c to cover ARM - we'll remove the whole cruft for good.
> > > 
> > > Actually, the following patch is probably the simplest solution.
> > > 
> > > > Btw., testing sidenote: i test the ARM defconfig and it didnt break 
> > > > there. Perhaps highmem is off in the ARM defconfig? It would be helpful 
> > > > if the ARM defconfig enabled highmem.
> > > 
> > > Given that highmem on ARM is experimental, I'd rather not have it enabled
> > > in too many machine defconfigs as standard just yet.
> > > 
> > > However, enabling highmem on itself is not enough to show this breakage,
> > > you also need highmem debugging enabled.
> > > 
> > >  arch/arm/include/asm/kmap_types.h |    6 ++++++
> > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/arm/include/asm/kmap_types.h b/arch/arm/include/asm/kmap_types.h
> > > index d16ec97..c019949 100644
> > > --- a/arch/arm/include/asm/kmap_types.h
> > > +++ b/arch/arm/include/asm/kmap_types.h
> > > @@ -22,4 +22,10 @@ enum km_type {
> > >  	KM_TYPE_NR
> > >  };
> > >  
> > > +#ifdef CONFIG_DEBUG_HIGHMEM
> > > +#define KM_NMI		(-1)
> > > +#define KM_NMI_PTE	(-1)
> > > +#define KM_IRQ_PTE	(-1)
> > > +#endif
> > 
> > Please solve this in mm/highmem.c as Andrew suggested it - other 
> > architectures could be affected as well beyond ARM.
> 
> Have you actually put any thought into that approach? [...]

Yes.

> [...]  What you're suggesting means:
> 
> - adding preprocessor definitions to all existing places where these
>   symbols are defined
> - adding multiple complex ifdefs to mm/highmem.c thusly:
> 
> 		if (
> #ifdef KM_NMI
> 			type != KM_NMI
> #else
> 			1
> #endif
> 			&&
> #ifdef KM_NMI_PTE
> 			type != KM_NMI_PTE
> #else
> 			1
> #endif

I'd NAK such ugly code.

What i was thinking of was a really simple thing in highmem.c (or 
rather, in include/linux/highmem.h, after kmap_types.h gets included):

#ifndef KM_NMI
# define KM_NMI			-1
#endif
#ifndef KM_NMI_PTE
# define KM_NMI_PTE		-1
#endif

etc.

Thanks,

	Ingo
