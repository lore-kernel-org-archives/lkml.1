Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZJGNbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZJGNbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZJGNbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:31:44 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:57610 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbZJGNbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:31:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAJ8uzEpMROOX/2dsb2JhbACBUtQXhCoE
Date: Wed, 7 Oct 2009 09:31:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091007133106.GC29632@Krystal>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <1254920460.26976.241.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1254920460.26976.241.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:25:42 up 50 days, 15 min,  2 users,  load average: 0.36, 0.46,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2009-10-07 at 08:46 -0400, Mathieu Desnoyers wrote:
> > * local_irq_restore
> >   -> the interrupt line is low. The scheduler won't be called. There is
> >      no preempt_check_resched() call.
> 
> That would be an issue with all irq disable sections, so I don't think
> this is actually true.
> 

AFAIK, irq disable sections rely on the fact that if you get a timer
interrupt during this section, the timer interrupt line stays triggered
for the duration of the irqoff section. Therefore, when interrupts are
re-enabled, the interrupt kicks in, so does the scheduler.

This is not the case with the preempt/irqoff dance proposed by
Christoph.

> I tried to find the actual code, but frigging paravirt crap obfuscated
> the code enough that I actually gave up.

You're probably looking for:

arch/x86/include/asm/irqflags.h:

static inline void native_irq_enable(void)
{
        asm volatile("sti": : :"memory");
}

and

static inline void native_restore_fl(unsigned long flags)
{
        asm volatile("push %0 ; popf"
                     : /* no output */
                     :"g" (flags)
                     :"memory", "cc");
}

static inline void raw_local_irq_restore(unsigned long flags)
{
        native_restore_fl(flags);
}

Which are as simple as it gets.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
