Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbZARHqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbZARHqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZARHpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:45:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:54130 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753978AbZARHpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:45:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/b8OoyZQbbbJ5frYnCRY8x5m2T+hwtrvw2LqfrSP
	GTnuTvJjBadwU5
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1232210232.5987.20.camel@marge.simson.net>
References: <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232194752.6273.5.camel@marge.simson.net>
	 <20090117044316.bda7d0bd.akpm@linux-foundation.org>
	 <1232198574.16303.8.camel@marge.simson.net>
	 <20090117160115.GA31601@elte.hu> <1232209281.5987.4.camel@marge.simson.net>
	 <20090117162519.GD10825@elte.hu>
	 <1232210232.5987.20.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 08:45:46 +0100
Message-Id: <1232264746.5640.60.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 17:37 +0100, Mike Galbraith wrote:
> On Sat, 2009-01-17 at 17:25 +0100, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Sat, 2009-01-17 at 17:01 +0100, Ingo Molnar wrote:
> > > > * Mike Galbraith <efault@gmx.de> wrote:
> > > > 
> > > > > On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
> > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
> > > > > > scheduler regression.  It has been bisected.
> > > > > 
> > > > > Seems pretty clear.  I'd suggest reverting it.
> > > > 
> > > > We can revert it (and will revert it if no solution is found), but i'd 
> > > > also like to understand why it happens, because that kind of 
> > > > regression from this change is unexpected - we might be hiding some 
> > > > bug that could pop up under less debuggable circumstances, so we need 
> > > > to understand it while we have a chance.
> > > 
> > > Agree.  However, with the sched_mc stuff, mysql+oltp now does better 
> > > with NEWIDLE on than off as well, as does an nfs kbuild.
> > 
> > Didnt you come up with the verdict that sched_mc=2 is not a win - or has 
> > that changed? If we should change the defaults then please send a 
> > re-tuning patch against the latest code.
> 
> sched_mc=2 was better than sched_mc=1.  The other balancing changes put
> a dent in mysql+oltp peak and immediately after peak.  Setting
> sched_mc=2 brought back the loss that was otherwise there all the way
> through the curve back to 28 level, so with sched_mc=2, there was only
> the slight loss of peak, and larger loss of post-peak.

P.S.
/sched_mc=1/sched_mc=0

P.P.S.
I suggested setting sched_mc=2 to be default since we already have the
pain that this development inflicted, we may as well have the gain as
well, such that it's a trade-off in favor of the fork/exec load at the
expense of cache sensitive loads like mysql+oltp, but the authors prefer
to leave the default as is.

<quote>
> > Thanks for the detailed benchmark reports.  Glad to hear that
> > sched_mc=2 is helping in most scenarios.  Though we would be tempted to
> > make it default, I would still like to default to zero in order to
> > provide base line performance.  I would expect end users to flip the
> > settings to sched_mc=2 if it helps their workload in terms of
> > performance and/or power savings.
> 
> The mysql+oltp peak loss is there either way, but with 2, mid range
> throughput is ~28 baseline.  High end (yawn) is better, and the nfs
> kbuild performs better than baseline.
> 
> Baseline performance, at least wrt mysql+oltp doesn't seem to be an
> option.  Not my call.  More testing and more testers required I suppose.

Yes, more testing is definitely due. I'd like to hear from people
with larger and newer boxes as well before I would be comfortable making
sched_mc=2 as default.
</quote>

WRT these latencies, I'm of two minds.

On the one hand, those huge latencies are unacceptable, but on the
other, there are knobs in place for anyone running a load that really
does wake a zillion long sleeping threads simultaneously.  No matter
_what_ amount of sleeper fairness we try to achieve, this latency
multiplier potential is there.

I see no really appetizing option.  You can easily scale the bonus back
as load increases to limit the pain potential, but that has down side
potential too, and would likely not be a good default: for mysql+oltp,
wakeup preemption is a positive factor through the entire performance
curve, up until it is totally jammed up on itself.  On my Q6600, the
preempt/no-preempt curves converge at 64 clients/core.  On the
interactivity front, X and it's clients don't care how many hogs they're
competing against, any preempt ability we take translates directly into
interactivity loss for the user.  Not to mention events. 

The potential of wake_up_all() bothers me more than this starter pistol.
(why I leapt straight to it from debug output, I've been there before;)

	-Mike

