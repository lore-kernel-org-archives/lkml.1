Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbYA2UnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbYA2UnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbYA2UnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:43:10 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:35194 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbYA2UnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:43:08 -0500
Message-Id: <479F4812.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 13:36:50 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Paul Jackson" <pj@sgi.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <rostedt@goodmis.org>, <menage@google.com>, <rientjes@google.com>,
       <tong.n.li@intel.com>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, <sgrubb@redhat.com>,
       <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
       <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <1201607401.28547.124.camel@lappy> <479F0507.BA47.005A.0@novell.com>
 <20080129105104.d70f36ef.pj@sgi.com> <479F1A4F.BA47.005A.0@novell.com>
 <20080129130403.92d0a1fe.pj@sgi.com>
In-Reply-To: <20080129130403.92d0a1fe.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at  2:04 PM, in message
<20080129130403.92d0a1fe.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Gregory wrote:
>> IMHO it works well the way it is:  The user selects the class for a
>> particular task using sched_setscheduler(), and they select the cpuset
>> (or inherit it) that defines its execution scope.  If that scope has
>> balancing enabled, the policy for the member classes is in effect.
> 
> Ok.
> 
> For the various classes of schedulers (sched_class's), it's fine by me
> if sched domains are polymorphic, supporting all classes, and it is
> left to each task to self-select the scheduling class of its preference.
> 
> For the batch scheduler case, this -must- be imposable from outside
> the task, by the batch scheduler that is overseeing the job, and it
> must support the batch scheduler being able to disable all the
> balancers in selected cpusets (selected sched_domains).
> 
> We have that now.  Each of us only knew of part of the solution,
> but we managed to arrive at the desired answer even so ... amazing.
> 
> The batch scheduler just has to arrange to get 'sched_load_balance'
> turned off in a cpuset and all overlapping cpusets, and then the
> CPUS in that cpuset will not belong to -any- sched_domain, and hence
> (could you verify I'm right in this detail?) won't be balanced by any
> sched_class.

I am a little fuzzy on how this would work, so I cant say for certain.  :) But it seems like that is accurate.


> 
> I should update the documentation for sched_load_balance, changing it
> from saying that you get realtime by turning off sched_load_balance in
> the RT cpuset, to saying that you get realtime by (1) turning off
> sched_load_balance in any overlapping cpusets, including all
> encompassing parent cpusets, (2) leaving sched_load_balance on in the
> RT cpuset itself, and (3) having those realtime tasks each self-select
> (elect) the desired SCHED_* using sched_setscheduler().
> 
> Condition (1) above is a tad difficult to understand, but servicable,
> I guess.  The combination of (1) and (2) results in a separate
> sched_domain just for the CPUs in the RT cpuset.

Technically you only need (2).  I run my 4-8 core development systems in the single default global cpuset, normally.  Customers typically do use multiple sets, but we only use the vanilla balanced variety.

> 
>> (on this topic, note that I do not know if the RT-balancer will
>> respect the cpuset concept of "balance-enabled" anyway.  That might
>> have to be fixed)
> 
> Er eh ... it has no choice.  If the user space code has configured a
> cpuset with 'sched_load_balance' turned off in that cpuset and all
> overlapping cpusets, then there will not even be a sched_domain
> covering those CPUs, and hence no balancer, RT or other class, will
> even see those CPUs.
> 
> Unless I really don't understand the kernel/sched.c sched_domain code
> (a distinct possibility), if some CPU is not in any sched_domain, then
> it won't get balanced, RT or otherwise.

Heh...I cant quite wrap my head around that, but it sounds like you are correct.  The only thing I was really pointing out is that the RT code doesn't necessarily look at sched-domain flags before making balancing decisions.  So as long as that is not a requirement, I think we are all set.




