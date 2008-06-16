Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYFPR7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYFPR7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYFPR7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:59:41 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:6973 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYFPR7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hGpDImqUigaVUX+lGYGUO2tTdBY2IdBv/70BKST4zRHejmz5o2jvA2VLuNHqknMoLz
         drFEZhnbbEabmOlPJZ9hB4hJD0P6HRLs0wG0LdvYZlhyXYbxh4ouWwU8z7GGilyNvH/5
         /8GXVOeVcBSCHRd2hkgQH/lV5C/bMzWKtMBnQ=
Message-ID: <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
Date: Mon, 16 Jun 2008 19:59:38 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable tasks over migratable ones"
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <48563FDB.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213138710.26530.51.camel@earth> <1213174382.31518.69.camel@twins>
	 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
	 <48563FDB.BA47.005A.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

> [ ... ]
>>> Doesn't this violate POSIX ?
>>>
>>
>> If so, then the idea of "prioritize non-migratable tasks over
>> migratable ones" violates it, not just an artefact of this particular
>> implementation.
>
> This isn't entirely accurate though.  Your proposal does alter the behavior from the original patch.  In fact, I put in the xqueue/squeue concept specifically to *avoid* the condition that you are creating.  I think this was the point Peter was making.
>
> However, to your point: I can agree that either implementation creates the possibility for creating strange scheduling artifacts.  And I think the point you are making is that once we have the artifact, whats another one? ;)

My guess was that Peter points out at the possibility of task_2
getting ahead of task_1, despite task_1's longer presence on the
run-queue and both tasks having equal priority.

IOW., it's not anymore a round-robin distribution for equal-prio
tasks (if that's how POSIX requires it... yeah, I'm speculating here
:-) but "migratable" vs. "non-migratable" in addition.

With your implementation, a "non-migratable" task gets ahead of
"migratable" (and possibly, some "migratable" that are on the queue
but for some reason have not been pulled/pushed yet).

With mine, one "non-migratable" can preempt another "non-migratable".

Partly, it could be fixed by : add a "non-migratable" task to the head
of the queue _only_ if the "current" task (or better -- if a
head-of-the-queue task) is "migratable".

One way or another, we have different aritifacts (and mine have likely
more) but conceptually, both "violates" POSIX if a strict round-robin
scheduling is required.

By "strict round-robin scheduling" I mean something as follows:

a woken-up task_N can get a CPU _only_ if none of other currently
pending tasks in the system (that's on all cpus and, sure, _RR and
_FIFO and of equal prio) can run on this CPU.

e.g. the following behavior of the load-balancer would be wrong (migth
have been possible with the 'old' scheduler/ load-balancer):

- task_1 is placed on CPU_N upon a wake-up with wake_idle();

- however, there were task_2 (currently running) and task_3 (pending) on CPU_M;

- task_3 was able to run on CPU_N _but_ has not been considered by the
load-balancer yet (let's say CPU_M became free just a moment ago, not
enough for the load-balancer to notice it).

i.e. task_1 gets ahead of task_3, although both have equal prios and
both are able to run on this cpu.

yeah, enough speculations :-)

>
>> Anyway, the original (and my rework) algorithm is somewhat
>> sub-optimal. It considers only "p->rt.nr_cpus_allowed == 1", while the
>> ideal algorithm would behave as follows:
>>
>> 1) we get a newly woken-up task on CPU_i;
>>
>> 2) this task have a number (!= 1) of allowed CPUs (which is a sub-set
>> of all) _but_ all of them are busy at the moment serving high prio
>> tasks;
>
> I don't understand the significance of the stipulation that its a "sub-set of all".  Can you elaborate?  Or did you mean to say "it *may* be a sub-set of all"?

it should have been "rt_se->nr_cpus_allowed not _necessarily_ equal to
1", meaning rt_se->nr_cpus_allowed is a sub-set of ALL_CPUS, not
strictly a single cpu.

We consider a task to be "bound" if

"rt_se->nr_cpus_allowed == 1"

i.e. a task needs to be bound to a _single_ cpu.

what I mean is e.g.

say, there are 4 cpus and cpu_0 and cpu_1 are busy serving task_0 and task_1;

there are also task_3 and task_4 which have equal prios _but_ lower
(worse) than those of task_0 and task_1.

task_3 can run on _any_ cpu but task_4 can run only on 2 of them --
cpu_1 and cpu_3.

task_3 is running on cpu_3

task_4 is woken up... with your/mine implementation it won't get cpu_3
as it's _not_ considered "bound" (rt_se->nr_cpus_allowed == 2)

while in fact, task_4 still might have been preempted and moved onto cpu_4.

that's why I called the current (mine is similar)
definition/implementation of "bound" (or "non-migratable" in my terms
above) sub-optimal.

hope it's clear now (and none of the important details are escaping me) :-)


>> All in all, I think that the initial implementation is sub-optimal
>
> Ouch :)

ok, mine is no way better :-)

repeating myself, they address just a specific case
(rt_se->nr_cpus_allowed == 1) of the broader "problem" which I
describe above.


>
> Regards,
> -Greg
>

-- 
Best regards,
Dmitry Adamushko
