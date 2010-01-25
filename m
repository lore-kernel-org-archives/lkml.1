Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902Ab0AYXOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0AYXOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673Ab0AYXOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:14:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab0AYXOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:14:52 -0500
Date: Mon, 25 Jan 2010 15:14:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
Message-Id: <20100125151404.7b7e6970.akpm@linux-foundation.org>
In-Reply-To: <20100118044142.GS12666@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	<20090512102939.GB11714@elte.hu>
	<20090512193656.D647.A69D9226@jp.fujitsu.com>
	<20090716081010.GB3134@in.ibm.com>
	<20090716083948.GA2950@kryten>
	<20090820051038.GF21100@kryten>
	<20100118044142.GS12666@kryten>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 15:41:42 +1100
Anton Blanchard <anton@samba.org> wrote:

> When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we can
> call cpuacct_update_stats with values much larger than percpu_counter_batch.
> This means the call to percpu_counter_add will always add to the global count
> which is protected by a spinlock and we end up with a global spinlock in
> the scheduler.

When one looks at the end result:

: static void cpuacct_update_stats(struct task_struct *tsk,
: 		enum cpuacct_stat_index idx, cputime_t val)
: {
: 	struct cpuacct *ca;
: 	int batch;
: 
: 	if (unlikely(!cpuacct_subsys.active))
: 		return;
: 
: 	rcu_read_lock();
: 	ca = task_ca(tsk);
: 
: 	batch = min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX);
: 	do {
: 		__percpu_counter_add(&ca->cpustat[idx], val, batch);
: 		ca = ca->parent;
: 	} while (ca);
: 	rcu_read_unlock();
: }

the code (which used to be quite obvious) becomes pretty unobvious.  In
fact it looks quite wrong.

Shouldn't there be a comment there explaining wtf is going on?
