Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbZFQFGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbZFQFGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 01:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932783AbZFQFGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 01:06:09 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46957 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbZFQFGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 01:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DLKmSzCCbaRwe4Pj1lvKVth40pBO/Lagpkmszi5V+hq3FnbyIU+22jlNjlhxcbsaAb
         L0SLvMe6EtQk9QdqxI3ocTGImcZkQEeXrPtDAInRvnR4nBFwbqSij7EMzwrKiY0Z+wSP
         cdNkAqb2tZfi45y4UB1UUomOyZ8ty8UQAjrq4=
Date: Wed, 17 Jun 2009 07:06:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/2] ksym_tracer:Fix line-wrapping after removal of
	ksym tracer entry
Message-ID: <20090617050605.GC7411@nowhere>
References: <20090616225257.041883212@prasadkr_t60p.in.ibm.com> <20090616230504.GB14753@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616230504.GB14753@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 04:35:04AM +0530, K.Prasad wrote:
> Removal of a ksym entry results in missing information and an early return with
> TRACE_TYPE_PARTIAL_LINE code (minus the line return). This patch modifies the
> output function to unconditionally add a line return irrespective of the
> return code. 
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_ksym.c |   27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> @@ -391,29 +391,32 @@ static enum print_line_t ksym_trace_outp
>  
>  	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
>  				entry->pid, iter->cpu, field->ksym_name);
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	if (!ret) {
> +		ret = TRACE_TYPE_PARTIAL_LINE;
> +		goto err_ret;
> +	}
>  
> +	ret = TRACE_TYPE_PARTIAL_LINE;
>  	switch (field->ksym_hbp->info.type) {
>  	case HW_BREAKPOINT_WRITE:
> -		ret = trace_seq_printf(s, " W  ");
> +		if (!trace_seq_printf(s, " W  "))
> +			goto err_ret;
>  		break;
>  	case HW_BREAKPOINT_RW:
> -		ret = trace_seq_printf(s, " RW ");
> +		if (!trace_seq_printf(s, " RW  "))
> +			goto err_ret;
>  		break;
>  	default:
> -		return TRACE_TYPE_PARTIAL_LINE;
> +		goto err_ret;
>  	}
>  
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> -
>  	sprint_symbol(str, field->ip);
>  	ret = trace_seq_printf(s, "%-20s\n", str);
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> -
> -	return TRACE_TYPE_HANDLED;
> +	if (ret)
> +		return TRACE_TYPE_HANDLED;
> +err_ret:
> +	trace_seq_printf(s, "\n");
> +	return ret;


As told in my email just before, TRACE_TYPE_PARTIAL_LINE
won't print a truncated line or a partial line. Instead, it
will be ignored and entirely retried later.
Then your newline will be ignored.

..unless we have a bug in trace.c

I'm not sure what it the origin of the concatenated printed entries
Ingo has reported.

Did you reproduce it and then this patch fixed it?



>  }
>  
>  struct tracer ksym_tracer __read_mostly =
> 

