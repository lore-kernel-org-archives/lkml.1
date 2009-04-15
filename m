Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZDOHFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZDOHFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZDOHEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:04:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbZDOHEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:04:50 -0400
Message-ID: <49E586E6.90100@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 15:04:06 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org>
In-Reply-To: <20090414172640.796858018@goodmis.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch lowers the number of places a developer must modify to add
> new tracepoints. The current method to add a new tracepoint
> into an existing system is to write the trace point macro in the
> trace header with one of the macros TRACE_EVENT, TRACE_FORMAT or
> DECLARE_TRACE, then they must add the same named item into the C file
> with the macro DEFINE_TRACE(name) and then add the trace point.
> 
> This change cuts out the needing to add the DEFINE_TRACE(name).
> Every file that uses the tracepoint must still include the trace/<type>.h
> file, but the one C file must also add a define before the including
> of that file.
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/mytrace.h>
> 
> This will cause the trace/mytrace.h file to also produce the C code
> necessary to implement the trace point.
> 
> Note, if more than one trace/<type>.h is used to create the C code
> it is best to list them all together.
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/foo.h>
>  #include <trace/bar.h>
>  #include <trace/fido.h>
> 
> Thanks to Mathieu Desnoyers and Christoph Hellwig for coming up with
> the cleaner solution of the define above the includes over my first
> design to have the C code include a "special" header.
> 
> This patch converts sched, irq and lockdep and skb to use this new
> method.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/define_trace.h |   75 ++++++++++++++++++++++++++++++++++++++++++
>  include/trace/irq.h          |    5 ++-
>  include/trace/kmem.h         |    4 ++-
>  include/trace/lockdep.h      |    3 ++
>  include/trace/sched.h        |    3 ++
>  include/trace/skb.h          |    3 ++
>  kernel/exit.c                |    4 --
>  kernel/fork.c                |    2 -
>  kernel/irq/handle.c          |    7 ++--
>  kernel/kthread.c             |    3 --
>  kernel/lockdep.c             |   12 ++-----
>  kernel/sched.c               |   10 ++----
>  kernel/signal.c              |    2 -
>  kernel/softirq.c             |    3 --
>  mm/util.c                    |   11 ++----
>  net/core/net-traces.c        |    4 +-
>  16 files changed, 105 insertions(+), 46 deletions(-)
>  create mode 100644 include/trace/define_trace.h
> 
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> new file mode 100644
> index 0000000..de9dc7d
> --- /dev/null
> +++ b/include/trace/define_trace.h
> @@ -0,0 +1,75 @@
> +/*
> + * Trace files that want to automate creationg of all tracepoints defined
> + * in their file should include this file. The following are macros that the
> + * trace file may define:
> + *
> + * TRACE_SYSTEM defines the system the tracepoint is for
> + *
> + * TRACE_INCLUDE_FILE if the file name is something other than TRACE_SYSTEM.h
> + *     This macro may be defined to tell define_trace.h what file to include.
> + *     Note, leave off the ".h".
> + *
> + * TRACE_INCLUDE_PATH if the path is something other than core kernel include/trace
> + *     then this macro can define the path to use. Note, the path is relative to
> + *     define_trace.h, not the file including it. Full path names for out of tree
> + *     modules must be used.
> + */
> +
> +#ifdef CREATE_TRACE_POINTS
> +
> +/* Prevent recursion */
> +#undef CREATE_TRACE_POINTS
> +
> +#include <linux/stringify.h>
> +
> +#undef TRACE_EVENT
> +#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
> +	DEFINE_TRACE(name)
> +
> +#undef TRACE_FORMAT
> +#define TRACE_FORMAT(name, proto, args, print)	\
> +	DEFINE_TRACE(name)
> +
> +#undef DECLARE_TRACE
> +#define DECLARE_TRACE(name, proto, args)	\
> +	DEFINE_TRACE(name)
> +
> +#undef TRACE_INCLUDE
> +#undef __TRACE_INCLUDE
> +
> +#ifndef TRACE_INCLUDE_FILE
> +# define TRACE_INCLUDE_FILE TRACE_SYSTEM
> +# define UNDEF_TRACE_INCLUDE_FILE
> +#endif
> +
> +#ifndef TRACE_INCLUDE_PATH
> +# define __TRACE_INCLUDE(system) <trace/system.h>
> +# define UNDEF_TRACE_INCLUDE_FILE
> +#else
> +# define __TRACE_INCLUDE(system) __stringify(TRACE_INCLUDE_PATH/system.h)
> +#endif
> +
> +# define TRACE_INCLUDE(system) __TRACE_INCLUDE(system)
> +
> +/* Let the trace headers be reread */
> +#define TRACE_HEADER_MULTI_READ
> +
> +#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
Hello, Steven

Include header file again is a power trap full of imagination.
It is great... but maybe we can choose a stupid way if we have.
And, TRACE_SYSTEM must be same as header file name if we use
current way.

How about just
#define TRACE_EVENT(name, proto, args, fmt) \
  DECLARE_TRACE(name, PARAMS(proto), PARAMS(args)) \
  DEFINE_TRACE(name)
in tracepoint.h?

It means we always define both whether for tracepoint provider or for
tracepoint user.(and make compiler a bit slow)

Thanks
Zhaolei

> +
> +#undef TRACE_HEADER_MULTI_READ
> +
> +/* Only undef what we defined in this file */
> +#ifdef UNDEF_TRACE_INCLUDE_FILE
> +# undef TRACE_INCLUDE_PATH
> +# undef UNDEF_TRACE_INCLUDE_FILE
> +#endif
> +
> +#ifdef UNDEF_TRACE_INCLUDE_FILE
> +# undef TRACE_INCLUDE_PATH
> +# undef UNDEF_TRACE_INCLUDE_FILE
> +#endif
> +
> +/* We may be processing more files */
> +#define CREATE_TRACE_POINTS
> +
> +#endif /* CREATE_TRACE_POINTS */
> diff --git a/include/trace/irq.h b/include/trace/irq.h
> index 04ab4c6..75e3468 100644
> --- a/include/trace/irq.h
> +++ b/include/trace/irq.h
> @@ -51,4 +51,7 @@ TRACE_FORMAT(softirq_exit,
>  	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
>  	);
>  
> -#endif
> +#endif /*  _TRACE_IRQ_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/include/trace/kmem.h b/include/trace/kmem.h
> index d7d1218..c22c42f 100644
> --- a/include/trace/kmem.h
> +++ b/include/trace/kmem.h
> @@ -188,5 +188,7 @@ TRACE_EVENT(kmem_cache_free,
>  
>  	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
>  );
> +#endif /* _TRACE_KMEM_H */
>  
> -#endif
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/include/trace/lockdep.h b/include/trace/lockdep.h
> index 8ee7900..4d301e7 100644
> --- a/include/trace/lockdep.h
> +++ b/include/trace/lockdep.h
> @@ -55,3 +55,6 @@ TRACE_EVENT(lock_acquired,
>  #endif
>  
>  #endif /* _TRACE_LOCKDEP_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/include/trace/sched.h b/include/trace/sched.h
> index 5b1cf4a..ffa1cab 100644
> --- a/include/trace/sched.h
> +++ b/include/trace/sched.h
> @@ -334,3 +334,6 @@ TRACE_EVENT(sched_signal_send,
>  );
>  
>  #endif /* _TRACE_SCHED_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/include/trace/skb.h b/include/trace/skb.h
> index e6fd281..1e8fabb 100644
> --- a/include/trace/skb.h
> +++ b/include/trace/skb.h
> @@ -35,3 +35,6 @@ TRACE_EVENT(kfree_skb,
>  );
>  
>  #endif /* _TRACE_SKB_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index abf9cf3..2fe9d2c 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -56,10 +56,6 @@
>  #include <asm/mmu_context.h>
>  #include "cred-internals.h"
>  
> -DEFINE_TRACE(sched_process_free);
> -DEFINE_TRACE(sched_process_exit);
> -DEFINE_TRACE(sched_process_wait);
> -
>  static void exit_mm(struct task_struct * tsk);
>  
>  static void __unhash_process(struct task_struct *p)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b9e2edd..4bebf26 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -83,8 +83,6 @@ DEFINE_PER_CPU(unsigned long, process_counts) = 0;
>  
>  __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
>  
> -DEFINE_TRACE(sched_process_fork);
> -
>  int nr_processes(void)
>  {
>  	int cpu;
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index d82142b..983d8be 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -17,9 +17,11 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/rculist.h>
>  #include <linux/hash.h>
> -#include <trace/irq.h>
>  #include <linux/bootmem.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/irq.h>
> +
>  #include "internals.h"
>  
>  /*
> @@ -348,9 +350,6 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
>  	       "but no thread function available.", irq, action->name);
>  }
>  
> -DEFINE_TRACE(irq_handler_entry);
> -DEFINE_TRACE(irq_handler_exit);
> -
>  /**
>   * handle_IRQ_event - irq action chain handler
>   * @irq:	the interrupt number
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 4ebaf85..e1c7692 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -21,9 +21,6 @@ static DEFINE_SPINLOCK(kthread_create_lock);
>  static LIST_HEAD(kthread_create_list);
>  struct task_struct *kthreadd_task;
>  
> -DEFINE_TRACE(sched_kthread_stop);
> -DEFINE_TRACE(sched_kthread_stop_ret);
> -
>  struct kthread_create_info
>  {
>  	/* Information passed to kthread() from kthreadd. */
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index c4582a6..257f21a 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -42,12 +42,14 @@
>  #include <linux/hash.h>
>  #include <linux/ftrace.h>
>  #include <linux/stringify.h>
> -#include <trace/lockdep.h>
>  
>  #include <asm/sections.h>
>  
>  #include "lockdep_internals.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/lockdep.h>
> +
>  #ifdef CONFIG_PROVE_LOCKING
>  int prove_locking = 1;
>  module_param(prove_locking, int, 0644);
> @@ -2929,8 +2931,6 @@ void lock_set_class(struct lockdep_map *lock, const char *name,
>  }
>  EXPORT_SYMBOL_GPL(lock_set_class);
>  
> -DEFINE_TRACE(lock_acquire);
> -
>  /*
>   * We are not always called with irqs disabled - do that here,
>   * and also avoid lockdep recursion:
> @@ -2957,8 +2957,6 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>  }
>  EXPORT_SYMBOL_GPL(lock_acquire);
>  
> -DEFINE_TRACE(lock_release);
> -
>  void lock_release(struct lockdep_map *lock, int nested,
>  			  unsigned long ip)
>  {
> @@ -3061,8 +3059,6 @@ found_it:
>  	put_lock_stats(stats);
>  }
>  
> -DEFINE_TRACE(lock_acquired);
> -
>  static void
>  __lock_acquired(struct lockdep_map *lock, unsigned long ip)
>  {
> @@ -3118,8 +3114,6 @@ found_it:
>  	lock->ip = ip;
>  }
>  
> -DEFINE_TRACE(lock_contended);
> -
>  void lock_contended(struct lockdep_map *lock, unsigned long ip)
>  {
>  	unsigned long flags;
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 5724508..e6d4518 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -72,13 +72,15 @@
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
> -#include <trace/sched.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
>  
>  #include "sched_cpupri.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/sched.h>
> +
>  /*
>   * Convert user-nice values [ -20 ... 0 ... 19 ]
>   * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
> @@ -118,12 +120,6 @@
>   */
>  #define RUNTIME_INF	((u64)~0ULL)
>  
> -DEFINE_TRACE(sched_wait_task);
> -DEFINE_TRACE(sched_wakeup);
> -DEFINE_TRACE(sched_wakeup_new);
> -DEFINE_TRACE(sched_switch);
> -DEFINE_TRACE(sched_migrate_task);
> -
>  #ifdef CONFIG_SMP
>  
>  static void double_rq_lock(struct rq *rq1, struct rq *rq2);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index d803473..1d5703f 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -41,8 +41,6 @@
>  
>  static struct kmem_cache *sigqueue_cachep;
>  
> -DEFINE_TRACE(sched_signal_send);
> -
>  static void __user *sig_handler(struct task_struct *t, int sig)
>  {
>  	return t->sighand->action[sig - 1].sa.sa_handler;
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 2fecefa..a2d9b45 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -186,9 +186,6 @@ EXPORT_SYMBOL(local_bh_enable_ip);
>   */
>  #define MAX_SOFTIRQ_RESTART 10
>  
> -DEFINE_TRACE(softirq_entry);
> -DEFINE_TRACE(softirq_exit);
> -
>  asmlinkage void __do_softirq(void)
>  {
>  	struct softirq_action *h;
> diff --git a/mm/util.c b/mm/util.c
> index 2599e83..0e74a22 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -4,9 +4,11 @@
>  #include <linux/module.h>
>  #include <linux/err.h>
>  #include <linux/sched.h>
> -#include <linux/tracepoint.h>
>  #include <asm/uaccess.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/kmem.h>
> +
>  /**
>   * kstrdup - allocate space for and copy an existing string
>   * @s: the string to duplicate
> @@ -239,13 +241,6 @@ int __attribute__((weak)) get_user_pages_fast(unsigned long start,
>  EXPORT_SYMBOL_GPL(get_user_pages_fast);
>  
>  /* Tracepoints definitions. */
> -DEFINE_TRACE(kmalloc);
> -DEFINE_TRACE(kmem_cache_alloc);
> -DEFINE_TRACE(kmalloc_node);
> -DEFINE_TRACE(kmem_cache_alloc_node);
> -DEFINE_TRACE(kfree);
> -DEFINE_TRACE(kmem_cache_free);
> -
>  EXPORT_TRACEPOINT_SYMBOL(kmalloc);
>  EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
>  EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
> diff --git a/net/core/net-traces.c b/net/core/net-traces.c
> index c8fb456..8017720 100644
> --- a/net/core/net-traces.c
> +++ b/net/core/net-traces.c
> @@ -19,11 +19,11 @@
>  #include <linux/workqueue.h>
>  #include <linux/netlink.h>
>  #include <linux/net_dropmon.h>
> -#include <trace/skb.h>
>  
>  #include <asm/unaligned.h>
>  #include <asm/bitops.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/skb.h>
>  
> -DEFINE_TRACE(kfree_skb);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);


