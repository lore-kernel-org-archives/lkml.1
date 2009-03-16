Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbZCPEhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbZCPEhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZCPEhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:37:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58467 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZCPEhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:37:40 -0400
Date: Mon, 16 Mar 2009 10:07:54 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -tip] cpuacct: per-cgroup utime/stime statistics -
	v2
Message-ID: <20090316043754.GA3449@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090312110924.GC3344@in.ibm.com> <20090316103517.b0f8a20c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316103517.b0f8a20c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 10:35:17AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 12 Mar 2009 16:39:24 +0530
> Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> >  #ifdef CONFIG_CGROUP_CPUACCT
> >  static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
> > +static void cpuacct_update_stats(struct task_struct *tsk,
> > +		enum cpuacct_stat_index idx, cputime_t val);
> >  #else
> >  static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
> > +static void cpuacct_update_stats(struct task_struct *tsk,
> > +		enum cpuacct_stat_index idx, cputime_t val) {}
> >  #endif
> "static inline"  
> if no "inline", the complier will show warning as
> "this function is defined but not used.."

Ok.

> >  
> > +/*
> > + * Account the system/user time to the task's accounting group.
> > + */
> > +static void cpuacct_update_stats(struct task_struct *tsk,
> > +		enum cpuacct_stat_index idx, cputime_t val)
> > +{
> > +	struct cpuacct *ca;
> > +
> > +	if (unlikely(!cpuacct_subsys.active))
> > +		return;
> > +
> > +	ca = task_ca(tsk);
> > +
> > +	do {
> > +		percpu_counter_add(&ca->cpustat[idx], val);
> > +		ca = ca->parent;
> > +	} while (ca);
> > +}
> > +
> 
> IIUC, to make sure accessing "ca" to be safe, we need some condition.
> (task_lock() or some other.....

task_lock() protects tsk->cgroups->subsys[]. So can we hold task_lock()
to protect this walk ? But we do this cpuacct hierarchy walk for the
current task here. So can a current task's ca or ca's parents disappear
from under us ?

Regards,
Bharata.
