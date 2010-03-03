Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0CCVJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:09:00 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:53984 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0CCVIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LYlHWmQUX/eeAjhvf+MoVreduESacyditjpT0XHzCyBr6NPtBp0BZ4pgP1buwV5wYg
         6wmIW6ise3t/orPEOijOxBClN0CDbdW8SR37u8EYmak1oDrGvzncjGSRrwz6w1mnCRA6
         qQlx+0z7RVrs1oIprPyD+nKYcLqzDmsPah2/I=
Date: Wed, 3 Mar 2010 22:08:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com
Subject: Re: [RFC][PATCH 09/11] perf, x86: Implement
	PERF_SAMPLE_BRANCH_STACK
Message-ID: <20100303210846.GD5194@nowhere>
References: <20100303163936.906011640@chello.nl> <20100303164306.526626387@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303164306.526626387@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 05:39:45PM +0100, Peter Zijlstra wrote:
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_event.c           |   14 +++-------
>  arch/x86/kernel/cpu/perf_event_intel.c     |   10 ++++++-
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  |   16 ++++--------
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   20 ++++++++-------
>  include/linux/perf_event.h                 |   27 +++++++++++++++++---
>  kernel/perf_event.c                        |   38 ++++++++++++++++++++++-------
>  6 files changed, 83 insertions(+), 42 deletions(-)
> 
> Index: linux-2.6/include/linux/perf_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -126,8 +126,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
>  	PERF_SAMPLE_RAW				= 1U << 10,
>  	PERF_SAMPLE_REGS			= 1U << 11,
> +	PERF_SAMPLE_BRANCH_STACK		= 1U << 12,
>  
> -	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
>  };
>  
>  /*
> @@ -395,9 +396,14 @@ enum perf_event_type {
>  	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
>  	 * 	{ struct pt_regs	regs;	  } && PERF_SAMPLE_REGS
>  	 *
> -	 *	{ u64			nr,
> +	 *	{ u64			nr;
>  	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
>  	 *
> +	 * 	{ u64			nr;
> +	 * 	  { u64 from, to, flags;
> +	 * 	  }			lbr[nr];  } && PERF_SAMPLE_BRANCH_STACK
> +	 *
> +	 *
>  	 *	#
>  	 *	# The RAW record below is opaque data wrt the ABI
>  	 *	#
> @@ -469,6 +475,17 @@ struct perf_raw_record {
>  	void				*data;
>  };
>  
> +struct perf_branch_entry {
> +	__u64				from;
> +	__u64				to;
> +	__u64				flags;
> +};
> +
> +struct perf_branch_stack {
> +	__u64				nr;
> +	struct perf_branch_entry	entries[0];
> +};
> +
>  struct task_struct;
>  
>  /**
> @@ -803,13 +820,15 @@ struct perf_sample_data {
>  	struct perf_callchain_entry	*callchain;
>  	struct perf_raw_record		*raw;
>  	struct pt_regs			*regs;
> +	struct perf_branch_stack	*branches;
>  };
>  
>  static inline
>  void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
>  {
> -	data->addr = addr;
> -	data->raw  = NULL;
> +	data->addr     = addr;
> +	data->raw      = NULL;
> +	data->branches = NULL;
>  }
>  
>  extern void perf_output_sample(struct perf_output_handle *handle,
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -3189,12 +3189,9 @@ void perf_output_sample(struct perf_outp
>  
>  	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
>  		if (data->callchain) {
> -			int size = 1;
> +			int size = sizeof(u64);
>  
> -			if (data->callchain)
> -				size += data->callchain->nr;
> -
> -			size *= sizeof(u64);
> +			size += data->callchain->nr * sizeof(u64);
>  
>  			perf_output_copy(handle, data->callchain, size);
>  		} else {
> @@ -3203,6 +3200,20 @@ void perf_output_sample(struct perf_outp
>  		}
>  	}
>  
> +	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
> +		if (data->branches) {
> +			int size = sizeof(u64);
> +
> +			size += data->branches->nr *
> +				sizeof(struct perf_branch_entry);
> +
> +			perf_output_copy(handle, data->branches, size);
> +		} else {
> +			u64 nr = 0;
> +			perf_output_put(handle, nr);
> +		}
> +	}
> +
>  	if (sample_type & PERF_SAMPLE_RAW) {
>  		if (data->raw) {
>  			perf_output_put(handle, data->raw->size);
> @@ -3291,14 +3302,25 @@ void perf_prepare_sample(struct perf_eve
>  	}
>  
>  	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
> -		int size = 1;
> +		int size = sizeof(u64);
>  
>  		data->callchain = perf_callchain(regs);
>  
>  		if (data->callchain)
> -			size += data->callchain->nr;
> +			size += data->callchain->nr * sizeof(u64);
> +
> +		header->size += size;
> +	}
>  
> -		header->size += size * sizeof(u64);
> +	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
> +		int size = sizeof(u64);
> +
> +		if (data->branches) {
> +			size += data->branches->nr *
> +				sizeof(struct perf_branch_entry);
> +		}
> +
> +		header->size += size;
>  	}



That looks good to me, (at least the generic part, as I don't
know enough the x86 part to tell).

