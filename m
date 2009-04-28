Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbZD1Qn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbZD1Qn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZD1Qna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:43:30 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:33973 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714AbZD1Qn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:43:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEADDP9klMQW1W/2dsb2JhbACBUM4Yg3MF
Date: Tue, 28 Apr 2009 12:38:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: LTTng "TIF_KERNEL_TRACE"
Message-ID: <20090428163825.GA2030@Krystal>
References: <20090428132037.GA27519@Krystal> <20090428150102.GB26546@elte.hu> <20090428154046.GA32381@Krystal> <20090428163300.GD5978@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090428163300.GD5978@nowhere>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:36:41 up 59 days, 13:02,  2 users,  load average: 0.86, 0.41,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Tue, Apr 28, 2009 at 11:40:46AM -0400, Mathieu Desnoyers wrote:
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > Hi Ingo,
> > > > 
> > > > Looking at the current -tip tree, I notice that the 
> > > > TIF_SYSCALL_FTRACE flag is only implemented for x86.
> > > > 
> > > > I have TIF_KERNEL_TRACE in my lttng tree which applies to all 
> > > > architectures to do the exact same thing :
> > > > 
> > > > lttng-kernel-trace-thread-flag-alpha.patch
> > > > lttng-kernel-trace-thread-flag-arm.patch
> > > > lttng-kernel-trace-thread-flag-avr32.patch
> > > > lttng-kernel-trace-thread-flag-blackfin.patch
> > > > lttng-kernel-trace-thread-flag-cris.patch
> > > > lttng-kernel-trace-thread-flag-frv.patch
> > > > lttng-kernel-trace-thread-flag-h8300.patch
> > > > lttng-kernel-trace-thread-flag-ia64.patch
> > > > lttng-kernel-trace-thread-flag-m32r.patch
> > > > lttng-kernel-trace-thread-flag-m68k.patch
> > > > lttng-kernel-trace-thread-flag-mips.patch
> > > > lttng-kernel-trace-thread-flag-parisc.patch
> > > > lttng-kernel-trace-thread-flag-powerpc.patch
> > > > lttng-kernel-trace-thread-flag-s390.patch
> > > > lttng-kernel-trace-thread-flag-sh.patch
> > > > lttng-kernel-trace-thread-flag-sparc.patch
> > > > lttng-kernel-trace-thread-flag-um.patch
> > > > lttng-kernel-trace-thread-flag-x86.patch
> > > > lttng-kernel-trace-thread-flag-xtensa.patch
> > > > lttng-kernel-trace-thread-flag-api.patch
> > > > 
> > > > Is there any way we could get this merged ?
> > > > 
> > > > One thing I like about the name TIF_KERNEL_TRACE compared to 
> > > > TIF_SYSCALL_FTRACE is that it gives us a per-thread flag that 
> > > > could eventually be used for more kernel tracing purposes than 
> > > > just syscalls.
> > > 
> > > Yeah - TIF_KERNEL_TRACE indeed sounds more descriptive and less 
> > > restrictive. TIF_SYSCALL_FTRACE was a bit ad-hoc.
> > > 
> > 
> > Second question :
> > 
> > LTTng :
> >         read_lock(&tasklist_lock);
> >         do_each_thread(p, t) {
> >                 set_tsk_thread_flag(t, TIF_KERNEL_TRACE);
> >         } while_each_thread(p, t);
> >         read_unlock(&tasklist_lock);
> > 
> > Ftrace:
> >         read_lock_irqsave(&tasklist_lock, flags);
> > 
> >         do_each_thread(g, t) {
> >                 clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> >         } while_each_thread(g, t);
> > 
> >         read_unlock_irqrestore(&tasklist_lock, flags);
> > 
> > With or without irqsave ?
> > 
> > Arguments against irqsave for this read lock :
> > 
> > - it's not used consistently for this read lock all over the kernel.
> >   Sometimes the read lock is taken without irqsave.
> > - it can be a long iteration, and therefore disables interrupts for a
> >   long time.
> > 
> > Arguments for irqsave for this read lock :
> > 
> > - Taking any kind of spin/rwlock with inconsistent irq disabling leads
> >   to races where interrupts can be disabled for an unbounded amount of
> >   time if a spinlock with irqoff waits on a spinlock with irqs on. This
> >   is a general problem with current kernel rwlock usage. See my
> >   "priority sifting reader-writer lock" patchset for a fix to this
> >   problem.
> > 
> > Mathieu
> > 
> 
> 
> I don't know why I used irqsave here, I guess I was tired.
> 
> $ git-grep "read_lock_irqsave(&tasklist_lock)" | wc -l
> 0
> $ git-grep "write_lock_irqsave(&tasklist_lock)" | wc -l
> 0
> 
> It is never used in an irq safe fashion, unless one of these sites
> has the irqs disabled.
> Lockdep should even have complained about this, when you hold
> a lock class in an irq safe fashion and thereafter you try to hold
> it in an irq unsafe fashion, then the state of the kernel becomes unsafe
> and lockdep is supposed to complain about that.

No, read-write lock is a "special case" where it does not deadlock if
you have an interrupt handler taking the read lock over another read
lock. It's just the write lock that _must absolutely_ disable
interrupts.

However, the "latency race" scenario I explained above applies here,
because the write lock disables interrupts and the read locks doesn't.

Mathieu

> 
> Frederic.
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
