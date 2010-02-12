Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab0BLQTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:19:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48872 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0BLQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:19:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=he6NB3zS91kA:10 a=W6fNSXVXEzn_cn_DNbQA:9 a=rlGTnkk32pC9KNL_t7fJxyKYF-MA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 08/11] readahead: add tracing event
From: Steven Rostedt <rostedt@goodmis.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100202153317.365099890@intel.com>
References: <20100202152835.683907822@intel.com>
	 <20100202153317.365099890@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Feb 2010 11:19:05 -0500
Message-ID: <1265991545.24271.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 23:28 +0800, Wu Fengguang wrote:
> plain text document attachment (readahead-tracer.patch)
> Example output:

> +	TP_printk("readahead-%s(dev=%d:%d, ino=%lu, "
> +		  "req=%lu+%lu, ra=%lu+%d-%d, async=%d) = %d",
> +			ra_pattern_names[__entry->pattern],

The above totally breaks any parsing by tools. We have already have a
way to map values to strings with __print_symbolic():

		__print_symbolic(__entry->pattern,
			{ RA_PATTERN_INITIAL, "initial" },
			{ RA_PATTERN_SUBSEQUENT, "subsequent"},
			{ RA_PATTERN_CONTEXT, "context"},
			{ RA_PATTERN_THRASH, "thrash"},
			{ RA_PATTERN_MMAP_AROUND, "around"},
			{ RA_PATTERN_FADVISE, "fadvise" },
			{ RA_PATTERN_RANDOM, "random"},
			{ RA_PATTERN_ALL, "all" }),

see include/trace/irq.h for another example.

-- Steve

> +			MAJOR(__entry->dev),
> +			MINOR(__entry->dev),
> +			__entry->ino,
> +			__entry->offset,
> +			__entry->req_size,
> +			__entry->start,
> +			__entry->size,
> +			__entry->async_size,
> +			__entry->start > __entry->offset,
> +			__entry->actual)
> +);
> +
> +#endif /* _TRACE_READAHEAD_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --- linux.orig/mm/readahead.c	2010-02-01 21:55:43.000000000 +0800
> +++ linux/mm/readahead.c	2010-02-01 21:57:25.000000000 +0800
> @@ -19,11 +19,25 @@
>  #include <linux/pagevec.h>
>  #include <linux/pagemap.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/readahead.h>
> +
>  /*
>   * Set async size to 1/# of the thrashing threshold.
>   */
>  #define READAHEAD_ASYNC_RATIO	8
>  
> +const char * const ra_pattern_names[] = {
> +	[RA_PATTERN_INITIAL]		= "initial",
> +	[RA_PATTERN_SUBSEQUENT]		= "subsequent",
> +	[RA_PATTERN_CONTEXT]		= "context",
> +	[RA_PATTERN_THRASH]		= "thrash",
> +	[RA_PATTERN_MMAP_AROUND]	= "around",
> +	[RA_PATTERN_FADVISE]		= "fadvise",
> +	[RA_PATTERN_RANDOM]		= "random",
> +	[RA_PATTERN_ALL]		= "all",
> +};
> +


