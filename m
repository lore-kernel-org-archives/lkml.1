Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZGNQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZGNQbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZGNQbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:31:50 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:15064 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZGNQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:31:49 -0400
X-SourceIP: 213.93.53.227
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "James H. Anderson" <anderson@cs.unc.edu>
Cc: Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
In-Reply-To: <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
	 <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 18:31:39 +0200
Message-Id: <1247589099.7500.191.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jim,

On Tue, 2009-07-14 at 11:19 -0400, James H. Anderson wrote:
> The first email in this thread that I was cc'ed on talked about
> implementing global EDF,

Hendrik says that its a modified Modified-Least-Laxity-First, so
something like M^2-LLF, and I cc'ed you (and I meant to add Bjorn too,
but now see I failed to actually do so) in the hope that you would have
some thoughts on his scheduling algorithm, since that is what you do a
lot of ;-)

It could well be he modified M-LLF into G-EDF, but I'm behind in my
reading here, so I'll have to leave that up to others.

> but the discussion since has been entirely about synchronization issues.

Right, this seems to be a very hot topic.

>   To the best of my
> knowledge, the only published real-time locking protocol that
> can be used under global EDF (and many other algorithms) without
> restricting critical sections (like not allowing certain resources
> to be accessed in a nested manner) is a protocol we designed called
> the flexible multiprocessor locking protocol (FMLP). 

> The FMLP is really embarrassingly simple.  It's main mechanisms are:
> 
> 1. Require critical sections to execute non-preemptively (I know,
> non-preemption violates the "real-fast" religion -- I've been in
> these discussion before :-)).

Lets simply state that industry would like to be able to deal with very
short deadlines :-)

> 2. Execute critical sections in FIFO order (I know, FIFO violates
> the "real-time" religion).

For those locks that are indeed non-preempt busy wait (raw_spinlock_t)
we generally use a FIFO-fair implementation (x86 at least, but I thought
several other platforms were looking at, or have already, implemented a
similar spinlock).

> 3. Deal with nested lock accesses by requiring a higher-level,
> coarser lock to be acquired.  While this many seem "too dumb", traces
> we have taken of real systems (including Linux) indicate that
> two-level nesting is not that common and deep nesting is quite rare.
> Why design complicated mechanisms that are both hard to implement
> and analyze to deal with something that is not so common?
> 
> In the FMLP, waiting can be implemented via either spinning or
> suspension (technically, critical sections are categorized as
> "short" or "long" and spinning is used for short CSs and suspension
> for long ones -- this categorization is entirely up to the user).
> Spinning is done non-preemptively (suspending obviously is not).
> 
> The beauty of non-preemptive, FIFO is that on an m-processor system,
> blocking behavior is easy to analyze.  For example, with spin-based
> waiting, the blocking per critical-section access is (m-1) times the
> cost of one critical section.  Someone remarked in an earlier email
> that we're really thinking of m being somewhat small (4, maybe 8).
> As such, this is a blocking term that is really hard to beat.  As I
> said, simplicity wins.  With suspension-based waiting, things are a
> bit more complicated, but not much.

Our problems are many (and I think you know about most if not all).

 - Linux is _huge_:
    o  and while we seem to do a reasonable job of
       getting people to cope with basic concurrency, asking them to
       take RT constraints into account when doing so will surely be too
       much -- worse, we might not ever convince people its a worthy
       goal to begin with.

    o  auditing each and every lock in the kernel simply isn't possible.

 - Linux needs to provide isolation:
    o  we must assume userspace is hostile and try to minimize the
       impact of such tasks on others.

 - POSIX:
    o  we're stuck with the legacy here, but we're looking fwd outside
       of POSIX.

(I'm probably forgetting half)

> In our experience, the blocking analysis of any multiprocessor protocol
> that uses priority-inheritance-related mechanisms is a nightmare.  The
> problem is that, to handle all the corner cases, pessimistic assumptions
> have to be made.  This pessimism can really add up and lead to huge
> blocking terms.

Right, Ted holds similar opinions.

Practically though, active Priority Inheritance has enormous benefits
for us simple people that need to get things done :-)

It has allowed us to convert this huge mass of code into something that
is real-time enough for a lot of practical uses, including industrial
robots and the like without the need to analyze each and every lock out
there.

Now I fully appreciate the theoretical trouble full PI and its ilk
gives, so maybe we can do something with lockdep/stat to track and
qualify the lock nesting depths and critical section lengths and use
those to improve upon the situation.

At worst we could use the data to qualify the usability of certain
system calls/traps wrt RT applications.

Also, can't we employ the PI framework to act as a debug/help-guide in
validating/figuring out the PCP levels?

On that, how does the priority ceiling/protection protocol extend to
deadline schedulers?

> This email thread has also touched on group-based scheduling.  We
> proposed a very simple scheme several years ago called "skipping"
> in the context of Pfair scheduling that makes this easy:

> In this approach, critical-section lengths must be known, and any
> lock request that occurs when a task doesn't have sufficient
> budget is simply denied -- the request is done later when that task
> receives additional budget.  This avoids a task in one group from
> holding a lock while it is preempted (which could severely hurt
> lock-requesting tasks in other groups).  This scheme is really easy
> to implement in conjunction with the FMLP and it doesn't require
> complicated budget tracking.  Its effects on blocking terms are
> also easy to analyze.  Thomas Nolte and colleagues (in Sweden) have
> written some papers where they've used skip-based locks in
> hierarchically-scheduled systems.

Not granting locks when the contender doesn't have enough budget to
finish them seems like a very attractive solution, however the cost of
having to analyze the critical section seems prohibitive.

That said, we could maybe experiment with this for a few key lock sites.

Anyway, our goal (the linux-rt folks) is to make Linux a better RT OS.
I'm sure we'll never get hard enough for some people, but I'm sure we
can do better than we do today.

Furthermore we're limited by the existing legacy (both spec and code
wise), but I think we have been able to make good progress through tools
that help us, such as lockdep and the latency tracer (now ftrace), which
help us find trouble in an active manner.

And I think discussion such as these help us find new directions to
explore, so carry on!

