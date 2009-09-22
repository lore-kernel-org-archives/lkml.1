Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZIVLF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZIVLF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZIVLF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:05:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:56054 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbZIVLFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:05:25 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253615424.20345.76.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Sep 2009 13:05:10 +0200
Message-Id: <1253617510.7695.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 12:30 +0200, Raistlin wrote:

> Some notes about the implementation, on which we are open to comments
> and suggestions:
> 
>  * It implements the well-known Earliest Deadline First (EDF) algorithm

Might be good to mention here that the current implementation is fully
partitioned, but you're striving to make it global-ish.

>  * It does not make any restrictive assumption about the characteristics
>    of the tasks: it can handle periodic, sporadic or aperiodic tasks
>    (see below)

sched_param_ex seems to only contain two of the three sporadic task
model parameters ;-)

>  * We decided to put the new scheduling class in between sched_rt and
>    sched_fair, for the following reasons:

I'd argue to put it above rt, since having it below renders any
guarantees void, since you have no idea about how much time is actually
available.

>    - Backward compatibility and (POSIX) standard compliance require
>      SCHED_FIFO/SCHED_RR tasks to run as soon as they can

In short, sod POSIX.

Simply define 'as soon as they can' to exclude EDF time ;-)

>    - Since EDF is more efficient than fixed-priority in terms of
>      schedulability, it will be easier for it to achieve high
>      utilization even if it runs in the idle time of fixed-priority,
>      than vice-versa
> 
>    - Real-time analysis techniques already exist to deal with exactly
>      such scheduling architecture
> 
>    - The amount of interference coming from system SCHED_FIFO/SCHED_RR
>      tasks can be accounted as system overhead
> 
>    - In recent kernels, the bandwidth used by the whole sched_rt
>      scheduling class can be forced to stay below a certain threshold

The only two tasks that need to be the absolute highest priority are
kstopmachine and migrate, so those would need to be lifted above EDF,
the rest is not important :-)

>  * It works natively on multicore platform. We have one runqueue for
>    each CPU, implemented with a red-black tree, for efficient
>    manipulation. 
>  
>  * We will migrate the tasks among the runqueues trying to always have,
>    on a system with m CPUs, the m earliest deadline ready tasks running
>    on the CPUs.
>    This is not present in the attached patch, but will be available
>    soon.

Ah, ok, so now its fully paritioned, but you'll add that push-pull logic
to make it 'global-ish'.

That should be done at the root_domain level, so that cpusets still work
as expected.

>  * Tasks are not migrated if a specific CPU affinity has been set.
>    Affinity can be set using existing Linux mechanisms (i.e.,
>    sched_setaffinity() for tasks and cpuset.cpus for task groups). Thus,
>    it is sufficient that each EDF task in the system has its affinity
>    set, to achieve a partitioned scheduling with very few overhead.
> 
>  * The API for tasks uses an additional system call, called
>    sched_setscheduler_ex(...), to assign and modify the scheduling
>    parameters described above (i.e., sched_runtime and sched_period).
>    The existing system call sched_setscheduler() has not been extended,
>    because of the binary compatibility issues that modifying its struct
>    sched_param parameter would have raised for existing applications. So
>    we implemented an additional syscall. The system call has the
>    following prototype:
> 
>    #define SCHED_EDF 6
> 
>    struct sched_param_ex {
>        int sched_priority; /* Backward compliance */
>        struct timespec sched_edf_period;
>        struct timespec sched_edf_runtime;
>    };
> 
>    int sched_setscheduler_ex (pid_t pid, int policy, struct sched_param_ex *param);
>   
>    for the sake of consistency, also sched_setaparam_ex() and
>    sched_getparam_ex() have been implemented.

There should also be a sys_sched_getscheduler_ex(), the get part of the
existing interface is what stops us from extending the sched_param bits
we have.

>  * We did not add any further system call to allow periodic tasks to
>    specify the end of the current instance, and the semantics of the
>    existing sched_yield() system call has been extended for this
>    purpose.

OK, so a wakeup after a yield, before a period elapses also raises some
warning/exception/signal thing?

>  * It is integrated with the cgroups filesystem, so it's possible to
>    assign a reservation to a group of tasks and make hierarchical
>    scheduling.
>    The cgroups interface provides two entries, cpu.edf_runtime_us and
>    cpu.edf_period_us. These files are created once the cgroup filesystem
>    is mounted, to get and set the group bandwidth. 

Nice.

>  * In case a SCHED_EDF tasks forks, parent's budget is split among
>    parent and child.

Right, I guess there's really nothing else you can do here...


Haven't looked at the code yet,. hope to do so shortly.

Thanks!
