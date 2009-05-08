Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZEHKeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZEHKeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZEHKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:34:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:38889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZEHKeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:34:01 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Christoph Lameter <cl@linux.com>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090507180112.GE6693@linux.vnet.ibm.com>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>
	 <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop>
	 <1241716718.6311.1531.camel@laptop>
	 <20090507173608.GC6693@linux.vnet.ibm.com>
	 <1241717904.6311.1558.camel@laptop>
	 <20090507180112.GE6693@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 08 May 2009 12:32:56 +0200
Message-Id: <1241778776.6311.2585.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 11:01 -0700, Paul E. McKenney wrote:

> In general, I agree.  However, in the case where you have a single
> CPU-bound task running in user mode, you don't care that much about
> syscall performance.  So, yes, this would mean having yet another config
> variable that users running big CPU-bound scientific applications would
> need to worry about, which is not perfect either.
> 
> For whatever it is worth, the added overhead on entry would be something
> like the following:
> 
> void rcu_irq_enter(void)
> {
> 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> 
> 	if (rdtp->dynticks_nesting++)
> 		return;
> 	rdtp->dynticks++;
> 	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
> 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> }
> 
> On exit, a bit more:
> 
> void rcu_irq_exit(void)
> {
> 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> 
> 	if (--rdtp->dynticks_nesting)
> 		return;
> 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> 	rdtp->dynticks++;
> 	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
> 
> 	/* If the interrupt queued a callback, get out of dyntick mode. */
> 	if (__get_cpu_var(rcu_data).nxtlist ||
> 	    __get_cpu_var(rcu_bh_data).nxtlist)
> 		set_need_resched();
> }
> 
> But I could move the callback check into call_rcu(), which would get the
> overhead of rcu_irq_exit() down to about that of rcu_irq_enter().

Can't you simply enter idle state after a grace period completes and
finds no pending callbacks for the next period. And leave idle state at
the next call_rcu()?



