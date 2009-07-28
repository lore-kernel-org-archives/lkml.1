Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZG1Pe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZG1Pe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZG1Pe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:34:58 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:64723 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZG1Pe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OIfwVZVrGa1p0+e7reqADf4IYSXIg0C+M6MnVlpGlojOOdOvkyWGc+dbNVrpfHIi1G
         2jzh70hz/A0oEiZDL3oHG0SHdzVqHLmiOStRfhx0xw3h5Gu40zuAhfdGxLJBrbntd3Vz
         zZwQS3RRwKETdkRoCb9D4gA9aEN1ri6tUjbCw=
Date: Tue, 28 Jul 2009 17:34:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix missing function_graph events when we
	splice_read from trace_pipe
Message-ID: <20090728153454.GB6215@nowhere>
References: <4A6EEC52.90704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6EEC52.90704@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 08:17:22PM +0800, Lai Jiangshan wrote:
> 
> About a half events are missing when we splice_read
> from trace_pipe. They are consumed unexpected.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---


Also queued for .31
Thanks!


> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e30e6b1..41996fc 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3085,7 +3085,8 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
>  			break;
>  		}
>  
> -		trace_consume(iter);
> +		if (ret != TRACE_TYPE_NO_CONSUME)
> +			trace_consume(iter);
>  		rem -= count;
>  		if (!find_next_entry_inc(iter))	{
>  			rem = 0;
> @@ -4230,8 +4231,11 @@ static void __ftrace_dump(bool disable_tracing)
>  		iter.pos = -1;
>  
>  		if (find_next_entry_inc(&iter) != NULL) {
> -			print_trace_line(&iter);
> -			trace_consume(&iter);
> +			int ret;
> +
> +			ret = print_trace_line(&iter);
> +			if (ret != TRACE_TYPE_NO_CONSUME)
> +				trace_consume(&iter);
>  		}
>  
>  		trace_printk_seq(&iter.seq);
> 
> 

