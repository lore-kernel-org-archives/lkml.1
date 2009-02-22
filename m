Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZBVDAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZBVDAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 22:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZBVDAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 22:00:31 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45625 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbZBVDAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 22:00:31 -0500
Date: Sat, 21 Feb 2009 19:00:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090222030030.GD6860@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com> <20090221014056.GU6960@linux.vnet.ibm.com> <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com> <20090221174703.GA6860@linux.vnet.ibm.com> <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com> <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 07:37:20PM +0100, Vegard Nossum wrote:
> 2009/2/21 Vegard Nossum <vegard.nossum@gmail.com>:
> > Here's the disassembly (I hope it won't wrap):
> >
> > 0xc1073ec0 <rcu_check_callbacks+0>:     push   %ebp
> > 0xc1073ec1 <rcu_check_callbacks+1>:     test   %edx,%edx
> > 0xc1073ec3 <rcu_check_callbacks+3>:     mov    %esp,%ebp
> > 0xc1073ec5 <rcu_check_callbacks+5>:     push   %ebx
> > 0xc1073ec6 <rcu_check_callbacks+6>:     mov    %eax,%ebx
> > 0xc1073ec8 <rcu_check_callbacks+8>:     je     0xc1073f08
> > <rcu_check_callbacks+72>
> > 0xc1073eca <rcu_qsctr_inc+0>:   mov    $0xc1771320,%eax
> > 0xc1073ecf <rcu_qsctr_inc+5>:   add    -0x3e8fa900(,%ebx,4),%eax
> > 0xc1073ed6 <rcu_qsctr_inc+12>:  mov    (%eax),%edx
> > 0xc1073ed8 <rcu_qsctr_inc+14>:  movb   $0x1,0xc(%eax)
> > 0xc1073edc <rcu_qsctr_inc+18>:  mov    %edx,0x8(%eax)
> > 0xc1073edf <rcu_bh_qsctr_inc+0>:        mov    $0xc1771380,%eax
> > 0xc1073ee4 <rcu_bh_qsctr_inc+5>:        add    -0x3e8fa900(,%ebx,4),%eax
> > 0xc1073eeb <rcu_bh_qsctr_inc+12>:       mov    (%eax),%edx
> > 0xc1073eed <rcu_bh_qsctr_inc+14>:       movb   $0x1,0xc(%eax)
> > 0xc1073ef1 <rcu_bh_qsctr_inc+18>:       mov    %edx,0x8(%eax)
> > 0xc1073ef4 <rcu_check_callbacks+52>:    mov    $0x8,%eax
> >
> > Seems to be rcu_qsctr_inc() that reloads %edx. If I'd guess, I'd say
> > x86's per_cpu macros. But it seems so strange that the corruption
> > would not manifest in other ways too.
> >
> 
> Okay, I don't really think it's an error. The if (user) test happens
> at the very beginning and gcc decides to reuse %edx. GDB doesn't know
> this, so it thinks the parameter changed, but at this point the
> parameter simply won't be used anymore.
> 
> So you're right: The value can't be trusted (after entry, anyway).

OK.  So at least the compiler is sane.  ;-)

And the fact that RCU Classic behaves the same as hierarchical RCU
pretty clearly points at some issue with the quiescent-state check code:

void rcu_check_callbacks(int cpu, int user)
{
	if (user ||
	    (idle_cpu(cpu) && !in_softirq() &&
				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
		rcu_qsctr_inc(cpu);
		rcu_bh_qsctr_inc(cpu);
	} else if (!in_softirq()) {
		rcu_bh_qsctr_inc(cpu);
	}
	raise_softirq(RCU_SOFTIRQ);
}

In the case you traced earlier, we interrupted out of kernel code, yet
somehow arrived at rcu_qsctr_inc().  We know that "user" really was 0,
thanks to your careful analysis, so the issue must be in the other
clause.  Since we interrupted out of mainline kernel code, in_softirq()
should have returned 0, and hardirq_count() should also have met the
above condition.

You mentioned some concern about idle_cpu() separately, and if idle_cpu()
was returning 1, then RCU would most certainly decide that it was in a
quiescent state and that it could end the current grace period.

							Thanx, Paul

