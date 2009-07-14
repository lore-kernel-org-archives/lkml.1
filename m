Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZGNJP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZGNJP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZGNJPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:15:25 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:2489 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZGNJPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:15:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Noah Watkins <jayhawk@soe.ucsc.edu>
Cc: Raistlin <raistlin@linux.it>, Douglas Niehaus <niehaus@ittc.ku.edu>,
       Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop>  <1247499843.8107.548.camel@Palantir>
	 <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 11:15:12 +0200
Message-Id: <1247562912.7500.78.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 11:14 -0700, Noah Watkins wrote:
> > I think you can extend PIP to include things like bandwidth  
> > inheritance
> > too. Instead of simply propagating the priority through the waitqueue
> > hierarchy, you can pass the actual task around, and having this  
> > task you
> > can indeed consume its bandwidth etc..
> 
> I think I understand what you are suggesting by "pass the actual task  
> around". If not, this message might seem out of place.
> 
> Consider this locking chain/graph:
> 
> A-->L1-->B-->L2-->C
> D-->L3-->E-->L2

       C
       |
       L2
      /  \
     B    E
     |    |
     L1   L3
     |    |
     A    D

> The way I understand what you are suggesting is that tasks A,B,D,E  
> (or some representation of them) can be passed around such that when  
> C executes it consumes some resource associated with the the tasks it  
> is blocking (A,B,D,E). Obviously which tasks and what quantities are  
> dependent on scheduling semantics and configuration.
> 
> The biggest implementation hurdle we have encountered is that as  
> tasks are passed forward along a locking chain knowledge about the  
> structure of the locking chain is lost. For example, as C releases  
> L2, C must be able to distinguish between A and D as having been  
> passed to C's location through B or E, respectively.
> 
> Keeping a representation of the locking chain as a full graph is the  
> solution we have used. Another solution is to allow A and D to re- 
> block and walk the locking chain again, but obviously some thundering- 
> hurd issues arise.

Right, we too keep the full graph (as Ted has noted with disgust).

Douglas mentions that since there is no priority in things like
proportional bandwidth schedulers (CFS), priority inheritance cannot
work.

I would beg to differ in that a straight forward extension of the
protocol can indeed work, even for such cases.

One needs to change the sorting function used in the waitqueues (Li) to
reflect the full scheduler function (which in itself can be expressed as
a (partial?) sorting function.

One needs to pass along the 'highest' task, not simply the priority.

And, one needs to cancel and re-acquire this task's contention whenever
the leading task (C) gets preempted.

We let the scheduler use and consume the task that is passed up as being
the 'highest' in C's stead (it might actually be C).


For example, suppose the above block graph and add a single unrelated
task F, all of equal and unit (1) weight. Now traditionally that'd
result in 2 runnable tasks of equal weight, such that they both get 50%
cpu time (assuming single cpu).

However, PEP and the above modified PIP will in fact result in C
receiving an effective weight of 5 versus 1 for F.

The sorting function for proportional bandwidth schedulers is the
typical least service received one -- such that the task with least
service will be deemed the 'highest' one.

Now suppose that that task would be found to be A, we'll run C with A's
values until its quanta is consumed and we'd force preempt. Normally
that would lead to the selection of F, however if we first cancel and
retry A, leading to a re-sorting of the graph, we might well find that E
is the 'highest' task in the graph, and also more eligible than F.


Furthermore Ted raises the point:

> Regarding the notion of charging proxy execution to the budget of
> the client task, I have grave concerns. It is already hard enough
> to estimate the amount of budget that a real-time task requires,
> without this additional complication. 

I hope the above illustrates the use of this, furthermore I think Dario
and team did some actual analysis on it wrt deadline schedulers. Dario
could you expand?

~ Peter

