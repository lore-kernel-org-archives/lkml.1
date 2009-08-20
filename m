Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZHTFxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZHTFxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZHTFw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:52:59 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:46089 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZHTFw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:52:58 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
 batch values for stats counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Anton Blanchard <anton@samba.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org
In-Reply-To: <20090820052605.GC26265@balbir.in.ibm.com>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	 <20090512102939.GB11714@elte.hu>
	 <20090512193656.D647.A69D9226@jp.fujitsu.com>
	 <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten>
	 <20090820051038.GF21100@kryten>  <20090820052605.GC26265@balbir.in.ibm.com>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 07:52:59 +0200
Message-Id: <1250747579.8282.110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 10:56 +0530, Balbir Singh wrote:

> Looks good overall, why not keep the batch size conditional on
> CONFIG_VIRT_CPU_ACCOUNTING? I'd still like to stick with
> percpu_counter_read() on the read side because My concern is that a
> bad user space application can read cpuacct.stat and bring the kernel
> to its knees.

Agreed, the first hunk is dangerous, on the second hunk, I'm not sure
about the INT_MAX thing, that's a 4s gap per cpu, that might be a tad
much.

> > > Signed-off-by: Anton Blanchard <anton@samba.org>
> > > ---
> > > 
> > > Index: linux.trees.git/kernel/sched.c
> > > ===================================================================
> > > --- linux.trees.git.orig/kernel/sched.c	2009-07-16 10:11:02.000000000 +1000
> > > +++ linux.trees.git/kernel/sched.c	2009-07-16 10:16:41.000000000 +1000
> > > @@ -10551,7 +10551,7 @@
> > >  	int i;
> > >  
> > >  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> > > -		s64 val = percpu_counter_read(&ca->cpustat[i]);
> > > +		s64 val = percpu_counter_sum(&ca->cpustat[i]);
> > >  		val = cputime64_to_clock_t(val);
> > >  		cb->fill(cb, cpuacct_stat_desc[i], val);
> > >  	}
> > > @@ -10621,7 +10621,7 @@
> > >  	ca = task_ca(tsk);
> > >  
> > >  	do {
> > > -		percpu_counter_add(&ca->cpustat[idx], val);
> > > +		__percpu_counter_add(&ca->cpustat[idx], val, INT_MAX);
> > >  		ca = ca->parent;
> > >  	} while (ca);
> > >  	rcu_read_unlock();
> 

