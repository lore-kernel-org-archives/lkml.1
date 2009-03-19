Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZCSJnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZCSJnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZCSJnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:43:00 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47573 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZCSJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:42:59 -0400
Date: Thu, 19 Mar 2009 15:13:17 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used.
Message-ID: <20090319094317.GC3303@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090317061754.GD3314@in.ibm.com> <49BF42FB.4030103@cn.fujitsu.com> <20090317073649.GH3314@in.ibm.com> <1237454421.7867.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237454421.7867.27.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:20:21AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-03-17 at 13:06 +0530, Bharata B Rao wrote:
> > On Tue, Mar 17, 2009 at 02:28:11PM +0800, Li Zefan wrote:
> > > Bharata B Rao wrote:
> > > > cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> > > > 	rcupreempt is used.
> > > > 
> > > > cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> > > > This can race with the task's movement between cgroups. This race
> > > > can cause an access to freed ca pointer in cpuacct_charge(). This will not
> > > 
> > > Actually it can also end up access invalid tsk->cgroups. ;)
> > > 
> > > get tsk->cgroups (cg)
> > >                          (move tsk to another cgroup) or (tsk exiting)
> > >                          -> kfree(tsk->cgroups)
> > > get cg->subsys[..]
> > 
> > Ok :) Here is the patch again with updated description.
> > 
> > cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> > 	rcupreempt is used.
> > 
> > cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> > This can race with the task's movement between cgroups. This race
> > can cause an access to freed ca pointer in cpuacct_charge() or access
> > to invalid cgroups pointer of the task. This will not happen with rcu or
> > tree rcu as cpuacct_charge() is called with preemption disabled. However if
> > rcupreempt is used, the race is seen. Thanks to Li Zefan for explaining this.
> > 
> > Fix this race by explicitly protecting ca and the hierarchy walk with
> > rcu_read_lock().
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> I would ditch the comment, it doesn't add anything.
> 
> The simple rule is: if you want RCU-safe, use rcu_read_lock().
> preempt/irq disable isn't sufficient -- hasn't been for a long long
> while.
> 
> After that,
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 

Ok. Removed the comment. Here is the updated patch.

cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
	rcupreempt is used.

cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
This can race with the task's movement between cgroups. This race
can cause an access to freed ca pointer in cpuacct_charge() or access
to invalid cgroups pointer of the task. This will not happen with rcu or
tree rcu as cpuacct_charge() is called with preemption disabled. However if
rcupreempt is used, the race is seen. Thanks to Li Zefan for explaining this.

Fix this race by explicitly protecting ca and the hierarchy walk with
rcu_read_lock().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9894,6 +9894,8 @@ static void cpuacct_charge(struct task_s
 		return;
 
 	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
 	ca = task_ca(tsk);
 
 	do {
@@ -9901,6 +9903,7 @@ static void cpuacct_charge(struct task_s
 		*cpuusage += cputime;
 		ca = ca->parent;
 	} while (ca);
+	rcu_read_unlock();
 }
 
 struct cgroup_subsys cpuacct_subsys = {
