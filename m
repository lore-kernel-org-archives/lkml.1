Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYKRNt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYKRNt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYKRNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:49:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYKRNto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:49:44 -0500
Date: Tue, 18 Nov 2008 08:49:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
In-Reply-To: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Heiko Carstens wrote:

> Hi Steven,
> 
> I was wondering why the preemptoff and preemptirqsoff tracer selftests
> don't work on s390. After all its just that they get called from
> non-preemptible context:
> 
> kernel_init() will execute all initcalls, however the first line in
> kernel_init() is lock_kernel(), which causes the preempt_count to be
> increased. Any later calls to add_preempt_count() (especially those
> from the selftests) will therefore not result in a call to
> trace_preempt_off() since the check below in add_preempt_count()
> will be false:
> 
> 	if (preempt_count() == val)
> 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
> 
> Hence the trace buffer will be empty.
> The patch below makes the selftests working for me, since then they run
> in preemptible context. But it is ugly and I'm not proposing it for
> upstream ;)
> 
> Just wanted to make you aware that there is a bug.

Yep, this might be a better answer than what I put into linux-tip (and my 
git repo).

See:

  ftrace: force pass of preemptoff selftest

The cause of the bug was the conversion of the BKL back to a spinlock, and 
making it non preempt.  The initcall code is called with the BKL applied 
which now means it can not preempt. This breaks the preempt tracer 
selftest.

My solution was to just force a pass if this is detected. Perhaps moving 
the test might be better.

-- Steve

> 
> ---
>  init/main.c                  |    4 ++++
>  kernel/trace/trace_irqsoff.c |    3 +--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/trace/trace_irqsoff.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_irqsoff.c
> +++ linux-2.6/kernel/trace/trace_irqsoff.c
> @@ -482,7 +482,7 @@ static struct tracer preemptirqsoff_trac
>  # define register_preemptirqsoff(trace) do { } while (0)
>  #endif
>  
> -__init static int init_irqsoff_tracer(void)
> +int init_irqsoff_tracer(void)
>  {
>  	register_irqsoff(irqsoff_tracer);
>  	register_preemptoff(preemptoff_tracer);
> @@ -490,4 +490,3 @@ __init static int init_irqsoff_tracer(vo
>  
>  	return 0;
>  }
> -device_initcall(init_irqsoff_tracer);
> Index: linux-2.6/init/main.c
> ===================================================================
> --- linux-2.6.orig/init/main.c
> +++ linux-2.6/init/main.c
> @@ -789,6 +789,8 @@ static void run_init_process(char *init_
>  	kernel_execve(init_filename, argv_init, envp_init);
>  }
>  
> +extern int init_irqsoff_tracer(void);
> +
>  /* This is a non __init function. Force it to be noinline otherwise gcc
>   * makes it inline to init() and it becomes part of init.text section
>   */
> @@ -800,6 +802,8 @@ static int noinline init_post(void)
>  	system_state = SYSTEM_RUNNING;
>  	numa_default_policy();
>  
> +	init_irqsoff_tracer();
> +
>  	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
>  		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
>  
> 
> 
