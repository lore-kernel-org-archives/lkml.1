Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbXCAFb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbXCAFb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 00:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932650AbXCAFb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 00:31:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:36422 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932654AbXCAFb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 00:31:58 -0500
X-Provags-ID: V01U2FsdGVkX19pj+krm5Zpu3Af5awDPEG5azYa7wammKYKbfmUzO
	LBpQ==
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200703010901.41715.kernel@kolivas.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <200702281007.16316.kernel@kolivas.org>
	 <1172636499.6534.101.camel@Homer.simpson.net>
	 <200703010901.41715.kernel@kolivas.org>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 01:02:21 +0100
Message-Id: <1172707341.7027.95.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 09:01 +1100, Con Kolivas wrote:
> On Wednesday 28 February 2007 15:21, Mike Galbraith wrote:

> > On Wed, 2007-02-28 at 09:58 +1100, Con Kolivas wrote:
> > > On Tuesday 27 February 2007 19:54, Mike Galbraith wrote:
> > > > Agreed.
> > > >
> > > > I was recently looking at that spot because I found that niced tasks
> > > > were taking latency hits, and disabled it, which helped a bunch.
> > >
> > > Ok... as I said above to Ingo, nice means more latency too, and there is
> > > no doubt that if we disable nice as a working feature then the niced
> > > tasks will have less latency. Of course, this ends up meaning that
> > > un-niced tasks no longer receive their better cpu performance..  You're
> > > basically saying that you prefer nice not to work in the setting of HT.
> >
> > No I'm not, but let's go further in that direction just for the sake of
> > argument.  You're then saying that you prefer realtime priorities to not
> > work in the HT setting, given that realtime tasks don't participate in
> > the 'single stream me' program.
> 
> Where do I say that? I do not presume to manage realtime priorities in any 
> way. You're turning my argument about nice levels around and somehow saying 
> that because hyperthreading breaks the single stream me semantics by 
> parallelising them that I would want to stop that happening. Nowhere have I 
> argued that realtime semantics should be changed to somehow work around 
> hyperthreading. SMT nice is about managing nice only, and not realtime 
> priorities which are independent entities.

I see no real difference between the two assertions.  Nice is just a
mechanism to set priority, so I applied your assertion to a different
range of priorities than nice covers, and returned it to show that the
code contradicts itself.  It can't be bad for a nice 1 task to run with
a nice 0 task, but OK for a minimum RT task to run with a maximum RT
task.  Iff HT without corrective measures breaks nice, then it breaks
realtime priorities as well.

> > I'm saying only that we're defeating the purpose of HT, and overriding a
> > user decision every time we force a sibling idle.
> >
> > > > I also
> > > > can't understand why it would be OK to interleave a normal task with an
> > > > RT task sometimes, but not others.. that's meaningless to the RT task.
> > >
> > > Clearly there would be a reason that code is there... The whole problem
> > > with HT is that as soon as you load up a sibling, you slow down the
> > > logical sibling, hence why this code is there in the first place. Since I
> > > know you're one to test things for yourself, I will put it to you this
> > > way:
> > >
> > > Boot into UP. Time how long it takes to do a million of these in a real
> > > time task:
> > >  asm volatile("" : : : "memory");
> > >
> > > Then start up a SCHED_NORMAL task fully cpu bound such as "yes >
> > > /dev/null" and time that again. Obviously the former being a realtime
> > > task will take the same amount of time and the SCHED_NORMAL task will be
> > > starved until the realtime task finishes.
> >
> > Sure.
> >
> > > Now try the same experiment with hyperthreading enabled and an ordinary
> > > SMP kernel. You'll find the realtime task runs at only ~60% performance.
> >
> > So?  User asked for HT.  That's hardware multiplexing. It ain't free.
> > Buyer beware.
> 
> But the buyer is not aware. You are aware because you tinker, but the vast 
> majority of users who enable hyperthreading in their shiny pcs are not aware.

Then we need to make them aware of what they're enabling?
 
> The only thing they know is that if they enable hyperthreading their programs 
> run slower in multitasking environments no matter how much they nice the 
> other processes. Buyers do not buy hardware knowing that the internal design 
> breaks something as fundamental as 'nice'. You seem to presume that most 
> people who get hyperthreading are happy to compromise 'nice' in order to get 
> their second core working and I put it to you that they do not make that 
> decision.

To me it's pretty much black and white.  Either you want to split your
cpu into logical units, which means each has less to offer than the
total, or you want all your processing power in one bucket.

> > >  That's a
> > > serious performance hit for realtime tasks considering you're running a
> > > SCHED_NORMAL task. The SMT code that you seem to dislike fixes this
> > > problem.
> >
> > I don't think it does actually. Let your RT task sleep regularly, and
> > ever so briefly.  We don't evict lower priority tasks from siblings upon
> > wakeup, we only prevent entry... sometimes.
> 
> Well you know as well as I do that you're selecting out the exception rather 
> than the rule, and statistically overall, it does work.

I don't agree that it's the exception, and if you look at this HT thing
from the split cpu perspective, I'm not sure there's even a problem.

Scrolling down, I see that this is getting too long, and we aren't
communicating anyway, so I'll cut it off here.

> We're going to have to agree to disagree, but feel free to have the final word 
> of course.

The above will have to do.

	-Mike

