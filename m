Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXDTEgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXDTEgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXDTEgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:36:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbXDTEgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:36:22 -0400
Date: Thu, 19 Apr 2007 21:36:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] Performance Stats: Kernel patch
Message-Id: <20070419213614.6416a2be.akpm@linux-foundation.org>
In-Reply-To: <4625FFCF.8040402@ru.mvista.com>
References: <4625FFCF.8040402@ru.mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(re-added lklml)

> Patch makes available to the user the following 
> thread performance statistics:
>    * Involuntary Context Switches (task_struct->nivcsw)
>    * Voluntary Context Switches (task_struct->nvcsw)

I suppose they might be useful, but I'd be interested in hearing what
the uses of this information are - why is it valuable?

>    * Number of system calls (added new counter 
>      thread_info->sysc_cnt)

eek.  syscall entry is a really hot hotpath, and, perhaps worse, it's the
sort of thing which people often measure ;)

I agree that this is a potentially interesting piece of instrumentation,
but it would need to be _super_ interesting to justify just the single
instruction overhead, and the cacheline touch.

So, again, please provide justification for this additional overhead.

> Statistics information is available from
> /proc/PID/status

No, /prod/pid is very lame.  If we're going to do this then we'll need to
deliver the information via taskstats.  And update getdelays.c and the
documentation, too.  We could also make it visible in /proc I guess, if
that's cheap to do.  But taskstats is the primary means of delivery - using
/proc is daft when we have that.

>  arch/powerpc/kernel/entry_32.S    |    5 +++++
>  arch/powerpc/kernel/entry_64.S    |    5 +++++
>  arch/x86_64/kernel/asm-offsets.c  |    3 +++
>  arch/x86_64/kernel/entry.S        |    3 +++
>  fs/proc/array.c                   |   17 +++++++++++++++++
>  include/asm-i386/thread_info.h    |    5 +++--
>  include/asm-powerpc/thread_info.h |    3 +++
>  include/asm-x86_64/thread_info.h  |    4 +++-
>  kernel/fork.c                     |    4 ++++
>  lib/Kconfig.debug                 |   15 +++++++++++++++
>  13 files changed, 71 insertions(+), 3 deletions(-)
> 

The patch adds far too many ifdefs to core C files.

> +#ifdef CONFIG_THREAD_PERF_STAT
> +static inline char *task_perf(struct task_struct *p, char *buffer)
> +{
> +#ifdef CONFIG_THREAD_PERF_STAT_SYSC
> +       buffer += sprintf(buffer, "Syscalls:\t%lu\n", p->thread_info->sysc_cnt);
> +#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
> +
> +       return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
> +                           "Nivcsw:\t%lu\n",
> +                           p->nvcsw,
> +                           p->nivcsw);
> +}

Here, you can put

#else
static inline char *task_perf(struct task_struct *p, char *buffer)
{
	return buffer;
}

> +#endif /* CONFIG_THREAD_PERF_STAT */
> +
>  int proc_pid_status(struct task_struct *task, char * buffer)
>  {
>  	char * orig = buffer;
> @@ -309,6 +323,9 @@ int proc_pid_status(struct task_struct *
>  #if defined(CONFIG_S390)
>  	buffer = task_show_regs(task, buffer);
>  #endif
> +#ifdef CONFIG_THREAD_PERF_STAT
> +	buffer = task_perf(task, buffer);
> +#endif /* CONFIG_THREAD_PERF_STAT */

so these ifdefs go away

>  	return buffer - orig;
>  }
>  
> Index: linux-2.6.21-rc5/kernel/fork.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/kernel/fork.c
> +++ linux-2.6.21-rc5/kernel/fork.c
> @@ -1044,6 +1044,10 @@ static struct task_struct *copy_process(
>  	p->syscr = 0;		/* I/O counter: read syscalls */
>  	p->syscw = 0;		/* I/O counter: write syscalls */
>  #endif
> +#ifdef CONFIG_THREAD_PERF_STAT_SYSC
> +        p->thread_info->sysc_cnt = 0;   /* Syscall counter: total numbers of syscalls */
> +#endif /* CONFIG_THREAD_PERF_STAT_SYSC */

And this can be removed via

#ifdef CONFIG_THREAD_PERF_STAT_SYSC
static inline thread_perf_stat_init(struct task_struct *p)
{
	p->thread_info->sysc_cnt = 0;
}
#else
static inline thread_perf_stat_init(struct task_struct *p)
{
}
#endif

in a header file somewhere.

But I expect that you'll find that all your ifdefs can be removed, and you
can piggyback the whole feature on top of one of the existing taskstats
config items.

>  	task_io_accounting_init(p);

So sysc_cnt will then get initialised in task_io_accounting_init() (perhaps
after suitably renaming task_io_accounting_init())

> +config THREAD_PERF_STAT
> +       bool "Thread performance statistics"
> +       help
> +         Make available to the user the following per-thread performance statistics:
> +            * Number of involuntary context switches
> +            * Number of voluntary context switches
> +            * Number of system calls (optional)
> +         This information is available via /proc/PID/status.
> +
> +config THREAD_PERF_STAT_SYSC
> +       bool "Enable syscall counter"
> +       depends on THREAD_PERF_STAT && (X86 || PPC)
> +       help
> +         This option adds a syscall counter to /proc/PID/status.

I'm dubious about the configurability.

I think this is the sort of feature which we'd want to have generally
available, and to discourage people from disabling it.  I mean, if it's
useful enough to justify the runtime overhead, then it's pretty darn useful
and a lot of people will want it.

Probably making this a part of the taskstats suite would cover this well
enough.

> Index: linux-2.6.21-rc5/arch/i386/kernel/entry.S
> ===================================================================
> --- linux-2.6.21-rc5.orig/arch/i386/kernel/entry.S
> +++ linux-2.6.21-rc5/arch/i386/kernel/entry.S
> @@ -334,6 +334,9 @@ sysenter_past_esp:
>  	CFI_ADJUST_CFA_OFFSET 4
>  	SAVE_ALL
>  	GET_THREAD_INFO(%ebp)
> +#ifdef CONFIG_THREAD_PERF_STAT_SYSC
> +        incl    TI_sysc_cnt(%ebp)       # Increment syscalls counter
> +#endif /* CONFIG_THREAD_PERF_STAT_SYSC */

There's no sane way of avoiding an ifdef here.

> +	ENTRY(sysc_cnt);

Please don't use arbitrarily truncated identifiers like sysc_count.  oops,
syscall_cnt, oops, sysc_cnt.

nr_syscalls or syscall_count would be the expected identifiers here.





But there's not much point in firing up the editor until we've worked out
why we want to add these features to the kernel.

