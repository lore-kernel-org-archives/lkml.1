Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZCMPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZCMPQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbZCMPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:16:41 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:53412 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbZCMPQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z7KV+zYah7mLlGokRok/zDM0dxplC1odDqSozbD4l+R290S02GHPobdH1+di+FHHUY
         9NKAi/javMITzZhLw7ujG2/zfbfbZ4ku+yEX011tDOAD2qAFyrpMtL46tpXSCQxQTeg6
         UhmNOcZHG8FxkpDqdR2tQED9CXlhLINggnvxc=
Date: Fri, 13 Mar 2009 16:16:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 0/2 v2] Syscalls tracing
Message-ID: <20090313151632.GB9867@nowhere>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 03:42:10PM +0100, Frederic Weisbecker wrote:
> tracing/syscalls: core infrastructure to trace syscalls
> 
> This new iteration addresses a good part of the previous reviews.


Ah I just discovered that you applied the previous version today.
But the v2 is not a delta :-s

I can rebase them but not until Sunday.

 
> As suggested by Ingo Molnar and Peter Zijlstra, the syscalls
> prototypes probing is done by abusing the SYSCALL_DEFINE family
> macros.
> We now store automatically the arguments names, their types, their number
> and the name of the syscall.
> 
> Also some fixes on output newlines and dangerous exporting of global_trace
> are provided.
> 
> An example of the trace:
> 
> echo syscall > /debugfs/tracing/current_tracer
> 
> 
> # tracer: syscall
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>            <...>-5080  [001]   132.192228: sys_dup2(oldfd: a, newfd: 1) 
>            <...>-5080  [001]   132.192239: sys_dup2 -> 0x1
>            <...>-5080  [001]   132.192242: sys_fcntl(fd: a, cmd: 1, arg: 0) 
>            <...>-5080  [001]   132.192245: sys_fcntl -> 0x1
>            <...>-5080  [001]   132.192248: sys_close(fd: a) 
>            <...>-5080  [001]   132.192250: sys_close -> 0x0
>            <...>-5080  [001]   132.192265: sys_rt_sigprocmask(how: 0, set: 0, oset: 6cf808, sigsetsize: 8) 
>            <...>-5080  [001]   132.192267: sys_rt_sigprocmask -> 0x0
>            <...>-5080  [001]   132.192271: sys_rt_sigaction(sig: 2, act: 7fffff4338f0, oact: 7fffff433850, sigsetsize: 8) 
>            <...>-5080  [001]   132.192273: sys_rt_sigaction -> 0x0
>            <...>-5080  [001]   132.192285: sys_rt_sigprocmask(how: 0, set: 0, oset: 6cf808, sigsetsize: 8) 
>            <...>-5080  [001]   132.192287: sys_rt_sigprocmask -> 0x0
>            <...>-5080  [001]   132.192415: sys_write(fd: 1, buf: 15dfc08, count: 21) 
>            <...>-5080  [001]   132.192436: sys_write -> 0x21
>            <...>-4754  [000]   132.192478: sys_read(fd: 8, buf: 2a9340e, count: 1fee) 
>            <...>-5080  [001]   132.192487: sys_rt_sigprocmask(how: 0, set: 7fffff432a70, oset: 7fffff4329f0, sigsetsize: 8) 
> 
> And if you ask for the parameters types:
> 
> echo syscall_arg_type > trace_options
> 
> # tracer: syscall
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>            <...>-5080  [001]   132.192228: sys_dup2(unsigned int oldfd: a, unsigned int newfd: 1) 
>            <...>-5080  [001]   132.192239: sys_dup2 -> 0x1
>            <...>-5080  [001]   132.192242: sys_fcntl(unsigned int fd: a, unsigned int cmd: 1, unsigned long arg: 0) 
>            <...>-5080  [001]   132.192245: sys_fcntl -> 0x1
>            <...>-5080  [001]   132.192248: sys_close(unsigned int fd: a) 
>            <...>-5080  [001]   132.192250: sys_close -> 0x0
>            <...>-5080  [001]   132.192265: sys_rt_sigprocmask(int how: 0, sigset_t * set: 0, sigset_t * oset: 6cf808, size_t sigsetsize: 8) 
>            <...>-5080  [001]   132.192267: sys_rt_sigprocmask -> 0x0
>            <...>-5080  [001]   132.192271: sys_rt_sigaction(int sig: 2, const struct sigaction * act: 7fffff4338f0, struct sigaction * oact: 7fffff433850, size_t sigsetsize: 8) 
>            <...>-5080  [001]   132.192273: sys_rt_sigaction -> 0x0
>            <...>-5080  [001]   132.192285: sys_rt_sigprocmask(int how: 0, sigset_t * set: 0, sigset_t * oset: 6cf808, size_t sigsetsize: 8) 
>            <...>-5080  [001]   132.192287: sys_rt_sigprocmask -> 0x0
>            <...>-5080  [001]   132.192415: sys_write(unsigned int fd: 1, const char * buf: 15dfc08, size_t count: 21) 
>            <...>-5080  [001]   132.192436: sys_write -> 0x21
> 
> TODO:
> 
> - add a single mask on the struct syscall_metadata to provide quickly which arguments is
>   a pointer (usually type __user *p) so that the user can decide if he wants to save them of tracing time
> 
> - now that we have each parameter type as strings, add a new field on struct syscall_metadata to have the parameter types
>   encoded as single enum values (for quick checks) so that we can use specific callbacks for each parameter type
>   to be displayed.
> 
> NOTE: this is still not overlapping with a potential future merge of utrace, since the low-level hooks on
> the syscalls remain somewhat basic.
> 
> NOTE2: I've only tested it on x86-64 for now, so only x86-64 support is provided.
> --
> 
> Frederic Weisbecker (2):
>   tracing/syscalls: core infrastructure for syscalls tracing
>   tracing/syscalls: support for syscalls tracing on x86-64
> 
>  arch/x86/Kconfig                   |    1 +
>  arch/x86/include/asm/ftrace.h      |    7 +
>  arch/x86/include/asm/thread_info.h |    9 +-
>  arch/x86/kernel/ftrace.c           |   63 +++++++++
>  arch/x86/kernel/ptrace.c           |    7 +
>  include/asm-generic/vmlinux.lds.h  |   11 ++-
>  include/linux/ftrace.h             |   29 +++++
>  include/linux/syscalls.h           |   60 +++++++++-
>  kernel/trace/Kconfig               |   10 ++
>  kernel/trace/Makefile              |    1 +
>  kernel/trace/trace.h               |   19 +++
>  kernel/trace/trace_syscalls.c      |  243 ++++++++++++++++++++++++++++++++++++
>  12 files changed, 454 insertions(+), 6 deletions(-)
>  create mode 100644 kernel/trace/trace_syscalls.c
> 

