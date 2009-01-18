Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZARSyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZARSyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZARSy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:54:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:38207 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752185AbZARSy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:54:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/EGyIK9ETE43K6VRfEvLUGlUvZV4y1wJPNZFvZud
	vamqZCTbJWsRX/
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232292491.5204.3.camel@laptop>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232287718.12958.8.camel@marge.simson.net>
	 <1232292491.5204.3.camel@laptop>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 19:54:15 +0100
Message-Id: <1232304855.5908.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 16:28 +0100, Peter Zijlstra wrote:
> On Sun, 2009-01-18 at 15:08 +0100, Mike Galbraith wrote:
> > On Sat, 2009-01-17 at 13:00 +0100, Peter Zijlstra wrote:
> > > On Sat, 2009-01-17 at 11:34 +0100, Mike Galbraith wrote:
> > > > > Right, how about we flip the 'initial' case in place_entity() for !
> > > > > nr_exclusive wakeups.
> > > > 
> > > > Wouldn't that be more drastic than sleep denial?
> > > 
> > > Strictly speaking that DEBIT thing is valid for each wakeup, IIRC we
> > > restricted it to clone() only because that was where we could actually
> > > observe these latency spikes using a fork-bomb.
> > > 
> > > This reduces the latency hits to around 400ms, which is about right for
> > > the given load.
> > 
> > Disregarding the startup landmine for the moment, maybe we should put a
> > buddy slice knob in the user's hands, so they can tune latency, along
> > with a full on/off switch for those who care not one whit about
> > scalability.
> 
> I'm not particularly fond of that idea because it only helps for this
> particular workload where any one task isn't actually running for very
> long.

Well, there are a lot of buddy loads where runtime is very short.  You
can achieve ~similar latency control, but not as fine, by twiddling
wakeup latency.  At least you can prevent the triple digit latency with
12 (and a half) pairs per core.  I can imagine server loads not liking
600-700ms latencies.  I was just thinking that with two knobs, you can
keep the benefits of relatively high wakeup granularity, yet have a user
tweakable throughput vs latency adjustment for buddies to complement
wakeup latency.

> If however your workload consists of cpu hogs, each will run for the
> full wakeup preemption 'slice' you now see these buddy pairs do.

Hm.  I had a whack buddy tags if you are one at tick in there, but
removed it pending measurement.  I was wondering if a last buddy hog
could end up getting the CPU back after having received his quanta and
being resched, but haven't checked that yet.

> Also, buddies really work for throughput, so I don't particularly fancy
> weakening them below what a normal cpu-hog can already do.

Yeah, I was thinking of the user who where latency rules, very select
group.  If someone has a really latency sensitive load, they can turn
LAST_BUDDY off, but that doesn't help with the latency that NEXT_BUDDY
causes.  Almost everyone really really wants buddies, but not all.

Buddies are wonderful for cache, wonderful for throughput, but are not
wonderful for latency, ergo the thought that maybe we should offer a
full off switch for those who know the consequences.

It was just a thought.

	-Mike

