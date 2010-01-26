Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612Ab0AZGgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0AZGgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434Ab0AZGgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:36:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab0AZGgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:36:08 -0500
Date: Mon, 25 Jan 2010 22:35:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: Anton Blanchard <anton@samba.org>,
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
Message-Id: <20100125223513.dd82e260.akpm@linux-foundation.org>
In-Reply-To: <4B5E88EB.4020001@linux.vnet.ibm.com>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	<20090512102939.GB11714@elte.hu>
	<20090512193656.D647.A69D9226@jp.fujitsu.com>
	<20090716081010.GB3134@in.ibm.com>
	<20090716083948.GA2950@kryten>
	<20090820051038.GF21100@kryten>
	<20100118044142.GS12666@kryten>
	<20100125151404.7b7e6970.akpm@linux-foundation.org>
	<4B5E88EB.4020001@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 11:47:15 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> On Tuesday 26 January 2010 04:44 AM, Andrew Morton wrote:
> > On Mon, 18 Jan 2010 15:41:42 +1100
> > Anton Blanchard <anton@samba.org> wrote:
> > 
> >> When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we can
> >> call cpuacct_update_stats with values much larger than percpu_counter_batch.
> >> This means the call to percpu_counter_add will always add to the global count
> >> which is protected by a spinlock and we end up with a global spinlock in
> >> the scheduler.
> > 
> > When one looks at the end result:
> > 
> > : static void cpuacct_update_stats(struct task_struct *tsk,
> > : 		enum cpuacct_stat_index idx, cputime_t val)
> > : {
> > : 	struct cpuacct *ca;
> > : 	int batch;
> > : 
> > : 	if (unlikely(!cpuacct_subsys.active))
> > : 		return;
> > : 
> > : 	rcu_read_lock();
> > : 	ca = task_ca(tsk);
> > : 
> > : 	batch = min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX);
> > : 	do {
> > : 		__percpu_counter_add(&ca->cpustat[idx], val, batch);
> > : 		ca = ca->parent;
> > : 	} while (ca);
> > : 	rcu_read_unlock();
> > : }
> > 
> > the code (which used to be quite obvious) becomes pretty unobvious.  In
> > fact it looks quite wrong.
> > 
> > Shouldn't there be a comment there explaining wtf is going on?
> 
> Andrew,
> 
> I guess a lot of the changelog and comments are in the email history,

Not a very useful location for it!

> Why does it look quite wrong to you?

Because it computes the correct value and then if it's larger than
INT_MAX, it inexplicably assigns INT_MAX to it, giving a wrong result!


Does that code actually work, btw?  percpu_counter_batch has type `int'
and cputime_one_jiffy has type `int' so their product has type `int'. 
So by the time min_t performs its comparison, the upper 32 bits of the
product are already lost.

