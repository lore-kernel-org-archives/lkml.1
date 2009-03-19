Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZCSJUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZCSJUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCSJUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:20:35 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:11191 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZCSJUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:20:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
 cpuacct_charge() safe when rcupreempt is used.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090317073649.GH3314@in.ibm.com>
References: <20090317061754.GD3314@in.ibm.com>
	 <49BF42FB.4030103@cn.fujitsu.com>  <20090317073649.GH3314@in.ibm.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 10:20:21 +0100
Message-Id: <1237454421.7867.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 13:06 +0530, Bharata B Rao wrote:
> On Tue, Mar 17, 2009 at 02:28:11PM +0800, Li Zefan wrote:
> > Bharata B Rao wrote:
> > > cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> > > 	rcupreempt is used.
> > > 
> > > cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> > > This can race with the task's movement between cgroups. This race
> > > can cause an access to freed ca pointer in cpuacct_charge(). This will not
> > 
> > Actually it can also end up access invalid tsk->cgroups. ;)
> > 
> > get tsk->cgroups (cg)
> >                          (move tsk to another cgroup) or (tsk exiting)
> >                          -> kfree(tsk->cgroups)
> > get cg->subsys[..]
> 
> Ok :) Here is the patch again with updated description.
> 
> cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> 	rcupreempt is used.
> 
> cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> This can race with the task's movement between cgroups. This race
> can cause an access to freed ca pointer in cpuacct_charge() or access
> to invalid cgroups pointer of the task. This will not happen with rcu or
> tree rcu as cpuacct_charge() is called with preemption disabled. However if
> rcupreempt is used, the race is seen. Thanks to Li Zefan for explaining this.
> 
> Fix this race by explicitly protecting ca and the hierarchy walk with
> rcu_read_lock().
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

I would ditch the comment, it doesn't add anything.

The simple rule is: if you want RCU-safe, use rcu_read_lock().
preempt/irq disable isn't sufficient -- hasn't been for a long long
while.

After that,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

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

