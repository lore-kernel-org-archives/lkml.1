Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZEOVXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZEOVXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZEOVXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:23:36 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42147 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZEOVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ReCMh/qN93QQNU+/KV/tD4fjWfsyMshmDTYvRZoTFY9oSbv18zIT3rbWy+n6MRwolx
         NrJWMBLuvx8Ps+NmoXZoF/TFplyrlcZr7XL+HCy65jGpxXIkNE06TqyhRH7FtzxOgUKs
         K6StFxZTDL/ZGTP8dwsKUy33FC1GhnzpMXYyw=
Date: Fri, 15 May 2009 23:23:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] tracing: add flag output for kmem events
Message-ID: <20090515212328.GA6156@nowhere>
References: <20090515210342.488025506@goodmis.org> <20090515210718.211132919@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515210718.211132919@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 05:03:45PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch changes the output for gfp_flags from being a simple hex value
> to the actual names.
> 
>   gfp_flags=GFP_ATOMIC  instead of gfp_flags=00000020
> 
> And even
> 
>   gfp_flags=GFP_KERNEL instead of gfp_flags=000000d0
> 
> [ Impact: more human readable output from tracer ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Nice!


> ---
>  include/trace/events/kmem.h |   43 +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> index c22c42f..9b3886b 100644
> --- a/include/trace/events/kmem.h
> +++ b/include/trace/events/kmem.h
> @@ -7,6 +7,33 @@
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM kmem
>  
> +#define show_gfp_flags(flags)						\
> +	(flags) ? __print_flags(flags, "|",				\
> +	(unsigned long)GFP_KERNEL,		"GFP_KERNEL",		\
> +	(unsigned long)GFP_NOFS,		"GFP_NOFS",		\
> +	(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY",	\
> +	(unsigned long)GFP_USER,		"GFP_USER",		\


Because you clear the mask value after finding out a matching mask
string, you should sort the masks from the highest number of bits
to the lowest.

GFP_USER should be placed before GFP_KERNEL otherwise it will always be
eaten.
Instead of GFP_USER, you will get:

GFP_KERNEL | __GFP_HARDWALL


> +	(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER",		\


Ditto, it should be placed before GFP_USER otherwise you will get:

GFP_USER | __GFP_HIGHMEM


> +	(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE",	\

And this one before HIGH_USER otherwise:

GFP_HIGHUSER__GFP_MOVABLE


:-)


Frederic.

> +	(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC",		\
> +	(unsigned long)GFP_NOIO,		"GFP_NOIO",		\
> +	(unsigned long)__GFP_HIGH,		"GFP_HIGH",		\
> +	(unsigned long)__GFP_WAIT,		"GFP_WAIT",		\
> +	(unsigned long)__GFP_IO,		"GFP_IO",		\
> +	(unsigned long)__GFP_COLD,		"GFP_COLD",		\
> +	(unsigned long)__GFP_NOWARN,		"GFP_NOWARN",		\
> +	(unsigned long)__GFP_REPEAT,		"GFP_REPEAT",		\
> +	(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL",		\
> +	(unsigned long)__GFP_NORETRY,		"GFP_NORETRY",		\
> +	(unsigned long)__GFP_COMP,		"GFP_COMP",		\
> +	(unsigned long)__GFP_ZERO,		"GFP_ZERO",		\
> +	(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC",	\
> +	(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL",		\
> +	(unsigned long)__GFP_THISNODE,		"GFP_THISNODE",		\
> +	(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE",	\
> +	(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"		\
> +	) : "GFP_NOWAIT"
> +
>  TRACE_EVENT(kmalloc,
>  
>  	TP_PROTO(unsigned long call_site,
> @@ -33,12 +60,12 @@ TRACE_EVENT(kmalloc,
>  		__entry->gfp_flags	= gfp_flags;
>  	),
>  
> -	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
>  		__entry->call_site,
>  		__entry->ptr,
>  		__entry->bytes_req,
>  		__entry->bytes_alloc,
> -		__entry->gfp_flags)
> +		show_gfp_flags(__entry->gfp_flags))
>  );
>  
>  TRACE_EVENT(kmem_cache_alloc,
> @@ -67,12 +94,12 @@ TRACE_EVENT(kmem_cache_alloc,
>  		__entry->gfp_flags	= gfp_flags;
>  	),
>  
> -	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
>  		__entry->call_site,
>  		__entry->ptr,
>  		__entry->bytes_req,
>  		__entry->bytes_alloc,
> -		__entry->gfp_flags)
> +		show_gfp_flags(__entry->gfp_flags))
>  );
>  
>  TRACE_EVENT(kmalloc_node,
> @@ -104,12 +131,12 @@ TRACE_EVENT(kmalloc_node,
>  		__entry->node		= node;
>  	),
>  
> -	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
>  		__entry->call_site,
>  		__entry->ptr,
>  		__entry->bytes_req,
>  		__entry->bytes_alloc,
> -		__entry->gfp_flags,
> +		show_gfp_flags(__entry->gfp_flags),
>  		__entry->node)
>  );
>  
> @@ -142,12 +169,12 @@ TRACE_EVENT(kmem_cache_alloc_node,
>  		__entry->node		= node;
>  	),
>  
> -	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
>  		__entry->call_site,
>  		__entry->ptr,
>  		__entry->bytes_req,
>  		__entry->bytes_alloc,
> -		__entry->gfp_flags,
> +		show_gfp_flags(__entry->gfp_flags),
>  		__entry->node)
>  );
>  
> -- 
> 1.6.2.4
> 
> -- 

