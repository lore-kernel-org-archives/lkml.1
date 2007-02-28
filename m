Return-Path: <linux-kernel-owner+w=401wt.eu-S1751493AbXB1EVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbXB1EVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 23:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXB1EVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 23:21:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:37983 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750842AbXB1EVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 23:21:43 -0500
X-Provags-ID: V01U2FsdGVkX1/iVEIk+O7iYCjFb0+xVAQCA6DH1tR8UOgFFRzZ9x
	ouqw==
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200702281007.16316.kernel@kolivas.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <20070227083349.GB30376@elte.hu>
	 <1172566453.7009.28.camel@Homer.simpson.net>
	 <200702281007.16316.kernel@kolivas.org>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 05:21:39 +0100
Message-Id: <1172636499.6534.101.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(hrmph.  having to copy/paste/try again.  evolution seems to be broken..
RCPT TO <linux-kernel@vg.kolivas.org> failed: Cannot resolve your domain {mp049}
..caused me to be unable to send despite receipts being disabled)

On Wed, 2007-02-28 at 09:58 +1100, Con Kolivas wrote:
> On Tuesday 27 February 2007 19:54, Mike Galbraith wrote:

> > Agreed.
> >
> > I was recently looking at that spot because I found that niced tasks
> > were taking latency hits, and disabled it, which helped a bunch.
> 
> Ok... as I said above to Ingo, nice means more latency too, and there is no 
> doubt that if we disable nice as a working feature then the niced tasks will 
> have less latency. Of course, this ends up meaning that un-niced tasks no 
> longer receive their better cpu performance..  You're basically saying that 
> you prefer nice not to work in the setting of HT.

No I'm not, but let's go further in that direction just for the sake of
argument.  You're then saying that you prefer realtime priorities to not
work in the HT setting, given that realtime tasks don't participate in
the 'single stream me' program.
 
I'm saying only that we're defeating the purpose of HT, and overriding a
user decision every time we force a sibling idle.

> > I also 
> > can't understand why it would be OK to interleave a normal task with an
> > RT task sometimes, but not others.. that's meaningless to the RT task.
> 
> Clearly there would be a reason that code is there... The whole problem with 
> HT is that as soon as you load up a sibling, you slow down the logical 
> sibling, hence why this code is there in the first place. Since I know you're 
> one to test things for yourself, I will put it to you this way:
> 
> Boot into UP. Time how long it takes to do a million of these in a real time 
> task:
>  asm volatile("" : : : "memory");
> 
> Then start up a SCHED_NORMAL task fully cpu bound such as "yes > /dev/null" 
> and time that again. Obviously the former being a realtime task will take the 
> same amount of time and the SCHED_NORMAL task will be starved until the 
> realtime task finishes.

Sure.

> Now try the same experiment with hyperthreading enabled and an ordinary SMP 
> kernel. You'll find the realtime task runs at only ~60% performance.

So?  User asked for HT.  That's hardware multiplexing. It ain't free.
Buyer beware.

>  That's a 
> serious performance hit for realtime tasks considering you're running a 
> SCHED_NORMAL task. The SMT code that you seem to dislike fixes this problem.

I don't think it does actually. Let your RT task sleep regularly, and
ever so briefly.  We don't evict lower priority tasks from siblings upon
wakeup, we only prevent entry... sometimes.
 
> The reason for interleaving is that there are a few cycles to be gained by 
> using the second core for a separate SCHED_NORMAL task, and you don't want to 
> disable access to the second core entirely for the duration the realtime task 
> is running. Since there is no simple relationship between SCHED_NORMAL 
> timeslices and realtime timeslices, we have to use some form of interleaving 
> based on the expected extra cycles and HZ is the obvious choice.

To me, the reason for interleaving is solely about keeping the core
busy .  It has nothing to do with SCHED_POLICY_X what so ever.

> > IMHO, SMT scheduling should be a buyer beware thing.  Maximizing your
> > core utilization comes at a price, but so does disabling it, so I think
> > letting the user decide what he wants is the right thing to do.
> 
> To me this is like arguing that we should not implement 'nice' within the cpu 
> scheduler at all and only allow nice to work on the few architectures that 
> support hardware priorities in the cpu (like power5). Now there is no doubt 
> that if we do away with nice entirely everywhere in the scheduler we'll gain 
> some throughput. However, nice is a basic unix/linux function and if hardware 
> comes along that breaks it working we should be working to make sure that it 
> keeps working in software. That is why smt nice and smp nice was implemented. 
> Of course it is our duty to ensure we do that at minimal overhead at all 
> times. That's a different argument to what you are debating here. The 
> throughput should not be adversely affected by this SMT priority code because 
> although the nice 19 task gets less throughput, the higher priority task gets 
> more as a result, which is essentially what nice is meant to do.

Re-read this paragraph with realtime task priorities in mind, or for
that matter, dynamic priorities.  If you carry your priority/throughput
argument to it's logical conclusion, only instruction streams of
absolutely equal priority should be able to share the core at any given
time.  You may as well just disable HT and be done with it.

To me, siblings are logically separate units, and should be treated as
such (as they mostly are).  They share an important resource, but so do
physically discrete units.

	-Mike


