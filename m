Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZCOQCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZCOQCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 12:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZCOQCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 12:02:05 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:63649 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZCOQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C91Szxlua4dMcjKqb/JE0Y7OTYZT9092Eh3mMz74AC2lZ4wnZ7J0RIlL4WzKa8ejrs
         rzIRzXuCNSpQ46VB14uOdtakbAeyUzbsvZUcOcps+KZLtJNTvU/8UMY3QGy7xFLAKmxA
         d6cwjwj8dCCfjqZB3H9IJi1yoP6c0dST+hA68=
Date: Sun, 15 Mar 2009 17:01:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 0/2 v2] Syscalls tracing
Message-ID: <20090315160132.GD5105@nowhere>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <20090313151632.GB9867@nowhere> <20090313164743.GC3354@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313164743.GC3354@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 12:47:43PM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Fri, Mar 13, 2009 at 03:42:10PM +0100, Frederic Weisbecker wrote:
> > > tracing/syscalls: core infrastructure to trace syscalls
> > > 
> > > This new iteration addresses a good part of the previous reviews.
> > 
> > 
> > Ah I just discovered that you applied the previous version today.
> > But the v2 is not a delta :-s
> > 
> > I can rebase them but not until Sunday.
> > 
> 
> Hi Frederic,
> 
> I like the approach you are taking for syscall tracing. As I read your
> code, I see that your infrastructure basically exports the information
> under ascii format. How hard do you think that would be to get this to
> work for binary output with LTTng ? Ascii output is not exactly a
> high-performance output for a hot path such as system call entry/exit.
> We could :


Do you mean the syscalls metadata? (syscall name, argument types, number
of arguments) or the syscall events?

I'm not sure it would be valuable to export the metadata as binary because
they are not very large as a whole. But a kind of enumeration of types
will be added as I explain below.

But I plan to export the events as binary values, though the usual tracing
files.
 
> 1 - Iterate on the table at trace start to dump the syscall names, and
> their arguments, into a syscall-table data channel.


Yeah.
For now the arguments parameters types are saved as strings as you know.
I would like to add a new field on the syscall_metadata struct which will
contain the arg types as enum values so that the tracer will be able to:

- Define custom callback for custom types to display better the arguments
  I think I could provide a default output for each parameter type and
  let the ability to override this default output with custom callback.
  For example, it would be great to have the open flag as O_RDONLY instead
  of the numerical value.

- probably create a raw format string value for each syscall so that we can
  export the binary values directly to userspace and the user can format all
  that with the pattern we give to him.


> 2 - We might have to create one event type per syscall argument types.
> Or one event per syscall, this would be great because we would benefit
> from the event identification infrastructure. And actually, the syscall
> declaration macros could declare tiny callbacks that would declare a
> marker name (syscall, <syscall_name>) along with the code that saves the
> system call pr_regs parameters into the event payload.
> 
> Any thoughts ?


I will surely have to provide a way to define custom callbacks for several
syscalls (as shown with the open() flag example).
But the problem is that I will not be able to do that statically like the
metadata is currently built.
Such a thing should be built when we enable the syscall tracing once I guess
(iterate over the syscalls metadata, assign the callback that matches a syscall,
etc...).

But I think I will need sometimes complex callbacks to handle the output of
some complex arguments, so I don't know if it is possible to handled all that
through a marker or TRACE_EVENT style.

Thanks!

Frederic.


> 
> Mathieu
> 
> >  
> > > As suggested by Ingo Molnar and Peter Zijlstra, the syscalls
> > > prototypes probing is done by abusing the SYSCALL_DEFINE family
> > > macros.
> > > We now store automatically the arguments names, their types, their number
> > > and the name of the syscall.
> > > 
> > > Also some fixes on output newlines and dangerous exporting of global_trace
> > > are provided.
> > > 
> > > An example of the trace:
> > > 
> > > echo syscall > /debugfs/tracing/current_tracer
> > > 
> > > 
> > > # tracer: syscall
> > > #
> > > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > #              | |       |          |         |
> > >            <...>-5080  [001]   132.192228: sys_dup2(oldfd: a, newfd: 1) 
> > >            <...>-5080  [001]   132.192239: sys_dup2 -> 0x1
> > >            <...>-5080  [001]   132.192242: sys_fcntl(fd: a, cmd: 1, arg: 0) 
> > >            <...>-5080  [001]   132.192245: sys_fcntl -> 0x1
> > >            <...>-5080  [001]   132.192248: sys_close(fd: a) 
> > >            <...>-5080  [001]   132.192250: sys_close -> 0x0
> > >            <...>-5080  [001]   132.192265: sys_rt_sigprocmask(how: 0, set: 0, oset: 6cf808, sigsetsize: 8) 
> > >            <...>-5080  [001]   132.192267: sys_rt_sigprocmask -> 0x0
> > >            <...>-5080  [001]   132.192271: sys_rt_sigaction(sig: 2, act: 7fffff4338f0, oact: 7fffff433850, sigsetsize: 8) 
> > >            <...>-5080  [001]   132.192273: sys_rt_sigaction -> 0x0
> > >            <...>-5080  [001]   132.192285: sys_rt_sigprocmask(how: 0, set: 0, oset: 6cf808, sigsetsize: 8) 
> > >            <...>-5080  [001]   132.192287: sys_rt_sigprocmask -> 0x0
> > >            <...>-5080  [001]   132.192415: sys_write(fd: 1, buf: 15dfc08, count: 21) 
> > >            <...>-5080  [001]   132.192436: sys_write -> 0x21
> > >            <...>-4754  [000]   132.192478: sys_read(fd: 8, buf: 2a9340e, count: 1fee) 
> > >            <...>-5080  [001]   132.192487: sys_rt_sigprocmask(how: 0, set: 7fffff432a70, oset: 7fffff4329f0, sigsetsize: 8) 
> > > 
> > > And if you ask for the parameters types:
> > > 
> > > echo syscall_arg_type > trace_options
> > > 
> > > # tracer: syscall
> > > #
> > > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > #              | |       |          |         |
> > >            <...>-5080  [001]   132.192228: sys_dup2(unsigned int oldfd: a, unsigned int newfd: 1) 
> > >            <...>-5080  [001]   132.192239: sys_dup2 -> 0x1
> > >            <...>-5080  [001]   132.192242: sys_fcntl(unsigned int fd: a, unsigned int cmd: 1, unsigned long arg: 0) 
> > >            <...>-5080  [001]   132.192245: sys_fcntl -> 0x1
> > >            <...>-5080  [001]   132.192248: sys_close(unsigned int fd: a) 
> > >            <...>-5080  [001]   132.192250: sys_close -> 0x0
> > >            <...>-5080  [001]   132.192265: sys_rt_sigprocmask(int how: 0, sigset_t * set: 0, sigset_t * oset: 6cf808, size_t sigsetsize: 8) 
> > >            <...>-5080  [001]   132.192267: sys_rt_sigprocmask -> 0x0
> > >            <...>-5080  [001]   132.192271: sys_rt_sigaction(int sig: 2, const struct sigaction * act: 7fffff4338f0, struct sigaction * oact: 7fffff433850, size_t sigsetsize: 8) 
> > >            <...>-5080  [001]   132.192273: sys_rt_sigaction -> 0x0
> > >            <...>-5080  [001]   132.192285: sys_rt_sigprocmask(int how: 0, sigset_t * set: 0, sigset_t * oset: 6cf808, size_t sigsetsize: 8) 
> > >            <...>-5080  [001]   132.192287: sys_rt_sigprocmask -> 0x0
> > >            <...>-5080  [001]   132.192415: sys_write(unsigned int fd: 1, const char * buf: 15dfc08, size_t count: 21) 
> > >            <...>-5080  [001]   132.192436: sys_write -> 0x21
> > > 
> > > TODO:
> > > 
> > > - add a single mask on the struct syscall_metadata to provide quickly which arguments is
> > >   a pointer (usually type __user *p) so that the user can decide if he wants to save them of tracing time
> > > 
> > > - now that we have each parameter type as strings, add a new field on struct syscall_metadata to have the parameter types
> > >   encoded as single enum values (for quick checks) so that we can use specific callbacks for each parameter type
> > >   to be displayed.
> > > 
> > > NOTE: this is still not overlapping with a potential future merge of utrace, since the low-level hooks on
> > > the syscalls remain somewhat basic.
> > > 
> > > NOTE2: I've only tested it on x86-64 for now, so only x86-64 support is provided.
> > > --
> > > 
> > > Frederic Weisbecker (2):
> > >   tracing/syscalls: core infrastructure for syscalls tracing
> > >   tracing/syscalls: support for syscalls tracing on x86-64
> > > 
> > >  arch/x86/Kconfig                   |    1 +
> > >  arch/x86/include/asm/ftrace.h      |    7 +
> > >  arch/x86/include/asm/thread_info.h |    9 +-
> > >  arch/x86/kernel/ftrace.c           |   63 +++++++++
> > >  arch/x86/kernel/ptrace.c           |    7 +
> > >  include/asm-generic/vmlinux.lds.h  |   11 ++-
> > >  include/linux/ftrace.h             |   29 +++++
> > >  include/linux/syscalls.h           |   60 +++++++++-
> > >  kernel/trace/Kconfig               |   10 ++
> > >  kernel/trace/Makefile              |    1 +
> > >  kernel/trace/trace.h               |   19 +++
> > >  kernel/trace/trace_syscalls.c      |  243 ++++++++++++++++++++++++++++++++++++
> > >  12 files changed, 454 insertions(+), 6 deletions(-)
> > >  create mode 100644 kernel/trace/trace_syscalls.c
> > > 
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

