Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXJCLib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXJCLib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbXJCLiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:38:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48593 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755482AbXJCLiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:38:23 -0400
Date: Wed, 3 Oct 2007 04:38:18 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003043818.baa0e1ce.pj@sgi.com>
In-Reply-To: <200710030356.18090.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710030209.56879.nickpiggin@yahoo.com.au>
	<20071003025518.7c184905.pj@sgi.com>
	<200710030356.18090.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, so to really do anything different (from a non-partitioned setup),
> you would need to set sched_load_balance=0 for the root cpuset?

Yup - exactly.  In fact one code fragment in my patch highlights this:

        /* Special case for the 99% of systems with one, full, sched domain */
        if (is_sched_load_balance(&top_cpuset)) {
                ndoms = 1;
                doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
                *doms = top_cpuset.cpus_allowed;
                goto rebuild;
        }

This code says: if the top cpuset is load balanced, you've got one
big fat sched domain covering all (nonisolated) CPUs - end of story.
None of the other 'sched_load_balance' flags matter in this case.

Logically, the above code fragment is not needed.  Without it, the
code would still do the same thing, just wasting more CPU cycles doing
it.

> Suppose you do that to hard partition the machine, what happens to
> newly created tasks like kernel threads or things that aren't in a
> cpuset?

Well ... --every-- task is in a cpuset, always.  Newly created tasks
start in the cpuset of their parent.  Grep for 'the_top_cpuset_hack'
in kernel/cpuset.c to see the lengths to which we go to ensure that
current->cpuset always resolves somewhere.

The usual case on the big systems that I care about the most is
that we move (almost) every task out of the top cpuset, into smaller
cpusets, because we don't want some random thread intruding on the
CPUs dedicated to a particular job.  The only threads left in the root
cpuset are pinned kernel threads, such as for thread migration, per-cpu
irq handlers and various per-cpu and per-node disk and file flushers
and such.  These threads aren't going anywhere, regardless.  But no
thread that is willing to run anywhere is left free to run anywhere.

I will advise my third party batch scheduler developers to turn off
sched_load_balance on their main cpuset, and on any big "holding tank"
cpusets they have which hold only inactive jobs.  This way, on big
systems that are managed to optimize for this, the kernel scheduler
won't waste time load balancing the batch schedulers big cpusets that
don't need it.  With the 'sched_load_balance' flag defined the way
it is, the batch scheduler won't have to make system-wide decisions
as to sched domain partitioning.  They can just make local 'advisory'
markings on particular cpusets that (1) are or might be big, and (2)
don't hold any active tasks that might need load balancing.  The system
will take it from there, providing the finest granularity sched domain
partitioning that will accomplish that.

I will advise the system admins of bigger systems to turn off
sched_load_balance on the top cpuset, as part of the above work
routinely done to get all non-pinned tasks out of the top cpuset.

I will advise the real time developers using cpusets to: (1) turn off
sched_load_balance on their real time cpusets, and (2) insist that
the sys admins using their products turn off sched_load_balance on
the top cpuset, to ensure the expected realtime performance is obtained.

Most systems, even medium size ones (for some definition of medium,
perhaps dozens of CPUs?) so long as they aren't running realtime on
some CPUs, can just run with the default - one big fat load balanced
sched domain ... unless of course they have some other need not
considered above.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
