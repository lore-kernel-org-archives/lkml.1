Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZCPFDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZCPFDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 01:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZCPFDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 01:03:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35968 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZCPFDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 01:03:19 -0400
Date: Mon, 16 Mar 2009 14:01:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -tip] cpuacct: per-cgroup utime/stime statistics -
 v2
Message-Id: <20090316140146.e8b90401.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090316043754.GA3449@in.ibm.com>
References: <20090312110924.GC3344@in.ibm.com>
	<20090316103517.b0f8a20c.kamezawa.hiroyu@jp.fujitsu.com>
	<20090316043754.GA3449@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 10:07:54 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> > > +static void cpuacct_update_stats(struct task_struct *tsk,
> > > +		enum cpuacct_stat_index idx, cputime_t val)
> > > +{
> > > +	struct cpuacct *ca;
> > > +
> > > +	if (unlikely(!cpuacct_subsys.active))
> > > +		return;
> > > +
> > > +	ca = task_ca(tsk);
> > > +
> > > +	do {
> > > +		percpu_counter_add(&ca->cpustat[idx], val);
> > > +		ca = ca->parent;
> > > +	} while (ca);
> > > +}
> > > +
> > 
> > IIUC, to make sure accessing "ca" to be safe, we need some condition.
> > (task_lock() or some other.....
> 
> task_lock() protects tsk->cgroups->subsys[]. So can we hold task_lock()
> to protect this walk ?
If necessary (see below)

> But we do this cpuacct hierarchy walk for the
> current task here. So can a current task's ca or ca's parents disappear
> from under us ?

Ok, followings are correct, I think.
 1. All updates are called under preempt-disabled.
 2. If "ca" is pointed by task, "disappear" will not happen.
 3. if one of children is alive, the parent is alive.
 4. "attach" can happen and tsk may be moved to other cgroup,
     because we don't take task_lock.
     So, ca = task_ca() may not be correct one.

What we should explain here is How we consider "4", here.

> > > +	ca = task_ca(tsk);
> > > + ----------------------------------(*1)
> > > +	do {
> > > +		percpu_counter_add(&ca->cpustat[idx], val);
> > > +		ca = ca->parent;
> > > +	} while (ca);
        ----------------------------------(*2)

About accounting, we don't have any problem even if (*2) is different from (*1).
But, considering "ca" can be empty cgroup after (*1), in _theory_, we cannot
say "ca" is valid pointer after (*1).

Hmm, if necessary, adding rcu_read_lock() before (*1) is reasonable ?
(I say "if necessary" because I'm not sure.)

Thanks,
-Kame 






