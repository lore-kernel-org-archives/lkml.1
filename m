Return-Path: <linux-kernel-owner+w=401wt.eu-S1762774AbZCQG2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774AbZCQG2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZCQG2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:28:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51373 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbZCQG2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:28:00 -0400
Message-ID: <49BF42FB.4030103@cn.fujitsu.com>
Date: Tue, 17 Mar 2009 14:28:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in	cpuacct_charge()
 safe when rcupreempt is used.
References: <20090317061754.GD3314@in.ibm.com>
In-Reply-To: <20090317061754.GD3314@in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> 	rcupreempt is used.
> 
> cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> This can race with the task's movement between cgroups. This race
> can cause an access to freed ca pointer in cpuacct_charge(). This will not

Actually it can also end up access invalid tsk->cgroups. ;)

get tsk->cgroups (cg)
                         (move tsk to another cgroup) or (tsk exiting)
                         -> kfree(tsk->cgroups)
get cg->subsys[..]

> happen with rcu or tree rcu as cpuacct_charge() is called with preemption
> disabled. However if rcupreempt is used, the race still exists. Thanks to
> Li Zefan for explaining this.
> 
> Fix this race by explicitly protecting ca and the hierarchy walk with
> rcu_read_lock().
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9891,6 +9891,13 @@ static void cpuacct_charge(struct task_s
>  		return;
>  
>  	cpu = task_cpu(tsk);
> +
> +	/*
> +	 * preemption is already disabled here, but to be safe with
> +	 * rcupreempt, take rcu_read_lock(). This protects ca and
> +	 * hence the hierarchy walk.
> +	 */
> +	rcu_read_lock();
>  	ca = task_ca(tsk);
>  
>  	do {
> @@ -9898,6 +9905,7 @@ static void cpuacct_charge(struct task_s
>  		*cpuusage += cputime;
>  		ca = ca->parent;
>  	} while (ca);
> +	rcu_read_unlock();
>  }
>  
>  struct cgroup_subsys cpuacct_subsys = {
> 
> 
