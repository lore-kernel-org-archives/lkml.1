Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYLDM4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYLDM4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYLDM4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:56:25 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41508 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYLDM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:56:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.362609481@goodmis.org>
Date: Thu, 04 Dec 2008 04:54:10 -0800
In-Reply-To: <20081204052735.362609481@goodmis.org> (Steven Rostedt's message
	of "Thu, 04 Dec 2008 00:26:41 -0500")
Message-ID: <m163m0umml.fsf@frodo.ebiederm.org>
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
> Impact: New feature
>
> This patch lets the swapper tasks of all CPUS be filtered by the
> set_ftrace_pid file.
>
> If '0' is echoed into this file, then all the idle tasks (aka swapper)
> is flagged to be traced.  This affects all CPU idle tasks.

Ok.  Nits below.

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ftrace.c |   74 +++++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 63 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 10b1d7c..eb57dc1 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -49,6 +49,7 @@ static int last_ftrace_enabled;
>  
>  /* set when tracing only a pid */
>  struct pid *ftrace_pid_trace;
> +static struct pid * const ftrace_swapper_pid = (struct pid *)1;

The initializer should be spelled &init_struct_pid instead of (struct pid *)1;

Except for the special case of finding this unhashed pid, by making the
attach_pid(p, PIDTYPE_PID, pid) unconditional in copy_process, you can
make the rest of the special cases go away.

Eric

>  
>  /* Quick disabling of function tracer. */
>  int function_trace_stop;
> @@ -1678,7 +1679,9 @@ ftrace_pid_read(struct file *file, char __user *ubuf,
>  	char buf[64];
>  	int r;
>  
> -	if (ftrace_pid_trace)
> +	if (ftrace_pid_trace == ftrace_swapper_pid)
> +		r = sprintf(buf, "swapper tasks\n");
> +	else if (ftrace_pid_trace)
>  		r = sprintf(buf, "%u\n", pid_nr(ftrace_pid_trace));
>  	else
>  		r = sprintf(buf, "no pid\n");
> @@ -1686,19 +1689,43 @@ ftrace_pid_read(struct file *file, char __user *ubuf,
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
>  }
>  
> -static void clear_ftrace_pid_task(struct pid **pid)
> +static void clear_ftrace_swapper(void)
>  {
>  	struct task_struct *p;
> +	int cpu;
>  
> -	do_each_pid_task(*pid, PIDTYPE_PID, p) {
> +	get_online_cpus();
> +	for_each_online_cpu(cpu) {
> +		p = idle_task(cpu);
>  		clear_tsk_trace_trace(p);
> -	} while_each_pid_task(*pid, PIDTYPE_PID, p);
> -	put_pid(*pid);
> +	}
> +	put_online_cpus();
> +}
>  
> -	*pid = NULL;
> +static void set_ftrace_swapper(void)
> +{
> +	struct task_struct *p;
> +	int cpu;
> +
> +	get_online_cpus();
> +	for_each_online_cpu(cpu) {
> +		p = idle_task(cpu);
> +		set_tsk_trace_trace(p);
> +	}
> +	put_online_cpus();
>  }
>  
> -static void set_ftrace_pid_task(struct pid *pid)
> +static void clear_ftrace_pid(struct pid *pid)
> +{
> +	struct task_struct *p;
> +
> +	do_each_pid_task(pid, PIDTYPE_PID, p) {
> +		clear_tsk_trace_trace(p);
> +	} while_each_pid_task(pid, PIDTYPE_PID, p);
> +	put_pid(pid);
> +}
> +
> +static void set_ftrace_pid(struct pid *pid)
>  {
>  	struct task_struct *p;
>  
> @@ -1707,6 +1734,24 @@ static void set_ftrace_pid_task(struct pid *pid)
>  	} while_each_pid_task(pid, PIDTYPE_PID, p);
>  }
>  
> +static void clear_ftrace_pid_task(struct pid **pid)
> +{
> +	if (*pid == ftrace_swapper_pid)
> +		clear_ftrace_swapper();
> +	else
> +		clear_ftrace_pid(*pid);
> +
> +	*pid = NULL;
> +}
> +
> +static void set_ftrace_pid_task(struct pid *pid)
> +{
> +	if (pid == ftrace_swapper_pid)
> +		set_ftrace_swapper();
> +	else
> +		set_ftrace_pid(pid);
> +}
> +
>  static ssize_t
>  ftrace_pid_write(struct file *filp, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
> @@ -1737,11 +1782,18 @@ ftrace_pid_write(struct file *filp, const char __user
> *ubuf,
>  		clear_ftrace_pid_task(&ftrace_pid_trace);
>  
>  	} else {
> -		pid = find_get_pid(val);
> +		/* swapper task is special */
> +		if (!val) {
> +			pid = ftrace_swapper_pid;
> +			if (pid == ftrace_pid_trace)
> +				goto out;
> +		} else {
> +			pid = find_get_pid(val);
>  
> -		if (pid == ftrace_pid_trace) {
> -			put_pid(pid);
> -			goto out;
> +			if (pid == ftrace_pid_trace) {
> +				put_pid(pid);
> +				goto out;
> +			}
>  		}
>  
>  		if (ftrace_pid_trace)
> -- 
> 1.5.6.5
>
> -- 
