Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYCQVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYCQVXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCQVXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:23:33 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56203 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYCQVXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:23:32 -0400
Date: Tue, 18 Mar 2008 00:23:04 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, ego@in.ibm.com,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       akpm@linux-foundation.org, josh@freedesktop.org, tglx@linutronix.de,
       niv@us.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH] fix misplaced mb() in rcu_enter/exit_nohz()
Message-ID: <20080317212304.GA118@tv-sign.ru>
References: <20080317010821.GA29875@linux.vnet.ibm.com> <20080317183047.GA188@tv-sign.ru> <20080317190605.GG10955@linux.vnet.ibm.com> <20080317201741.GA92@tv-sign.ru> <20080317204357.GI10955@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317204357.GI10955@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Paul E. McKenney wrote:
>
> On Mon, Mar 17, 2008 at 11:17:41PM +0300, Oleg Nesterov wrote:
> > (to clarify: my question is completely offtopic to this patch)
> > On 03/17, Paul E. McKenney wrote:
> > > On Mon, Mar 17, 2008 at 09:30:47PM +0300, Oleg Nesterov wrote:
> > > > I'm not sure the code below is up to date, but what I have in
> > > > arch/s390/kernel/time.c is:
> > > > 
> > > > 	stop_hz_timer:
> > > > 
> > > > 		cpu_set(cpu, nohz_cpu_mask);
> > > > 		
> > > > 		if (rcu_needs_cpu(cpu) || local_softirq_pending()) {
> > > > 			cpu_clear(cpu, nohz_cpu_mask);
> > > > 			return;
> > > > 		}
> > > > 
> > > > Don't we need smp_mb() after cpu_set() ?
> > > 
> > > S390's memory model is quite strong, so it might not be needed.
> > 
> > OK, in that case we shouldn't worry.
> 
> I don't know if I would go -that- far.  ;-)
> 
> > > In any
> > > case, if needed, it goes -before- the cpu_set(), because the problems
> > > would arise if prior RCU read-side critical sections were to be reordered
> > > to follow this cpu_set(), right?
> > 
> > No, but it is very possible I missed something.
> > 
> > What if rcu_needs_cpu(cpu) is executed before cpu_set(cpu, nohz_cpu_mask)?
> > It can miss rcu_start_batch() -> rcp->cur++ and return false, but at the
> > same time rcu_start_batch() may see nohz_cpu_mask without this CPU.
> 
> If you mean that the rcu_needs_cpu() executes before the cpu_set() in
> the code fragment above, while the rcu_start_batch() executes on some
> other CPU?

Yes, and __rcu_pending() sees the old value of ->cur.

IOW. Suppose that this CPU reads rcp->cur out of order. To simplify, let's
suppose that stop_hz_timer() on CPU_0 in fact does

	xxx = rcu_needs_cpu(cpu); // false

	// ---- WINDOW ------

	cpu_set(cpu, nohz_cpu_mask);

	if (xxx || local_softirq_pending()) {
		... abort ...
	}

	...proceed...

Another CPU does rcu_start_batch() in the window above. In that case
rcp->cpumask will include CPU_0, and the grace period can't be completed
untill CPU_0 is "woken".

Oleg.

