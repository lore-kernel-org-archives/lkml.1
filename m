Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995Ab0ATR7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0ATR7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077Ab0ATR7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:59:14 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60754 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab0ATR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:59:11 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 12:59:11 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pzIv5qwXo3WiZvWnBgKwJGs4Iql2w0BgVTD71JsEZ50oXWzZHx45dBlCDJG3q8CLMN
         t2bggwphmtve2ryRCcSKjzmMoecfyvYuOkA6CAENU0bSTeSOiWPP+VZAePt11Dh2f16x
         SwZyL8GP+Edcv25TJhzUS8EcLOvLVteIjakeI=
Date: Wed, 20 Jan 2010 18:52:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] : bug fix, remove partial zero out
Message-ID: <20100120175205.GA5017@nowhere>
References: <4B556064.7080700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B556064.7080700@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:33:56PM +0800, Lai Jiangshan wrote:
> partial-zero-out a struct is very dangerous, we should zero out
> field by field directly when need.
> 
> partial-zero-out for struct trace_iterator exists when ftrace
> was first introduced into mainline kernel. But in this few years,
> the code of ftrace is changed a lot, and:
> 
> 1) partial-zero-out for struct trace_iterator has a bug now,
>    cpumask_var_t started should not be zeroed out.
> 
> 2) I viewed the codes and found that fields below
>    "/* The below is zeroed out in pipe_read */"
>    don't need to be zeroed out or initialized now.
> 
> So, we remove the code of "partial zero out"
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 3ca9485..c6d0e1a 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -54,7 +54,6 @@ struct trace_iterator {
>  	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
>  	unsigned long		iter_flags;
>  
> -	/* The below is zeroed out in pipe_read */
>  	struct trace_seq	seq;
>  	struct trace_entry	*ent;
>  	int			leftover;
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5314c90..27fecf8 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3124,12 +3124,6 @@ waitagain:
>  	if (cnt >= PAGE_SIZE)
>  		cnt = PAGE_SIZE - 1;
>  
> -	/* reset all but tr, trace, and overruns */
> -	memset(&iter->seq, 0,
> -	       sizeof(struct trace_iterator) -
> -	       offsetof(struct trace_iterator, seq));
> -	iter->pos = -1;
> -



I'm not sure exaclty why we needed to zero the seq here.
We already reset it in trace_seq_init().

We might do it again on waitagain. I lost track how we could
ever need to goto waitagain. It was about a tricky bug to fix
but I'm don't remember exactly the details.

That said, if trace_seq_to_user returns -EBUSY, we
re-init the seq buffer, so it should be fine I guess.

But concerning the need of setting iter->pos to -1, I'm not
sure we need to remove it. Shouldn't it be set to 0 btw?

Steve?

