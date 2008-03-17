Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYCQTGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYCQTGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYCQTGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:06:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39524 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYCQTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:06:24 -0400
Date: Mon, 17 Mar 2008 12:06:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, ego@in.ibm.com,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       akpm@linux-foundation.org, josh@freedesktop.org, tglx@linutronix.de,
       niv@us.ibm.com
Subject: Re: [PATCH] fix misplaced mb() in rcu_enter/exit_nohz()
Message-ID: <20080317190605.GG10955@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080317010821.GA29875@linux.vnet.ibm.com> <20080317183047.GA188@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317183047.GA188@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 09:30:47PM +0300, Oleg Nesterov wrote:
> On 03/16, Paul E. McKenney wrote:
> > 
> > In the process of writing up the mechanical proof of correctness for the
> > dynticks/preemptable-RCU interface, I noticed misplaced memory barriers
> > in rcu_enter_nohz() and rcu_exit_nohz().
> 
> Can't comment this patch, there is no rcu_enter_nohz() in my rcupreempt.h ;)

It is in 2.6.25-rc4 and later.  ;-)

> I'm not sure the code below is up to date, but what I have in
> arch/s390/kernel/time.c is:
> 
> 	stop_hz_timer:
> 
> 		cpu_set(cpu, nohz_cpu_mask);
> 		
> 		if (rcu_needs_cpu(cpu) || local_softirq_pending()) {
> 			cpu_clear(cpu, nohz_cpu_mask);
> 			return;
> 		}
> 
> Don't we need smp_mb() after cpu_set() ?

S390's memory model is quite strong, so it might not be needed.  In any
case, if needed, it goes -before- the cpu_set(), because the problems
would arise if prior RCU read-side critical sections were to be reordered
to follow this cpu_set(), right?

Let's see...  In S390, a store cannot be reordered to precede any prior
load or store, so any preceding RCU read-side critical section would be
seen by all CPUs as preceding the shift to nohz mode.  Might be trouble
for the opposite transition...

But last I heard, the s390 guys were thinking in terms of moving to the
generic dynticks model.  If they really are doing so, then the above
code goes away in any case.

							Thanx, Paul
