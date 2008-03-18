Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbYCSUtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbYCSUtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbYCSTpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:45:49 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:42040 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbYCSTpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:45:47 -0400
Date: Tue, 18 Mar 2008 07:10:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org, mingo@elte.hu,
       ego@in.ibm.com, dipankar@in.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, akpm@linux-foundation.org, josh@freedesktop.org,
       tglx@linutronix.de, niv@us.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] fix misplaced mb() in rcu_enter/exit_nohz()
Message-ID: <20080318141040.GB8222@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080317010821.GA29875@linux.vnet.ibm.com> <20080317183047.GA188@tv-sign.ru> <20080317190605.GG10955@linux.vnet.ibm.com> <20080317201741.GA92@tv-sign.ru> <20080317204357.GI10955@linux.vnet.ibm.com> <20080318124248.GB8669@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318124248.GB8669@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 01:42:48PM +0100, Heiko Carstens wrote:
> On Mon, Mar 17, 2008 at 01:43:57PM -0700, Paul E. McKenney wrote:
> > On Mon, Mar 17, 2008 at 11:17:41PM +0300, Oleg Nesterov wrote:
> > > (to clarify: my question is completely offtopic to this patch)
> > > On 03/17, Paul E. McKenney wrote:
> > > > On Mon, Mar 17, 2008 at 09:30:47PM +0300, Oleg Nesterov wrote:
> > > > > I'm not sure the code below is up to date, but what I have in
> > > > > arch/s390/kernel/time.c is:
> > > > > 
> > > > > 	stop_hz_timer:
> > > > > 
> > > > > 		cpu_set(cpu, nohz_cpu_mask);
> > > > > 		
> > > > > 		if (rcu_needs_cpu(cpu) || local_softirq_pending()) {
> > > > > 			cpu_clear(cpu, nohz_cpu_mask);
> > > > > 			return;
> > > > > 		}
> > > > > 
> > > > > Don't we need smp_mb() after cpu_set() ?
> > > > 
> > > > S390's memory model is quite strong, so it might not be needed.
> > > 
> > > OK, in that case we shouldn't worry.
> > 
> > I don't know if I would go -that- far.  ;-)
> 
> Not sure if I can follow you here, but for the smp case cpu_set() is
> nothing but a set_bit() which implies both: a memory barrier and a compiler
> barrier on s390. The compare and swap instruction used here ensures that
> all previous memory accesses will be seen by other cpus.

That should make this work as far as I can see!

							Thanx, Paul

> Btw. the code sequence above will go away soon anyway, since I'm converting
> our code to the generic NO_HZ infrastructure.
> 
> > > > In any
> > > > case, if needed, it goes -before- the cpu_set(), because the problems
> > > > would arise if prior RCU read-side critical sections were to be reordered
> > > > to follow this cpu_set(), right?
> > > 
> > > No, but it is very possible I missed something.
> > > 
> > > What if rcu_needs_cpu(cpu) is executed before cpu_set(cpu, nohz_cpu_mask)?
> > > It can miss rcu_start_batch() -> rcp->cur++ and return false, but at the
> > > same time rcu_start_batch() may see nohz_cpu_mask without this CPU.
> > 
> > If you mean that the rcu_needs_cpu() executes before the cpu_set() in
> > the code fragment above, while the rcu_start_batch() executes on some
> > other CPU?
> 
> That should never happen because of the compiler and memory barrier semantics
> of cpu_set(). Or... I'm completely misunderstanding you, which wouldn't me
> surprise me too much :)
