Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbZFLN4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbZFLN4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZFLN4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:56:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59358 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZFLN4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:56:09 -0400
Date: Fri, 12 Jun 2009 15:56:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open
	when supported
Message-ID: <20090612135603.GF32105@elte.hu>
References: <20090612120507.GH16044@elte.hu> <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com> <20090612121757.GD31845@elte.hu> <8bd0f97a0906120522v51ae0151i48d5f6846ddcff10@mail.gmail.com> <20090612123152.GE31845@elte.hu> <8bd0f97a0906120541x739b7902pe40ff7aa91337bac@mail.gmail.com> <20090612125941.GI31845@elte.hu> <8bd0f97a0906120604o1e90ac93l469e86173224364e@mail.gmail.com> <20090612130949.GJ31845@elte.hu> <8bd0f97a0906120621o609d7489v83cd3efc0102412d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906120621o609d7489v83cd3efc0102412d@mail.gmail.com>
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


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Fri, Jun 12, 2009 at 09:09, Ingo Molnar wrote:
> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> >> On Fri, Jun 12, 2009 at 08:59, Ingo Molnar wrote:
> >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> >> >> On Fri, Jun 12, 2009 at 08:31, Ingo Molnar wrote:
> >> >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> >> >> >> On Fri, Jun 12, 2009 at 08:17, Ingo Molnar wrote:
> >> >> >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> >> >> >> >> On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
> >> >> >> >> > * Mike Frysinger <vapier@gentoo.org> wrote:
> >> >> >> >> >> If the port does not support HAVE_PERF_COUNTERS, then they can't
> >> >> >> >> >> support the perf_counter_open syscall either.  Rather than forcing
> >> >> >> >> >> everyone to add an ignore (or suffer the warning until they get
> >> >> >> >> >> around to implementing support), only whine about the syscall when
> >> >> >> >> >> applicable.
> >> >> >> >> >
> >> >> >> >> > No, this patch is wrong - it's really easy to add support: just hook
> >> >> >> >> > up the syscall. This should happen for every architecture really, so
> >> >> >> >> > the warning is correct and it should not be patched out.
> >> >> >> >> >
> >> >> >> >> > PMU support is not required to get perfcounters support: if an
> >> >> >> >> > architecture hooks up the syscall it will get generic software
> >> >> >> >> > counters and the tools will work as well.
> >> >> >> >> >
> >> >> >> >> > Profiling falls back to a hrtimer-based sampling method - this is a
> >> >> >> >> > much better fallback than oprofile's fall-back to the timer tick.
> >> >> >> >> > This hrtimer based sampling is dynticks/nohz-correct and can go
> >> >> >> >> > beyond HZ if the architecture supports hrtimers.
> >> >> >> >>
> >> >> >> >> if there is generic support available, why must every arch select
> >> >> >> >> HAVE_PERF_COUNTERS in their Kconfig ?
> >> >> >> >
> >> >> >> > Because we only want to enable it on architectures that have tested
> >> >> >> > it. It should only need a syscall addition, but nothing beats having
> >> >> >> > tested things, hence we have that additional Kconfig symbol.
> >> >> >>
> >> >> >> that is a pretty weak reason. [...]
> >> >> >
> >> >> > It isnt - this is proper isolation - dont offer something to the
> >> >> > user to enable that 1) cannot be used due to the lack of a syscall
> >> >> > 2) has not been tested by anyone on that architecture, ever.
> >> >> >
> >> >> > That way say build breakages or runtime failures due to perfcounters
> >> >> > only become possible on an architecture if the architecture
> >> >> > maintainer has hooked up the syscall and has provided
> >> >> > HAVE_PERF_COUNTERS explicitly.
> >> >>
> >> >> except that the syscall presence is trivial to detect in the code by
> >> >> something like:
> >> >> #ifndef __NR_perf_counter_open
> >> >> # error sorry, your arch has not hooked up perf_counter_open syscall yet
> >> >> #endif
> >> >>
> >> >> as for "no arch testing yet", there are plenty of drivers which lack
> >> >> arch depends in the Kconfig specifically so that it can be *easily*
> >> >> tested on random systems out there without requiring manual twiddling.
> >> >
> >> > This is a new kernel subsystem, not just yet another driver.
> >>
> >> so what ?  if it has generic pieces, it is exactly the same as yet
> >> another generic driver.  people should be able to randomly test
> >> build it when possible to discover latent issues that your testing
> >> limited to one arch did not find.
> >>
> >> > Which bit of: "we dont want perfcounters to be enabled in the
> >> > Kconfig on architectures that have no syscalls and no testing for
> >> > it" is hard to understand? It is a valid technical concern.
> >>
> >> your (1) is valid but i already pointed out a simple fix for that.
> >> your (2) is not.
> >
> > Uhm, your 'fix':
> >
> >  #ifndef __NR_perf_counter_open
> >  # error sorry, your arch has not hooked up perf_counter_open syscall yet
> >  #endif
> >
> > is completely unacceptable. We dont propagate build failures via
> > user-enable config options, we never did. There's a lot of people
> > doing randconfig builds - if it randomly failed due to your 'fix'
> > that would upset a lot of testing for no good reason.
> 
> accept that is a valid bug: the arch is missing the syscall and it 
> should hook it up

Uhm, that's ridiculous, observe lkml for a few weeks and see what 
happens when any subsystem fails to build in a user-configurable 
variation. Even if it's "just" because something like a syscall 
definition is missing.

Anyway, i have no time to teach you about kernel mainteinance basics 
really so i probably wont follow up on future emails.

Thanks,

	Ingo
