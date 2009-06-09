Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZFIWWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZFIWWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZFIWWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:22:22 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:60688 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZFIWWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bUxOuLz+v5LgNcEfTYO3nqXn2kE/DjVc+7X9JzagUdD2Kq4KlbOp05ftOIlzafh+Rp
         bnlhIgiFEMvL6H3lzWVsEDv7nIrxRK7SNttS5sZjum/7QKy4WHgdvj4kQAi21j1zdiD7
         uYs1E3hRBV4rPYph14XWegZK8nJMTwzKnw2BQ=
Date: Wed, 10 Jun 2009 00:22:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/8] tracing/events: modify irq print to new format
Message-ID: <20090609222217.GE6057@nowhere>
References: <20090609215211.307980196@goodmis.org> <20090609215339.384594898@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609215339.384594898@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 05:52:15PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Use new format for better parsing of irq events.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/events/irq.h |   38 +++++++++++++++++++-------------------
>  1 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index b0c7ede..c6c0ff1 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -7,18 +7,19 @@
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM irq
>  
> -#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
> -#define show_softirq_name(val)			\
> -	__print_symbolic(val,			\
> -			 softirq_name(HI),	\
> -			 softirq_name(TIMER),	\
> -			 softirq_name(NET_TX),	\
> -			 softirq_name(NET_RX),	\
> -			 softirq_name(BLOCK),	\
> -			 softirq_name(TASKLET),	\
> -			 softirq_name(SCHED),	\
> -			 softirq_name(HRTIMER),	\
> -			 softirq_name(RCU))
> +#define softirq_name(sirq) sirq##_SOFTIRQ, #sirq
> +#define show_softirq_name_format(val)					\
> +	"%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s>"
> +#define show_softirq_name_args()					\
> +		softirq_name(HI),					\
> +		softirq_name(TIMER),					\
> +		softirq_name(NET_TX),					\
> +		softirq_name(NET_RX),					\
> +		softirq_name(BLOCK),					\
> +		softirq_name(TASKLET),					\
> +		softirq_name(SCHED),					\
> +		softirq_name(HRTIMER),					\
> +		softirq_name(RCU)
>  
>  /**
>   * irq_handler_entry - called immediately before the irq action handler
> @@ -47,7 +48,7 @@ TRACE_EVENT(irq_handler_entry,
>  		__assign_str(name, action->name);
>  	),
>  
> -	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
> +	TP_FORMAT("irq=<int:irq> handler=<string:name>")
>  );
>  
>  /**
> @@ -77,8 +78,7 @@ TRACE_EVENT(irq_handler_exit,
>  		__entry->ret	= ret;
>  	),
>  
> -	TP_printk("irq=%d return=%s",
> -		  __entry->irq, __entry->ret ? "handled" : "unhandled")
> +	TP_FORMAT("irq=<int:irq> return=<if:ret:handled:unhandled>")
>  );
>  
>  /**
> @@ -106,8 +106,8 @@ TRACE_EVENT(softirq_entry,
>  		__entry->vec = (int)(h - vec);
>  	),
>  
> -	TP_printk("softirq=%d action=%s", __entry->vec,
> -		  show_softirq_name(__entry->vec))
> +	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),


Just to zap the confusion, I would suggest to explicitly close the '>' here instead
of inside the macro. The current state suggests a kind of imbalance at a first glance.


> +		  show_softirq_name_args())
>  );
>  
>  /**
> @@ -135,8 +135,8 @@ TRACE_EVENT(softirq_exit,
>  		__entry->vec = (int)(h - vec);
>  	),
>  
> -	TP_printk("softirq=%d action=%s", __entry->vec,
> -		  show_softirq_name(__entry->vec))
> +	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),


And ditto.

Frederic.



> +		  show_softirq_name_args())
>  );
>  
>  #endif /*  _TRACE_IRQ_H */
> -- 
> 1.6.3.1
> 
> -- 

