Return-Path: <linux-kernel-owner+w=401wt.eu-S938307AbZDJN3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938307AbZDJN3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764633AbZDJN3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:29:24 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37239 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbZDJN3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HmuFF5gL8exvFO7maK6u0tm8JwcK5n7zMXFtgDJCYET8rmesUMmA/2O4Zp8has+DCP
         dauZOJt9813TaGVfWlOqyYhoA45y11fvvVhVwY7TEyK8u7YQkhHdZPIcGAVMdCOlSv/O
         tsUJjRgdELiybhGjB4aQbdDJiNQfp7lnmOoLs=
Date: Fri, 10 Apr 2009 15:29:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracepoint: Make kmem tracepoint use TRACE_EVENT
	macro
Message-ID: <20090410132916.GB5988@nowhere>
References: <49DEE68A.5040902@cn.fujitsu.com> <49DEE6DA.80600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DEE6DA.80600@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 02:27:38PM +0800, Zhaolei wrote:
> TRACE_EVENT is more unify and generic for define a tracepoint.
> It also add ftrace support for this tracepoint.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---


Nice!
It would be good to also propagate this conversion to some other tracers.
It think about power, workqueue and block tracers.

I may have some time to work on the workqueue tracer soon.

Another idea: I plan to provide an "enable" file per trace event subsystem
so that we can quickly toggle a whole batch of event tracing for
any targeted subsystem.

Ingo also suggested a quick toggle for all events. As an end result, me
would have a hierarchical level of enable files:

./events
	enable
	subsys1/
		enable
		subsys1_event1/
			enable
			....
		subsys1_event2/
		...
	subsys2/
		enable
		subsys2_event1/
		subsys2_event2/
		...
	...

I will work on it.
The root enable file will be only useful for quick regression tests anyway. We will
have some suprises.... :-)

Thanks,
Frederic.



>  include/trace/kmem.h              |   39 +-------
>  include/trace/kmem_event_types.h  |  193 +++++++++++++++++++++++++++++++++++++
>  include/trace/trace_event_types.h |    1 +
>  include/trace/trace_events.h      |    1 +
>  4 files changed, 197 insertions(+), 37 deletions(-)
>  create mode 100644 include/trace/kmem_event_types.h
> 
> diff --git a/include/trace/kmem.h b/include/trace/kmem.h
> index 24d2519..46efc24 100644
> --- a/include/trace/kmem.h
> +++ b/include/trace/kmem.h
> @@ -1,44 +1,9 @@
>  #ifndef _TRACE_KMEM_H
>  #define _TRACE_KMEM_H
>  
> -#include <linux/tracepoint.h>
>  #include <linux/types.h>
> +#include <linux/tracepoint.h>
>  
> -DECLARE_TRACE(kmalloc,
> -	      TP_PROTO(unsigned long call_site,
> -		      const void *ptr,
> -		      size_t bytes_req,
> -		      size_t bytes_alloc,
> -		      gfp_t gfp_flags),
> -	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
> -DECLARE_TRACE(kmem_cache_alloc,
> -	      TP_PROTO(unsigned long call_site,
> -		      const void *ptr,
> -		      size_t bytes_req,
> -		      size_t bytes_alloc,
> -		      gfp_t gfp_flags),
> -	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
> -DECLARE_TRACE(kmalloc_node,
> -	      TP_PROTO(unsigned long call_site,
> -		      const void *ptr,
> -		      size_t bytes_req,
> -		      size_t bytes_alloc,
> -		      gfp_t gfp_flags,
> -		      int node),
> -	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
> -DECLARE_TRACE(kmem_cache_alloc_node,
> -	      TP_PROTO(unsigned long call_site,
> -		      const void *ptr,
> -		      size_t bytes_req,
> -		      size_t bytes_alloc,
> -		      gfp_t gfp_flags,
> -		      int node),
> -	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
> -DECLARE_TRACE(kfree,
> -	      TP_PROTO(unsigned long call_site, const void *ptr),
> -	      TP_ARGS(call_site, ptr));
> -DECLARE_TRACE(kmem_cache_free,
> -	      TP_PROTO(unsigned long call_site, const void *ptr),
> -	      TP_ARGS(call_site, ptr));
> +#include <trace/kmem_event_types.h>
>  
>  #endif /* _TRACE_KMEM_H */
> diff --git a/include/trace/kmem_event_types.h b/include/trace/kmem_event_types.h
> new file mode 100644
> index 0000000..4ff420f
> --- /dev/null
> +++ b/include/trace/kmem_event_types.h
> @@ -0,0 +1,193 @@
> +
> +/* use <trace/kmem.h> instead */
> +#ifndef TRACE_EVENT
> +# error Do not include this file directly.
> +# error Unless you know what you are doing.
> +#endif
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM kmem
> +
> +TRACE_EVENT(kmalloc,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags)
> +);
> +
> +TRACE_EVENT(kmem_cache_alloc,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags)
> +);
> +
> +TRACE_EVENT(kmalloc_node,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags,
> +		 int node),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +		__field(	int,		node		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +		__entry->node		= node;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags,
> +		__entry->node)
> +);
> +
> +TRACE_EVENT(kmem_cache_alloc_node,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags,
> +		 int node),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +		__field(	int,		node		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +		__entry->node		= node;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags,
> +		__entry->node)
> +);
> +
> +TRACE_EVENT(kfree,
> +
> +	TP_PROTO(unsigned long call_site, const void *ptr),
> +
> +	TP_ARGS(call_site, ptr),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
> +);
> +
> +TRACE_EVENT(kmem_cache_free,
> +
> +	TP_PROTO(unsigned long call_site, const void *ptr),
> +
> +	TP_ARGS(call_site, ptr),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
> +);
> +
> +#undef TRACE_SYSTEM
> diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
> index 33b6bfc..552a50e 100644
> --- a/include/trace/trace_event_types.h
> +++ b/include/trace/trace_event_types.h
> @@ -4,3 +4,4 @@
>  #include <trace/irq_event_types.h>
>  #include <trace/lockdep_event_types.h>
>  #include <trace/skb_event_types.h>
> +#include <trace/kmem_event_types.h>
> diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
> index 0e2aa80..13d6b85 100644
> --- a/include/trace/trace_events.h
> +++ b/include/trace/trace_events.h
> @@ -4,3 +4,4 @@
>  #include <trace/irq.h>
>  #include <trace/lockdep.h>
>  #include <trace/skb.h>
> +#include <trace/kmem.h>
> -- 
> 1.5.5.3
> 
> 

