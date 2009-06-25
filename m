Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZFYChY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZFYChY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZFYChN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:37:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56057 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbZFYChM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:37:12 -0400
Message-ID: <4A42E310.3010400@cn.fujitsu.com>
Date: Thu, 25 Jun 2009 10:38:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 7/7] V2 add syscall tracepoints
References: <cover.1245770664.git.jbaron@redhat.com> <92f34bb50412cc43e04a484b48cb3452aabce775.1245770664.git.jbaron@redhat.com>
In-Reply-To: <92f34bb50412cc43e04a484b48cb3452aabce775.1245770664.git.jbaron@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #endif /* _TRACE_SYSCALL_H */
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 08aed43..cc283d6 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -1,15 +1,16 @@
>  #include <trace/syscall.h>
>  #include <linux/kernel.h>
> +#include <linux/ftrace.h>
>  #include <asm/syscall.h>
>  
>  #include "trace_output.h"
>  #include "trace.h"
>  
> -/* Keep a counter of the syscall tracing users */
> -static int refcount;
> -
> -/* Prevent from races on thread flags toggling */
>  static DEFINE_MUTEX(syscall_trace_lock);
> +static int sys_refcount_enter;
> +static int sys_refcount_exit;
> +static DECLARE_BITMAP(enabled_enter_syscalls, FTRACE_SYSCALL_MAX + 1);
> +static DECLARE_BITMAP(enabled_exit_syscalls, FTRACE_SYSCALL_MAX + 1);

Why "+ 1" ?

> -static int init_syscall_tracer(struct trace_array *tr)
> +int reg_event_syscall_enter(char *name)
>  {
> -	start_ftrace_syscalls();
> +	int ret = 0;
> +	int num;
>  
> -	return 0;
> +	num = syscall_name_to_nr(name);
> +	if (num < 0 || num > FTRACE_SYSCALL_MAX)
> +		return -ENOSYS;

syscall_name_to_nr() returns [0, FTRACE_SYSCALL_MAX) or -1,
so you don't need to check num > MAX, instead it should be
WAR_ON(num >= MAX).

> +	mutex_lock(&syscall_trace_lock);
> +	if (!sys_refcount_enter)
> +		ret = register_trace_syscall_enter(ftrace_syscall_enter);
> +	if (ret) {
> +		pr_info("event trace: Could not activate"
> +				"syscall entry trace point");

Should be:

+		pr_info("event trace: Could not activate "
+				"syscall entry trace point");

> +	} else {
> +		set_bit(num, enabled_enter_syscalls);
> +		sys_refcount_enter++;
> +	}
> +	mutex_unlock(&syscall_trace_lock);
> +	return ret;
>  }

> +int reg_event_syscall_exit(char *name)
>  {
> -	int ret;
> +	int ret = 0;
> +	int num;
>  
> -	ret = register_ftrace_event(&syscall_enter_event);
> -	if (!ret) {
> -		printk(KERN_WARNING "event %d failed to register\n",
> -		       syscall_enter_event.type);
> -		WARN_ON_ONCE(1);
> +	num = syscall_name_to_nr(name);
> +	if (num < 0 || num > FTRACE_SYSCALL_MAX)
> +		return -ENOSYS;

ditto

> +	mutex_lock(&syscall_trace_lock);
> +	if (!sys_refcount_exit)
> +		ret = register_trace_syscall_exit(ftrace_syscall_exit);
> +	if (ret) {
> +		pr_info("event trace: Could not activate"
> +				"syscall exit trace point");

ditto

> +	} else {
> +		set_bit(num, enabled_exit_syscalls);
> +		sys_refcount_exit++;
>  	}
> +	mutex_unlock(&syscall_trace_lock);
> +	return ret;
> +}
>  
> -	ret = register_ftrace_event(&syscall_exit_event);
> -	if (!ret) {
> -		printk(KERN_WARNING "event %d failed to register\n",
> -		       syscall_exit_event.type);
> -		WARN_ON_ONCE(1);
> -	}
> +void unreg_event_syscall_exit(char *name)
> +{
> +	int num;
>  
> -	return register_tracer(&syscall_tracer);
> +	num = syscall_name_to_nr(name);
> +	if (num < 0 || num > FTRACE_SYSCALL_MAX)
> +		return;

ditto

> +	mutex_lock(&syscall_trace_lock);
> +	sys_refcount_exit--;
> +	clear_bit(num, enabled_exit_syscalls);
> +	if (!sys_refcount_exit)
> +		unregister_trace_syscall_exit(ftrace_syscall_exit);
> +	mutex_unlock(&syscall_trace_lock);
>  }
