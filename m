Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053Ab0AZGR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab0AZGR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665Ab0AZGRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:17:25 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34221 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0AZGRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:17:24 -0500
Message-ID: <4B5E88EB.4020001@linux.vnet.ibm.com>
Date: Tue, 26 Jan 2010 11:47:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Anton Blanchard <anton@samba.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090716081010.GB3134@in.ibm.com>	<20090716083948.GA2950@kryten> <20090820051038.GF21100@kryten>	<20100118044142.GS12666@kryten> <20100125151404.7b7e6970.akpm@linux-foundation.org>
In-Reply-To: <20100125151404.7b7e6970.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010 04:44 AM, Andrew Morton wrote:
> On Mon, 18 Jan 2010 15:41:42 +1100
> Anton Blanchard <anton@samba.org> wrote:
> 
>> When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we can
>> call cpuacct_update_stats with values much larger than percpu_counter_batch.
>> This means the call to percpu_counter_add will always add to the global count
>> which is protected by a spinlock and we end up with a global spinlock in
>> the scheduler.
> 
> When one looks at the end result:
> 
> : static void cpuacct_update_stats(struct task_struct *tsk,
> : 		enum cpuacct_stat_index idx, cputime_t val)
> : {
> : 	struct cpuacct *ca;
> : 	int batch;
> : 
> : 	if (unlikely(!cpuacct_subsys.active))
> : 		return;
> : 
> : 	rcu_read_lock();
> : 	ca = task_ca(tsk);
> : 
> : 	batch = min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX);
> : 	do {
> : 		__percpu_counter_add(&ca->cpustat[idx], val, batch);
> : 		ca = ca->parent;
> : 	} while (ca);
> : 	rcu_read_unlock();
> : }
> 
> the code (which used to be quite obvious) becomes pretty unobvious.  In
> fact it looks quite wrong.
> 
> Shouldn't there be a comment there explaining wtf is going on?

Andrew,

I guess a lot of the changelog and comments are in the email history,
but your point on the comment is valid. Why does it look quite wrong to you?

cputime_one_jiffy tells us how many cputime_t's we've gotten in one
jiffy. If virtual accounting is enabled, this number is quite large, and
1 if virtual accounting is not enabled. Overall the value is set to 32
for non-virtual accounting enabled systems. On systems that support
virtual accounting, the value is set to 32*cputime_per_jifffy, so the
per cpu counter syncs up roughly once in 32 jiffies assuming
cpuacct_update_stats is called once per jiffy for non-virtual machines.

If the above comment, pleases you I'll polish it and send it across.
Anton, could you please confirm what I've said above is indeed correct.



-- 
Three Cheers,
Balbir Singh
