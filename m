Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYJFQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYJFQw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYJFQwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:52:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:33545 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYJFQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:52:48 -0400
Subject: Re: [PATCH v2] ftrace: Add a C-state tracer to help power
	optimization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081004112915.7c2b45ea@infradead.org>
References: <20081004105447.0e48d6d4@infradead.org>
	 <alpine.DEB.1.10.0810041410390.6571@gandalf.stny.rr.com>
	 <20081004112915.7c2b45ea@infradead.org>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 18:52:39 +0200
Message-Id: <1223311960.12409.28.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-04 at 11:29 -0700, Arjan van de Ven wrote:

> @@ -100,6 +101,9 @@ static inline int hlt_use_halt(void)
>  void default_idle(void)
>  {
>  	if (hlt_use_halt()) {
> +		struct cstate_trace it;
> +
> +		trace_cstate_start(&it, 1);
>  		current_thread_info()->status &= ~TS_POLLING;
>  		/*
>  		 * TS_POLLING-cleared state must be visible before we
> @@ -112,6 +116,7 @@ void default_idle(void)
>  		else
>  			local_irq_enable();
>  		current_thread_info()->status |= TS_POLLING;
> +		trace_cstate_end(&it);
>  	} else {
>  		local_irq_enable();
>  		/* loop is done by the caller */

> @@ -232,6 +232,20 @@ static inline void start_boot_trace(void) { }
>  static inline void stop_boot_trace(void) { }
>  #endif
>  
> +struct cstate_trace {
> +	ktime_t			stamp;
> +	ktime_t			end;
> +	int			state;
> +};
> +
> +#ifdef CONFIG_CSTATE_TRACER
> +extern void trace_cstate_start(struct cstate_trace *it, unsigned int state);
> +extern void trace_cstate_end(struct cstate_trace *it);
> +#else
> +static inline void trace_cstate_start(struct cstate_trace *it, int state) { }
> +static inline void trace_cstate_end(struct cstate_trace *it) { }
> +#endif
> +
>  
> 
>  #endif /* _LINUX_FTRACE_H */

Why have the cstate_trace structure? If you just log start, stop you
could compute the time delta from the trace time stamps, no?

If you decide to keep the structure, perhaps declare it empty for !
CONFIG_CSTATE_TRACER so as to not bloat stack usage when its not
configured.

