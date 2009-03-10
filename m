Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZCJMuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZCJMuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZCJMuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:50:04 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:36561 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752294AbZCJMuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:50:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X2yM5b8GRwFVbDr5ZB34c6BdsE8e0EHzz+qp4suAjd8/VJ4oWgzLNsB1CARRwLO5K3dFn8ym7U409+2Q6nC1KCZV65dTtlrG/XEUDDZFxo9XBgtxPsJje/ZCjcVB9UoAqwrov88gTzBv1i7OqjZQoNDLL5B1UzKKrwVJ8DNeAZ4=  ;
X-YMail-OSG: PWqdvggVM1kvl5hlnNa6WlDhC.qC5xsNhQEx6ttKAiLQsUU849DT9VM9P7XJwKOg50uT8NXLpSTAfFd86MuTQZn5dob8uZX7zHL4yL89AAQL7z3CsNQcbaeS55fqbJyrLDelDCoLzjrVfTeA4jm6Gg2hQtKiqC_750RDmauKLWnoxwcoG_F.504vRwfP014baPyn0f7sOPqzZ9qvVNQeK3b03V1HHA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: core dom0 support
Date: Tue, 10 Mar 2009 23:49:52 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090308221208.GA24079@elte.hu> <49B55AB0.1070605@goop.org>
In-Reply-To: <49B55AB0.1070605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903102349.53343.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 March 2009 05:06:40 Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> >> Ingo Molnar wrote:
> >>> Since it's the same kernel image i think the only truly reliable
> >>> method would be to reboot between _different_ kernel images:
> >>> same instructions but randomly re-align variables both in terms
> >>> of absolute address and in terms of relative position to each
> >>> other. Plus randomize bootmem allocs and never-gets-freed-really
> >>> boot-time allocations.
> >>>
> >>> Really hard to do i think ...
> >>
> >> Ouch, yeah.
> >>
> >> On the other hand, the numbers made sense to me, so I don't
> >> see why there is any reason to distrust them.  They show a 5%
> >> overhead with pv_ops enabled, reduced to a 2% overhead with
> >> the changed.  That is more or less what would match my
> >> intuition from seeing the code.
> >
> > Yeah - it was Jeremy expressed doubt in the numbers, not me.
>
> Mainly because I was seeing the instruction and cycle counts completely
> unchanged from run to run, which is implausible.  They're not zero, so
> they're clearly measurements of *something*, but not cycles and
> instructions, since we know that they're changing.  So what are they
> measurements of?  And if they're not what they claim, are the other
> numbers more meaningful?
>
> It's easy to read the numbers as confirmations of preconceived
> expectations of the outcomes, but that's - as I said - unsatisfying.
>
> > And we need to eliminate that 2% as well - 2% is still an awful
> > lot of native kernel overhead from a kernel feature that 95%+ of
> > users do not make any use of.
>
> Well, I think there's a few points here:
>
>    1. the test in question is a bit vague about kernel and user
>       measurements.  I assume the stuff coming from perfcounters is
>       kernel-only state, but the elapsed time includes the usermode
>       component, and so will be affected by the usermode page placement
>       and cache effects.  If I change the test to copy the test
>       executable (statically linked, to avoid libraries), then that
>       should at least fuzz out user page placement.
>    2. Its true that the cache effects could be due to the precise layout
>       of the kernel executable; but if those effects are swamping
>       effects of the changes to improve pvops then its unclear what the
>       point of the exercise is.  Especially since:
>    3. It is a config option, so if someone is sensitive to the
>       performance hit and it gives them no useful functionality to
>       offset it, then it can be disabled.  Distros tend to enable it
>       because they tend to value function and flexibility over raw
>       performance; they tend to enable things like audit, selinux,
>       modules which all have performance hits of a similar scale (of
>       course, you could argue that more people get benefit from those
>       features to offset their costs).  But,
>    4. I think you're underestimating the number of people who get
>       benefit from pvops; the Xen userbase is actually pretty large, and
>       KVM will use pvops hooks when available to improve Linux-as-guest.
>    5. Also, we're looking at a single benchmark with no obvious
>       relevance to a real workload.  Perhaps there are workloads which
>       continuously mash mmap/munmap/mremap(!), but I think they're
>       fairly rare.  Such a benchmark is useful for tuning specific
>       areas, but if we're going to evaluate pvops overhead, it would be
>       nice to use something a bit broader to base our measurements on.
>       Also, what weighting are we going to put on 32 vs 64 bit?  Equally
>       important?  One more than the other?

I saw _most_ of the extra overhead show up in page fault path. And also
don't forget that fork/exit workloads are essentially mashing mmap/munmap.

So things which mash these paths include kbuild, scripts, and some malloc
patters (like you might see in MySQL running OLTP).

Of course they tend to do more other stuff as well, so 2% in a
microbenchmark will be much smaller, but that was never in dispute. One
hardest problems is adding lots of features to critical paths that
individually "never show a statistical difference on any real workload",
but combine to slow things down. It really sucks to have people upgrade
and performance go down.

As an anecdote, I had a problem where an ISV upgraded SLES9 to SLES10
and their software's performance dropped 30% or so. And there were like
3 or 4 things that could be bisected to show a few % of that. This was
without pvops mind you, but in very similar paths (mmap/munmap/page
fault/teardown). The pvops stuff was basically just an extension of that
saga.

OK, that's probably an extreme case, but any of this stuff must always
be considered a critical fastpath IMO. We know any slowdown is going to
hurt in the long run.


> All that said, I would like to get the pvops overhead down to
> unmeasureable - the ideal would be to be able to justify removing the
> config option altogether and leave it always enabled.
>
> The tradeoff, as always, is how much other complexity are we willing to
> stand to get there?  The addition of a new calling convention is already
> fairly esoteric, but so far it has got us a 60% reduction in overhead
> (in this test).  But going further is going to get more complex.

If the complexity is not in generic code and constrained within pvops
stuff, then from my POV "as much as it takes", and you get to maintain
it ;)

Well, that's a bit unfair. From a distro POV, I'd love that to be the
case because we ship pvops. From a kernel.org point of view, you provide
a service that inevitably will have some cost but can be configured out.
But I do think that it would be in your interest too because the speed
of these paths should be important even for virtualised systems.


> For example, the next step would be to attack set_pte (including
> set_pte_*, pte_clear, etc), to make them use the new calling convention,
> and possibly make them inlineable (ie, to get it as close as possible to
> the non-pvops case).  But that will require them to be implemented in
> asm (to guarantee that they only use the registers they're allowed to
> use), and we already have 3 variants of each for the different pagetable
> modes.  All completely doable, and not even very hard, but it will be
> just one more thing to maintain - we just need to be sure the payoff is
> worth it.

Thanks for what you've done so far. I would like to see this taken as
far as possible. I think it is very worthwhile although complexity is
obviously a very real concern too.

