Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbZBLTiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbZBLTiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZBLTh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:37:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:5132 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZBLTh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sN8iqPHCUy8sD+/Jp50FdrWbcxbx/ue1P+KjosqduA1IF/obFWIgPKkuCByUu7GpSy
         QC6M3l4x1U7oc7r/wjyZ5lAp1X9dmfeFVGmpnMFB7Rx1zoMN91dWKP6yzM9ReSC8tI3r
         2fLHaD404o/P+ZEHbdx4Kre/wodBWusJJWoew=
Date: Thu, 12 Feb 2009 20:37:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] tracing: Only drop the BKL in register_tracer
	if there is a selftest
Message-ID: <20090212193751.GA5003@nowhere>
References: <20090212192354.GA5348@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090212192354.GA5348@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 05:23:54PM -0200, Arnaldo Carvalho de Melo wrote:
> Impact: cleanup
> 
> We only need to drop the BKL for some tracers, and then only if the
> tracer being registered has a selftest method. So clean up moving the
> selftest bits to a different function.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  kernel/trace/trace.c |  138 ++++++++++++++++++++++++++++----------------------
>  1 files changed, 77 insertions(+), 61 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 95f99a7..fc01e0c 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -452,6 +452,76 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  	__raw_spin_unlock(&ftrace_max_lock);
>  }
>  
> +static int trace_selftest(struct tracer *trace)
> +{
> +	int ret = 0;
> +#ifdef CONFIG_FTRACE_STARTUP_TEST
> +	struct tracer *saved_tracer;
> +	struct trace_array *tr;
> +	int i;
> +
> +	if (trace->selftest == NULL || tracing_selftest_disabled)
> +		return 0;
> +	/*
> +	 * When this gets called we hold the BKL which means that
> +	 * preemption is disabled. Various trace selftests however
> +	 * need to disable and enable preemption for successful tests.
> +	 * So we drop the BKL here and grab it after the tests again.
> +	 */
> +	unlock_kernel();
> +
> +	saved_tracer = current_trace;
> +	tr = &global_trace;
> +
> +	/*
> +	 * Run a selftest on this tracer.
> +	 * Here we reset the trace buffer, and set the current
> +	 * tracer to be this tracer. The tracer can then run some
> +	 * internal tracing to verify that everything is in order.
> +	 * If we fail, we do not register this tracer.
> +	 */
> +	for_each_tracing_cpu(i)
> +		tracing_reset(tr, i);
> +
> +	current_trace = trace;
> +	/* the test is responsible for initializing and enabling */
> +	pr_info("Testing tracer %s: ", trace->name);
> +	ret = trace->selftest(trace, tr);
> +	/* the test is responsible for resetting too */
> +	current_trace = saved_tracer;
> +	if (ret)
> +		printk(KERN_CONT "FAILED!\n");
> +	else {
> +		/* Only reset on passing, to avoid touching corrupted buffers */
> +		for_each_tracing_cpu(i)
> +			tracing_reset(tr, i);
> +
> +		printk(KERN_CONT "PASSED\n");
> +	}
> +
> +	tracing_selftest_running = false;
> +	lock_kernel();
> +#endif
> +	return ret;
> +}
> +
> +static void trace_boot(struct tracer *trace)
> +{
> +	if (strncmp(default_bootup_tracer, trace->name, BOOTUP_TRACER_SIZE))
> +		return;
> +
> +	pr_info("Starting tracer '%s'\n", trace->name);
> +	/* Do we want this tracer to start on bootup? */
> +	tracing_set_tracer(trace->name);
> +	default_bootup_tracer = NULL;
> +	/* disable other selftests, since this will break it. */
> +	tracing_selftest_disabled = 1;
> +#ifdef CONFIG_FTRACE_STARTUP_TEST
> +	pr_info("Disabling FTRACE selftests due to running tracer '%s'\n",
> +		trace->name);
> +#endif
> +}
> +
>  /**
>   * register_tracer - register a tracer with the ftrace system.
>   * @type - the plugin for the tracer
> @@ -471,13 +541,6 @@ __acquires(kernel_lock)
>  		return -1;
>  	}
>  
> -	/*
> -	 * When this gets called we hold the BKL which means that
> -	 * preemption is disabled. Various trace selftests however
> -	 * need to disable and enable preemption for successful tests.
> -	 * So we drop the BKL here and grab it after the tests again.
> -	 */
> -	unlock_kernel();
>  	mutex_lock(&trace_types_lock);
>  
>  	tracing_selftest_running = true;
> @@ -488,7 +551,7 @@ __acquires(kernel_lock)
>  			pr_info("Trace %s already registered\n",
>  				type->name);
>  			ret = -1;
> -			goto out;
> +			goto out_mutex_unlock;
>  		}
>  	}
>  
> @@ -500,39 +563,9 @@ __acquires(kernel_lock)
>  		if (!type->flags->opts)
>  			type->flags->opts = dummy_tracer_opt;
>  
> -#ifdef CONFIG_FTRACE_STARTUP_TEST
> -	if (type->selftest && !tracing_selftest_disabled) {
> -		struct tracer *saved_tracer = current_trace;
> -		struct trace_array *tr = &global_trace;
> -		int i;
> -
> -		/*
> -		 * Run a selftest on this tracer.
> -		 * Here we reset the trace buffer, and set the current
> -		 * tracer to be this tracer. The tracer can then run some
> -		 * internal tracing to verify that everything is in order.
> -		 * If we fail, we do not register this tracer.
> -		 */
> -		for_each_tracing_cpu(i)
> -			tracing_reset(tr, i);
> -
> -		current_trace = type;
> -		/* the test is responsible for initializing and enabling */
> -		pr_info("Testing tracer %s: ", type->name);
> -		ret = type->selftest(type, tr);
> -		/* the test is responsible for resetting too */
> -		current_trace = saved_tracer;
> -		if (ret) {
> -			printk(KERN_CONT "FAILED!\n");
> -			goto out;
> -		}
> -		/* Only reset on passing, to avoid touching corrupted buffers */
> -		for_each_tracing_cpu(i)
> -			tracing_reset(tr, i);
> -
> -		printk(KERN_CONT "PASSED\n");
> -	}
> -#endif
> +	ret = trace_selftest(type);
> +	if (ret != 0)
> +		goto out_mutex_unlock;
>  
>  	type->next = trace_types;
>  	trace_types = type;
> @@ -540,29 +573,12 @@ __acquires(kernel_lock)
>  	if (len > max_tracer_type_len)
>  		max_tracer_type_len = len;
>  
> - out:
> -	tracing_selftest_running = false;
> +out_mutex_unlock:
>  	mutex_unlock(&trace_types_lock);
>  
> -	if (ret || !default_bootup_tracer)
> -		goto out_unlock;
> -
> -	if (strncmp(default_bootup_tracer, type->name, BOOTUP_TRACER_SIZE))
> -		goto out_unlock;
> -
> -	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
> -	/* Do we want this tracer to start on bootup? */
> -	tracing_set_tracer(type->name);
> -	default_bootup_tracer = NULL;
> -	/* disable other selftests, since this will break it. */
> -	tracing_selftest_disabled = 1;
> -#ifdef CONFIG_FTRACE_STARTUP_TEST
> -	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
> -	       type->name);
> -#endif
> +	if (ret == 0 && default_bootup_tracer)
> +		trace_boot(type);
>  
> - out_unlock:
> -	lock_kernel();
>  	return ret;
>  }
>  
> -- 
> 1.6.0.6
> 

Yes, this is better like that.
Thanks.

