Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZDWOkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZDWOkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZDWOjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:39:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35295 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZDWOjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:39:48 -0400
Date: Thu, 23 Apr 2009 10:39:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
In-Reply-To: <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu>
 <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Apr 2009, Steven Rostedt wrote:

> 
> On Thu, 23 Apr 2009, Ingo Molnar wrote:
> 
> > > 
> > > Here's the situation:
> > > 
> > > We've added selftests for the event tracer. What this basically does is 
> > > enables each event one at a time and runs tests. The tests include 
> > > creating a kernel thread, executing workqueues and grabbing locks.
> > > 
> > > We also have PROVE_LOCKING (LOCKDEP) enabled, that keeps track of 
> > > interrupts being enabled. When they are, we set a flag in the task struct 
> > > "hardirqs_enabled". When they are disabled, this flag is cleared.
> > > 
> > > When we fork a process, a test is made to see if the flag is set for the 
> > > new process and if it is not, a warning is printed (as is done in the 
> > > above dump).
> > > 
> > > I investigated this and found that the flag is mysteriously being set and 
> > > cleared for no apparent reason. The flag is in the task struct and nothing 
> > > should be touching it. In fact, it is a full int, not even a bit in a 
> > > flags variable.
> > > 
> > > I had a test that would print the flag and irqs_disabled() in copy_process 
> > > before the warning and it showed that the flag was cleared but irqs was 
> > > enabled. The funny part is, I if the test triggered, I printed the flag 
> > > again, and the second print it was set again!!
> > > 
> > > 	if (!p->hardirqs_enabled) {
> > > 		printk("irqs:%d flag:%d\n", irqs_disabled(),
> > > 			p->hardirqs_enabled);
> > > 		printk("try again: %d\n", p->hardirqs_enabled);
> > > 	}
> > > 
> > > The first print showed that it was cleared, the second showed it was set 
> > > again??
> > 
> > function tracer was active? So somewhere there we corrupted this 
> > state? It's unlikely that printk itself did this.
> 
> The problem always arises at the same spot. I'm not saying printk was the 
> culprit, I'm saying that printk actually "fixed" the issue. Which can be a 
> sign of a corrupted register somewhere.
> 
> I currently tracked it down to something in "prep_new_page". It is hard to 
> debug because as I add tests into the code, it makes the race window 
> smaller, and I need to run multiple boots to trigger the code. But when I 
> do trigger it (and I try to trigger it a few times) it always happens at 
> the same spot.
> 
> Note, everytime I catch the issue, the printk again "fixes" the problem 
> :-/
> 
> Since I need both DEBUG_PAGEALLOC and PARAVIRT on, I'm thinking that the 
> debug page alloc might be messing with the paravirt "modified" code (or 
> vice versa). It could also be the function tracer doing it too. But it 
> looks like the DEBUG_PAGEALLOC code is causing issues because the bug 
> always appears in the alloc code.
> 
> I'm not blaming any subsystem yet. It just seems that the combination of 
> these systems are broken.

OK, now I need help :-p

I traced the corruption down to the __flush_tlb_all() in kernel_map_pages. 
This is only called when DEBUG_PAGEALLOC is enabled, thus this explains 
why DEBUG_PAGEALLOC must be set.

Now it may be an issue between the function tracer and paravirt.

The __flush_tlb_all is:

static inline void __flush_tlb_all(void)
{
        if (cpu_has_pge)
                __flush_tlb_global();
        else
                __flush_tlb();
}

Which, on my box calls __flush_tlb_global()

which is a paravirt call:

static void native_flush_tlb_global(void)
{
        __native_flush_tlb_global();
}


Even though the alternative code makes this a direct call, it is still 
traced by ftrace. Heck, even the calls in __native_flush_tlb_global call 
into paravirt (read_cr4 and write_cr4).

static inline void __native_flush_tlb_global(void)
{
        unsigned long flags;
        unsigned long cr4;

        /*
         * Read-modify-write to CR4 - protect it from preemption and
         * from interrupts. (Use the raw variant because this code can
         * be called from deep inside debugging code.)
         */
        raw_local_irq_save(flags);

        cr4 = read_cr4();
        /* clear PGE */
        write_cr4(cr4 & ~X86_CR4_PGE);
        /* write old PGE again and flush TLBs */
        write_cr4(cr4);

        raw_local_irq_restore(flags);
}


Each of those read_cr4 and write_cr4 can be traced. But I still do not see 
how this can cause corruption in the current task struct.

The TLB just caches the pages we are using, not the contents inside. I 
still do not see how this can corrupt a bit. Unless a register leaked :-/

-- Steve

