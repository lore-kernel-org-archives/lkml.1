Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYFKKFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYFKKFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYFKKF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:05:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:39348 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYFKKF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IKtsGLIcNYZUN1e2tlPJmGACbQpczQzjNh3fTKjh3UNKWSRCk1S3RxwRK1ULJr/MLV
         YBvSCAgt84UVbL2fSnrK//DmPveRYvrVX7135WC3enDJQ0TF3Go3+yVohJSL7TflhGVc
         BAQoJ9HzwBvRnynpYuBKjFkOxsyFw8dnpHscY=
Message-ID: <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
Date: Wed, 11 Jun 2008 12:05:26 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable tasks over migratable ones"
Cc: "Gregory Haskins" <ghaskins@novell.com>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1213174382.31518.69.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213138710.26530.51.camel@earth> <1213174382.31518.69.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/11 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2008-06-11 at 00:58 +0200, Dmitry Adamushko wrote:
>> Hi Gregory,
>>
>>
>> regarding this commit: 45c01e824991b2dd0a332e19efc4901acb31209f
>>
>>
>> I think we can do it simpler. Please take a look at the patch below.
>>
>> Instead of having 2 separate arrays (which is + ~800 bytes on x86_32 and twice so on x86_64),
>> let's add "exclusive" (the ones that are bound to this CPU) tasks to the head of the queue
>> and "shared" ones -- to the end.
>>
>> In case of a few newly woken up "exclusive" tasks, they are 'stacked' (not queued as now), meaning that
>> a task {i+1} is being placed in front of the previously woken up task {i}. But I don't think that
>> this behavior may cause any realistic problems.
>
> Doesn't this violate POSIX ?
>

If so, then the idea of "prioritize non-migratable tasks over
migratable ones" violates it, not just an artefact of this particular
implementation.

No matter which implementation is used, we have a situation when a
woken-up single-CPU-bound task (let's call it 'p') can preempt a
current task with effects as follows:

- 'current' is not guaranteed to get another CPU;

- there might have been other pending tasks (of equal prio) on this
queue. As a result, 'p' starts running before them violating currently
used (explicitly requested by POSIX?) round-robin behavior.

Anyway, the original (and my rework) algorithm is somewhat
sub-optimal. It considers only "p->rt.nr_cpus_allowed == 1", while the
ideal algorithm would behave as follows:

1) we get a newly woken-up task on CPU_i;

2) this task have a number (!= 1) of allowed CPUs (which is a sub-set
of all) _but_ all of them are busy at the moment serving high prio
tasks;

3) there are no other pending tasks on the queue (of equal prio) that
are in the same condition as 'p' (that's they can't be migrated to
other CPUs at the moment and to wait for CPU_i is the 'best' effort
for them);

4) 'current' is guaranteed to start running immediatelly on another
CPU (apparently, its affinity allows CPUs that can be used neither by
'p', nor by tasks from (3) ), should we preempt it now.

5) then let 'p' preempt 'current'.

We do cause some 'troubles' (in a way of 'cache' efficienty) for the
'current' but probably we win CPU-time-distribution-wise.

Note, hard real-time tasks would not like to find themselves in the
aforemnetioned situation. But then, one probably should have initially
taken care of assigning different prios or better off, isolating
dedicated CPUs for some tasks wrt how much CPU-time they
consume/latency they expect.


All in all, I think that the initial implementation is sub-optimal in
any case and it's not worth introducing additional overhead (another
priority queue array) to address this issue (which is kind of a corner
case).

We may just consider dropping this idea completely.
(my 0.02$)

-- 
Best regards,
Dmitry Adamushko
