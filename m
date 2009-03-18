Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZCRJhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZCRJhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZCRJgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:36:55 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33841 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZCRJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:36:54 -0400
Date: Wed, 18 Mar 2009 15:06:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used.
Message-ID: <20090318093624.GZ16897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090317061754.GD3314@in.ibm.com> <49BF42FB.4030103@cn.fujitsu.com> <20090317073649.GH3314@in.ibm.com> <20090317131251.GU16897@balbir.in.ibm.com> <20090318031832.GA3960@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090318031832.GA3960@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bharata B Rao <bharata@linux.vnet.ibm.com> [2009-03-18 08:48:32]:

> On Tue, Mar 17, 2009 at 06:42:51PM +0530, Balbir Singh wrote:
> > * Bharata B Rao <bharata@linux.vnet.ibm.com> [2009-03-17 13:06:49]:
> > 
> > > On Tue, Mar 17, 2009 at 02:28:11PM +0800, Li Zefan wrote:
> > > > Bharata B Rao wrote:
> > > > > cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> > > > > 	rcupreempt is used.
> > > > > 
> > > > > cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> > > > > This can race with the task's movement between cgroups. This race
> > > > > can cause an access to freed ca pointer in cpuacct_charge(). This will not
> > > > 
> > > > Actually it can also end up access invalid tsk->cgroups. ;)
> > > > 
> > > > get tsk->cgroups (cg)
> > > >                          (move tsk to another cgroup) or (tsk exiting)
> > > >                          -> kfree(tsk->cgroups)
> > > > get cg->subsys[..]
> > > 
> > > Ok :) Here is the patch again with updated description.
> > > 
> > > cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
> > > 	rcupreempt is used.
> > > 
> > > cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
> > > This can race with the task's movement between cgroups. This race
> > > can cause an access to freed ca pointer in cpuacct_charge() or access
> > > to invalid cgroups pointer of the task. This will not happen with rcu or
> > > tree rcu as cpuacct_charge() is called with preemption disabled. However if
> > > rcupreempt is used, the race is seen. Thanks to Li Zefan for explaining this.
> > > 
> > > Fix this race by explicitly protecting ca and the hierarchy walk with
> > > rcu_read_lock().
> > >
> > 
> > Looks good and works very well (except for the batch issue that you
> > pointed out, it takes up to batch values before updates are seen).
> > 
> > I'd like to get the patches in -tip and see the results, I would
> > recommend using percpu_counter_sum() while reading the data as an
> > enhancement to this patch. If user space does not overwhelm with a lot
> > of reads, sum would work out better.
> > 
> > 
> > Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> So I guess this ack is not for this patch but for the per-cgroup
> stime/utime cpuacct controller statistics patch.
>

Yes.. for both these patches actually. Thanks for pointing it out
though. 

-- 
	Balbir
