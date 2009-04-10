Return-Path: <linux-kernel-owner+w=401wt.eu-S1764664AbZDJJtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764664AbZDJJtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZDJJta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:49:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36852 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbZDJJt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:49:29 -0400
Date: Fri, 10 Apr 2009 11:47:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       hch@infradead.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 09/30] x86_64: ifdef out struct thread_struct::ip
Message-ID: <20090410094738.GA11770@elte.hu>
References: <20090410023522.GJ27788@x200.localdomain> <20090410035328.GB29496@us.ibm.com> <20090410091931.GF17962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410091931.GF17962@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Matt Helsley <matthltc@us.ibm.com> wrote:
> 
> > On Fri, Apr 10, 2009 at 06:35:22AM +0400, Alexey Dobriyan wrote:
> > > struct thread_struct::ip isn't used on x86_64, struct pt_regs::ip is used
> > > instead. 
> > > 
> > > kgdb should be reading 0, but I can't check it.
> > > 
> > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > ---
> > > 
> > >  arch/x86/include/asm/processor.h |    2 ++
> > >  arch/x86/kernel/kgdb.c           |    2 +-
> > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > --- a/arch/x86/include/asm/processor.h
> > > +++ b/arch/x86/include/asm/processor.h
> > > @@ -421,7 +421,9 @@ struct thread_struct {
> > >  	unsigned short		fsindex;
> > >  	unsigned short		gsindex;
> > >  #endif
> > > +#ifdef CONFIG_X86_32
> > >  	unsigned long		ip;
> > > +#endif
> > >  #ifdef CONFIG_X86_64
> > >  	unsigned long		fs;
> > >  #endif
> > 
> > Do these make struct thread_struct behave better in cachelines 
> > (smaller, less aliasing)? Can we really fit more in the slab du 
> > jour?
> > 
> > Otherwise it seems like we're littering these structs with #ifdefs 
> > and not really saving anything. [...]
> 
> Removing fields always saves memory (even if it does not show up 
> currently due to allocators cache-aligning sizes).

I mean: we always try to consider structure size reductions as if 
they saved real memory, even if they dont do so in the current 
layout and allocation patterns.

In reality only every 8th 8-byte reduction will result in a true 
64-byte cacheline reduction - but still we have to continue small 
reductions otherwise we wont ever get to the larger reductions in 
the first place.

I.e. Alexey's patch shows a real item worth checking, regardless of 
the current size and alignment scenario.

	Ingo
