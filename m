Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbXI1Ql4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbXI1Ql4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXI1Qlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:41:47 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:45478 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751566AbXI1Qlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:41:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bs0t2JyHwmzZadT8RUH3U1K8IK9SpWKjtECm9/RuImb6NCVvojFKore1oYONJf1qDxJNm+AbPWYitXw9c1gLkeSWokggwX4fMOD62obNq/+MrdCPyIEFF/eavORkryFD7Z8SX15njIzRlfx1TQS8+wHPxUCRR/E6i6L9KjDj6dQ=  ;
X-YMail-OSG: SxDxgYoVM1k8_FdItHrPNHzb3m1fm4YDZkVfnT.kQXWN1unQPhHEH2iQXwqygrfp7CFQEuDQiQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] writeback: remove unnecessary wait in throttle_vm_writeout()
Date: Fri, 28 Sep 2007 10:10:27 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, hirofumi@mail.parknet.co.jp,
       galak@kernel.crashing.org, zaitcev@redhat.com, greg@kroah.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <390857819.00313@ustc.edu.cn> <20070928080202.GA10293@elte.hu> <20070928162347.GA11024@Krystal>
In-Reply-To: <20070928162347.GA11024@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281010.28086.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007 02:23, Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > This is a pretty major bugfix.
> > >
> > > GFP_NOIO and GFP_NOFS callers should have been spending really large
> > > amounts of time stuck in that sleep.
> > >
> > > I wonder why nobody noticed this happening.  Either a) it turns out
> > > that kswapd is doing a good job and such callers don't do direct
> > > reclaim much or b) nobody is doing any in-depth kernel
> > > instrumentation.
> >
> > [ Oh, it's Friday already, so soapbox time i guess. The easily offended
> >   please skip this mail ;-) ]
> >
> > People _have_ noticed, and we often ignored them. I can see four
> > fundamental, structural problems:
> >
> > 1) A certain lack of competitive pressure. An MM is too complex and
> >    there is no "better Linux MM" to compare against objectively. The
> >    BSDs are way too different and it's easy to dismiss even objective
> >    comparisons due to the real complexity of the differences. Heck,
> >    2.6.9 is "way too different" and we routinely reject bugreports from
> >    such old kernels and lose vital feedback.
> >
> > 2) There is a wide-spread mentality of "you prove that there is a
> >    problem" in the MM and elsewhere in the Linux kernel too. While of
> >    course objective proof is paramount, we often "hide" behind our
> >    self-created complexity of the system (without malice and without
> >    realising it!). We've seen that happen in the updatedb discussions
> >    and the swap-prefetch discussions. The correct approach would be for
> >    the MM folks to be able to tell for just about any workload "this is
> >    not our problem", and to have the benefit of the doubt _on the
> >    tester's side_. We must not ignore people who tell us that "there is
> >    something wrong going on here", just because they are unable to
> >    analyze it themselves. Very often where we end up saying "we dont
> >    know what's going on here" it's likely _our_ fault. We also must not
> >    hide behind "please do these 10 easy steps and 2 kernel recompiles
> >    and 10 reboots, only takes half a day, and come back to us once you
> >    have the detailed debug data" requests. Instrumentation must be _on
> >    by default_ (like SCHED_DEBUG is on by default), which brings us to:
> >
> > 3) Instrumentation and tools. Instrumentation (for example MM delay
> >    statistics - like the scheduler delay statistics) give an objective
> >    measure to compare kernels against each other. _Smart_ and _easy to
> >    use_ and _default enabled_ instrumentation is a must. Not "turn on
> >    these 3 zillion kernel options" which no distro enables. Debug
> >    tools/scripts that use the instrumentation, that just have to be run
> >    and produce meaningful output based on which 90% of the workloads can
> >    be analyzed _without having to ask the user to do more_. (See
> >    PowerTop as an example, the right kind of instrumentation can do
> >    wonders that enables users to help us. We worked hard to lower the
> >    cost of /proc/timer_stats so that distros can enable it by default -
> >    and now they do enable it by default.)
> >
> > 4) The use of heuristics and the resulting inevitable nondeterminism in
> >    the MM. I guess i'm biased about this, doing -rt and CFS, but we've
> >    seen that happen with the scheduler: users _love_ determinism. (Users
> >    dont typically care whether a click on the desktop takes 0.5 seconds
> >    or 1.0 second - as long as it's always 0.5 or always 1.0. What they
> >    do notice is when a click takes 0.5 seconds most of the time but
> >    occasionally it takes 1.5 seconds - _that_ they report as a
> >    regression. They would actually prefer it to take 1.0 seconds all the
> >    time. The reason is human psychology: 99% of our daily routine is
> >    driven by inconscious brain automatisms. We auto-pilot through most
> >    of the day - and that very much covers routine computer/desktop usage
> >    too. Unpredictable/noisy behavior of the computer forces the human
> >    brain back into more consious activity, which is perceived as a
> >    negative thing: it's a distraction takes capacity away from
> >    _important_ conscious activities ... such as getting real work done
> >    on the computer.)
> >
> >    Heuristics is also an objective problem for the code itself: it
> >    introduces artificial coupling of workloads and raises complexity
> >    artificially: it makes it very hard to prove the impact of changes
> >    (even with good instrumentation) - thus increasing the barrier of
> >    entry significantly. (both to external contributors and to existing
> >    maintainers)
> >
> > all in one: the barrier of entry to _providing meaningful feedback_ is
> > often very high, and thus the barrier of entry of experimental patches
> > is too high too. These two factors are a lethal combination that lure us
> > into the false perception that everything is fine and that the yelling
> > out there is just from clueless whiners who are not willing to help us
> >
> > :-/
> >
> > Yes, MM testing is hard (in fact, good MM instrumentation and tooling is
> > _very_ hard), and the MM is in a pretty good shape (otherwise an
> > alternative would have shown up already), and today's MM is clearly the
> > best ever Linux MM - but still we have to solve these structural
> > problems if we want to advance to the next level of quality.
> >
> > The solution? I think it's not that hard: we should lower the acceptance
> > barrier of instrumentation patches massively. (maybe even merge them
> > outside the normal merge window, like we merge cleanups) Then we should
> > only allow high-rate changes in risky kernel subsystems that improve
> > their own instrumentation and tools sufficiently for ordinary users to
> > be able to tell whether the changes are an improvement or not. Every
> > time there's a major regression that was hard to debug via the existing
> > instrumentation, mandate the extension of instrumentation to cover that
> > case too.
> >
> > This all couples the desire of developers to add new code with the
> > desire of testers to provide feedback and with the desire of actual
> > users to have a proven good system.
>
> I totally agree with Ingo here. Having a basic instrumentation that is
> enabled by default will help to identify code paths causing unexpected
> delays in the kernel. It will not only identify kernel bugs, but also
> unexpected behaviors that would be qualified as "quiet bugs" (e.g. long
> delays).

It is. See: CONFIG_VM_EVENT_COUNTERS and all the other vm specific
crap littered in /proc/ (buddyinfo, zoneinfo, meminfo, etc).

There is always an issue of sometimes not instrumenting enough basic
things... but we fundamentally have always tried to do improve this.

vm is one of the most instrumented subsystems in the kernel. By default.


> The key aspect that seems to be inherent to this proposal is the need
> for an extensible instrumentation mechanism that would allow developers
> to add new instrumentation when it is needed (such as the Linux Kernel
> Markers on which I have been working for the last year). It will enable
> them, and testers, to test and benchmark kernel subsystems to detect
> regressions as well as erratic behaviors.

We have several for the VM.


> When a problem such as this VM delay is found, we should really be able
> to ask ourselves : "what instrumentation (and tests) can we add to
> detect this class of problem automatically in the future ?".

We can and do (Andrew did, in this case).
