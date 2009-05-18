Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZEROkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZEROkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZEROkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:40:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58824 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZEROkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:40:41 -0400
Date: Mon, 18 May 2009 07:40:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       davem@davemloft.net, dada1@cosmosbay.com, zbr@ioremap.net,
       jeff.chua.linux@gmail.com, paulus@samba.org, jengelh@medozas.de,
       r000n@r000n.net, benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v5 expedited "big hammer" RCU grace periods
Message-ID: <20090518144039.GA6768@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090517191141.GA25915@linux.vnet.ibm.com> <4A110768.2040707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A110768.2040707@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 02:59:52PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > +void sched_expedited_wake(void *unused)
> > +{
> > +	mutex_lock(&__get_cpu_var(sched_expedited_done_mutex));
> > +	if (__get_cpu_var(sched_expedited_done_qs) ==
> > +	    SCHED_EXPEDITED_QS_DONE_QS) {
> > +		__get_cpu_var(sched_expedited_done_qs) =
> > +			SCHED_EXPEDITED_QS_NEED_QS;
> > +		wake_up(&__get_cpu_var(sched_expedited_qs_wq));
> > +	}
> > +	mutex_unlock(&__get_cpu_var(sched_expedited_done_mutex));
> > +}
> 
> [...]
> 
> > +		get_online_cpus();
> > +		preempt_disable();
> > +		mycpu = smp_processor_id();
> > +		smp_call_function(sched_expedited_wake, NULL, 1);
> 
> sched_expedited_wake() calls mutex_lock() which may sleep?

Good eyes!  Fixing this and the failure to release this lock in
krcu_sched_expedited_percpu() allows it to survive 10 hours of
rcutorture running in parallel with onlining/offlining random CPUs.

> And I think you have re-implement workqueue.

Hmmm...  I suppose I could use schedule_work(), though I am concerned
about interference from other work.  But I will give this some thought.

							Thanx, Paul
