Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbZE3KYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbZE3KYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZE3KYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:24:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZE3KYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:24:09 -0400
Date: Sat, 30 May 2009 12:23:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090530102330.GC16913@elte.hu>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528061702.GB6920@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Nick Piggin <npiggin@suse.de> wrote:

> FWIW, we had to disable paravirt in our default SLES11 kernel. 
> (admittedly this was before some of the recent improvements were 
> made). But there are only so many 1% performance regressions you 
> can introduce before customers won't upgrade (or vendors won't 
> publish benchmarks with the new software).
> 
> But OTOH, almost any bit feature is going to cost performance. I don't
> think this is something new (as noted with CONFIG_SECURITY). [...]

Yes in a way, but the difference is that:

 - i noted CONFIG_SECURITY as the _worst current example_. It is the
   largest-overhead feature known to me in this area, and i 
   benchmark the kernel a lot. CONFIG_PARAVIRT has _even more_
   overhead so it takes the (dubious) top spot in this category.

 - CONFIG_SECURITY, in the distros where it's enabled (most of them) 
   it is actually being relied on by the default user-space. It's 
   being configured and every default install of the distro has a 
   real (or at least perceived) advantage from it.

Not so with CONFIG_PARAVIRT. That feature is almost fully parasitic 
to native environments: currently it brings no advantage on native 
hardware _at all_ (and 95% of the users dont care about Xen).

Still it's impractical for a distro to disable it because adding a 
separate kernel package has high costs too and PARAVIRT=y is needed 
for the weird execution environment that Xen requires to run Linux 
with acceptable speed.

It's as if we paid a full 1% overhead from the requirements of say 
Centaur CPUs, on all other CPUs (Intel and AMD). That would be 
inacceptable to owners of Intel and AMD CPUs: and so would it be 
inacceptable to distros to have a separate kernel package for it.

A distro is unable to hold the tide of creeping bloat - they dont 
have the long-term view (and probably shouldnt have it - a distro 
should care about and maximize the here-and-now utility of Linux 
mostly). Upstream maintainers are the ones to say "NO" to such crap, 
even if it's unpopular. In this current case that's me i guess.

Note what _is_ acceptable and what _is_ doable is to be a bit more 
inventive when dumping this optional, currently-high-overhead 
paravirt feature on us. My message to Xen folks is: use dynamic 
patching, fix your hypervisor and just use plain old-fashioned 
_restraint_ and common sense when engineering things, and for 
heaven's sake, _care_ about the native kernel's performance because 
in the long run it's your bread and butter too.

1% overhead (paid by _everyone_ who runs that distro kernel) for 
something 95%+ of the users _wont ever use_ is _not acceptable_.

So unless this overhead is brought down significantly i see the dom0 
patches as outright harmful: upstream dom0 makes PARAVIRT=Y even 
_harder_ for distros to disable, and there will be even _less_ 
incentive for Xen folks to get the native bloat they caused under 
control.

Note that specific pieces of the dom0 patches, like the io-apic 
driver patches, are still acceptable of course, as they improve the 
overall quality of the kernel. Helping dom0 too as a 'side effect' 
is fully acceptable as long as everyone else is helped too.

And if the performance problems are largely fixed (say 0.1%-0.2% 
overhead in the benchmarks i did would be acceptable IMO), and if 
the patches are all squeaky-clean, i suspect we can do upstream dom0 
as well.

	Ingo
