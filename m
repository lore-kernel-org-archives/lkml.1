Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZCWQm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZCWQm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbZCWQmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:42:17 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:41476 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452AbZCWQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:42:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAE9Xx0lMQW1W/2dsb2JhbACBUNERg34G
Date: Mon, 23 Mar 2009 12:42:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       utrace-devel@redhat.com
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090323164208.GB22501@Krystal>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <49BEAA5A.4030708@redhat.com> <20090316201526.GE8393@nowhere> <49BEB8C4.2010606@redhat.com> <20090316214526.GA15119@Krystal> <20090316221800.GE12974@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090316221800.GE12974@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:35:11 up 23 days, 13:01,  1 user,  load average: 1.69, 0.92,
	0.66
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> 
> On Mon, Mar 16, 2009 at 05:45:26PM -0400, Mathieu Desnoyers wrote:
> 
> > [...]
> > > As far as I know, utrace supports multiple trace-engines on a process.
> > > Since ptrace is just an engine of utrace, you can add another engine on utrace.
> > > 
> > > utrace-+-ptrace_engine---owner_process
> > >        |
> > >        +-systemtap_module
> > >        |
> > >        +-ftrace_plugin
> 
> Right.  In this way, utrace is simply a multiplexing intermediary.
> 
> 
> > > Here, Frank had posted an example of utrace->ftrace engine.
> > > http://lkml.org/lkml/2009/1/27/294
> > > 
> > > And here is the latest his patch(which seems to support syscall tracing...)
> > > http://git.kernel.org/?p=linux/kernel/git/frob/linux-2.6-utrace.git;a=blob;f=kernel/trace/trace_process.c;h=619815f6c2543d0d82824139773deb4ca460a280;hb=ab20efa8d8b5ded96e8f8c3663dda3b4cb532124
> > > 
> > 
> > Reminder : we are looking at system-wide tracing here. Here are some
> > comments about the current utrace implementation.
> > 
> > Looking at include/linux/utrace.h from the tree
> > 
> > 17  * A tracing engine starts by calling utrace_attach_task() or
> > 18  * utrace_attach_pid() on the chosen thread, passing in a set of hooks
> > 19  * (&struct utrace_engine_ops), and some associated data.  This produces a
> > 20  * &struct utrace_engine, which is the handle used for all other
> > 21  * operations.  An attached engine has its ops vector, its data, and an
> > 22  * event mask controlled by utrace_set_events().
> > 
> > So if the system has, say 3000 threads, then we have 3000 struct
> > utrace_engine created ? I wonder what effet this could have one
> > cachelines if this is used to trace hot paths like system call
> > entry/exit. Have you benchmarked this kind of scenario under tbench ?
> 
> It has not been a problem, since utrace_engines are designed to be
> lightweight.  Starting or stopping a systemtap script of the form
> 
>     probe process.syscall {}
> 
> appears to have no noticable impact on a tbench suite.
> 

Do you mean starting this script for a single process or for _all_ the
processes and threads running on the system ?

> 
> > 24  * For each event bit that is set, that engine will get the
> > 25  * appropriate ops->report_*() callback when the event occurs.  The
> > 26  * &struct utrace_engine_ops need not provide callbacks for an event
> > 27  * unless the engine sets one of the associated event bits.
> > 
> > Looking at utrace_set_events(), we seem to be limited to 32 events on a
> > 32-bits architectures because it uses a bitmask ? Isn't it a bit small?
> 
> There are only a few types of thread events that involve different
> classes of treatment, or different degrees of freedom in terms of
> interference with the uninstrumented fast path of the threads.
> 
> For example, it does not make sense to have different flag bits for
> different system calls, since choosing to trace *any* system call
> involves taking the thread off of the fast path with the TIF_ flag.
> Once it's off the fast path, it doesn't matter whether the utrace core
> or some client performs syscall discrimination, so it is left to the
> client.
> 

If we limit ourself to thread-interaction events, I agree that they are
limited. But in the system-wide tracing scenario, the criterions for
filtering can apply to many more event categories.

Referring to Roland's reply, I think using utrace to enable system-wide
collection of data would just be a waste of resources. Going through a
more lightweight system-wide activation seems more appropriate to me.
Utrace is still a very promising tool to trace process-specific activity
though.

Mathieu

> 
> > 682 /**
> > 683  * utrace_set_events_pid - choose which event reports a tracing engine gets
> > 684  * @pid:                thread to affect
> > 685  * @engine:             attached engine to affect
> > 686  * @eventmask:          new event mask
> > 687  *
> > 688  * This is the same as utrace_set_events(), but takes a &struct pid
> > 689  * pointer rather than a &struct task_struct pointer.  The caller must
> > 690  * hold a ref on @pid, but does not need to worry about the task
> > 691  * staying valid.  If it's been reaped so that @pid points nowhere,
> > 692  * then this call returns -%ESRCH.
> > 
> > 
> > Comments like "but does not need to worry about the task staying valid"
> > does not make me feel safe and comfortable at all, could you explain
> > how you can assume that derefencing an "invalid" pointer will return
> > NULL ?
> 
> (We're doing a final round of "internal" (pre-LKML) reviews of the
> utrace implementation right now on utrace-devel@redhat.com, where such
> comments get fastest attention from the experts.)
> 
> For this particular issue, the utrace documentation file explains the
> liveness rules for the various pointers that can be fed to or received
> from utrace functions.  This is not about "feeling" safe, it's about
> what the mechanism is deliberately designed to permit.
> 
> 
> > About the utrace_attach_task() :
> > 
> > 244         if (unlikely(target->flags & PF_KTHREAD))
> > 245                 /*
> > 246                  * Silly kernel, utrace is for users!
> > 247                  */
> > 248                 return ERR_PTR(-EPERM);
> > 
> > So we cannot trace kernel threads ?
> 
> I'm not quite sure about all the reasons for this, but I believe that
> kernel threads don't tend to engage in job control / signal /
> system-call activities the same way as normal user threads do.
> 
> 
> > 118 /*
> > 119  * Called without locks, when we might be the first utrace engine to attach.
> > 120  * If this is a newborn thread and we are not the creator, we have to wait
> > 121  * for it.  The creator gets the first chance to attach.  The PF_STARTING
> > 122  * flag is cleared after its report_clone hook has had a chance to run.
> > 123  */
> > 124 static inline int utrace_attach_delay(struct task_struct *target)
> > 125 {
> > 126         if ((target->flags & PF_STARTING) && target->real_parent != current)
> > 127                 do {
> > 128                         schedule_timeout_interruptible(1);
> > 129                         if (signal_pending(current))
> > 130                                 return -ERESTARTNOINTR;
> > 131                 } while (target->flags & PF_STARTING);
> > 132
> > 133         return 0;
> > 134 }
> > 
> > Why do we absolutely have to poll until the thread has started ?
> 
> (I don't know off the top of my head - Roland?)
> 
> 
> > utrace_add_engine()
> >   set_notify_resume(target);
> > 
> > ok, so this is where the TIF_NOTIFY_RESUME thread flag is set. I notice
> > that it is set asynchronously with the execution of the target thread
> > (as I do with my TIF_KERNEL_TRACE thread flag).
> > 
> > However, on x86_64, _TIF_DO_NOTIFY_MASK is only tested in 
> > entry_64.S
> > 
> > int_signal:
> > and
> > retint_signal:
> > 
> > code paths. However, if there is no syscall tracing to do upon syscall
> > entry, the thread flags are not re-read at syscall exit and you will
> > miss the syscall exit returning from your target thread if this thread
> > was blocked while you set its TIF_NOTIFY_RESUME. Or is it handled in
> > some subtle way I did not figure out ? BTW re-reading the TIF flags from
> > the thread_info at syscall exit on the fast path is out of question
> > because it considerably degrades the kernel performances. entry_*.S is
> > a very, very critical path.
> 
> (I don't know off the top of my head - Roland?)
> 
> 
> - FChE

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
