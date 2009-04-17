Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbZDQOJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbZDQOJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZDQOJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:09:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZDQOJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:09:00 -0400
Date: Fri, 17 Apr 2009 10:08:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
 prints
In-Reply-To: <20090416021928.467656424@goodmis.org>
Message-ID: <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ted, is this patch still needed?

I'm starting to have second thoughts on this patch because it may require 
adding: #include <linux/rcupdate.h> in include/trace/ftrace.h. Jeremy has 
been struggling with include hell with these files.

Hmm, maybe this is not an issue because we undef CREATE_TRACE_POINTS 
before calling this.

Jeremy,

Do you see a problem if we include linux/rcupdate.h in ftrace.h?
Remember, CREATE_TRACE_POINTS is undefined here.

Thanks,

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
