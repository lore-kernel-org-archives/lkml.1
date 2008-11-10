Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbYKJKWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbYKJKWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYKJKWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:22:12 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:55194 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbYKJKWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:22:11 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
 controller
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081104124937.GB4898@in.ibm.com>
References: <20081024050830.GA4387@in.ibm.com>
	 <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
	 <20081025060157.GA4614@in.ibm.com>
	 <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>
	 <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081027044319.GA4386@in.ibm.com>
	 <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com>
	 <49057ADD.1050705@cn.fujitsu.com>
	 <20081030171622.GA19872@linux.vnet.ibm.com>
	 <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081104124937.GB4898@in.ibm.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 11:22:41 +0100
Message-Id: <1226312561.2697.4093.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 18:19 +0530, Bharata B Rao wrote:

> Add hierarchical accounting to cpu accounting controller and cpuacct
> documentation.
> 
> Currently, while charging the task's cputime to its accounting group,
> the accounting group hierarchy isn't updated. This patch charges the cputime
> of a task to its accounting group and all its parent accounting groups.
> 
> Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Reviewed-by: Paul Menage <menage@google.com>

Seems sane and simple enough.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo?

> ---
>  Documentation/controllers/cpuacct.txt |   32 ++++++++++++++++++++++++++++++++
>  kernel/sched.c                        |   10 ++++++++--
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> --- /dev/null
> +++ b/Documentation/controllers/cpuacct.txt
> @@ -0,0 +1,32 @@
> +CPU Accounting Controller
> +-------------------------
> +
> +The CPU accounting controller is used to group tasks using cgroups and
> +account the CPU usage of these group of tasks.
> +
> +The CPU accounting controller supports multi-hierarchy groups. An accounting
> +group accumulates the CPU usage of all of it's child groups and
> +the tasks directly present in it's group.
> +
> +Accounting groups can be created by first mounting the cgroup filesystem.
> +
> +# mkdir /cgroups
> +# mount -t cgroup -ocpuacct none /cgroups
> +
> +With the above step, the initial or the parent accounting group
> +becomes visible at /cgroups. At bootup, this group comprises of all the
> +tasks in the system. /cgroups/tasks lists the tasks in this cgroup.
> +/cgroups/cpuacct.usage gives the CPU time (in nanoseconds) obtained by
> +this group which is essentially the CPU time obtained by all the tasks
> +in the system.
> +
> +New accounting groups can be created under the parent group /cgroups.
> +
> +# cd /cgroups
> +# mkdir g1
> +# echo $$ > g1
> +
> +The above steps create a new group g1 and move the current shell
> +process (bash) into it. CPU time consumed by this bash and it's children
> +can be obtained from g1/cpuacct.usage and the same gets accumulated in
> +/cgroups/cpuacct.usage also.
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9236,6 +9236,7 @@ struct cpuacct {
>  	struct cgroup_subsys_state css;
>  	/* cpuusage holds pointer to a u64-type object on every cpu */
>  	u64 *cpuusage;
> +	struct cpuacct *parent;
>  };
>  
>  struct cgroup_subsys cpuacct_subsys;
> @@ -9269,6 +9270,9 @@ static struct cgroup_subsys_state *cpuac
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> +	if (cgrp->parent)
> +		ca->parent = cgroup_ca(cgrp->parent);
> +
>  	return &ca->css;
>  }
>  
> @@ -9348,14 +9352,16 @@ static int cpuacct_populate(struct cgrou
>  static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>  {
>  	struct cpuacct *ca;
> +	int cpu;
>  
>  	if (!cpuacct_subsys.active)
>  		return;
>  
> +	cpu = task_cpu(tsk);
>  	ca = task_ca(tsk);
> -	if (ca) {
> -		u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk));
>  
> +	for (; ca; ca = ca->parent) {
> +		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
>  		*cpuusage += cputime;
>  	}
>  }


