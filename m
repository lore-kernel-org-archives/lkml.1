Return-Path: <linux-kernel-owner+w=401wt.eu-S1767308AbXDEUbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767308AbXDEUbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767299AbXDEUbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:31:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:52433 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1767293AbXDEU3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:29:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+6bBk67su6aDs5R/kqjq4GlEIFUDJTLqamv303Ll
	iT8hMPXnXGAkK4
Subject: Re: [test] sched: SD-latest versus Mike's latest
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704060208.47327.kernel@kolivas.org>
References: <200703290237.38777.kernel@kolivas.org>
	 <1175770950.6609.16.camel@Homer.simpson.net>
	 <20070405115447.GA24138@elte.hu>  <200704060208.47327.kernel@kolivas.org>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 22:29:36 +0200
Message-Id: <1175804976.7814.109.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 02:08 +1000, Con Kolivas wrote:
> On Thursday 05 April 2007 21:54, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > > On Tue, 2007-04-03 at 08:01 +0200, Ingo Molnar wrote:
> > > > looks interesting - could you send the patch?
> > >
> > > Ok, this is looking/feeling pretty good in testing.  Comments on
> > > fugliness etc much appreciated.
> > >
> > > Below the numbers is a snapshot of my experimental tree.  It's a
> > > mixture of my old throttling/anti-starvation tree and the task
> 
> Throttling to try to get to SD fairness? The mainline state machine becomes 
> more complex than ever and fluctuates from interactive to fair by an as-yet 
> unchosen magic number timeframe which ebbs and flows.

I believe I've already met and surpassed SD fairness.  Bold statement,
but I believe it's true.  I'm more worried about becoming _too_ fair.

Show me your numbers.  I showed you mine with both SD and my patches.

WRT magic and state machine complexity:  If you read the patch, there is
nothing "magical" about it.  It doesn't do anything but monitor CPU
usage and move a marker.  It does nothing the least bit complicated, and
what it does, it does in the slow path.  The only thing it does in the
fast path is to move the marker, and perhaps tag a targeted task.  State
machine?  There is nothing there that resembles a state machine to me,
the heuristic is just add sleep time, burn on use.

> > > promotion patch, with the addition of a scheduling class for
> > > interactive tasks to dish out some of that targeted unfairness I
> > > mentioned.
> 
> Nice -10 on mainline ruins the latency of nice 0 tasks unlike SD. New 
> scheduling class just for X? Sounds like a very complicated 
> userspace-changing way to just do the equivalent of "nice -n -10" obfuscated.

This patch makes massive nice -10 vs nice 0 latency history I believe.
Testing welcome.  WRT "nice -10 obfuscated", that's a load of high grade
horse-hockey.  There were very good reason posted here as to why that is
a very bad idea, perhaps you haven't read them.  (you can find them if
you choose)

Your criticism SCHED_INTERACTIVE leaves me dumbfounded, since you were,
and still are, specifically telling me that I should tell the scheduler
that X is special.  I did precisely that, and am also trying to tell it
that it's clients are special too, _without_ having to start each and
every client at nice -10 or whatever static number of the day.

> > here's some test results, comparing SD-latest to Mike's-latest:
> >
> > re-testing the weak points of the vanilla scheduler + Mike's:
> >
> >  - thud.c:    this workload has almost unnoticeable effect
> >  - fiftyp.c:  noticeable, but alot better than previously!
> 
> Load of 1.5 makes mainline a doorstop without throttling.

Where does that come from?  Doesn't jibe with my experience at all.

> > re-testing the weak points of SD:
> >
> >  - hackbench: still unusable under such type of high load - no improvement.
> 
> Load of 160. Is proportional slowdown bad?
> 
> >  - make -j:   still less interactive than Mike's - no improvement.
> 
> Depends on how big your job number vs cpu is. The better the throttling gets 
> with mainline the better SD gets in this comparison. At equal fairness 
> mainline does not have the low latency interactivity SD has.

So we should do 8ms slices too?  I don't think that's necessary.

> Nice -10 X with SD is a far better solution than an ever increasing complexity 
> state machine and a userspace-changing scheduling policy just for X. Half 
> decent graphics cards get good interactivity with SD even without renicing.

SD does not retain interactivity under any appreciable load for one, and
secondly, I'm getting interactivity that SD cannot even get close to
without renicing, and without any patches - in mainline right now.

(Speaking of low latency, how long can tasks forking off sleepers who
overlap their wake times prevent an array switch with SD?  Forever?)

I posted numbers that demonstrate the improvement in fairness while
maintaining interactivity, and I'm not finished.  I've solved the
multiple fiftyp.c thing Ingo noticed, and in fact, I had 10 copies
running that I had forgotten to terminate while I was working, and I
didn't even notice until I finished, and saw my top window.  Patch to
follow as soon as I test some more (that's what takes much time, not
creating the diff.  this isn't rocket science.)

Maybe I'll succeed, maybe I won't.

	-Mike

