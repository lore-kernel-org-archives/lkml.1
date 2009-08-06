Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbZHFKwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbZHFKwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZHFKwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:52:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZHFKw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:52:29 -0400
Date: Thu, 6 Aug 2009 12:51:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20090806105134.GD11236@elte.hu>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com> <20090803112220.GA22936@elte.hu> <20090803072522.1d90f15c@infradead.org> <20090804201109.GA21386@elte.hu> <20090805123501.GF14610@erda.amd.com> <84144f020908060031vb48b983m6e6b1b521e01d6aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908060031vb48b983m6e6b1b521e01d6aa@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Robert,
> 
> On Wed, Aug 5, 2009 at 3:35 PM, Robert Richter<robert.richter@amd.com> wrote:
>
> > The question is more if it makes sense. It's new to me dropping 
> > user/kernel interfaces that are in use and forcing its 
> > developers to rewrite their code. Oprofile is actively developed 
> > and in many distros. It supports architectures perfcounters 
> > doesn't. So, what do you want?
> 
> Maybe we can keep the ABIs in place but use a common machinery 
> under the hood for both perf and oprofile? That said, I do expect 
> oprofile ABIs to be special meaning that there's probably not a 
> whole lot users other than the oprofile user-space tool? So if do 
> convert the user-space tool to use sys_perf_counter_open() and put 
> the in-kernel oprofile code into deep-maintenance mode, maybe we 
> can eventually get rid of it?

Note, we dont need to (and dont want to) 'get rid of oprofile' - 
that's not the point. Nobody is arguing for instant removal of 
oprofile.

All i'm arguing for is to not rewrite all oprofile drivers while we 
try to extend perfcounters support. Robert's series does exactly 
that and that's where my unhappiness comes from ...

As you note it below, in terms of development it's quite a 
distraction to have active development in both facilities, when 
oprofile is arguably on the to-be-obsoleted side of the equation. 

Converting the user-space oprofile tools: instead of some in-kernel 
wrappery, the right approach is to use the already existing high 
level interface: to use sys_perf_counter_open() in the oprofile 
daemon.

It only affects the sample collection daemon (which is a small 
portion of oprofile user-space) and needs no kernel changes. This is 
what i suggested to Robert before and i've seen no argument why this 
cannot be done.

An added bonus is that the legacy oprofile kernel ABI can stay 
completely untouched. (and the oprofile tooling can fall back to it)

And yes, AFAIK oprofile user-space is pretty much the only 
user-space app that relies on the oprofile ABI - at least in the OSS 
space. Robert, is there perhaps some bin-only oprofile based tool 
that you implied before? Which one is it?

> That said, the lack of architecture support for perf is definitely 
> a blocker here...

Note, here's the current (roughly calculated, possibly inaccurate) 
platform support matrix between oprofile and perfcounters:

    + : hw support available
    0 : sw support available
    - : no support

                        oprofile     perfcounters
   alpha                   +             -
   arm                     +             -
   avr32                   +             -
   blackfin                -             -
   cris                    -             -
   frv                     -             0
   h8300                   -             -
   ia64                    +             -
   m32r                    -             -
   m68k                    -             -
   m68knommu               -             -
   microblaze              -             -
   mips                    +             0
   mn10300                 -             -
   parisc                  -             0
   powerpc                 +             +
   s390                    0             0
   sh                      +             0
   sparc                   0             0-[pending]
   x86                     +             +
   xtensa                  -             -

Takeaway points:

 - out of 20 hardware architectures, 8 have oprofile hw-PMU
   support, 2 have timer-fallback support, 11 are not supported at 
   all.

 - out of 20 hardware architectures, 2 have perfcounters hw-PMU 
   support, 6 have sw event support, 12 are not supported at all.

The architectures with the biggest practical weight are: x86, 
powerpc, arm, mips.

So there's a gap but it's not "all architectures" and the transition 
to perfcounters is well underway. Still, oprofile obviously leads 
(it has a 10 years headway) - and it's needed as a compatibility 
option during the migration and even if perf had equivalent support 
it would _still_ be around for some time as a pure ABI compatibility 
thing.

> On Wed, Aug 5, 2009 at 3:35 PM, Robert Richter<robert.richter@amd.com> wrote:
>
> > And why not having more than one profiling subsystem in the 
> > kernel? I see also more than one type of car on the street 
> > though all of them have 4 wheels.
> 
> Well, so far I've only had bad experiences with duplicate 
> functionality in the kernel be it a core kernel subsystem like 
> slab or a device driver (broadcom and e100 come to mind). The 
> problem is that you fragment tester and developer base and end up 
> with a different set of bugs for each of the duplicate components 
> causing more work than necessary. And what eventually happens is 
> that you have only one component that's under active development 
> but you can't get rid of the less active ones because people 
> depend on them and the active one has corner case bugs that just 
> don't get fixed.

Correct. That's my main point.

	Ingo
