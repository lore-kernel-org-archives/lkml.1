Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYLDMq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYLDMq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYLDMqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:46:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48806 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbYLDMq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:46:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.175697908@goodmis.org>
Date: Thu, 04 Dec 2008 04:42:20 -0800
In-Reply-To: <20081204052735.175697908@goodmis.org> (Steven Rostedt's message
	of "Thu, 04 Dec 2008 00:26:40 -0500")
Message-ID: <m1d4g8un6b.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> From: Steven Rostedt <srostedt@redhat.com>
>
> Impact: clean up
>
> Eric Biederman suggested using the struct pid for filtering on
> pids in the kernel. This patch is based off of a demonstration
> of an implementation that Eric sent me in an email.

A little nit. I forgot to mention rcu_read_lock() is still needed in that
email.

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ftrace.c |   76 ++++++++++++++++++++++++++++--------------------
>  kernel/trace/trace.h  |    4 +-
>  2 files changed, 46 insertions(+), 34 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 57592a9..10b1d7c 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -48,7 +48,7 @@ int ftrace_enabled __read_mostly;
>  static int last_ftrace_enabled;
>  
>  /* set when tracing only a pid */
> -int ftrace_pid_trace = -1;
> +struct pid *ftrace_pid_trace;
>  
>  /* Quick disabling of function tracer. */
>  int function_trace_stop;
> @@ -153,7 +153,7 @@ static int __register_ftrace_function(struct ftrace_ops
> *ops)
>  		else
>  			func = ftrace_list_func;
>  
> -		if (ftrace_pid_trace >= 0) {
> +		if (ftrace_pid_trace) {
>  			set_ftrace_pid_function(func);
>  			func = ftrace_pid_func;
>  		}
> @@ -209,7 +209,7 @@ static int __unregister_ftrace_function(struct ftrace_ops
> *ops)
>  		if (ftrace_list->next == &ftrace_list_end) {
>  			ftrace_func_t func = ftrace_list->func;
>  
> -			if (ftrace_pid_trace >= 0) {
> +			if (ftrace_pid_trace) {
>  				set_ftrace_pid_function(func);
>  				func = ftrace_pid_func;
>  			}
> @@ -239,7 +239,7 @@ static void ftrace_update_pid_func(void)
>  
>  	func = ftrace_trace_function;
>  
> -	if (ftrace_pid_trace >= 0) {
> +	if (ftrace_pid_trace) {
>  		set_ftrace_pid_function(func);
>  		func = ftrace_pid_func;
>  	} else {
> @@ -1678,18 +1678,40 @@ ftrace_pid_read(struct file *file, char __user *ubuf,
>  	char buf[64];
>  	int r;
>  
> -	if (ftrace_pid_trace >= 0)
> -		r = sprintf(buf, "%u\n", ftrace_pid_trace);
> +	if (ftrace_pid_trace)
> +		r = sprintf(buf, "%u\n", pid_nr(ftrace_pid_trace));
>  	else
>  		r = sprintf(buf, "no pid\n");
>  
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
>  }
>  
> +static void clear_ftrace_pid_task(struct pid **pid)
> +{
> +	struct task_struct *p;
> +
	rcu_read_lock();

> +	do_each_pid_task(*pid, PIDTYPE_PID, p) {
> +		clear_tsk_trace_trace(p);
> +	} while_each_pid_task(*pid, PIDTYPE_PID, p);
	rcu_read_unlock()

> +	put_pid(*pid);
> +
> +	*pid = NULL;
> +}
> +
> +static void set_ftrace_pid_task(struct pid *pid)
> +{
> +	struct task_struct *p;
> +
	rcu_read_lock();
> +	do_each_pid_task(pid, PIDTYPE_PID, p) {
> +		set_tsk_trace_trace(p);
> +	} while_each_pid_task(pid, PIDTYPE_PID, p);
	rcu_read_unlock();
> +}
> +
>  static ssize_t
>  ftrace_pid_write(struct file *filp, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
> +	struct pid *pid;
>  	char buf[64];
>  	long val;
>  	int ret;
> @@ -1707,40 +1729,30 @@ ftrace_pid_write(struct file *filp, const char __user
> *ubuf,
>  		return ret;
>  
>  	mutex_lock(&ftrace_start_lock);
> -	if (ret < 0) {
> +	if (val < 0) {
>  		/* disable pid tracing */
> -		if (ftrace_pid_trace < 0)
> +		if (!ftrace_pid_trace)
>  			goto out;
> -		ftrace_pid_trace = -1;
> +
> +		clear_ftrace_pid_task(&ftrace_pid_trace);
>  
>  	} else {
> -		struct task_struct *p;
> -		int found = 0;
> +		pid = find_get_pid(val);
>  
> -		if (ftrace_pid_trace == val)
> +		if (pid == ftrace_pid_trace) {
> +			put_pid(pid);
>  			goto out;
> -
> -		/*
> -		 * Find the task that matches this pid.
> -		 * TODO: use pid namespaces instead.
> -		 */
> -		rcu_read_lock();
> -		for_each_process(p) {
> -			if (p->pid == val) {
> -				found = 1;
> -				set_tsk_trace_trace(p);
> -			} else if (test_tsk_trace_trace(p))
> -				clear_tsk_trace_trace(p);
>  		}
> -		rcu_read_unlock();
>  
> -		if (found)
> -			ftrace_pid_trace = val;
> -		else {
> -			if (ftrace_pid_trace < 0)
> -				goto out;
> -			ftrace_pid_trace = -1;
> -		}
> +		if (ftrace_pid_trace)
> +			clear_ftrace_pid_task(&ftrace_pid_trace);
> +
> +		if (!pid)
> +			goto out;
> +
> +		ftrace_pid_trace = pid;
> +
> +		set_ftrace_pid_task(ftrace_pid_trace);
>  	}
>  
>  	/* update the function call */
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 95fff37..8b81b4d 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -541,11 +541,11 @@ print_graph_function(struct trace_iterator *iter)
>  }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
> -extern int ftrace_pid_trace;
> +extern struct pid *ftrace_pid_trace;
>  
>  static inline int ftrace_trace_task(struct task_struct *task)
>  {
> -	if (ftrace_pid_trace < 0)
> +	if (ftrace_pid_trace)
>  		return 1;
>  
>  	return test_tsk_trace_trace(task);
> -- 
> 1.5.6.5
>
> -- 
