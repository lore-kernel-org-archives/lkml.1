Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab0BRViZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 16:38:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:19353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0BRViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 16:38:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MMD4FEtSZIU0XjlNN+PzXgY+Eg4f16XLzRP2NsZ5lKc5P633hn7Ug6IFEbqjCofIb
	j+UyYfdOHeU+lQH0mTjUA==
Date: Thu, 18 Feb 2010 13:38:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Miao Xie <miaox@cn.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <20100218134921.GF9738@laptop>
Message-ID: <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010, Nick Piggin wrote:

> Hi,
> 
> The patch cpuset,mm: update tasks' mems_allowed in time (58568d2) causes
> a regression uncovered by SGI. Basically it is allowing possible but not
> online nodes in the task_struct.mems_allowed nodemask (which is contrary
> to several comments still in kernel/cpuset.c), and that causes
> cpuset_mem_spread_node() to return an offline node to slab, causing an
> oops.
> 
> Easy to reproduce if you have a machine with !online nodes.
> 
>         - mkdir /dev/cpuset
>         - mount cpuset -t cpuset /dev/cpuset
>         - echo 1 > /dev/cpuset/memory_spread_slab
> 
> kernel BUG at
> /usr/src/packages/BUILD/kernel-default-2.6.32/linux-2.6.32/mm/slab.c:3271!
> bash[6885]: bugcheck! 0 [1]
> Pid: 6885, CPU 5, comm:                 bash
> psr : 00001010095a2010 ifs : 800000000000038b ip  : [<a00000010020cf00>]
> Tainted: G        W    (2.6.32-0.6.8-default)
> ip is at ____cache_alloc_node+0x440/0x500

It seems like current->mems_allowed is not properly initialized, although 
task_cs(current)->mems_allowed is to node_states[N_HIGH_MEMORY].  See 
below.

> A simple bandaid is to skip !online nodes in cpuset_mem_spread_node().
> However I'm a bit worried about 58568d2.
> 
> It is doing a lot of stuff. It is removing the callback_mutex from
> around several seemingly unrelated places (eg. from around
> guarnatee_online_cpus, which explicitly asks to be called with that
> lock held), and other places, so I don't know how it is not racy
> with hotplug.
> 

guarantee_online_cpus() truly does require callback_mutex, the 
cgroup_scan_tasks() iterator locking can protect changes in the cgroup 
hierarchy but it doesn't protect a store to cs->cpus_allowed or for 
hotplug.

top_cpuset.cpus_allowed will always need to track cpu_active_map since 
those are the schedulable cpus, it looks like that's initialized for SMP 
and the cpu hotplug notifier does that correctly.

I'm not sure what the logic is doing in cpuset_attach() where cs is the 
cpuset to attach to:

	if (cs == &top_cpuset) {
		cpumask_copy(cpus_attach, cpu_possible_mask);
		to = node_possible_map;
	}

cpus_attach is properly protected by cgroup_lock, but using 
node_possible_map here will set task->mems_allowed to node_possible_map 
when the cpuset does not have memory_migrate enabled.  This is the source 
of your oops, I think.

> Then it also says that the fastpath doesn't use any locking, so the
> update-path first adds the newly allowed nodes, then removes the
> newly prohibited nodes. Unfortunately there are no barriers apparent
> (and none added), and cpumask/nodemask can be larger than one word,
> so it seems there could be races.
> 

We can remove the store to tsk->mems_allowed in cpuset_migrate_mm() 
because cpuset_change_task_nodemask() already does it under 
task_lock(tsk).

cpuset_migrate_mm() looks to be subsequently updating the cpuset_attach() 
nodemask when moving to top_cpuset so it doesn't get stuck with 
node_possible_map, but that's not called unless memory_migrate is enabled.

> It also seems like the exported cpuset_mems_allowed and
> cpuset_cpus_allowed APIs are just broken wrt hotplug because the
> hotplug lock is dropped before returning.
> 

The usage of cpuset_cpus_allowed_locked() looks wrong in the scheduler, as 
well: it can't hold callback_mutex since it is only declared at file scope 
in the cpuset code.
