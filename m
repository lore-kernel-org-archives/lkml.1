Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZCDLYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZCDLYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZCDLX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:23:59 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:37367 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZCDLX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:23:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EffV/33g0pE+daJW7CwIsuYCxMCNtVUzOdjCKFGAj6iqZyaCdxsaE9CGwXQr3T4ZGn
         SxcEwVRGXOkfwPURv4q8HVfzBQRoMf91Pw/CmrCV28rgAZaZRI2T8h5aE7EyexuK54K1
         bo6M3nf8tVRKW6j1660/t4HJ7xOKPoWoyaJ6A=
Date: Wed, 4 Mar 2009 12:23:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: lockdep tracepoints
Message-ID: <20090304112345.GB6032@nowhere>
References: <1236164586.5330.7142.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236164586.5330.7142.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 12:03:06PM +0100, Peter Zijlstra wrote:
> Lets add LKML this time :-)
> 
> ---
> Subject: tracing: lockdep tracepoints
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Mar 03 22:03:08 CET 2009
> 
> Augment the traces with lock names when lockdep is available:
> 
>  1)               |  down_read_trylock() {
>  1)               |    _spin_lock_irqsave() {
>  1)               |      /* lock_acquire: name: &sem->wait_lock */
>  1)   4.201 us    |    }
>  1)               |    _spin_unlock_irqrestore() {
>  1)               |      /* lock_release: name: &sem->wait_lock */

Nice idea.
I would just suggest to drop the "name:" since the comment is intuitive enough
to figure out what we have after lock_{release,acquire}: 

Frederic.


>  1)   3.523 us    |    }
>  1)               |  /* lock_acquire: try read name: &mm->mmap_sem */
>  1) + 13.386 us   |  }
>  1)   1.635 us    |  find_vma();
>  1)               |  handle_mm_fault() {
>  1)               |    __do_fault() {
>  1)               |      filemap_fault() {
>  1)               |        find_lock_page() {
>  1)               |          find_get_page() {
>  1)               |            /* lock_acquire: read name: rcu_read_lock */
>  1)               |            /* lock_release: name: rcu_read_lock */
>  1)   5.697 us    |          }
>  1)   8.158 us    |        }
>  1) + 11.079 us   |      }
>  1)               |      _spin_lock() {
>  1)               |        /* lock_acquire: name: __pte_lockptr(page) */
>  1)   3.949 us    |      }
>  1)   1.460 us    |      page_add_file_rmap();
>  1)               |      _spin_unlock() {
>  1)               |        /* lock_release: name: __pte_lockptr(page) */
>  1)   3.115 us    |      }
>  1)               |      unlock_page() {
>  1)   1.421 us    |        page_waitqueue();
>  1)   1.220 us    |        __wake_up_bit();
>  1)   6.519 us    |      }
>  1) + 34.328 us   |    }
>  1) + 37.452 us   |  }
>  1)               |  up_read() {
>  1)               |  /* lock_release: name: &mm->mmap_sem */
>  1)               |    _spin_lock_irqsave() {
>  1)               |      /* lock_acquire: name: &sem->wait_lock */
>  1)   3.865 us    |    }
>  1)               |    _spin_unlock_irqrestore() {
>  1)               |      /* lock_release: name: &sem->wait_lock */
>  1)   8.562 us    |    }
>  1) + 17.370 us   |  }
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/trace/lockdep.h             |    9 +++++++
>  include/trace/lockdep_event_types.h |   44 ++++++++++++++++++++++++++++++++++++
>  include/trace/trace_event_types.h   |    1 
>  include/trace/trace_events.h        |    1 
>  kernel/lockdep.c                    |   17 +++++++++++++
>  kernel/trace/trace.c                |   14 ++++++-----
>  kernel/trace/trace_events_stage_3.h |    4 +--
>  7 files changed, 82 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/include/trace/lockdep.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/trace/lockdep.h
> @@ -0,0 +1,9 @@
> +#ifndef _TRACE_LOCKDEP_H
> +#define _TRACE_LOCKDEP_H
> +
> +#include <linux/lockdep.h>
> +#include <linux/tracepoint.h>
> +
> +#include <trace/lockdep_event_types.h>
> +
> +#endif
> Index: linux-2.6/include/trace/lockdep_event_types.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/trace/lockdep_event_types.h
> @@ -0,0 +1,44 @@
> +
> +#ifndef TRACE_EVENT_FORMAT
> +# error Do not include this file directly.
> +# error Unless you know what you are doing.
> +#endif
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM lock
> +
> +#ifdef CONFIG_LOCKDEP
> +
> +TRACE_FORMAT(lock_acquire,
> +	TPPROTO(struct lockdep_map *lock, unsigned int subclass,
> +		int trylock, int read, int check,
> +		struct lockdep_map *next_lock, unsigned long ip),
> +	TPARGS(lock, subclass, trylock, read, check, next_lock, ip),
> +	TPFMT("%s%sname: %s", trylock ? "try " : "",
> +		read ? "read " : "", lock->name)
> +	);
> +
> +TRACE_FORMAT(lock_release,
> +	TPPROTO(struct lockdep_map *lock, int nested, unsigned long ip),
> +	TPARGS(lock, nested, ip),
> +	TPFMT("name: %s", lock->name)
> +	);
> +
> +#ifdef CONFIG_LOCK_STAT
> +
> +TRACE_FORMAT(lock_contended,
> +	TPPROTO(struct lockdep_map *lock, unsigned long ip),
> +	TPARGS(lock, ip),
> +	TPFMT("name: %s", lock->name)
> +	);
> +
> +TRACE_FORMAT(lock_acquired,
> +	TPPROTO(struct lockdep_map *lock, unsigned long ip),
> +	TPARGS(lock, ip),
> +	TPFMT("name: %s", lock->name)
> +	);
> +
> +#endif
> +#endif
> +
> +#undef TRACE_SYSTEM
> Index: linux-2.6/include/trace/trace_events.h
> ===================================================================
> --- linux-2.6.orig/include/trace/trace_events.h
> +++ linux-2.6/include/trace/trace_events.h
> @@ -2,3 +2,4 @@
>  
>  #include <trace/sched.h>
>  #include <trace/irq.h>
> +#include <trace/lockdep.h>
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -42,6 +42,7 @@
>  #include <linux/hash.h>
>  #include <linux/ftrace.h>
>  #include <linux/stringify.h>
> +#include <trace/lockdep.h>
>  
>  #include <asm/sections.h>
>  
> @@ -2912,6 +2913,8 @@ void lock_set_class(struct lockdep_map *
>  }
>  EXPORT_SYMBOL_GPL(lock_set_class);
>  
> +DEFINE_TRACE(lock_acquire);
> +
>  /*
>   * We are not always called with irqs disabled - do that here,
>   * and also avoid lockdep recursion:
> @@ -2922,6 +2925,8 @@ void lock_acquire(struct lockdep_map *lo
>  {
>  	unsigned long flags;
>  
> +	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
> +
>  	if (unlikely(current->lockdep_recursion))
>  		return;
>  
> @@ -2936,11 +2941,15 @@ void lock_acquire(struct lockdep_map *lo
>  }
>  EXPORT_SYMBOL_GPL(lock_acquire);
>  
> +DEFINE_TRACE(lock_release);
> +
>  void lock_release(struct lockdep_map *lock, int nested,
>  			  unsigned long ip)
>  {
>  	unsigned long flags;
>  
> +	trace_lock_release(lock, nested, ip);
> +
>  	if (unlikely(current->lockdep_recursion))
>  		return;
>  
> @@ -3089,10 +3098,14 @@ found_it:
>  	lock->ip = ip;
>  }
>  
> +DEFINE_TRACE(lock_contended);
> +
>  void lock_contended(struct lockdep_map *lock, unsigned long ip)
>  {
>  	unsigned long flags;
>  
> +	trace_lock_contended(lock, ip);
> +
>  	if (unlikely(!lock_stat))
>  		return;
>  
> @@ -3108,10 +3121,14 @@ void lock_contended(struct lockdep_map *
>  }
>  EXPORT_SYMBOL_GPL(lock_contended);
>  
> +DEFINE_TRACE(lock_acquired);
> +
>  void lock_acquired(struct lockdep_map *lock, unsigned long ip)
>  {
>  	unsigned long flags;
>  
> +	trace_lock_acquired(lock, ip);
> +
>  	if (unlikely(!lock_stat))
>  		return;
>  
> Index: linux-2.6/kernel/trace/trace.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace.c
> +++ linux-2.6/kernel/trace/trace.c
> @@ -624,7 +624,7 @@ static unsigned map_pid_to_cmdline[PID_M
>  static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
>  static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
>  static int cmdline_idx;
> -static DEFINE_SPINLOCK(trace_cmdline_lock);
> +static raw_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
>  
>  /* temporary disable recording */
>  static atomic_t trace_record_cmdline_disabled __read_mostly;
> @@ -736,7 +736,7 @@ static void trace_save_cmdline(struct ta
>  	 * nor do we want to disable interrupts,
>  	 * so if we miss here, then better luck next time.
>  	 */
> -	if (!spin_trylock(&trace_cmdline_lock))
> +	if (!__raw_spin_trylock(&trace_cmdline_lock))
>  		return;
>  
>  	idx = map_pid_to_cmdline[tsk->pid];
> @@ -754,7 +754,7 @@ static void trace_save_cmdline(struct ta
>  
>  	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
>  
> -	spin_unlock(&trace_cmdline_lock);
> +	__raw_spin_unlock(&trace_cmdline_lock);
>  }
>  
>  char *trace_find_cmdline(int pid)
> @@ -3491,7 +3491,7 @@ static __init int tracer_init_debugfs(vo
>  
>  int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>  {
> -	static DEFINE_SPINLOCK(trace_buf_lock);
> +	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
>  	static char trace_buf[TRACE_BUF_SIZE];
>  
>  	struct ring_buffer_event *event;
> @@ -3513,7 +3513,8 @@ int trace_vprintk(unsigned long ip, int 
>  		goto out;
>  
>  	pause_graph_tracing();
> -	spin_lock_irqsave(&trace_buf_lock, irq_flags);
> +	raw_local_irq_save(irq_flags);
> +	__raw_spin_lock(&trace_buf_lock);
>  	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
>  
>  	len = min(len, TRACE_BUF_SIZE-1);
> @@ -3532,7 +3533,8 @@ int trace_vprintk(unsigned long ip, int 
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  
>   out_unlock:
> -	spin_unlock_irqrestore(&trace_buf_lock, irq_flags);
> +	__raw_spin_unlock(&trace_buf_lock);
> +	raw_local_irq_restore(irq_flags);
>  	unpause_graph_tracing();
>   out:
>  	preempt_enable_notrace();
> Index: linux-2.6/kernel/trace/trace_events_stage_3.h
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_events_stage_3.h
> +++ linux-2.6/kernel/trace/trace_events_stage_3.h
> @@ -5,7 +5,7 @@
>   *
>   * static void ftrace_event_<call>(proto)
>   * {
> - * 	event_trace_printk(_RET_IP_, "(<call>) " <fmt>);
> + * 	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
>   * }
>   *
>   * static int ftrace_reg_event_<call>(void)
> @@ -112,7 +112,7 @@
>  #define _TRACE_FORMAT(call, proto, args, fmt)				\
>  static void ftrace_event_##call(proto)					\
>  {									\
> -	event_trace_printk(_RET_IP_, "(" #call ") " fmt);		\
> +	event_trace_printk(_RET_IP_, #call ": " fmt);			\
>  }									\
>  									\
>  static int ftrace_reg_event_##call(void)				\
> Index: linux-2.6/include/trace/trace_event_types.h
> ===================================================================
> --- linux-2.6.orig/include/trace/trace_event_types.h
> +++ linux-2.6/include/trace/trace_event_types.h
> @@ -2,3 +2,4 @@
>  
>  #include <trace/sched_event_types.h>
>  #include <trace/irq_event_types.h>
> +#include <trace/lockdep_event_types.h>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

