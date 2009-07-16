Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZGPIj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZGPIj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZGPIj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:39:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54739 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZGPIjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:39:55 -0400
Date: Thu, 16 Jul 2009 18:39:48 +1000
From: Anton Blanchard <anton@samba.org>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090716083948.GA2950@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090716081010.GB3134@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716081010.GB3134@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> On ppc64, calling jiffies_to_cputime() from sched_init() is too early because
> jiffies_to_cputime() needs tb_ticks_per_sec which gets initialized only
> later in time_init(). Because of this I see that cpuacct_batch will always
> be zero effectively negating what this patch is trying to do.
> 
> As explained by you earlier, we too are finding the default batch value to
> be too low for ppc64 with VIRT_CPU_ACCOUNTING turned on. Hence I guess
> if this patch is taken in (ofcourse with the above issue fixed), it will
> benefit ppc64 also.

I created this patch earlier today when I hit the problem. Thoughts?

Anton
--

When CONFIG_VIRT_CPU_ACCOUNTING is enabled we can call cpuacct_update_stats
with values much larger than percpu_counter_batch. This means the
call to percpu_counter_add will always add to the global count which is
protected by a spinlock.

Since reading of the CPU accounting cgroup counters is not performance
critical, we can use a maximum size batch of INT_MAX and use
percpu_counter_sum on the read side which will add all the percpu
counters.

With this patch an 8 core POWER6 with CONFIG_VIRT_CPU_ACCOUNTING and
CONFIG_CGROUP_CPUACCT shows an improvement in aggregate context switch rate of
397k/sec to 3.9M/sec, a 10x improvement.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c	2009-07-16 10:11:02.000000000 +1000
+++ linux.trees.git/kernel/sched.c	2009-07-16 10:16:41.000000000 +1000
@@ -10551,7 +10551,7 @@
 	int i;
 
 	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
-		s64 val = percpu_counter_read(&ca->cpustat[i]);
+		s64 val = percpu_counter_sum(&ca->cpustat[i]);
 		val = cputime64_to_clock_t(val);
 		cb->fill(cb, cpuacct_stat_desc[i], val);
 	}
@@ -10621,7 +10621,7 @@
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, INT_MAX);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();
