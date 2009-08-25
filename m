Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZHYQUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZHYQUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZHYQUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:20:06 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:49945 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056AbZHYQUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:20:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAOimk0pMROOX/2dsb2JhbACBU9ZbgjKBaAU
Date: Tue, 25 Aug 2009 12:20:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090825162004.GA25058@Krystal>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:11:00 up 7 days,  3:00,  2 users,  load average: 0.13, 0.14,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hendrik Brueckner (brueckner@linux.vnet.ibm.com) wrote:
> On Tue, Aug 25, 2009 at 04:15:49PM +0200, Frederic Weisbecker wrote:
> > On Tue, Aug 25, 2009 at 02:50:27PM +0200, Hendrik Brueckner wrote:
> > > There are at least two scenarios where syscall_get_nr() can return -1:
> > > 
> > > 1. For example, ptrace stores an invalid syscall number, and thus,
> > >    tracing code resets it.
> > >    (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)
> > > 
> > > 2. The syscall_regfunc() (kernel/tracepoint.c) sets the TIF_SYSCALL_FTRACE
> > >    (now: TIF_SYSCALL_TRACEPOINT) flag for all threads which includes
> > >    kernel threads.
> > >    However, the ftrace selftest triggers a kernel oops when testing syscall
> > >    trace points:
> > >       - The kernel thread is started as ususal (do_fork()),
> > >       - tracing code sets TIF_SYSCALL_FTRACE,
> > >       - the ret_from_fork() function is triggered and starts
> > > 	ftrace_syscall_exit() with an invalid syscall number.
> > 
> > 
> > 
> > I wonder if there is any way to identify such situation...?
> For the second case, it might be an option to avoid setting the
> TIF_SYSCALL_FTRACE flag for kernel threads.
> 
> Kernel threads have task_struct->mm set to NULL.
> (Thanks to Heiko for that hint ;-)
> 
> The idea is then to check the mm field in syscall_regfunc() and
> set the flag accordingly.
> 
> However, I think the patch is an optional add-on becase checking
> the syscall number is still required for case 1).
> 
> ---
>  kernel/tracepoint.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -593,7 +593,9 @@ void syscall_regfunc(void)
>  	if (!sys_tracepoint_refcount) {
>  		read_lock_irqsave(&tasklist_lock, flags);
>  		do_each_thread(g, t) {
> -			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> +			/* Skip kernel threads. */
> +			if (t->mm)
> +				set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);

Uh ? kernel threads can invoke a system call. There are rare places
where kernel code actually invoke system calls. I don't see why we
should not deal with them.

Moreover, the problem you face is more general: if we set the
TIF_SYSCALL_FTRACE flag of a standard thread right in the middle of its
system call, x86_64 will cause the syscall exit to execute by re-reading
the thread flags and run a syscall trace exit.

We could simply initialize the "saved system calls id" number to
something like -1, so that if we happen to return from a syscall that
did not get its id recorded at syscall entry, we know it because it's
not initialized.

We would need to carefully put back the -1 value after clearing the
thread flag when we stop tracing too (while still holding a mutex).

Mathieu

>  		} while_each_thread(g, t);
>  		read_unlock_irqrestore(&tasklist_lock, flags);
>  	}
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
