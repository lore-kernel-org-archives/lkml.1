Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZFILSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZFILSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZFILSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:18:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZFILSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:18:07 -0400
Date: Tue, 9 Jun 2009 13:17:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090609111719.GA4463@elte.hu>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609093918.GC16940@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Thu, Jun 04, 2009 at 08:02:14AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 4 Jun 2009, Rusty Russell wrote:
> > > >
> > > > Turn off HIGHMEM64G, please (and HIGHMEM4G too, for that matter - you
> > > > can't compare it to a no-highmem case).
> > > 
> > > Thanks, your point is demonstrated below.  I don't think HIGHMEM4G is 
> > > unreasonable for a distro tho, so I turned that on instead.
> > 
> > Well, I agree that HIGHMEM4G is a _reasonable_ thing to turn on.
> > 
> > The thing I disagree with is that it's at all valid to then compare to 
> > some all-software feature thing. HIGHMEM doesn't expand any esoteric 
> > capability that some people might use - it's about regular RAM for regular 
> > users.
> > 
> > And don't get me wrong - I don't like HIGHMEM. I detest the damn thing. I 
> > hated having to merge it, and I still hate it. It's a stupid, ugly, and 
> > very invasive config option. It's just that it's there to support a 
> > stupid, ugly and very annoying fundamental hardware problem.
> 
> I was looking forward to be able to get rid of it... unfortunately 
> other 32-bit architectures are starting to use it again :(
> 
> I guess it is not incredibly intrusive for generic mm code. A bit 
> of kmap sprinkled around which is actually quite a useful 
> delimiter of where pagecache is addressed via its kernel mapping.
> 
> Do you hate more the x86 code? Maybe that can be removed?

IMHO what hurts most about highmem isnt even its direct source code 
overhead, but three factors:

 - The buddy allocator allocates top down, with highmem pages first.
   So a lot of critical apps (the first ones started) will have 
   highmem footprint, and that shows up every time they use it for 
   file IO or other ops. kmap() overhead and more.

 - Highmem is not really a 'solvable' problem in terms of good VM 
   balancing. It gives conflicting constraints and there's no single 
   'good VM' that can really work - just a handful of bad solutions 
   that differ in their level and area of suckiness.

 - The kmap() cache itself can be depleted, and using atomic kmaps 
   is fragile and error-prone. I think we still have a FIXME of a 
   possibly triggerable deadlock somewhere in the core MM code ...

OTOH, highmem is clearly a useful hardware enablement feature with a 
slowly receding upside and a constant downside. The outcome is 
clear: when a critical threshold is reached distros will stop 
enabling it. (or more likely, there will be pure 64-bit x86 distros)

Highmem simply enables a sucky piece of hardware so the code itself 
has an intrinsic level of suckage, so to speak. There's not much to 
be done about it but it's not a _big_ problem either: this type of 
hw is moving fast out of the distro attention span.

( What scares/worries me much more than sucky hardware is sucky
  _software_ ABIs. Those have a half-life measured not in years but 
  in decades and they get put into new products stubbornly, again
  and again. There's no Moore's Law getting rid of sucky software
  really and unlike the present set of sucky highmem hardware 
  there's no influx of cosmic particles chipping away on their 
  installed base either. )

	Ingo
