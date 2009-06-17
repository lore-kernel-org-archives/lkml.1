Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbZFQFMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbZFQFMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 01:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZFQFMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 01:12:38 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57423 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbZFQFMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 01:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m9w6mmsN39oGF0yGVtjmGByV0/uHQswVuRFnOqi7wiaeI+Y6YCGBjTbxs7ws9lbmhr
         Xi6JQME39I4TcnN2oztMGykZMLFc+rLtaR4v4vlKUuif6NmzX6neQcQn8VSE+7tcgKst
         /pwlkhcf9QeyVdx9vbzrz9YO+Met4RMzhRFEc=
Date: Wed, 17 Jun 2009 07:12:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 2/2] ksym_tracer:Handle machine stall when cat
	trace_pipe for ksym tracer
Message-ID: <20090617051235.GD7411@nowhere>
References: <20090616225257.041883212@prasadkr_t60p.in.ibm.com> <20090616230527.GC14753@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616230527.GC14753@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 04:35:27AM +0530, K.Prasad wrote:
> 'trace_pipe' does not handle a TRACE_TYPE_PARTIAL_LINE well and causes the
> machine to stall.



No, if it stalls here, it means it handles it well :)



> While a TRACE_TYPE_UNHANDLED return causes the tracer to
> output unrelated data, a TRACE_TYPE_HANDLED return presents a clean output
> (minus all partial traces).
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_ksym.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> @@ -389,6 +389,12 @@ static enum print_line_t ksym_trace_outp
>  
>  	trace_assign_type(field, entry);
>  
> +	/*
> +	 * Return early without any output if we don't have sufficient
> +	 * information
> +	 */
> +	if ((!field->ksym_hbp->info.type) || (!field->ip))
> +		return TRACE_TYPE_HANDLED;



Yeah that seems a good fix. But such silent ignored traces may
hide bugs (current or futures).
Is it a common situation to have a zero ip or an undefined
breakpoint type? How can that happen?

Thanks.



>  	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
>  				entry->pid, iter->cpu, field->ksym_name);
>  	if (!ret) {
> 

