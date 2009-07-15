Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbZGOUzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbZGOUzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbZGOUzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:55:12 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5549 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932317AbZGOUzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:55:11 -0400
Date: Wed, 15 Jul 2009 16:55:03 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: "James H. Anderson" <anderson@cs.unc.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090715205503.GA14993@cs.fsu.edu>
References: <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu> <1247589099.7500.191.camel@twins> <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 12:54:13PM -0400, James H. Anderson wrote:
> 
> ... Ted Baker did some work on an algorithm called EDZL
> (EDF until zero laxity) that is essentially a hybrid of these two
> algorithms.  In simulations we've done (not based on real implementations),
> EDZL exhibits really low tardiness (almost non-existent).  EDZL may
> give you the benefits of using laxities where useful and be easier
> to implement (but that's just my guess)

Yes, EDZL is a simple extension of EDF.  If you have a WCET
estimate for a task, you just apply EDF until/unless the task
reaches zero laxity.  If it reaches zero laxity you bump it to a
fixed priority level that is above all EDF tasks.  It seems very
good in simulations, in terms of schedulabilty, number of context
switches, and number of task migration.  It never deviates from
EDF except in cases where a deadline would otherwise be missed.
Therefore all EDF schedulability tests are valid for EDZL.  In
addition, we have some tighter tests.  EDZL never causes more than
one context switch more than EDF, when a task goes from positive
laxity to zero laxity.  This does not happen often.  It is much
lower overhead than least-laxity-first, since there is no
possibility of getting into a time-slicing situtation among tasks
with equal laxity.  It is also nice because in many cases the
scheduler will not know the WCET of a task, and so it is
impossible to compute laxity.  In those cases, you just use EDF.
The two policies (EDF and EDZL) are completely compatible and
interoperable.

I hope that Linux will not pursue EDF or EDZL in only a narrow
sense, as simple priority scheduling algorithms, without providing
for bandwidth guaranteees and limits.

By bandwith "guarantee" I mean that the task/scheduling entity is
guaranteed to be able to at least *compete* at a certain level for
a certain percentage of the CPU, if we cannot (better) provide an
admission control mechanism that guarantees it will actually get a
certain percentage of the CPU.

By bandwidth "limit" I mean that there is an enforced bound
on the percentage of processor time a task/scheduling entity
may consume.  

For example, in the fixed-priority domain, we have Sporadic
Server.  This guarantees the server a chance to compete at its top
priority for at least sched_ss_init_budget time in every
sched_ss_repl_period time, at sched_priority, within some
tolerance.  It also should not be permitted to use more than
sched_ss_init_budget time in every sched_ss_repl_period time, at
sched_priority, within some tolerance.

In the deadline scheduling domain, we have algorithms like
Constant Bandwidth Server (and some improved variants) that
provide similar gurantees and limites, in terms of deadlines.  (I
recall seeing one very good version in a paper I recently saw,
which I could seek out and provide to the list if there is
interest.)

These so-called "aperiodic server scheduling" algorithms are
critically needed in a system like Linux that is open (in the
sense of being able to host a dynamic mix of uncoordinated
applications), and based on a thread programming model (as copared
to the job/task models used in scheduling theory).  With the
thread abstraction one generally cannot give the scheduler WCET
bounds, and sometimes cannot give deadlines, since the threads
will wake up and go to sleep according to their own internal logic
(all the OS sees is the system calls).  However, if the
application is guaranteed a chance to at least compete at a high
enough priority for a certain bandwidth (and, preferably, actually
be guaranteed that bandwidth, by admission control), it is
possible to write real-time applications. In order to be able to
make such a guarantee, one must be able to limit the CPU usage of
all other threads.  This means, in effect, that *all*
tasks/scheduling entities above a certain priority level must be
scheduled according to a bandwidth-limiting algorithm.

The present Linux "RT throttling" mechanism seems to be an attempt
to achieve something similar (preventing RT tasks from shutting
out other work, by reserving some bandwidth for non-RT tasks).
However, it is done so grossly as to be unsatisfactory for
real-time applications.  The better way to do this would be to
enforce a bandwidth limit on each task with real-time priority --
using the budget amount and replenishment interval required by
that task -- and enforce by admission control that the real-time
tasks do not exceed some configurable percent of the total system
utilization.

Of course, the POSIX standard does not recognize any budget and
replenishment interval for policies other than SCHED_SPORADIC, but
the same problem exists with respect to the present "RT
throttling" mechanism.  It would be possible to provide legal
implementation-defined extensions for the operations that take a
struct sched_param to look at these additional sched_param fields
for other policies such as SCHED_FIFO and SCHED_OTHER, and to
provide default values when they are not specified.  The amount of
capacity to be reserved for system internal use could be
configured, using some combination of kernel compile-time macros,
boot parameters, and the /proc interface.  User defaults could be
configured using extensions to the setrlimit() interface.

Ted
