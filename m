Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZKWM11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZKWM11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbZKWM11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:27:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395AbZKWM1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:27:25 -0500
Date: Mon, 23 Nov 2009 13:27:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123122731.GE2287@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop> <20091123114550.GB25575@elte.hu> <20091123120100.GC2287@wotan.suse.de> <20091123120849.GB32009@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123120849.GB32009@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 01:08:49PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Mon, Nov 23, 2009 at 12:45:50PM +0100, Ingo Molnar wrote:
> > Well to be fair, the *decision* is to use a longer-term weight for the 
> > runqueue to reduce balancing (seeing as we naturally do far more 
> > balancing on conditions means that we tend to look at our instant 
> > runqueue weight when it is 0).
> 
> Well, the problem with that is that it uses a potentially outdated piece 
> of metric - and that can become visible if balancing events are rare 
> enough.

It shouldn't, it happens on the local CPU, at each scheduler tick.

 
> I.e. we do need a time scale (rate of balancing) to be able to do this 
> correctly on a statistical level - which pretty much brings in 'rate 
> limit' kind of logic.
> 
> We are better off observing reality precisely and then saying "dont do 
> this action" instead of fuzzing our metrics [or using fuzzy metrics 
> conditionally - which is really the same] and hoping that in the end it 
> will be as if we didnt do certain decisions.

We do though. We take the instant value and the weighted value and
take the min or max (depending on source or destination).

And we decide to do that because of the instantaneous fluctuations
on runqueue load can be far far outside even a normal short term
operating condition.

I don't know how you would otherwise propose to damp those fluctuations
that don't actually require any balancing. Rate limiting doesn't get
rid of those at all, it just does a bit less frequent blaancing. But
on the NUMA domain, memory affinity has been destroyed whether a task is
moved once or 100 times.

 
> (I hope i explained my point clearly enough.)
> 
> No argument that it could be done cleaner - the duality right now of
> both having the fuzzy stats and the rate limiting should be decided 
> one way or another.

Well, I would say please keep domain balancing behaviour at least
somewhat close to how it was with O(1) scheduler at least until CFS
is more sorted out. There is no need to knee jerk because BFS is
better at something.

We can certainly look at making improvements and take queues from
BFS to use in sched domains, but it is so easy to introduce regressions
and also regressions versus previous kernels are much more important
than slowdowns versus an out of tree patch. So while CFS is still
going through troubles I think it is much better to slow down on
sched-domains changes.
 
Thanks,

