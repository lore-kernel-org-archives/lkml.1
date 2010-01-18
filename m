Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608Ab0ARJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0ARJmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489Ab0ARJmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:42:22 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:59036 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab0ARJmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:42:18 -0500
Date: Mon, 18 Jan 2010 10:42:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
Message-ID: <20100118104213.64231c1e@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100118044142.GS12666@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	<20090512102939.GB11714@elte.hu>
	<20090512193656.D647.A69D9226@jp.fujitsu.com>
	<20090716081010.GB3134@in.ibm.com>
	<20090716083948.GA2950@kryten>
	<20090820051038.GF21100@kryten>
	<20100118044142.GS12666@kryten>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Mon, 18 Jan 2010 15:41:42 +1100
Anton Blanchard <anton@samba.org> wrote:

> Note: ccing ia64 and s390 who have not yet added code to statically
> initialise cputime_one_jiffy at boot. 
> See a42548a18866e87092db93b771e6c5b060d78401 (cputime: Optimize
> jiffies_to_cputime(1) for details). Adding this would help optimise not only
> this patch but many other areas of the scheduler when
> CONFIG_VIRT_CPU_ACCOUNTING is enabled.

For s390 the jiffies_to_cputime is a compile time constant. No need to
initialize it at runtime, no? 

> Index: linux.trees.git/kernel/sched.c
> ===================================================================
> --- linux.trees.git.orig/kernel/sched.c	2010-01-18 14:27:12.000000000 +1100
> +++ linux.trees.git/kernel/sched.c	2010-01-18 15:21:59.000000000 +1100
> @@ -10894,6 +10894,7 @@ static void cpuacct_update_stats(struct 
>  		enum cpuacct_stat_index idx, cputime_t val)
>  {
>  	struct cpuacct *ca;
> +	int batch;
> 
>  	if (unlikely(!cpuacct_subsys.active))
>  		return;
> @@ -10901,8 +10902,9 @@ static void cpuacct_update_stats(struct 
>  	rcu_read_lock();
>  	ca = task_ca(tsk);
> 
> +	batch = min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX);
>  	do {
> -		percpu_counter_add(&ca->cpustat[idx], val);
> +		__percpu_counter_add(&ca->cpustat[idx], val, batch);
>  		ca = ca->parent;
>  	} while (ca);
>  	rcu_read_unlock();

The patch itself trades some accuracy (larger cpu accounting value that
are stored per-cpu) against runtime overhead (spinlock to transfer the
value to the global variable in __percpu_counter_add). Did you
calculate how big the loss in accuracy is?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

