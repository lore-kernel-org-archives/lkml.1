Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZCPHNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZCPHNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZCPHNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:13:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50659 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZCPHNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:13:33 -0400
Message-ID: <49BDFC22.6090202@cn.fujitsu.com>
Date: Mon, 16 Mar 2009 15:13:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -tip] cpuacct: per-cgroup utime/stime statistics -
 v2
References: <20090312110924.GC3344@in.ibm.com> <20090316103517.b0f8a20c.kamezawa.hiroyu@jp.fujitsu.com> <20090316043754.GA3449@in.ibm.com>
In-Reply-To: <20090316043754.GA3449@in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +/*
>>> + * Account the system/user time to the task's accounting group.
>>> + */
>>> +static void cpuacct_update_stats(struct task_struct *tsk,
>>> +		enum cpuacct_stat_index idx, cputime_t val)
>>> +{
>>> +	struct cpuacct *ca;
>>> +
>>> +	if (unlikely(!cpuacct_subsys.active))
>>> +		return;
>>> +
>>> +	ca = task_ca(tsk);
>>> +
>>> +	do {
>>> +		percpu_counter_add(&ca->cpustat[idx], val);
>>> +		ca = ca->parent;
>>> +	} while (ca);
>>> +}
>>> +
>> IIUC, to make sure accessing "ca" to be safe, we need some condition.
>> (task_lock() or some other.....
> 
> task_lock() protects tsk->cgroups->subsys[]. So can we hold task_lock()
> to protect this walk ? But we do this cpuacct hierarchy walk for the
> current task here. So can a current task's ca or ca's parents disappear
> from under us ?
> 

task_ca() should be protected by task_lock() or rcu_read_lock(), otherwise
there is a very small race:

  ca = task_ca(tsk)
				move @tsk to another cgroup
				rmdir old_cgrp (thus ca is freed)
  ca->cpustat <--- accessing freed memory

As KAMEZAWA-san said all updates are called under preempt-disabled, and
classic and tree rcu's rcu_read_lock does preempt disable only, so above
code is ok, except for rcupreempt.

