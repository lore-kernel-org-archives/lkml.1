Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZFRXm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZFRXm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZFRXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:42:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:23269 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZFRXmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:42:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,248,1243839600"; 
   d="scan'208";a="526041068"
Subject: Re: [patch 0/2] RFC sched: Change nohz ilb logic from poll to push
 model
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <20090617191619.GH7961@dirshya.in.ibm.com>
References: <20090617182649.604970000@intel.com>
	 <20090617191619.GH7961@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 16:41:13 -0700
Message-Id: <1245368473.4534.10512.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 12:16 -0700, Vaidyanathan Srinivasan wrote:
> * venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> [2009-06-17 11:26:49]:
> 
> > Existing nohz idle load balance (ilb) logic uses the pull model, with one
> > idle load balancer CPU nominated on any partially idle system and that
> > balancer CPU not going into nohz mode. With the periodic tick, the
> > balancer does the idle balancing on behalf of all the CPUs in nohz mode.
> > 
> > This is not very optimal and has few issues:
> > * the balancer will continue to have periodic ticks and wakeup
> >   frequently (HZ rate), even though it may not have any rebalancing to do on
> >   behalf of any of the idle CPUs.
> > * On x86 and CPUs that have APIC timer stoppage on idle CPUs, this periodic
> >   wakeup can result in an additional interrupt on a CPU doing the timer
> >   broadcast.
> > * The balancer may end up spending a lot of time doing the balancing on
> >   behalf of nohz CPUs, especially with increasing number of sockets and
> >   cores in the platform.
> > 
> > The alternative is to have a push model, where all idle CPUs can enter nohz
> > mode and busy CPU kicks one of the idle CPUs to take care of idle balancing
> > on behalf of a group of idle CPUs.
> 
> Hi Venki,
> 
> The idea is very useful and further extends the power savings in idle
> system.  However the kick method from busy CPU should not add to
> scheduling latency during a sudden burst of work.
> 
> Does adding nohz_balancer_kick() in trigger_load_balance() path in
> a busy CPU add to its overhead?
> 
>  
> > Following patches tries that approach. There are still some rough edges
> > in the patches related to use of #defines around the code. But, wanted
> > to get opinion on this approach as an RFC (not for inclusion into the
> > tree yet).
> 
> I like the idea but my only concern is the performance impact on busy
> cpus with this push model. 

Vaidy,

I tried to keep the overhead on the busy CPU low in this RFC. There is a
check the for next_balance time and if there is a load balance CPU
nominated we just send a resched to the load balance CPU. We do look at
cpu_mask to find the first bit set, when there is no assigned
load_balance CPU (that is when say load balance CPU started running and
no other CPU has nominated himself yet). But, that's the only overhead
there. All the other complexities are handled on the idle CPU side.

Thanks,
Venki

