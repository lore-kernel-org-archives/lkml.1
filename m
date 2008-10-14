Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbYJNMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbYJNMJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYJNMJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:09:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:49359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbYJNMJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:09:28 -0400
Subject: Re: [RFC PATCH v2 0/5] sched: modular find_busiest_group()
From: Peter Zijlstra <peterz@infradead.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, arjan <arjan@infradead.org>
In-Reply-To: <1223561968.7382.42.camel@lappy.programming.kicks-ass.net>
References: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
	 <1223561968.7382.42.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 14:09:13 +0200
Message-Id: <1223986153.9557.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

So the basic issue is sched_group::cpu_power should become more dynamic.

There are two driving factors:
- RT time consumption feedback into CFS
- dynamic per-cpu power manangement like Intel's Dynamic Speed
Technology (formerly know as Turbo Mode).

We currently have sched_group::cpu_power to model SMT. We say that
multiple threads that share a core are not as powerful as two cores.

Therefore, we move a task when doing so results in more of that power
being utilized, resulting in preferring to run tasks on full cores
instead of SMT siblings.


RT time
-------

So the basic issue is that we cannot know how much cpu-time will be
consumed by RT tasks (we used to relate that to the number of running
tasks, but that's utter nonsense).

Therefore the only way is to measure it and assume the near future looks
like the near past.

So why is this an issue.. suppose we have 2 cpus, and 1 cpu is consumed
for 50% by RT tasks, while the other is fully available to regular
tasks.

In that case we'd want to load-balance such that the cpu affected by the
RT task(s) gets half the load the other cpu has.

[ I tried modelling this by scaling the load of cpus up, but that fails
to handle certain cases - for instance 100% RT gets real funny, and it
fails to properly skip the RT-loaded cores in the low-load situation ]

Dynamic Speed Technology
------------------------

With cpus actively fiddling with their processing capacity we get into
similar issues. Again we can measure this, but this would require the
addition of a clock that measures work instead of time.

Having that, we can even acturately measure the old SMT case, which has
always been approximated by a static percentage - even though the actual
gain is very workload dependent.

The idea is to introduce sched_work_clock() so that:

        work_delta / time_delta gives the power for a cpu. <1 means we
        did less work than a dedicated pipeline, >1 means we did more.

So, if for example our core's canonical freq would be 2.0GHz but we get
boosted to 2.2GHz while the other core would get lowered to 1.8GHz we
can observe and attribute this asymetric power balance.

[ This assumes that the total power is preserved for non-idle situations
- is that true?, if not this gets real interesting ]

Also, an SMT thread, when sharing the core with its sibling will get <1,
but together they might be >1.


Funny corner cases
------------------

Like mentioned in the RT time note, there is the possiblity that a core
has 0 power (left) for SCHED_OTHER. This has a consequence for the
balance cpu. Currently we let the first cpu in the domain do the
balancing, however if that CPU has 0 power it might not be the best
choice (esp since part of the balancing can be done from softirq context
- which would basically starve that group).



Sched domains
-------------

There seems to be a use-case where we need both the cache and the
package levels. So I wanted to have both levels in there.

Currently each domain level can only be one of:

SD_LV_NONE = 0,
SD_LV_SIBLING,
SD_LV_MC,
SD_LV_CPU,
SD_LV_NODE,
SD_LV_ALLNODES,

So to avoid a double domain with 'native' multi-core chips where the
cache and package level have the same span, I want to encode this
information in the sched_domain::flags as bits, which means a level can
be both cache and package.


Over balancing
--------------

Lastly, we might need to introduce SD_OVER_BALANCE, which toggles the
over-balance logic. While over-balancing brings better fairness for a
number of cases, its also hard on power savings.




