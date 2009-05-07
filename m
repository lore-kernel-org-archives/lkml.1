Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbZEGCKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbZEGCKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761933AbZEGCKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:10:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762108AbZEGCKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:10:21 -0400
Date: Wed, 6 May 2009 22:10:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
 prints
In-Reply-To: <20090416021928.467656424@goodmis.org>
Message-ID: <alpine.DEB.2.00.0905062207370.24643@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Somehow this patch got dropped. I believe Ted's work requires it.

I'm not sure if we need to include rcupdate.h or not to use 
rcu_read_lock. I think it may be fine to include it in ftrace.h. 

Jeremy, does this patch effect anything that you are doing?

-- Steve

On Wed, 15 Apr 2009, Steven Rostedt wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Some trace events need to have a way to print out data that his
> allocated, but will be freed later. Using a function that can allocate
> memory, and free it with call_rcu, can be useful.
> 
> This patch adds rcu locking around the print part of the TRACE_EVENT
> macro to facilitate this.
> 
> Reported-by: Theodore Tso <tytso@mit.edu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/ftrace.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 60c5323..6fb06bd 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -62,7 +62,9 @@
>   *
>   *	field = (typeof(field))entry;
>   *
> + *	rcu_read_lock();
>   *	ret = trace_seq_printf(s, <TP_printk> "\n");
> + *	rcu_read_unlock();
>   *	if (!ret)
>   *		return TRACE_TYPE_PARTIAL_LINE;
>   *
> @@ -99,7 +101,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  									\
>  	field = (typeof(field))entry;					\
>  									\
> +	rcu_read_lock();						\
>  	ret = trace_seq_printf(s, #call ": " print);			\
> +	rcu_read_unlock();						\
>  	if (!ret)							\
>  		return TRACE_TYPE_PARTIAL_LINE;				\
>  									\
> -- 
> 1.6.2.1
> 
> -- 
> 
