Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXB1WDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXB1WDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXB1WDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:03:51 -0500
Received: from mail30.syd.optusnet.com.au ([211.29.133.193]:42774 "EHLO
	mail30.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932493AbXB1WDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:03:50 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Date: Thu, 1 Mar 2007 09:01:41 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200702281007.16316.kernel@kolivas.org> <1172636499.6534.101.camel@Homer.simpson.net>
In-Reply-To: <1172636499.6534.101.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703010901.41715.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 February 2007 15:21, Mike Galbraith wrote:
> (hrmph.  having to copy/paste/try again.  evolution seems to be broken..
> RCPT TO <linux-kernel@vg.kolivas.org> failed: Cannot resolve your domain
> {mp049} ..caused me to be unable to send despite receipts being disabled)

Apologies for mangling the email address as I said :-(

> On Wed, 2007-02-28 at 09:58 +1100, Con Kolivas wrote:
> > On Tuesday 27 February 2007 19:54, Mike Galbraith wrote:
> > > Agreed.
> > >
> > > I was recently looking at that spot because I found that niced tasks
> > > were taking latency hits, and disabled it, which helped a bunch.
> >
> > Ok... as I said above to Ingo, nice means more latency too, and there is
> > no doubt that if we disable nice as a working feature then the niced
> > tasks will have less latency. Of course, this ends up meaning that
> > un-niced tasks no longer receive their better cpu performance..  You're
> > basically saying that you prefer nice not to work in the setting of HT.
>
> No I'm not, but let's go further in that direction just for the sake of
> argument.  You're then saying that you prefer realtime priorities to not
> work in the HT setting, given that realtime tasks don't participate in
> the 'single stream me' program.

Where do I say that? I do not presume to manage realtime priorities in any 
way. You're turning my argument about nice levels around and somehow saying 
that because hyperthreading breaks the single stream me semantics by 
parallelising them that I would want to stop that happening. Nowhere have I 
argued that realtime semantics should be changed to somehow work around 
hyperthreading. SMT nice is about managing nice only, and not realtime 
priorities which are independent entities.

> I'm saying only that we're defeating the purpose of HT, and overriding a
> user decision every time we force a sibling idle.
>
> > > I also
> > > can't understand why it would be OK to interleave a normal task with an
> > > RT task sometimes, but not others.. that's meaningless to the RT task.
> >
> > Clearly there would be a reason that code is there... The whole problem
> > with HT is that as soon as you load up a sibling, you slow down the
> > logical sibling, hence why this code is there in the first place. Since I
> > know you're one to test things for yourself, I will put it to you this
> > way:
> >
> > Boot into UP. Time how long it takes to do a million of these in a real
> > time task:
> >  asm volatile("" : : : "memory");
> >
> > Then start up a SCHED_NORMAL task fully cpu bound such as "yes >
> > /dev/null" and time that again. Obviously the former being a realtime
> > task will take the same amount of time and the SCHED_NORMAL task will be
> > starved until the realtime task finishes.
>
> Sure.
>
> > Now try the same experiment with hyperthreading enabled and an ordinary
> > SMP kernel. You'll find the realtime task runs at only ~60% performance.
>
> So?  User asked for HT.  That's hardware multiplexing. It ain't free.
> Buyer beware.

But the buyer is not aware. You are aware because you tinker, but the vast 
majority of users who enable hyperthreading in their shiny pcs are not aware. 
The only thing they know is that if they enable hyperthreading their programs 
run slower in multitasking environments no matter how much they nice the 
other processes. Buyers do not buy hardware knowing that the internal design 
breaks something as fundamental as 'nice'. You seem to presume that most 
people who get hyperthreading are happy to compromise 'nice' in order to get 
their second core working and I put it to you that they do not make that 
decision.

> >  That's a
> > serious performance hit for realtime tasks considering you're running a
> > SCHED_NORMAL task. The SMT code that you seem to dislike fixes this
> > problem.
>
> I don't think it does actually. Let your RT task sleep regularly, and
> ever so briefly.  We don't evict lower priority tasks from siblings upon
> wakeup, we only prevent entry... sometimes.

Well you know as well as I do that you're selecting out the exception rather 
than the rule, and statistically overall, it does work.

> > The reason for interleaving is that there are a few cycles to be gained
> > by using the second core for a separate SCHED_NORMAL task, and you don't
> > want to disable access to the second core entirely for the duration the
> > realtime task is running. Since there is no simple relationship between
> > SCHED_NORMAL timeslices and realtime timeslices, we have to use some form
> > of interleaving based on the expected extra cycles and HZ is the obvious
> > choice.
>
> To me, the reason for interleaving is solely about keeping the core
> busy .  It has nothing to do with SCHED_POLICY_X what so ever.
>
> > > IMHO, SMT scheduling should be a buyer beware thing.  Maximizing your
> > > core utilization comes at a price, but so does disabling it, so I think
> > > letting the user decide what he wants is the right thing to do.
> >
> > To me this is like arguing that we should not implement 'nice' within the
> > cpu scheduler at all and only allow nice to work on the few architectures
> > that support hardware priorities in the cpu (like power5). Now there is
> > no doubt that if we do away with nice entirely everywhere in the
> > scheduler we'll gain some throughput. However, nice is a basic unix/linux
> > function and if hardware comes along that breaks it working we should be
> > working to make sure that it keeps working in software. That is why smt
> > nice and smp nice was implemented. Of course it is our duty to ensure we
> > do that at minimal overhead at all times. That's a different argument to
> > what you are debating here. The throughput should not be adversely
> > affected by this SMT priority code because although the nice 19 task gets
> > less throughput, the higher priority task gets more as a result, which is
> > essentially what nice is meant to do.
>
> Re-read this paragraph with realtime task priorities in mind, or for
> that matter, dynamic priorities.  If you carry your priority/throughput
> argument to it's logical conclusion, only instruction streams of
> absolutely equal priority should be able to share the core at any given
> time.  You may as well just disable HT and be done with it.

Well that's certainly taking my logic for a ride. This is about managing 
_nice_ and _only_ nice. Nice specifies fixed interval static priorities where 
(in the risk of repeating myself) you are specifying that higher nice values 
tasks you wish to receive less cpu and more latency. Dynamic priorities have 
absolutely no effect on what the discrepancies are between the static 
priorities of differing nice values. As for realtime priorities, again, I do 
not presume to be managing them with SMT nice. They are unique entities 
unrelated to nice values. The only thing they have in common with nice levels 
is that if something is running without a realtime priority, it should be 
preempted by the realtime task as you have specified that the realtime task 
should receive all the cpu over the non-realtime task. I don't pretend that 
there is some cpu percentage relationship between different _realtime 
priorities_ and do not try to manage them in any way.

> To me, siblings are logically separate units, and should be treated as
> such (as they mostly are).  They share an important resource, but so do
> physically discrete units.

Again you're saying here that if the hardware breaks nice levels we should not 
bother trying to enforce them. As I said before, this is an extension of 
arguing that we should not try to enforce nice except on hardware that has 
priority support within the cpu.

We're going to have to agree to disagree, but feel free to have the final word 
of course.

--
-ck
--

'In general this practice is meant to exhaust the opposition in some debate, 
and when they fail to respond, claim the silence as assent, to prevent 
an "unfavorable" conclusion of a debate from being reached by refusing to 
allow the discussion to conclude so long as its conclusion is unfavorable, 
and to discourage future "challenges".' -wli
