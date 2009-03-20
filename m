Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZCTIue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZCTIue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZCTIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:50:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:13582 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZCTIuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CV+jL/6fuJzJXStNUTR9/ESVp4Yi52DzDPSIPJ2aAjcBqCdjjaQIo1VZ+TeQpJLpfI
         IY3YbfhJ3CBZKHY4nqZWAaGxxwuMBNkp5wi3U0Dlyoy0NIdKsEyyFIhF+ZTailPDDyxn
         KCbGRHrR/xErTSCKW7E21s/oySyNW62EsTVl8=
Date: Fri, 20 Mar 2009 09:50:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] blktrace: remove blk_probe_mutex
Message-ID: <20090320085016.GB7820@nowhere>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F5EA.8060606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F5EA.8060606@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:48:26AM +0800, Li Zefan wrote:
> blk_register_tracepoints() always returns 0, so make it return void, thus
> we don't need to use blk_probe_mutex to protect blk_probes_ref.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |   27 +++++----------------------
>  1 files changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 73845b7..223b92e 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -47,10 +47,9 @@ static struct tracer_flags blk_tracer_flags = {
>  };
>  
>  /* Global reference count of probes */
> -static DEFINE_MUTEX(blk_probe_mutex);
>  static atomic_t blk_probes_ref = ATOMIC_INIT(0);
>  
> -static int blk_register_tracepoints(void);
> +static void blk_register_tracepoints(void);
>  static void blk_unregister_tracepoints(void);
>  
>  /*
> @@ -256,10 +255,8 @@ static void blk_trace_cleanup(struct blk_trace *bt)
>  	free_percpu(bt->sequence);
>  	free_percpu(bt->msg_data);
>  	kfree(bt);
> -	mutex_lock(&blk_probe_mutex);
>  	if (atomic_dec_and_test(&blk_probes_ref))
>  		blk_unregister_tracepoints();
> -	mutex_unlock(&blk_probe_mutex);
>  }
>  
>  int blk_trace_remove(struct request_queue *q)
> @@ -471,13 +468,8 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>  	bt->pid = buts->pid;
>  	bt->trace_state = Blktrace_setup;
>  
> -	mutex_lock(&blk_probe_mutex);
> -	if (atomic_add_return(1, &blk_probes_ref) == 1) {
> -		ret = blk_register_tracepoints();
> -		if (ret)
> -			goto probe_err;
> -	}
> -	mutex_unlock(&blk_probe_mutex);
> +	if (atomic_add_return(1, &blk_probes_ref) == 1)


atomic_inc_return() is a bit more simple.


> +		blk_register_tracepoints();
>  
>  	ret = -EBUSY;
>  	old_bt = xchg(&q->blk_trace, bt);
> @@ -487,9 +479,6 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>  	}
>  
>  	return 0;
> -probe_err:
> -	atomic_dec(&blk_probes_ref);
> -	mutex_unlock(&blk_probe_mutex);
>  err:
>  	if (bt) {
>  		if (bt->msg_file)
> @@ -863,7 +852,7 @@ void blk_add_driver_data(struct request_queue *q,
>  }
>  EXPORT_SYMBOL_GPL(blk_add_driver_data);
>  
> -static int blk_register_tracepoints(void)
> +static void blk_register_tracepoints(void)
>  {
>  	int ret;
>  
> @@ -901,7 +890,6 @@ static int blk_register_tracepoints(void)
>  	WARN_ON(ret);
>  	ret = register_trace_block_remap(blk_add_trace_remap);
>  	WARN_ON(ret);
> -	return 0;
>  }
>  
>  static void blk_unregister_tracepoints(void)
> @@ -1099,11 +1087,8 @@ static void blk_tracer_print_header(struct seq_file *m)
>  
>  static void blk_tracer_start(struct trace_array *tr)
>  {
> -	mutex_lock(&blk_probe_mutex);
>  	if (atomic_add_return(1, &blk_probes_ref) == 1)
> -		if (blk_register_tracepoints())
> -			atomic_dec(&blk_probes_ref);
> -	mutex_unlock(&blk_probe_mutex);
> +		blk_register_tracepoints();
>  	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
>  }
>  
> @@ -1118,10 +1103,8 @@ static int blk_tracer_init(struct trace_array *tr)
>  static void blk_tracer_stop(struct trace_array *tr)
>  {
>  	trace_flags |= TRACE_ITER_CONTEXT_INFO;
> -	mutex_lock(&blk_probe_mutex);
>  	if (atomic_dec_and_test(&blk_probes_ref))
>  		blk_unregister_tracepoints();
> -	mutex_unlock(&blk_probe_mutex);
>  }
>  
>  static void blk_tracer_reset(struct trace_array *tr)
> -- 
> 1.5.4.rc3
>

Looks good. 

