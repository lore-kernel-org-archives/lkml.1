Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556Ab0ARHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0ARHvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435Ab0ARHvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:51:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:58702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0ARHvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:51:50 -0500
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
In-Reply-To: <20100118044142.GS12666@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	 <20090512102939.GB11714@elte.hu>
	 <20090512193656.D647.A69D9226@jp.fujitsu.com>
	 <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten>
	 <20090820051038.GF21100@kryten>  <20100118044142.GS12666@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 08:51:19 +0100
Message-ID: <1263801079.4283.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 15:41 +1100, Anton Blanchard wrote:
> Hi,
> 
> Another try at this percpu_counter batch issue with CONFIG_VIRT_CPU_ACCOUNTING
> and CONFIG_CGROUP_CPUACCT enabled. Thoughts?

Seems like a good idea, but isn't that batch number rather static? If
so, computing it in some init path would save that multiply on the
actual accounting path.

> 
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


