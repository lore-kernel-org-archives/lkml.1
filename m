Return-Path: <linux-kernel-owner+w=401wt.eu-S934638AbZGQNh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbZGQNh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934617AbZGQNh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:37:26 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:1543 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934616AbZGQNhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:37:25 -0400
Date: Fri, 17 Jul 2009 09:37:22 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Henrik Austad <henrik@austad.us>
Cc: "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
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
       Bjoern Brandenburg <bbb@cs.unc.edu>, stanovic@cs.fsu.edu
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090717133722.GB2111@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <200907142128.48558.henrik@austad.us> <20090715215305.GD14993@cs.fsu.edu> <200907170941.01559.henrik@austad.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907170941.01559.henrik@austad.us>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 09:40:59AM +0200, Henrik Austad wrote:

> Why cannot you expect real-time tasks using a deadline scheduler to provide 
> some estimate of the execution cost? How can you ever hope to run a deadline 
> scheduler without this?

This depends on what you mean by a "deadline scheduler".
Personally, I don't think it makes much sense for an OS to support
scheduling of aperiodic "jobs" on job deadlines.  If you have
chunks of application work that logically should be viewed as
jobs, with approximately known WCET and deadlines, the right way
to handle that is to have server thread(s), with associated job
queue(s) that order their own queues by job deadline.  The servers
are provisioned with enough CPU capacity to provide the desired
level of service for the anticipated load.  If load-shedding is
required at times, that is the responsibility of the server, which
is part of the application and has the application-specific
knowledge needed to make such decisions.  (Alternatively,
the server could negotiated for a higher CPU share if it starts
missing deadlines.)

What it makes sense for the OS to provide is what I'll loosely
call "CPU shares".  Deadline scheduling is a good way to implement
this, since the schedulability analysis is relatively clean
(including max. tardiness).  That is each server thread has a
"period" and is entitled to a certain budgeted amount of time each
period, and the period is the deadline for getting that much CPU
time.  Constant Bandwidth and Total Bandwidth are two such
policies.  (I recently reviewed a paper that worked the kinks out
of the published Constant Bandwidth in a very nice way.  If I can
find that it has been since published, or if there is a public
pre-print technical report, I'll try to send the reference in
another e-mail.)

With CPU shares, we do have something like a WCET, but it is
really a maximum allowed execution time.  In this case, I'm not
sure it makes much (any?) sense to worry about laxity, though.
This should not be a hard-deadline situation (indeed, I don't
think it makes sense for an OS as complicated as Linux to talk
about truly hard deadlines).  It may be enough to know the maximum
lag or tardiness.

Of course, if you want to put in special support for periodic
tasks (say for sensor polling or poriodic actuator output), you
can do that, but to me the right model is probably not a thread.
It would make more sense to me for such tasks to implemented as
event handlers.

> How can you use deadlines based on priorities? A priority is a
> one-way mapping of deadlines for a set of tasks.

I had in mind several different ways.

1) You can preserve a range of nominal "deadlines" that are
above and below the range of real deadlines used in scheduling.
For example:

A) reserve the maximum representable time value for
tasks that should never run (suspended).  
This value is useful for bandwidth
limiting aperiodic server scheduling, if you really want to
keep a temporarily out-of-budget server from competing with 
other tasks.  Note that the pure constant-bandwith server is not enough
in this respect, since it would still have a deadline earlier
than non-realtime - tasks in the B range.

B) Reserve a few values below that for tasks that are
fixed-priority and lower in priority than all true deadline tasks.
Some of these "deadlines" can be used for SCHED_FIFO and SCHED_RR
that we want to be below the deadline-scheduler and also for
SCHED_OTHER.

C) The main band of deadlines is used for real deadline
scheduling.  (I don't believe it would technicall violate the
POSIX standard to have a hidden "hole" between SCHED_FIFO and
SCHED_RR values, but if there are seriou objections, one could
pick a priority in the middle of the RT range and say that these
deadline scheduled tasks are executing at that priority.)

D) Reserve a few values close to zero for tasks that
are fixed-priority and higher in priority than all true
deadline tasks.  This is useful for SCHED_FIFO and SCHED_RR
that we want to be above the deadline-scheduler, and
also for hybrid EDZL and EDF scheduling algorithms.
EDZL would use such a value when a task reaches zero laxity.
Hybrid EDF uses such a value for tasks that have high
enough processor utilizations (> 50%), to achieve a higher
schedulable system utilization than pure EDF.

You have lost nothing in deadline representation, since the values
used for these two fixed-priority ranges are useless for real
deadlines.

2) Within the range (C) ("real" deadline scheduling), you can also
implement something close enough to priority to serve the purposes
for which priority is typically used, by using an aperiodic-server
type scheduling algorithm and giving "high priority" tasks short
replenishment periods (and so shorter relative deadlines).

> Are we going to place all tasks in the kernel into rt-deadline
> tasks? I had the impression that we wanted a class for a special
> set of tasks.

I think it could be done.
See my scheme above for translating everthing into deadlines.

Ted
