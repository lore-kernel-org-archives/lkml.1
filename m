Return-Path: <linux-kernel-owner+w=401wt.eu-S1765576AbYA2P53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765576AbYA2P53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYA2P5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:57:19 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:27817 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbYA2P5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:57:18 -0500
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 10:57:18 EST
Message-Id: <479F0507.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 08:50:47 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Paul Jackson" <pj@sgi.com>
Cc: <mingo@elte.hu>, <dmitry.adamushko@gmail.com>, <rostedt@goodmis.org>,
       <menage@google.com>, <rientjes@google.com>, <tong.n.li@intel.com>,
       <tglx@linutronix.de>, <akpm@linux-foundation.org>,
       <dhaval@linux.vnet.ibm.com>, <vatsa@linux.vnet.ibm.com>,
       <sgrubb@redhat.com>, <linux-kernel@vger.kernel.org>,
       <ebiederm@xmission.com>, <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <1201607401.28547.124.camel@lappy>
In-Reply-To: <1201607401.28547.124.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at  6:50 AM, in message
<1201607401.28547.124.camel@lappy>, Peter Zijlstra <a.p.zijlstra@chello.nl>
wrote: 

> On Tue, 2008-01-29 at 05:30 -0600, Paul Jackson wrote:
>> Peter wrote, in reply to Peter ;):
>> > > [ It looks to me it balances a group over the largest SD the current cpu
>> > >   has access to, even though that might be larger than the SD associated
>> > >   with the cpuset of that particular cgroup. ]
>> > 
>> > Hmm, with a bit more thought I think that does indeed DTRT. Because, if
>> > the cpu belongs to a disjoint cpuset, the highest sd (with
>> > load-balancing enabled) would be that. Right?
>> 
>> The code that defines sched domains, kernel/sched.c 
> partition_sched_domains(),
>> as called from the cpuset code in kernel/cpuset.c rebuild_sched_domains(),
>> does not make use of the full range of sched_domain possibilities.
>> 
>> In particular, it only sets up some non-overlapping set of sched domains.
>> Every CPU ends up in at most a single sched domain.
> 
> Ah, good to know. I thought it would reflect the hierarchy of the sets
> themselves.
> 
>> The original reason that one can't define overlapping sched domains via
>> this cpuset interface (based off the cpuset 'sched_load_balance' flag)
>> is that I didn't realize it was even possible to overlap sched domains
>> when I wrote the cpuset code defining sched domains.  And then when I
>> later realized one could overlap sched domains, I (a) didn't see a need
>> to do so, and (b) couldn't see how to do so via the cpuset interface
>> without causing my brain to explode.
> 
> Good reason :-), this code needs all the reasons it can grasp to not
> grow more complexity.
> 
>> Now, back to Peter's question, being a bit pedantic, CPUs don't belong
>> to disjoint cpusets, except in the most minimal situation that there is
>> only one cpuset covering all CPUs.
>> 
>> Rather what happens, when you have need for some realtime CPUs, is that:
>>  1) you turn off sched_load_balance on the top cpuset,
>>  2) you setup your realtime cpuset as a child cpuset of the top cpuset
>>     such that its CPUs doesn't overlap any of its siblings, and
>>  3) you turn off sched_load_balance in that realtime cpuset.
> 
> Ah, I don't think 3 is needed. Quite to the contrary, there is quite a
> large body of research work covering the scheduling of (hard and soft)
> realtime tasks on multiple cpus.

This is correct.  We have the balance policy polymorphically associated with each sched_class, and the CFS load-balancer and RT "load" (really, priority) balancer can coexist together at the same time and across arbitrary #s of cores.  From an RT perspective, this works great.  Its a little trickier (and I dont think we have this quite right, yet) for the CFS side, since that interface deals strictly in terms of load.  As such, it gets a little perturbed by these "rude" RT tasks that arbitrarily preempt its tasks.  :)  I think Steven may have done some work in that area by playing with the associated weight of RT tasks, etc so that the CFS balancer can more accurate account for the externally managed RT load on the system.   But AFAIK, its not in the tree yet. 


> 
>> At that point, sched domains are rebuilt, including providing a
>> sched domain that just contains the CPUs in that realtime cpuset, and
>> normal scheduler load balancing ceases on the CPUs in that realtime
>> cpuset.
> 
> Right, which would also disable the realtime load-balancing we do want.
> Hence my suggestion to stick the rt balance data in this sched domain.
> 
>> > [ Just a bit of a shame we have all cgroups represented on each cpu. ]
>> 
>> Could you restate this -- I suspect it's obvious, but I'm oblivious ;).
> 
> Ah, sure. struct task_group creates cfs_rq/rt_rq entities for each cpu's
> runqueue. So an iteration like for_each_leaf_{cfs,rt}_rq() will touch
> all task_groups/cgroups, not only those that are actually schedulable on
> that cpu.
> 
> Now, I think that could be easily solved by adding/removing
> {cfs,rt}_rq->leaf_{cfs,rt}_rq_list to/from rq->leaf_{cfs,rt}_rq_list on
> enqueue of the first/dequeue of the last entity of its tg on that rq.


