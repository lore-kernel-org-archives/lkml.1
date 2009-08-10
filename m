Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZHJJsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZHJJsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZHJJsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:48:19 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:37278 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbZHJJsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ub5zis2pLHTJh+3qRwY/qAO/vrUxWE9ZYoyHWINimidCEezw9MVUOrDCsASAkiKJ6B
         GHlJmWI7iGj9fqpEXSxptUGyFk+HWbvrp/kX6xAZ6yV4v5Q3sGSNZ2b9Zv+oppPBAN63
         Z88uj16BY/dbKX2LfZNE+3ymlGrRajsOAmXss=
Date: Mon, 10 Aug 2009 11:48:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/3] perf_counter: Correct PERF_SAMPLE_RAW output
Message-ID: <20090810094815.GB5508@nowhere>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com> <1249698400-5441-2-git-send-email-fweisbec@gmail.com> <1249896447.17467.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249896447.17467.74.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 11:27:27AM +0200, Peter Zijlstra wrote:
> Subject: perf_counter: Correct PERF_SAMPLE_RAW output
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Aug 10 11:16:52 CEST 2009
> 
> PERF_SAMPLE_* output switches should unconditionally output the
> correct format, as they are the only way to unambiguously parse the
> PERF_EVENT_SAMPLE data.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


I economized this part because I thought ftrace events could
be parsed the same way we parse binary events through debugfs.
The size of an ftrace event can be deduced from its format.

But I must confess that would require a pre-parsing of dynamic
strings.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  include/linux/perf_counter.h |    2 ++
>  include/trace/ftrace.h       |    3 ++-
>  kernel/perf_counter.c        |   30 ++++++++++++++++++++++++------
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/include/linux/perf_counter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -369,6 +369,8 @@ enum perf_event_type {
>  	 *
>  	 *	{ u64			nr,
>  	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
> +	 *	{ u32			size;
> +	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
>  	 * };
>  	 */
>  	PERF_EVENT_SAMPLE		= 9,
> Index: linux-2.6/include/trace/ftrace.h
> ===================================================================
> --- linux-2.6.orig/include/trace/ftrace.h
> +++ linux-2.6/include/trace/ftrace.h
> @@ -687,7 +687,8 @@ static void ftrace_profile_##call(proto)
>  	pc = preempt_count();						\
>  									\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> -	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
> +	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
> +			     sizeof(u64));				\
>  									\
>  	do {								\
>  		char raw_data[__entry_size];				\
> Index: linux-2.6/kernel/perf_counter.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_counter.c
> +++ linux-2.6/kernel/perf_counter.c
> @@ -2647,7 +2647,6 @@ void perf_counter_output(struct perf_cou
>  		u64 counter;
>  	} group_entry;
>  	struct perf_callchain_entry *callchain = NULL;
> -	struct perf_raw_record *raw = NULL;
>  	int callchain_size = 0;
>  	u64 time;
>  	struct {
> @@ -2717,9 +2716,15 @@ void perf_counter_output(struct perf_cou
>  	}
>  
>  	if (sample_type & PERF_SAMPLE_RAW) {
> -		raw = data->raw;
> -		if (raw)
> -			header.size += raw->size;
> +		int size = sizeof(u32);
> +
> +		if (data->raw)
> +			size += data->raw->size;
> +		else
> +			size += sizeof(u32);
> +
> +		WARN_ON_ONCE(size & (sizeof(u64)-1));
> +		header.size += size;
>  	}
>  
>  	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
> @@ -2785,8 +2790,21 @@ void perf_counter_output(struct perf_cou
>  		}
>  	}
>  
> -	if ((sample_type & PERF_SAMPLE_RAW) && raw)
> -		perf_output_copy(&handle, raw->data, raw->size);
> +	if (sample_type & PERF_SAMPLE_RAW) {
> +		if (data->raw) {
> +			perf_output_put(&handle, data->raw->size);
> +			perf_output_copy(&handle, data->raw->data, data->raw->size);
> +		} else {
> +			struct {
> +				u32	size;
> +				u32	data;
> +			} raw = {
> +				.size = sizeof(u32),
> +				.data = 0,
> +			};
> +			perf_output_put(&handle, raw);
> +		}
> +	}
>  
>  	perf_output_end(&handle);
>  }
> 

