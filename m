Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZHYQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZHYQ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZHYQ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:59:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:7821 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbZHYQ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KcKGMT2p+myFa6YbZqfgVxER0v9sqTfmZMO5ZfZatftilEveFxZ9jhEuXyDLjl6ngR
         VRnEMIfOl8JlJpca/X8GIHiUjFiR+5fCTBZep31Y3JbPnttkmAQYRlt14BmvDK7vAili
         aaCr6ZRObLbG7rLuy8ExF5Ly9Fnq1dFqOb/wg=
Date: Tue, 25 Aug 2009 18:59:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090825165912.GI6114@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825162004.GA25058@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 12:20:04PM -0400, Mathieu Desnoyers wrote:
> * Hendrik Brueckner (brueckner@linux.vnet.ibm.com) wrote:
> > On Tue, Aug 25, 2009 at 04:15:49PM +0200, Frederic Weisbecker wrote:
> > > On Tue, Aug 25, 2009 at 02:50:27PM +0200, Hendrik Brueckner wrote:
> > > > There are at least two scenarios where syscall_get_nr() can return -1:
> > > > 
> > > > 1. For example, ptrace stores an invalid syscall number, and thus,
> > > >    tracing code resets it.
> > > >    (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)
> > > > 
> > > > 2. The syscall_regfunc() (kernel/tracepoint.c) sets the TIF_SYSCALL_FTRACE
> > > >    (now: TIF_SYSCALL_TRACEPOINT) flag for all threads which includes
> > > >    kernel threads.
> > > >    However, the ftrace selftest triggers a kernel oops when testing syscall
> > > >    trace points:
> > > >       - The kernel thread is started as ususal (do_fork()),
> > > >       - tracing code sets TIF_SYSCALL_FTRACE,
> > > >       - the ret_from_fork() function is triggered and starts
> > > > 	ftrace_syscall_exit() with an invalid syscall number.
> > > 
> > > 
> > > 
> > > I wonder if there is any way to identify such situation...?
> > For the second case, it might be an option to avoid setting the
> > TIF_SYSCALL_FTRACE flag for kernel threads.
> > 
> > Kernel threads have task_struct->mm set to NULL.
> > (Thanks to Heiko for that hint ;-)
> > 
> > The idea is then to check the mm field in syscall_regfunc() and
> > set the flag accordingly.
> > 
> > However, I think the patch is an optional add-on becase checking
> > the syscall number is still required for case 1).
> > 
> > ---
> >  kernel/tracepoint.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -593,7 +593,9 @@ void syscall_regfunc(void)
> >  	if (!sys_tracepoint_refcount) {
> >  		read_lock_irqsave(&tasklist_lock, flags);
> >  		do_each_thread(g, t) {
> > -			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +			/* Skip kernel threads. */
> > +			if (t->mm)
> > +				set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> 
> Uh ? kernel threads can invoke a system call. There are rare places
> where kernel code actually invoke system calls. I don't see why we
> should not deal with them.



Yeah they do, but they don't use the sysenter path, they call the
syscall helpers directly, such as do_fork() or things like that.

The syscall tracepoints are set in the sysenter/sysexit path, then
it's no use to trace the kernel threads, it doesn't have any effect,
except random results in case of fork() calls, because we take
the ret_from_fork() path that also ends up to trace_sys_exit()
if the TIF_SYSCALL_TRACEPOINT thing is set, leading to such
asymetric tracing.

Kernel threads use syscalls toward wrappers such as create_thread().
So instead, statically defined tracepoints in create_thread() and such
other syscall wrappers for kernel threads seem more valuable, hmm?

 
> Moreover, the problem you face is more general: if we set the
> TIF_SYSCALL_FTRACE flag of a standard thread right in the middle of its
> system call, x86_64 will cause the syscall exit to execute by re-reading
> the thread flags and run a syscall trace exit.


Well, I don't think that's the problem. The issue here, if I understand
correctly, is that kernel threads don't take the sysenter path, then never hit
the trace_sys_enter() call. And usually they won't ever hit any
trace_sys_exit() calls except in the fork() case, because we take
the ret_from_fork() path, which lead to syscall exit tracing due
to the TIF flags set.

At this stage, the syscall number is supposed to be stored in orig_eax,
but because the kernel thread hasn't called fork() through a syscall and
has called do_fork() directly, the regs values have nothing that look
like syscall parameters.

I guess we don't need to take the sys_enter tracing path to have a sane
orig_eax in the sys_exit tracing path (for non kernel threads).
Though I'm not sure about that, I should check to be sure.

> We could simply initialize the "saved system calls id" number to
> something like -1, so that if we happen to return from a syscall that
> did not get its id recorded at syscall entry, we know it because it's
> not initialized.
> 
> We would need to carefully put back the -1 value after clearing the
> thread flag when we stop tracing too (while still holding a mutex).
> 
> Mathieu
> 
> >  		} while_each_thread(g, t);
> >  		read_unlock_irqrestore(&tasklist_lock, flags);
> >  	}
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

