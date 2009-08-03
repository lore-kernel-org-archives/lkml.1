Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbZHCQbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbZHCQbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZHCQbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:31:08 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:52547 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbZHCQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:31:06 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz62a3L1432R98dN936eM1442J14e1Izz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNT77E-03-TPG-01
Date: Mon, 3 Aug 2009 18:30:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20090803163048.GT14610@erda.amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com> <20090803112220.GA22936@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090803112220.GA22936@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Aug 2009 16:30:50.0089 (UTC) FILETIME=[C3116D90:01CA1457]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.08.09 13:22:20, Ingo Molnar wrote:
> Ok. The oprofile patches have been going upstream via -tip and i've
> been pulling and testing/relaying them for upstream for more than a
> year with pretty good results.
> 
> Now i'm also co-maintaining perfcounters and because it's a full 
> oprofile replacement (which aspect Robert seems to disagree with ;-) 

I can't imagine a full oprofile replacement. This would require a
rewrite of all userland tools and also the complete port of all
architectures (which has to be done for each architecture
individually). And first of all, I don't think it is necessary to do
this, why not keep different interfaces for different purposes? Why
reimplement architectural code if the current implementation fits its
need? We should reduce duplicate implementations such as hardware
drivers, especially for x86 (I remember implementing the same pmu
feature for three kinds of kernel profiling subsystems). And of
course, future hardware implementations should support a generic
perfcounter abstraction to only have a single implementation for all.

> i'd like to make sure it's not seen by Robert as a conflict of 
> interest so let me raise the following questions publicly:
> 
> This new oprofile multiplexing mechanism really overlaps the PMU 
> abstractions that perfcounters already provide, and i disagree with 
> this general direction. The code you wrote is clean though so i've 
> (reluctantly) pulled it into tip:oprofile and started testing it, 
> and will send it Linus-wards in the .32 merge window - unless Linus 
> agrees with my general objections against this oprofile direction.

I do not see this patch set as a step away from perfcounters, instead
it is going towards perfcounters. Since it implements a feature for
oprofile that is already available for perfcounters. This will make
migration easier. Also, this multiplexing implementation is mainly an
extension of the oprofile user/kernel i/f. I don't see much
overlapping code with perfcounters.

When talking about migration: I also would like to see one single pmu
abstraction in the kernel and I already was thinking about the best
way to do this. The current oprofile implementation does not allow an
easy transition, since the internal data representation is very
different to perfcounters and code is very model specific (x86). First
there must be implemented a single generic abstraction layer including
all models, then hardware access can be changed to use a perfcounter
in-kernel api. In the end there would be one implementation for both
profiling subsystems. I already started to rework oprofile with my
recent update patch set for v2.6.32 and I already provided updates
also for perfcounters.

The transition to perfcounters is not easy to make. There are many
changes that can break much. Switching directly to perfcounters for
multiplexing would have delayed the feature for oprofile for months,
which is not acceptable for oprofile users. There would have been a
higher risk having a reimplementation together with a feature
implementation. So doing step by step is much more safe.

Perfcounters were merged for v2.6.31 in June, so less than 2 months
ago. A long time it was not clear if and when it will go into the
kernel. Still it has to be proved for production and stable usage. You
can't expect that ongoing feature development for oprofile is stopped
immediately and all efforts promptly are moved to perfcounters.

Overall, I don't see oprofile going away from perfcounters, there will
be a migration. This patch set simply documents ongoing development
for oprofile in parallel of perfcounters. Stopping this is not an
option, it is in the kernel for years and there are users that can
expect ongoing support and feature extension for oprofile.

> 
> The reason for my disagreement is on the technical and on the policy 
> level.
> 
> Here's the (rough) support comparison matrix:
> 
>                               perfcounters |         oprofile-mux
>                        ..........................................
>    granularity:        per task or per cpu |              per cpu
>                                            .
>    switch mechanism:             interrupt |            workqueue
>                                            .
>    limits:                 soft, unlimited |      hardcoded to 32
>                                            .
>    arch support:              generic, all |  AMD only, needs per
>                         perfcounter arches | cpu and arch changes
> 
> The perfcounters multiplexing is visibly more mature and more
> capable: more generic, integrated into the scheduler, not hardcoded,
> etc.
> 
> And the oprofile bits are for x86 (AMD) only, with every oprofile 
> architecture having to do similarly invasive changes - so these 500 
> lines of changes probably get multipled by a factor of 10 or so in 
> the end, years down the line. A lot of work and i think it can and 
> should all be avoided.
> 
> So there are two technical/policy questions:
> 
> Would it be fair to require oprofile to implement a similarly
> high-quality counter virtualization as perfcounters? If yes then i
> think the end result would be oprofile based on perfcounters: i.e.
> this particular oprofile-mux patchset becomes largely moot and we'd
> not have to go through the (non-trivial) transition period of
> updating every single oprofile driver for multiplexing.

Oprofile will base on perfcounters, but porting oprofile to
perfcounters should be done separately and not delay oprofile feature
development. As soon as oprofile uses a perfcounter api for counter
setup there will be only a single implementation. But until then it is
a long way to go.

> 
> The other question is: do we really want to have a constant
> distraction via the overlapping oprofile space? I think a feasible
> and sane looking approach would be to:
> 
>  - Put oprofile into maintenance mode, fix all bugs that get
>    reported/found, perhaps add new hw enablement drivers in the
>    existing scheme (if they are submitted) but otherwise dont
>    complicate the code any more.
> 
>  - Extend PMU and performance instrumentation support via
>    perfcounters primarily.

In my opinion it is too early for both. As said, perfcounters are out
less than 2 months. We can consider this later approach when an
in-kernel perfcounters api is in sight and oprofile is using
perfcounters. At least ongoing development shouldn't be stopped.

> 
>  - Possibly base oprofile user-space on perfcounters syscalls
>    (with a fall-back to old oprofile syscalls on older kernels),
>    if there's interest from folks who want the oprofile tool-chain,
>    allowing the removal of the oprofile kernel code in the long run.

This looks very intrusive. Tools base on the user/kernel i/f that is
mainly controlled with oprofilefs. I don't see many options to change
this. And as said, it is not necessary.

> 
> This series of steps seems to be the technically sanest approach to
> me, and we are certainly willing to extend perfcounters in any
> fashion to allow a fuller replacement for oprofile. (we already
> think it's a worthy replacement and more - but we are open to all
> enhancements.)
> 
> I'd not be against maintaining the code in its current form, but i'm
> not sure whether we should extend the core oprofile code itself with
> things like the multiplexing code above which is seriously
> non-trivial and splits both developer attention and testing efforts.
> 
> Linus, Peter, Paul, do you have any preferences? I'm really on two
> minds about whether to do this oprofile feature. The overlap of this
> patch-set with perfcounters is serious, the induced complexity is
> serious and the ongoing maintenance cost is non-trivial.
> 
> Since PMU developers is a more or less constant pool of people, 
> these policy issues do matter IMO and affect perfcounters as well 
> indirectly, not just oprofile. Hardware vendors generally want to 
> enable all facilities that are in the kernel, regardless of which 
> one we consider to be the best one. So by forcing development of a 
> new oprofile driver variant, resources are taken away from 
> perfcounters.
> 
> It's as if we continued maintaining and developing ipchains after 
> iptables was merged upstream. Instead we used compatibility 
> mechanisms and phased out ipchains rather gracefully. Robert is 
> apparently of the opinion that oprofile needs to be developed 
> further - hence these questions.
> 
> So on those grounds i'm (mildly) inclined to not do this and suggest 
> that we work on achieving the same end result via other means: via 
> the perfcounters enabling of oprofile userspace.
> 
> But if Linus/Peter/Paul thinks that pulling it was the right 
> solution then i'll keep the bits - i wanted to have a public 
> discussion of these questions first.

I do not agree to stop oprofile development from one day to the
other. As you, I also want to have one single pmu implementation in
the kernel and we have to avoid writing duplicate code and having
duplicate development efforts. But, a transition of oprofile to use
perfcounters is not trivial and should be smooth. Mixing this
transition with a feature implementation is also not a good idea. So
lets narrow each other from both sides. Moving oprofile towards
perfcounters and vice versa.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

