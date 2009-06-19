Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbZFSVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbZFSVJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZFSVI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:08:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52345 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbZFSVI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:08:58 -0400
Date: Fri, 19 Jun 2009 23:08:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
Message-ID: <20090619210839.GB26037@elte.hu>
References: <4A39F5B4.1070305@kernel.org> <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain> <4A3AC0BA.4000407@kernel.org> <4A3AEE42.4010300@kernel.org> <20090619053944.GB8162@elte.hu> <alpine.LFD.2.01.0906191235490.16802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906191235490.16802@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 19 Jun 2009, Ingo Molnar wrote:
> > 
> > ( Many wont btw: we still dont have lockdep support in all
> >   architectures - 3 years and counting. It's a highly useful purely
> >   sw feature with zero hardware dependencies. Fortunately it's
> >   well-modularized and the functionality is non-essential. Percpu
> >   allocation is not so lucky as it's essential functionality. )
> 
> When it coems to code coverage, x86 matters _so_ much more than 
> any other architecture, that verification features like lockdep 
> etc are way more important on x86 than on anything else.
> 
> Sure, there may be locking issues in some arch-specific code, and 
> other architectures could be better off caring. But the advantage 
> of lockdep for some pissant architecture that has a very limited 
> user base (maybe lots of chips, but much more limited _use_ - 
> fewer drivers, fewer workloads etc) is much lower, since those 
> architectures know that x86 will give them 99% of the coverage.
> 
> So it's quite reasonable to think that other architectures simply 
> care less.

Hm, agreed, i accept that point. A minimal architecture can be 
implemented in as little as 10-20 KLOC, and the chances of there 
being lockups in that code, versus the millions of lines of code 
they take advantage of, is proportionately low.

Btw., here's the current lockdep support list:

  for N in arch/*/; do printf "%30s: %d\n" $N \
    $(git grep -l -w LOCKDEP_SUPPORT $N | wc -l); done | \
      sort -t: -n -k 2 -r
 
                     arch/x86/: 1
                      arch/um/: 1
                   arch/sparc/: 1
                      arch/sh/: 1
                    arch/s390/: 1
                 arch/powerpc/: 1
                    arch/mips/: 1
                arch/blackfin/: 1
                   arch/avr32/: 1
                     arch/arm/: 1
                  arch/xtensa/: 0
                  arch/parisc/: 0
                 arch/mn10300/: 0
              arch/microblaze/: 0
               arch/m68knommu/: 0
                    arch/m68k/: 0
                    arch/m32r/: 0
                    arch/ia64/: 0
                   arch/h8300/: 0
                     arch/frv/: 0
                    arch/cris/: 0
                   arch/alpha/: 0

Lockdep is supported on 10 architectures, not supported on 12.

We still have regular friction between pre-lockdep and post-lockdep 
APIs, such as local_irq_save / raw_local_irq_save. If some generic 
code makes use of raw_local_irq_save then non-lockdep architectures 
break and the 'offending' tree gets excluded from linux-next.

So there's ongoing cost involved for the core kernel as well and 
non-lockdep architectures dont just hurt themselves, they also hurt 
core kernel changes, via their incomplete APIs. Such assymetries 
could be eliminated without adding lockdep support, by providing 1:1 
aliases - but not even this minimal step is done as there's 
basically no incentive on the part of these architectures to do it.

Taking advantage of other trees while costing them - that looks a 
bit like parasitic behavior to me, in this specific instance of 
lockdep support - wouldnt you agree to a certain degree?

	Ingo
