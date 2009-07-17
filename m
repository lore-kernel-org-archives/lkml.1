Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbZGQEFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbZGQEFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 00:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZGQEFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 00:05:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:40296 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZGQEFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 00:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vuLSJcxp1/bHd/OtJrENtvGpXColrJzmm9iw+SLERZmVw7TgdsunBjepapEr14U9kY
         O5Yf3S0oE1QybnbP8JsODQbtTbkQQNYwrPcdRwJjlllW8GFuyzEKRgpdF4T7JRHdi41i
         Y751t3JCfZ2e9fcc6sZih5w4BhdHDmr/xpvFo=
Date: Fri, 17 Jul 2009 00:05:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function: simplify for
	__ftrace_replace_code()
Message-ID: <20090717040528.GB4977@nowhere>
References: <4A5D5B12.2050802@cn.fujitsu.com> <4A5D5BCF.4070707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5D5BCF.4070707@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:32:15PM +0800, Xiao Guangrong wrote:
> Rewrite the __ftrace_replace_code() function, let it's simple, but
> not change the code's logic.
> 
> First, we get the state we want to set, if the record has the same
> state, then do nothing, if not, enable/disable it.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c |   75 +++++++++++++-----------------------------------
>  1 files changed, 21 insertions(+), 54 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 4521c77..18aeb8d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1016,71 +1016,38 @@ static int
>  __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
>  {
>  	unsigned long ftrace_addr;
> -	unsigned long ip, fl;
> +	unsigned long flag = 0UL;
>  
>  	ftrace_addr = (unsigned long)FTRACE_ADDR;
>  
> -	ip = rec->ip;
> -
>  	/*
> -	 * If this record is not to be traced and
> -	 * it is not enabled then do nothing.
> +	 * If this record is not to be traced or we want to disable it,
> +	 * then disable it.
>  	 *
> -	 * If this record is not to be traced and
> -	 * it is enabled then disable it.
> +	 * If we want to enable it and filtering is off, then enable it.
>  	 *
> +	 * If we want to enable it and filtering is on, enable it only if
> +	 * it's filtered
>  	 */
> -	if (rec->flags & FTRACE_FL_NOTRACE) {
> -		if (rec->flags & FTRACE_FL_ENABLED)
> -			rec->flags &= ~FTRACE_FL_ENABLED;
> -		else
> -			return 0;
> -
> -	} else if (ftrace_filtered && enable) {
> -		/*
> -		 * Filtering is on:
> -		 */
> -
> -		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_ENABLED);
> -
> -		/* Record is filtered and enabled, do nothing */
> -		if (fl == (FTRACE_FL_FILTER | FTRACE_FL_ENABLED))
> -			return 0;
> -
> -		/* Record is not filtered or enabled, do nothing */
> -		if (!fl)
> -			return 0;
> -
> -		/* Record is not filtered but enabled, disable it */
> -		if (fl == FTRACE_FL_ENABLED)
> -			rec->flags &= ~FTRACE_FL_ENABLED;
> -		else
> -		/* Otherwise record is filtered but not enabled, enable it */
> -			rec->flags |= FTRACE_FL_ENABLED;
> -	} else {
> -		/* Disable or not filtered */
> -
> -		if (enable) {
> -			/* if record is enabled, do nothing */
> -			if (rec->flags & FTRACE_FL_ENABLED)
> -				return 0;
> -
> -			rec->flags |= FTRACE_FL_ENABLED;
> -
> -		} else {
> +	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
> +		if (ftrace_filtered) {
> +			if (rec->flags & FTRACE_FL_FILTER)
> +				flag = FTRACE_FL_ENABLED;
> +		} else
> +			flag = FTRACE_FL_ENABLED;


The above can be factorized in

if (!ftrace_filtered || rec->flags & FTRACE_FL_FILTER)
	flag = FTRACE_FL_ENABLED



> +	}
>  
> -			/* if record is not enabled, do nothing */
> -			if (!(rec->flags & FTRACE_FL_ENABLED))
> -				return 0;
> +	/* If not change this record's state, then do nothing */
> +	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
> +		return 0;
>  
> -			rec->flags &= ~FTRACE_FL_ENABLED;
> -		}
> +	if (flag) {
> +		rec->flags |= FTRACE_FL_ENABLED;
> +		return ftrace_make_call(rec, ftrace_addr);
>  	}
>  
> -	if (rec->flags & FTRACE_FL_ENABLED)
> -		return ftrace_make_call(rec, ftrace_addr);
> -	else
> -		return ftrace_make_nop(NULL, rec, ftrace_addr);
> +	rec->flags &= ~FTRACE_FL_ENABLED;
> +	return ftrace_make_nop(NULL, rec, ftrace_addr);
>  }
>  
>  static void ftrace_replace_code(int enable)
> -- 
> 1.6.1.2
> 
> 


Nice simplification.
I'm queuing it for .32 (I will just change with my comment above).

Thanks!

