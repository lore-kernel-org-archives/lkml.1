Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYKPWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYKPWk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYKPWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:40:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:5139 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYKPWkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=hNjxogArfP15dPawBalnedLt7Vk9Nl1M2ZA2obzYGwjC4Y6xtr3DUes5jvpKU3CQjm
         WK1g2EGdH4TRp9PUqu+U7orlHo5NOH5Gm8gexz8/EnbWuEcsShZMnJDH9UaRU5XepTKc
         wAIJZ6oclKt1zPQq4DlK9IUs1aIuO2DIqtaPM=
Date: Mon, 17 Nov 2008 00:40:41 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Noonan <steven@uplinklabs.net>
Subject: Re: [PATCH 2/4] tracing/ftrace: Change the type of the init()
 callback
Message-ID: <20081117004041.0ac7a5e9@daedalus.pq.iki.fi>
In-Reply-To: <491FA836.4020101@gmail.com>
References: <491FA836.4020101@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 05:57:26 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: Handle errors during initialization of a tracer
> 
> This bring a way to know if the initialization of a tracer successed.
> A tracer must return 0 on success and a traditional error (ie: -ENOMEM)
> if it fails.
> If a tracer fails to init, it is free to print a detailed warn. The tracing
> api will not and switch to a new tracer will just return the error from the init
> callback.
> 
> Note: this will be used for the return tracer.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Pekka Paalanen <pq@iki.fi>
> Cc: Steven Noonan <steven@uplinklabs.net>
> ---
>  kernel/trace/trace.c                  |    7 ++-
>  kernel/trace/trace.h                  |    3 +-
>  kernel/trace/trace_boot.c             |    3 +-
>  kernel/trace/trace_branch.c           |    3 +-
>  kernel/trace/trace_functions.c        |    3 +-
>  kernel/trace/trace_functions_return.c |    3 +-
>  kernel/trace/trace_irqsoff.c          |    9 +++-
>  kernel/trace/trace_mmiotrace.c        |    3 +-
>  kernel/trace/trace_nop.c              |    3 +-
>  kernel/trace/trace_sched_switch.c     |    3 +-
>  kernel/trace/trace_sched_wakeup.c     |    3 +-
>  kernel/trace/trace_selftest.c         |   66 ++++++++++++++++++++++++++++----
>  kernel/trace/trace_sysprof.c          |    3 +-
>  13 files changed, 88 insertions(+), 24 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 2d5672d..938ee31 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2638,8 +2638,11 @@ static int tracing_set_tracer(char *buf)
>  		current_trace->reset(tr);
>  
>  	current_trace = t;
> -	if (t->init)
> -		t->init(tr);
> +	if (t->init) {
> +		ret = t->init(tr);
> +		if (ret)
> +			goto out;
> +	}
>  
>  	trace_branch_enable(tr);
>   out:
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 790ea8c..cdbd5cc 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -264,7 +264,8 @@ enum print_line_t {
>   */
>  struct tracer {
>  	const char		*name;
> -	void			(*init)(struct trace_array *tr);
> +	/* Your tracer should raise a warning if init fails */
> +	int			(*init)(struct trace_array *tr);
>  	void			(*reset)(struct trace_array *tr);
>  	void			(*start)(struct trace_array *tr);
>  	void			(*stop)(struct trace_array *tr);

...

> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index 51bcf37..433d650 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -30,13 +30,14 @@ static void mmio_reset_data(struct trace_array *tr)
>  		tracing_reset(tr, cpu);
>  }
>  
> -static void mmio_trace_init(struct trace_array *tr)
> +static int mmio_trace_init(struct trace_array *tr)
>  {
>  	pr_debug("in %s\n", __func__);
>  	mmio_trace_array = tr;
>  
>  	mmio_reset_data(tr);
>  	enable_mmiotrace();
> +	return 0;
>  }
>  
>  static void mmio_trace_reset(struct trace_array *tr)

On a quick glance, I didn't see anything wrong in these parts.
I leave it for later to check if enable_mmiotrace() could fail
and if it should be propagated.

Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
