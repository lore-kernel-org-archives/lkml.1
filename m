Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801Ab0ASRLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0ASRLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768Ab0ASRLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:11:32 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:55169 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749Ab0ASRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:11:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAFZ0VUuuWOiG/2dsb2JhbACBRtY4hDME
Date: Tue, 19 Jan 2010 12:11:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100119171128.GA23509@Krystal>
References: <20100113013757.GA29314@Krystal> <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal> <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal> <1263919667.4283.732.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263919667.4283.732.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:07:15 up 34 days,  1:25,  4 users,  load average: 0.25, 0.19,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
[...]
> > It's this scenario that is causing problem. Let's consider this
> > execution:
> > 
> >        CPU 0 (membarrier)                  CPU 1 (another mm -> our mm)
> >        <kernel-space>                      <kernel-space>
> >                                            switch_mm()
> >                                              smp_mb()
> >                                              clear_mm_cpumask()
> >                                              set_mm_cpumask()
> >                                              smp_mb() (by load_cr3() on x86)
> >                                            switch_to()
> >        mm_cpumask includes CPU 1
> >        rcu_read_lock()
> >        if (CPU 1 mm != our mm)
> >          skip CPU 1.
> >        rcu_read_unlock()
> >                                              current = next (1)
> 
> OK, so on x86 current uses esp and will be flipped somewhere in the
> switch_to() magic, cpu_curr(cpu) as used by CPU 0 uses rq->curr, which
> will be set before context_switch() and that always implies a mb() for
> non matching ->mm's [*]

Hi Peter,

Please refer to the discussion with Steven further down this thread
(http://lkml.org/lkml/2010/1/14/319), which I update the scenario
when I figured out that "current" and rq->curr are indeed two different
things. It's rq->curr we are interested into here, not "current" as I
previously thought. (sorry about the mixup)

> 
> >                                            <switch back to user-space>
> >                                            read-lock()
> >                                              read gp, store local gp
> >                                              barrier()
> >                                              access critical section (2)
> > 
> > So if we don't have any memory barrier between (1) and (2), the memory
> > operations can be reordered in such a way that CPU 0 will not send IPI
> > to a CPU that would need to have it's barrier() promoted into a
> > smp_mb().
> 
> OK, so I'm utterly failing to make sense of the above, do you need more
> than the 2 cpus discussed to make it go boom?
> 
> > Replacing these kernel rcu_read_lock/unlock() by rq locks ensures that
> > when the scheduler runs concurrently on another CPU, _all_ the scheduling
> > code is executed atomically wrt the spin lock taken on cpu 0.
> 
> Sure, but taking the rq->lock is fairly heavy handed.
> 
> > When x86 uses iret to return to user-space, then we have a serializing
> > instruction. But if it uses sysexit, or if we are on a different
> > architecture, are we sure that a memory barrier is issued before
> > returning to user-space ?
> 
> [*] and possibly also for matching ->mm's, because:
> 
> OK, so I had a quick look at the switch_to() magic, and from what I can
> make of it it implies an mb, if only because poking at the segment
> registers implies LOCK semantics.

Can you have a look at the updated scenario and reply with questions
that might arise ?

Thanks!

Mathieu

> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
