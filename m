Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633Ab0ARQWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0ARQWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547Ab0ARQWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:22:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab0ARQWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:22:33 -0500
Message-ID: <4B548A9A.1020806@redhat.com>
Date: Mon, 18 Jan 2010 11:21:46 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer operation
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com>
In-Reply-To: <4B5465D8.9070203@cn.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> Introduce ftrace_profile_buf_begin() and ftrace_profile_buf_end() to
> operate event profile buffer, clean up redundant code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
[...]

> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
> index 9e25573..f0fa16b 100644
> --- a/kernel/trace/trace_event_profile.c
> +++ b/kernel/trace/trace_event_profile.c
> @@ -9,11 +9,8 @@
>  #include "trace.h"
>  
>  
> -char *perf_trace_buf;
> -EXPORT_SYMBOL_GPL(perf_trace_buf);
> -
> -char *perf_trace_buf_nmi;
> -EXPORT_SYMBOL_GPL(perf_trace_buf_nmi);
> +static char *perf_trace_buf;
> +static char *perf_trace_buf_nmi;
>  
>  typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
>  
> @@ -120,3 +117,56 @@ void ftrace_profile_disable(int event_id)
>  	}
>  	mutex_unlock(&event_mutex);
>  }
> +
> +void *ftrace_profile_buf_begin(int size, unsigned short type, int *rctxp,
> +			       unsigned long *irq_flags)
> +{
> +	struct trace_entry *entry;
> +	char *trace_buf, *raw_data;
> +	int pc, cpu;
> +
> +	pc = preempt_count();
> +
> +	/* Protect the per cpu buffer, begin the rcu read side */
> +	local_irq_save(*irq_flags);
> +
> +	*rctxp = perf_swevent_get_recursion_context();
> +	if (*rctxp < 0)
> +		goto err_recursion;
> +
> +	cpu = smp_processor_id();
> +
> +	if (in_nmi())
> +		trace_buf = rcu_dereference(perf_trace_buf_nmi);
> +	else
> +		trace_buf = rcu_dereference(perf_trace_buf);
> +
> +	if (!trace_buf)
> +		goto err;
> +
> +	raw_data = per_cpu_ptr(trace_buf, cpu);
> +
> +	/* zero the dead bytes from align to not leak stack to user */
> +	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
> +
> +	entry = (struct trace_entry *)raw_data;
> +	tracing_generic_entry_update(entry, *irq_flags, pc);
> +	entry->type = type;
> +
> +	return raw_data;
> +err:
> +	perf_swevent_put_recursion_context(*rctxp);
> +err_recursion:
> +	local_irq_restore(*irq_flags);
> +	return NULL;
> +}
> +
> +void ftrace_profile_buf_end(void *raw_data, int size, int rctx, u64 addr,
> +			    u64 count, unsigned long irq_flags)
> +{
> +	struct trace_entry *entry = raw_data;
> +
> +	perf_tp_event(entry->type, addr, count, raw_data, size);
> +	perf_swevent_put_recursion_context(rctx);
> +	local_irq_restore(irq_flags);
> +}

Hmm, could you make it inline-functions or add __kprobes?
Because it is called from kprobes, we don't want to probe
the function which will be called from kprobes handlers itself.

(IMHO, from the viewpoint of performance, inline-function
 could be better.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

