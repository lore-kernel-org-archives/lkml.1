Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0BSKGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 05:06:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0BSKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 05:06:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Z/h1O43mIfRfbu+hUcNB4LNRVmTpjkV2Og+rPxLxfYswrFNypc+ElRj80z64iOln7
	aVVV+JGAoxJrYhzKD2R2A==
Date: Fri, 19 Feb 2010 02:06:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Miao Xie <miaox@cn.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <20100219033126.GI9738@laptop>
Message-ID: <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010, Nick Piggin wrote:

> > guarantee_online_cpus() truly does require callback_mutex, the 
> > cgroup_scan_tasks() iterator locking can protect changes in the cgroup 
> > hierarchy but it doesn't protect a store to cs->cpus_allowed or for 
> > hotplug.
> 
> Right, but the callback_mutex was being removed by this patch.
> 

I was making the case for it to be readded :)

> > top_cpuset.cpus_allowed will always need to track cpu_active_map since 
> > those are the schedulable cpus, it looks like that's initialized for SMP 
> > and the cpu hotplug notifier does that correctly.
> > 
> > I'm not sure what the logic is doing in cpuset_attach() where cs is the 
> > cpuset to attach to:
> > 
> > 	if (cs == &top_cpuset) {
> > 		cpumask_copy(cpus_attach, cpu_possible_mask);
> > 		to = node_possible_map;
> > 	}
> > 
> > cpus_attach is properly protected by cgroup_lock, but using 
> > node_possible_map here will set task->mems_allowed to node_possible_map 
> > when the cpuset does not have memory_migrate enabled.  This is the source 
> > of your oops, I think.
> 
> Could be, yes.
> 

I'd be interested to see if you still get the same oops with the patch at 
the end of this email that fixes this logic.

> But it doesn't matter if stores are done under lock, if the loads are
> not. masks can be multiple words, so there isn't any ordering between
> reading half and old mask and half a new one that results in an invalid
> state. AFAIKS.
> 

It doesn't matter for MAX_NUMNODES > BITS_PER_LONG because 
task->mems_alllowed only gets updated via cpuset_change_task_nodemask() 
where the added nodes are set and then the removed nodes are cleared.  The 
side effect of this lockless access to task->mems_allowed means we may 
have a small race between

	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);

		and

	tsk->mems_allowed = *newmems;

but the penalty is that we get an allocation on a removed node, which 
isn't a big deal, especially since it was previously allowed.

> Well it is exported as cpuset_lock(). And the scheduler has it covered
> in all cases by the looks except for select_task_rq, which is called
> by wakeup code. We should stick WARN_ONs through the cpuset code for
> mutexes not held when they should be.
> 

A lot of the reliance on callback_mutex was removed because the strict 
hierarchy walking and task membership is now guarded by cgroup_mutex 
instead.  Some of the comments in kernel/cpuset.c weren't updated so they 
still say callback_mutex when in reality they mean cgroup_mutex.
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1319,7 +1319,7 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
-/* Protected by cgroup_lock */
+/* Protected by cgroup_mutex held on cpuset_attach() */
 static cpumask_var_t cpus_attach;
 
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
@@ -1390,8 +1390,12 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	struct cpuset *oldcs = cgroup_cs(oldcont);
 
 	if (cs == &top_cpuset) {
-		cpumask_copy(cpus_attach, cpu_possible_mask);
-		to = node_possible_map;
+		/*
+		 * top_cpuset.cpus_allowed and top_cpuset.mems_allowed are
+		 * protected by cgroup_lock which is already held here.
+		 */
+		cpumask_copy(cpus_attach, top_cpuset.cpus_allowed);
+		to = top_cpuset.mems_allowed;
 	} else {
 		guarantee_online_cpus(cs, cpus_attach);
 		guarantee_online_mems(cs, &to);
