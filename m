Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZBSF0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZBSF0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 00:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZBSF0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 00:26:13 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:64195 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZBSF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 00:26:12 -0500
Message-ID: <499CED75.9030907@oracle.com>
Date: Wed, 18 Feb 2009 21:26:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: various documentation fixes and updates
References: <499CBFDF.1070503@cn.fujitsu.com>
In-Reply-To: <499CBFDF.1070503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.499CED43.00BD:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> I noticed the old commit 8f5aa26c75b7722e80c0c5c5bb833d41865d7019
> ("cpusets: update_cpumask documentation fix") is not a complete fix,
> resulting in inconsistent paragraphs. This patch fixes it and does
> other fixes and updates:
> 
> - s/migrate_all_tasks()/migrate_live_tasks()/
> - describe more cpuset control files
> - s/cpumask_t/struct cpumask/
> - document cpu hotplug and change of 'sched_relax_domain_level' may cause
>   domain rebuild
> - document various ways to query or modify cpusets
> - the equivalent of "mount -t cpuset" is "mount -t cgroup -o cpuset,noprefix"
> - fix typos
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  Documentation/cgroups/cpusets.txt |   65 +++++++++++++++++++++----------------
>  1 files changed, 37 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
> index 5c86c25..3543706 100644
> --- a/Documentation/cgroups/cpusets.txt
> +++ b/Documentation/cgroups/cpusets.txt
> @@ -142,7 +142,7 @@ into the rest of the kernel, none in performance critical paths:
>   - in fork and exit, to attach and detach a task from its cpuset.
>   - in sched_setaffinity, to mask the requested CPUs by what's
>     allowed in that tasks cpuset.
> - - in sched.c migrate_all_tasks(), to keep migrating tasks within
> + - in sched.c migrate_live_tasks(), to keep migrating tasks within
>     the CPUs allowed by their cpuset, if possible.
>   - in the mbind and set_mempolicy system calls, to mask the requested
>     Memory Nodes by what's allowed in that tasks cpuset.
> @@ -175,6 +175,10 @@ files describing that cpuset:
>   - mem_exclusive flag: is memory placement exclusive?
>   - mem_hardwall flag:  is memory allocation hardwalled
>   - memory_pressure: measure of how much paging pressure in cpuset
> + - memory_spread_page flag: if set, spread page cache evenly on allowed nodes
> + - memory_spread_slab flag: if set, spread slab cache evenly on allowed nodes
> + - sched_load_balance flag: if set, load balance within CPUs on that cpuset
> + - sched_relax_domain_level: the searching range when migrating tasks
>  
>  In addition, the root cpuset only has the following file:
>   - memory_pressure_enabled flag: compute memory_pressure?
> @@ -252,7 +256,7 @@ is causing.
>  
>  This is useful both on tightly managed systems running a wide mix of
>  submitted jobs, which may choose to terminate or re-prioritize jobs that
> -are trying to use more memory than allowed on the nodes assigned them,
> +are trying to use more memory than allowed on the nodes assigned to them,
>  and with tightly coupled, long running, massively parallel scientific
>  computing jobs that will dramatically fail to meet required performance
>  goals if they start to use more memory than allowed to them.
> @@ -378,7 +382,7 @@ as cpusets and sched_setaffinity.
>  The algorithmic cost of load balancing and its impact on key shared
>  kernel data structures such as the task list increases more than
>  linearly with the number of CPUs being balanced.  So the scheduler
> -has support to  partition the systems CPUs into a number of sched
> +has support to partition the systems CPUs into a number of sched
>  domains such that it only load balances within each sched domain.
>  Each sched domain covers some subset of the CPUs in the system;
>  no two sched domains overlap; some CPUs might not be in any sched
> @@ -485,17 +489,22 @@ of CPUs allowed to a cpuset having 'sched_load_balance' enabled.
>  The internal kernel cpuset to scheduler interface passes from the
>  cpuset code to the scheduler code a partition of the load balanced
>  CPUs in the system. This partition is a set of subsets (represented
> -as an array of cpumask_t) of CPUs, pairwise disjoint, that cover all
> -the CPUs that must be load balanced.
> -
> -Whenever the 'sched_load_balance' flag changes, or CPUs come or go
> -from a cpuset with this flag enabled, or a cpuset with this flag
> -enabled is removed, the cpuset code builds a new such partition and
> -passes it to the scheduler sched domain setup code, to have the sched
> -domains rebuilt as necessary.
> +as an array of struct cpumask) of CPUs, pairwise disjoint, that cover
> +all the CPUs that must be load balanced.
> +
> +The cpuset code builds a new such partition and passes it to the
> +scheduler sched domain setup code, to have the sched domains rebuilt
> +as necessary, whenever:
> + - the 'sched_load_balance' flag of a cpuset with non-empty CPUs changes,
> + - or CPUs come or go from a cpuset with this flag enabled,
> + - or 'sched_relax_domain_level' value of a cpuset with non-empty CPUs
> +   and with this flag enabled changes,
> + - or a cpuset with non-empty CPUs and with this flag enabled is removed,
> + - or a cpu is offlined/onlined.
>  
>  This partition exactly defines what sched domains the scheduler should
> -setup - one sched domain for each element (cpumask_t) in the partition.
> +setup - one sched domain for each element (struct cpumask) in the
> +partition.
>  
>  The scheduler remembers the currently active sched domain partitions.
>  When the scheduler routine partition_sched_domains() is invoked from
> @@ -559,7 +568,7 @@ domain, the largest value among those is used.  Be careful, if one
>  requests 0 and others are -1 then 0 is used.
>  
>  Note that modifying this file will have both good and bad effects,
> -and whether it is acceptable or not will be depend on your situation.
> +and whether it is acceptable or not depends on your situation.
>  Don't modify this file if you are not sure.
>  
>  If your situation is:
> @@ -600,19 +609,15 @@ to allocate a page of memory for that task.
>  
>  If a cpuset has its 'cpus' modified, then each task in that cpuset
>  will have its allowed CPU placement changed immediately.  Similarly,
> -if a tasks pid is written to a cpusets 'tasks' file, in either its
> -current cpuset or another cpuset, then its allowed CPU placement is
> -changed immediately.  If such a task had been bound to some subset
> -of its cpuset using the sched_setaffinity() call, the task will be
> -allowed to run on any CPU allowed in its new cpuset, negating the
> -affect of the prior sched_setaffinity() call.
> +if a tasks pid is written to another cpusets 'tasks' file, then its

        task's pid                      cpuset's

> +allowed CPU placement is changed immediately.  If such a task had been
> +bound to some subset of its cpuset using the sched_setaffinity() call,
> +the task will be allowed to run on any CPU allowed in its new cpuset,
> +negating the affect of the prior sched_setaffinity() call.

                effect

>  
>  In summary, the memory placement of a task whose cpuset is changed is
>  updated by the kernel, on the next allocation of a page for that task,
> -but the processor placement is not updated, until that tasks pid is
> -rewritten to the 'tasks' file of its cpuset.  This is done to avoid
> -impacting the scheduler code in the kernel with a check for changes
> -in a tasks processor placement.
> +and the processor placement is updated immediately.
>  
>  Normally, once a page is allocated (given a physical page
>  of main memory) then that page stays on whatever node it
> @@ -681,10 +686,14 @@ and then start a subshell 'sh' in that cpuset:
>    # The next line should display '/Charlie'
>    cat /proc/self/cpuset
>  
> -In the future, a C library interface to cpusets will likely be
> -available.  For now, the only way to query or modify cpusets is
> -via the cpuset file system, using the various cd, mkdir, echo, cat,
> -rmdir commands from the shell, or their equivalent from C.
> +There are ways to query or modify cpusets:
> + - via the cpuset file system directly, using the various cd, mkdir, echo,
> +   cat, rmdir commands from the shell, or there equivalent from C.

                                             their

> + - via the C library libcpuset.
> + - via the C library libcgroup.
> +   (http://sourceforge.net/proects/libcg/)
> + - via the python application cset.
> +   (http://developer.novell.com/wiki/index.php/Cpuset)
>  
>  The sched_setaffinity calls can also be done at the shell prompt using
>  SGI's runon or Robert Love's taskset.  The mbind and set_mempolicy
> @@ -756,7 +765,7 @@ mount -t cpuset X /dev/cpuset
>  
>  is equivalent to
>  
> -mount -t cgroup -ocpuset X /dev/cpuset
> +mount -t cgroup -ocpuset,noprefix X /dev/cpuset

I'm used to "-o options_list"... I guess either is OK.

>  echo "/sbin/cpuset_release_agent" > /dev/cpuset/release_agent
>  
>  2.2 Adding/removing cpus


-- 
~Randy
