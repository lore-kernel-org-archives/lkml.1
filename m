Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZBCDvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZBCDvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZBCDvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:51:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbZBCDvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:51:03 -0500
Date: Mon, 2 Feb 2009 19:50:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] trace: fix default boot up tracer
Message-Id: <20090202195021.83bd0b80.akpm@linux-foundation.org>
In-Reply-To: <20090203024358.332574797@goodmis.org>
References: <20090203023830.440860800@goodmis.org>
	<20090203024358.332574797@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009 21:38:32 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> @@ -510,8 +520,25 @@ int register_tracer(struct tracer *type)
>   out:
>  	tracing_selftest_running = false;
>  	mutex_unlock(&trace_types_lock);
> -	lock_kernel();
>  
> +	if (!ret && default_bootup_tracer) {
> +		if (!strncmp(default_bootup_tracer, type->name,
> +			     BOOTUP_TRACER_SIZE)) {
> +			printk(KERN_INFO "Starting tracer '%s'\n",
> +			       type->name);
> +			/* Do we want this tracer to start on bootup? */
> +			tracing_set_tracer(type->name);
> +			default_bootup_tracer = NULL;
> +			/* disable other selftests, since this will break it. */
> +			tracing_selftest_disabled = 1;
> +#ifdef CONFIG_FTRACE_STARTUP_TEST
> +			printk(KERN_INFO "Disabling FTRACE selftests due"
> +			       " to running tracer '%s'\n", type->name);
> +#endif
> +		}
> +	}
> +
> +	lock_kernel();
>  	return ret;
>  }

The fun and games which register_tracer() plays with lock_kernel() tell
us that this function is only called at bootup time and hence could be
__init.  A quick whizz through callers confirms that.

And if register_tracer() is also only callable at bootup, one suspects
that unregister_tracer() isn't useful.  And lo, it has no callers.

This leads one to further surmise that trace_types_lock a) could be
__initdata and b) could be removed (the list is only altered when we're
running single-threaded).  This appears to be the case.

