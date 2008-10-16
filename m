Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYJPWLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYJPWLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbYJPWKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:10:49 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:41674 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbYJPWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:10:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAKBU90hMQWq+/2dsb2JhbACBcsIug2w
Date: Thu, 16 Oct 2008 18:10:46 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fche@redhat.com, fweisbec@gmail.com,
       edwintorok@gmail.com, mingo@elte.hu, peterz@infradead.org
Subject: Re: tracepoints for kernel/mutex.c
Message-ID: <20081016221046.GD21877@Krystal>
References: <20081016210430.GC25738@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081016210430.GC25738@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:03:43 up 134 days,  2:44,  6 users,  load average: 0.19, 0.58,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> hi,
> 
> Below are 3 tracepoints I've been playing with in kernel/mutex.c using
> a SystemTap script. The idea is to detect and determine the cause of
> lock contention. Currently I get the following output:
> 
> <contended mutex nam> <process name and pid of the contention> <time of
> contention> <pid that woke me up(caused the contention?)>
> 
> for example:
> 
> name: &inode->i_mutex, pid name: udevd, pid: 26567, jiffies: 1 cause:
> 26566
>  
> 
> Using SystemTap I can now modify my script to figure out the inode number, the 
> file and pathname, or the backtrace and get to the bottom of the
> contention.
> 
> I think this approach has a number of advantages. It has low
> overhead in the off case, since its based on tracepoints. It is
> minimally invasive in the code path (3 tracepoints). It also allows me
> to explore data structures and parts of the kernel by simply modifying
> the SystemTap script. I do not need to re-compile the kernel and reboot.
> 
> You can run the script via: $stap mutex.stp
> 
> thanks,
> 
> -Jason
> 
> 
> diff --git a/include/trace/mutex.h b/include/trace/mutex.h
> new file mode 100644
> index 0000000..8d365d6
> --- /dev/null
> +++ b/include/trace/mutex.h
> @@ -0,0 +1,10 @@
> +#ifndef _TRACE_MUTEX_H
> +#define _TRACE_MUTEX_H
> +
> +#include <linux/tracepoint.h>
> +
> +DEFINE_TRACE(mutex_lock_contention, TPPROTO(int pid, unsigned long time), TPARGS(pid, time));
> +DEFINE_TRACE(mutex_lock_contention_length, TPPROTO(char *name, int pid, unsigned long time), TPARGS(name, pid, time));
> +DEFINE_TRACE(mutex_wakeup, TPPROTO(int target_pid, int sender_pid), TPARGS(target_pid, sender_pid));
> +
> +#endif
> diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
> index 1d94160..847a9fb 100644
> --- a/kernel/mutex-debug.c
> +++ b/kernel/mutex-debug.c
> @@ -97,6 +97,7 @@ void debug_mutex_init(struct mutex *lock, const char *name,
>  #endif
>  	lock->owner = NULL;
>  	lock->magic = lock;
> +	lock->name = name;
>  }
>  
>  /***
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 12c779d..62c2aab 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -18,6 +18,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/interrupt.h>
>  #include <linux/debug_locks.h>
> +#include <trace/mutex.h>
>  
>  /*
>   * In the DEBUG case we are using the "NULL fastpath" for mutexes,
> @@ -147,6 +148,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		goto done;
>  
>  	lock_contended(&lock->dep_map, ip);
> +	trace_mutex_lock_contention((int)task->pid, jiffies);
>  
>  	for (;;) {
>  		/*
> @@ -182,7 +184,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		schedule();
>  		spin_lock_mutex(&lock->wait_lock, flags);
>  	}
> -
> +	trace_mutex_lock_contention_length(lock->name, (int)task->pid, jiffies);
>  done:
>  	lock_acquired(&lock->dep_map);
>  	/* got the lock - rejoice! */
> @@ -256,7 +258,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
>  					   struct mutex_waiter, list);
>  
>  		debug_mutex_wake_waiter(lock, waiter);
> -
> +		trace_mutex_wakeup(waiter->task->pid, current->pid);
>  		wake_up_process(waiter->task);
>  	}
>  
> diff --git a/ltt/probes/Makefile b/ltt/probes/Makefile
> index 2ee8a46..0c54d01 100644
> --- a/ltt/probes/Makefile
> +++ b/ltt/probes/Makefile
> @@ -10,7 +10,8 @@ CFLAGS_REMOVE_rcu-trace.o = -pg
>  endif
>  
>  obj-$(CONFIG_LTT_TRACEPROBES)	+= kernel-trace.o mm-trace.o fs-trace.o \
> -				ipc-trace.o lockdep-trace.o rcu-trace.o
> +				ipc-trace.o lockdep-trace.o rcu-trace.o \
> +				mutex-trace.o
>  
>  ifeq ($(CONFIG_NET),y)
>  ifdef CONFIG_FTRACE
> diff --git a/ltt/probes/mutex-trace.c b/ltt/probes/mutex-trace.c
> new file mode 100644
> index 0000000..3b1ebeb
> --- /dev/null
> +++ b/ltt/probes/mutex-trace.c
> @@ -0,0 +1,43 @@
> +/*
> + * ltt/probes/fs-trace.c
> + *

Perhaps you meant mutex-trace.c ? :)

> + * Mutex tracepoint probes.
> + */
> +
> +#include <linux/module.h>
> +#include <trace/mutex.h>
> +
> +static unsigned long mutex_times[PID_MAX_DEFAULT+1];
> +static int mutex_wakeup[PID_MAX_DEFAULT+1];
> +

What happens if PID_MAX_LIMIT > PID_MAX_DEFAULT ?

What happens when a process ID gets reused (exit/fork reusing a PID) ?

Could you add this information to the task_structs or does it really
have to be separate ?

Mathieu

> +void probe_mutex_lock_contention(int pid, unsigned long time)
> +{
> +	mutex_times[pid] = (unsigned long)time;	
> +
> +	trace_mark_tp(mutex_lock_contention, mutex_lock_contention,
> +		probe_mutex_lock_contention, "pid %d time %lu", pid, time);
> +}
> +
> +void probe_mutex_lock_contention_length(char *name, int pid, unsigned long time)
> +{
> +	unsigned long delay = time - mutex_times[pid];
> +	int reason = mutex_wakeup[pid];
> +
> +	/* FIXME: why is name sometimes null? */
> +	if (!name)
> +		return;
> +
> +	trace_mark_tp(mutex_lock_contention_length, mutex_lock_contention_length,
> +		probe_mutex_lock_contention_length, 
> +		"name %s pid %d delay %lu cause %d", 
> +		name, pid, delay, reason);
> +}
> +
> +void probe_mutex_wakeup(int target_pid, int sender_pid)
> +{
> +	mutex_wakeup[target_pid] = sender_pid;
> +
> +	trace_mark_tp(mutex_wakeup, mutex_wakeup,
> +		probe_mutex_wakeup, "pid %d pid %d", target_pid, sender_pid);
> +}
> +
> 
> 
> # mutex.stp
> 
> probe kernel.mark("mutex_lock_contention") 
> { 
> }
> 
> probe kernel.mark("mutex_wakeup") 
> { 
> }
> 
> probe kernel.mark("mutex_lock_contention_length") 
> { 
> 	name = $arg1
> 	pid = $arg2
> 	delay = $arg3
> 	cause = $arg4
> 
> 	printf("name: %s, pid name: %s, pid: %d, jiffies: %d cause: %d\n", 
> 		name, execname(), pid, delay, cause);
> }
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
