Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbZGOVT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbZGOVT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZGOVT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:19:56 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5602 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbZGOVTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:19:55 -0400
Date: Wed, 15 Jul 2009 17:19:52 -0400
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
Message-ID: <20090715211952.GB14993@cs.fsu.edu>
References: <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu> <1247589099.7500.191.camel@twins> <alpine.LRH.2.00.0907141259100.16818@anderson.cs.unc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0907141259100.16818@anderson.cs.unc.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 01:16:52PM -0400, James H. Anderson wrote:
> ... BTW, I should say that I am not
> familiar with the PEP protocol that has been discussed in this thread.
> I assume it doesn't work under GEDF, or you wouldn't have asked the
> question...

I have not seen the definition of PEP, but from the context of
this discussion I infer that it refers to an implementation of
priority inheritance.  As such, with pretty much any global
scheduling policy, the set of other tasks whose critical sections
could stack up is bounded only by the number of tasks in the
system.

In any case, I have misunderstood what PEP is, let me attempt
to summarize what I have inferred:

A high priority running task that would otherwise become blocked
waiting for a lower-priority lock-holding task to release the lock
can give up its prority/shot at execution to the lower-priority
task that is blocking it.  That is, when a task A is "blocked" for
a lock it can stay in the run-queue so long as the task B that is
(ultimately, transitively) blocking it is in (the same?)
run-queue.  At any point where the scheduler would choose to
execute A it instead finds B, by traversing wait-for links between
tasks, and executes B.  The priority order of the run-queue can be
based on any (partial) ordering relation, including deadlines.

A slight complexity is that if B is allowed to suspend itself
while holding a lock, and does so, one must run back and also
remove the tasks like A from the run-queue, and when B wakes up,
one must do the revers.  However, the frequency of deep nesting
of wait-for relationships seems small.

For GEDF on SMP, a question is how to handle the case where A is
blocked on one processor and B may be running on a different one.
This seems to require removing A from the run-queue when it is
detected.

Of course, the current Linux model appears not to fully support
GEDF, since run-queues are per-processor, subject to explicit
migration.  So, as infer from the preceding messages, the question
above transforms into whether to migrate A to B's processor
run-queue or to migrate B to A's processor run-queue?

Ted
