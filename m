Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbZCPIrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbZCPIrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZCPIrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:47:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56567 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZCPIrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:47:36 -0400
Date: Mon, 16 Mar 2009 14:17:56 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -tip] cpuacct: per-cgroup utime/stime statistics -
	v2
Message-ID: <20090316084756.GD3449@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090312110924.GC3344@in.ibm.com> <20090316103517.b0f8a20c.kamezawa.hiroyu@jp.fujitsu.com> <20090316043754.GA3449@in.ibm.com> <49BDFC22.6090202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BDFC22.6090202@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 03:13:38PM +0800, Li Zefan wrote:
> >>> +/*
> >>> + * Account the system/user time to the task's accounting group.
> >>> + */
> >>> +static void cpuacct_update_stats(struct task_struct *tsk,
> >>> +		enum cpuacct_stat_index idx, cputime_t val)
> >>> +{
> >>> +	struct cpuacct *ca;
> >>> +
> >>> +	if (unlikely(!cpuacct_subsys.active))
> >>> +		return;
> >>> +
> >>> +	ca = task_ca(tsk);
> >>> +
> >>> +	do {
> >>> +		percpu_counter_add(&ca->cpustat[idx], val);
> >>> +		ca = ca->parent;
> >>> +	} while (ca);
> >>> +}
> >>> +
> >> IIUC, to make sure accessing "ca" to be safe, we need some condition.
> >> (task_lock() or some other.....
> > 
> > task_lock() protects tsk->cgroups->subsys[]. So can we hold task_lock()
> > to protect this walk ? But we do this cpuacct hierarchy walk for the
> > current task here. So can a current task's ca or ca's parents disappear
> > from under us ?
> > 
> 
> task_ca() should be protected by task_lock() or rcu_read_lock(), otherwise
> there is a very small race:
> 
>   ca = task_ca(tsk)
> 				move @tsk to another cgroup
> 				rmdir old_cgrp (thus ca is freed)
>   ca->cpustat <--- accessing freed memory
> 
> As KAMEZAWA-san said all updates are called under preempt-disabled, and
> classic and tree rcu's rcu_read_lock does preempt disable only, so above
> code is ok, except for rcupreempt.

So I will protect task_ca() and ca hierarchy walk with explicit
rcu_read_lock() to be fully safe.

By the same logic, hierarchy walk in cpuacct_charge() is also
not safe with rcupreempt. It is under preempt disabled section due
to rq->lock. Does cpuacct_charge() also need a fix then ?

Regards,
Bharata.
