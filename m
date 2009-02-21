Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZBUSd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZBUSd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 13:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZBUSdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 13:33:19 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60276 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbZBUSdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 13:33:18 -0500
Date: Sat, 21 Feb 2009 10:33:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090221183318.GB6860@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com> <20090221014056.GU6960@linux.vnet.ibm.com> <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com> <20090221174703.GA6860@linux.vnet.ibm.com> <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 07:08:55PM +0100, Vegard Nossum wrote:
> 2009/2/21 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> rcu_check_callbacks (cpu=0, user=0) at kernel/rcutree.c:949
> >> 949     {
> >> ...
> >> rcu_check_callbacks (cpu=0, user=-1049147360) at kernel/rcutree.c:967
> >> 967                     rcu_qsctr_inc(cpu);
> >
> > ????  Are the argument values trustworthy?  If so, I don't see how
> > the variable user transitioned from zero to non-zero.
> >
> > The value user!=0 tells RCU that we were interrupted from a user process,
> > but this immediately follows user==0.  If we really were interrupted
> > from kernel code, (including from an irq handler) we should have user==0.
> >
> > The user!=0 causes RCU to conclude that we are in a quiescent state.
> >
> > RCU is then within its rights to process callbacks, which would result
> > in the behavior you saw.
> 
> Ah, curious. Thanks for the explanation.
> 
> I tried again, just to be sure:
> 
> Breakpoint 1, rcu_check_callbacks (cpu=0, user=0) at kernel/rcutree.c:949
> 949     {
> (gdb) p &user
> Address requested for identifier "user" which is in register $edx
> (gdb) p user
> $1 = 0
> (gdb) s
> 950             if (user ||
> (gdb)
> 949     {
> (gdb)
> 950             if (user ||
> (gdb)
> idle_cpu (cpu=0) at kernel/sched.c:5196
> 5196            return cpu_curr(cpu) == cpu_rq(cpu)->idle;
> (gdb)
> 5197    }
> (gdb)
> idle_cpu (cpu=<value optimized out>) at kernel/sched.c:5196
> 5196            return cpu_curr(cpu) == cpu_rq(cpu)->idle;
> (gdb)
> 5197    }
> (gdb)
> rcu_check_callbacks (cpu=0, user=-1049147360) at kernel/rcutree.c:967
> 967                     rcu_qsctr_inc(cpu);
> 
> Could that be a missing "d" clobber in some inline assembly? Or a
> miscompilation?

Hmmm...  cpu_rq() does invoke per_cpu()...

> Here's the disassembly (I hope it won't wrap):
> 
> 0xc1073ec0 <rcu_check_callbacks+0>:     push   %ebp
> 0xc1073ec1 <rcu_check_callbacks+1>:     test   %edx,%edx
> 0xc1073ec3 <rcu_check_callbacks+3>:     mov    %esp,%ebp
> 0xc1073ec5 <rcu_check_callbacks+5>:     push   %ebx
> 0xc1073ec6 <rcu_check_callbacks+6>:     mov    %eax,%ebx
> 0xc1073ec8 <rcu_check_callbacks+8>:     je     0xc1073f08
> <rcu_check_callbacks+72>
> 0xc1073eca <rcu_qsctr_inc+0>:   mov    $0xc1771320,%eax
> 0xc1073ecf <rcu_qsctr_inc+5>:   add    -0x3e8fa900(,%ebx,4),%eax
> 0xc1073ed6 <rcu_qsctr_inc+12>:  mov    (%eax),%edx
> 0xc1073ed8 <rcu_qsctr_inc+14>:  movb   $0x1,0xc(%eax)
> 0xc1073edc <rcu_qsctr_inc+18>:  mov    %edx,0x8(%eax)
> 0xc1073edf <rcu_bh_qsctr_inc+0>:        mov    $0xc1771380,%eax
> 0xc1073ee4 <rcu_bh_qsctr_inc+5>:        add    -0x3e8fa900(,%ebx,4),%eax
> 0xc1073eeb <rcu_bh_qsctr_inc+12>:       mov    (%eax),%edx
> 0xc1073eed <rcu_bh_qsctr_inc+14>:       movb   $0x1,0xc(%eax)
> 0xc1073ef1 <rcu_bh_qsctr_inc+18>:       mov    %edx,0x8(%eax)
> 0xc1073ef4 <rcu_check_callbacks+52>:    mov    $0x8,%eax
> 
> Seems to be rcu_qsctr_inc() that reloads %edx. If I'd guess, I'd say
> x86's per_cpu macros. But it seems so strange that the corruption
> would not manifest in other ways too.
> 
> Stand by for further investigations :-)

I will look into this, but it will take a bit.

							Thanx, Paul
