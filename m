Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbXI1PbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbXI1PbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbXI1PbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:31:14 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:23719 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755998AbXI1PbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:31:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=VGWvDPlVspI4Wgey/ykZsmXguEokSk3DTffYbbsINwxCl166l97OgASwaeTPpkNc4o41mqHL6TjApd/jgePUtrzvEyN1VGqxOuGJqGZuxEwibwucx+7tH/B9TcjSPMOZ0UA9Vl0BwL9fvkbCo2DgdUgdseT9zHBjo0lbasv8SLA=  ;
X-YMail-OSG: P5JiSyUVM1lHEdMZXBgMtAcQbYzNJOa3h1ES.MGrwhhcAHxPLQlm.c6_Jr1saEK2WXbZHwkoPg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] writeback: remove unnecessary wait in throttle_vm_writeout()
Date: Fri, 28 Sep 2007 08:59:42 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, hirofumi@mail.parknet.co.jp,
       galak@kernel.crashing.org, zaitcev@redhat.com, greg@kroah.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <390857819.00313@ustc.edu.cn> <20070927134726.ac39b55f.akpm@linux-foundation.org> <20070928080202.GA10293@elte.hu>
In-Reply-To: <20070928080202.GA10293@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709280859.42886.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 18:02, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> > This is a pretty major bugfix.
> >
> > GFP_NOIO and GFP_NOFS callers should have been spending really large
> > amounts of time stuck in that sleep.
> >
> > I wonder why nobody noticed this happening.  Either a) it turns out
> > that kswapd is doing a good job and such callers don't do direct
> > reclaim much or b) nobody is doing any in-depth kernel
> > instrumentation.
>
> [ Oh, it's Friday already, so soapbox time i guess. The easily offended
>   please skip this mail ;-) ]

I'll join you on your soapbox ;)


> People _have_ noticed, and we often ignored them. I can see four

This is a problem with the testers. The barrier for *reporting* problems
is really low. And if they're regressions, then it is almost 100% chance of
being solved. If we're simply missing the bug reports, I'll again ask for a
linux-bugs list which is clear of other crap.

Or are people scared of reporting regressions from previous experience?
I haven't seen any reason for this and linux-mm is probably one of the
most polite lists I have read (when it comes to interacting with non
developers, anyway ;)).


> fundamental, structural problems:
>
> 1) A certain lack of competitive pressure. An MM is too complex and
>    there is no "better Linux MM" to compare against objectively. The
>    BSDs are way too different and it's easy to dismiss even objective
>    comparisons due to the real complexity of the differences. Heck,
>    2.6.9 is "way too different" and we routinely reject bugreports from
>    such old kernels and lose vital feedback.

I don't see this as a big problem. The "better Linux MM" is implemented
by the patch one is proposing -- whether it be a one liner bugfix, or a
complete rewrite. I think it _would_ be really nice to run all interesting
workloads on various Linux 26 and 24 kernels, various patchsets, and
other open source OSes for the regression testing and cross polination
aspects... however this brings us to the main problem:

Devising useful tests and metrics, and running them.


> 2) There is a wide-spread mentality of "you prove that there is a
>    problem" in the MM and elsewhere in the Linux kernel too. While of

The alternative is completely unscientific chaos. OK, for performance
heuristics, it is actually a much grayer "you show that your patch
improves something / doesn't harm others" -- this is pretty tough for
mm patches at the moment, maybe it could be better but at the end
of the day, if something is worth merging then we should be able to
actually prove (or have a pretty high confidence) that it is good. If not,
then we don't want to merge it, by definition.

In the case of the vm, this comes right back to the difficulty of getting a
range of meaningful tests. We can definitely improve this situation a
great deal, but like the scheduler, the *real* "tests" simply have to be
done by users. And unfortunately, a lot of them don't actually test VM
changes for a long time after they're merged. This would actually be one
area where it might make a lot of sense to coordinate more significant
VM changes with distro release cycles (maybe?)


>    course objective proof is paramount, we often "hide" behind our
>    self-created complexity of the system (without malice and without
>    realising it!). We've seen that happen in the updatedb discussions
>    and the swap-prefetch discussions. The correct approach would be for
>    the MM folks to be able to tell for just about any workload "this is
>    not our problem", and to have the benefit of the doubt _on the
>    tester's side_. We must not ignore people who tell us that "there is
>    something wrong going on here", just because they are unable to
>    analyze it themselves. Very often where we end up saying "we dont
>    know what's going on here" it's likely _our_ fault. We also must not
>    hide behind "please do these 10 easy steps and 2 kernel recompiles
>    and 10 reboots, only takes half a day, and come back to us once you
>    have the detailed debug data" requests. Instrumentation must be _on
>    by default_ (like SCHED_DEBUG is on by default), which brings us to:

The recent swap prefetch debate showed exactly how the process _should_
work. We discovered a serious issue with metadata caching behaviour, and
also the active-inactive list balancing change that makes use-once much
less effective.

It was discovered by the metrics that are already there and compiled in,
and basically required a cat /proc/vmstat ; run-workload ; cat /proc/vmstat

[ You understand why I wanted to explore any possible underlying problems
independent of swap prefetch, right? If you'd just happened to be running on
a laptop, or your pagecache / buffercache / slab cache just happened to be
full of useless crap already (as in: something that updatedb might cause), or
your morning workload happened to fault in a lot of mmap()ed data, then
swap prefetch suddenly doesn't help you. ]



> 3) Instrumentation and tools. Instrumentation (for example MM delay
>    statistics - like the scheduler delay statistics) give an objective
>    measure to compare kernels against each other. _Smart_ and _easy to
>    use_ and _default enabled_ instrumentation is a must. Not "turn on
>    these 3 zillion kernel options" which no distro enables. Debug
>    tools/scripts that use the instrumentation, that just have to be run
>    and produce meaningful output based on which 90% of the workloads can
>    be analyzed _without having to ask the user to do more_. (See
>    PowerTop as an example, the right kind of instrumentation can do
>    wonders that enables users to help us. We worked hard to lower the
>    cost of /proc/timer_stats so that distros can enable it by default -
>    and now they do enable it by default.)

There are a lot of useful stats compiled in already. There are some
significant useful metrics which are not there, but could help. I don't know
if it is anything fundamental that we're doing wrong, though.

As you say, VM state machine is a lot more complex than scheduler. I
don't think it is reasonable to expect to be able to solve all problems 
bylooking at exported stats. But so far in 2.6 development, they have often
been enough to narrow things down pretty well. And where they haven't been,
I (and others) have added useful metrics where possible (witness the
evolution of oom killer output!)

But your soapbox is helpful to emphasise that we need to be thorough
with adding and using instrumentation when debugging a problem or
introducing some new behaviour / changing old behaviour.
